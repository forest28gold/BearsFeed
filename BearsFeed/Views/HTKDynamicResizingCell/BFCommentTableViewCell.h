//
//  BFCommentTableViewCell.h
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
#define DEFAULT_CELL_SIZE_COMMENT (CGSize){[[UIScreen mainScreen] bounds].size.width, 200}

/**
 * Sample CollectionViewCell that implements the dynamic sizing protocol.
 */
@interface BFCommentTableViewCell : HTKDynamicResizingTableViewCell

@property (nonatomic, strong) UIImageView *imgAvatar;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) TTTAttributedLabel *lblPost;
@property (nonatomic, strong) UIButton *btnReadMore;
@property (nonatomic, strong) UIButton *btnUpVote;
@property (nonatomic, strong) UILabel *lblVoteCount;
@property (nonatomic, strong) UIButton *btnDownVote;
@property (nonatomic, strong) UIImageView *imgTime;
@property (nonatomic, strong) UILabel *lblTimeStamp;
@property (nonatomic, strong) UIView *viewSeperate;

/**
 * Sets up the cell with data
 */
- (void)setupCellWithData:(CommentData *)commentData;

@end
