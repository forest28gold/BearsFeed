//
//  BFFeedTableViewCell.h
//  BearsFeed
//
//  Created by AppsCreationTech on 3/20/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HTKDynamicResizingTableViewCell.h"
#import "HTKDynamicResizingCellProtocol.h"

/**
 * Default cell size. This is required to properly size cells.
 */
#define DEFAULT_CELL_SIZES_FEED (CGSize){[[UIScreen mainScreen] bounds].size.width, 375}

/**
 * Sample CollectionViewCell that implements the dynamic sizing protocol.
 */
@interface BFFeedNewTableViewCell : HTKDynamicResizingTableViewCell

@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) TTTAttributedLabel *lblPost;

@property (nonatomic, strong) UIButton *btnShareFB;
@property (nonatomic, strong) UIButton *btnShareTW;
@property (nonatomic, strong) UIButton *btnShareINS;
@property (nonatomic, strong) UILabel *lblShareCount;

@property (nonatomic, strong) UIView *viewSeperate;

/**
 * Sets up the cell with data
 */
- (void)setupCellWithFeedData:(PostData *)feedData;

@end
