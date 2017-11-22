//
//  BFTwitterUserTimelineViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFTwitterUserTimelineViewController.h"
#import "BFFeedTableViewCell.h"
#import "BFFeedPhotoTableViewCell.h"

static NSString *BFFeedTableViewCellIdentifier = @"BFFeedTableViewCellIdentifier";
static NSString *BFFeedPhotoTableViewCellIdentifier = @"BFFeedPhotoTableViewCellIdentifier";

@interface BFTwitterUserTimelineViewController () <UITableViewDragLoadDelegate, UIGestureRecognizerDelegate>
{
    NSString* _maxID;
    int _loadCount;
    BOOL tempIsOn;
}

@property (nonatomic, strong) NSMutableArray *statusesArray;

@end

@implementation BFTwitterUserTimelineViewController

@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    tempIsOn = false;
    _maxID = nil;
    _loadCount = 10;
    
    [m_tableView registerClass:[BFFeedTableViewCell class] forCellReuseIdentifier:BFFeedTableViewCellIdentifier];
    [m_tableView registerClass:[BFFeedPhotoTableViewCell class] forCellReuseIdentifier:BFFeedPhotoTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    SVPROGRESSHUD_SHOW;
    [self initLoadHomeFeedData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GlobalData sharedGlobalData].g_toggleTwitterIsOn = true;
    
    if ([GlobalData sharedGlobalData].g_togglePhotoIsOn) {
        [GlobalData sharedGlobalData].g_togglePhotoIsOn = false;
    } else if (tempIsOn && ![GlobalData sharedGlobalData].g_togglePhotoIsOn) {
//        [self finishRefresh];
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

- (void)initLoadHomeFeedData {
    
    self.statusesArray = [[NSMutableArray alloc] init];
    
    [[GlobalData sharedGlobalData].twitter getStatusesUserTimelineForUserID:[GlobalData sharedGlobalData].g_twitterUserID screenName:nil sinceID:nil count:[NSString stringWithFormat:@"%i", _loadCount] maxID:nil trimUser:nil excludeReplies:nil contributorDetails:nil includeRetweets:nil successBlock:^(NSArray *statuses) {
        
        NSLog(@"-- statuses: %@", statuses);
        
        SVPROGRESSHUD_DISMISS;
        
        if (statuses.count > 0) {
            
            for (int i = 0; i < statuses.count; i++) {
                
                NSDictionary *status = [statuses objectAtIndex:i];
                
                if (i == statuses.count - 1) {
                    _maxID = [status valueForKeyPath:@"id_str"];
                }
                
                [self.statusesArray addObject:[[GlobalData sharedGlobalData] onParseFeedData:status]];
            }
        }
        
        [m_tableView reloadData];
        
        tempIsOn = true;
        
    } errorBlock:^(NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        [m_tableView reloadData];
        
        tempIsOn = true;
    }];
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
    [[GlobalData sharedGlobalData].twitter getStatusesUserTimelineForUserID:[GlobalData sharedGlobalData].g_twitterUserID screenName:nil sinceID:nil count:[NSString stringWithFormat:@"%i", _loadCount] maxID:nil trimUser:nil excludeReplies:nil contributorDetails:nil includeRetweets:nil successBlock:^(NSArray *statuses) {
        
        NSLog(@"-- statuses: %@", statuses);
        
        if (statuses.count > 0) {
            self.statusesArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < statuses.count; i++) {
                
                NSDictionary *status = [statuses objectAtIndex:i];
                
                if (i == statuses.count - 1) {
                    _maxID = [status valueForKeyPath:@"id_str"];
                }
                
                [self.statusesArray addObject:[[GlobalData sharedGlobalData] onParseFeedData:status]];
            }
        }
        
        [m_tableView finishRefresh];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
        
    } errorBlock:^(NSError *error) {
        
        [m_tableView finishRefresh];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
    }];
}

- (void)finishLoadMore {
    
    [[GlobalData sharedGlobalData].twitter getStatusesUserTimelineForUserID:[GlobalData sharedGlobalData].g_twitterUserID screenName:nil sinceID:nil count:[NSString stringWithFormat:@"%i", _loadCount] maxID:_maxID trimUser:nil excludeReplies:nil contributorDetails:nil includeRetweets:nil successBlock:^(NSArray *statuses) {
        
        NSLog(@"-- statuses: %@", statuses);
        
        if (statuses.count > 0) {
            
            for (int i = 1; i < statuses.count; i++) {
                
                NSDictionary *status = [statuses objectAtIndex:i];
                
                if (i == statuses.count - 1) {
                    _maxID = [status valueForKeyPath:@"id_str"];
                }
                
                [self.statusesArray addObject:[[GlobalData sharedGlobalData] onParseFeedData:status]];
            }
        }
        
        [m_tableView finishLoadMore];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
        
    } errorBlock:^(NSError *error) {
        
        [m_tableView finishLoadMore];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
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
    return self.statusesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedData *feedData = self.statusesArray[indexPath.row];
    
    if ([feedData.type isEqualToString:POST_TYPE_PHOTO]) {
        
        BFFeedPhotoTableViewCell *cell = (BFFeedPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFFeedPhotoTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithFeedData:feedData];
        
        [cell.btnPhoto addTarget:self action:@selector(onDetailTwitterUserPhotoView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPost addTarget:self action:@selector(onTwitterUserFeedPost:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(onTwitterUserFeedEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else {
        
        BFFeedTableViewCell *cell = (BFFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFFeedTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithFeedData:feedData];
        
        [cell.btnPost addTarget:self action:@selector(onTwitterUserFeedPost:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(onTwitterUserFeedEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    FeedData *feedData = self.statusesArray[indexPath.row];
    
    if ([feedData.type isEqualToString:POST_TYPE_PHOTO]) {
        
        CGSize cellSize = [BFFeedPhotoTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            
            [((BFFeedPhotoTableViewCell *)cellToSetup) setupCellWithFeedData:feedData];
            
            // return cell
            return cellToSetup;
        }];
        
        return cellSize.height;
        
    } else {
        
        CGSize cellSize = [BFFeedTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            
            [((BFFeedTableViewCell *)cellToSetup) setupCellWithFeedData:feedData];
            
            // return cell
            return cellToSetup;
        }];
        
        return cellSize.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)onDetailTwitterUserPhotoView:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    FeedData *feedData = self.statusesArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_photoUrl = feedData.filePath;
    
    [[GlobalData sharedGlobalData].g_ctrlTwitter goToPhotoView];
}

-(void)onTwitterUserFeedPost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    FeedData *feedData = self.statusesArray[indexPath.row];
    
    NSData *data = [feedData.content dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *postValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    SVPROGRESSHUD_SHOW;
    
    Post *post = [Post new];
    post.content = postValue;
    post.type = feedData.type;
    post.filePath = feedData.filePath;
    post.userId = [GlobalData sharedGlobalData].g_userData.userId;
    post.postUser = [GlobalData sharedGlobalData].g_currentUser;
    post.time = [[GlobalData sharedGlobalData] getCurrentDate];
    post.commentCount = 0;
    post.likeCount = 0;
    post.reportCount = 0;
    post.commentType = @"";
    post.likeType = @"";
    post.reportType = @"";
    
    [backendless.persistenceService save:post response:^(id response) {
        NSLog(@"saved new post data");
        
        [BFUtility onSendBroadcastNotification];
        
        SVPROGRESSHUD_DISMISS;
        
        [[GlobalData sharedGlobalData].g_ctrlTwitter performSegueWithIdentifier:UNWIND_TWITTER_POST sender:nil];
        
    } error:^(Fault *fault) {
        NSLog(@"Failed save in background of post data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Posting is failed. Please try again."];
    }];
}

-(void)onTwitterUserFeedEdit:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_feedData = [[FeedData alloc] init];
    [GlobalData sharedGlobalData].g_feedData = self.statusesArray[indexPath.row];
    
    [[GlobalData sharedGlobalData].g_ctrlTwitter performSegueWithIdentifier:UNWIND_TWITTER_EDIT sender:nil];
}

@end
