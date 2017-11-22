//
//  BFTabExploreViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFTabExploreViewController.h"

@interface BFTabExploreViewController ()

@end

@implementation BFTabExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (IBAction)onSearch:(id)sender {
    [[GlobalData sharedGlobalData].g_tabBar goToSearch];
}

- (IBAction)onTapLastBearStanding:(id)sender {    
    [[GlobalData sharedGlobalData].g_tabBar goToLastBearStanding];
}

- (IBAction)onShopping:(id)sender {
    [[GlobalData sharedGlobalData].g_tabBar goToShopping];
}

- (IBAction)onFollowUsSnapchat:(id)sender {
    
    NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:BEARSFEED_SNAPCHAT_LINK]];
    
    if ([[UIApplication sharedApplication] canOpenURL:strUrl]) {
        [[UIApplication sharedApplication] openURL:strUrl];
    }
}

- (IBAction)onFollowUsInstagram:(id)sender {
    
    NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:BEARSFEED_INSTAGRAM_LINK]];
    
    if ([[UIApplication sharedApplication] canOpenURL:strUrl]) {
        [[UIApplication sharedApplication] openURL:strUrl];
    }
}

- (IBAction)onFollowUsFacebook:(id)sender {
    
    NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:BEARSFEED_FACEBOOK_LINK]];
    
    if ([[UIApplication sharedApplication] canOpenURL:strUrl]) {
        [[UIApplication sharedApplication] openURL:strUrl];
    }
}

- (IBAction)onFollowUsWebsite:(id)sender {
    
    NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:BEARSFEED_WEBSITE_LINK]];
    
    if ([[UIApplication sharedApplication] canOpenURL:strUrl]) {
        [[UIApplication sharedApplication] openURL:strUrl];
    }
}

@end
