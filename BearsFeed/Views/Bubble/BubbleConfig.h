//
//  BubbleConfig.h
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BubbleInfo.h"

@interface BubbleConfig : NSObject

// Returns an Array of "BubbleInfo" objects
+(NSArray *)getBubbleInfoArray;

// Adds Tap gesture to view
+(void)addTapGestureToView:(UIView *)view
                    target:(id)target
                  selector:(SEL)selector;

@end
