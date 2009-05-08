//
//  propertyListViewController.m
//  propertyList
//
//  Created by wang luke on 4/30/09.
//  Copyright luke 2009. All rights reserved.
//

#include <stdio.h>
#import "Alert.h"
#import "propertyListViewController.h"

const double URLCacheInterval = 86400.0;
//@interface NSObject(PrivateMethods)
//
//- (void) initImageView;
//- (void) startAnimation;
//- (void) stopAnimation;
//- (void) buttonsEnabled:(BOOL)flag;
//- (void) displayImageWithURL:(NSURL *)theURL;
//- (void) displayCachedImage;
//- (void) turnOffSharedCache;
//- (void) initCache;
//- (void) clearCache;
//- (void) getFileModificationDate;
//
//@end

@implementation propertyListViewController

@synthesize field1;
@synthesize field2;
@synthesize written;
@synthesize saveButton;
@synthesize copyButton;
/////
@synthesize cacheDir;
@synthesize cachedFilePath;
@synthesize fileDate;
@synthesize urlArray;

@synthesize imageView;
@synthesize activityIndicator;
@synthesize display;
@synthesize clear;
@synthesize statusField;
@synthesize dateField;
@synthesize infoField;

#pragma mark -
#pragma mark propertyListViewController_方法实现
// 键盘Done事件处理
- (IBAction)fieldsDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}

// 点击背景关闭键盘
- (IBAction)backgroundClicked:(id)sender
{
	[field1 resignFirstResponder];
	[field2 resignFirstResponder];}

// 返回Documents路径
+ (NSString *)appDocumentsDir
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
	NSString *fullpath = [[propertyListViewController appDocumentsDir] stringByAppendingPathComponent:kFilename];
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
	//[Downloader createConn];
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
	//NSString *secondString = @"EFGH";
	//const char *utfSecondString = [secondString UTF8String];
	//NSMutableData *data2 = [NSMutableData dataWithBytes:utfSecondString length:strlen(utfSecondString)];
	//unsigned len = [data2 length];
//	aBuffer = malloc(len);
	
	const char *path = [[self dataFilePath] UTF8String];
	//const char *destPath = [[[self appDocumentsDir] stringByAppendingPathComponent:@"ttt.txt"] UTF8String];
	FILE *fp = fopen(path, "rb");
	unsigned fileLen = [self fileLength:fp];
	
	aBuffer = malloc(fileLen);
	//FILE *fpdest = fopen(destPath, "wb");
	fread(aBuffer, 1, fileLen, fp);
	//fwrite(aBuffer, 1, fileLen, fpdest);
	[self write:aBuffer toFile:@"ttt.txt"];
	
	fclose(fp);
	//fclose(fpdest);
}

- (unsigned)fileLength:(FILE *)fp
{
	unsigned len = 0;
	if(fp){
		fseek(fp, 0L, SEEK_END);
		len = ftell(fp);
		fseek(fp, 0L, SEEK_SET);
	}
	return len;
}

- (void)write:(const char *)buffer toFile:(NSString *)fileName
{
	const char *destPath = [[[propertyListViewController appDocumentsDir] stringByAppendingPathComponent:fileName] UTF8String];
	FILE *fpdest = fopen(destPath, "wb");
	unsigned fileLen = strlen(buffer);
	fwrite(buffer, 1, fileLen, fpdest);
	fclose(fpdest);
}


#pragma mark -
#pragma mark 属性列表方法
// property-list对象转换为NSData对象
- (BOOL)writePlist:(id)plist toFile:(NSString *)fileName
{
    NSString *err;
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
    if (!pData) {
        NSLog(@"%@", err);
        return NO;
    }
    return ([self writeData:pData toFile:(NSString *)fileName]);
}

