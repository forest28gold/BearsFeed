//
//  GlobalData.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

static GlobalData *_globalData = nil;

+ (GlobalData *) sharedGlobalData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalData == nil) {
            _globalData = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalData;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        [self setG_appDelegate:[[UIApplication sharedApplication] delegate]];       
    }
    
    return self;
}

# pragma mark - Trim string

- (NSString *) trimString:(NSString *) string
{   
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)getCurrentDate {
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Min
    [formatter setDateFormat:@"mm"];
    NSString *currentMinString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Second
    [formatter setDateFormat:@"ss"];
    NSString *currentSecondString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@", currentMonthString, currentDateString, currentyearString, currentHourString, currentMinString, currentSecondString];
}

- (NSString*)getFormattedCount:(int)count {
    
    NSString *strCount = @"0";
    
    if (count == 0) {
        strCount = @"0";
    } else if (count < 1000) {
        strCount = [NSString stringWithFormat:@"%i", count];
    } else if (count >= 1000 && count < 1000000) {
        float count_dec = count / 1000;
        strCount = [NSString stringWithFormat:@"%0.0fK", count_dec];
    } else {
        float count_dec = count / 1000000;
        strCount = [NSString stringWithFormat:@"%0.0fM", count_dec];
    }
    
    return strCount;
}

- (NSString*)getFormattedCommentCount:(int)count {
    
    NSString *strCount = @" ";
    
    if (count == 0) {
        strCount = @"  No comment";
    } else if (count == 1) {
        strCount = [NSString stringWithFormat:@"  %i comment", count];
    } else if (count < 1000) {
        strCount = [NSString stringWithFormat:@"  %i comments", count];
    } else if (count >= 1000 && count < 1000000) {
        float count_dec = count / 1000;
        strCount = [NSString stringWithFormat:@"  %0.0fK comments", count_dec];
    } else {
        float count_dec = count / 1000000;
        strCount = [NSString stringWithFormat:@"  %0.0fM comments", count_dec];
    }
    
    return strCount;
}

- (NSString*)getFormattedTimeStamp:(NSString*)time {

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate* firstDate = [dateFormatter dateFromString:[self getCurrentDate]];
    NSDate* secondDate = [dateFormatter dateFromString:time];
    
    NSTimeInterval timeDifference = -(int)[secondDate timeIntervalSinceDate:firstDate];
    
    return [NSDate mysqlDatetimeFormattedAsTimeAgo:time interval:timeDifference];
}

