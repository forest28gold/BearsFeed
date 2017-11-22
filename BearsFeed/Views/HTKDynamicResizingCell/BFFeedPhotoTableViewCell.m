//
//  BFFeedPhotoTableViewCell.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/20/17.
//  Copyright © 2017 Henry Lee. All rights reserved.
//


#import "BFFeedPhotoTableViewCell.h"

@interface BFFeedPhotoTableViewCell () <TTTAttributedLabelDelegate>

@end

@implementation BFFeedPhotoTableViewCell

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
    self.lblName.textColor = [UIColor colorWithHexString:@"7b7b7b"];
    self.lblName.numberOfLines = 0;
    self.lblName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblName];
    
    self.lblPost = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.lblPost.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblPost.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.lblPost.textColor = [UIColor darkGrayColor];
    self.lblPost.numberOfLines = 0;
    self.lblPost.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblPost.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.lblPost.delegate = self;
    [self.contentView addSubview:self.lblPost];
    
    self.imgPost = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.imgPost.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgPost.contentMode = UIViewContentModeScaleAspectFill;
    self.imgPost.image = [UIImage imageNamed:@"loading"];
    self.imgPost.clipsToBounds = YES;
    [self.contentView addSubview:self.imgPost];
    
    self.btnPhoto = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.btnPhoto.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnPhoto setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.btnPhoto];
    
    self.viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
    self.viewLine.backgroundColor = [UIColor colorWithHexString:@"#dadada"];
    self.viewLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewLine.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewLine];
    
    self.btnPost = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 36)];
    self.btnPost.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnPost.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnPost setImage:[UIImage imageNamed:@"repost"] forState:UIControlStateNormal];
    [self.btnPost setTitle:@"  Post" forState:UIControlStateNormal];
    self.btnPost.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [self.btnPost setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnPost];
    
    self.btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 36)];
    self.btnEdit.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnEdit.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnEdit setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.btnEdit setTitle:@"  Edit" forState:UIControlStateNormal];
    self.btnEdit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [self.btnEdit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnEdit];

    self.viewSeperate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    self.viewSeperate.backgroundColor = [UIColor colorWithHexString:@"#dadada"];
    self.viewSeperate.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewSeperate.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewSeperate];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imgAvatar, _lblName, _lblPost, _imgPost, _btnPhoto, _viewLine, _btnPost, _btnEdit, _viewSeperate);
    
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @18, @"avatarSize" : @40, @"sidePostBuffer" : @20, @"buttonVoteSize" : @30, @"buttonShareSize" : @30, @"buttonReadMoreSize" : @80, @"sideImageBuffer" : @35, @"imgPostSize" : @250, @"buttonRepost" : @160, @"sideTimeBuffer" : @95, @"sideTimeEndBuffer" : @15, @"imgTimeSize" : @20, @"verticalBuffer" : @15, @"verticalNameBuffer" : @25, @"verticalPostBuffer" : @8, @"imgPostHeight" : @180, @"verticalCommentBuffer" : @15, @"verticalVoteBuffer" : @35, @"verticalLineBuffer" : @10, @"commentHeight" : @20, @"lineHeight" : @1, @"replyHeight" : @36, @"seperateHeight" : @5};
        
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_imgAvatar(avatarSize)]-sideBuffer-[_lblName]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sidePostBuffer-[_lblPost]-sidePostBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideImageBuffer-[_imgPost]-sideImageBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideImageBuffer-[_btnPhoto]-sideImageBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideImageBuffer-[_viewLine]-sideImageBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_btnPost(buttonRepost)]-[_btnEdit(buttonRepost)]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewSeperate]|" options:0 metrics:metricDict views:viewDict]];
    
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalNameBuffer-[_lblName]" options:0 metrics:metricDict views:viewDict]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_imgPost(imgPostHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnPost(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_imgPost(imgPostHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnEdit(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_imgAvatar(avatarSize)]-verticalPostBuffer-[_lblPost]-verticalPostBuffer-[_btnPhoto(imgPostHeight)]-verticalLineBuffer-[_viewLine(lineHeight)]-[_btnPost(replyHeight)]-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.imgAvatar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgAvatar setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblName setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblName setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblPost setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lblPost setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.imgPost setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgPost setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnPhoto setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnPhoto setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewLine setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewLine setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnPost setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnPost setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnEdit setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnEdit setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    self.lblPost.preferredMaxLayoutWidth = defaultSize.width - ([metricDict[@"sidePostBuffer"] floatValue] * 2);
    
    self.imgPost.layer.cornerRadius = BUTTON_RADIUS;
    self.imgAvatar.layer.cornerRadius = BUTTON_RADIUS;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.contentView];
}

- (void)setupCellWithFeedData:(FeedData *)feedData {
    
    NSURL *imageAvatarURL = [NSURL URLWithString:feedData.profileUrl];
    [self.imgAvatar setShowActivityIndicatorView:YES];
    [self.imgAvatar setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.imgAvatar sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    self.lblName.text = [NSString stringWithFormat:@"%@ @%@ - %@", feedData.userName, feedData.userID, [[GlobalData sharedGlobalData] getFormattedTwitterTimeStamp:feedData.time]];
    NSRange range1 = [self.lblName.text rangeOfString:feedData.userName];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.lblName.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y], NSForegroundColorAttributeName:[UIColor blackColor]} range:range1];
    self.lblName.attributedText = attributedText;
    
    NSString *empty = @" \n \n";
    self.lblPost.text = [NSString stringWithFormat:@"%@ %@", feedData.content, empty];
    
    NSString *strUrl = feedData.filePath;
    NSURL *imageURL = [NSURL URLWithString:strUrl];
    [self.imgPost setShowActivityIndicatorView:YES];
    [self.imgPost setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.imgPost sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];

    self.btnPost.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
    self.btnEdit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    [GlobalData sharedGlobalData].g_strPostLink = url.absoluteString;
    [[GlobalData sharedGlobalData].g_ctrlTwitter goToPostLink];
}


@end

