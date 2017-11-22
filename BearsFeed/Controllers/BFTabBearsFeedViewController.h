//
//  BFTabBearsFeedViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"

@interface BFTabBearsFeedViewController : UIViewController

@property (nonatomic, strong) ViewPagerController *viewPagerCtrl;

@property (strong, nonatomic) IBOutlet UIView *m_viewTab;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNewest;
@property (strong, nonatomic) IBOutlet UIButton *m_btnMostCommented;
@property (strong, nonatomic) IBOutlet UIButton *m_btnMostVotes;

@end
