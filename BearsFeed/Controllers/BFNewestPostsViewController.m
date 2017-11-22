//
//  BFNewestPostsViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 4/20/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFNewestPostsViewController.h"
#import "BFPostTableViewCell.h"
#import "BFPostPhotoTableViewCell.h"
#import "BFFeedNewTableViewCell.h"
#import "BFFeedNewPhotoTableViewCell.h"

static NSString *BFPostTableViewCellIdentifier = @"BFPostTableViewCellIdentifier";
static NSString *BFPostPhotoTableViewCellIdentifier = @"BFPostPhotoTableViewCellIdentifier";
static NSString *BFFeedNewTableViewCellIdentifier = @"BFFeedNewTableViewCellIdentifier";
static NSString *BFFeedNewPhotoTableViewCellIdentifier = @"BFFeedNewPhotoTableViewCellIdentifier";

@interface BFNewestPostsViewController () <UITableViewDragLoadDelegate, UIGestureRecognizerDelegate, UIDocumentInteractionControllerDelegate>
{
    int _dataCount;
    BOOL tempIsOn;
    
    NSString* _maxID;
    int _loadCount;
    
    BOOL toggleBearsRefreshIsOn;
    NSMutableArray *arrayLoadMore;
}

@end

@implementation BFNewestPostsViewController

@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempIsOn = false;
    _dataCount = 0;
    toggleBearsRefreshIsOn = false;
    
    _maxID = nil;
    _loadCount = 15;
    
    arrayLoadMore = [[NSMutableArray alloc] init];
    
    [m_tableView registerClass:[BFPostTableViewCell class] forCellReuseIdentifier:BFPostTableViewCellIdentifier];
    [m_tableView registerClass:[BFPostPhotoTableViewCell class] forCellReuseIdentifier:BFPostPhotoTableViewCellIdentifier];
    [m_tableView registerClass:[BFFeedNewTableViewCell class] forCellReuseIdentifier:BFFeedNewTableViewCellIdentifier];
    [m_tableView registerClass:[BFFeedNewPhotoTableViewCell class] forCellReuseIdentifier:BFFeedNewPhotoTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
//    [GlobalData sharedGlobalData].g_timer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(onAutoUpdateNewest) userInfo:nil repeats:YES];
    
    SVPROGRESSHUD_SHOW;
    [self initLoadNewestPostData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GlobalData sharedGlobalData].g_strSelectedTab = SELECT_NEWEST;
    
    if ([GlobalData sharedGlobalData].g_togglePhotoIsOn) {
        [GlobalData sharedGlobalData].g_togglePhotoIsOn = false;
    } else if (tempIsOn && ![GlobalData sharedGlobalData].g_togglePhotoIsOn) {
        [self finishRefresh];
    }
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [GlobalData sharedGlobalData].g_toggleRefreshIsOn = false;
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

- (void)onAutoUpdateNewest {

    if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_NEWEST] && [GlobalData sharedGlobalData].g_toggleRefreshIsOn) {
    
        NSLog(@"=======******** reload ********======");
        [self finishRefresh];
    }
}

- (void)onTwitterFetch {
    
    [GlobalData sharedGlobalData].twitter_bears = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET oauthToken:TWITTER_ACCESS_TOKEN oauthTokenSecret:TWITTER_ACCESS_TOKEN_SECRET];
    
    [[GlobalData sharedGlobalData].twitter_bears verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [self initLoadTwitterFeedData];
        
    } errorBlock:^(NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        [m_tableView reloadData];
    }];
}

- (void)initLoadTwitterFeedData {
    
    [[GlobalData sharedGlobalData].twitter_bears getHomeTimelineSinceID:nil count:_loadCount successBlock:^(NSArray *statuses) {
        NSLog(@"-- statuses: %@", statuses);
        
        SVPROGRESSHUD_DISMISS;
        
        if (statuses.count > 0) {
            
            for (int i = 0; i < statuses.count; i++) {
                
                NSDictionary *status = [statuses objectAtIndex:i];
                
                if (i == statuses.count - 1) {
                    _maxID = [status valueForKeyPath:@"id_str"];
                }
                
                [[GlobalData sharedGlobalData].g_arrayNewestPost addObject:[[GlobalData sharedGlobalData] onParseTwitterData:status]];
            }
        }
        
        [[GlobalData sharedGlobalData].g_arrayNewestPost sortUsingComparator:^NSComparisonResult(PostData *postData1, PostData *postData2) {
            return [postData2.time compare:postData1.time options:(NSNumericSearch)];
        }];
        
        [m_tableView reloadData];
        
        tempIsOn = true;
        [GlobalData sharedGlobalData].g_toggleRefreshIsOn = true;
        
    } errorBlock:^(NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        [m_tableView reloadData];
        
        tempIsOn = true;
        [GlobalData sharedGlobalData].g_toggleRefreshIsOn = true;

    }];
}

