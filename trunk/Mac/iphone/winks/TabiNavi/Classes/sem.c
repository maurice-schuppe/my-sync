/*
 *  sem.c
 *  semmm
 *
 *  Created by wang luke on 7/13/09.
 *  Copyright 2009 luke. All rights reserved.
 *
 *	id = sem_create(key, initval);
 *	id = sem_open(key);
 *	sem_wait(id);
 *	sem_signal(id);
 *	sem_close(id);
 *	sem_rm(id);
 *	
 * [0]: ʵ��ʹ�õ��ź�����
 * [1]: ʹ���ߣ�����/�̣߳�������
 * [2]: lock sem_create() �� sem_close()
 */

#include <sys/ipc.h>
#include <sys/sem.h>
#include <errno.h>

void sem_op(int, int);
int sem_create(key_t, int);
int sem_open(key_t);
void sem_rm(int);
void sem_close(int);
void sem_wait(int);
void sem_signal(int);

#define	BIGCOUNT 10000		/* initial value of process counter */

/*
 * Define the semaphore operation arrays for the semop() calls.
 */

static struct sembuf op_lock[2] = {
2, 0, 0,	/* wait for [2] (lock) to equal 0 */
2, 1, SEM_UNDO	/* then increment [2] to 1 - this locks it */
/* UNDO to release the lock if processes exits
 before explicitly unlocking */
};

static struct sembuf op_endcreate[2] = {
1, -1, SEM_UNDO,/* decrement [1] (proc counter) with undo on exit */
/* UNDO to adjust proc counter if process exits
 before explicitly calling sem_close() */
2, -1, SEM_UNDO	/* then decrement [2] (lock) back to 0 */
};

static struct sembuf op_open[1] = {
1, -1, SEM_UNDO	/* decrement [1] (proc counter) with undo on exit */
};

static struct sembuf op_close[3] = {
2, 0, 0,	/* wait for [2] (lock) to equal 0 */
2, 1, SEM_UNDO,	/* then increment [2] to 1 - this locks it */
1, 1, SEM_UNDO	/* then increment [1] (proc counter) */
};

static struct sembuf op_unlock[1] = {
2, -1, SEM_UNDO	/* decrement [2] (lock) back to 0 */
};

static struct sembuf op_op[1] = {
0, 99, SEM_UNDO	/* decrement or increment [0] with undo on exit */
/* the 99 is set to the actual amount to add
 or subtract (positive or negative) */
};


/****************************************************************************
 * ָ����ʼֵ����һ���ź���������Ѵ����򲻻�ȥ��ʼ������open��
 * �ɹ������ź���ID, ����-1.
 */
int sem_create(key_t key, int initval)
{
	register int		id, semval;
	union semun {
		int		val;
		struct semid_ds	*buf;
		ushort		*array;
	} semctl_arg;
	
	if (key == IPC_PRIVATE)
		return(-1);	/* not intended for private semaphores */
	
	else if (key == (key_t) -1)
		return(-1);	/* probably an ftok() error by caller */
	
again:
	if ((id = semget(key, 3, 0666 | IPC_CREAT)) < 0)
		return(-1);	/* permission problem or tables full */
	
	/*
	 * When the semaphore is created, we know that the value of all
	 * 3 members is 0.
	 * Get a lock on the semaphore by waiting for [2] to equal 0,
	 * then increment it.
	 *
	 * There is a race condition here.  There is a possibility that
	 * between the semget() above and the semop() below, another
	 * process can call our sem_close() function which can remove
	 * the semaphore if that process is the last one using it.
	 * Therefore, we handle the error condition of an invalid
	 * semaphore ID specially below, and if it does happen, we just
	 * go back and create it again.
	 */
	
	if (semop(id, &op_lock[0], 2) < 0) {
		if (errno == EINVAL)
			goto again;
		err_sys("can't lock");
	}
	
	/*
	 * Get the value of the process counter.  If it equals 0,
	 * then no one has initialized the semaphore yet.
	 */
	
	if ((semval = semctl(id, 1, GETVAL, 0)) < 0)
		err_sys("can't GETVAL");
	
	if (semval == 0) {
		/*
		 * We could initialize by doing a SETALL, but that
		 * would clear the adjust value that we set when we
		 * locked the semaphore above.  Instead, we'll do 2
		 * system calls to initialize [0] and [1].
		 */
		
		semctl_arg.val = initval;
		if (semctl(id, 0, SETVAL, semctl_arg) < 0)
			err_sys("can SETVAL[0]");
		
		semctl_arg.val = BIGCOUNT;
		if (semctl(id, 1, SETVAL, semctl_arg) < 0)
			err_sys("can SETVAL[1]");
	}
	
	/*
	 * Decrement the process counter and then release the lock.
	 */
	
	if (semop(id, &op_endcreate[0], 2) < 0)
		err_sys("can't end create");
	
	return(id);
}

/****************************************************************************
 * ��һ���Ѵ��ڵ��ź�����
 * ��ȷ�����ź���ID, ����-1.
 */
int sem_open(key_t key)
{
	register int	id;
	
	if (key == IPC_PRIVATE)
		return(-1);	/* not intended for private semaphores */
	
	else if (key == (key_t) -1)
		return(-1);	/* probably an ftok() error by caller */
	
	if ((id = semget(key, 3, 0)) < 0)
		return(-1);	/* doesn't exist, or tables full */
	
	/*
	 * Decrement the process counter.  We don't need a lock
	 * to do this.
	 */
	
	if (semop(id, &op_open[0], 1) < 0)
		err_sys("can't open");
	
	return(id);
}

/****************************************************************************
 * ɾ���ź�����
 * �Ҳ����Ƿ��������߳�/������ʹ�ô��ź�����
 */
void sem_rm(int id)
{
	if (semctl(id, 0, IPC_RMID, 0) < 0)
		err_sys("can't IPC_RMID");
}

/****************************************************************************
 * �ر��ź���.
 * �߳���ֹʱ���ô˺�����
 * ʹ�ô��ź������߳�/��������һ������������һ��ʹ�ô��ź������߳�/������ɾ�����ź�����
 */
void sem_close(int id)
{
	register int semval;
	
	/*
	 * The following semop() first gets a lock on the semaphore,
	 * then increments [1] - the process counter.
	 */
	
	if (semop(id, &op_close[0], 3) < 0)
		err_sys("can't semop");
	
	/*
	 * Now that we have a lock, read the value of the process
	 * counter to see if this is the last reference to the
	 * semaphore.
	 * There is a race condition here - see the comments in
	 * sem_create().
	 */
	
	if ((semval = semctl(id, 1, GETVAL, 0)) < 0)
		err_sys("can't GETVAL");
	
	if (semval > BIGCOUNT)
		err_dump("sem[1] > BIGCOUNT");
	else if (semval == BIGCOUNT)
		sem_rm(id);
	else
		if (semop(id, &op_unlock[0], 1) < 0)
			err_sys("can't unlock");	/* unlock */
}

/****************************************************************************
 * waiֱ���ź�����ֵ����0, ���һ��return
 */
void sem_wait(int id)
{
	sem_op(id, -1);
}

/****************************************************************************
 * ��1
 */
void sem_signal(int id)
{
	sem_op(id, 1);
}

void sem_op(int id, int value)
{
	if ((op_op[0].sem_op = value) == 0)
		err_sys("can't have value == 0");
	
	if (semop(id, &op_op[0], 1) < 0)
		err_sys("sem_op error");
}

int main(int argc, const char* argv[]){
	int id = sem_create(0);
	sem_wait(id);
	printf("sem_wait return");
	return 0;
}