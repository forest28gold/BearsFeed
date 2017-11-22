//
//  AutoFormatter.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AutoFormatter.h"

@implementation AutoFormatter

@synthesize SCALE_X;
@synthesize SCALE_Y;

static AutoFormatter *instance = nil;

+(AutoFormatter *)getInstance
{
    @synchronized( self )
    {
        if ( instance == nil )
        {
            instance = [AutoFormatter new];
            
            instance.SCALE_X = ((float)[UIScreen mainScreen].applicationFrame.size.width) / 320.0f;
            instance.SCALE_Y = ((float)[UIScreen mainScreen].applicationFrame.size.height ) / 548.0f;
        }
    }
    return( instance );
}

- (void) initTextFldType:(UITextField*)_textFld placeholder:(NSString*)_txt
{
    UIColor *color = [UIColor grayColor];
    
    _textFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txt attributes:@{NSForegroundColorAttributeName: color}];
}

- (void) resizeView:(UIView*)__view
{
    NSArray* _subViews = [__view subviews];
    for (UIView *subView in _subViews) {
//        NSLog(@"%@", subView);
        
        [self resizeView:subView];
        
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)subView;
            //NSString* strTemp = button.titleLabel.text;
            CGFloat fontSize = button.titleLabel.font.pointSize;
            
            button.titleLabel.font = [UIFont fontWithName:button.titleLabel.font.fontName size:fontSize * SCALE_Y];
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel* button = (UILabel*)subView;
            //NSString* strTemp = button.titleLabel.text;
            CGFloat fontSize = button.font.pointSize;
            
            button.font = [UIFont fontWithName:button.font.fontName size:fontSize * SCALE_Y];
            
        }
        
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField* button = (UITextField*)subView;
            //NSString* strTemp = button.titleLabel.text;
            CGFloat fontSize = button.font.pointSize;
            
             button.font = [UIFont fontWithName:button.font.fontName size:fontSize * SCALE_Y];
            
            //button.adjustsFontSizeToFitWidth = true;
            //button.minimumFontSize = ;
            
        }
        
        [subView setFrame:CGRectMake(subView.frame.origin.x * SCALE_X, subView.frame.origin.y * SCALE_Y, subView.frame.size.width * SCALE_X , subView.frame.size.height * SCALE_Y)];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
