//
//  BFUtility.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/20/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFUtility : NSObject

+ (void)likePostInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;
+ (void)dislikePostInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;

+ (void)likeCommentInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;
+ (void)dislikeCommentInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;

+ (void)onSendBroadcastNotification;

+ (void)shareToSicial:(NSInteger)type viewCtrl:(UIViewController*)viewController text:(NSString*)text imageUrl:(NSString*)imageUrl;

@end
