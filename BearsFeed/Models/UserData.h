//
//  UserData.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/19/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *photoUrl;
@property (strong, nonatomic) NSString *signup;
@property (strong, nonatomic) NSString *fbId;
@property (strong, nonatomic) NSString *socialRole;
@property (strong, nonatomic) NSString *verificationCode;
@property (nonatomic, assign) int score;

@end
