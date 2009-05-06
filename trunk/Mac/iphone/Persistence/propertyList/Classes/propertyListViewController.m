//
//  propertyListViewController.m
//  propertyList
//
//  Created by wang luke on 4/30/09.
//  Copyright luke 2009. All rights reserved.
//

#include <stdio.h>
#import "propertyListViewController.h"

@implementation propertyListViewController

@synthesize field1;
@synthesize field2;
@synthesize field3;
@synthesize field4;
@synthesize written;
@synthesize saveButton;
@synthesize copyButton;

#pragma mark -
#pragma mark propertyListViewController_方法实现

// 返回Documents路径
- (NSString *)appDocumentsDir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//documentsDirectory = [[NSString alloc] initWithCString:getenv("HOME")];
	//return [documentsDirectory autorelease];
	return documentsDirectory;
}

// 返回保存文件的完整路径
- (NSString *)dataFilePath
{
	//@"/var/root/"
	//NSString *documentsDirectory = [[NSString alloc] initWithCString:getenv("HOME")];
	NSString *fullpath = [[self appDocumentsDir] stringByAppendingPathComponent:kFilename];
	NSLog(@"fullpath -----> %@", fullpath);
	return fullpath;
}

- (void)setTip:(NSString *)isSuccess
{
//	NSString *tip = [[NSString alloc] initWithFormat:@"write to %@ : %@",[self dataFilePath]];
	NSString *tip = [[NSString alloc] initWithFormat:@"write to %@ : %@",[self dataFilePath], isSuccess];
	[written setText:tip];
	[tip release];
}

- (IBAction)save:(id)sender
{
	[self applicationWillTerminate:nil];
}

#pragma mark -
#pragma mark 通知方法。（此处非UIApplicationDelegate方法）
// 是一种通知方法。所有通知方法都使用一个NSNotification实例作为参数。通知是发生了某些事件的指示。
// 被传递的发布通知的对象在其文档中包含一个通知列表（如UIApplication类文档中有一个notification列表）。
// 退出时调用
- (void)applicationWillTerminate:(NSNotification *)notification
{
	NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	
	// TODO: 检查field中text是否为空的情况
	[dataArray addObject:field1.text];
	[dataArray addObject:field2.text];
	[dataArray addObject:field3.text];
	[dataArray addObject:field4.text];
	
	BOOL isSuccess = NO;
	if([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]){
		// 将“序列化对象“序列化到属性列表文件
		isSuccess = [dataArray writeToFile:[self dataFilePath] atomically:YES];
	}else{
		NSLog(@"file is not exists");
	}
	if(isSuccess)
		[self setTip:@"Success"];
	else
		[self setTip:@"Fail"];
	
	[dataArray release];
}

#pragma mark -
#pragma mark 测试
- (IBAction)copy:(id)sender
{
	//NSData *reader = [NSData dataWithContentsOfFile:[self dataFilePath]];
//	//NSString *dir = [[NSString alloc] initWithCString:getenv("HOME")];
//	NSString *dest = [[self appDocumentsDir] stringByAppendingPathComponent:@"test.txt"];
//	
//	NSLog(@"dest -----> %@", dest);
//	if(![[NSFileManager defaultManager] fileExistsAtPath:dest])
//		[[NSFileManager defaultManager] createFileAtPath:dest contents:nil attributes:nil];
//	
//	[reader writeToFile:dest atomically:YES];
//	
//	////////////////写一个较大的文件
//	NSMutableData *data1, *data2;
//	NSString *firstString  = @"ABCD";
//	NSString *secondString = @"EFGH";
//	const char *utfFirstString = [firstString UTF8String];
//	const char *utfSecondString = [secondString UTF8String];
//	unsigned char *aBuffer;
//	unsigned len;
//	
//	data1 = [NSMutableData dataWithBytes:utfFirstString length:strlen(utfFirstString)];
//	data2 = [NSMutableData dataWithBytes:utfSecondString length:strlen(utfSecondString)];
//	
//	len = [data2 length];
//	aBuffer = malloc(len);
//	
//	[data2 getBytes:aBuffer];
//	for (int i = 0; i < 999999; i++) {
//		[data1 appendBytes:aBuffer length:len];
//	}
//	
//	[data1 writeToFile:dest atomically:YES];
	
	///////////// c
	const char *aBuffer;
	NSString *secondString = @"EFGH";
	const char *utfSecondString = [secondString UTF8String];
	NSMutableData *data2 = [NSMutableData dataWithBytes:utfSecondString length:strlen(utfSecondString)];
	//unsigned len = [data2 length];
//	aBuffer = malloc(len);
	
	const char *path = [[self dataFilePath] UTF8String];
	const char *destPath = [[[self appDocumentsDir] stringByAppendingPathComponent:@"ttt.txt"] UTF8String];
	FILE *fp = fopen(path, "rb");
	unsigned fileLen = 0;
	if(fp){
		fseek(fp, 0L, SEEK_END);
		fileLen = ftell(fp);
		printf("%ld", fileLen);
	}
	
	aBuffer = malloc(fileLen);
	FILE *fpdest = fopen(destPath, "wb");
	fread(aBuffer, 1, fileLen, fp);
	fwrite(aBuffer, 1, fileLen, fpdest);
	
	fclose(fp);
	fclose(fpdest);
}

- (void)write
{
	
}

#pragma mark -
#pragma mark UIViewControllerDelegate方法
// Sent to the view controller when the application receives a memory warning.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

// Invoked when the view is finished loading.
- (void)viewDidLoad
{
	NSString *filepath = [self dataFilePath];

	if([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:filepath];
		// FIXME: 应处理属性列表文件为空的情况
		field1.text = [array objectAtIndex:0];
		field2.text = [array objectAtIndex:1];
		field3.text = [array objectAtIndex:2];
		field4.text = [array objectAtIndex:3];
		[array release];
	}else {
		[[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
	}

	
	// Returns the singleton application instance
	UIApplication *app = [UIApplication sharedApplication];
	// !!!: 订阅UIApplicationWillTerminateNotification通知。self是需要被通知的对象。selector为收到通知后要调用的方法。name为我们感兴趣的通知名称。app为The object whose notifications the observer wants to receive（发出通知的对象）
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:app];
	
	/////////////test
	//NSString *home = [[NSString alloc] initWithCString:getenv("HOME")];
//	NSString *file = @"test.txt";
//	NSString *dest = [home stringByAppendingPathComponent:file];
//	NSLog(@"path-----> %@", dest);
//	[self copy:filepath dest:dest];
	/////////////test~
	
	[super viewDidLoad];
}

// Returns a Boolean value indicating whether the view controller autorotates its view.
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
	// return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark 释放资源
- (void)dealloc {
	// !!!: 应释放所有资源
	[field1 release];
	[field2 release];
	[field3 release];
	[field4 release];
    [super dealloc];
}

@end