- (void)finishTwitterFeedRefresh {
    
    [[GlobalData sharedGlobalData].twitter_bears getHomeTimelineSinceID:nil count:_dataCount successBlock:^(NSArray *statuses) {
        NSLog(@"-- statuses: %@", statuses);
        
        if (statuses.count > 0) {
            
            if (!toggleBearsRefreshIsOn) {
                [GlobalData sharedGlobalData].g_arrayNewestPost = [[NSMutableArray alloc] init];
            }
            
            for (int i = 0; i < statuses.count; i++) {
                
                NSDictionary *status = [statuses objectAtIndex:i];
                
                if (i == statuses.count - 1) {
                    _maxID = [status valueForKeyPath:@"id_str"];
                }
                
                [[GlobalData sharedGlobalData].g_arrayNewestPost addObject:[[GlobalData sharedGlobalData] onParseTwitterData:status]];
            }
        }
        
        [[GlobalData sharedGlobalData].g_arrayNewestPost sortUsingComparator:^NSComparisonResult(PostData *postData1, PostData *postData2) {
            return [postData2.time compare:postData1.time options:(NSNumericSearch)];
        }];
        
        [m_tableView finishRefresh];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
        
    } errorBlock:^(NSError *error) {
        
        [m_tableView finishRefresh];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
    }];
}

- (void)finishTwitterFeedLoadMore {
    
    [[GlobalData sharedGlobalData].twitter_bears getStatusesHomeTimelineWithCount:[NSString stringWithFormat:@"%i", _loadCount] sinceID:nil maxID:_maxID trimUser:nil excludeReplies:nil contributorDetails:nil includeEntities:nil successBlock:^(NSArray *statuses) {
        
        NSLog(@"-- statuses: %@", statuses);
        
        if (statuses.count > 0) {
            
            for (int i = 1; i < statuses.count; i++) {
                
                NSDictionary *status = [statuses objectAtIndex:i];
                
                if (i == statuses.count - 1) {
                    _maxID = [status valueForKeyPath:@"id_str"];
                }
                
                [arrayLoadMore addObject:[[GlobalData sharedGlobalData] onParseTwitterData:status]];
            }
        }
        
        [arrayLoadMore sortUsingComparator:^NSComparisonResult(PostData *postData1, PostData *postData2) {
            return [postData2.time compare:postData1.time options:(NSNumericSearch)];
        }];
        
        [[GlobalData sharedGlobalData].g_arrayNewestPost addObjectsFromArray:arrayLoadMore];
        
        [m_tableView finishLoadMore];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
        
    } errorBlock:^(NSError *error) {
        
        [m_tableView finishLoadMore];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
    }];
}

- (void)initLoadNewestPostData {
    
    [GlobalData sharedGlobalData].g_arrayNewestPost = [[NSMutableArray alloc] init];
    
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParsePostData:post];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [[GlobalData sharedGlobalData].g_arrayNewestPost addObject:record];
                }
                
            }
            
        }

        [self onTwitterFetch];
        
    } error:^(Fault *fault) {
        
        [self onTwitterFetch];
    }];
    
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
    if (_dataCount == 0) {
        _dataCount = LOAD_DATA_COUNT;
    }
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            toggleBearsRefreshIsOn = true;
            
            [GlobalData sharedGlobalData].g_arrayNewestPost = [[NSMutableArray alloc] init];
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParsePostData:post];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [[GlobalData sharedGlobalData].g_arrayNewestPost addObject:record];
                }
            }
            
        } else {
            toggleBearsRefreshIsOn = false;
        }
        
        [self finishTwitterFeedRefresh];
        
    } error:^(Fault *fault) {
        
        toggleBearsRefreshIsOn = false;
        [self finishTwitterFeedRefresh];
    }];
}

