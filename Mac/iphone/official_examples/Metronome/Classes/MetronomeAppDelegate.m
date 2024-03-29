/*

File: MetronomeAppDelegate.m
Abstract: MetronomeAppDelegate is responsible for creating instantiating a
MetronomeViewController, which manages the views that will appear in the
application's window. MetronomeAppDelegate also provides the time signatures
displayed in the PreferencesView, and keeps track of the currently selected time
signature.

Version: 1.7

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

#import "MetronomeAppDelegate.h"
#import "RootViewController.h"
#import "MetronomeView.h"
#import "Constants.h"

static NSString *MetronomeTimeSignatureKey = @"MetronomeTimeSignatureKey";

@implementation MetronomeAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize timeSignatures;
@synthesize timeSignature;

#pragma mark -
#pragma mark === Set up/Tear down ===
#pragma mark -
// +initialize is invoked before the class receives any other messages, so it
// is a good place to set up application defaults
+ (void)initialize {

    if ([self class] == [MetronomeAppDelegate class]) {
        // Register a default value for the time signature. 
        // This will be used if the user hasn't already specified a preferred time signature.
        NSNumber *defaultTimeSignature = [NSNumber numberWithInt:TimeSignatureFourFour];
        NSDictionary *resourceDict = [NSDictionary dictionaryWithObject:defaultTimeSignature forKey:MetronomeTimeSignatureKey];
        [[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
    }
}

// Invoked after the application has been launched and initialized but before it has received its first event.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Set up time signature array
    timeSignatures = [[NSArray alloc] initWithObjects:@"2/4", @"3/4", @"4/4", nil];
    
    // Set up main view controller 
    RootViewController *viewController = [[RootViewController alloc] init];
    self.rootViewController = viewController;
    [viewController release];
    
    // Add the view controller's view to the window
    [window addSubview:[rootViewController view]];

    // Restore preferred time signature
    int restoredSignature = [[NSUserDefaults standardUserDefaults] integerForKey:MetronomeTimeSignatureKey];
    if ((restoredSignature >= TimeSignatureTwoFour ) && (restoredSignature <= TimeSignatureFourFour )) {
        self.timeSignature = restoredSignature;
    }
}

// Invoked immediately before the application terminates.
- (void)applicationWillTerminate:(UIApplication *)application {
    // Store user's time signature preference, so that it is used the next time the app is launched
    [[NSUserDefaults standardUserDefaults] setInteger:self.timeSignature forKey:MetronomeTimeSignatureKey];
}

- (void)setTimeSignature:(TimeSignatureType)value {
    timeSignature = value;
    MetronomeView *metronomeView = (MetronomeView *)rootViewController.metronomeViewController.view;
    [metronomeView updateAnimation:self];
}

- (void)dealloc {
    [timeSignatures release];
    [rootViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark === Time signature table: TableView datasource methods ===
#pragma mark -

// As the delegate and data source for the table, the MetronomeAppDelegate must respond to certain methods the table view
// will call to get the number of sections, the number of rows, and the cell for a row.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [timeSignatures count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // this table has only one section
    return NSLocalizedString(@"Time Signature", @"Title for table that display time signatures");
}

// Provide cells for the table, with each showing one of the available time signatures
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"PreferencesCellIdentifier"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"PreferencesCellIdentifier"] autorelease];
    }
    
    cell.text = [timeSignatures objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark ===  Time signature table: TableView delegate methods ===
#pragma mark -
// Specify the kind of accessory view (to the far right of each row) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:([self timeSignature] - 2) inSection:0];
    
    if ([selectedPath compare:indexPath] == NSOrderedSame ) {
        return UITableViewCellAccessoryCheckmark;
    }
    
    return UITableViewCellAccessoryNone;
}

// As the delegate, the MetronomeAppDelegate is informed when selection changes in the table.
// Display check mark on the new selected time signature and remove check mark from old time signature
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:([self timeSignature] - 2) inSection:0];

    [[table cellForRowAtIndexPath:oldIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    [[table cellForRowAtIndexPath:newIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [table deselectRowAtIndexPath:newIndexPath animated:YES];

    if (newIndexPath.row == 0) {
        [self setTimeSignature:TimeSignatureTwoFour];
    } else if (newIndexPath.row == 1) {
        [self setTimeSignature:TimeSignatureThreeFour];
    } else {
        [self setTimeSignature:TimeSignatureFourFour];
    }
}

@end
