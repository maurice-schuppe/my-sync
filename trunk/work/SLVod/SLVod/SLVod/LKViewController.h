//
//  LKViewController.h
//  siluVod
//
//  Created by luke on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+iconImage.h"
#import "SBJson.h"
#import "LKTipCenter.h"
#import "UIView+LKAddition.h"
#import "LKImgDownload.h"
#import "LKImageRecord.h"
#import "LKShadowTableView.h"
#import "NSString+URL.h"

#import "SLHotCell.h"
#import "SLMovInfoCell.h"
#import "SLUserProfileCell.h"

#import "SLVodAppDelegate.h"

@interface LKViewController : UIViewController <LKImgDownloadDelegate, SLPlayDelegate> {
    
    NSMutableData   *jsonData;
    NSMutableArray  *movies;
    NSURLConnection *listConn;
    
    BOOL            allRequestShouldCancel;
    NSMutableDictionary	*imageDownloadsInProgress;
    
    UITableView     *theTable;
    
    // cells
    SLHotCell           *tmpHotCell;
    SLMovInfoCell       *tmpMovInfoCell;
    SLUserProfileCell   *tmpUProfileCell;
}

@property (nonatomic, assign) UITableView     *theTable;

@property (nonatomic, assign) IBOutlet SLHotCell *tmpHotCell;
@property (nonatomic, assign) IBOutlet SLMovInfoCell *tmpMovInfoCell;
@property (nonatomic, assign) IBOutlet SLUserProfileCell *tmpUProfileCell;

@property (nonatomic, assign) BOOL              allRequestShouldCancel;
@property (nonatomic, retain) NSMutableDictionary	*imageDownloadsInProgress;
@property (nonatomic, retain) NSURLConnection   *listConn;
@property (nonatomic, retain) NSMutableArray    *movies;
@property (nonatomic, retain) NSMutableData     *jsonData;

@end



#pragma mark - ListAndImageLoad()
@interface LKViewController (ListAndImageLoad)
- (id)parse:(NSData *)theData;
- (void)cancelListConn;
- (void)loadImagesForOnscreenRows:(UITableView *)theTable;
@end

#pragma mark - Http Live Stream()
@interface LKViewController (HLS)
- (void)initAndPlayMovie:(NSURL *)movieURL;
@end

