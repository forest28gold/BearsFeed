//
//  BFLoginViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFLoginViewController.h"
#import "BFTabBarViewController.h"
#import "BFForgetPasswordViewController.h"
#import "BFSignUpNameViewController.h"
#import "BFSignUpConfirmViewController.h"

@interface BFLoginViewController ()

@end

@implementation BFLoginViewController

@synthesize m_txtPassword, m_txtEmail, m_viewEmail, m_btnLogin, m_viewPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewEmail.layer.cornerRadius = BUTTON_RADIUS;
    m_viewPassword.layer.cornerRadius = BUTTON_RADIUS;
    m_btnLogin.layer.cornerRadius = BUTTON_RADIUS;
    m_btnLogin.layer.borderWidth = 1.0f;
    m_btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
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
        [m_txtPassword becomeFirstResponder];
    } else if (textField == m_txtPassword) {
        [self dismissKeyboard];
        [self onLogin:textField];
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

- (IBAction)onSignUp:(id)sender {
    
    BFSignUpNameViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_NAME];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onForgetPassword:(id)sender {
    
    BFForgetPasswordViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_FORGET_PASSWORD];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onLogin:(id)sender {
    
    NSString *strEmail = m_txtEmail.text;
    NSString *strPassword = m_txtPassword.text;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input email."];
        return;
    } else if(![emailTest evaluateWithObject:strEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input email exactly."];
        return;
    } else if ([strPassword isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input password."];
        return;
    }
    
    [self dismissKeyboard];
    
    [self login:strEmail password:strPassword];
}

- (void)login:(NSString*)email password:(NSString*)password {
    
    SVPROGRESSHUD_SHOW;
    
    [backendless.userService login:email password:password response:^(BackendlessUser *user) {
        
        NSLog(@"user = %@", user);

        [GlobalData sharedGlobalData].g_userData = [[UserData alloc] init];
        [GlobalData sharedGlobalData].g_userData.userId = user.objectId;
        [GlobalData sharedGlobalData].g_userData.userName = user.name;
        [GlobalData sharedGlobalData].g_userData.email = user.email;
        [GlobalData sharedGlobalData].g_userData.password = password;
        [GlobalData sharedGlobalData].g_userData.bio = [user getProperty:KEY_BIO];
        [GlobalData sharedGlobalData].g_userData.photoUrl = [user getProperty:KEY_PHOTO_URL];
        [GlobalData sharedGlobalData].g_userData.signup = USER_SIGNUP;
        [GlobalData sharedGlobalData].g_userData.socialRole = [user getProperty:KEY_SOCIAL];
        [GlobalData sharedGlobalData].g_userData.fbId = [user getProperty:KEY_FB_ID];
        NSString *strScore = [user getProperty:KEY_SCORE];
        [GlobalData sharedGlobalData].g_userData.score = [strScore intValue];
        [GlobalData sharedGlobalData].g_userData.verificationCode = @"";
        
        NSString *strVerify = [user getProperty:KEY_VERIFY];
        
        if ([strVerify isEqual:[NSNull null]]) {
            
            [GlobalData sharedGlobalData].g_currentUser = user;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendVerificationEmail:[GlobalData sharedGlobalData].g_userData.email];
            });
            
            SVPROGRESSHUD_DISMISS;
            
            BFSignUpConfirmViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_CONFIRM];
            [self.navigationController pushViewController:nextCtrl animated:true];
            
        } else {
            
            if ([strVerify isEqualToString:USER_VERIFY]) {
                
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
                    
                    SVPROGRESSHUD_DISMISS;
                    
                    BFTabBarViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_TAB];
                    [self.navigationController pushViewController:nextCtrl animated:true];
                    
                } else {
                    
                    if ([strDeviceId isEqualToString:[GlobalData sharedGlobalData].g_deviceID]) {
                        [GlobalData sharedGlobalData].g_userData.deviceId = strDeviceId;
                        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                        SVPROGRESSHUD_DISMISS;
                        
                        [GlobalData sharedGlobalData].g_currentUser = user;
                        
                        BFTabBarViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_TAB];
                        [self.navigationController pushViewController:nextCtrl animated:true];
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
                        
                        SVPROGRESSHUD_DISMISS;
                        
                        BFTabBarViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_TAB];
                        [self.navigationController pushViewController:nextCtrl animated:true];
                    }
                }

            } else {
                
                [GlobalData sharedGlobalData].g_currentUser = user;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendVerificationEmail:[GlobalData sharedGlobalData].g_userData.email];
                });
                
                SVPROGRESSHUD_DISMISS;
                
                BFSignUpConfirmViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_CONFIRM];
                [self.navigationController pushViewController:nextCtrl animated:true];
            }
            
        }
        
    } error:^(Fault *fault) {
        NSLog(@"Failed, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Invalid email or password."];
    }];
}

- (void)sendVerificationEmail:(NSString*)strEmail {
    
    int randomID = arc4random() % 900000 + 100000;
    NSString *strCode = [NSString stringWithFormat:@"%i", randomID];
    
    NSString *subject = mail_verification_email;
    NSString *body = [NSString stringWithFormat:@"%@%@%@", mail_verification_email_body1, strCode, mail_verification_email_body2];
    
    [backendless.messagingService sendHTMLEmail:subject body:body to:@[strEmail] response:^(id result) {
        
        NSLog(@"ASYNC: HTML email has been sent");
        
        [GlobalData sharedGlobalData].g_userData.verificationCode = strCode;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
    } error:^(Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }];
}

@end
