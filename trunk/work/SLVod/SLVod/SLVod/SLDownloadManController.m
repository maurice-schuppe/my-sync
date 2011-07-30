//
//  SLDownloadManController.m
//  SLVod
//
//  Created by luke on 11-6-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SLDownloadManController.h"
#import "LKTools.h"
#import "SLMovie.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequestConfig.h"


@implementation SLDownloadManController

@synthesize table, seg;
@synthesize movsInDownloading, movsDownloaded, downingQueue;

- (void)dealloc
{
    MLog(@"");
    [movsDownloaded release];
    [movsInDownloading release];
    [table release];
    [seg release];
    [downingQueue release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        NSArray *segArr = [NSArray arrayWithObjects:@"全部", @"已完成", @"下载中", nil];
        
        self.seg = [[UISegmentedControl alloc] initWithItems:segArr];
        self.seg.segmentedControlStyle = UISegmentedControlStyleBar;
        [self.seg addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
        self.seg.selectedSegmentIndex = 0;
        
        NSLog(@"%@", self.navigationItem);
        NSLog(@"%@", self.navigationItem.titleView);
        self.navigationItem.titleView = seg;
        [seg release];
        
        self.downingQueue = [ASINetworkQueue queue];
        [self.downingQueue setMaxConcurrentOperationCount:2];
        self.movsInDownloading = [NSMutableDictionary dictionary];
        self.movsDownloaded = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - segment handle

- (void)segmentSelected:(UISegmentedControl *)aSeg
{
    DLOG
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SLMovDetailController *detailVC = [[SLMovDetailController alloc] initWithNibName:@"SLMovDetailController" bundle:nil];
//    detailVC.mov = [movies objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [detailVC release];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SLHotCell";
    SLHotCell *theCell = (SLHotCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!theCell) {
        [[NSBundle mainBundle] loadNibNamed:@"SLHotCell" owner:self options:nil];
        if (tmpHotCell) {
            theCell = tmpHotCell;
            theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.tmpHotCell = nil;
        }
    }
    theCell.movie = [movies objectAtIndex:indexPath.row];
    return theCell;
}

#pragma mark - download handle
- (NSString *)downloadPath:(SLMovie *)mov
{
    NSString *path = nil;
    NSString *catePart = docPath();
    if (mov && mov.cate && [mov.cate length] > 0) {
        catePart = [catePart stringByAppendingPathComponent:mov.cate];
    }
    if (catePart && [catePart length] > 0) {
        NSString *url = [NSString stringWithFormat:@"%@", mov.url];
        path = [catePart stringByAppendingPathComponent:[url lastPathComponent]];
    }
    return path;
}

- (BOOL)startDownload:(SLMovie *)mov
{
    if (mov.url) {
        if ([mov.url scheme]) {
            
            ASIHTTPRequest *downReq = [ASIHTTPRequest requestWithURL:mov.url];
            [downReq addRequestHeader:@"Connection" value:@"Keep-Alive"];
            [downReq addRequestHeader:@"Keep-Alive" value:@"timeout=300, max=29974"];
            [downReq setAllowResumeForFileDownloads:YES];
            [downReq setDownloadDestinationPath:[self downloadPath:mov]];
            [downReq setDelegate:self];
            [downReq setDownloadCache:[ASIDownloadCache sharedCache]];
            [downingQueue addOperation:downReq];
            [downingQueue go];
            return YES;
        }
    }
    return NO;
}

#pragma mark - SLMovDownloadDelegate
- (void)download:(SLHotCell *)theCell
{
    if ([self startDownload:theCell.movie]) {
        [theCell.downButton setEnabled:NO];
    } else {
        [theCell.titleLabel setText:@"无法下载"];
    }
}

#pragma mark - ASIHTTPRequest
- (void)requestFailed:(ASIHTTPRequest *)request
{
    DLog(@"%@", [request.error description]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    DLOG
    DLog(@"%d", [[request responseData] length]);
}

#pragma mark - ASIProgressDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    DLOG
}

#pragma mark - ASICacheDelegate

// Should return the cache policy that will be used when requests have their cache policy set to ASIUseDefaultCachePolicy
- (ASICachePolicy)defaultCachePolicy
{
    return ASIAskServerIfModifiedWhenStaleCachePolicy;
}

// Returns the date a cached response should expire on. Pass a non-zero max age to specify a custom date.
- (NSDate *)expiryDateForRequest:(ASIHTTPRequest *)request maxAge:(NSTimeInterval)maxAge
{
    return [NSDate dateWithTimeIntervalSinceNow:MAXFLOAT];
}

// Updates cached response headers with a new expiry date. Pass a non-zero max age to specify a custom date.
- (void)updateExpiryForRequest:(ASIHTTPRequest *)request maxAge:(NSTimeInterval)maxAge
{
    DLOG
}

// Looks at the request's cache policy and any cached headers to determine if the cache data is still valid
- (BOOL)canUseCachedDataForRequest:(ASIHTTPRequest *)request
{
    DLOG
    return YES;
}

// Removes cached data for a particular request
- (void)removeCachedDataForRequest:(ASIHTTPRequest *)request
{
    DLOG
}

// Should return YES if the cache considers its cached response current for the request
// Should return NO is the data is not cached, or (for example) if the cached headers state the request should have expired
- (BOOL)isCachedDataCurrentForRequest:(ASIHTTPRequest *)request
{
    DLOG
    return YES;
}

// Should store the response for the passed request in the cache
// When a non-zero maxAge is passed, it should be used as the expiry time for the cached response
- (void)storeResponseForRequest:(ASIHTTPRequest *)request maxAge:(NSTimeInterval)maxAge
{
    DLOG
}

// Removes cached data for a particular url
- (void)removeCachedDataForURL:(NSURL *)url
{
    DLOG
}

// Should return an NSDictionary of cached headers for the passed URL, if it is stored in the cache
- (NSDictionary *)cachedResponseHeadersForURL:(NSURL *)url
{
    DLOG
    return nil;
}

// Should return the cached body of a response for the passed URL, if it is stored in the cache
- (NSData *)cachedResponseDataForURL:(NSURL *)url
{
    DLOG
    return nil;
}

// Returns a path to the cached response data, if it exists
- (NSString *)pathToCachedResponseDataForURL:(NSURL *)url
{
    DLOG
    return nil;
}

// Returns a path to the cached response headers, if they url
- (NSString *)pathToCachedResponseHeadersForURL:(NSURL *)url
{
    DLOG
    return nil;
}

// Returns the location to use to store cached response headers for a particular request
- (NSString *)pathToStoreCachedResponseHeadersForRequest:(ASIHTTPRequest *)request
{
    DLOG
    NSString *headerPath = [docPath() stringByAppendingPathComponent:@"cachedresponseheaders"];
    return headerPath;
}

// Returns the location to use to store a cached response body for a particular request
- (NSString *)pathToStoreCachedResponseDataForRequest:(ASIHTTPRequest *)request
{
    DLOG
    NSString *headerDataPath = [docPath() stringByAppendingPathComponent:@"cachedresponsedata"];
    return headerDataPath;
}

// Clear cached data stored for the passed storage policy
- (void)clearCachedResponsesForStoragePolicy:(ASICacheStoragePolicy)cachePolicy
{
    DLOG
}

#pragma mark - BCTabbar 

- (NSString *)iconImageName {
	return @"disk.png";
}

@end