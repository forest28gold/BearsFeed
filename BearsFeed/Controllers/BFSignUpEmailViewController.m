//
//  BFSignUpEmailViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFSignUpEmailViewController.h"
#import "BFSignUpPasswordViewController.h"

@interface BFSignUpEmailViewController ()

@end

@implementation BFSignUpEmailViewController

@synthesize m_btnContinue, m_txtEmail, m_viewEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewEmail.layer.cornerRadius = BUTTON_RADIUS;
    m_btnContinue.layer.cornerRadius = BUTTON_RADIUS;
    m_viewEmail.layer.borderWidth = 1.0f;
    m_viewEmail.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
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
    if (textField == m_txtEmail) {
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
    
    NSString *strUserName = m_txtEmail.text;
    NSString *strEmail = [NSString stringWithFormat:@"%@%@", strUserName, BEARSFEED_EMAIL];
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strUserName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input email."];
        return;
    } else if(![emailTest evaluateWithObject:strEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input email exactly."];
        return;
    }
    
    [GlobalData sharedGlobalData].g_strEmail = strEmail;
    
    BFSignUpPasswordViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_PASSWORD];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

@end
