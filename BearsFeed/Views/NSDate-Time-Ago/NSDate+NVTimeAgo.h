//
//  NSDate+NVTimeAgo.h
//  Adventures
//
//  Created by Nikil Viswanathan on 4/18/13.
//  Copyright (c) 2013 Nikil Viswanathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NVFacebookTimeAgo)

/*
    Mysql Datetime Formatted As Time Ago
    Takes in a mysql datetime string and returns the Time Ago date format
 */
+ (NSString*)mysqlDatetimeFormattedAsTimeAgo:(NSString *)mysqlDatetime interval:(NSTimeInterval)interval;

/*
    Formatted As Time Ago
    Returns the time formatted as Time Ago (in the style of Facebook's mobile date formatting)
 */
- (NSString *)formattedAsTimeAgo:(NSTimeInterval)secondsSince;

@end
