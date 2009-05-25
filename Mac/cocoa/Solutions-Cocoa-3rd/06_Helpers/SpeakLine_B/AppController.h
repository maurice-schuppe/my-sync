//
//  AppController.h
//  SpeakLine
//
//  Created by Aaron Hillegass on 9/13/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject {
	IBOutlet NSTextField *textField;
	IBOutlet NSButton *stopButton;
	IBOutlet NSButton *startButton;
	IBOutlet NSTableView *tableView;
	
	NSSpeechSynthesizer *speechSynth;
	NSArray *voiceList;
}
- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;
@end
