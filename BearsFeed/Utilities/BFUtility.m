//
//  BFUtility.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/20/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFUtility.h"
#import <Social/Social.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation BFUtility 

+ (void)likePostInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    PostData *record = [[PostData alloc] init];
    record.commentTypeArray = [[NSMutableArray alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE]]) {
        
        NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE];
        [record.likeTypeArray addObject:item];
        record.likeCount = record.likeCount + 1;
        
        record.likeType = @"";
        if (record.likeTypeArray.count > 1) {
            record.likeType = record.likeTypeArray[0];
            for (int i = 1; i < record.likeTypeArray.count; i++) {
                record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
            }
        } else if (record.likeTypeArray.count == 1) {
            record.likeType = record.likeTypeArray[0];
        }
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
            [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
                
                if (posts.data.count > 0) {
                    
                    Post *updatedData = posts.data[0];
                    
                    [updatedData setLikeCount:record.likeCount];
                    [updatedData setLikeType:record.likeType];
                    
                    [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                        NSLog(@"Post Like is succeed!");
                    } error:^(Fault *fault) {
                        NSLog(@"Post Like is failed!");
                    }];
                } else {
                    NSLog(@"Post Like is not found!");
                }
            } error:^(Fault *fault) {
                NSLog(@"Post Like is time out!");
                
            }];
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
            
            [deviceIDArray addObject:[record.postUser getProperty:KEY_DEVICE_ID]];
            
            PublishOptions *options = [PublishOptions new];
            options.headers = @{@"ios-alert":ALERT_UPVOTE,
                                @"ios-badge":PUSH_BADGE,
                                @"ios-sound":PUSH_SOUND,
                                @"android-ticker-text":PUSH_TITLE,
                                @"android-content-title":PUSH_TITLE,
                                @"android-content-text":ALERT_UPVOTE};
            
            DeliveryOptions *deliveryOptions = [DeliveryOptions new];
            deliveryOptions.pushSinglecast = deviceIDArray;
            
            [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_UPVOTE publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                NSLog(@"showMessageStatus: %@", res.status);
            } error:^(Fault *fault) {
                NSLog(@"sendMessage: fault = %@", fault);
            }];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            Notification *notification = [Notification new];
            notification.type = NOTI_UPVOTE;
            notification.fromUser = [GlobalData sharedGlobalData].g_currentUser;
            notification.toUser = record.postUser;
            notification.time = [[GlobalData sharedGlobalData] getCurrentDate];
            notification.postId = record.objectId;
            notification.userId = record.userId;
            notification.commentId = @"";
            [backendless.persistenceService save:notification];
        });
    }
}

+ (void)dislikePostInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    UIButton *btn = (UIButton*)sender;
    
    PostData *record = [[PostData alloc] init];
    record.commentTypeArray = [[NSMutableArray alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE]]) {
        
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"downvote_normal"]]) {
            
            [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
            
            NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE];
            [record.likeTypeArray addObject:item];
            record.likeCount = record.likeCount - 1;
            
            record.likeType = @"";
            if (record.likeTypeArray.count > 1) {
                record.likeType = record.likeTypeArray[0];
                for (int i = 1; i < record.likeTypeArray.count; i++) {
                    record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
                }
            } else if (record.likeTypeArray.count == 1) {
                record.likeType = record.likeTypeArray[0];
            }
            
            [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BackendlessDataQuery *query = [BackendlessDataQuery query];
                query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
                [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
                    
                    if (posts.data.count > 0) {
                        
                        Post *updatedData = posts.data[0];
                        
                        [updatedData setLikeCount:record.likeCount];
                        [updatedData setLikeType:record.likeType];
                        
                        [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                            NSLog(@"Post Disike is succeed!");
                        } error:^(Fault *fault) {
                            NSLog(@"Post Disike is failed!");
                        }];
                    } else {
                        NSLog(@"Post Disike is not found!");
                    }
                } error:^(Fault *fault) {
                    NSLog(@"Post Disike is time out!");
                }];
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                
                [deviceIDArray addObject:[record.postUser getProperty:KEY_DEVICE_ID]];
                
                PublishOptions *options = [PublishOptions new];
                options.headers = @{@"ios-alert":ALERT_DOWNVOTE,
                                    @"ios-badge":PUSH_BADGE,
                                    @"ios-sound":PUSH_SOUND,
                                    @"android-ticker-text":PUSH_TITLE,
                                    @"android-content-title":PUSH_TITLE,
                                    @"android-content-text":ALERT_DOWNVOTE};
                
                DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                deliveryOptions.pushSinglecast = deviceIDArray;
                
                [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_DOWNVOTE publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                    NSLog(@"showMessageStatus: %@", res.status);
                } error:^(Fault *fault) {
                    NSLog(@"sendMessage: fault = %@", fault);
                }];
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                Notification *notification = [Notification new];
                notification.type = NOTI_DOWNVOTE;
                notification.fromUser = [GlobalData sharedGlobalData].g_currentUser;
                notification.toUser = record.postUser;
                notification.time = [[GlobalData sharedGlobalData] getCurrentDate];
                notification.postId = record.objectId;
                notification.userId = record.userId;
                notification.commentId = @"";
                [backendless.persistenceService save:notification];
            });
            
        }
        
    }
    
}

