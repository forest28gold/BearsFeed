//
//  BFChangePasswordViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/23/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFChangePasswordViewController.h"

@interface BFChangePasswordViewController ()

@end

@implementation BFChangePasswordViewController

@synthesize m_btnSave, m_txtNewPassword, m_viewNewPassword, m_txtConfirmPassword;
@synthesize m_txtCurrentPassword, m_viewConfirmPassword, m_viewCurrentPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [m_txtCurrentPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtNewPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [m_txtConfirmPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [m_btnSave setEnabled:false];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewCurrentPassword.layer.cornerRadius = BUTTON_RADIUS;
    m_viewNewPassword.layer.cornerRadius = BUTTON_RADIUS;
    m_viewConfirmPassword.layer.cornerRadius = BUTTON_RADIUS;
    m_btnSave.layer.cornerRadius = BUTTON_RADIUS;
    m_viewCurrentPassword.layer.borderWidth = 1.0f;
    m_viewCurrentPassword.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
    m_viewNewPassword.layer.borderWidth = 1.0f;
    m_viewNewPassword.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
    m_viewConfirmPassword.layer.borderWidth = 1.0f;
    m_viewConfirmPassword.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField == m_txtCurrentPassword) {
        
        if (![m_txtNewPassword.text isEqualToString:@""] && ![m_txtConfirmPassword.text isEqualToString:@""]) {
            if (![m_txtCurrentPassword.text isEqualToString:@""]) {
                [m_btnSave setEnabled:true];
            } else {
                [m_btnSave setEnabled:false];
            }
        } else {
            [m_btnSave setEnabled:false];
        }
        
    } else if (textField == m_txtNewPassword) {
        
        if (![m_txtCurrentPassword.text isEqualToString:@""] && ![m_txtConfirmPassword.text isEqualToString:@""]) {
            if (![m_txtNewPassword.text isEqualToString:@""]) {
                [m_btnSave setEnabled:true];
            } else {
                [m_btnSave setEnabled:false];
            }
        } else {
            [m_btnSave setEnabled:false];
        }
        
    } else if (textField == m_txtConfirmPassword) {
        
        if (![m_txtCurrentPassword.text isEqualToString:@""] && ![m_txtNewPassword.text isEqualToString:@""]) {
            if (![m_txtConfirmPassword.text isEqualToString:@""]) {
                [m_btnSave setEnabled:true];
            } else {
                [m_btnSave setEnabled:false];
            }
        } else {
            [m_btnSave setEnabled:false];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_txtCurrentPassword) {
        [m_txtNewPassword becomeFirstResponder];
    } else if (textField == m_txtNewPassword) {
        [m_txtConfirmPassword becomeFirstResponder];
    } else if (textField == m_txtConfirmPassword) {
        [self dismissKeyboard];
        [self onSave:textField];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
    
    NSString *strCurrentPassword = m_txtCurrentPassword.text;
    NSString *strNewPassword = m_txtNewPassword.text;
    NSString *strConfirmPassword = m_txtConfirmPassword.text;
    
    if ([strCurrentPassword isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input current password."];
        return;
    } else if (![strCurrentPassword isEqualToString:[GlobalData sharedGlobalData].g_userData.password]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"The current password is not correct. Please input current password again."];
        return;
    }else if ([strNewPassword isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input new password."];
        return;
    } else if (strNewPassword.length < 6) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Password can not be less than 6 characters."];
        return;
    } else if (![strNewPassword isEqualToString:strConfirmPassword]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Password is not match. Please input confirm password again."];
        m_txtConfirmPassword.text = @"";
        return;
    }
    
    [self dismissKeyboard];
    
    [[GlobalData sharedGlobalData].g_currentUser setPassword:strNewPassword];
    [backendless.userService update:[GlobalData sharedGlobalData].g_currentUser response:^(BackendlessUser *user) {
        
        [GlobalData sharedGlobalData].g_currentUser = user;
        
        SVPROGRESSHUD_SUCCESS(@"Password changed succeesfully.");
        
        [GlobalData sharedGlobalData].g_userData.password = strNewPassword;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Change password is failed. Please try again."];
    }];
}

@end
