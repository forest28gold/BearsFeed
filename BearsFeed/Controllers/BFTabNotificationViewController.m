//
//  BFTabNotificationViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFTabNotificationViewController.h"

@interface BFTabNotificationViewController () <UITableViewDragLoadDelegate>
{
    int _dataCount;
    BOOL tempIsOn;
}

@property (nonatomic, strong) NSMutableArray *notificationDataArray;

@end

@implementation BFTabNotificationViewController

@synthesize m_tableView, m_viewEmpty, m_btnPost;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempIsOn = false;
    _dataCount = 0;
    
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    m_viewEmpty.hidden = YES;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_btnPost.layer.cornerRadius = 3.0f;
    
    SVPROGRESSHUD_SHOW;
    [self initLoadNotificationData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (tempIsOn) {
        [self finishRefresh];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onShowEmpty {
    
    [m_tableView reloadData];
    
    if (self.notificationDataArray.count > 0) {
        m_viewEmpty.hidden = YES;
    } else {
        m_viewEmpty.hidden = NO;
    }
}

- (IBAction)onSearch:(id)sender {
    [[GlobalData sharedGlobalData].g_tabBar goToSearch];
}

- (IBAction)onPostMoment:(id)sender {
    [[GlobalData sharedGlobalData].g_tabBar goToNewPost];
}

- (void)onSetEmptyView {
    
    m_viewEmpty.hidden = NO;
}

- (void)initLoadNotificationData {
    
    self.notificationDataArray = [[NSMutableArray alloc] init];
    
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"fromUser"];
    [queryOption addRelated:@"toUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userData.userId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Notification class]] find:query response:^(BackendlessCollection *notifications) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (notifications.data.count > 0) {
            
            for (Notification *notification in notifications.data) {
                
                [self.notificationDataArray addObject:notification];
            }
            
            [self onShowEmpty];
            
        } else {
            [self onShowEmpty];
        }
        
        tempIsOn = true;
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [self onShowEmpty];
        
        tempIsOn = true;
    }];
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
    if (_dataCount == 0) {
        _dataCount = LOAD_DATA_COUNT;
    }
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"fromUser"];
    [queryOption addRelated:@"toUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userData.userId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Notification class]] find:query response:^(BackendlessCollection *notifications) {

        if (notifications.data.count > 0) {
            
            self.notificationDataArray = [[NSMutableArray alloc] init];

            for (Notification *notification in notifications.data) {
                
                [self.notificationDataArray addObject:notification];
            }
            
            [m_tableView finishRefresh];
            m_tableView.showLoadMoreView = true;
            [self onShowEmpty];
            
        } else {
            [m_tableView finishRefresh];
            m_tableView.showLoadMoreView = true;
            [self onShowEmpty];
        }
        
    } error:^(Fault *fault) {
        
        [m_tableView finishRefresh];
        m_tableView.showLoadMoreView = true;
        [self onShowEmpty];
    }];
}

