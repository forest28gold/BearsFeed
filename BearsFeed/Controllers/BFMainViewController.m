//
//  BFMainViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFMainViewController.h"
#import "BFSignUpNameViewController.h"
#import "BFLoginViewController.h"
#import "BFTabBarViewController.h"
#import "BFBerkShireStoreViewController.h"
#import "BFSignUpConfirmViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface BFMainViewController () <UIGestureRecognizerDelegate>

@end

@implementation BFMainViewController

@synthesize m_btnSignUp, m_btnLogin, m_btnFacebook, m_viewLoading, m_viewNoNetwork, m_btnTryAgain;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self onGetRemoteDeviceId];

    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_btnSignUp.layer.cornerRadius = BUTTON_RADIUS;
    m_btnLogin.layer.cornerRadius = BUTTON_RADIUS;
    m_btnFacebook.layer.cornerRadius = BUTTON_RADIUS;
    m_btnTryAgain.layer.cornerRadius = BUTTON_RADIUS;
    m_btnLogin.layer.borderWidth = 1.0f;
    m_btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if ([[GlobalData sharedGlobalData].g_userData.signup isEqualToString:USER_SIGNUP]) {
        m_viewLoading.hidden = NO;
        m_viewNoNetwork.hidden = YES;
        [self login:[GlobalData sharedGlobalData].g_userData.email password:[GlobalData sharedGlobalData].g_userData.password];
    } else {
        m_viewLoading.hidden = YES;
        m_viewNoNetwork.hidden = YES;
    }
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)onGetRemoteDeviceId {
    
    @try {
        [backendless.messaging registerForRemoteNotifications];
        [GlobalData sharedGlobalData].g_deviceID = [backendless.messagingService getRegistrations].deviceId;
        NSLog(@"RegisterDevice: %@", [GlobalData sharedGlobalData].g_deviceID);
    } @catch (Fault *fault) {
        [GlobalData sharedGlobalData].g_deviceID = @"";
        NSLog(@"Register of Device is failed: %@", fault);
    }
}

- (IBAction)onTermsOfUse:(id)sender {
    
    [GlobalData sharedGlobalData].g_strTitle = TITLE_TERMS_OF_USE;
    
    BFBerkShireStoreViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_BERKSHIRE_STORE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onPrivacyPolicy:(id)sender {
    
    [GlobalData sharedGlobalData].g_strTitle = TITLE_PRIVACY_POLICY;
    
    BFBerkShireStoreViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_BERKSHIRE_STORE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onSignUp:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_deviceID == nil || [[GlobalData sharedGlobalData].g_deviceID isEqualToString:@""]) {
        [self onGetRemoteDeviceId];
    }
    
    BFSignUpNameViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_NAME];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onLogin:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_deviceID == nil || [[GlobalData sharedGlobalData].g_deviceID isEqualToString:@""]) {
        [self onGetRemoteDeviceId];
    }
    
    BFLoginViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_LOGIN];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)onSignupConfirm {
    
    m_viewLoading.hidden = YES;
    m_viewNoNetwork.hidden = YES;
    
    BFSignUpConfirmViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_CONFIRM];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)onGoMainView {
    
    m_viewLoading.hidden = YES;
    m_viewNoNetwork.hidden = YES;
    
    BFTabBarViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_TAB];
    [self.navigationController pushViewController:nextCtrl animated:NO];
}

- (IBAction)onLoginWithFacebook:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_deviceID == nil || [[GlobalData sharedGlobalData].g_deviceID isEqualToString:@""]) {
        [self onGetRemoteDeviceId];
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [self getResultFromFBSDK:result error:error];
    }];
}

#pragma mark - Facebook

- (void)getResultFromFBSDK:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    if (error) {
        // Process error
        [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is failed. Please try again."];
        return;
    } else if (result.isCancelled) {
        // Handle cancellations
        [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is cancelled."];
        return;
    } else {
        SVPROGRESSHUD_SHOW;
        
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"public_profile"]) {
            // Do work
            if ([FBSDKAccessToken currentAccessToken]) {
                
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
                    if (!error) {
                        NSLog(@"fetched user:%@", result);
                        
                        NSString *strUserId = user[@"id"];
                        NSString *strEmail = user[@"email"];
                        NSString *strName = user[@"name"];
                        NSString *strAvatarUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=500&height=500", strUserId];
                        NSString *strPassword = user[@"id"];
                        
                        BackendlessDataQuery *query = [BackendlessDataQuery query];
                        query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_EMAIL, strEmail];
                        [[backendless.persistenceService of:[BackendlessUser class]] find:query response:^(BackendlessCollection *users) {
                            
                            if (users.data.count > 0) {
                                [self login:strEmail password:strPassword];
                            } else {
                                [self signup:strEmail password:strPassword name:strName photo:strAvatarUrl bio:@""];                                
                            }
                            
                        } error:^(Fault *fault) {
                            
                            NSLog(@"Signup is failed. Please try again!");
                            
                            SVPROGRESSHUD_DISMISS;
                            [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is failed. Please try again."];
                            return;
                        }];
                        
                    } else {
                        NSLog(@"%@", error.description);
                        
                        SVPROGRESSHUD_DISMISS;
                        [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is failed. Please try again."];
                        return;
                    }
                }];
            } else {
                SVPROGRESSHUD_DISMISS;
                [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is failed. Please try again."];
                return;
            }
        } else {
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is failed. Please try again."];
            return;
        }
    }
}

