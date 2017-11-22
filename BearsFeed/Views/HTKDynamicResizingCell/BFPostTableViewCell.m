//
//  BFPostTableViewCell.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/20/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//


#import "BFPostTableViewCell.h"

@interface BFPostTableViewCell () <TTTAttributedLabelDelegate>

@end

@implementation BFPostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Fix for contentView constraint warning
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    self.imgAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.imgAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgAvatar.contentMode = UIViewContentModeScaleToFill;
    self.imgAvatar.clipsToBounds = YES;
    self.imgAvatar.image = [UIImage imageNamed:@"avatar"];
    [self.contentView addSubview:self.imgAvatar];
    
    self.lblName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblName.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblName.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    self.lblName.textColor = [UIColor blackColor];
    self.lblName.numberOfLines = 0;
    self.lblName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblName];
    
    self.lblPost = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.lblPost.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblPost.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.lblPost.textColor = [UIColor darkGrayColor];
    self.lblPost.numberOfLines = 3;
    self.lblPost.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblPost.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.lblPost.delegate = self;
    [self.contentView addSubview:self.lblPost];
    
    self.btnReadMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    self.btnReadMore.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnReadMore.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnReadMore setTitle:@"Read More" forState:UIControlStateNormal];
    self.btnReadMore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    [self.btnReadMore setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btnReadMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.btnReadMore];
    
    self.btnUpVote = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.btnUpVote.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnUpVote.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnUpVote setImage:[UIImage imageNamed:@"upvote_normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnUpVote];
    
    self.lblVoteCount = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblVoteCount.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblVoteCount.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    self.lblVoteCount.textColor = [UIColor blackColor];
    self.lblVoteCount.textAlignment = NSTextAlignmentCenter;
    self.lblVoteCount.numberOfLines = 0;
    self.lblVoteCount.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblVoteCount];
    
    self.btnDownVote = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.btnDownVote.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDownVote.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnDownVote setImage:[UIImage imageNamed:@"downvote_normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnDownVote];
    
    self.btnShareFB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.btnShareFB.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnShareFB.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnShareFB setImage:[UIImage imageNamed:@"share_facebook"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnShareFB];
    
    self.btnShareTW = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.btnShareTW.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnShareTW.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnShareTW setImage:[UIImage imageNamed:@"share_twitter"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnShareTW];
    
    self.btnShareINS = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.btnShareINS.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnShareINS.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnShareINS setImage:[UIImage imageNamed:@"share_instagram"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnShareINS];
    
    self.lblShareCount = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblShareCount.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblShareCount.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    self.lblShareCount.textColor = [UIColor darkGrayColor];
    self.lblShareCount.numberOfLines = 0;
    self.lblShareCount.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblShareCount.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.lblShareCount];
    
    self.viewLineShare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
    self.viewLineShare.backgroundColor = [UIColor colorWithHexString:@"#dadada"];
    self.viewLineShare.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewLineShare.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewLineShare];
    
    self.btnComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    self.btnComment.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnComment.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnComment setImage:[UIImage imageNamed:@"comment_count_normal"] forState:UIControlStateNormal];
    [self.btnComment setTitle:@"  5 comments" forState:UIControlStateNormal];
    self.btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    [self.btnComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btnComment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.btnComment];
    
    self.imgTime = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.imgTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgTime.contentMode = UIViewContentModeScaleAspectFill;
    self.imgTime.image = [UIImage imageNamed:@"timestamp"];
    [self.contentView addSubview:self.imgTime];
    
    self.lblTimeStamp = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblTimeStamp.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTimeStamp.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    self.lblTimeStamp.textColor = [UIColor darkGrayColor];
    self.lblTimeStamp.numberOfLines = 0;
    self.lblTimeStamp.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblTimeStamp.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.lblTimeStamp];
    
    self.viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
    self.viewLine.backgroundColor = [UIColor colorWithHexString:@"#dadada"];
    self.viewLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewLine];
    
    self.btnReply = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    self.btnReply.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnReply.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnReply setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    [self.btnReply setTitle:@"  Reply" forState:UIControlStateNormal];
    self.btnReply.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [self.btnReply setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnReply];

    self.viewSeperate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    self.viewSeperate.backgroundColor = [UIColor colorWithHexString:@"#dadada"];
    self.viewSeperate.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewSeperate.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewSeperate];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imgAvatar, _lblName, _lblPost, _btnReadMore, _btnUpVote, _lblVoteCount, _btnDownVote, _btnShareFB, _btnShareTW, _btnShareINS, _lblShareCount, _viewLineShare, _btnComment, _imgTime, _lblTimeStamp, _viewLine, _btnReply, _viewSeperate);
    
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @18, @"avatarSize" : @40, @"sidePostBuffer" : @20, @"buttonVoteSize" : @30, @"buttonShareSize" : @30, @"buttonReadMoreSize" : @80, @"sideImageBuffer" : @35, @"imgPostSize" : @250, @"buttonCommentSize" : @120, @"sideTimeBuffer" : @95, @"sideTimeEndBuffer" : @15, @"imgTimeSize" : @20, @"verticalBuffer" : @15, @"verticalNameBuffer" : @25, @"verticalPostBuffer" : @8, @"imgPostHeight" : @1, @"verticalCommentBuffer" : @15, @"verticalVoteBuffer" : @35, @"verticalLineBuffer" : @10, @"commentHeight" : @20, @"lineHeight" : @1, @"replyHeight" : @36, @"seperateHeight" : @5};
        
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_imgAvatar(avatarSize)]-sideBuffer-[_lblName]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sidePostBuffer-[_lblPost]-[_btnUpVote(buttonVoteSize)]-sidePostBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sidePostBuffer-[_lblPost]-[_lblVoteCount(buttonVoteSize)]-sidePostBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sidePostBuffer-[_lblPost]-[_btnDownVote(buttonVoteSize)]-sidePostBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_btnReadMore(buttonReadMoreSize)]-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sidePostBuffer-[_btnShareFB(buttonShareSize)]-sideTimeEndBuffer-[_btnShareTW(buttonShareSize)]-sideTimeEndBuffer-[_btnShareINS(buttonShareSize)]-sideTimeEndBuffer-[_lblShareCount]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideImageBuffer-[_viewLineShare]-sideImageBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sidePostBuffer-[_btnComment]-sideTimeBuffer-[_imgTime(imgTimeSize)]-[_lblTimeStamp]-sideTimeEndBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideImageBuffer-[_viewLine]-sideImageBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_btnReply]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewSeperate]|" options:0 metrics:metricDict views:viewDict]];
    
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalNameBuffer-[_lblName]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalVoteBuffer-[_btnUpVote(buttonVoteSize)]-[_lblVoteCount(buttonVoteSize)]-[_btnDownVote(buttonVoteSize)]" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnReadMore(buttonVoteSize)]-verticalCommentBuffer-[_btnShareFB(buttonShareSize)]-verticalLineBuffer-[_viewLineShare(lineHeight)]-verticalCommentBuffer-[_btnComment(commentHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnReply(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnReadMore(buttonVoteSize)]-verticalCommentBuffer-[_btnShareTW(buttonShareSize)]-verticalLineBuffer-[_viewLineShare(lineHeight)]-verticalCommentBuffer-[_btnComment(commentHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnReply(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnReadMore(buttonVoteSize)]-verticalCommentBuffer-[_btnShareINS(buttonShareSize)]-verticalLineBuffer-[_viewLineShare(lineHeight)]-verticalCommentBuffer-[_btnComment(commentHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnReply(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnReadMore(buttonVoteSize)]-verticalCommentBuffer-[_lblShareCount(buttonShareSize)]-verticalLineBuffer-[_viewLineShare(lineHeight)]-verticalCommentBuffer-[_btnComment(commentHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnReply(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnReadMore(buttonVoteSize)]-verticalCommentBuffer-[_btnShareFB(buttonShareSize)]-verticalLineBuffer-[_viewLineShare(lineHeight)]-verticalCommentBuffer-[_imgTime(imgTimeSize)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnReply(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnReadMore(buttonVoteSize)]-verticalCommentBuffer-[_btnShareFB(buttonShareSize)]-verticalLineBuffer-[_viewLineShare(lineHeight)]-verticalCommentBuffer-[_lblTimeStamp(imgTimeSize)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnReply(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.imgAvatar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgAvatar setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblName setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblName setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblPost setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblPost setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnReadMore setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnReadMore setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnUpVote setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnUpVote setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblVoteCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblVoteCount setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnDownVote setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnDownVote setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnShareFB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnShareFB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnShareTW setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnShareTW setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnShareINS setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnShareINS setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblShareCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblShareCount setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewLineShare setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewLineShare setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnComment setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnComment setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.imgTime setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgTime setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblTimeStamp setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblTimeStamp setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewLine setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewLine setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnReply setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnReply setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    CGSize defaultSize = DEFAULT_CELL_SIZES;
    self.lblPost.preferredMaxLayoutWidth = defaultSize.width - ([metricDict[@"sidePostBuffer"] floatValue] * 2);
    
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height / 2;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.contentView];
}