// 读取plist属性文件
- (id)plistFromFile:(NSString *)fileName
{
    NSData *retData;
    NSString *err;
    id retPlist;
    NSPropertyListFormat format;
	
    retData = [self dataFromFile:fileName];
    if (!retData) {
        NSLog(@"Data file not returned.");
        return nil;
    }
    retPlist = [NSPropertyListSerialization propertyListFromData:retData  mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&err];
    if (!retPlist){
        NSLog(@"Plist not returned, error: %@", err);
    }
    return retPlist;
}

// NSData对象写入文件
- (BOOL)writeData:(NSData *)data toFile:(NSString *)fileName
{
	return [data writeToFile:fileName atomically:YES];
}

#pragma mark -
#pragma mark archiver方法
//???: An archiver converts an arbitrary collection of objects into a stream of bytes.
//Archivers can convert arbitrary Objective-C objects, scalar types, arrays, structures, strings, and more.

// 从documents目录读取文件， 返回NSData
- (NSData *)dataFromFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
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
	
	/* set initial state of network activity indicators */
	[self stopAnimation];
    
	/* initialize the user interface */
	[self initImageView];
	
	NSString *filepath = [self dataFilePath];

	if([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:filepath];
		// FIXME: 应处理属性列表文件为空的情况
		field1.text = [array objectAtIndex:0];
		field2.text = [array objectAtIndex:1];
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
	
	//////////////////////////////////////////////////////////////////////
	[self turnOffSharedCache];
	[self initCache];
	[self loadUrlRes];
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
	///
	[cacheDir release];
	[cachedFilePath release];
	[fileDate release];
	[urlArray release];
	
	[imageView release];
	[activityIndicator release];
	[statusField release];
	[dateField release];
	[infoField release];
	[display release];
	[clear release];
    [super dealloc];
}


////////////////////////////////////////////////////////////
- (IBAction) onDisplayImage:(id)sender
{
	[self initImageView];
	[self displayImageWithURL:[urlArray objectAtIndex:0]];
}

- (IBAction) onClearCache:(id)sender
{
	NSString *message = NSLocalizedString (@"Do you really want to clear the cache?",
										   @"Clear Cache alert message");
    
	alertWithMessageAndDelegate(message, self);
}

#pragma mark -
#pragma mark NSObject-PrivateMethods 实现
// 初始化ImageView
- (void) initImageView
{
	imageView.image = nil;
	statusField.text = @"";
	dateField.text = @"";
	infoField.text = @"";
}


/* show the user that loading activity has started */
- (void) startAnimation
{
	[self.activityIndicator startAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}


/* show the user that loading activity has stopped */
- (void) stopAnimation
{
	[self.activityIndicator stopAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}


/* enable or disable all toolbar buttons */
- (void) buttonsEnabled:(BOOL)flag
{
	display.enabled = flag;
	clear.enabled = flag;
}

/* 关闭共享的cache */
- (void) turnOffSharedCache
{
	/* turn off the NSURLCache shared cache */
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];
}

/* 初始化自己的cache */
- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.cacheDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
	
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheDir]) {
		return;
	}
	
	/* 新建cache目录 */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDir withIntermediateDirectories:NO attributes:nil error:&error]) {
		alertWithError(error);
		return;
	}
}


