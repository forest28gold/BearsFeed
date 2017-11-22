//
//  BFSignUpNameViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSignUpNameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_viewFirstName;
@property (strong, nonatomic) IBOutlet UIView *m_viewLastName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtLastName;
@property (strong, nonatomic) IBOutlet UIButton *m_btnContinue;

@end
