/*
File: TCPConnection.m
Abstract: Convenience class that acts as a controller for TCP based network connections.

Version: 1.3
*/

#import <unistd.h>
#import <netinet/in.h>
#ifndef __CODEX__
#if !TARGET_OS_IPHONE
#import <netinet6/in6.h>
#endif
#endif

#import "TCPConnection.h"
#import "NetUtilities.h"
#import "Networking_Internal.h"

//CONSTANTS:

#define kMagic						0x1234ABCD
#define kOpenedMax					3

//STRUCTURE:

typedef struct {
	NSUInteger		magic;
	NSUInteger		length;
} Header; //NOTE: This header is in big-endian

//CLASS INTERFACES:

@interface TCPConnection (Internal)
- (id) _initWithRunLoop:(CFRunLoopRef)runLoop readStream:(CFReadStreamRef)input writeStream:(CFWriteStreamRef)output;
- (void) _handleStreamEvent:(CFStreamEventType)type forStream:(CFTypeRef)stream;
@end

//FUNCTIONS:

static void _ReadClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void* clientCallBackInfo)
{
	NSAutoreleasePool*		localPool = [NSAutoreleasePool new];
	
	[(TCPConnection*)clientCallBackInfo _handleStreamEvent:type forStream:stream];
	
	[localPool release];
}

static void _WriteClientCallBack(CFWriteStreamRef stream, CFStreamEventType type, void* clientCallBackInfo)
{
	NSAutoreleasePool*		localPool = [NSAutoreleasePool new];
	
	[(TCPConnection*)clientCallBackInfo _handleStreamEvent:type forStream:stream];
	
	[localPool release];
}

//CLASS IMPLEMENTATION:

@implementation TCPConnection

@synthesize delegate=_delegate, CFRunLoop=_runLoop;

- (id) initWithSocketHandle:(int)socket
{
	CFReadStreamRef			readStream = NULL;
	CFWriteStreamRef		writeStream = NULL;
	
	CFStreamCreatePairWithSocket(kCFAllocatorDefault, socket, &readStream, &writeStream);
	if(!readStream || !writeStream) {
		close(socket);
		if(readStream)
		CFRelease(readStream);
		if(writeStream)
		CFRelease(writeStream);
		[self release];
		return nil;
	}
	
	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	self = [self _initWithRunLoop:CFRunLoopGetCurrent() readStream:readStream writeStream:writeStream];
	CFRelease(readStream);
	CFRelease(writeStream);
	
	return self;
}

- (id) initWithRemoteAddress:(const struct sockaddr*)address
{
	CFReadStreamRef			readStream = NULL;
	CFWriteStreamRef		writeStream = NULL;
	CFSocketSignature		signature;
	CFDataRef				data;
	
	data = (address ? CFDataCreate(kCFAllocatorDefault, (const UInt8*)address, address->sa_len) : NULL);
	if(data == NULL) {
		[self release];
		return nil;
	}
	
	signature.protocolFamily = PF_INET;
	signature.socketType = SOCK_STREAM;
	signature.protocol = IPPROTO_TCP;
	signature.address = data;
	CFStreamCreatePairWithPeerSocketSignature(kCFAllocatorDefault, &signature, &readStream, &writeStream);
	CFRelease(data);
	if(!readStream || !writeStream) {
		if(readStream)
		CFRelease(readStream);
		if(writeStream)
		CFRelease(writeStream);
		[self release];
		return nil;
	}
	
	self = [self _initWithRunLoop:CFRunLoopGetCurrent() readStream:readStream writeStream:writeStream];
	CFRelease(readStream);
	CFRelease(writeStream);
	
	return self;
}

- (id) initWithRemoteIPv4Address:(UInt32)address port:(UInt16)port
{
	struct sockaddr_in		ipAddress;
	
	bzero(&ipAddress, sizeof(ipAddress));
	ipAddress.sin_len = sizeof(ipAddress);
	ipAddress.sin_family = AF_INET;
	ipAddress.sin_port = htons(port);
	ipAddress.sin_addr.s_addr = htonl(address);
	
	return [self initWithRemoteAddress:(struct sockaddr*)&ipAddress];
}

#ifndef __CODEX__
#if !TARGET_OS_IPHONE

- (id) initWithRemoteIPv6Address:(const struct in6_addr*)address port:(UInt16)port
{
	struct sockaddr_in6		ipAddress;
	
	bzero(&ipAddress, sizeof(ipAddress));
	ipAddress.sin6_len = sizeof(ipAddress);
	ipAddress.sin6_family = AF_INET6;
	ipAddress.sin6_port = htons(port);
	bcopy(address, &ipAddress.sin6_addr, sizeof(struct in6_addr));
	
	return [self initWithRemoteAddress:(struct sockaddr*)&ipAddress];
}

