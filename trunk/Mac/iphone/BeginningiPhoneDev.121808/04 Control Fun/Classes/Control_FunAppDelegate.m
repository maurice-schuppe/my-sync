//
//  Control_FunAppDelegate.m
//  Control Fun
//
//  Created by Jeff LaMarche on 7/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Control_FunAppDelegate.h"
#import "Control_FunViewController.h"

@implementation Control_FunAppDelegate

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