- (void)signup:(NSString*)email password:(NSString*)password name:(NSString*)name photo:(NSString*)photoUrl bio:(NSString*)bio {
    
    BackendlessUser *user = [BackendlessUser new];
    user.email = email;
    user.password = password;
    user.name = name;
    [user setProperty:KEY_DEVICE_ID object:[GlobalData sharedGlobalData].g_deviceID];
    [user setProperty:KEY_BIO object:bio];
    [user setProperty:KEY_PHOTO_URL object:photoUrl];
    [user setProperty:KEY_FB_ID object:password];
    [user setProperty:KEY_SOCIAL object:USER_FACEBOOK];
    [user setProperty:KEY_SCORE object:@"0"];
    [user setProperty:KEY_VERIFY object:USER_VERIFY];
    
    [backendless.userService registering:user response:^(BackendlessUser *user) {
        
        NSLog(@"user = %@", user);
        
        [GlobalData sharedGlobalData].g_currentUser = user;
        
        [GlobalData sharedGlobalData].g_userData = [[UserData alloc] init];
        [GlobalData sharedGlobalData].g_userData.userId = user.objectId;
        [GlobalData sharedGlobalData].g_userData.deviceId = [GlobalData sharedGlobalData].g_deviceID;
        [GlobalData sharedGlobalData].g_userData.userName = name;
        [GlobalData sharedGlobalData].g_userData.email = email;
        [GlobalData sharedGlobalData].g_userData.password = password;
        [GlobalData sharedGlobalData].g_userData.bio = bio;
        [GlobalData sharedGlobalData].g_userData.photoUrl = photoUrl;
        [GlobalData sharedGlobalData].g_userData.signup = USER_SIGNUP;
        [GlobalData sharedGlobalData].g_userData.score = 0;
        [GlobalData sharedGlobalData].g_userData.socialRole = USER_FACEBOOK;
        [GlobalData sharedGlobalData].g_userData.fbId = password;
        [GlobalData sharedGlobalData].g_userData.verificationCode = @"";
        
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        SVPROGRESSHUD_DISMISS;
        [self onGoMainView];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of facebook user, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Login with Facebook is failed. Please try again."];
        
    }];
}

- (void)login:(NSString*)email password:(NSString*)password {
    
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
            [self onSignupConfirm];
            
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
                    [self onGoMainView];
                    
                } else {
                    
                    if ([strDeviceId isEqualToString:[GlobalData sharedGlobalData].g_deviceID]) {
                        [GlobalData sharedGlobalData].g_userData.deviceId = strDeviceId;
                        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                        SVPROGRESSHUD_DISMISS;
                        
                        [GlobalData sharedGlobalData].g_currentUser = user;
                        
                        [self onGoMainView];
                        
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
                        [self onGoMainView];
                    }
                }

            } else {
                
                [GlobalData sharedGlobalData].g_currentUser = user;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendVerificationEmail:[GlobalData sharedGlobalData].g_userData.email];
                });
                
                SVPROGRESSHUD_DISMISS;
                [self onSignupConfirm];
            }
        }

    } error:^(Fault *fault) {
        NSLog(@"Failed, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        
        if ([[GlobalData sharedGlobalData].g_userData.signup isEqualToString:USER_SIGNUP]) {
            m_viewNoNetwork.hidden = NO;
            m_viewLoading.hidden = NO;
        } else {
            m_viewLoading.hidden = YES;
            m_viewNoNetwork.hidden = YES;
            [[GlobalData sharedGlobalData] onErrorAlert:@"Invalid email or password."];
        }
    }];
    
}

- (IBAction)onTryAgain:(id)sender {
    
    m_viewNoNetwork.hidden = YES;
    m_viewLoading.hidden = NO;
    
    [self login:[GlobalData sharedGlobalData].g_userData.email password:[GlobalData sharedGlobalData].g_userData.password];
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

- (IBAction)unwindLogOut:(UIStoryboardSegue *)unwindSegue {
    m_viewLoading.hidden = YES;
}

- (IBAction)unwindVerify:(UIStoryboardSegue *)unwindSegue {
    m_viewLoading.hidden = YES;
}

@end
