//
//  BFCreatePostViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFCreatePostViewController.h"
#import <Accounts/Accounts.h>

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage);

@interface BFCreatePostViewController () <UIActionSheetDelegate, STTwitterAPIOSProtocol>
{
    BOOL toggleKeyboardIsOn;
    BOOL togglePhotoIsOn;
    UIImage *prevImage;
    BOOL toggleTwitterIsOn;
    BOOL toggleBroadcastIsOn;
}

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;

@end

@implementation BFCreatePostViewController

@synthesize m_imgCamera, m_imgPost, m_lblName, m_txtPost, m_imgPhoto, containerView, m_btnBradcastOption;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountStore = [[ACAccountStore alloc] init];
    
    togglePhotoIsOn = false;
    toggleTwitterIsOn = false;
    toggleBroadcastIsOn = true;
    
    m_lblName.text = [GlobalData sharedGlobalData].g_userData.userName;
    
    NSURL *imageAvatarURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_userData.photoUrl];
    [m_imgPhoto setShowActivityIndicatorView:YES];
    [m_imgPhoto setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgPhoto sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UISwipeGestureRecognizer *tapGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [m_btnBradcastOption setImage:[UIImage imageNamed:@"checkbox_active"] forState:UIControlStateNormal];
    
    m_txtPost.text = @"What's on your mind?";
    m_imgPost.hidden = YES;
    m_imgPost.image = [UIImage imageNamed:@"loading"];
    
    m_imgCamera.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto)];
    tapPhoto.cancelsTouchesInView = NO;
    [m_imgCamera addGestureRecognizer:tapPhoto];
    
    [m_txtPost becomeFirstResponder];
    toggleKeyboardIsOn = true;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_imgPhoto.layer.cornerRadius = m_imgPhoto.frame.size.height / 2;
    m_imgPost.layer.cornerRadius = BUTTON_RADIUS;
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

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = true;
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = false;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // set views with new info
    containerView.frame = containerFrame;
    
    toggleKeyboardIsOn = false;
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([m_txtPost.text isEqualToString:@"What's on your mind?"]) {
        m_txtPost.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([m_txtPost.text isEqualToString:@""]) {
        m_txtPost.text = @"What's on your mind?";
    } else if (textView.text.length > 450) {
        textView.text = [textView.text substringToIndex:450];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView.text.length > 450) {
        textView.text = [textView.text substringToIndex:450];
    }
    
    int numLines = textView.contentSize.height / textView.font.lineHeight;
    
    if (numLines > 12) {
        textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return true;
}

- (void)onTapPhoto {
    
    [self dismissKeyboard];
    
    toggleTwitterIsOn = false;
    
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
    
    if (toggleTwitterIsOn) {
        
        if(buttonIndex == [actionSheet cancelButtonIndex]) {
            _accountChooserBlock(nil, @"Account selection was cancelled.");
            return;
        }
        
        NSUInteger accountIndex = buttonIndex - 1;
        ACAccount *account = [_iOSAccounts objectAtIndex:accountIndex];
        
        _accountChooserBlock(account, nil);
        
        [self loginWithiOSAccount:account];
        
    } else {
        
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
}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    m_imgPost.hidden = NO;
    m_imgPost.image = imgPhoto;
    prevImage = imgPhoto;
    togglePhotoIsOn = true;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender {
    
    [self dismissKeyboard];
    
//    [self performSegueWithIdentifier:UNWIND_NEW_POST sender:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCheckBroadcastOption:(id)sender {
    
    if (toggleBroadcastIsOn) {
        toggleBroadcastIsOn = false;
        [m_btnBradcastOption setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    } else {
        toggleBroadcastIsOn = true;
        [m_btnBradcastOption setImage:[UIImage imageNamed:@"checkbox_active"] forState:UIControlStateNormal];
    }
}

#pragma mark STTwitterAPIOSProtocol

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    if(twitterAPI != [GlobalData sharedGlobalData].twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}

- (void)chooseAccount {
    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                _accountChooserBlock(nil, @"Acccess not granted.");
                return;
            }
            
            self.iOSAccounts = [_accountStore accountsWithAccountType:accountType];
            
            if([_iOSAccounts count] == 1) {
                ACAccount *account = [_iOSAccounts lastObject];
                _accountChooserBlock(account, nil);
            } else if ([_iOSAccounts count] == 0) {
                [self loginOnTheWebAction];
                return;
            } else {
                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Select an account:"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil otherButtonTitles:nil];
                for(ACAccount *account in _iOSAccounts) {
                    [as addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
                }
                [as showInView:self.view.window];
            }
        }];
    };
    
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                     withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];
    }
#else
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
#endif
    
}

- (IBAction)onTwitterFetch:(id)sender {
    
    [self dismissKeyboard];
    
    toggleTwitterIsOn = true;
    
    __weak typeof(self) weakSelf = self;
    
    self.accountChooserBlock = ^(ACAccount *account, NSString *errorMessage) {
        if(account) {
            [weakSelf loginWithiOSAccount:account];
        } else {
            [weakSelf loginOnTheWebAction];
            return;
        }
    };
    
    [self chooseAccount];
}

- (void)loginWithiOSAccount:(ACAccount *)account {
    
    SVPROGRESSHUD_SHOW;
    
    [GlobalData sharedGlobalData].twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [[GlobalData sharedGlobalData].twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        SVPROGRESSHUD_DISMISS;
        
        [GlobalData sharedGlobalData].g_twitterUserID = userID;
        
        [self performSegueWithIdentifier:SEGUE_NEW_TWITTER sender:nil];
        
    } errorBlock:^(NSError *error) {
        [self loginOnTheWebAction];
    }];
}

