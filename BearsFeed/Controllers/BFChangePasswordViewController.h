//
//  BFChangePasswordViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/23/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFChangePasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_viewCurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtCurrentPassword;
@property (strong, nonatomic) IBOutlet UIView *m_viewNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtNewPassword;
@property (strong, nonatomic) IBOutlet UIView *m_viewConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtConfirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *m_btnSave;

@end
