//
//  LLTabBarItem.m
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import "LLTabBarItem.h"

@implementation LLTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self config];
	}
	
	return self;
}

- (instancetype)init {
	self = [super init];
	
	if (self) {
		[self config];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self config];
	}
	
	return self;
}

- (void)config {
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self.titleLabel sizeToFit];
	CGSize titleSize = self.titleLabel.frame.size;

	CGSize imageSize = [self imageForState:UIControlStateNormal].size;
	if (imageSize.width != 0 && imageSize.height != 0) {
		CGFloat imageViewCenterY = CGRectGetHeight(self.frame) - 3 - titleSize.height - imageSize.height / 2 - 5;
		self.imageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, imageViewCenterY);
	} else {
		CGPoint imageViewCenter = self.imageView.center;
		imageViewCenter.x = CGRectGetWidth(self.frame) / 2;
		imageViewCenter.y = (CGRectGetHeight(self.frame) - titleSize.height) / 2;
		self.imageView.center = imageViewCenter;
	}
	
	CGPoint labelCenter = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 3 - titleSize.height / 2);
	self.titleLabel.center = labelCenter;
}

- (void)setHighlighted:(BOOL)highlighted{
  // do not anything  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
