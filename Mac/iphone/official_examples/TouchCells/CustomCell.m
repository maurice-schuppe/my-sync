/*
     File: CustomCell.m
 Abstract: The custom UITableViewCell for holding the checkmark button.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008 Apple Inc. All Rights Reserved.
 
 */

#import "CustomCell.h"
#import "AppDelegate.h"

@implementation CustomCell

@synthesize checked, title;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		self.target = self;
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		self.accessoryAction = @selector(onClick:);
		
		// cell's title label
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.opaque = NO;
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.highlightedTextColor = [UIColor whiteColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
		[self.contentView addSubview:titleLabel];
		
		// cell's check button
		checkButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		checkButton.frame = CGRectZero;
		checkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[checkButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchDown];
		checkButton.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:checkButton];
	}
	return self;
}

// called when the accessory view (disclosure button) is touched
- (void)onClick:(id)sender
{
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
								self.title, @"text",
								[NSNumber numberWithBool:self.checked], @"checked",
								nil];
	[appDelegate showDetail:infoDict];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	
	CGRect frame = CGRectMake(contentRect.origin.x + 40.0, 8.0, contentRect.size.width, 30.0);
	titleLabel.frame = frame;
	titleLabel.text = self.title;
	
	// layout the check button image
	UIImage *checkedImage = [UIImage imageNamed:@"checked.png"];
	frame = CGRectMake(contentRect.origin.x + 10.0, 12.0, checkedImage.size.width, checkedImage.size.height);
	checkButton.frame = frame;
	
	UIImage *image = (self.checked) ? checkedImage: [UIImage imageNamed:@"unchecked.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[checkButton setBackgroundImage:newImage forState:UIControlStateNormal];
}

- (void)dealloc
{
	[titleLabel release];
	[checkButton release];
	[title release];
    [super dealloc];
}

// called when the checkmark button is touched 
- (void)checkAction:(id)sender
{
	// note: we don't use 'sender' because this action method can be called separate from the button (i.e. from table selection)
	self.checked = !self.checked;
	UIImage *checkImage = (self.checked) ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
	[checkButton setImage:checkImage forState:UIControlStateNormal];
}

@end
