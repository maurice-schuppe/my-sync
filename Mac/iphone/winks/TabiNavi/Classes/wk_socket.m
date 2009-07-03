//
//  wk_socket.m
//  TabiNavi
//
//  Created by wang luke on 7/3/09.
//  Copyright 2009 luke. All rights reserved.
//

#import "wk_socket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

@implementation wk_socket
CFRunLoopRef _runLoop;

CFOptionFlags _SocketCallbackTypes = kCFSocketConnectCallBack
									|kCFSocketDataCallBack
									|kCFSocketReadCallBack
									|kCFSocketWriteCallBack
									|kCFSocketNoCallBack;

static void Winks_CFSocketCallback (CFSocketRef sref, CFSocketCallBackType callbackType, CFDataRef address, 
								const void *data, void *info){
	
}

//- (CFSocketRef)createSocket:(CFSocketNativeHandle)sock callback:(CFOptionFlags)callbackTypes{
//	CFSocketRef sock = CFSocketCreateWithNative(kCFAllocatorDefault, socket, callbackTypes, 
//												(CFSocketCallBack)&Winks_CFSocketCallback, NULL);
//	return sock;
//}


#pragma mark -
#pragma mark osal
/*************************************************************************************\
 函数原型：  int Winks_SoStartup( void )
 函数介绍：
 socket抽象层初始化函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 函数返回值：
 成功返回0，失败返回-1。
 实现描述：
 任何socket函数在被调用以前都需要确定本函数被调用。
 本函数初始化socket抽象层的所有资源，创建轮训查询线程，等待用户随后的调用动作。
 \*************************************************************************************/
int Winks_SoStartup( void );

/*************************************************************************************\
 函数原型：  int Winks_SoCleanup( void )
 函数介绍：
 socket抽象层关闭函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 函数返回值：
 成功返回0，失败返回-1。
 实现描述：
 本函数释放所有socket抽象层资源，关闭线程。第一期开发本函数不实现，以存根函数存在。
 \*************************************************************************************/
int Winks_SoCleanup( void );

/*************************************************************************************\
 函数原型：  int Winks_socket( int family, int type, int protocol )
 函数介绍：
 socket传输句柄创建函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 family	    int	        socket家族	
 type	    int	        socket类型	
 protocol	int	        socket协议	
 函数返回值：
 成功返回创建出来的socket句柄，失败返回-1。
 实现描述：
 本函数创建socket传输句柄，如果成功会返回创建出来的socket句柄，失败返回-1。
 一旦被调用，首先从全局资源中查找可用的socket句柄资源，如果没找到，返回失败。
 如果找到，则使用用户提供的参数调用平台socket函数，返回成功则告知用户返回成
 功，返回失败则释放申请的资源，同时返回用户失败。
 \*************************************************************************************/
int Winks_socket( int family ,int type ,int protocol ){
	// bsd socket句柄
	CFSocketNativeHandle nativeFd;
	if((nativeFd=socket(PF_INET, SOCK_STREAM, /*IPPROTO_TCP*/0))==-1){
		fprintf(stderr,"Socket Error:%s\a\n",strerror(errno));
		return -1;
	}
	CFSocketRef sock = CFSocketCreateWithNative(kCFAllocatorDefault, nativeFd, _SocketCallbackTypes, 
																   (CFSocketCallBack)&Winks_CFSocketCallback, NULL);
	if(sock == NULL){
		NSLog(@"Winks_socket: CFSocketCreateWithNative error");
	}
	return nativeFd;
}

/*************************************************************************************\
 函数原型：  int Winks_asyncselect( int socket, int opcode, void* channel, int channellen, int msg )
 函数介绍：
 socket传输句柄消息设置函数。
 参数说明：
 参数名称	参数类型	    参数介绍	备注
 socket	    int	            socket句柄	
 opcode	    unsigned long	操作码	    目前未用
 channel	    void*	        消息通道名称	
 channellen	int	            消息通道参数长度	
 msg	        int	            消息数值	
 函数返回值：
 成功返回0，失败返回-1。
 实现描述：
 本函数用来设置已经创建好的socket句柄的消息发送内容。任何socket句柄经过本函数设置
 以后默认会变成异步socket，并且设置以后，该socket的任何连接、读取、接收和关闭事件
 发生以后，用户指定的消息通道都会接收到指定的消息，其中消息数据为两个长整形数值，
 如上述结构Winks_Socketmsg_s。在该结构中，wParam指定发生事件的socket句柄数值，lParam
 高16位代表一个错误码，低16位代表发生的事件类型，事件类型定义见上述预定义常量。
 
 一旦被调用，首先检查参数有效值，错误返回失败；如果正确，记录用户设置，将该socket
 设置成非阻塞模式并返回成功。
 \*************************************************************************************/
int Winks_asyncselect( int socket, int opcode, WINKS_CHN_ID channel, int msg ){
	CFSocketRef sock = CFSocketCreateWithNative(kCFAllocatorDefault, socket, _SocketCallbackTypes, 
												(CFSocketCallBack)&Winks_CFSocketCallback, NULL);
	if(sock == NULL){
		NSLog(@"Winks_asyncselect: CFSocketCreateWithNative error");
		return -1;
	}
	CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sock, 0);
	_runLoop = (_runLoop == nil) ? CFRunLoopGetCurrent() : _runLoop;
	CFRunLoopAddSource (_runLoop, source, kCFRunLoopCommonModes);
	
	return 0;
}

