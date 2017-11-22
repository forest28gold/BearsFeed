//
//  BFPostPhotoTableViewCell.h
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
#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 375}

/**
 * Sample CollectionViewCell that implements the dynamic sizing protocol.
 */
@interface BFPostPhotoTableViewCell : HTKDynamicResizingTableViewCell

@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) TTTAttributedLabel *lblPost;
@property (nonatomic, strong) UIButton *btnReadMore;
@property (nonatomic, strong) UIButton *btnUpVote;
@property (nonatomic, strong) UILabel *lblVoteCount;
@property (nonatomic, strong) UIButton *btnDownVote;
@property (nonatomic, strong) UIImageView *imgPost;
@property (nonatomic, strong) UIButton *btnPhoto;

@property (nonatomic, strong) UIButton *btnShareFB;
@property (nonatomic, strong) UIButton *btnShareTW;
@property (nonatomic, strong) UIButton *btnShareINS;
@property (nonatomic, strong) UILabel *lblShareCount;
@property (nonatomic, strong) UIView *viewLineShare;

@property (nonatomic, strong) UIButton *btnComment;
@property (nonatomic, strong) UIImageView *imgTime;
@property (nonatomic, strong) UILabel *lblTimeStamp;
@property (nonatomic, strong) UIView *viewLine;
@property (nonatomic, strong) UIButton *btnReply;
@property (nonatomic, strong) UIView *viewSeperate;

/**
 * Sets up the cell with data
 */
- (void)setupCellWithPhotoData:(PostData *)postData;

@end
