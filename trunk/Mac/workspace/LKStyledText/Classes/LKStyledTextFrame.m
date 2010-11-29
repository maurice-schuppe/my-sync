//
//  LKStyledTextFrame.m
//  LKStyledText
//
//  Created by luke on 10-11-29.
//  Copyright 2010 pica.com. All rights reserved.
//

#import "LKStyledTextFrame.h"
#import "LKStyledTextNode.h"
#import "LKStyledLinkNode.h"


@implementation LKStyledTextFrame

@synthesize text, font, textColor, backColor;

- (id)initWithText:(NSString *)atext node:(LKStyledTextNode *)aTNode {
	
	if (self = [super init]) {
		self.text = atext;
		node = aTNode;
	}
	return self;
}

- (void)drawInRect:(CGRect)aRect {
	
	CGContextRef _context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(_context);
	//CGContextSetStrokeColorWithColor(_context, [textColor CGColor]);
	//CGContextSetFillColorWithColor(_context, [textColor CGColor]);
	
	if ([self.node isKindOfClass:[LKStyledLinkNode class]]) {
		// 画背景
		DLog(@"画背景");
		if (selected) {
			self.textColor = [UIColor darkGrayColor];
		} else {
			self.textColor = [UIColor blueColor];
		}
	} else {
		self.textColor = [UIColor blackColor];
	}

	[self.textColor set];
	[text drawInRect:aRect withFont:font lineBreakMode:UILineBreakModeClip];
	CGContextRestoreGState(_context);
}

- (void)dealloc {
	
	[text release];
	[font release];
	[textColor release];
	[backColor release];
	[super dealloc];
}

@end
