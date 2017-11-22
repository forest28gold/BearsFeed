//
//  M13ProgressView.h
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /**Resets the action and returns the progress view to its normal state.*/
    M13ProgressViewActionNone,
    /**The progress view shows success.*/
    M13ProgressViewActionSuccess,
    /**The progress view shows failure.*/
    M13ProgressViewActionFailure
} M13ProgressViewAction;

/**A standardized base upon which to build progress views for applications. This allows one to use any subclass progress view in any component that use this standard.*/
@interface M13ProgressView : UIView

/**@name Appearance*/
/**The primary color of the `M13ProgressView`.*/
@property (nonatomic, retain) UIColor *primaryColor;
/**The secondary color of the `M13ProgressView`.*/
@property (nonatomic, retain) UIColor *secondaryColor;

/**@name Properties*/
/**Wether or not the progress view is indeterminate.*/
@property (nonatomic, assign) BOOL indeterminate;
/**The durations of animations in seconds.*/
@property (nonatomic, assign) CGFloat animationDuration;
/**The progress displayed to the user.*/
@property (nonatomic, readonly) CGFloat progress;

/**@name Actions*/
/**Set the progress of the `M13ProgressView`.
 @param progress The progress to show on the progress view.
 @param animated Wether or not to animate the progress change.*/
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
/**Perform the given action if defined. Usually showing success or failure.
 @param action The action to perform.
 @param animated Wether or not to animate the change*/
- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated;

@end
