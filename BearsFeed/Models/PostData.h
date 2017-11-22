//
//  PostData.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/19/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostData : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) BackendlessUser *postUser;
@property (strong, nonatomic) NSString *time;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) int reportCount;
@property (strong, nonatomic) NSString *commentType;
@property (strong, nonatomic) NSString *likeType;
@property (strong, nonatomic) NSString *reportType;
@property (strong, nonatomic) NSMutableArray *commentTypeArray;
@property (strong, nonatomic) NSMutableArray *likeTypeArray;
@property (strong, nonatomic) NSMutableArray *reportTypeArray;
@property (nonatomic, assign) BOOL toggleReadMore;
@property (nonatomic, assign) BOOL toggleTwitterBearsFeedIsOn;
@property (strong, nonatomic) NSString *twitterName;
@property (strong, nonatomic) NSString *twitterID;
@property (strong, nonatomic) NSString *twitterProfileUrl;

@end
