//
//  BubbleAnimationView.m
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BubbleAnimationView.h"
#import "BubbleConfig.h"
#import "BubbleInfo.h"

#define TITLE_TAG 100
#define SUBTITLE_TAG 101
#define IMAGE_TAG 102
#define VIEW_TAG 103

#define ZOOM_ANIMATION_DURATION 0.3

@interface BubbleAnimationView ()
{
    NSInteger previousIndex;
}

@property(nonatomic, strong) NSArray *bubbleInfoArray;
@property(nonatomic, strong) NSMutableArray *bubbleViewsArray;
@property (nonatomic ,strong) NSTimer *animationTimer;

@property (nonatomic, strong) UIView *selectedBubbleView;
@property (nonatomic, strong) UIView *overlayBubbleView;

@property (strong, nonatomic) UIView *bubbleContainerView;

@property (nonatomic, strong) UITapGestureRecognizer *tapOutsideDismiss;

@end

@implementation BubbleAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}

#pragma mark
#pragma mark Private Methods

- (void)addGestureForTapOutside
{
    self.tapOutsideDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutSideDismiss:)];
    self.tapOutsideDismiss.numberOfTapsRequired = 1;
    [self.bubbleContainerView addGestureRecognizer:self.tapOutsideDismiss];
    [self.tapOutsideDismiss setEnabled:NO];
}

- (void)animateBuubleViews
{
    self.backgroundColor = [UIColor colorWithHexString:@"77000000"];
    self.alpha = 1;
    
    self.bubbleContainerView = [[UIView alloc] initWithFrame:self.frame];
    self.bubbleContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bubbleContainerView];
    
    [self addGestureForTapOutside];
    
    [self addBubbleViews];
}

- (void)addBubbleViews {
    
    previousIndex = 0;
    
    self.bubbleInfoArray = [BubbleConfig getBubbleInfoArray];
    
    self.bubbleViewsArray = [NSMutableArray array];
    
    for (BubbleInfo *info in self.bubbleInfoArray) {
        
        UIView *bubbleView = [[UIView alloc] initWithFrame:info.frame];
        bubbleView.layer.cornerRadius = bubbleView.frame.size.width / 2;
        bubbleView.clipsToBounds = YES;
        bubbleView.backgroundColor = info.bgColor;
        bubbleView.tag = [self.bubbleInfoArray indexOfObject:info];
        
        UIImageView *imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, bubbleView.frame.size.width-6, bubbleView.frame.size.height-6)];
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2;
        imgAvatar.contentMode = UIViewContentModeScaleToFill;
        imgAvatar.clipsToBounds = YES;
        imgAvatar.tag = IMAGE_TAG;
        
        NSURL *imageAvatarURL = [NSURL URLWithString:[info.targetUser getProperty:KEY_PHOTO_URL]];
        [imgAvatar setShowActivityIndicatorView:YES];
        [imgAvatar setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [imgAvatar sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        [bubbleView addSubview:imgAvatar];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, bubbleView.frame.size.height*0.7, bubbleView.frame.size.width, bubbleView.frame.size.height*0.7)];
        titleView.backgroundColor = [UIColor colorWithHexString:@"88000000"];
        titleView.tag = VIEW_TAG;
        
        [bubbleView addSubview:titleView];
        
        // Title Label
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, bubbleView.frame.size.height/2, bubbleView.frame.size.width-10, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        titleLabel.text = [info.targetUser getProperty:KEY_SCORE];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:info.titleFontSize];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = TITLE_TAG;
        
        [bubbleView addSubview:titleLabel];
        
        [self.bubbleContainerView addSubview:bubbleView];
        
        [BubbleConfig addTapGestureToView:bubbleView target:self selector:@selector(onTapBubbleViews:)];
        
        [self.bubbleViewsArray addObject:bubbleView];
    }
    
    for (UIView *view in self.bubbleViewsArray) {
        view.userInteractionEnabled = NO;
        view.hidden = YES;
    }
    
    [self performSelector:@selector(animateBubbleViews:) withObject:nil afterDelay:0.2];
}

