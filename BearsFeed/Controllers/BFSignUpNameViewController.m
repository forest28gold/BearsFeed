//
//  BFSignUpNameViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFSignUpNameViewController.h"
#import "BFSignUpEmailViewController.h"

@interface BFSignUpNameViewController ()

@end

@implementation BFSignUpNameViewController

@synthesize m_viewFirstName, m_viewLastName, m_btnContinue, m_txtLastName, m_txtFirstName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewFirstName.layer.cornerRadius = BUTTON_RADIUS;
    m_viewLastName.layer.cornerRadius = BUTTON_RADIUS;
    m_btnContinue.layer.cornerRadius = BUTTON_RADIUS;
    m_viewFirstName.layer.borderWidth = 1.0f;
    m_viewFirstName.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
    m_viewLastName.layer.borderWidth = 1.0f;
    m_viewLastName.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
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
    if (textField == m_txtFirstName) {
        [m_txtLastName becomeFirstResponder];
    } else if (textField == m_txtLastName) {
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
    
    NSString *strFirstName = m_txtFirstName.text;
    NSString *strLastName = m_txtLastName.text;
    
    if ([strFirstName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input first name."];
        return;
    } else if ([strLastName isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input last name."];
        return;
    }
    
    [GlobalData sharedGlobalData].g_strName = [NSString stringWithFormat:@"%@ %@", strFirstName, strLastName];
    
    BFSignUpEmailViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_EMAIL];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

@end
