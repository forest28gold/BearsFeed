//
//  BFPhotoViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/20/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFPhotoViewController.h"
#import "STPhotoBrowserView.h"

@interface BFPhotoViewController ()

@end

@implementation BFPhotoViewController

@synthesize m_view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    STPhotoBrowserView *photoView = [[STPhotoBrowserView alloc] initWithFrame:self.view.frame];
    [photoView setImageWithURL:[NSURL URLWithString:[GlobalData sharedGlobalData].g_photoUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    [m_view addSubview:photoView];
    
    photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto)];
    tapPhoto.cancelsTouchesInView = NO;
    [photoView addGestureRecognizer:tapPhoto];
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

- (void)onTapPhoto {
    
    [GlobalData sharedGlobalData].g_togglePhotoIsOn = true;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClose:(id)sender {
    
    [GlobalData sharedGlobalData].g_togglePhotoIsOn = true;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
