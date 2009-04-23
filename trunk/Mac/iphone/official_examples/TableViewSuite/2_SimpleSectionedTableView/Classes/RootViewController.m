/*

File: RootViewController.m
Abstract: View controller that serves as the table view's data source and
delegate. It also set up the data.

Version: 1.8

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

#import "RootViewController.h"
#import "SimpleSectionedTableViewAppDelegate.h"


NSString *localeNameForTimeZoneNameComponents(NSArray *nameComponents);
NSMutableDictionary *regionDictionaryWithNameInArray(NSString *name, NSArray *array);


@implementation RootViewController


@synthesize displayList;


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.title = NSLocalizedString(@"Time Zones", @"Time Zones title");
	}
	return self;
}


- (void)viewDidLoad {
	[self setUpDisplayList];
}


- (void)dealloc {
	[displayList release];
    [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Number of sections is the number of region dictionaries
	return [displayList count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Number of rows is the number of names in the region dictionary for the specified section
	NSDictionary *regionDictionary = [displayList objectAtIndex:section];
	NSArray *zonesForSection = [regionDictionary objectForKey:@"TimeZones"];
	return [zonesForSection count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// The header for the section is the region name -- get this from the dictionary at the section index
	NSDictionary *regionDictionary = [displayList objectAtIndex:section];
	return [regionDictionary valueForKey:@"RegionName"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	// Get the section index, and so the region dictionary for that section
	NSDictionary *regionDictionary = [displayList objectAtIndex:indexPath.section];
	NSArray *regionTimeZones = [regionDictionary objectForKey:@"TimeZones"];
	
	// Set the cell's text to the name of the time zone at the row
	cell.text = [[regionTimeZones objectAtIndex:indexPath.row] objectForKey:@"timeZoneLocaleName"];
	return cell;
}


- (void)setUpDisplayList {
	/*
	 Create an array of dictionaries
	 Each dictionary represents a region:
	 key = "RegionName" value = e.g. "Europe"
	 key = "LocaleNames" value = [array of strings with locale names]
	 */
	
	SimpleSectionedTableViewAppDelegate *appDelegate = (SimpleSectionedTableViewAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *knownTimeZoneNames = [appDelegate list];
	NSMutableArray *timeZones = [[NSMutableArray alloc] init];
	
	for (NSString *name in knownTimeZoneNames) {
		NSArray *components = [name componentsSeparatedByString:@"/"];
		NSString *regionName = [components objectAtIndex:0];
		
		// Get the region dictionary with the region name, or create it if it doesn't exist
		NSMutableDictionary *regionDictionary = regionDictionaryWithNameInArray(regionName, timeZones);
		if (regionDictionary == nil) {
			regionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:regionName, @"RegionName", [NSMutableArray array], @"TimeZones", nil];
			[timeZones addObject:regionDictionary];
			[regionDictionary release];
		}
		
		NSMutableArray *zones = [regionDictionary objectForKey:@"TimeZones"];
		NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:name];
		NSString *timeZoneLocaleName = localeNameForTimeZoneNameComponents(components);
		NSDictionary *timeZoneDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:timeZone, @"timeZone", timeZoneLocaleName, @"timeZoneLocaleName", nil];
		[zones addObject:timeZoneDictionary];
		[timeZoneDictionary release];
	}
	
	// Now sort the time zones by name
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeZoneLocaleName" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	for (NSMutableDictionary *regionDictionary in timeZones) {
		NSMutableArray *zones = [regionDictionary objectForKey:@"TimeZones"];
		[zones sortUsingDescriptors:sortDescriptors];
	}
	[sortDescriptor release];
	
	// Sort the regions
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"RegionName" ascending:YES];
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [timeZones sortUsingDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	self.displayList = timeZones;
	[timeZones release];
}	

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}


@end


NSString *localeNameForTimeZoneNameComponents(NSArray *nameComponents) {
	if ([nameComponents count] == 2) {
		return [nameComponents objectAtIndex:1];
	}
	NSString *localeName = [NSString stringWithFormat:@"%@ (%@)", [nameComponents objectAtIndex:2], [nameComponents objectAtIndex:1]];
	return localeName;
}


NSMutableDictionary *regionDictionaryWithNameInArray(NSString *name, NSArray *array) {
	// Return the region dictionary with a given region name
	for (NSMutableDictionary *region in array) {
		NSString *regionName = [region objectForKey:@"RegionName"];
		if ([regionName isEqualToString:name]) {
			return region;
		}
	}
	return nil;
}

