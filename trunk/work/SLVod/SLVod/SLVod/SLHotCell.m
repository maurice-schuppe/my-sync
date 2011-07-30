//
//  SLHotCell.m
//  SLVod
//
//  Created by luke on 11-6-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SLHotCell.h"


@implementation SLHotCell

@synthesize imageView, playButton, downButton, playDelegate, downDelegare;
@synthesize titleLabel, progressView;
@synthesize actorLabel, cateLabel;
@synthesize movie;


- (void)dealloc
{
    MLog(@"");
    [downButton release];
    [progressView release];
    [movie release];
    [playButton release];
    [imageView release];
    [titleLabel release];
    [actorLabel release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -

- (void)setMovie:(SLMovie *)theMov
{
    movie = [theMov retain];
    self.titleLabel.text = theMov.title;
    self.actorLabel.text = theMov.actor;
    
    if (theMov.cate) {
        self.cateLabel.text = theMov.cate;
    }
    
    if (theMov.imgRecord && theMov.imgRecord.img) {
        self.imageView.image = theMov.imgRecord.img;
    } else {
        self.imageView.image = nil;
    }
}

- (IBAction)downloadMovPressed:(id)sender
{
    if (downDelegare && [downDelegare respondsToSelector:@selector(download:)]) {
        [downDelegare download:self];
    }
}

- (IBAction)playButtonPressed:(UIButton *)pButton
{
    if (playDelegate && [playDelegate respondsToSelector:@selector(play:)]) {
        [playDelegate play:movie];
    }
}

@end