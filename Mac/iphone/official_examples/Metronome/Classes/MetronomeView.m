/*

File: MetronomeView.m
Abstract: MetronomeView builds and displays the primary user interface of the
Metronome application.

Version: 1.7

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

#import "MetronomeView.h"
#import "MetronomeAppDelegate.h"
#import "SoundEffect.h" 

#define kDisplacementAngle 20
#define kMaxBPM 225
#define kMinBPM 1
#define kDefaultBPM 80

// These dimensions are based on the artwork for the arm.
// They're used to keep the weight from being dragged off either end of the arm.
// They're also used to calculate a rotational angle given a horizontal drag, see touchesMoved:.
#define kArmBaseX    160.0
#define kArmBaseY    440.0
#define kArmTopY     100.0
#define kWeightHeight 40.0
#define kWeightOffset 14.0
#define kUpperWeightLocationLimit kArmTopY + (kWeightHeight / 2)
#define kLowerWeightLocationLimit kArmBaseY

#define kYMinMinusBPMMin (kArmTopY - kMinBPM)
#define kBPMRange (kMaxBPM - kMinBPM)
#define kYRange (kArmBaseY - kArmTopY)

CGFloat WeightYCoordinateForBPM(NSInteger bpm) {
    CGFloat yCoord = (bpm + kWeightOffset) * (kYRange/kBPMRange) + kArmTopY;
    return yCoord;
}

CGFloat bpmForWeightYCoordinate(NSInteger yCoord) {
    CGFloat bpm = (yCoord - kArmTopY) * (kBPMRange/kYRange) - kWeightOffset;
    return bpm;
}

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

// Setter is private, so redeclare property here in a class extension (anonymous category).
// Properties that you want to be private - accessible only to objects of this class, must be declared in
// class extensions.
@interface MetronomeView () 
@property CGFloat duration;
@end

// Private interface, methods used only internally.
@interface MetronomeView (PrivateMethods) 
- (void)stopArm:(id)sender;
- (void)stopSoundAndArm;
- (void)stopDriverThread;
- (void)startSoundAndAnimateArmToRight:(BOOL)startToRight;
- (void)setDuration:(CGFloat)duration;
- (CGFloat)duration;
- (void)updateWeightPosition;
- (void)dragWeightByYDisplacement:(CGFloat)yDisplacement;
- (void)setupSounds;
- (void)setupSubviews;
- (void)updateBPMFromWeightLocation;
- (void)rotateArmToDegree:(CGFloat)positionInDegrees;
@end


@implementation MetronomeView

// Direct the compiler to synthesize accessors for these properties.
@synthesize duration;
@synthesize soundPlayerThread;
@synthesize metronomeViewController;

#pragma mark -
#pragma mark === Setting up / Tearing down ===
#pragma mark -
// Set up default values
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        // set up default state
        armIsAnimating = NO;
        tempoChangeInProgress = NO;
        self.bpm = kDefaultBPM;
        
        // set up sounds and views
        [self setupSounds];
        [self setupSubviews];
    }
    return self;
}

// Load sound files into SoundEffect objects, and hold on to them for later use
- (void)setupSounds {
    NSBundle *mainBundle = [NSBundle mainBundle];

    tickSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"tick" ofType:@"caf"]];
    tockSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"tock" ofType:@"caf"]];
}

// Assemble the interface
- (void)setupSubviews {
    self.backgroundColor = [UIColor blackColor];
    
    // set up front view
    UIImageView *metronomeFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metronomeBody.png"]];
    metronomeFront.center = self.center;
    metronomeFront.opaque = YES;
    
    // set up base (covers bottom of arm)
    UIImageView *metronomeBase = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"base.png"]];
    metronomeBase.center = self.center;
    
    // set up the metronome arm
    metronomeArm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metronomeArm.png"]];
    
    // move the anchor point to the bottom middle of the metronomeArm bounds, so rotations occur around that point
    metronomeArm.layer.anchorPoint = CGPointMake(0.5, 1.0);
    
    CGFloat centerY = self.center.y + (self.bounds.size.height/2);
    metronomeArm.center = CGPointMake(self.center.x, centerY);
    
    // set up the metronome weight
    metronomeWeight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"metronomeWeight.png"]];
    metronomeWeight.center=CGPointMake(self.center.x, centerY);
    
    // set up tempo display
    CGFloat tempoDisplayX = self.center.x - 25.0;
    CGFloat tempoDisplayY = 26.0;
    CGFloat tempoDisplayWidth = 50.0;
    CGFloat tempoDisplayHeight = 18.0;
    
    CGRect tempoRect = CGRectMake(tempoDisplayX, tempoDisplayY, tempoDisplayWidth, tempoDisplayHeight);
    tempoDisplay = [[UILabel alloc] initWithFrame:tempoRect];
    tempoDisplay.font = [UIFont boldSystemFontOfSize:24.0];
    tempoDisplay.backgroundColor = [UIColor clearColor];
    tempoDisplay.textColor = [UIColor colorWithRed:214.0/255.0 green:156.0/255.0 blue:138.0/255.0 alpha:1.0];
    tempoDisplay.textAlignment = UITextAlignmentCenter;
    tempoDisplay.text = [[NSNumber numberWithInteger:self.bpm] stringValue];
    
    // Add 'i' button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(256, 432, 44, 44);
    [infoButton addTarget:metronomeViewController action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
        
    // add view in proper order and location
    [self addSubview:metronomeFront];
    [self addSubview:tempoDisplay];
    [metronomeFront addSubview:metronomeArm];
    [metronomeArm addSubview:metronomeWeight];
    [self addSubview:metronomeBase];
    [self addSubview:infoButton];

    // release views we no longer need to address
    [metronomeFront release];
    [metronomeBase release];
    
    // make sure weight position represents current BPM setting
    [self updateWeightPosition];
}

- (void)dealloc {
    [metronomeArm release];
    [metronomeWeight release];
    [tempoDisplay release];
    [soundPlayerThread release];
    [tickSound release];
    [tockSound release];
    [super dealloc];
}


#pragma mark -
#pragma mark === Touch handling ===
#pragma mark -

// MetronomeView is a "responder" and will receive touch event messages because it implements the follow messages.
// By default, a UIView doesn't handle multi-touch events (see setMultipleTouchEnabled:), which is what we want for
// this simple app.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    lastLocation = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
        
    CGFloat xDisplacement = location.x - lastLocation.x;
    CGFloat yDisplacement = location.y - lastLocation.y;
    CGFloat xDisplacementAbs = fabs(xDisplacement);
    CGFloat yDisplacementAbs = fabs(yDisplacement);

    // If the displacement is vertical, drag the weight up or down. This will impact the speed of the oscillation.
    if ((xDisplacementAbs < yDisplacementAbs) && (yDisplacementAbs > 1)) {  
        [self stopSoundAndArm];
        [self dragWeightByYDisplacement:yDisplacement];
        lastLocation = location;
        tempoChangeInProgress = YES;
    } else if (xDisplacementAbs >= yDisplacementAbs) {  
        // If displacement is horizontal, drag arm left or right. This will start oscillation when the touch ends.
        CGFloat radians = atan2f(location.y - kArmBaseY, location.x - kArmBaseX);
        CGFloat rotation = RadiansToDegrees(radians) + 90.0;
        [self rotateArmToDegree:rotation];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGFloat xDisplacement = location.x - lastLocation.x;
    CGFloat yDisplacement = location.y - lastLocation.y;
    CGFloat xDisplacementAbs = fabs(xDisplacement);
    CGFloat yDisplacementAbs = fabs(yDisplacement);
    
    [self stopSoundAndArm];

    if (tempoChangeInProgress) {  
        [self dragWeightByYDisplacement:yDisplacement];
        [self startSoundAndAnimateArmToRight:YES];
        tempoChangeInProgress = NO;
    } else if (xDisplacementAbs > yDisplacementAbs) {
        // horizontal displacement, start oscillation
        BOOL startToRight = (xDisplacement >= 0.0) ? YES : NO;
        [self startSoundAndAnimateArmToRight:startToRight];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    tempoChangeInProgress = NO;
    [self stopSoundAndArm];
}

#pragma mark -
#pragma mark === Actions ===
#pragma mark -
- (void)updateWeightPosition {
    CGFloat yLocation = WeightYCoordinateForBPM(self.bpm);
    CGPoint weightPosition = metronomeWeight.center;
    CGPoint newPosition = CGPointMake(weightPosition.x, yLocation);
    metronomeWeight.center=newPosition;
    tempoDisplay.text = [NSString stringWithFormat:@"%d", self.bpm];
    [self setNeedsDisplay];
}

- (void)dragWeightByYDisplacement:(CGFloat)yDisplacement {
    CGPoint weightPosition = metronomeWeight.center;
    CGFloat newYPos = weightPosition.y + yDisplacement;
    
    if (newYPos > kLowerWeightLocationLimit) {
        newYPos = kLowerWeightLocationLimit;
    } else if (newYPos < kUpperWeightLocationLimit) {
        newYPos = kUpperWeightLocationLimit;
    }
    
    CGPoint newPosition = CGPointMake(weightPosition.x, newYPos);
    metronomeWeight.center=newPosition;
    
    [self updateBPMFromWeightLocation];

    tempoDisplay.text = [NSString stringWithFormat:@"%d", self.bpm];
    [self setNeedsDisplay];
}

- (void)updateBPMFromWeightLocation {
    CGFloat weightYPosition = metronomeWeight.center.y;
    NSUInteger newBPM = ceil(bpmForWeightYCoordinate(weightYPosition));
    self.bpm = newBPM;
}

- (void)playSound {
    SoundEffect *currentSoundEffect= tickSound;
    MetronomeAppDelegate *appDelegate = (MetronomeAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (beatNumber == 1) {
        currentSoundEffect = tockSound;
    } else if (beatNumber == [appDelegate timeSignature]) {
        beatNumber = 0;
    }
    
    [currentSoundEffect play];
    beatNumber++;
}

// This method is invoked from the driver thread
- (void)startDriverTimer:(id)info {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Give sound thread high priority to keep the timing steady
    [NSThread setThreadPriority:1.0];
    BOOL continuePlaying = YES;
    
    while (continuePlaying) {  // loop until cancelled
        // Use an autorelease pool to prevent the build-up of temporary date objects
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init]; 
        
        [self playSound];
        [self performSelectorOnMainThread:@selector(animateArmToOppositeExtreme) withObject:nil waitUntilDone:NO];
        NSDate *curtainTime = [NSDate dateWithTimeIntervalSinceNow:self.duration];
        NSDate *currentTime = [NSDate date];
        
        // wake up periodically to see if we've been cancelled
        while (continuePlaying && ([currentTime compare:curtainTime] != NSOrderedDescending)) { 
            if ([soundPlayerThread isCancelled] == YES) {
                continuePlaying = NO;
            }
            [NSThread sleepForTimeInterval:0.001];
            currentTime = [NSDate date];
        }
        [loopPool release];
    }
    [pool release];
}

- (void)waitForSoundDriverThreadToFinish {
    while (soundPlayerThread && ![soundPlayerThread isFinished]) { // wait for the thread to finish
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)startDriverThread {
    if (soundPlayerThread != nil) {
        [soundPlayerThread cancel];
        [self waitForSoundDriverThreadToFinish];
    }
    
    NSThread *driverThread = [[NSThread alloc] initWithTarget:self selector:@selector(startDriverTimer:) object:nil];
    self.soundPlayerThread = driverThread;
    [driverThread release];
    
    [self.soundPlayerThread start];
}

- (void)stopDriverThread {
    [self.soundPlayerThread cancel];
    [self waitForSoundDriverThreadToFinish];
    self.soundPlayerThread = nil;
}

#pragma mark -
#pragma mark === Oscillation Animation Starts Here ===
#pragma mark -

// Animation creates a separate thread.
- (void)startSoundAndAnimateArmToRight:(BOOL)startToRight {
    if (armIsAnimating == YES) {
        return;
    }
    
    // start by animating arm to full extent of swing in the swiped direction
    if (startToRight == YES) {
        [self rotateArmToDegree:kDisplacementAngle];
        armIsAtRightExtreme = YES;
    } else {
        [self rotateArmToDegree:-kDisplacementAngle];
        armIsAtRightExtreme = NO;
    }
    
    beatNumber = 1;
    [self startDriverThread];
    armIsAnimating = YES;
}

- (void)stopSoundAndArm {
    [self stopArm:self];
    [self stopDriverThread];
}

- (void)rotateArmToDegree:(CGFloat)positionInDegrees {
    [metronomeArm.layer removeAllAnimations];

    // keep arm from being dragged beyond the maximum displacement
    if (positionInDegrees > kDisplacementAngle) {
        positionInDegrees = kDisplacementAngle;
    } else if (positionInDegrees < -kDisplacementAngle) {
        positionInDegrees = -kDisplacementAngle;
    }

    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform = CATransform3DRotate(rotationTransform, DegreesToRadians(positionInDegrees), 0.0, 0.0, 1.0);
    metronomeArm.layer.transform = rotationTransform;
}

- (void)animateArmToOppositeExtreme {
    int signValue = (armIsAtRightExtreme) ? -1 : 1;
    
    // create rotation animation around z axis
    CABasicAnimation *rotateAnimation = [CABasicAnimation animation];
    rotateAnimation.keyPath = @"transform.rotation.z";
    rotateAnimation.fromValue = [NSNumber numberWithFloat:DegreesToRadians(signValue * -kDisplacementAngle)];
    rotateAnimation.toValue = [NSNumber numberWithFloat:DegreesToRadians(signValue * kDisplacementAngle)];
    rotateAnimation.duration = (self.duration);
    rotateAnimation.removedOnCompletion = NO;
    // leaves presentation layer in final state; preventing snap-back to original state
    rotateAnimation.fillMode = kCAFillModeBoth; 
    rotateAnimation.repeatCount = 0;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // add the animation to the selection layer. This causes it to begin animating. 
    [metronomeArm.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    armIsAnimating = YES;
    armIsAtRightExtreme = (armIsAtRightExtreme) ? NO : YES;
}

- (IBAction)updateAnimation:(id)sender {
    if (armIsAnimating) {
        [self stopSoundAndArm];
        [self startSoundAndAnimateArmToRight:YES];
    }
}

- (void)stopArm:(id)sender {
    if (armIsAnimating == NO) {
        return;
    }
    [self rotateArmToDegree:0.0];
    armIsAnimating = NO;
}

- (void)setBpm:(NSUInteger)bpm {
    if (bpm >= kMaxBPM) {
        bpm = kMaxBPM;
    } else if (bpm <= kMinBPM) {
        bpm = kMinBPM;
    }
    
    self.duration = (60.0 / bpm);
}

- (NSUInteger)bpm {
    return lrint(ceil(60.0 / (self.duration)));
}

@end
