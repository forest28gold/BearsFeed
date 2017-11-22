//
//  BFTabBarViewController.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTabBar.h"
#import "LLTabBarItem.h"
#import "BFTabBearsFeedViewController.h"
#import "BFTabExploreViewController.h"
#import "BFTabNotificationViewController.h"
#import "BFTabProfileViewController.h"

@interface BFTabBarViewController : UITabBarController <LLTabBarDelegate>

@property(nonatomic,strong) BFTabBearsFeedViewController *m_feedVC;
@property(nonatomic,strong) BFTabExploreViewController *m_exploreVC;
@property(nonatomic,strong) BFTabNotificationViewController *m_notificationVC;
@property(nonatomic,strong) BFTabProfileViewController *m_profileVC;

- (void)goToSearch;
- (void)goToNewPost;
- (void)goToCommentPost;
- (void)goToReplyPost;
- (void)goToPhotoView;
- (void)goToPostDetails;
- (void)goToUserProfile;
- (void)goToLastBearStanding;
- (void)goToShopping;
- (void)goToChangeProfilePicture;
- (void)goToChangePassword;
- (void)goToHelp;
- (void)goToPostLink;
- (void)LogOut;

- (IBAction)unwindNewPost:(UIStoryboardSegue *)unwindSegue;

@end
