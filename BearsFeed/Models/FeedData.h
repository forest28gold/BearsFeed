//
//  FeedData.h
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedData : NSObject

@property (strong, nonatomic) NSString *profileUrl;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *time;
@property (nonatomic, assign) BOOL toggleReadMore;

@end
