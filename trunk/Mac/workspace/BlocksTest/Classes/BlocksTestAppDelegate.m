//
//  BlocksTestAppDelegate.m
//  BlocksTest
//
//  Created by luke on 10-9-14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BlocksTestAppDelegate.h"
#import "BlocksTestViewController.h"
#import "LongRunningTask.h"

@interface BlocksTestAppDelegate ()

- (void)scheduleAlarmForDate:(NSDate *)theDate;
@end


@implementation BlocksTestAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize appStatus;

#ifdef USE_INSTANCE_VAR
@synthesize aTask;
#endif

#pragma mark -
#pragma mark Application lifecycle


//+ (void)initialize
//{
//	if ( self == [BlocksTestAppDelegate class] ) {
//		
//	}
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	self.appStatus = @"Back";
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	UIApplication *app = [UIApplication sharedApplication];
	
	if (isLongRunningTaskRunning) {
		return;
	}
	
#ifdef USE_INSTANCE_VAR // or localVariable
	self.aTask = [[LongRunningTask alloc] init];
#else
	LongRunningTask *aTask = [[LongRunningTask alloc] init];
#endif
	NSLog(@"1 - aTask count = %u", [aTask retainCount]);
	
    aTask.bgTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
		//???: 中断的任务再次进入会自动重新执行?
		NSLog(@"%@ -------- intrupted runTask --------", appStatus);
		NSLog(@"2 - aTask count = %u", [aTask retainCount]);
		isLongRunningTaskRunning = NO;
        [app endBackgroundTask:aTask.bgTaskID];
        aTask.bgTaskID = UIBackgroundTaskInvalid;
		NSLog(@"3 - aTask retainCount = %u", [aTask retainCount]);
		[aTask release];
    }];
	
	// start timer-based local notify 
	[self scheduleAlarmForDate:[NSDate dateWithTimeIntervalSinceNow:3]];
	
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		isLongRunningTaskRunning = YES;
		NSLog(@"4 - aTask count = %u", [aTask retainCount]);
		[aTask runTask];
		NSLog(@"%@ -------- finish runTask --------", appStatus);
		
		/// 
		NSLog(@"5 - aTask retainCount = %u", [aTask retainCount]);
		isLongRunningTaskRunning = NO;
        [app endBackgroundTask:aTask.bgTaskID];
        aTask.bgTaskID = UIBackgroundTaskInvalid;
		NSLog(@"6 - aTask retainCount = %u", [aTask retainCount]);
		[aTask release];
    });
	
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	self.appStatus = @"Forg";
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -

#pragma mark UIApplication
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSLog(@"didReceiveLocalNotification");
}

#pragma mark // timer-based Local Notify
- (void)scheduleAlarmForDate:(NSDate *)theDate
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
	
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
	
    // Create a new notification
    UILocalNotification *alarm = [[[UILocalNotification alloc] init] autorelease];
    if (alarm) {
        alarm.fireDate = theDate;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
		alarm.alertLaunchImage = @"alarm.png"; // [UIImage imageNamed:@"alarm.png"];
        alarm.soundName = @"alarmsound.caf";
        alarm.alertBody = @"Time to wake up!";
		
        [app scheduleLocalNotification:alarm];
    }
}


#pragma mark // post Local Notify while in background self


////
#pragma mark -
#pragma mark // background audio




#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
#ifdef USE_INSTANCE_VAR
	[aTask release];
#endif
	[appStatus release];
    [viewController release];
    [window release];
    [super dealloc];
}

@end