/*************************************************************************************\
 函数原型：  int Winks_connect(int socket, struct winks_sockaddr* serv_addr, int addrlen )
 函数介绍：
 socket连接函数。
 参数说明：
 参数名称	参数类型	        参数介绍	备注
 socket	    int	                socket句柄	
 serv_addr	struct sockaddr*	目的地址	
 addrlen	    int	                目的地址长度	
 函数返回值：
 成功返回0，失败返回-1。
 实现描述：
 本函数用来与目的服务器进行连接。如果该socket句柄被设置成异步消息模式的话，
 本函数被调用以后，系统会进行后续的连接操作，通常情况下函数会同步返回EINPROGRESS
 错误，提醒用户等待连接结果。一旦连接成功或者失败，用户指定的消息通道里面
 会接收到连接成功或者失败的消息通知。
 一旦被调用，首先检查参数有效性，错误返回失败；如果正确，需要将本地全局socket
 资源里面的操作码设置上连接操作掩码，使用用户参数调用平台连接函数，同时按
 照情况释放全局轮训查询线程等待事件，启动轮训查询工作。向用户返回平台函数
 的返回值。
 连接函数被调用以后，轮训查询函数就需要启动查询该传输句柄的状态，而一旦连
 接成功，则该句柄的数据接收和数据发送消息都需要同时开始监视。
 \*************************************************************************************/
int Winks_connect(int socket, struct winks_sockaddr* serv_addr, int addrlen ){
	//CFSocketRef sock = [self createSocket:socket callback:_SocketCallbackTypes];
//	if(sock != NULL){
//		
//	}else{
//		NSLog(@"create CFSocket from native error");
//		return -1;
//	}
	
	if(connect(socket, (struct sockaddr*)serv_addr, addrlen) == -1){
		fprintf(stderr,"Connect Error:%s\a\n",strerror(errno));
		return -1;
	}
	return 0;
}

/*************************************************************************************\
 函数原型：int Winks_send( int socket, void *buf, int len, int flags )
 函数介绍：
 socket数据发送函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 socket	    int	        socket句柄	
 buf	        void*	    发送数据	
 len	        int	        发送数据长度	
 flags	    int	        发送标记	
 函数返回值：
 成功返回发送的数据长度，失败返回-1。
 实现描述：
 本函数用来向目的服务器发送数据。通常情况下会返回发送数据的长度，当用户
 将该句柄设置成异步消息通知模式的情况下，如果用户提供的数据过长，底层缓
 冲区无法完全保留用户数据的话，函数会返回实际发送的数据长度，极端情况下，
 当底层缓冲区无法装入数据的话，函数会返回EAGAIN错误，通知用户需要稍后发
 送。一旦底层缓冲区允许继续发送数据了，用户指定的消息通道会接收到继续发
 送的消息通知。每次发送数据要求用户需要确保数据发送完成或循环调用本函数
 直到返回EAGAIN错误，否则系统不会上发继续发送消息。如果连接已经被平稳断
 开，函数会返回0。
 一旦被调用，首先检查参数有效性，错误返回失败；如果正确，需要将本地全局
 socket资源里面的操作码删除发送操作掩码，使用用户参数调用平台发送函数。
 向用户返回平台函数的返回值。
 特别的，由于模块本身可能会发送大量的数据，因此本函数的调用有可能因为底
 层缓冲区不够而返回失败，本API要求用户必须循环调用本函数直到数据完全发送
 出去或者因EAGAIN返回失败，否则不会上发继续发送消息，此功能在本函数内部
 处理的时候需要注意。另外，鉴于Linux Socket的关闭处理特点，平台发送函数
 一旦返回0，本函数在告知用户平台返回值的同时，还需补发关闭消息通知应用连
 接已经平稳断连。
 \*************************************************************************************/
int Winks_send( int socket, void *buf, int len, int flags ){
	int sent = -1;
	if((sent = send(socket, buf, len, flags)) == -1){
		perror("Winks_send");
		return -1;
	}
	return sent;
}

