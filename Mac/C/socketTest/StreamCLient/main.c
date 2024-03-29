/*
 ** a stream socket client demo
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#define PORT "9034" // the port client will be connecting to 

#define MAXDATASIZE 1024 // max number of bytes we can get at once 

// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa)
{
	if (sa->sa_family == AF_INET) {
		return &(((struct sockaddr_in*)sa)->sin_addr);
	}
	
	return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

int main(int argc, char *argv[])
{
	int clientsockfd, numrecv, numsent;
	char buf[MAXDATASIZE];
	struct addrinfo hints, *servinfo, *p;
	int rv;
	char s[INET6_ADDRSTRLEN];
	
	// if (argc != 2) {
	// 	    fprintf(stderr,"usage: client hostname\n");
	// 	    exit(1);
	// 	}
	char *host = "127.0.0.1";
	
	
	memset(&hints, 0, sizeof hints);
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	
	// 取得服务器地址信息（struct addrinfo）
	if ((rv = getaddrinfo(/* argv[1] */ host, PORT, &hints, &servinfo)) != 0) {
		fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
		return 1;
	}
	// loop through all the results and connect to the first we can
	for(p = servinfo; p != NULL; p = p->ai_next) {
		if ((clientsockfd = socket(p->ai_family, p->ai_socktype,
							 p->ai_protocol)) == -1) {
			perror("client: socket"); // 创建socket描述符失败
			continue;
		}
		
		// 使用addrinfo连接(实际上就是将sockfd连接到sockaddr_in)
		if (connect(clientsockfd, p->ai_addr, p->ai_addrlen) == -1) {
			close(clientsockfd);
			perror("client: connect"); // connect失败
			continue;
		}

		break;
	}
	
	if (p == NULL) {
		fprintf(stderr, "client: failed to connect\n");
		return 2;
	}
	
	inet_ntop(p->ai_family, get_in_addr((struct sockaddr *)p->ai_addr),
			  s, sizeof s);
	printf("client: connecting to %s\n", s);
	
	freeaddrinfo(servinfo); // all done with this structure
	
	if ((numrecv = recv(clientsockfd, buf, MAXDATASIZE-1, 0)) == -1) {
	    perror("recv");
	    exit(1);
	}
	buf[numrecv] = '\0';
	printf("client: received: %s\n", buf);
	
	char sendbuf[MAXDATASIZE] = "lalalalala";
	sendbuf[strlen(sendbuf)] = '\0';
	if((numsent = send(clientsockfd, "lalalalala", 10, 0)) == -1){
		perror("send");
		exit(1);
	}
	char end[1] = {'\0'}; 
	send(clientsockfd, end, 1, 0);
	printf("client: sent: %s\n", sendbuf);
	
	if ((numrecv = recv(clientsockfd, buf, MAXDATASIZE-1, 0)) == -1) {
	    perror("recv");
	    exit(1);
	}
	buf[numrecv] = '\0';
	printf("client: received: %s\n", buf);
	//close(sockfd);
	
	return 0;
}

