//
//  BFSignUpPasswordViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFSignUpPasswordViewController.h"
#import "BFSignUpBioViewController.h"

@interface BFSignUpPasswordViewController ()

@end

@implementation BFSignUpPasswordViewController

@synthesize m_btnContinue, m_txtPassword, m_viewPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewPassword.layer.cornerRadius = BUTTON_RADIUS;
    m_btnContinue.layer.cornerRadius = BUTTON_RADIUS;
    m_viewPassword.layer.borderWidth = 1.0f;
    m_viewPassword.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_txtPassword) {
        [self dismissKeyboard];
        [self onContinue:textField];
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

- (IBAction)onContinue:(id)sender {
    
    NSString *strPassword = m_txtPassword.text;
    
    if ([strPassword isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input password."];
        return;
    } else if (strPassword.length < 6) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Password can not be less than 6 characters."];
        return;
    }
    
    [GlobalData sharedGlobalData].g_strPassword = strPassword;
    
    BFSignUpBioViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_BIO];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

@end