- (void)loginOnTheWebAction {
    
    [GlobalData sharedGlobalData].twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [[GlobalData sharedGlobalData].twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
        [[UIApplication sharedApplication] openURL:url];
        
    } authenticateInsteadOfAuthorize:NO forceLogin:@(YES) screenName:nil oauthCallback:@"bearsfeedtwitter://twitter_access_tokens/" errorBlock:^(NSError *error) {
        NSLog(@"-- error: %@", error);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Login with twitter is failed. Please try again."];
        return;
    }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [[GlobalData sharedGlobalData].twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        
        SVPROGRESSHUD_DISMISS;
        
        [GlobalData sharedGlobalData].g_twitterUserID = userID;
        
        [self performSegueWithIdentifier:SEGUE_NEW_TWITTER sender:nil];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Login with twitter is failed. Please try again."];
        return;
    }];
}

- (IBAction)onPost:(id)sender {

    NSString *strPost = m_txtPost.text;
    UIImage *imagePhoto = [self scaleAndRotateImage:prevImage];
    
    if ([strPost isEqualToString:@"What's on your mind?"] || [strPost isEqualToString:@""]) {
        [self dismissKeyboard];
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input post."];
        return;
    }
    
    [self dismissKeyboard];
    
    NSData *data = [strPost dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *postValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (togglePhotoIsOn) {
        [self onSendPhotoPostData:imagePhoto post:postValue];
    } else {
        [self onSendPhotoPostData:postValue];
    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 1136;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)onSendPhotoPostData:(UIImage*)imagePhoto post:(NSString*)strPost {
    
    SVPROGRESSHUD_SHOW;
    
    int randomID = arc4random() % 900000000 + 100000000;
    NSString *prefixName = [NSString stringWithFormat:@"%i", randomID];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_%0.0f.jpeg", BACKEND_URL_POST, prefixName, [[NSDate date] timeIntervalSince1970]];
    NSData *filePhotoData = UIImageJPEGRepresentation(imagePhoto, 0.1);
    [backendless.fileService saveFile:fileName content:filePhotoData response:^(BackendlessFile *fileData) {
        
        Post *post = [Post new];
        post.content = strPost;
        post.type = POST_TYPE_PHOTO;
        post.filePath = fileData.fileURL;
        post.userId = [GlobalData sharedGlobalData].g_userData.userId;
        post.postUser = [GlobalData sharedGlobalData].g_currentUser;
        post.time = [[GlobalData sharedGlobalData] getCurrentDate];
        post.commentCount = 0;
        post.likeCount = 0;
        post.reportCount = 0;
        post.commentType = @"";
        post.likeType = @"";
        post.reportType = @"";
        
        [backendless.persistenceService save:post response:^(id response) {
            NSLog(@"saved new post data");
            
            if (toggleBroadcastIsOn) {
                [BFUtility onSendBroadcastNotification];
            }
            
            SVPROGRESSHUD_DISMISS;
            [self performSegueWithIdentifier:UNWIND_NEW_POST sender:nil];
            
            
        } error:^(Fault *fault) {
            NSLog(@"Failed save in background of post data, = %@ <%@>", fault.message, fault.detail);
            
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:@"Posting is failed. Please try again."];
        }];
    } error:^(Fault *fault) {
        NSLog(@"Failed save in background of post photo, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Posting is failed. Please try again."];
    }];
}

- (void)onSendPhotoPostData:(NSString*)strPost {
    
    SVPROGRESSHUD_SHOW;
    
    Post *post = [Post new];
    post.content = strPost;
    post.type = POST_TYPE_TEXT;
    post.filePath = @"";
    post.userId = [GlobalData sharedGlobalData].g_userData.userId;
    post.postUser = [GlobalData sharedGlobalData].g_currentUser;
    post.time = [[GlobalData sharedGlobalData] getCurrentDate];
    post.commentCount = 0;
    post.likeCount = 0;
    post.reportCount = 0;
    post.commentType = @"";
    post.likeType = @"";
    post.reportType = @"";
    
    [backendless.persistenceService save:post response:^(id response) {
        NSLog(@"saved new post data");
        
        if (toggleBroadcastIsOn) {
            [BFUtility onSendBroadcastNotification];
        }
        
        SVPROGRESSHUD_DISMISS;
        [self performSegueWithIdentifier:UNWIND_NEW_POST sender:nil];
        
    } error:^(Fault *fault) {
        NSLog(@"Failed save in background of post data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Posting is failed. Please try again."];
    }];
}

- (IBAction)unwindTwitterPost:(UIStoryboardSegue *)unwindSegue {
    
    [self performSegueWithIdentifier:UNWIND_NEW_POST sender:nil];
}

- (IBAction)unwindTwitterEdit:(UIStoryboardSegue *)unwindSegue {
    
    m_txtPost.text = [GlobalData sharedGlobalData].g_feedData.content;
    
    if ([[GlobalData sharedGlobalData].g_feedData.type isEqualToString:POST_TYPE_PHOTO]) {
      
        m_imgPost.hidden = NO;
        togglePhotoIsOn = true;
        
        NSString *strUrl = [GlobalData sharedGlobalData].g_feedData.filePath;
        NSURL *imageURL = [NSURL URLWithString:strUrl];
        [m_imgPost setShowActivityIndicatorView:YES];
        [m_imgPost setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [m_imgPost sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    }
}

@end
