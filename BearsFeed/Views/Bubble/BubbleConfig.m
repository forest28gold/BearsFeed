//
//  BubbleConfig.m
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BubbleConfig.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define X_PROP SCREEN_WIDTH / 320
#define Y_PROP SCREEN_HEIGHT / 480  // 480

#define SIZE_PROP SCREEN_WIDTH / 320

#define SMALL_FONT_SIZE 12.0 * SIZE_PROP
#define LARGE_FONT_SIZE 14.0 * SIZE_PROP

#define LARGE_BUBBLE_SIZE 80
#define SMALL_BUBBLE_SIZE 60

@implementation BubbleConfig

+(NSArray *)getBubbleInfoArray
{
    NSMutableArray *createProDataArray = [NSMutableArray array];
    
    for (int i=0; i < [GlobalData sharedGlobalData].g_arrayTarget.count; i++) {
        
        Target *record = [GlobalData sharedGlobalData].g_arrayTarget[i];
        BackendlessUser *user = record.targetUser;
        
        int randomX = arc4random() % (int)(SCREEN_WIDTH - LARGE_BUBBLE_SIZE);
        int randomY = arc4random() % (400) + LARGE_BUBBLE_SIZE * 1.5;
        int randomWidth = arc4random() % (LARGE_BUBBLE_SIZE - SMALL_BUBBLE_SIZE) + SMALL_BUBBLE_SIZE;
        
        BubbleInfo *info = [[BubbleInfo alloc] init];
        info.bgColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
        info.frame = CGRectMake(randomX, randomY, randomWidth, randomWidth);
        info.titleFontSize = SMALL_FONT_SIZE;
        info.targetUser = user;
        
        [createProDataArray addObject:info];
    }
    
//    {
//        BubbleInfo *info = [[BubbleInfo alloc] init];
//        info.title = @"Title 1";
//        info.desc = @"This is the Description of Title 1 From BubbleInfo file.";
//        info.bgColor = [UIColor redColor];
//        info.frame = CGRectMake(110*X_PROP, 110*Y_PROP, LARGE_BUBBLE_SIZE*SIZE_PROP, LARGE_BUBBLE_SIZE*SIZE_PROP);
//        info.titleFontSize = LARGE_FONT_SIZE;
//        
//        [createProDataArray addObject:info];
//    }
    
    return createProDataArray;
}

+(void)addTapGestureToView:(UIView *)view
                    target:(id)target
                  selector:(SEL)selector
{
    view.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

@end