+ (void)likeCommentInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    CommentData *record = [[CommentData alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE]]) {
        
        NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE];
        [record.likeTypeArray addObject:item];
        record.likeCount = record.likeCount + 1;
        
        record.likeType = @"";
        if (record.likeTypeArray.count > 1) {
            record.likeType = record.likeTypeArray[0];
            for (int i = 1; i < record.likeTypeArray.count; i++) {
                record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
            }
        } else if (record.likeTypeArray.count == 1) {
            record.likeType = record.likeTypeArray[0];
        }
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
            [[backendless.persistenceService of:[Comment class]] find:query response:^(BackendlessCollection *comments) {
                
                if (comments.data.count > 0) {
                    
                    Comment *updatedData = comments.data[0];
                    
                    [updatedData setLikeCount:record.likeCount];
                    [updatedData setLikeType:record.likeType];
                    
                    [[backendless.persistenceService of:[Comment class]] save:updatedData response:^(id response) {
                        NSLog(@"Comment Like is succeed!");
                    } error:^(Fault *fault) {
                        NSLog(@"Comment Like is failed!");
                    }];
                } else {
                    NSLog(@"Comment Like is not found!");
                }
            } error:^(Fault *fault) {
                NSLog(@"Comment Like is time out!");
            }];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
            
            [deviceIDArray addObject:[record.toUser getProperty:KEY_DEVICE_ID]];
            
            PublishOptions *options = [PublishOptions new];
            options.headers = @{@"ios-alert":ALERT_COMMENT_UPVOTE,
                                @"ios-badge":PUSH_BADGE,
                                @"ios-sound":PUSH_SOUND,
                                @"android-ticker-text":PUSH_TITLE,
                                @"android-content-title":PUSH_TITLE,
                                @"android-content-text":ALERT_COMMENT_UPVOTE};
            
            DeliveryOptions *deliveryOptions = [DeliveryOptions new];
            deliveryOptions.pushSinglecast = deviceIDArray;
            
            [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_COMMENT_UPVOTE publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                NSLog(@"showMessageStatus: %@", res.status);
            } error:^(Fault *fault) {
                NSLog(@"sendMessage: fault = %@", fault);
            }];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            Notification *notification = [Notification new];
            notification.type = NOTI_COMMENT_UPVOTE;
            notification.fromUser = [GlobalData sharedGlobalData].g_currentUser;
            notification.toUser = record.toUser;
            notification.time = [[GlobalData sharedGlobalData] getCurrentDate];
            notification.commentId = record.objectId;
            notification.postId = record.postId;
            notification.userId = record.toUser.objectId;
            [backendless.persistenceService save:notification];
        });
    }
    
}

+ (void)dislikeCommentInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    UIButton *btn = (UIButton*)sender;
    
    CommentData *record = [[CommentData alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE]]) {
        
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"downvote_normal"]]) {
            
            [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
            
            NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE];
            [record.likeTypeArray addObject:item];
            record.likeCount = record.likeCount - 1;
            
            record.likeType = @"";
            if (record.likeTypeArray.count > 1) {
                record.likeType = record.likeTypeArray[0];
                for (int i = 1; i < record.likeTypeArray.count; i++) {
                    record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
                }
            } else if (record.likeTypeArray.count == 1) {
                record.likeType = record.likeTypeArray[0];
            }
            
            [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BackendlessDataQuery *query = [BackendlessDataQuery query];
                query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
                [[backendless.persistenceService of:[Comment class]] find:query response:^(BackendlessCollection *comments) {
                    
                    if (comments.data.count > 0) {
                        
                        Comment *updatedData = comments.data[0];
                        
                        [updatedData setLikeCount:record.likeCount];
                        [updatedData setLikeType:record.likeType];
                        
                        [[backendless.persistenceService of:[Comment class]] save:updatedData response:^(id response) {
                            NSLog(@"Comment Disike is succeed!");
                        } error:^(Fault *fault) {
                            NSLog(@"Comment Disike is failed!");
                        }];
                    } else {
                        NSLog(@"Comment Disike is not found!");
                    }
                } error:^(Fault *fault) {
                    NSLog(@"Comment Disike is time out!");
                }];
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                
                [deviceIDArray addObject:[record.toUser getProperty:KEY_DEVICE_ID]];
                
                PublishOptions *options = [PublishOptions new];
                options.headers = @{@"ios-alert":ALERT_COMMENT_DOWNVOTE,
                                    @"ios-badge":PUSH_BADGE,
                                    @"ios-sound":PUSH_SOUND,
                                    @"android-ticker-text":PUSH_TITLE,
                                    @"android-content-title":PUSH_TITLE,
                                    @"android-content-text":ALERT_COMMENT_DOWNVOTE};
                
                DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                deliveryOptions.pushSinglecast = deviceIDArray;
                
                [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_COMMENT_DOWNVOTE publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                    NSLog(@"showMessageStatus: %@", res.status);
                } error:^(Fault *fault) {
                    NSLog(@"sendMessage: fault = %@", fault);
                }];
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                Notification *notification = [Notification new];
                notification.type = NOTI_COMMENT_DOWNVOTE;
                notification.fromUser = [GlobalData sharedGlobalData].g_currentUser;
                notification.toUser = record.toUser;
                notification.time = [[GlobalData sharedGlobalData] getCurrentDate];
                notification.commentId = record.objectId;
                notification.postId = record.postId;
                notification.userId = record.toUser.objectId;
                [backendless.persistenceService save:notification];
            });
        }
    }
}

