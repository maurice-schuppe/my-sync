//
//  Foo.h
//  RandomApp
//
//  Created by luke on 4/16/09.
//  Copyright 2009 luke. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Foo : NSObject {
	IBOutlet NSTextField *textField;
}

-(IBAction)seed:(id)sender;
-(IBAction)generate:(id)sender;

@end