- (void)setupCellWithPostData:(PostData *)postData {
    
    NSURL *imageAvatarURL = [NSURL URLWithString:[postData.postUser getProperty:KEY_PHOTO_URL]];
    [self.imgAvatar setShowActivityIndicatorView:YES];
    [self.imgAvatar setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.imgAvatar sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    self.lblName.text = postData.postUser.name;
    self.lblShareCount.text = @"";
    
    self.lblVoteCount.text = [[GlobalData sharedGlobalData] getFormattedCount:postData.likeCount];
    self.lblTimeStamp.text = [[GlobalData sharedGlobalData] getFormattedTimeStamp:postData.time];
    
    NSData *strdata = [postData.content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *contentValue = [[NSString alloc] initWithData:strdata encoding:NSNonLossyASCIIStringEncoding];
    self.lblPost.text = [NSString stringWithFormat:@"%@", contentValue];
    
    if (contentValue.length >= 100) {
        self.btnReadMore.hidden = NO;
    } else if (contentValue.length < 100 && [contentValue rangeOfString:@"\n"].location != NSNotFound) {
        self.btnReadMore.hidden = NO;
    } else {
        self.btnReadMore.hidden = YES;
    }
    
    [self.lblPost sizeToFit];
    NSInteger numberOfLines = floor(ceilf(CGRectGetHeight(self.lblPost.frame)) / self.lblPost.font.lineHeight);
//    NSLog(@"No of lines: %ld",(long)numberOfLines);
    
    if (numberOfLines == 2) {
        NSString *empty = @" \n \n";
        self.lblPost.text = [NSString stringWithFormat:@"%@ %@", contentValue, empty];
    } else if (numberOfLines == 1) {
        NSString *empty = @" \n \n \n";
        self.lblPost.text = [NSString stringWithFormat:@"%@ %@", contentValue, empty];
    } else {
        NSString *empty = @" \n \n";
        self.lblPost.text = [NSString stringWithFormat:@"%@ %@", contentValue, empty];
    }
    
    if (!postData.toggleReadMore) {
        self.lblPost.numberOfLines = 3;
        [self.btnReadMore setTitle:@"Read More" forState:UIControlStateNormal];
    } else {
        self.lblPost.numberOfLines = 0;
        [self.btnReadMore setTitle:@"Less" forState:UIControlStateNormal];
    }
    
    [self.btnComment setTitle:[[GlobalData sharedGlobalData] getFormattedCommentCount:postData.commentCount] forState:UIControlStateNormal];

    self.btnReadMore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
    self.btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
    self.btnReply.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
    
    if ([postData.commentTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
        [self.btnComment setImage:[UIImage imageNamed:@"comment_count"] forState:UIControlStateNormal];
    } else {
        [self.btnComment setImage:[UIImage imageNamed:@"comment_count_normal"] forState:UIControlStateNormal];
    }
    
    if ([postData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, LIKE_TYPE]]) {
        [self.btnUpVote setImage:[UIImage imageNamed:@"upvote"] forState:UIControlStateNormal];
        [self.btnDownVote setImage:[UIImage imageNamed:@"downvote_normal"] forState:UIControlStateNormal];
    } else if ([postData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userData.userId, DISLIKE_TYPE]]) {
        [self.btnUpVote setImage:[UIImage imageNamed:@"upvote_normal"] forState:UIControlStateNormal];
        [self.btnDownVote setImage:[UIImage imageNamed:@"downvote"] forState:UIControlStateNormal];
    } else {
        [self.btnUpVote setImage:[UIImage imageNamed:@"upvote_normal"] forState:UIControlStateNormal];
        [self.btnDownVote setImage:[UIImage imageNamed:@"downvote_normal"] forState:UIControlStateNormal];
    }
    
    if (postData.likeCount > 1) {
        [self.btnDownVote setEnabled:true];
    } else {
        [self.btnDownVote setEnabled:false];
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    [GlobalData sharedGlobalData].g_strPostLink = url.absoluteString;
    [[GlobalData sharedGlobalData].g_tabBar goToPostLink];
}

@end

