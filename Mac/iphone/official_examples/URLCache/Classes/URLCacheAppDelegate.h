/*
 
 File: URLCacheAppDelegate.h
 Abstract: The application delegate for the URLCache sample.
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008 Apple Inc. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import	"URLCacheConnection.h"

@interface URLCacheAppDelegate : NSObject <UIApplicationDelegate, URLCacheConnectionDelegate, UIAlertViewDelegate> {
	NSString *dataPath; // 自己的cache路径
	NSString *filePath; // path to the cached image
	NSDate *fileDate; // cached image的文件最后修改时间
	NSMutableArray *urlArray; // URLCache.plist文件中所有的url
	NSError *error; // 指向所有的错误（始终指向最新的错误）
	
	IBOutlet UIWindow *window;
	IBOutlet UIImageView *imageView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UILabel *statusField;
	IBOutlet UILabel *dateField;
	IBOutlet UILabel *infoField;
	IBOutlet UIBarButtonItem *toolbarItem1;
	IBOutlet UIBarButtonItem *toolbarItem2;
}

@property (nonatomic, copy) NSString *dataPath;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, retain) NSDate *fileDate;
@property (nonatomic, retain) NSMutableArray *urlArray;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *statusField;
@property (nonatomic, retain) UILabel *dateField;
@property (nonatomic, retain) UILabel *infoField;
@property (nonatomic, retain) UIBarButtonItem *toolbarItem1;
@property (nonatomic, retain) UIBarButtonItem *toolbarItem2;

- (IBAction) onDisplayImage:(id)sender;
- (IBAction) onClearCache:(id)sender;

@end

