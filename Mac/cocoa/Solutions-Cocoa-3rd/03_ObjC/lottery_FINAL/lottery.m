#import <Foundation/Foundation.h>
#import "LotteryEntry.h"

int main (int argc, const char * argv[]) {
	NSMutableArray *array;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSCalendarDate *now = [[NSCalendarDate alloc] init];
	
	// Seed the random number generator
	srandom(time(NULL));
	
	array = [[NSMutableArray alloc] init];
	int i;

	for (i = 0; i < 10; i++) {
			
		// Create a date/time object that is 'i' weeks from now
		NSCalendarDate *iWeeksFromNow;
		iWeeksFromNow = [now dateByAddingYears:0
										months:0
										  days:(i * 7)
										 hours:0
									   minutes:0
									   seconds:0];
		
		// Create a new instance of Lottery Entry
		LotteryEntry *newEntry = [[LotteryEntry alloc] initWithEntryDate:iWeeksFromNow];
		
        // Add the LotteryEntry object to the array
		[array addObject:newEntry];
	}
	
    
	for (LotteryEntry *entryToPrint in array) {
        // Display its contents
		NSLog(@"%@", entryToPrint);
	}
	
	[pool drain];
	return 0;
}
