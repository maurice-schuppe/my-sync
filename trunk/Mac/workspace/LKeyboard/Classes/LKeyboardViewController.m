//
//  LKeyboardViewController.m
//  LKeyboard
//
//  Created by luke on 10-10-14.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LKeyboardViewController.h"
#import "LKeyboardView.h"
#import "LKeyboardAppDelegate.h"


@interface LKeyboardViewController ()

@property (nonatomic, retain) UITextField *txtField;
@property (nonatomic, retain) UIButton *showOrHideButton;

@end


@implementation LKeyboardViewController

@synthesize emoKeyBoardView, txtField, showOrHideButton;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.showOrHideButton setTitle:@"show" forState:UIControlStateNormal];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification object:nil];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIDeviceOrientationLandscapeRight);
	return YES;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardWillShowNotification 
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardWillHideNotification 
												  object:nil];
	[emoKeyBoardView release];
	[txtField release];
	[showOrHideButton release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark LKeyBoardView

- (CGRect)resetKeyboardFrame
{
	CGRect keyBoardFrame = CGRectZero;
	switch ([UIDevice currentDevice].orientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			keyBoardFrame = kPortraitRect_Frame;
			break;
		case UIInterfaceOrientationLandscapeRight:
		case UIInterfaceOrientationLandscapeLeft:
			keyBoardFrame = kLandscapRect_Frame;
			break;
		default:
			NSLog(@"curOrientation invailide");
			break;
	}
	return keyBoardFrame;
}

- (IBAction)showOrHideEmoKeyboard
{
	CATransition *theAnimation = [CATransition animation];
	[theAnimation setType:kCATransitionPush];
	theAnimation.delegate = self;
	
	CGRect keyBoardFrame = [self resetKeyboardFrame];
	if ([showOrHideButton.currentTitle isEqualToString:@"show"]) {
		[self.txtField resignFirstResponder];
		
		self.emoKeyBoardView = [[LKeyboardView alloc] initWithFrame:keyBoardFrame];
		[self.view addSubview:emoKeyBoardView];
		[emoKeyBoardView release];
		
		[showOrHideButton setTitle:@"hide" forState:UIControlStateNormal];
		
		[theAnimation setSubtype:kCATransitionFromTop];
		[emoKeyBoardView.layer addAnimation:theAnimation 
						   forKey:@"pushIn"];
	} else {
		[showOrHideButton setTitle:@"show" forState:UIControlStateNormal];
		
		[theAnimation setSubtype:kCATransitionFromBottom];
		[emoKeyBoardView.layer addAnimation:theAnimation 
									 forKey:@"pushOut"];
		[self.emoKeyBoardView setHidden:YES];
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	//if (anim == [emoKeyBoardView.layer animationForKey:@"pushOut"])
	if ([showOrHideButton.currentTitle isEqualToString:@"show"])
		[self.emoKeyBoardView removeFromSuperview];
}

#pragma mark -
#pragma mark rotate handle

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration
{
	// 释放上一个重新创建一个新的.
	if ([showOrHideButton.currentTitle isEqualToString:@"hide"]) {
		[self.emoKeyBoardView removeFromSuperview];
		
		CGRect keyBoardFrame = [self resetKeyboardFrame];
		self.emoKeyBoardView = [[LKeyboardView alloc] initWithFrame:keyBoardFrame];
		[self.view addSubview:emoKeyBoardView];
		[emoKeyBoardView release];
	}	
	
#if 1
	for (UIView *aView in self.view.subviews) {
		[aView layoutSubviews];
	}
#else
	[self.view layoutSubviews];
#endif
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation
											duration:duration];
}

#pragma mark -
#pragma mark UIKeyBoard handle

- (void)keyboardWillShow:(NSNotification *)note
{
	if (emoKeyBoardView) {
		[self.emoKeyBoardView removeFromSuperview];
		[self.showOrHideButton setTitle:@"show" forState:UIControlStateNormal];
	}
}

- (void)keyboardWillHide:(NSNotification *)note
{
	
}

@end
