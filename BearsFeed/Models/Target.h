//
//  Target.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/23/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) BackendlessUser *targetUser;

@end
