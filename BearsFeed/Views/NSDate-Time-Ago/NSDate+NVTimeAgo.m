//
//  NSDate+NVTimeAgo.m
//  Adventures
//
//  Created by Nikil Viswanathan on 4/18/13.
//  Copyright (c) 2013 Nikil Viswanathan. All rights reserved.
//

#import "NSDate+NVTimeAgo.h"
#import "GlobalData.h"

@implementation NSDate (NVFacebookTimeAgo)


#define SECOND  1
#define MINUTE  (SECOND * 60)
#define HOUR    (MINUTE * 60)
#define DAY     (HOUR   * 24)
#define WEEK    (DAY    * 7)
#define MONTH   (DAY    * 31)
#define YEAR    (DAY    * 365.24)

/*
    Mysql Datetime Formatted As Time Ago
    Takes in a mysql datetime string and returns the Time Ago date format
 */
+ (NSString *)mysqlDatetimeFormattedAsTimeAgo:(NSString*)mysqlDatetime interval:(NSTimeInterval)interval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:mysqlDatetime];
    
    return [date formattedAsTimeAgo:interval];
    
}


/*
    Formatted As Time Ago
    Returns the date formatted as Time Ago (in the style of the mobile time ago date formatting for Facebook)
 */
- (NSString *)formattedAsTimeAgo:(NSTimeInterval)secondsSince
{
    
    //Should never hit this but handle the future case
    if(secondsSince < 0)
//        return @"In The Future";
        return @"just now";
    
    // < 1 minute = "Just now"
    if(secondsSince < MINUTE)
        return [self formatSecondsAgo:secondsSince];

    // < 1 hour = "x minutes ago"
    if(secondsSince < HOUR)
        return [self formatMinutesAgo:secondsSince];
  
    
    // Today = "x hours ago"
    if(secondsSince < DAY)
        return [self formatAsToday:secondsSince];
    
    // "x days ago"
    if(secondsSince < MONTH)
        return [self formatAsLastMonth:secondsSince];

    
    // < Last 30 days = "March 30 at 1:14 PM"
    if(secondsSince < YEAR)
        return [self formatAsLastYear:secondsSince];
    
    // Anything else = "September 9, 2011"
    return [self formatAsOther:secondsSince];
    
}

/*
   ========================== Formatting Methods ==========================
 */

- (NSString *)formatSecondsAgo:(NSTimeInterval)secondsSince
{
    if(secondsSince == 1)
        return @"just now";
    else
        return [NSString stringWithFormat:@"%d s ago", (int)secondsSince];
}

// < 1 hour = "x minutes ago"
- (NSString *)formatMinutesAgo:(NSTimeInterval)secondsSince
{
    //Convert to minutes
    int minutesSince = (int)secondsSince / MINUTE;

    if(minutesSince == 1)
        return @"1 min ago";
    else
        return [NSString stringWithFormat:@"%d mins ago", minutesSince];
}


// Today = "x hours ago"
- (NSString *)formatAsToday:(NSTimeInterval)secondsSince
{
    //Convert to hours
    int hoursSince = (int)secondsSince / HOUR;
    
    //Handle Plural
    if(hoursSince == 1)
        return @"1 hr ago";
    else
        return [NSString stringWithFormat:@"%d hrs ago", hoursSince];
}

// < Last 30 days = "March 30 at 1:14 PM"
- (NSString *)formatAsLastMonth:(NSTimeInterval)secondsSince
{
    int daySince = (int)secondsSince / DAY;
    int monthSince = (int)secondsSince / MONTH;
    
    //Handle Plural
    if (daySince == 1)
        return @"1 day ago";
    else if(monthSince == 1)
        return @"1 month ago";
    else if (monthSince < 1)
        return [NSString stringWithFormat:@"%d days ago", daySince];
    else
        return [NSString stringWithFormat:@"%d months ago", monthSince];
}


// < 1 year = "September 15"
- (NSString *)formatAsLastYear:(NSTimeInterval)secondsSince
{
    int monthSince = (int)secondsSince / MONTH;
    int yearSince = (int)secondsSince / YEAR;
    
    //Handle Plural
    if (monthSince == 1)
        return @"1 month ago";
    else if(yearSince == 1)
        return @"1 year ago";
    else if (yearSince < 1)
        return [NSString stringWithFormat:@"%d months ago", monthSince];
    else
        return [NSString stringWithFormat:@"%d years ago", yearSince];
}


// Anything else = "September 9, 2011"
- (NSString *)formatAsOther:(NSTimeInterval)secondsSince
{
    int yearSince = (int)secondsSince / YEAR;
    return [NSString stringWithFormat:@"%d years ago", yearSince];
}


/*
 =======================================================================
 */




@end
