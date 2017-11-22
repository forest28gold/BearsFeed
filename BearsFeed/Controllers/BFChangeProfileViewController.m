//
//  BFChangeProfileViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/23/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFChangeProfileViewController.h"

@interface BFChangeProfileViewController ()

@end

@implementation BFChangeProfileViewController

@synthesize m_btnSave, m_txtBio, m_viewBio, m_imgPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *strBio = [GlobalData sharedGlobalData].g_userData.bio;
    NSData *strdata = [strBio dataUsingEncoding:NSUTF8StringEncoding];
    NSString *bioValue = [[NSString alloc] initWithData:strdata encoding:NSNonLossyASCIIStringEncoding];
    
    m_txtBio.text = bioValue;
    
    NSURL *imageAvatarURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_userData.photoUrl];
    [m_imgPhoto setShowActivityIndicatorView:YES];
    [m_imgPhoto setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgPhoto sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    if ([GlobalData sharedGlobalData].g_toggleBioIsOn) {
        
        [m_txtBio addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGestureRecognizer];
        
    } else {
        
        m_imgPhoto.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto)];
        tapPhoto.cancelsTouchesInView = NO;
        [m_imgPhoto addGestureRecognizer:tapPhoto];
        
        [m_txtBio setEnabled:false];
    }
    
    [m_btnSave setEnabled:false];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_viewBio.layer.cornerRadius = BUTTON_RADIUS;
    m_btnSave.layer.cornerRadius = BUTTON_RADIUS;
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

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (![m_txtBio.text isEqualToString:@""] && ![m_txtBio.text isEqualToString:[GlobalData sharedGlobalData].g_userData.bio]) {
        [m_btnSave setEnabled:true];
    } else {
        [m_btnSave setEnabled:false];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_txtBio) {
        [self dismissKeyboard];
        [self onSave:textField];
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

- (void)openEditor:(UIImage *)editImage {
    
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
        [m_btnSave setEnabled:true];
        
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

- (IBAction)onSave:(id)sender {
    
    UIImage *imgPhoto = m_imgPhoto.image;
    NSString *strBio = m_txtBio.text;
    
    [self dismissKeyboard];

    if ([GlobalData sharedGlobalData].g_toggleBioIsOn) {
        
        if ([strBio isEqualToString:@""]) {
            [[GlobalData sharedGlobalData] onErrorAlert:@"Please input bio."];
            return;
        }
        
        NSData *data = [strBio dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *bioValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self onSaveBio:bioValue];
    } else {
        [self onSaveProfilePicture:imgPhoto];
    }
}

- (void)onSaveBio:(NSString*)strBio {
    
    SVPROGRESSHUD_SHOW;
    
    [[GlobalData sharedGlobalData].g_currentUser setProperty:KEY_BIO object:strBio];
    [backendless.userService update:[GlobalData sharedGlobalData].g_currentUser response:^(BackendlessUser *user) {
        
        [GlobalData sharedGlobalData].g_currentUser = user;
        
        SVPROGRESSHUD_SUCCESS(@"Bio changed succeesfully.");
        
        [GlobalData sharedGlobalData].g_userData.bio = strBio;
        [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Change Bio is failed. Please try again."];
    }];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)onSaveProfilePicture:(UIImage*)imgPhoto {

    SVPROGRESSHUD_SHOW;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *items = [[GlobalData sharedGlobalData].g_userData.photoUrl componentsSeparatedByString:@"/"];
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", BACKEND_URL_AVATAR, [items lastObject]];
        [backendless.fileService remove:fileName];
        NSLog(@"***************** Profile photo file is deleted. **********************");
    });
    
    int randomID = arc4random() % 900000000 + 100000000;
    NSString *prefixName = [NSString stringWithFormat:@"%i", randomID];
    
    UIImage *uploadImage = [self imageWithImage:imgPhoto convertToSize:CGSizeMake(600, 600)];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_%0.0f.jpeg", BACKEND_URL_AVATAR, prefixName, [[NSDate date] timeIntervalSince1970]];
    NSData *fileData = UIImageJPEGRepresentation(uploadImage, 0.5);
    [backendless.fileService saveFile:fileName content:fileData response:^(BackendlessFile *fileData) {
        
        NSLog(@"=================== Profile photo file is saved. ===================");
        
        [[GlobalData sharedGlobalData].g_currentUser setProperty:KEY_PHOTO_URL object:fileData.fileURL];
        [backendless.userService update:[GlobalData sharedGlobalData].g_currentUser response:^(BackendlessUser *user) {
            
            [GlobalData sharedGlobalData].g_currentUser = user;
            
            SVPROGRESSHUD_SUCCESS(@"Profile picture changed succeesfully.");
            
            [GlobalData sharedGlobalData].g_userData.photoUrl = fileData.fileURL;
            [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } error:^(Fault *fault) {
            
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:@"Change profile picture is failed. Please try again."];
        }];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of user photo, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Change profile picture is failed. Please try again."];
        
    }];
}

@end
