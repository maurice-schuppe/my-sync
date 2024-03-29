//
//  GreetView.h
//  TemplateShow
//
//  Created by luke on 10-2-7.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wk_iphoneccshw.h"

@interface GreetView : UIView {
	Winks_CCDW_Text_s *gText;
	NSTimer *greetingTimer;
	NSString *gNsGreet;
	int gGreetWidth;
}

@property (nonatomic, assign) Winks_CCDW_Text_s *gText;
@property (nonatomic, assign) NSTimer *greetingTimer;
@property (nonatomic, retain) NSString *gNsGreet;
@property (nonatomic, assign) int gGreetWidth;

- (id)initWithSection:(Winks_CCDW_Text_s *)pSection;
- (CGFloat)getStrWidth:(NSString *)str withFontSize:(int)size;

- (void)getGreetingStyles;
- (void)renderGreeting:(NSString *)greeting width:(int)greetingWidth at:(CGContextRef)context;
- (void)drawCrollUp:(NSString *)greeting withRect:(CGRect)rect withAlign:(UITextAlignment)align at:(CGContextRef)context;
- (void)drawCrollLeft:(NSString *)greeting withRect:(CGRect)rect withAlign:(UITextAlignment)align at:(CGContextRef)context;

- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)disposeGreetTimer;

- (void)initColors;
- (void)colorCroll;
- (void)drawWithColors:(CGContextRef)context atRect:(CGRect)textRect lineBreakMode:(UILineBreakMode)breakMode alignment:(UITextAlignment)alignMode;

@end
