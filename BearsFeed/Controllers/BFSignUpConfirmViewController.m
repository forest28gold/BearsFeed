//
//  BFSignUpConfirmViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/31/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFSignUpConfirmViewController.h"
#import "BFTabBarViewController.h"

@interface BFSignUpConfirmViewController ()

@end

@implementation BFSignUpConfirmViewController

@synthesize m_txtCode, m_viewCode, m_btnConfirm;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewCode.layer.cornerRadius = BUTTON_RADIUS;
    m_btnConfirm.layer.cornerRadius = BUTTON_RADIUS;
    m_btnConfirm.layer.borderWidth = 1.0f;
    m_btnConfirm.layer.borderColor = [UIColor whiteColor].CGColor;

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
    if (textField == m_txtCode) {
        [self dismissKeyboard];
        [self onConfirmVerification:textField];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onBack:(id)sender {
    [self performSegueWithIdentifier:UNWIND_VERIFY sender:nil];
}

- (IBAction)onResendEmail:(id)sender {
    [self sendVerificationEmail:[GlobalData sharedGlobalData].g_userData.email];
}

- (IBAction)onConfirmVerification:(id)sender {
    
    NSString *strCode = m_txtCode.text;
    
    if ([strCode isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input verification code."];
        return;
    } else if(![strCode isEqualToString:[GlobalData sharedGlobalData].g_userData.verificationCode]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Invalid verification code."];
        return;
    }
    
    [self dismissKeyboard];
    
    
    SVPROGRESSHUD_SHOW;
    
    [[GlobalData sharedGlobalData].g_currentUser setProperty:KEY_VERIFY object:USER_VERIFY];
    [backendless.userService update:[GlobalData sharedGlobalData].g_currentUser response:^(BackendlessUser *user) {
        
        NSString *strDeviceId = [user getProperty:KEY_DEVICE_ID];
        
        if ([strDeviceId isEqual:[NSNull null]]) {
            
            [GlobalData sharedGlobalData].g_userData.deviceId = [GlobalData sharedGlobalData].g_deviceID;
            [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [user setProperty:KEY_DEVICE_ID object:[GlobalData sharedGlobalData].g_deviceID];
                [backendless.userService update:user response:^(BackendlessUser *user) {
                    NSLog(@"Update DeviceId is succeed.");
                    [GlobalData sharedGlobalData].g_currentUser = user;
                } error:^(Fault *fault) {
                    NSLog(@"Update DeviceId Failed, = %@ <%@>", fault.message, fault.detail);
                }];
            });
            
        } else {
            
            if ([strDeviceId isEqualToString:[GlobalData sharedGlobalData].g_deviceID]) {
                
                [GlobalData sharedGlobalData].g_userData.deviceId = strDeviceId;
                [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                
                [GlobalData sharedGlobalData].g_currentUser = user;
                
            } else {
                
                [GlobalData sharedGlobalData].g_userData.deviceId = [GlobalData sharedGlobalData].g_deviceID;
                [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [user setProperty:KEY_DEVICE_ID object:[GlobalData sharedGlobalData].g_deviceID];
                    [backendless.userService update:user response:^(BackendlessUser *user) {
                        NSLog(@"Update DeviceId is succeed.");
                        [GlobalData sharedGlobalData].g_currentUser = user;
                    } error:^(Fault *fault) {
                        NSLog(@"Update DeviceId Failed, = %@ <%@>", fault.message, fault.detail);
                    }];
                });
            }
        }
        
        SVPROGRESSHUD_DISMISS;
        
        BFTabBarViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_TAB];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Verification is failed. Please try again."];
    }];
}

- (void)sendVerificationEmail:(NSString*)strEmail {
    
    SVPROGRESSHUD_SHOW;
    
    int randomID = arc4random() % 900000 + 100000;
    NSString *strCode = [NSString stringWithFormat:@"%i", randomID];
    
    NSString *subject = mail_verification_email;
    NSString *body = [NSString stringWithFormat:@"%@%@%@", mail_verification_email_body1, strCode, mail_verification_email_body2];
    
    [backendless.messagingService sendHTMLEmail:subject body:body to:@[strEmail] response:^(id result) {
        
        NSLog(@"ASYNC: HTML email has been sent");
        
        SVPROGRESSHUD_SUCCESS(@"We have just sent an email with a verification code. Please check your email.");
        
        [GlobalData sharedGlobalData].g_userData.verificationCode = strCode;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
    } error:^(Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Email sending is failed. Please try again."];
    }];
}


@end