#endif
#endif

- (id) initWithRemoteHostName:(NSString*)name port:(UInt16)port
{
	CFReadStreamRef			readStream = NULL;
	CFWriteStreamRef		writeStream = NULL;
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)name, port, &readStream, &writeStream);
	if(!readStream || !writeStream) {
		if(readStream)
		CFRelease(readStream);
		if(writeStream)
		CFRelease(writeStream);
		[self release];
		return nil;
	}
	
	self = [self _initWithRunLoop:CFRunLoopGetCurrent() readStream:readStream writeStream:writeStream];
	CFRelease(readStream);
	CFRelease(writeStream);
	
	return self;
}

- (id) initWithCFNetService:(CFNetServiceRef)service timeOut:(NSTimeInterval)timeOut
{
	CFReadStreamRef			readStream = NULL;
	CFWriteStreamRef		writeStream = NULL;
	
	if(!service || ((timeOut >= 0.0) && !CFNetServiceGetAddressing(service) && !CFNetServiceResolveWithTimeout(service, timeOut, NULL))) {
		[self release];
		return nil;
	}
	
	CFStreamCreatePairWithSocketToNetService(kCFAllocatorDefault, service, &readStream, &writeStream);
	if(!readStream || !writeStream) {
		if(readStream)
		CFRelease(readStream);
		if(writeStream)
		CFRelease(writeStream);
		[self release];
		return nil;
	}
	
	self = [self _initWithRunLoop:CFRunLoopGetCurrent() readStream:readStream writeStream:writeStream];
	CFRelease(readStream);
	CFRelease(writeStream);
	
	return self;
}

- (id) initWithServiceDomain:(NSString*)domain type:(NSString*)type name:(NSString*)name timeOut:(NSTimeInterval)timeOut
{
	CFNetServiceRef			service;
	
	service = CFNetServiceCreate(kCFAllocatorDefault, (CFStringRef)domain, (CFStringRef)_MakeServiceType(type, @"tcp"), (CFStringRef)name, 0);
	if(service == NULL) {
		[self release];
		return nil;
	}
	
	self = [self initWithCFNetService:service timeOut:timeOut];
	
	CFRelease(service);
	
	return self;
}

- (id) _initWithRunLoop:(CFRunLoopRef)runLoop readStream:(CFReadStreamRef)input writeStream:(CFWriteStreamRef)output
{
	CFStreamClientContext	context = {0, self, NULL, NULL, NULL};
	
	if((self = [super init])) {
		_inputStream = (CFReadStreamRef)CFRetain(input);
		_outputStream = (CFWriteStreamRef)CFRetain(output);
		_runLoop = (CFRunLoopRef)CFRetain(runLoop);
		
		CFReadStreamSetClient(_inputStream, kCFStreamEventOpenCompleted | kCFStreamEventHasBytesAvailable | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered, _ReadClientCallBack, &context);
		CFReadStreamScheduleWithRunLoop(_inputStream, _runLoop, kCFRunLoopCommonModes);
		CFWriteStreamSetClient(_outputStream, kCFStreamEventOpenCompleted | kCFStreamEventCanAcceptBytes | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered, _WriteClientCallBack, &context);
		CFWriteStreamScheduleWithRunLoop(_outputStream, _runLoop, kCFRunLoopCommonModes);
		
		if(!CFReadStreamOpen(_inputStream) || !CFWriteStreamOpen(_outputStream)) {
			[self release];
			return nil;
		}
	}
	
	return self;
}

- (void) dealloc
{	
	[self invalidate];
	
	if(_localAddress)
	free(_localAddress);
	if(_remoteAddress)
	free(_remoteAddress);
	
	[super dealloc];
}

- (void) setDelegate:(id<TCPConnectionDelegate>)delegate
{
	_delegate = delegate;
	
	SET_DELEGATE_METHOD_BIT(0, connectionDidFailOpening:);
	SET_DELEGATE_METHOD_BIT(1, connectionDidOpen:);
	SET_DELEGATE_METHOD_BIT(2, connectionDidClose:);
	SET_DELEGATE_METHOD_BIT(3, connection:didReceiveData:);
}

- (BOOL) isValid
{
	return ((_opened >= kOpenedMax) && !_invalidating ? YES : NO);
}

