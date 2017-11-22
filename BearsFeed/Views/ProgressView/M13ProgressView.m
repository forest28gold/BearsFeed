//
//  M13ProgressView.m
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import "M13ProgressView.h"

@implementation M13ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _progress = progress;
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    //To be overriden in subclasses
}

@end
