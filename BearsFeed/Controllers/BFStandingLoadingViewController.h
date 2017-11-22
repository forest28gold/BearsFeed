//
//  BFStandingLoadingViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 4/27/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewBar.h"

@interface BFStandingLoadingViewController : UIViewController

@property (nonatomic, retain) IBOutlet M13ProgressViewBar *m_progressViewBar;
@property (strong, nonatomic) IBOutlet UILabel *m_lblScore;

@property (strong, nonatomic) IBOutlet UILabel *m_lblSuccess;
@property (strong, nonatomic) IBOutlet UIButton *m_btnRestart;
@property (strong, nonatomic) IBOutlet UIButton *m_btnEnd;
@property (strong, nonatomic) IBOutlet UIView *m_viewRestart;
@property (strong, nonatomic) IBOutlet UIView *m_viewLoading;

- (IBAction)unwindBearStanding:(UIStoryboardSegue *)unwindSegue;

@end
