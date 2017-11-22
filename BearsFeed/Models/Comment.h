//
//  Comment.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/21/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) BackendlessUser *fromUser;
@property (strong, nonatomic) BackendlessUser *toUser;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *time;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) int reportCount;
@property (strong, nonatomic) NSString *likeType;
@property (strong, nonatomic) NSString *reportType;

@end