- (void)animateBubbleViews:(id)sender
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSingleBubble:) userInfo:nil repeats:YES];
}

- (void)animateSingleBubble:(id)snder
{
    if (previousIndex < self.bubbleViewsArray.count) {
        UIView *view = [self.bubbleViewsArray objectAtIndex:previousIndex ++];
        view.hidden = NO;
        [self animateView:view];
    } else {
        [self.animationTimer invalidate];
        for (UIView *view in self.bubbleViewsArray) {
            view.userInteractionEnabled = YES;
        }
    }
}

- (void)animateView:(UIView *)view
{
    view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.30 initialSpringVelocity:5.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (CGFloat)getScalingfactor
{
    CGFloat viewWidth = self.selectedBubbleView.frame.size.width;
    
    return 200.0/viewWidth;
}

-(void)springAnimationOnBubble:(CGFloat)matrixVal
                       zoomVal:(CGFloat)zoomVal
                      movement:(BOOL)movement
                     iteration:(NSInteger)iteration
{
    if(zoomVal >= ZOOM_ANIMATION_DURATION / 10)
    {
        [UIView animateWithDuration:zoomVal animations:^{
            self.selectedBubbleView.transform = CGAffineTransformMakeScale(self.selectedBubbleView.transform.a-matrixVal, self.selectedBubbleView.transform.d-matrixVal);
        } completion:^(BOOL finished) {
            
            CGFloat matrixValue = !movement ? -(matrixVal * 0.5) : -(matrixVal);
            NSInteger iter =  iteration + 1;
            [self springAnimationOnBubble:matrixValue
                                  zoomVal:ZOOM_ANIMATION_DURATION /(iter+1)
                                 movement:!movement
                                iteration:iter];
        }];
        
    }
    else
    {
        [self.tapOutsideDismiss setEnabled:YES];
    }
}

- (void)onTapBubbleViews:(UITapGestureRecognizer *)recognizer
{
    self.selectedBubbleView = recognizer.view;
    
    for (UIView *view in self.bubbleViewsArray) {
        if (view.tag != self.selectedBubbleView.tag) {
            view.hidden = YES;
        }
    }
    
    [self.bubbleContainerView bringSubviewToFront:self.selectedBubbleView];
    
    [UIView animateWithDuration:ZOOM_ANIMATION_DURATION animations:^{
        self.selectedBubbleView.transform = CGAffineTransformMakeScale([self getScalingfactor]+1, [self getScalingfactor]+1);
        self.selectedBubbleView.center = self.bubbleContainerView.center;
        UILabel *label = (UILabel *)[self.selectedBubbleView viewWithTag:TITLE_TAG];
        label.alpha = 0.0;
        UIImageView *imageView = (UIImageView *)[self.selectedBubbleView viewWithTag:IMAGE_TAG];
        imageView.alpha = 0.0;
        UIView *view = (UIView *)[self.selectedBubbleView viewWithTag:VIEW_TAG];
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self springAnimationOnBubble:1
                              zoomVal:ZOOM_ANIMATION_DURATION / 2
                             movement:FALSE
                            iteration:1];
        
        self.overlayBubbleView = [[UIView alloc] initWithFrame:self.selectedBubbleView.frame];
        self.overlayBubbleView.layer.cornerRadius = self.overlayBubbleView.frame.size.width / 2;
        self.overlayBubbleView.clipsToBounds = YES;
        self.overlayBubbleView.backgroundColor = self.selectedBubbleView.backgroundColor;
        
        BubbleInfo *data = [self.bubbleInfoArray objectAtIndex:self.selectedBubbleView.tag];
        
        UIImageView *imgAvatar = [[UIImageView alloc] init];
        imgAvatar.frame = CGRectMake(4, 4, self.overlayBubbleView.frame.size.width-8, self.overlayBubbleView.frame.size.height-8);
        imgAvatar.contentMode = UIViewContentModeScaleToFill;
        imgAvatar.clipsToBounds = YES;
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2;
        imgAvatar.tag = IMAGE_TAG;
        
        NSURL *imageAvatarURL = [NSURL URLWithString:[data.targetUser getProperty:KEY_PHOTO_URL]];
        [imgAvatar setShowActivityIndicatorView:YES];
        [imgAvatar setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [imgAvatar sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        [self.overlayBubbleView addSubview:imgAvatar];
        
        [self.bubbleContainerView addSubview:self.overlayBubbleView];
        self.overlayBubbleView.alpha = 0.0;
        
        // title label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = data.targetUser.name;
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:25.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = TITLE_TAG;
        titleLabel.frame = CGRectMake(0, self.overlayBubbleView.frame.origin.y-120, [UIScreen mainScreen].bounds.size.width, 60);
        
        [self.bubbleContainerView addSubview:titleLabel];
        titleLabel.alpha = 0.0;
        
        // Subtitle Label
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.text = [NSString stringWithFormat:@"Score : %@", [data.targetUser getProperty:KEY_SCORE]];
        subTitleLabel.numberOfLines = 1;
        subTitleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:18.0];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.tag = SUBTITLE_TAG;
        subTitleLabel.alpha = 0.6;
        subTitleLabel.frame = CGRectMake(0, self.overlayBubbleView.frame.origin.y-70, [UIScreen mainScreen].bounds.size.width, 60);
        
        [self.bubbleContainerView addSubview:subTitleLabel];
        subTitleLabel.alpha = 0.0;
        
        UIButton *btnEliminate = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-220)/2, self.overlayBubbleView.frame.origin.y+self.overlayBubbleView.frame.size.height+50, 220, 40)];
        [btnEliminate setBackgroundColor:[UIColor colorWithHexString:@"2ecc71"]];
        [btnEliminate setTitle:@"ELIMINATE!" forState:UIControlStateNormal];
        btnEliminate.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:12];
        [btnEliminate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnEliminate.layer.cornerRadius = BUTTON_RADIUS;
        
        [btnEliminate addTarget:self action:@selector(onEliminateTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bubbleContainerView addSubview:btnEliminate];
        btnEliminate.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.overlayBubbleView.alpha = 1.0;
            titleLabel.alpha = 1.0;
            subTitleLabel.alpha = 1.0;
            btnEliminate.alpha = 1.0;
        }completion:^(BOOL finished) {
        }];
    }];
}

