//
//  BFTabBarViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFTabBarViewController.h"
#import "BFSearchViewController.h"
#import "BFCommentViewController.h"
#import "BFChangeProfileViewController.h"
#import "BFChangePasswordViewController.h"
#import "BFBerkShireStoreViewController.h"
#import "BFPostDetailsViewController.h"
#import "BFUserProfileViewController.h"
#import "BFStandingLoadingViewController.h"
#import <StoreKit/StoreKit.h>

@interface BFTabBarViewController ()

@end

@implementation BFTabBarViewController

@synthesize m_feedVC, m_exploreVC, m_profileVC, m_notificationVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self setupViewControllers];
    
    [self performSelector:@selector(onAppRate) withObject:self afterDelay:5.0];
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

- (void)onAppRate {
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    int day = [currentDateString intValue];
    
    if (day%3 == 1) {
        [SKStoreReviewController requestReview];
    }
}

#pragma mark - Methods

- (void)setupViewControllers {
    
    [GlobalData sharedGlobalData].g_tabBar = self;
    
    m_feedVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_BEARSFEED];
    m_exploreVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_EXPLORE];
    m_notificationVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_NOTIFICATION];
    m_profileVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_PROFILE];
    
    [GlobalData sharedGlobalData].g_tabBar.viewControllers = @[m_feedVC, m_exploreVC, m_notificationVC, m_profileVC];
    
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:[GlobalData sharedGlobalData].g_tabBar.tabBar.bounds];
    
    CGFloat normalButtonWidth = ([[UIScreen mainScreen] bounds].size.width * 3 / 4) / 4;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat publishItemWidth = ([[UIScreen mainScreen] bounds].size.width / 4);
    
    LLTabBarItem *feedItem = [self tabBarItemWithFrame:CGRectMake(0, 0, normalButtonWidth, tabBarHeight)
                                                 title:@"Home"
                                       normalImageName:@"tab_icon_feed"
                                     selectedImageName:@"tab_icon_feed_selected" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *exploreItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight)
                                                     title:@"Explore"
                                           normalImageName:@"tab_icon_explore"
                                         selectedImageName:@"tab_icon_explore_selected" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *publishItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 2, 0, publishItemWidth, tabBarHeight)
                                                    title:@""
                                          normalImageName:@"tab_icon_new"
                                        selectedImageName:@"tab_icon_new" tabBarItemType:LLTabBarItemRise];
    LLTabBarItem *notificationItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 2 + publishItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                    title:@"Notifications"
                                          normalImageName:@"tab_icon_notification"
                                        selectedImageName:@"tab_icon_notification_selected" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *profileItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 3 + publishItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                 title:@"My Profile"
                                       normalImageName:@"tab_icon_profile"
                                     selectedImageName:@"tab_icon_profile_selected" tabBarItemType:LLTabBarItemNormal];
    
    tabBar.tabBarItems = @[feedItem, exploreItem, publishItem, notificationItem, profileItem];
    tabBar.delegate = self;
    
    [[GlobalData sharedGlobalData].g_tabBar.tabBar addSubview:tabBar];
    
}

- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame];
    
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:10];
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setImage:selectedImage forState:UIControlStateHighlighted];
    
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithHexString:@"fff600"] forState:UIControlStateSelected];
    
    item.tabBarItemType = tabBarItemType;
    
    return item;
}

#pragma mark - LLTabBarDelegate

- (void)tabBarDidSelectedRiseButton {
    
    [self goToNewPost];
}

- (void)goToSearch {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    BFSearchViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_SEARCH];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToNewPost {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    [self performSegueWithIdentifier:SEGUE_NEW_POST sender:nil];
}

- (void)goToCommentPost {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    BFCommentViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_COMMENT];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToPhotoView {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    [self performSegueWithIdentifier:SEGUE_PHOTO sender:nil];
}

- (void)goToPostDetails {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    BFPostDetailsViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_POST_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToUserProfile {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    BFUserProfileViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_USER_PROFILE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToReplyPost {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    BFCommentViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_COMMENT];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToLastBearStanding {
    
    BFStandingLoadingViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_STANDING_LOADING];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToShopping {
    
    [GlobalData sharedGlobalData].g_strTitle = TITLE_BERKSHIRE_STORE;
    
    BFBerkShireStoreViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_BERKSHIRE_STORE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToChangeProfilePicture {
    
    BFChangeProfileViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_CHANGE_PROFILE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToChangePassword {
    
    BFChangePasswordViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_CHANGE_PASSWORD];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToHelp {
    
//    NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:BEARSFEED_WEBSITE_LINK]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:strUrl]) {
//        [[UIApplication sharedApplication] openURL:strUrl];
//    }
    
    [GlobalData sharedGlobalData].g_strTitle = TITLE_HELP;
    
    BFBerkShireStoreViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_BERKSHIRE_STORE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToPostLink {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    [GlobalData sharedGlobalData].g_strTitle = @"";
    
    BFBerkShireStoreViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_BERKSHIRE_STORE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)LogOut {
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
    
    [GlobalData sharedGlobalData].g_userData.signup = USER_LOGOUT;
    [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
    
    [self performSegueWithIdentifier:UNWIND_LOGOUT sender:nil];
}

- (IBAction)unwindNewPost:(UIStoryboardSegue *)unwindSegue {
    
}

@end
