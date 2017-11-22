//
//  BFMainViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *m_btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *m_btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *m_btnFacebook;
@property (strong, nonatomic) IBOutlet UIView *m_viewLoading;
@property (strong, nonatomic) IBOutlet UIView *m_viewNoNetwork;
@property (strong, nonatomic) IBOutlet UIButton *m_btnTryAgain;

- (IBAction)unwindLogOut:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindVerify:(UIStoryboardSegue *)unwindSegue;

@end
