//
//  DataModel.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define TABLE_USER                      @"bearsfeed_user"

#define FIELD_USER_ID                   @"userId"
#define FIELD_DEVICE_ID                 @"deviceId"
#define FIELD_USERNAME                  @"userName"
#define FIELD_EMAIL                     @"email"
#define FIELD_PASSWORD                  @"password"
#define FIELD_BIO                       @"bio"
#define FIELD_PHOTO_URL                 @"photoUrl"
#define FIELD_SIGNUP             		@"signup"
#define FIELD_BEARS_SCORE         		@"bearsScore"
#define FIELD_USER_ROLE         		@"userRole"
#define FIELD_FB_ID             		@"fbId"


@interface DataModel : NSObject

@property (nonatomic) sqlite3 *dbHandler;


+ (BOOL)createTable:(sqlite3 *)dbHandler;
- (id)initWithDBHandler:(sqlite3*)dbHandler;
- (BOOL)updateUserDB;

@end
