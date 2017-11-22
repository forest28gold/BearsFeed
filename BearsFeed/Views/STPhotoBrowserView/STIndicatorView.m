//
//  STIndicatorView.m
//  STPhotoBrowser
//
//  Copyright © 2016 ST. All rights reserved.
//

#import "STIndicatorView.h"
#import "STConfig.h"

static CGFloat const WidthIndicator = 42;

@implementation STIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(255, 255, 255, 0.7);
        self.clipsToBounds = YES;
        self.viewMode = STIndicatorViewModeLoopDiagram;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];

    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = WidthIndicator;
    frame.size.height = WidthIndicator;
    self.layer.cornerRadius = WidthIndicator / 2;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef content = UIGraphicsGetCurrentContext();

    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    [[UIColor whiteColor] set];
    
    switch (self.viewMode) {
        case STIndicatorViewModeLoopDiagram:
        {
            CGContextSetLineWidth(content, 2);
            CGContextSetLineCap(content, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05;
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - STMargin;
            CGContextAddArc(content, centerX, centerY, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(content);}
            break;
        default:
        {
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - STMarginSmall;
            
            CGFloat contentW = radius * 2 + STMargin;
            CGFloat contentH = contentW;
            CGFloat contentX = (rect.size.width - contentW) * 0.5;
            CGFloat contentY = (rect.size.height - contentH) * 0.5;
            CGContextAddEllipseInRect(content, CGRectMake(contentX, contentY, contentW, contentH));
            CGContextFillPath(content);
            
            [[UIColor lightGrayColor] set];
            CGContextMoveToPoint(content, centerX, centerY);
            CGContextAddLineToPoint(content, centerX, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001;
            CGContextAddArc(content, centerX, centerY, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(content);
            
            CGContextFillPath(content);
        }
            break;
    }
}
@end
