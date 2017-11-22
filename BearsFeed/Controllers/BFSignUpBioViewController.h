//
//  BFSignUpBioViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

@interface BFSignUpBioViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, PECropViewControllerDelegate>
{
    UIPopoverController             *m_popoverController;
    UIImagePickerController         *m_pickerController;
}

@property (strong, nonatomic) IBOutlet UIView *m_viewBio;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (strong, nonatomic) IBOutlet UITextField *m_txtBio;
@property (strong, nonatomic) IBOutlet UIButton *m_btnContinue;

@end