- (void)tapOutSideDismiss:(UITapGestureRecognizer *)recognizer
{
    [self.tapOutsideDismiss setEnabled:NO];
    [self.overlayBubbleView removeFromSuperview];
    
    NSArray *viewsToRemove = [self.bubbleContainerView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [self addBubbleViews];
}

-(void)onEliminateTarget:(id)sender {
    
    [self.tapOutsideDismiss setEnabled:NO];
    [self.overlayBubbleView removeFromSuperview];
    
    NSArray *viewsToRemove = [self.bubbleContainerView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [GlobalData sharedGlobalData].g_targetUser = [GlobalData sharedGlobalData].g_arrayTarget[self.selectedBubbleView.tag];
    
    if ([GlobalData sharedGlobalData].g_arrayTarget.count == 1) {
        [GlobalData sharedGlobalData].g_arrayTarget = [[NSMutableArray alloc] init];
        [[GlobalData sharedGlobalData].g_ctrlEliminatedTarget onEliminateLastTarget];
    } else {
        [[GlobalData sharedGlobalData].g_ctrlEliminatedTarget onEliminateTarget];
        [[GlobalData sharedGlobalData].g_arrayTarget removeObjectAtIndex:self.selectedBubbleView.tag];
        [self addBubbleViews];
    }
}

@end
