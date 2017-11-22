//
//  BubbleInfo.h
//  BearsFeed
//
//  Created by AppsCreationTech on 4/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BubbleInfo : NSObject

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGRect frame;
@property (strong, nonatomic) BackendlessUser *targetUser;

@end
