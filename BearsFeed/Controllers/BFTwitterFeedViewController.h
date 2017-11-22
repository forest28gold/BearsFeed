//
//  BFTwitterFeedViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"

@interface BFTwitterFeedViewController : UIViewController

@property (nonatomic, strong) ViewPagerController *viewPagerCtrl;

@property (strong, nonatomic) IBOutlet UIView *m_viewTab;
@property (strong, nonatomic) IBOutlet UIButton *m_btnHome;
@property (strong, nonatomic) IBOutlet UIButton *m_btnUser;

- (void)goToPhotoView;
- (void)goToPostLink;

@end
