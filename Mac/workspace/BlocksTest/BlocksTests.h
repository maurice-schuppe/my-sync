//
//  BlocksTests.h
//  BlocksTest
//
//  Created by luke on 10-9-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlocksTests : NSObject {
	NSString *instanceVariable;
}

@property (assign) NSString *instanceVariable;

- (void)runTest;
- (void)retainTest;
@end
