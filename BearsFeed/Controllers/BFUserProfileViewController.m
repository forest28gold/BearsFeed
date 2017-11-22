//
//  BFUserProfileViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFUserProfileViewController.h"
#import "BFPostTableViewCell.h"
#import "BFPostPhotoTableViewCell.h"

static NSString *BFPostTableViewCellIdentifier = @"BFPostTableViewCellIdentifier";
static NSString *BFPostPhotoTableViewCellIdentifier = @"BFPostPhotoTableViewCellIdentifier";

@interface BFUserProfileViewController () <UITableViewDragLoadDelegate, UIGestureRecognizerDelegate>
{
    int _dataCount;
    BOOL tempIsOn;
}

@property (nonatomic,assign) float backImgHeight;
@property (nonatomic,assign) float backImgWidth;
@property (nonatomic, strong) NSMutableArray *postDataArray;

@end

@implementation BFUserProfileViewController

@synthesize m_lblName, m_tableView, m_lblBio, m_imgPhoto, m_imgBackPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempIsOn = false;
    _dataCount = 0;
    
    m_lblName.text = [GlobalData sharedGlobalData].g_postUser.name;
    
    NSString *strBio = [[GlobalData sharedGlobalData].g_postUser getProperty:KEY_BIO];
    NSData *strdata = [strBio dataUsingEncoding:NSUTF8StringEncoding];
    NSString *bioValue = [[NSString alloc] initWithData:strdata encoding:NSNonLossyASCIIStringEncoding];
    
    m_lblBio.text = bioValue;
    
    NSURL *imageAvatarURL = [NSURL URLWithString:[[GlobalData sharedGlobalData].g_postUser getProperty:KEY_PHOTO_URL]];
    [m_imgPhoto setShowActivityIndicatorView:YES];
    [m_imgPhoto setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgPhoto sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    [m_tableView registerClass:[BFPostTableViewCell class] forCellReuseIdentifier:BFPostTableViewCellIdentifier];
    [m_tableView registerClass:[BFPostPhotoTableViewCell class] forCellReuseIdentifier:BFPostPhotoTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showRefreshView = false;
    m_tableView.showLoadMoreView = true;
    
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_imgPhoto.layer.cornerRadius = m_imgPhoto.frame.size.height / 2;
    m_imgPhoto.layer.borderWidth = 2.0f;
    m_imgPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    
    m_imgBackPhoto.userInteractionEnabled = YES;
    m_imgBackPhoto.contentMode = UIViewContentModeScaleAspectFill;
    _backImgHeight = m_imgBackPhoto.frame.size.height;
    _backImgWidth = m_imgBackPhoto.frame.size.width;
    
    SVPROGRESSHUD_SHOW;
    [self initLoadUserPostData];
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (contentOffsety < 0) {
        CGRect rect = m_imgBackPhoto.frame;
        rect.size.height = _backImgHeight - contentOffsety;
        rect.size.width = _backImgWidth * (_backImgHeight - contentOffsety) / _backImgHeight;
        rect.origin.x = -(rect.size.width -_backImgWidth) / 2;
        rect.origin.y = 0;
        m_imgBackPhoto.frame = rect;
    } else {
        CGRect rect = m_imgBackPhoto.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        m_imgBackPhoto.frame = rect;
    }
}

- (void)initLoadUserPostData {
    
    self.postDataArray = [[NSMutableArray alloc] init];
    
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"postUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_postUser.objectId];
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
                    [self.postDataArray addObject:record];
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
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_postUser.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            self.postDataArray = [[NSMutableArray alloc] init];
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParsePostData:post];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [self.postDataArray addObject:record];
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
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_postUser.objectId];
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
                    [self.postDataArray addObject:record];
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
    return self.postDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostData *postData = self.postDataArray[indexPath.row];
    
    if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
        
        BFPostPhotoTableViewCell *cell = (BFPostPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostPhotoTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithPhotoData:postData];
        
        [cell.btnUpVote addTarget:self action:@selector(onUpVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDownVote addTarget:self action:@selector(onDownVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReadMore addTarget:self action:@selector(onReadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReply addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPhoto addTarget:self action:@selector(onDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareFB addTarget:self action:@selector(onShareUserPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareTW addTarget:self action:@selector(onShareUserPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareINS addTarget:self action:@selector(onShareUserPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else {
        
        BFPostTableViewCell *cell = (BFPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithPostData:postData];
        
        [cell.btnUpVote addTarget:self action:@selector(onUpVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDownVote addTarget:self action:@selector(onDownVote:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReadMore addTarget:self action:@selector(onReadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReply addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareFB addTarget:self action:@selector(onShareUserPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareTW addTarget:self action:@selector(onShareUserPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShareINS addTarget:self action:@selector(onShareUserPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    PostData *postData = self.postDataArray[indexPath.row];
    
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
    [GlobalData sharedGlobalData].g_postData = self.postDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPostDetails];
}

-(void)onUpVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility likePostInBackground:indexPath dataArray:self.postDataArray];
    
    [m_tableView reloadData];
}

-(void)onDownVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility dislikePostInBackground:sender indexPath:indexPath dataArray:self.postDataArray];
    
    [m_tableView reloadData];
}

-(void)onReadMore:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.postDataArray[indexPath.row];
    
    if (!postData.toggleReadMore) {
        postData.toggleReadMore = true;
    } else {
        postData.toggleReadMore = false;
    }
    
    [self.postDataArray replaceObjectAtIndex:indexPath.row withObject:postData];
    [m_tableView reloadData];
}

-(void)onDetailView:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.postDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_photoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoView];
}

-(void)onComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = self.postDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = false;
    
    [[GlobalData sharedGlobalData].g_tabBar goToCommentPost];
}

-(void)onReply:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = self.postDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = true;
    
    [[GlobalData sharedGlobalData].g_tabBar goToReplyPost];
}

-(void)onShareUserPostToFacebook:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.postDataArray[indexPath.row];
    
    [BFUtility shareToSicial:0 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareUserPostToTwitter:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.postDataArray[indexPath.row];
    
    [BFUtility shareToSicial:1 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareUserPostToInstagram:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.postDataArray[indexPath.row];
    
    [BFUtility shareToSicial:2 viewCtrl:self text:record.content imageUrl:record.filePath];
    
}

@end
