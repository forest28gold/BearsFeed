//
//  M13ProgressViewBar.h
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewBarPercentagePositionLeft,
    M13ProgressViewBarPercentagePositionRight,
    M13ProgressViewBarPercentagePositionTop,
    M13ProgressViewBarPercentagePositionBottom,
} M13ProgressViewBarPercentagePosition;

typedef enum {
    M13ProgressViewBarProgressDirectionLeftToRight,
    M13ProgressViewBarProgressDirectionBottomToTop,
    M13ProgressViewBarProgressDirectionRightToLeft,
    M13ProgressViewBarProgressDirectionTopToBottom
} M13ProgressViewBarProgressDirection;

/**A replacement for UIProgressBar.*/
@interface M13ProgressViewBar : M13ProgressView

/**@name Appearance*/
/**The direction of progress. (What direction the fill proceeds in.)*/
@property (nonatomic, assign) M13ProgressViewBarProgressDirection progressDirection;
/**The thickness of the progress bar.*/
@property (nonatomic, assign) CGFloat progressBarThickness;
/**The corner radius of the progress bar.*/
@property (nonatomic, assign) CGFloat progressBarCornerRadius;
/**@name Actions*/
/**The color the bar changes to for the success action.*/
@property (nonatomic, retain) UIColor *successColor;
/**The color the bar changes to for the failure action.*/
@property (nonatomic, retain) UIColor *failureColor;
/**@name Percentage*/
/**Wether or not to show percentage text. If shown exterior to the progress bar, the progress bar is shifted to make room for the text.*/
@property (nonatomic, assign) BOOL showPercentage;
/**The location of the percentage in comparison to the progress bar.*/
@property (nonatomic, assign) M13ProgressViewBarPercentagePosition percentagePosition;

@end
