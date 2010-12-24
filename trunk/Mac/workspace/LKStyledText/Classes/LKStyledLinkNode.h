//
//  LKStyledLinkNode.h
//  LKStyledText
//
//  Created by luke on 10-11-29.
//  Copyright 2010 pica.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKStyledTextNode.h"

@interface LKStyledLinkNode : LKStyledTextNode {

	NSString *URL;
}


@property (nonatomic, retain) NSString *URL;
@end