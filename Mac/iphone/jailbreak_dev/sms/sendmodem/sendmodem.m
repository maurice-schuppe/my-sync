#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <time.h>
#import <Foundation/Foundation.h>

NSString *CTSettingCopyMyPhoneNumber();
NSString *CTSIMSupportCopyMobileSubscriberIdentity(void* tmp);


#define BUFSIZE (65536+100)
unsigned char readbuf[BUFSIZE];

static struct termios term;
static struct termios gOriginalTTYAttrs;
int InitConn(int speed);

void SendCmd(int fd, void *buf, size_t size)
{

  if(write(fd, buf, size) == -1) {
    fprintf(stderr, "SendCmd error. %s\n", strerror(errno));
    exit(1);
  }
}

void SendStrCmd(int fd, char *buf)
{
  fprintf(stderr,"Sending command to modem: %s\n",buf);
  SendCmd(fd, buf, strlen(buf));
}

int ReadResp(int fd)
{
  int len = 0;
  struct timeval timeout;
  int nfds = fd + 1;
  fd_set readfds;
  int select_ret;

  FD_ZERO(&readfds);
  FD_SET(fd, &readfds);

  // Wait a second
  timeout.tv_sec = 1;
  timeout.tv_usec = 500000;

  fprintf(stderr,"-");
  while (select_ret = select(nfds, &readfds, NULL, NULL, &timeout) > 0)
  {
    fprintf(stderr,".");
    len += read(fd, readbuf + len, BUFSIZE - len);
    FD_ZERO(&readfds);
    FD_SET(fd, &readfds);
    timeout.tv_sec = 0;
    timeout.tv_usec = 500000;
  }
  if (len > 0) {
    fprintf(stderr,"+\n");
  }
  readbuf[len] = 0;
  fprintf(stderr,"%s",readbuf);
  return len;
}

int InitConn(int speed)
{
  int fd = open("/dev/tty.debug", O_RDWR | O_NOCTTY);

  if(fd == -1) {
    fprintf(stderr, "%i(%s)\n", errno, strerror(errno));
    exit(1);
  }

  ioctl(fd, TIOCEXCL);
  fcntl(fd, F_SETFL, 0);

  tcgetattr(fd, &term);
  gOriginalTTYAttrs = term;

  cfmakeraw(&term);
  cfsetspeed(&term, speed);
  term.c_cflag = CS8 | CLOCAL | CREAD;
  term.c_iflag = 0;
  term.c_oflag = 0;
  term.c_lflag = 0;
  term.c_cc[VMIN] = 0;
  term.c_cc[VTIME] = 0;
  tcsetattr(fd, TCSANOW, &term);

  return fd;
}
void CloseConn(int fd)
{
    tcdrain(fd);
    tcsetattr(fd, TCSANOW, &gOriginalTTYAttrs);
    close(fd);
}

void SendAT(int fd)
{
  char cmd[5];

  //  SendStrCmd(fd, "AT\r");
  sprintf(cmd,"AT\r");
  SendCmd(fd, cmd, strlen(cmd));
}

void AT(int fd)
{
  fprintf(stderr, "Sending command to modem: AT\n");
  SendAT(fd);
  for (;;) {
    if(ReadResp(fd) != 0) {
      if(strstr((const char *)readbuf,"OK") != NULL)
      {
	break;
      }
    }
    SendAT(fd);
  }
}

int main(int argc, char **argv)
{
//AT+CIMI  get the imsi
//AT+CNUM  get the number,but you must write the number to sim card first
//AT+CCID 获得SIM卡的标
	NSString *phone_number = CTSettingCopyMyPhoneNumber();
	NSLog(phone_number);
	fprintf(stderr,"+\n");
	
	NSString *phone_imsi = CTSIMSupportCopyMobileSubscriberIdentity(nil);
	NSLog(phone_imsi);
	fprintf(stderr,"+\n");
		
		
  int fd;
  char cmd[1024]; 
  if(argc < 2)
  {
	fprintf(stderr,"usage: %s <at command>\n",argv[0]);
	fprintf(stderr,"examples:\t%s \"AT+XSIMSTATE=1\"\n",argv[0]);
	fprintf(stderr,"\t\t%s \"AT+XGENDATA\"\n",argv[0]);
	fprintf(stderr,"\t\t%s \"AT+CLCK=\\\"SC\\\",2\"\n",argv[0]);
	exit(1); 
  }
  fd = InitConn(115200);

  AT(fd);
  sprintf(cmd,"%s\r",argv[1]);
  SendStrCmd(fd,cmd);
  ReadResp(fd);
  CloseConn(fd);
  return 0;
}

