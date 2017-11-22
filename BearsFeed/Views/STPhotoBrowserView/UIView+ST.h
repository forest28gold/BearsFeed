//
//  UIView+ST.h
//  STPhotoBrowser
//
//  Copyright © 2016 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ST)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;


- (UIView *)getParsentView:(UIView *)view;
@end

