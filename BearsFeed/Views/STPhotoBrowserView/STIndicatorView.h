//
//  STIndicatorView.h
//  STPhotoBrowser
//
//  Copyright © 2016 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, STIndicatorViewMode ) {
    STIndicatorViewModeLoopDiagram = 0,
    STIndicatorViewModePieDiagram  = 1
};

@interface STIndicatorView : UIView

@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign)STIndicatorViewMode viewMode;

@end


