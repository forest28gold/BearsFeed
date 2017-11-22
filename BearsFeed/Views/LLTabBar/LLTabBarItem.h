//
//  LLTabBarItem.h
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LLTabBarItemType) {
	LLTabBarItemNormal = 0,
	LLTabBarItemRise,
};

@interface LLTabBarItem : UIButton

@property (nonatomic, assign) LLTabBarItemType tabBarItemType;

@end
