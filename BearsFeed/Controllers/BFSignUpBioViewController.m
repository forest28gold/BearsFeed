//
//  BFSignUpBioViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFSignUpBioViewController.h"
#import "BFTabBarViewController.h"
#import "BFSignUpConfirmViewController.h"

@interface BFSignUpBioViewController ()

@end

@implementation BFSignUpBioViewController

@synthesize m_btnContinue, m_txtBio, m_viewBio, m_imgPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    m_imgPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto)];
    tapPhoto.cancelsTouchesInView = NO;
    [m_imgPhoto addGestureRecognizer:tapPhoto];
    
    m_imgPhoto.image = [UIImage imageNamed:@"photo"];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewBio.layer.cornerRadius = BUTTON_RADIUS;
    m_btnContinue.layer.cornerRadius = BUTTON_RADIUS;
    m_viewBio.layer.borderWidth = 1.0f;
    m_viewBio.layer.borderColor = [UIColor colorWithHexString:@"#d8dad9"].CGColor;
    m_imgPhoto.layer.cornerRadius = m_imgPhoto.frame.size.height / 2;
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
    if (textField == m_txtBio) {
        [self dismissKeyboard];
        [self onContinue:textField];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)onTapPhoto {
    
    [self dismissKeyboard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Image Gallary", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                
                [self presentViewController:picker animated:YES completion:nil];
            }
            
            break;
        }
            
        case 1: {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            if(m_popoverController != nil) {
                [m_popoverController dismissPopoverAnimated:YES];
                m_popoverController = nil;
            }
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                    m_popoverController.delegate = self;
                    [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
                                                         inView:self.view
                                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                                       animated:YES];
                } else {
                    
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    m_pickerController = picker;
    
    [self openEditor:imgPhoto];
}


# pragma mark - Open Crop View Controller

- (void) openEditor:(UIImage *) editImage {
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = editImage;
    controller.cropAspectRatio = 1.0f;
    controller.keepingCropAspectRatio = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [m_pickerController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - PECropViewController Delegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    
    [controller dismissViewControllerAnimated:YES completion:^(void) {
        
        m_imgPhoto.image = croppedImage;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [m_popoverController dismissPopoverAnimated:YES];
        } else {
            [m_pickerController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void) cropViewControllerDidCancel:(PECropViewController *) controller {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onContinue:(id)sender {
    
    UIImage *imgPhoto = m_imgPhoto.image;
    NSString *strBio = m_txtBio.text;
    
    if ([imgPhoto isEqual:[UIImage imageNamed:@"photo"]]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input photo."];
        return;
    } else if ([strBio isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input bio."];
        return;
    }
    
    NSData *data = [strBio dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *bioValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self dismissKeyboard];
    
    [self signup:bioValue image:imgPhoto];
    
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)signup:(NSString *)bio image:(UIImage*)image {
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_EMAIL, [GlobalData sharedGlobalData].g_strEmail];
    [[backendless.persistenceService of:[BackendlessUser class]] find:query response:^(BackendlessCollection *users) {
        
        if (users.data.count > 0) {
            
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:@"The email address had been registered already. Please input another email address."];
            
        } else {
            
            int randomID = arc4random() % 900000000 + 100000000;
            NSString *prefixName = [NSString stringWithFormat:@"%i", randomID];
            
            UIImage *uploadImage = [self imageWithImage:image convertToSize:CGSizeMake(600, 600)];
            
            NSString *fileName = [NSString stringWithFormat:@"%@/%@_%0.0f.jpeg", BACKEND_URL_AVATAR, prefixName, [[NSDate date] timeIntervalSince1970]];
            NSData *fileData = UIImageJPEGRepresentation(uploadImage, 0.5);
            [backendless.fileService saveFile:fileName content:fileData response:^(BackendlessFile *fileData) {
                
                BackendlessUser *user = [BackendlessUser new];
                user.email = [GlobalData sharedGlobalData].g_strEmail;
                user.password = [GlobalData sharedGlobalData].g_strPassword;
                user.name = [GlobalData sharedGlobalData].g_strName;
                [user setProperty:KEY_DEVICE_ID object:[GlobalData sharedGlobalData].g_deviceID];
                [user setProperty:KEY_BIO object:bio];
                [user setProperty:KEY_PHOTO_URL object:fileData.fileURL];
                [user setProperty:KEY_FB_ID object:@""];
                [user setProperty:KEY_SOCIAL object:USER_NORMAL];
                [user setProperty:KEY_SCORE object:@"0"];
                [user setProperty:KEY_VERIFY object:USER_DISABLE];
                
                [backendless.userService registering:user response:^(BackendlessUser *user) {
                    
                    NSLog(@"user = %@", user);
                    
                    [GlobalData sharedGlobalData].g_currentUser = user;

                    [GlobalData sharedGlobalData].g_userData = [[UserData alloc] init];
                    [GlobalData sharedGlobalData].g_userData.userId = user.objectId;
                    [GlobalData sharedGlobalData].g_userData.deviceId = [GlobalData sharedGlobalData].g_deviceID;
                    [GlobalData sharedGlobalData].g_userData.userName = [GlobalData sharedGlobalData].g_strName;
                    [GlobalData sharedGlobalData].g_userData.email = [GlobalData sharedGlobalData].g_strEmail;
                    [GlobalData sharedGlobalData].g_userData.password = [GlobalData sharedGlobalData].g_strPassword;
                    [GlobalData sharedGlobalData].g_userData.bio = bio;
                    [GlobalData sharedGlobalData].g_userData.photoUrl = [user getProperty:KEY_PHOTO_URL];
                    [GlobalData sharedGlobalData].g_userData.signup = USER_SIGNUP;
                    [GlobalData sharedGlobalData].g_userData.score = 0;
                    [GlobalData sharedGlobalData].g_userData.socialRole = USER_NORMAL;
                    [GlobalData sharedGlobalData].g_userData.fbId = @"";
                    [GlobalData sharedGlobalData].g_userData.verificationCode = @"";

                    [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self sendVerificationEmail:[GlobalData sharedGlobalData].g_userData.email];
                    });
                    
                    SVPROGRESSHUD_DISMISS;
                    
                    BFSignUpConfirmViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SIGNUP_CONFIRM];
                    [self.navigationController pushViewController:nextCtrl animated:true];
                    
                } error:^(Fault *fault) {
                    
                    NSLog(@"Failed save in background of user,= %@ <%@>", fault.message, fault.detail);
                    
                    SVPROGRESSHUD_DISMISS;
                    [[GlobalData sharedGlobalData] onErrorAlert:@"Signup is failed. Please try again."];
                    
                }];
                
            } error:^(Fault *fault) {
                
                NSLog(@"Failed save in background of user photo, = %@ <%@>", fault.message, fault.detail);
                
                SVPROGRESSHUD_DISMISS;
                [[GlobalData sharedGlobalData] onErrorAlert:@"Signup is failed. Please try again."];
                
            }];
        
        }
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Signup is failed. Please try again."];
        
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
