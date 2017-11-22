//
//  Notification.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/23/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) BackendlessUser *fromUser;
@property (strong, nonatomic) BackendlessUser *toUser;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *time;

@end