- (void)finishLoadMore {
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"fromUser"];
    [queryOption addRelated:@"toUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userData.userId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Notification class]] find:query response:^(BackendlessCollection *notifications) {
        
        if (notifications.data.count > 0) {
            
            for (Notification *notification in notifications.data) {
                
                [self.notificationDataArray addObject:notification];
            }
            
            [m_tableView finishLoadMore];
            m_tableView.showLoadMoreView = true;
            [self onShowEmpty];
            
        } else {
            
            [m_tableView finishLoadMore];
            m_tableView.showLoadMoreView = true;
            [self onShowEmpty];
        }
        _dataCount += LOAD_DATA_COUNT;
        
    } error:^(Fault *fault) {
        
        [m_tableView finishLoadMore];
        m_tableView.showLoadMoreView = true;
        [self onShowEmpty];
    }];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:1];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:1];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.notificationDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 76 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    
    UIImageView *imgAvatar = (UIImageView*)[_cell viewWithTag:1];
    UILabel *lblName = (UILabel*)[_cell viewWithTag:2];
    UILabel *lblState = (UILabel*)[_cell viewWithTag:3];
    UIImageView *imgNotification = (UIImageView*)[_cell viewWithTag:4];
    UILabel *lblTime = (UILabel*)[_cell viewWithTag:5];
    
    Notification *record = self.notificationDataArray[indexPath.row];
    BackendlessUser *user = record.fromUser;
    
    NSURL *imageAvatarURL = [NSURL URLWithString:[user getProperty:KEY_PHOTO_URL]];
    [imgAvatar setShowActivityIndicatorView:YES];
    [imgAvatar setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [imgAvatar sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    lblName.text = user.name;
    lblState.text = [self getNotificationState:record.type];
    imgNotification.image = [UIImage imageNamed:[self getNotificationIcon:record.type]];
    lblTime.text = [[GlobalData sharedGlobalData] getFormattedTimeStamp:record.time];
    
    imgAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailNotificationProfile:)];
    tapAvatar.cancelsTouchesInView = NO;
    [imgAvatar addGestureRecognizer:tapAvatar];

    
    UIView* m_view = (UIView*)[_cell viewWithTag:20];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2;
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    
    Notification *record = self.notificationDataArray[indexPath.row];
    
    SVPROGRESSHUD_SHOW;
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.postId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
         
            PostData *post = posts.data[0];

            [GlobalData sharedGlobalData].g_postData.objectId = post.objectId;
            [GlobalData sharedGlobalData].g_postData.content = post.content;
            [GlobalData sharedGlobalData].g_postData.type = post.type;
            [GlobalData sharedGlobalData].g_postData.filePath = post.filePath;
            [GlobalData sharedGlobalData].g_postData.userId = post.userId;
            [GlobalData sharedGlobalData].g_postData.postUser = post.postUser;
            [GlobalData sharedGlobalData].g_postData.time = post.time;
            [GlobalData sharedGlobalData].g_postData.commentCount = post.commentCount;
            [GlobalData sharedGlobalData].g_postData.likeCount = post.likeCount;
            [GlobalData sharedGlobalData].g_postData.commentType = post.commentType;
            [GlobalData sharedGlobalData].g_postData.likeType = post.likeType;
            [GlobalData sharedGlobalData].g_postData.reportCount = post.reportCount;
            [GlobalData sharedGlobalData].g_postData.reportType = post.reportType;
            [GlobalData sharedGlobalData].g_postData.toggleReadMore = false;
            
            [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
            [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
            [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
            
            if ([GlobalData sharedGlobalData].g_postData.commentType != nil && ![[GlobalData sharedGlobalData].g_postData.commentType isEqualToString:@""]) {
                
                if ([[GlobalData sharedGlobalData].g_postData.commentType containsString:@";"]) {
                    NSArray *itemsComment = [post.commentType componentsSeparatedByString:@";"];
                    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [itemsComment mutableCopy];
                } else {
                    [[GlobalData sharedGlobalData].g_postData.commentTypeArray addObject:[GlobalData sharedGlobalData].g_postData.commentType];
                }
            }
            
            if ([GlobalData sharedGlobalData].g_postData.likeType != nil && ![[GlobalData sharedGlobalData].g_postData.likeType isEqualToString:@""]) {
                
                if ([[GlobalData sharedGlobalData].g_postData.likeType containsString:@";"]) {
                    NSArray *itemsLike = [post.likeType componentsSeparatedByString:@";"];
                    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [itemsLike mutableCopy];
                } else {
                    [[GlobalData sharedGlobalData].g_postData.likeTypeArray addObject:[GlobalData sharedGlobalData].g_postData.likeType];
                }
            }
            
            if ([GlobalData sharedGlobalData].g_postData.reportType != nil && ![[GlobalData sharedGlobalData].g_postData.reportType isEqualToString:@""]) {
                
                if ([[GlobalData sharedGlobalData].g_postData.reportType containsString:@";"]) {
                    NSArray *itemsLike = [post.reportType componentsSeparatedByString:@";"];
                    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [itemsLike mutableCopy];
                } else {
                    [[GlobalData sharedGlobalData].g_postData.reportTypeArray addObject:[GlobalData sharedGlobalData].g_postData.reportType];
                }
            }
            
            [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
            
            [[GlobalData sharedGlobalData].g_tabBar goToPostDetails];
        }
        
    } error:^(Fault *fault) {
        SVPROGRESSHUD_DISMISS;
    }];
}

-(void)onDetailNotificationProfile:(UITapGestureRecognizer*)sender {
    
    UIImageView *btn = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    Notification *record = self.notificationDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_postUser = record.fromUser;
    
    [[GlobalData sharedGlobalData].g_tabBar goToUserProfile];
}

- (NSString*)getNotificationState:(NSString*)type {
    
    NSString *strState = ALERT_UPVOTE;
    
    if ([type isEqualToString:NOTI_UPVOTE]) {
        strState = ALERT_UPVOTE;
    } else if ([type isEqualToString:NOTI_DOWNVOTE]) {
        strState = ALERT_DOWNVOTE;
    } else if ([type isEqualToString:NOTI_COMMENT]) {
        strState = ALERT_COMMENT;
    } else if ([type isEqualToString:NOTI_COMMENT_UPVOTE]) {
        strState = ALERT_COMMENT_UPVOTE;
    } else if ([type isEqualToString:NOTI_COMMENT_DOWNVOTE]) {
        strState = ALERT_COMMENT_DOWNVOTE;
    } else if ([type isEqualToString:NOTI_REPORT]) {
        strState = ALERT_REPORT;
    }
    
    return strState;
}

- (NSString*)getNotificationIcon:(NSString*)type {
    
    NSString *strIcon = @"noti_upvote";
    
    if ([type isEqualToString:NOTI_UPVOTE]) {
        strIcon = @"noti_upvote";
    } else if ([type isEqualToString:NOTI_DOWNVOTE]) {
        strIcon = @"noti_downvote";
    } else if ([type isEqualToString:NOTI_COMMENT]) {
        strIcon = @"noti_comment";
    } else if ([type isEqualToString:NOTI_COMMENT_UPVOTE]) {
        strIcon = @"noti_upvote";
    } else if ([type isEqualToString:NOTI_COMMENT_DOWNVOTE]) {
        strIcon = @"noti_downvote";
    } else if ([type isEqualToString:NOTI_REPORT]) {
        strIcon = @"noti_report";
    }
    
    return strIcon;
}

@end
