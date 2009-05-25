//
//  CellsAppDelegate.m
//  Cells
//
//  Created by Jeff LaMarche on 7/12/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "CellsAppDelegate.h"
#import "CellsViewController.h"

@implementation CellsAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	// Override point for customization after app launch	
    [window addSubview:viewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
	[window release];
	[super dealloc];
}


@end