/*************************************************************************************\
 函数原型：  int Winks_recv( int socket, void *buf, int len, int flags )
 函数介绍：
 socket数据发送函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 socket	    int	        socket句柄	
 buf	        void*	    接收数据缓冲区	
 len	        int	        接收数据缓冲区长度	
 flags	    int	        接收标记	
 函数返回值：
 成功返回接收到的数据长度，失败返回-1。
 实现描述：
 本函数用来从目的服务器接收数据，如果用户提供的缓冲区足够长，函数会返回
 实际接收到的数据长度，如果用户缓冲区不足以装下所有数据，函数会返回实际
 接收到的数据（一般情况下会是用户缓冲区的长度）。如果用户将该句柄设置成
 异步消息通知模式的话，一旦该句柄有数据到达，用户指定的消息通道会接收到
 数据到达的消息通知。每次调用都需要用户循环调用本函数知道返回EAGAIN错误，
 否则系统将不会再次发送数据到达消息。如果连接已经被平稳断开，函数会返回0。
 
 一旦被调用，首先检查参数有效性，错误返回失败；如果正确，需要将本地全局
 socket资源里面的操作码删除接收操作掩码，使用用户参数调用平台接收函数。
 向用户返回平台函数的返回值。
 特别的，由于调用本函数提供的缓冲区的不确定性，因此本函数的调用有可能因
 为用户缓冲区不够而返回失败，本API要求用户必须循环调用本函数直到数据完全
 接收完毕并且因EAGAIN返回失败，否则不会再次上发数据到来消息，此功能在本
 函数内部处理的时候需要注意。另外，鉴于Linux Socket的关闭处理特点，平台
 发送函数一旦返回0，本函数在告知用户平台返回值的同时，还需补发关闭消息
 通知应用连接已经平稳断连。
 \*************************************************************************************/
int Winks_recv( int socket, void *buf, int len, int flags ){
	int recved = -1;
	if((recved = recv(socket, buf, len, flags)) == -1){
		perror("Winks_recv");
		return -1;
	}
	return recved;
}

/*************************************************************************************\
 函数原型：  int Winks_closesocket( int socket )
 函数介绍：
 socket句柄关闭函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 socket	    int	        socket句柄	
 函数返回值：
 成功返回接收到的数据长度，失败返回-1。
 实现描述：
 本函数用来关闭socket句柄，本函数被调用以后，抽象层本地全局socket资源即会被释放。
 一旦被调用，首先检查参数有效性，错误返回失败；如果正确，需要将本地全局socket
 资源删除，使用用户参数调用平台关闭函数。向用户返回平台函数的返回值。
 特别的，我们不关注该socket句柄是否真的被删除了，考虑到Linux资源足够丰富，我们
 仅仅需要调用平台的关闭函数即可，下层资源的释放由系统处理。
 \*************************************************************************************/
int Winks_closesocket( int socket ){
	if(close(socket) == -1){
		perror("Winks_closesocket");
		return -1;
	}
	return 0;
}

/*************************************************************************************\
 函数原型：  int Winks_AsyncGetHostByName( char* name, char* pHost, int hostlen, void* channel, 
 int channellen, int msg )
 函数介绍：
 异步域名查询函数。
 参数说明：
 参数名称	参数类型	参数介绍	        备注
 name	    char*	    需要查询的域名	
 pHost	    char*	    域名查询结果缓冲区	本缓冲区要有足够的长度填写查询结果，
 建议长度不要低于预定义常量WINKS_SO_GHBFLEN
 hostlen	    int	        域名查询结果缓冲区长度	
 channel	    void*	    消息通道名称	
 channellen	int	        消息通道名称长度	
 msg	        int	        消息数值	
 函数返回值：
 成功返回域名查询句柄，失败返回-1。如果返回0，代表本函数同步成功返回，用户可以直
 接从提供的缓冲区里面获得域名查询结果。 
 实现描述：
 本函数用来进行异步域名查询，本函数会在资源许可的情况下返回域名查询句柄，系统会
 自动进行随后的域名查询工作，一旦域名查询工作结束，系统会将查询结构填写入用户提
 供的缓冲区并且用户指定的消息通道会接收到指定消息，其中消息数据为两个长整形数值，
 如上述结构Winks_Socketmsg_s。在该结构中，wParam指定发生事件的域名查询句柄数值，
 lParam代表一个错误码。用户在查询成功以后可以通过读取指定的缓冲区内的数据获得域
 名查询结果。
 一旦被调用，首先检查参数有效性，错误返回失败；如果正确，需要在本地全局域名查询
 资源里面申请资源，申请失败返回-1，申请成功的话，通过建立一个独立线程进行域名查
 询，无论查询成功与否，都要向用户发送消息通知查询结果。
 \*************************************************************************************/
int Winks_AsyncGetHostByName( char* name, char* pHost, int hostlen, WINKS_CHN_ID channel, int msg ){
	
}

/*************************************************************************************\
 函数原型：  int Winks_CancleGetHostByName( int handle )
 函数介绍：
 异步域名查询放弃函数。
 参数说明：
 参数名称	参数类型	参数介绍	备注
 handle	    int	        域名查询句柄	
 函数返回值：
 成功返回0，失败返回-1。
 实现描述：
 本函数用来放弃一个正在进行的域名查询请求。用户可以使用本函数放弃一个正在进行
 的域名查询．
 \*************************************************************************************/
int Winks_CancelGetHostByName( int handle ){
	
}

/*************************************************************************************\
 函数原型：  unsigned short Winks_htons( unsigned short port )
 函数介绍：
 由本地字节序转换为网络字节序.
 参数说明：
 参数名称	参数类型	参数介绍	备注
 port		u_short
 函数返回值：
 返回转换后的字节序数字.
 实现描述：
 \*************************************************************************************/
unsigned short Winks_htons( unsigned short port ){
	return htons(port);
}
@end