- (void)finishLoadMore {
    
    arrayLoadMore = [[NSMutableArray alloc] init];
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParsePostData:post];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [arrayLoadMore addObject:record];
                }
                
            }
            
        }
        
        _dataCount += LOAD_DATA_COUNT;
        
        [self finishTwitterFeedLoadMore];
        
    } error:^(Fault *fault) {
        
        [self finishTwitterFeedLoadMore];
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
    return [GlobalData sharedGlobalData].g_arrayNewestPost.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    if (postData.toggleTwitterBearsFeedIsOn) {
        
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            BFFeedNewPhotoTableViewCell *cell = (BFFeedNewPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFFeedNewPhotoTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithFeedData:postData];
            
            [cell.btnPhoto addTarget:self action:@selector(onNewestDetailPhotoView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onNewestSharePostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onNewestSharePostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onNewestSharePostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        } else {
            
            BFFeedNewTableViewCell *cell = (BFFeedNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFFeedNewTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithFeedData:postData];
            
            [cell.btnShareFB addTarget:self action:@selector(onNewestSharePostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onNewestSharePostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onNewestSharePostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
    } else {
     
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            BFPostPhotoTableViewCell *cell = (BFPostPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostPhotoTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithPhotoData:postData];
            
            [cell.btnUpVote addTarget:self action:@selector(onNewestUpVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownVote addTarget:self action:@selector(onNewestDownVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReadMore addTarget:self action:@selector(onNewestReadMore:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnComment addTarget:self action:@selector(onNewestComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReply addTarget:self action:@selector(onNewestReply:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnPhoto addTarget:self action:@selector(onNewestDetailPhotoView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onNewestSharePostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onNewestSharePostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onNewestSharePostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.imgAvatar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNewestDetailUserProfile:)];
            tapAvatar.cancelsTouchesInView = NO;
            [cell.imgAvatar addGestureRecognizer:tapAvatar];
            
            return cell;
            
        } else {
            
            BFPostTableViewCell *cell = (BFPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithPostData:postData];
            
            [cell.btnUpVote addTarget:self action:@selector(onNewestUpVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownVote addTarget:self action:@selector(onNewestDownVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReadMore addTarget:self action:@selector(onNewestReadMore:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnComment addTarget:self action:@selector(onNewestComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReply addTarget:self action:@selector(onNewestReply:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onNewestSharePostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onNewestSharePostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onNewestSharePostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.imgAvatar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNewestDetailUserProfile:)];
            tapAvatar.cancelsTouchesInView = NO;
            [cell.imgAvatar addGestureRecognizer:tapAvatar];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    if (postData.toggleTwitterBearsFeedIsOn) {
        
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            CGSize cellSize = [BFFeedNewPhotoTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
                
                [((BFFeedNewPhotoTableViewCell *)cellToSetup) setupCellWithFeedData:postData];
                
                // return cell
                return cellToSetup;
            }];
            
            return cellSize.height;
            
        } else {
            
            CGSize cellSize = [BFFeedNewTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
                
                [((BFFeedNewTableViewCell *)cellToSetup) setupCellWithFeedData:postData];
                
                // return cell
                return cellToSetup;
            }];
            
            return cellSize.height;
        }
        
    } else {
     
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            CGSize cellSize = [BFPostPhotoTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
                
                [((BFPostPhotoTableViewCell *)cellToSetup) setupCellWithPhotoData:postData];
                
                // return cell
                return cellToSetup;
            }];
            
            return cellSize.height;
            
        } else {
            
            CGSize cellSize = [BFPostTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
                
                [((BFPostTableViewCell *)cellToSetup) setupCellWithPostData:postData];
                
                // return cell
                return cellToSetup;
            }];
            
            return cellSize.height;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    if (!postData.toggleTwitterBearsFeedIsOn) {
        
        [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
        [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_postData = postData;
        
        [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
        
        [[GlobalData sharedGlobalData].g_tabBar goToPostDetails];
    }
}

-(void)onNewestUpVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility likePostInBackground:indexPath dataArray:[GlobalData sharedGlobalData].g_arrayNewestPost];
    
    [m_tableView reloadData];
}

-(void)onNewestDownVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility dislikePostInBackground:sender indexPath:indexPath dataArray:[GlobalData sharedGlobalData].g_arrayNewestPost];
    
    [m_tableView reloadData];
}

-(void)onNewestReadMore:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    if (!postData.toggleReadMore) {
        postData.toggleReadMore = true;
    } else {
        postData.toggleReadMore = false;
    }
    
    [[GlobalData sharedGlobalData].g_arrayNewestPost replaceObjectAtIndex:indexPath.row withObject:postData];
    [m_tableView reloadData];
}

-(void)onNewestDetailPhotoView:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_photoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoView];
}

-(void)onNewestDetailUserProfile:(UITapGestureRecognizer*)sender {
    
    UIImageView *btn = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_postUser = postData.postUser;
    
    [[GlobalData sharedGlobalData].g_tabBar goToUserProfile];
}

-(void)onNewestComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = false;
    
    [[GlobalData sharedGlobalData].g_tabBar goToCommentPost];
}

-(void)onNewestReply:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = true;
    
    [[GlobalData sharedGlobalData].g_tabBar goToReplyPost];
}

-(void)onNewestSharePostToFacebook:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [BFUtility shareToSicial:0 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onNewestSharePostToTwitter:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [BFUtility shareToSicial:1 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onNewestSharePostToInstagram:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = [GlobalData sharedGlobalData].g_arrayNewestPost[indexPath.row];
    
    [BFUtility shareToSicial:2 viewCtrl:self text:record.content imageUrl:record.filePath];
}

@end
