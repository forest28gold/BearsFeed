//
//  BFForgetPasswordViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFForgetPasswordViewController.h"

@interface BFForgetPasswordViewController () <MFMailComposeViewControllerDelegate>
{
    BackendlessUser *emailUser;
}

@end

@implementation BFForgetPasswordViewController

@synthesize m_txtEmail, m_viewEmail, m_btnSent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewEmail.layer.cornerRadius = BUTTON_RADIUS;
    m_btnSent.layer.cornerRadius = BUTTON_RADIUS;
    m_btnSent.layer.borderWidth = 1.0f;
    m_btnSent.layer.borderColor = [UIColor whiteColor].CGColor;
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

#pragma mark - MFMailCompose delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail cancelled: you cancelled the operation and no email message was queued."];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail saved: you saved the email message in the drafts folder."];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
//            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail send: the email message is queued in the outbox. It is ready to send."];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail failed: the email message was not saved or queued, possibly due to an error."];
            break;
        default:
            NSLog(@"Mail not sent.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail not sent."];
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_txtEmail) {
        [self dismissKeyboard];
        [self onSendLoginLink:textField];
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

- (IBAction)onEmailUs:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[SUPPORT_EMAIL]];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (IBAction)onSendLoginLink:(id)sender {
    
    NSString *strEmail = m_txtEmail.text;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input email."];
        return;
    } else if(![emailTest evaluateWithObject:strEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input email exactly."];
        return;
    }
    
    [self dismissKeyboard];
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_EMAIL, strEmail];
    [[backendless.persistenceService of:[BackendlessUser class]] find:query response:^(BackendlessCollection *users) {
        
        if (users.data.count > 0) {
            
            NSLog(@"User exist");
            
            emailUser = users.data[0];
            [self sendForgottenPasswordEmail:strEmail];
            
        } else {
            
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:@"The email is not user account. Please input another email address."];
        }
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"The email is not user account. Please input another email address."];
    }];
}

- (void)sendForgottenPasswordEmail:(NSString*)strEmail {
    
    int randomID = arc4random() % 900000 + 100000;
    NSString *kPassword = [NSString stringWithFormat:@"%i", randomID];
    NSString *strPassword = [NSString stringWithFormat:@"bearsfeed%@", kPassword];
    
    NSString *subject = mail_reset_your_password;
    NSString *body = [NSString stringWithFormat:@"%@%@%@%@%@", mail_reset_password_body1, strEmail, mail_reset_password_body2, strPassword, mail_reset_password_body3];
    
    [backendless.messagingService sendHTMLEmail:subject body:body to:@[strEmail] response:^(id result) {
        
        NSLog(@"ASYNC: HTML email has been sent");
        
        SVPROGRESSHUD_SUCCESS(@"We have just sent an email with a reseted password. Please check your email.");
        
        [GlobalData sharedGlobalData].g_userData.signup = USER_LOGOUT;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [emailUser setPassword:strPassword];
            [backendless.userService update:emailUser];
        });
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Server reported an error: %@", fault);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Email sending is failed. Please try again."];
    }];
}


@end
