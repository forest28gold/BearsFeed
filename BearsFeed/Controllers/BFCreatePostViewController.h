//
//  BFCreatePostViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFCreatePostViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController             *m_popoverController;
    UIImagePickerController         *m_pickerController;
}

@property (strong, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *m_lblName;
@property (strong, nonatomic) IBOutlet UITextView *m_txtPost;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPost;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgCamera;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *m_btnBradcastOption;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

- (IBAction)unwindTwitterPost:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindTwitterEdit:(UIStoryboardSegue *)unwindSegue;

@end
