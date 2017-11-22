//
//  LLTabBar.h
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLTabBarDelegate;

@interface LLTabBar : UIView

@property (nonatomic, copy) NSArray *tabBarItems;
@property (nonatomic, weak) id <LLTabBarDelegate> delegate;

@end


@protocol LLTabBarDelegate <NSObject>

- (void)tabBarDidSelectedRiseButton;

@end