- (void) _invalidate
{
	if(_inputStream) {
		CFReadStreamSetClient(_inputStream, kCFStreamEventNone, NULL, NULL);
		CFReadStreamClose(_inputStream);
		CFRelease(_inputStream);
		_inputStream = NULL;
	}
	
	if(_outputStream) {
		CFWriteStreamSetClient(_outputStream, kCFStreamEventNone, NULL, NULL);
		CFWriteStreamClose(_outputStream);
		CFRelease(_outputStream);
		_outputStream = NULL;
	}
	
	if(_runLoop) {
		CFRelease(_runLoop);
		_runLoop = NULL;
	}
	
	if(_opened >= kOpenedMax) {
		if(TEST_DELEGATE_METHOD_BIT(2))
		[_delegate connectionDidClose:self];
		_opened = 0;
	}
	else if(TEST_DELEGATE_METHOD_BIT(0))
	[_delegate connectionDidFailOpening:self];
}

- (void) invalidate
{
	if(_invalidating == NO) {
		_invalidating = YES;
		
		[self _invalidate];
	}
}

- (BOOL) _writeData:(NSData*)data
{
	CFIndex					length = [data length],
							result;
	Header					header;
	
	header.magic = NSSwapHostIntToBig(kMagic);
	header.length = NSSwapHostIntToBig(length);
	result = CFWriteStreamWrite(_outputStream, (const UInt8*)&header, sizeof(Header));
	if(result != sizeof(Header)) {
		REPORT_ERROR(@"Wrote only %i bytes out of %i bytes in header", (int)result, (int)sizeof(Header));
		return NO;
	}
	
	while(length > 0) {
		result = CFWriteStreamWrite(_outputStream, (UInt8*)[data bytes] + [data length] - length, length);
		if(result <= 0) {
			REPORT_ERROR(@"Wrote only %i bytes out of %i (%i) bytes in data", (int)result, (int)length, [data length]);
			return NO;
		}
		length -= result;
	}
	
	return YES;
}

- (NSData*) _readData
{
	NSMutableData*			data;
	CFIndex					result,
							length;
	Header					header;
	
	result = CFReadStreamRead(_inputStream, (UInt8*)&header, sizeof(Header));
	if(result == 0)
	return (id)kCFNull;
	if(result != sizeof(Header)) {
		REPORT_ERROR(@"Read only %i bytes out of %i bytes in header", (int)result, (int)sizeof(Header));
		return nil;
	}
	if(NSSwapBigIntToHost(header.magic) != kMagic) {
		REPORT_ERROR(@"Invalid header", NULL);
		return nil;
	}
	
	length = NSSwapBigIntToHost(header.length);
	data = [NSMutableData dataWithCapacity:length];
	[data setLength:length];
	
	while(length > 0) {
		result = CFReadStreamRead(_inputStream, (UInt8*)[data mutableBytes] + [data length] - length, length);
		if(result <= 0) {
			REPORT_ERROR(@"Read only %i bytes out of %i (%i) bytes in data", (int)result, (int)length, [data length]);
			return nil;
		}
		length -= result;
	}
	
	return data;
}

- (void) _initializeConnection:(CFTypeRef)stream
{
	int						value = 1;
	CFDataRef				data;
	CFSocketNativeHandle	socket;
	socklen_t				length;
	
	if((data = (CFGetTypeID(stream) == CFWriteStreamGetTypeID() ? CFWriteStreamCopyProperty((CFWriteStreamRef)stream, kCFStreamPropertySocketNativeHandle) : CFReadStreamCopyProperty((CFReadStreamRef)stream, kCFStreamPropertySocketNativeHandle)))) {
		CFDataGetBytes(data, CFRangeMake(0, sizeof(CFSocketNativeHandle)), (UInt8*)&socket);
		value = 1;
		setsockopt(socket, SOL_SOCKET, SO_KEEPALIVE, &value, sizeof(value));
		value = sizeof(Header);
		setsockopt(socket, SOL_SOCKET, SO_SNDLOWAT, &value, sizeof(value));
		setsockopt(socket, SOL_SOCKET, SO_SNDLOWAT, &value, sizeof(value));
		CFRelease(data);
		
		length = SOCK_MAXADDRLEN;
		_localAddress = malloc(length);
		if(getsockname(socket, _localAddress, &length) < 0) {
			free(_localAddress);
			_localAddress = NULL;
			REPORT_ERROR(@"Unable to retrieve local address (%i)", errno);
		}
		length = SOCK_MAXADDRLEN;
		_remoteAddress = malloc(length);
		if(getpeername(socket, _remoteAddress, &length) < 0) {
			free(_remoteAddress);
			_remoteAddress = NULL;
			REPORT_ERROR(@"Unable to retrieve remote address (%i)", errno);
		}
		
		if(TEST_DELEGATE_METHOD_BIT(1))
		[_delegate connectionDidOpen:self]; //NOTE: Connection may have been invalidated after this call!
	}
	else
	[NSException raise:NSInternalInconsistencyException format:@"Unable to retrieve socket from CF stream"];
}

