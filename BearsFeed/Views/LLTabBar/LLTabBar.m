//
//  LLTabBar.m
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//

#import "LLTabBar.h"
#import "LLTabBarItem.h"

@implementation LLTabBar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self config];
	}
	
	return self;
}

#pragma mark - Private Method

- (void)config {
	self.backgroundColor = [UIColor colorWithHexString:@"2ecc71"];
	UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, [[UIScreen mainScreen] bounds].size.width, 5)];
	topLine.image = [UIImage imageNamed:@"tapbar_top_line"];
	[self addSubview:topLine];
}

- (void)setSelectedIndex:(NSInteger)index {
	for (LLTabBarItem *item in self.tabBarItems) {
		if (item.tag == index) {
			item.selected = YES;
		} else {
			item.selected = NO;
		}
	}
	
	if ([GlobalData sharedGlobalData].g_tabBar) {
		[GlobalData sharedGlobalData].g_tabBar.selectedIndex = index;
        
        if (index == 0) {
            [GlobalData sharedGlobalData].g_toggleRefreshIsOn = true;
        } else {
            [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
        }
	}
}

#pragma mark - Touch Event

- (void)itemSelected:(LLTabBarItem *)sender {
	if (sender.tabBarItemType != LLTabBarItemRise) {
		[self setSelectedIndex:sender.tag];
	} else {
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton)]) {
				[self.delegate tabBarDidSelectedRiseButton];
			}
		}
	}
}

#pragma mark - Setter

- (void)setTabBarItems:(NSArray *)tabBarItems {
	_tabBarItems = tabBarItems;
	NSInteger itemTag = 0;
	for (id item in tabBarItems) {
		if ([item isKindOfClass:[LLTabBarItem class]]) {
			if (itemTag == 0) {
				((LLTabBarItem *)item).selected = YES;
			}
			[((LLTabBarItem *)item) addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchDown];
			[self addSubview:item];
			if (((LLTabBarItem *)item).tabBarItemType != LLTabBarItemRise) {
				((LLTabBarItem *)item).tag = itemTag;
				itemTag++;
			}
		}
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
