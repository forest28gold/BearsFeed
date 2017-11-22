//
//  BFLoginViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_viewEmail;
@property (strong, nonatomic) IBOutlet UIView *m_viewPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *m_btnLogin;

@end