- (NSString*)getFormattedTwitterTimeStamp:(NSString*)time {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDateFormatter* dateFormatterTwitter = [[NSDateFormatter alloc] init];
    [dateFormatterTwitter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatterTwitter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate* firstDate = [dateFormatter dateFromString:[self getCurrentDate]];
    NSDate* secondDate = [dateFormatterTwitter dateFromString:time];
    
    NSString* strTime = [dateFormatter stringFromDate:secondDate];
    
    NSTimeInterval timeDifference = -(int)[secondDate timeIntervalSinceDate:firstDate];
    
    return [NSDate mysqlDatetimeFormattedAsTimeAgo:strTime interval:timeDifference];
}

- (PostData*)onParsePostData:(Post*)post {
    
    PostData *record = [[PostData alloc] init];
    record.objectId = post.objectId;
    record.content = post.content;
    record.type = post.type;
    record.filePath = post.filePath;
    record.userId = post.userId;
    record.postUser = post.postUser;
    record.time = post.time;
    record.commentCount = post.commentCount;
    record.likeCount = post.likeCount;
    record.commentType = post.commentType;
    record.likeType = post.likeType;
    record.reportCount = post.reportCount;
    record.reportType = post.reportType;
    record.toggleReadMore = false;
    
    record.toggleTwitterBearsFeedIsOn = false;
    record.twitterProfileUrl = @"";
    record.twitterName = @"";
    record.twitterID = @"";
    
    record.commentTypeArray = [[NSMutableArray alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    
    if (record.commentType != nil && ![record.commentType isEqualToString:@""]) {
        
        if ([record.commentType containsString:@";"]) {
            NSArray *itemsComment = [post.commentType componentsSeparatedByString:@";"];
            record.commentTypeArray = [itemsComment mutableCopy];
        } else {
            [record.commentTypeArray addObject:record.commentType];
        }
    }
    
    if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
        
        if ([record.likeType containsString:@";"]) {
            NSArray *itemsLike = [post.likeType componentsSeparatedByString:@";"];
            record.likeTypeArray = [itemsLike mutableCopy];
        } else {
            [record.likeTypeArray addObject:record.likeType];
        }
    }
    
    if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
        
        if ([record.reportType containsString:@";"]) {
            NSArray *itemsLike = [post.reportType componentsSeparatedByString:@";"];
            record.reportTypeArray = [itemsLike mutableCopy];
        } else {
            [record.reportTypeArray addObject:record.reportType];
        }
    }
    
    return record;
}

- (PostData*)onParseTwitterData:(NSDictionary*)status {
    
    PostData *record = [[PostData alloc] init];
    record.objectId = @"";
    record.content = [status valueForKey:@"text"];
    record.userId = @"";
    record.postUser = nil;
    record.time = [self setFormattedTwitterTimeStamp:[status valueForKey:@"created_at"]];
    record.commentCount = 0;
    record.likeCount = 0;
    record.commentType = @"";
    record.likeType = @"";
    record.reportCount = 0;
    record.reportType = @"";
    record.toggleReadMore = false;
    record.toggleTwitterBearsFeedIsOn = true;
    record.twitterProfileUrl = [status valueForKeyPath:@"user.profile_image_url"];
    record.twitterName = [status valueForKeyPath:@"user.name"];
    record.twitterID = [status valueForKeyPath:@"user.screen_name"];
    
    record.commentTypeArray = [[NSMutableArray alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    
    NSArray *mediaType = [status valueForKeyPath:@"entities.media"];
    
    if (mediaType != nil) {
        
        NSDictionary *media = [mediaType objectAtIndex:0];
        
        if ([[media valueForKeyPath:@"type"] isEqualToString:@"photo"]) {
            record.type = POST_TYPE_PHOTO;
            record.filePath = [media valueForKeyPath:@"media_url_https"];
        } else {
            record.type = POST_TYPE_TEXT;
            record.filePath = @"";
        }
        
    } else {
        record.type = POST_TYPE_TEXT;
        record.filePath = @"";
    }
    
    return record;
}

- (NSString*)setFormattedTwitterTimeStamp:(NSString*)time {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDateFormatter* dateFormatterTwitter = [[NSDateFormatter alloc] init];
    [dateFormatterTwitter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatterTwitter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate* secondDate = [dateFormatterTwitter dateFromString:time];
    NSString* strTime = [dateFormatter stringFromDate:secondDate];
    
    return strTime;
}

- (CommentData*)onParseCommentData:(Comment*)comment {
    
    CommentData *record = [[CommentData alloc] init];
    record.objectId = comment.objectId;
    record.postId = comment.postId;
    record.comment = comment.comment;
    record.fromUser = comment.fromUser;
    record.toUser = comment.toUser;
    record.time = comment.time;
    record.likeCount = comment.likeCount;
    record.likeType = comment.likeType;
    record.reportCount = comment.reportCount;
    record.reportType = comment.reportType;
    record.toggleReadMore = false;
    
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    
    if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
        
        if ([record.likeType containsString:@";"]) {
            NSArray *itemsLike = [comment.likeType componentsSeparatedByString:@";"];
            record.likeTypeArray = [itemsLike mutableCopy];
        } else {
            [record.likeTypeArray addObject:record.likeType];
        }
    }
    
    if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
        
        if ([record.reportType containsString:@";"]) {
            NSArray *itemsLike = [comment.reportType componentsSeparatedByString:@";"];
            record.reportTypeArray = [itemsLike mutableCopy];
        } else {
            [record.reportTypeArray addObject:record.reportType];
        }
    }
    
    return record;
}

- (FeedData*)onParseFeedData:(NSDictionary*)status {
    
    FeedData *record = [[FeedData alloc] init];
    record.profileUrl = [status valueForKeyPath:@"user.profile_image_url"];
    record.userName = [status valueForKeyPath:@"user.name"];
    record.userID = [status valueForKeyPath:@"user.screen_name"];
    record.content = [status valueForKey:@"text"];
    record.time = [status valueForKey:@"created_at"];
    record.toggleReadMore = false;
    
    NSArray *mediaType = [status valueForKeyPath:@"entities.media"];
    
    if (mediaType != nil) {
        
        NSDictionary *media = [mediaType objectAtIndex:0];
        
        if ([[media valueForKeyPath:@"type"] isEqualToString:@"photo"]) {
            record.type = POST_TYPE_PHOTO;
            record.filePath = [media valueForKeyPath:@"media_url_https"];
        } else {
            record.type = POST_TYPE_TEXT;
            record.filePath = @"";
        }
        
    } else {
        record.type = POST_TYPE_TEXT;
        record.filePath = @"";
    }
    
    return record;
}

- (void)onErrorAlert:(NSString*)errorString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:errorString
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
