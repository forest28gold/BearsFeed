//
//  GlobalData.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AutoFormatter.h"
#import "DataModel.h"
#import "DBHandler.h"
#import "BFTabBarViewController.h"
#import "BFTabBearsFeedViewController.h"
#import "BFEliminatedTargetViewController.h"
#import "BFTwitterFeedViewController.h"
#import "UserData.h"
#import "NSDate+NVTimeAgo.h"
#import "PostData.h"
#import "Target.h"
#import "STTwitter.h"
#import "FeedData.h"
#import "Post.h"
#import "Comment.h"
#import "CommentData.h"

@interface GlobalData : NSObject

@property (nonatomic, retain) AppDelegate                   *g_appDelegate;
@property (nonatomic, retain) AutoFormatter                 *g_autoFormat;
@property (nonatomic, retain) DBHandler                     *g_dBHandler;
@property (nonatomic, retain) DataModel                     *g_dataModel;
@property (strong, nonatomic) BFTabBarViewController        *g_tabBar;
@property (strong, nonatomic) BFTabBearsFeedViewController  *g_ctrlTabHome;
@property (strong, nonatomic) BFTwitterFeedViewController   *g_ctrlTwitter;
@property (nonatomic, retain) UserData                      *g_userData;
@property (nonatomic, retain) BackendlessUser               *g_currentUser;
@property (nonatomic, retain) BackendlessUser               *g_postUser;
@property (nonatomic, retain) Target                        *g_target;
@property (nonatomic, retain) Target                        *g_targetUser;
@property (strong, nonatomic) BFEliminatedTargetViewController  *g_ctrlEliminatedTarget;
@property (nonatomic, strong) STTwitterAPI                  *twitter;
@property (nonatomic, strong) STTwitterAPI                  *twitter_bears;
@property (nonatomic, retain) FeedData                      *g_feedData;
@property (strong, nonatomic) NSString                      *g_twitterUserID;
@property (strong, nonatomic) NSTimer                       *g_timer;

@property (strong, nonatomic) NSString                      *g_deviceID;
@property (strong, nonatomic) NSString                      *g_strName;
@property (strong, nonatomic) NSString                      *g_strEmail;
@property (strong, nonatomic) NSString                      *g_strPassword;

@property (strong, nonatomic) NSString                      *g_strSelectedTab;
@property (nonatomic, assign) BOOL                          g_togglePhotoIsOn;
@property (strong, nonatomic) NSMutableArray                *g_arrayNewestPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMostCommentedPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMostVotesPost;
@property (nonatomic, assign) BOOL                          g_toggleTwitterIsOn;

@property (strong, nonatomic) NSMutableArray                *g_arrayMyPost;
@property (nonatomic, assign) BOOL                          g_toggleReplyIsOn;
@property (strong, nonatomic) NSString                      *g_photoUrl;
@property (nonatomic, retain) PostData                      *g_postData;
@property (nonatomic, assign) BOOL                          g_toggleBioIsOn;
@property (nonatomic, strong) NSString                      *g_strLastBearStanding;
@property (strong, nonatomic) NSMutableArray                *g_arrayTarget;
@property (strong, nonatomic) NSString                      *g_strTitle;
@property (strong, nonatomic) NSString                      *g_strPostLink;
@property (nonatomic, assign) BOOL                          g_toggleMyPostIsOn;
@property (nonatomic, assign) BOOL                          g_toggleTwitterLinkIsOn;
@property (nonatomic, assign) BOOL                          g_toggleRefreshIsOn;


+ (GlobalData *)sharedGlobalData;
- (NSString *)trimString:(NSString *)string;

- (NSString*)getCurrentDate;
- (NSString*)getFormattedCount:(int)count;
- (NSString*)getFormattedCommentCount:(int)count;
- (NSString*)getFormattedTimeStamp:(NSString*)time;
- (NSString*)getFormattedTwitterTimeStamp:(NSString*)time;

- (PostData*)onParsePostData:(Post*)post;
- (PostData*)onParseTwitterData:(NSDictionary*)status;
- (CommentData*)onParseCommentData:(Comment*)comment;
- (FeedData*)onParseFeedData:(NSDictionary*)status;

- (void)onErrorAlert:(NSString*)errorString;

@end