/* removes every file in the cache directory */
- (void) clearCache
{
	/* remove the cache directory and its contents */
	if (![[NSFileManager defaultManager] removeItemAtPath:self.cacheDir error:&error]) {
		alertWithError(error);
		return;
	}
	
	/* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDir 
								   withIntermediateDirectories:NO
													attributes:nil 
														 error:&error]) {
		alertWithError(error);
		return;
	}
	
	[self initImageView];
}	


/* display new or existing cached image */
- (void) displayImageWithURL:(NSURL *)theURL
{
	/* get the path to the cached image */
	[cachedFilePath release]; /* release previous instance */
	NSString *fileName = [[theURL path] lastPathComponent];
	cachedFilePath = [[self.cacheDir stringByAppendingPathComponent:fileName] retain];
    
	/* apply daily time interval policy */
	
	/* In this program, "update" means to check the last modified date 
	 of the image to see if we need to load a new version. */
	
	[self getFileModificationDate];
	/* get the elapsed time since last file update */
	NSTimeInterval time = fabs([fileDate timeIntervalSinceNow]);
	if (time > URLCacheInterval) {
		/* file doesn't exist or hasn't been updated for at least one day */
		[self initImageView];
		[self buttonsEnabled:NO];
		[self startAnimation];
		(void) [[URLCacheConnection alloc] initWithURL:theURL delegate:self];
	}
	else {
		statusField.text = NSLocalizedString (@"Previously cached image", 
											  @"Image found in cache and updated in last 24 hours.");
		[self displayCachedImage];
	}
}


/* display existing cached image */
- (void) displayCachedImage
{
	infoField.text = NSLocalizedString (@"The cached image is updated if 24 hours has elapsed since the last update and you press the Display Image button.", @"Information about updates.");
	
	/* retrieve file attributes */
    
	[self getFileModificationDate];
    
	/* format the file modification date for display in Updated field */
	
	/* for detailed information on Unicode date format patterns, see:
	 <http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns> */
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEE, MMM d, yyyy, h:mm a"];
	/* another possible format: @"yyyy-MM-dd HH:mm:ss zzz" */
	dateField.text = [@"Updated: " stringByAppendingString:[dateFormatter stringFromDate:fileDate]];
	[dateFormatter release];
	
	/* display the file as an image */
	
	UIImage *theImage = [[UIImage alloc] initWithContentsOfFile:cachedFilePath];
	if (theImage) {
		imageView.image = theImage;
		[theImage release];
	}
}



/* get modification date of the current cached image */
- (void) getFileModificationDate
{
	/* default date if file doesn't exist (not an error) */
	fileDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath]) {
		/* retrieve file attributes */
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:cachedFilePath error:&error];
		if (attributes != nil) {
			fileDate = [attributes fileModificationDate];
		}
		else {
			alertWithError(error);
		}
	}
}

- (void)loadUrlRes
{
	/* 加载资源得到url。create and load the URL array using the strings stored in URLCache.plist */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"URLCache" ofType:@"plist"];
    if (path) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        urlArray = [[NSMutableArray alloc] init];
        for (NSString *element in array) {
            [urlArray addObject:[NSURL URLWithString:element]];
        }
        [array release];
    }
}

#pragma mark -
#pragma mark URLCacheConnectionDelegate 实现

- (void) connectionDidFail:(URLCacheConnection *)theConnection
{	
	[self stopAnimation];
	[self buttonsEnabled:YES];
	[theConnection release];
}


- (void) connectionDidFinish:(URLCacheConnection *)theConnection
{	
	if ([[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath] == YES) {
		
		/* apply the modified date policy */
		[self getFileModificationDate];
		NSComparisonResult result = [theConnection.lastModified compare:fileDate];
		if (result == NSOrderedDescending) {
			/* file is outdated, so remove it */
			if (![[NSFileManager defaultManager] removeItemAtPath:cachedFilePath error:&error]) {
				alertWithError(error);
			}
			
		}
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath] == NO) {
		/* file doesn't exist, so create it */
		[[NSFileManager defaultManager] createFileAtPath:cachedFilePath 
												contents:theConnection.receivedData 
											  attributes:nil];
		
		statusField.text = NSLocalizedString (@"Newly cached image", 
											  @"Image not found in cache or new image available.");
	}
	else {
		statusField.text = NSLocalizedString (@"Cached image is up to date",
											  @"Image updated and no new image available.");
	}
	
	/* reset the file's modification date to indicate that the URL has been checked */
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil];
	if (![[NSFileManager defaultManager] setAttributes:dict ofItemAtPath:cachedFilePath error:&error]) {
		alertWithError(error);
	}
	[dict release];
	
	[self stopAnimation];
	[self buttonsEnabled:YES];
	[self displayCachedImage];
	
	[theConnection release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		/* the user clicked the Cancel button */
        return;
    }
	
	[self clearCache];
}


@end
