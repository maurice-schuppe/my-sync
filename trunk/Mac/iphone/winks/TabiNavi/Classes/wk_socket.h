/*
 *  wk_socket.h
 *  TabiNavi
 *
 *  Created by wang luke on 7/6/09.
 *  Copyright 2009 luke. All rights reserved.
 *
 */
#include "wk_public.h"
#include "wk_osfnc.h"

/*************************************************
 Socket接口
 **************************************************/

typedef struct tag_Winks_Socketmsg_s
	{
		unsigned long wParam;
		unsigned long lParam;
	}Winks_Socketmsg_s;

typedef struct tag_Winks_hostent 
	{
		char* h_name;           /* official name of host */
		char** h_aliases;          /* alias list */
		short h_addrtype;       /* host address type */
		short h_length;         /* length of address */
		char** h_addr_list;     /* list of addresses */
#define h_addr h_addr_list[0]   /* address, for backward compat */
	}Winks_hostent;

struct winks_sockaddr
{ 
    unsigned short sa_family; 
    char sa_data[14]; 
}; 

struct winks_in_addr
{
    unsigned int wk_addr;
};

struct winks_sockaddr_in
{ 
    unsigned short sin_family; 
    unsigned short int sin_port; 
    struct winks_in_addr sin_addr; 
    unsigned char sin_zero[8]; 
};


int Winks_getlasterror( void );


//socket抽象层初始化函数。
int Winks_SoStartup( void );
//socket抽象层关闭函数
int Winks_SoCleanup( void );

//socket传输句柄创建函数
int Winks_socket( int family ,int type ,int protocol );

//socket传输句柄消息设置函数
int Winks_asyncselect( int socket, int opcode, WINKS_CHN_ID channel, int msg );

//socket连接函数
int Winks_connect(int socket, struct winks_sockaddr* serv_addr, int addrlen );

//socket数据发送函数
int Winks_send( int socket, void *buf, int len, int flags );

//socket数据接收函数
int Winks_recv( int socket, void *buf, int len, int flags );

//socket句柄关闭函数
int Winks_closesocket( int socket );

//异步域名查询函数
int Winks_AsyncGetHostByName( char* name, char* pHost, int hostlen, WINKS_CHN_ID channel, int msg );

//异步域名查询放弃函数
int Winks_CancelGetHostByName( int handle );

//本地字节序转换为网络字节序
unsigned short Winks_htons( unsigned short port );