/* Behavior notes regarding socket based CF streams:
- The connection is really ready once both input & output streams are opened and the output stream is writable
- The connection can receive a "has bytes available" notification before it's ready as defined above, in which case it should be ignored as there seems to be no bytes available to read anyway
*/
- (void) _handleStreamEvent:(CFStreamEventType)type forStream:(CFTypeRef)stream
{
	NSData*				data;
	CFStreamError		error;
	
#ifndef __CODEX__
#if __DEBUG__
	NSLog(@"[%p] %@ (%i) = %i", self, stream, (CFGetTypeID(stream) == CFReadStreamGetTypeID() ? CFReadStreamGetStatus((CFReadStreamRef)stream) : CFWriteStreamGetStatus((CFWriteStreamRef)stream)), type);
#endif
#endif
	
	switch(type) {
		
		case kCFStreamEventOpenCompleted:
		if(_opened < kOpenedMax) {
			_opened += 1;
			if(_opened == kOpenedMax)
			[self _initializeConnection:stream];
		}
		break;
		
		case kCFStreamEventHasBytesAvailable: //NOTE: kCFStreamEventHasBytesAvailable will be sent for 0 bytes available to read when stream reaches end
		if(_opened >= kOpenedMax) {
			do {
				data = [self _readData];
				if(data != (id)kCFNull) {
					if(data == nil) {
						[self invalidate]; //NOTE: "self" might have been already de-alloced after this call!
						return;
					}
					else {
						if((_invalidating == NO) && TEST_DELEGATE_METHOD_BIT(3))
						[_delegate connection:(id)self didReceiveData:data]; //NOTE: Avoid type conflict with NSURLConnection delegate
					}
				}
			} while(!_invalidating && CFReadStreamHasBytesAvailable(_inputStream));
		}
		break;
		
		case kCFStreamEventCanAcceptBytes:
		if(_opened < kOpenedMax) {
			_opened += 1;
			if(_opened == kOpenedMax)
			[self _initializeConnection:stream];
		}
		break;
		
		case kCFStreamEventErrorOccurred:
		error = (CFGetTypeID(stream) == CFWriteStreamGetTypeID() ? CFWriteStreamGetError((CFWriteStreamRef)stream) : CFReadStreamGetError((CFReadStreamRef)stream));
		REPORT_ERROR(@"Error (%i) occured in CF stream", (int)error.error);
		case kCFStreamEventEndEncountered:
		[self invalidate];
		break;
				
	}
}

- (BOOL) hasDataAvailable
{
	if(![self isValid])
	return NO;
	
	return CFReadStreamHasBytesAvailable(_inputStream);
}

- (NSData*) receiveData
{
	NSData*				data;
	
	if(![self isValid])
	return nil;
	
	data = [self _readData];
	if(data == nil)
	[self invalidate];
	else if(data == (id)kCFNull)
	data = nil;
	
	return data;
}

- (BOOL) sendData:(NSData*)data
{
	if(![self isValid] || !data)
	return NO;
	
	if(![self _writeData:data]) {
		[self invalidate];
		return NO;
	}
	
	return YES;
}

- (UInt16) localPort
{
	if(_localAddress)
	switch(_localAddress->sa_family) {
		case AF_INET: return ntohs(((struct sockaddr_in*)_localAddress)->sin_port);
		case AF_INET6: return ntohs(((struct sockaddr_in6*)_localAddress)->sin6_port);
	}
	
	return 0;
}

- (UInt32) localIPv4Address
{
	return (_localAddress && (_localAddress->sa_family == AF_INET) ? ntohl(((struct sockaddr_in*)_localAddress)->sin_addr.s_addr) : 0);
}

- (NSString*) localAddress
{
	return (_localAddress ? IPAddressToString(_localAddress, NO, NO) : nil);
}

- (UInt16) remotePort
{
	if(_remoteAddress)
	switch(_remoteAddress->sa_family) {
		case AF_INET: return ntohs(((struct sockaddr_in*)_remoteAddress)->sin_port);
#ifndef __CODEX__
#if !TARGET_OS_IPHONE
		case AF_INET6: return ntohs(((struct sockaddr_in6*)_remoteAddress)->sin6_port);
#endif
#endif
	}
	
	return 0;
}

- (UInt32) remoteIPv4Address
{
	return (_remoteAddress && (_remoteAddress->sa_family == AF_INET) ? ntohl(((struct sockaddr_in*)_remoteAddress)->sin_addr.s_addr) : 0);
}

- (NSString*) remoteAddress
{
	return (_remoteAddress ? IPAddressToString(_remoteAddress, NO, NO) : nil);
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08X | valid = %i | local address = %@ | remote address = %@>", [self class], (long)self, [self isValid], [self localAddress], [self remoteAddress]];
}

- (const struct sockaddr*) remoteSocketAddress
{
	return _remoteAddress;
}

@end
