//
//  BFMostCommentedViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 4/20/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFMostCommentedViewController.h"
#import "BFPostTableViewCell.h"
#import "BFPostPhotoTableViewCell.h"

static NSString *BFPostTableViewCellIdentifier = @"BFPostTableViewCellIdentifier";
static NSString *BFPostPhotoTableViewCellIdentifier = @"BFPostPhotoTableViewCellIdentifier";

@interface BFMostCommentedViewController () <UITableViewDragLoadDelegate, UIGestureRecognizerDelegate, UIDocumentInteractionControllerDelegate>
{
    int _dataCount;
    BOOL tempIsOn;
}

@end

@implementation BFMostCommentedViewController

@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempIsOn = false;
    _dataCount = 0;
    
    [m_tableView registerClass:[BFPostTableViewCell class] forCellReuseIdentifier:BFPostTableViewCellIdentifier];
    [m_tableView registerClass:[BFPostPhotoTableViewCell class] forCellReuseIdentifier:BFPostPhotoTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    SVPROGRESSHUD_SHOW;
    [self initLoadMostCommentedData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GlobalData sharedGlobalData].g_strSelectedTab = SELECT_MOST_COMMENTED;
    
    if ([GlobalData sharedGlobalData].g_togglePhotoIsOn) {
        [GlobalData sharedGlobalData].g_togglePhotoIsOn = false;
    } else if (tempIsOn && ![GlobalData sharedGlobalData].g_togglePhotoIsOn) {
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

- (void)initLoadMostCommentedData {
    
    [GlobalData sharedGlobalData].g_arrayMostCommentedPost = [[NSMutableArray alloc] init];
    
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"commentCount DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParsePostData:post];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [[GlobalData sharedGlobalData].g_arrayMostCommentedPost addObject:record];
                }
                
            }
            
            [m_tableView reloadData];
            
        } else {
            [m_tableView reloadData];
        }
        
        tempIsOn = true;
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [m_tableView reloadData];
        
        tempIsOn = true;
    }];
    
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
    if (_dataCount == 0) {
        _dataCount = LOAD_DATA_COUNT;
    }
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"commentCount DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            [GlobalData sharedGlobalData].g_arrayMostCommentedPost = [[NSMutableArray alloc] init];
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParsePostData:post];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [[GlobalData sharedGlobalData].g_arrayMostCommentedPost addObject:record];
                }
                
            }
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
        }
        
    } error:^(Fault *fault) {
        
        [m_tableView finishRefresh];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
        
    }];
    
}

- (void)finishLoadMore {
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"commentCount DESC"];
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
                    [[GlobalData sharedGlobalData].g_arrayMostCommentedPost addObject:record];
                }
                
            }
            
            [m_tableView finishLoadMore];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
            [m_tableView finishLoadMore];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
        }
        _dataCount += LOAD_DATA_COUNT;
        
    } error:^(Fault *fault) {
        
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
    return [GlobalData sharedGlobalData].g_arrayMostCommentedPost.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
        
        BFPostPhotoTableViewCell *cell = (BFPostPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostPhotoTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithPhotoData:postData];
        
        [cell.btnUpVote addTarget:self action:@selector(onMostCommentedUpVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDownVote addTarget:self action:@selector(onMostCommentedDownVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReadMore addTarget:self action:@selector(onMostCommentedReadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComment addTarget:self action:@selector(onMostCommentedComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReply addTarget:self action:@selector(onMostCommentedReply:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPhoto addTarget:self action:@selector(onMostCommentedDetailPhotoView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareFB addTarget:self action:@selector(onShareMostCommentedPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareTW addTarget:self action:@selector(onShareMostCommentedPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareINS addTarget:self action:@selector(onShareMostCommentedPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgAvatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMostCommentedDetailUserProfile:)];
        tapAvatar.cancelsTouchesInView = NO;
        [cell.imgAvatar addGestureRecognizer:tapAvatar];
        
        return cell;
        
    } else {
        
        BFPostTableViewCell *cell = (BFPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithPostData:postData];
        
        [cell.btnUpVote addTarget:self action:@selector(onMostCommentedUpVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDownVote addTarget:self action:@selector(onMostCommentedDownVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReadMore addTarget:self action:@selector(onMostCommentedReadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComment addTarget:self action:@selector(onMostCommentedComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReply addTarget:self action:@selector(onMostCommentedReply:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareFB addTarget:self action:@selector(onShareMostCommentedPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareTW addTarget:self action:@selector(onShareMostCommentedPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareINS addTarget:self action:@selector(onShareMostCommentedPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgAvatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMostCommentedDetailUserProfile:)];
        tapAvatar.cancelsTouchesInView = NO;
        [cell.imgAvatar addGestureRecognizer:tapAvatar];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPostDetails];
}

-(void)onMostCommentedUpVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility likePostInBackground:indexPath dataArray:[GlobalData sharedGlobalData].g_arrayMostCommentedPost];
    
    [m_tableView reloadData];
}

-(void)onMostCommentedDownVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility dislikePostInBackground:sender indexPath:indexPath dataArray:[GlobalData sharedGlobalData].g_arrayMostCommentedPost];
    
    [m_tableView reloadData];
}

-(void)onMostCommentedReadMore:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    if (!postData.toggleReadMore) {
        postData.toggleReadMore = true;
    } else {
        postData.toggleReadMore = false;
    }
    
    [[GlobalData sharedGlobalData].g_arrayMostCommentedPost replaceObjectAtIndex:indexPath.row withObject:postData];
    [m_tableView reloadData];
}

-(void)onMostCommentedDetailPhotoView:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_photoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoView];
}

-(void)onMostCommentedDetailUserProfile:(UITapGestureRecognizer*)sender {
    
    UIImageView *btn = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_postUser = postData.postUser;
    
    [[GlobalData sharedGlobalData].g_tabBar goToUserProfile];
}

-(void)onMostCommentedComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = false;
    
    [[GlobalData sharedGlobalData].g_tabBar goToCommentPost];
}

-(void)onMostCommentedReply:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = true;
    
    [[GlobalData sharedGlobalData].g_tabBar goToReplyPost];
}

-(void)onShareMostCommentedPostToFacebook:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [BFUtility shareToSicial:0 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareMostCommentedPostToTwitter:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [BFUtility shareToSicial:1 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareMostCommentedPostToInstagram:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = [GlobalData sharedGlobalData].g_arrayMostCommentedPost[indexPath.row];
    
    [BFUtility shareToSicial:2 viewCtrl:self text:record.content imageUrl:record.filePath];
    
}

@end