+ (void)onSendBroadcastNotification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *strAlert = [NSString stringWithFormat:@"%@ %@", [GlobalData sharedGlobalData].g_currentUser.name, ALERT_POST];
        
        PublishOptions *options = [PublishOptions new];
        options.headers = @{@"ios-alert":strAlert,
                            @"ios-badge":PUSH_BADGE,
                            @"ios-sound":PUSH_SOUND,
                            @"android-ticker-text":PUSH_TITLE,
                            @"android-content-title":PUSH_TITLE,
                            @"android-content-text":strAlert};
        
        DeliveryOptions *deliveryOptions = [DeliveryOptions new];
        [deliveryOptions pushBroadcast:FOR_ALL];
        
        [backendless.messagingService publish:MESSAGING_CHANNEL message:strAlert publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
            NSLog(@"showBroadcastMessageStatus: %@", res.status);
        } error:^(Fault *fault) {
            NSLog(@"sendBroadcastMessage: fault = %@", fault);
        }];
    });
}

+ (void)shareToSicial:(NSInteger)type viewCtrl:(UIViewController*)viewController text:(NSString*)text imageUrl:(NSString*)imageUrl {
    
    NSData *strdata = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *contentValue = [[NSString alloc] initWithData:strdata encoding:NSNonLossyASCIIStringEncoding];
    
    NSURL *imageURL = [NSURL URLWithString:imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    switch (type) {
        case 0: // Facebook
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ) {
                SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

                [fbSheet addImage:image];
                [fbSheet setInitialText:contentValue];
                
                [fbSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                    if (result == SLComposeViewControllerResultDone) {
                        NSLog(@"Posted");
                        [[GlobalData sharedGlobalData] onErrorAlert:@"Post Sharing to Facebook is succeed."];
                    } else if (result == SLComposeViewControllerResultCancelled) {
                        NSLog(@"Post Cancelled");
                    } else {
                        NSLog(@"Post Failed");
                        [[GlobalData sharedGlobalData] onErrorAlert:@"Post Sharing to Facebook is failed. Please try again."];
                    }
                }];
                
                [viewController presentViewController:fbSheet animated:true completion:nil];
            }
            break;
        case 1: // Twitter
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] ) {
                SLComposeViewController* twSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [twSheet addImage:image];
                [twSheet setInitialText:contentValue];
                
                [twSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                    if (result == SLComposeViewControllerResultDone) {
                        NSLog(@"Posted");
                         [[GlobalData sharedGlobalData] onErrorAlert:@"Post Sharing to Twitter is succeed."];
                    } else if (result == SLComposeViewControllerResultCancelled) {
                        NSLog(@"Post Cancelled");
                    } else {
                        NSLog(@"Post Failed");
                        [[GlobalData sharedGlobalData] onErrorAlert:@"Post Sharing to Twitter is failed. Please try again."];
                    }
                }];
                
                [viewController presentViewController:twSheet animated:true completion:nil];
            }
            break;
        case 2: // Instagram
            {
                DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
                
                NSString *shareText = contentValue;
                NSURL *shareURL = [NSURL URLWithString:imageUrl];
                
                NSArray *activityItems = @[image, shareText, shareURL];
                
                UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[instagramActivity]];
                [viewController presentViewController:activityController animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}

@end
