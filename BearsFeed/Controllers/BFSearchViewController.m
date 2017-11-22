//
//  BFSearchViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFSearchViewController.h"
#import "BFCommentViewController.h"
#import "BFPostTableViewCell.h"
#import "BFPostPhotoTableViewCell.h"
#import "BFPostDetailsViewController.h"
#import "BFUserProfileViewController.h"

static NSString *BFPostTableViewCellIdentifier = @"BFPostTableViewCellIdentifier";
static NSString *BFPostPhotoTableViewCellIdentifier = @"BFPostPhotoTableViewCellIdentifier";

@interface BFSearchViewController () <UITableViewDragLoadDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    NSString *strSearchKey;
    BOOL togglePeopleIsOn;
    int _dataPeopleCount;
    int _dataPostCount;
}

@property (nonatomic, strong) NSMutableArray *searchPeopleDataArray;
@property (nonatomic, strong) NSMutableArray *searchPostDataArray;

@end

@implementation BFSearchViewController

@synthesize m_btnPost, m_btnPeople, m_txtSearch, m_tableViewPost, m_tableViewPeople;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onSetPeople];
    
    [m_txtSearch addTarget:self action:@selector(textFieldSearchChange:) forControlEvents:UIControlEventEditingChanged];
    strSearchKey = @"";
    
    _dataPeopleCount = 0;
    _dataPostCount = 0;
    
    [m_tableViewPeople setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableViewPeople.showRefreshView = false;
    m_tableViewPeople.showLoadMoreView = true;
    
    [m_tableViewPost registerClass:[BFPostTableViewCell class] forCellReuseIdentifier:BFPostTableViewCellIdentifier];
    [m_tableViewPost registerClass:[BFPostPhotoTableViewCell class] forCellReuseIdentifier:BFPostPhotoTableViewCellIdentifier];
    [m_tableViewPost setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableViewPost.showRefreshView = false;
    m_tableViewPost.showLoadMoreView = true;
    
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_btnPeople.layer.cornerRadius = m_btnPeople.frame.size.height / 2;
    m_btnPost.layer.cornerRadius = m_btnPost.frame.size.height / 2;
    m_btnPeople.layer.borderWidth = 1.0f;
    m_btnPost.layer.borderWidth = 1.0f;
    m_btnPeople.layer.borderColor = [UIColor colorWithHexString:@"#39ca74"].CGColor;
    m_btnPost.layer.borderColor = [UIColor colorWithHexString:@"#39ca74"].CGColor;
    
    self.searchPeopleDataArray = [[NSMutableArray alloc] init];
    self.searchPostDataArray = [[NSMutableArray alloc] init];
    
    [m_txtSearch becomeFirstResponder];
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

- (void)onSetPeople {
    
    togglePeopleIsOn = true;
    
    [m_btnPeople setBackgroundColor:[UIColor colorWithHexString:@"#39ca74"]];
    [m_btnPost setBackgroundColor:[UIColor whiteColor]];
    
    [m_btnPeople setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_btnPost setTitleColor:[UIColor colorWithHexString:@"#39ca74"] forState:UIControlStateNormal];
    
    m_tableViewPeople.hidden = NO;
    m_tableViewPost.hidden = YES;
}

- (void)onSetPost {
    
    togglePeopleIsOn = false;
    
    [m_btnPeople setBackgroundColor:[UIColor whiteColor]];
    [m_btnPost setBackgroundColor:[UIColor colorWithHexString:@"#39ca74"]];
    
    [m_btnPeople setTitleColor:[UIColor colorWithHexString:@"#39ca74"] forState:UIControlStateNormal];
    [m_btnPost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    m_tableViewPeople.hidden = YES;
    m_tableViewPost.hidden = NO;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectPeople:(id)sender {
    [self onSetPeople];
}

- (IBAction)onSelectPost:(id)sender {
    [self onSetPost];
}

// Somewhere in your implementation file:
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"Will begin dragging");
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Did Scroll");
}

//------------  Search --------------

- (void)textFieldSearchChange:(UITextField *)textField {
    
    strSearchKey = textField.text;
    
    if ([strSearchKey isEqualToString:@""]) {
        
        self.searchPeopleDataArray = [[NSMutableArray alloc] init];
        [m_tableViewPeople reloadData];
        m_tableViewPeople.showLoadMoreView = false;
        
        self.searchPostDataArray = [[NSMutableArray alloc] init];
        [m_tableViewPost reloadData];
        m_tableViewPost.showLoadMoreView = false;
        
        return;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    strSearchKey = textField.text;
    [self.view endEditing:YES];
    [self onSearchData];
    
    return YES;
}

- (void)onSearchData {
    
    if ([strSearchKey isEqualToString:@""]) {
        
        self.searchPeopleDataArray = [[NSMutableArray alloc] init];
        [m_tableViewPeople reloadData];
        m_tableViewPeople.showLoadMoreView = false;
        
        self.searchPostDataArray = [[NSMutableArray alloc] init];
        [m_tableViewPost reloadData];
        m_tableViewPost.showLoadMoreView = false;
        
        return;
    }
    
    SVPROGRESSHUD_SHOW;
    
    if (!togglePeopleIsOn) {
        
        _dataPostCount = LOAD_DATA_COUNT;
        
        QueryOptions *queryOption = [QueryOptions new];
        [queryOption addRelated:@"postUser"];
        queryOption.sortBy = @[@"time DESC"];
        queryOption.pageSize = [NSNumber numberWithInt:_dataPostCount];
        queryOption.offset = [NSNumber numberWithInt:0];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_CONTENT, strSearchKey];
        query.queryOptions = queryOption;
        [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
            
            SVPROGRESSHUD_DISMISS;
            
            self.searchPostDataArray = [[NSMutableArray alloc] init];
            
            if (posts.data.count > 0) {
                
                for (Post *post in posts.data) {
                    
                    PostData *record = [[PostData alloc] init];
                    record.commentTypeArray = [[NSMutableArray alloc] init];
                    record.likeTypeArray = [[NSMutableArray alloc] init];
                    record.reportTypeArray = [[NSMutableArray alloc] init];
                    record = [[GlobalData sharedGlobalData] onParsePostData:post];
                    
                    if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                        [self.searchPostDataArray addObject:record];
                    }
                }
                
                [m_tableViewPost reloadData];
                
            } else {
                [m_tableViewPost reloadData];
            }
            
        } error:^(Fault *fault) {
            
            SVPROGRESSHUD_DISMISS;
            [m_tableViewPost reloadData];
        }];
        
    } else {
        
        QueryOptions *queryOption = [QueryOptions new];
        queryOption.sortBy = @[@"created DESC"];
        queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
        queryOption.offset = [NSNumber numberWithInt:_dataPeopleCount];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\' OR %@ LIKE \'%%%@%%\'", KEY_NAME, strSearchKey, KEY_BIO, strSearchKey];
//        query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_BIO, strSearchKey];
        query.queryOptions = queryOption;
        [[backendless.persistenceService of:[BackendlessUser class]] find:query response:^(BackendlessCollection *users) {
            
            SVPROGRESSHUD_DISMISS;
            
            self.searchPeopleDataArray = [[NSMutableArray alloc] init];
            
            if (users.data.count > 0) {
                for (BackendlessUser *user in users.data) {
                    
                    [self.searchPeopleDataArray addObject:user];
                }
                [m_tableViewPeople reloadData];
                
            } else {
                [m_tableViewPeople reloadData];
            }
            
        } error:^(Fault *fault) {
            
            SVPROGRESSHUD_DISMISS;
            [m_tableViewPeople reloadData];
        }];
    }
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
}

- (void)finishLoadMore {
    
    if (!togglePeopleIsOn) {
        
        QueryOptions *queryOption = [QueryOptions new];
        [queryOption addRelated:@"postUser"];
        queryOption.sortBy = @[@"time DESC"];
        queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
        queryOption.offset = [NSNumber numberWithInt:_dataPostCount];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_CONTENT, strSearchKey];
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
                        [self.searchPostDataArray addObject:record];
                    }
                }
                
                [m_tableViewPost finishLoadMore];
                [m_tableViewPost reloadData];
                m_tableViewPost.showLoadMoreView = true;
                
            } else {
                
                [m_tableViewPost finishLoadMore];
                [m_tableViewPost reloadData];
                m_tableViewPost.showLoadMoreView = true;
            }
            _dataPostCount += LOAD_DATA_COUNT;
            
        } error:^(Fault *fault) {
            
            [m_tableViewPost finishLoadMore];
            [m_tableViewPost reloadData];
            m_tableViewPost.showLoadMoreView = true;
        }];
        
    } else {
        
        QueryOptions *queryOption = [QueryOptions new];
        queryOption.sortBy = @[@"created DESC"];
        queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
        queryOption.offset = [NSNumber numberWithInt:_dataPeopleCount];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\' OR %@ LIKE \'%%%@%%\'", KEY_NAME, strSearchKey, KEY_BIO, strSearchKey];
        query.queryOptions = queryOption;
        [[backendless.persistenceService of:[BackendlessUser class]] find:query response:^(BackendlessCollection *users) {
            
            if (users.data.count > 0) {
                
                self.searchPeopleDataArray = [[NSMutableArray alloc] init];
                
                for (BackendlessUser *user in users.data) {
                    
                    [self.searchPeopleDataArray addObject:user];
                }
                
                [m_tableViewPeople finishLoadMore];
                [m_tableViewPeople reloadData];
                m_tableViewPeople.showLoadMoreView = true;
                
            } else {
                
                [m_tableViewPeople finishLoadMore];
                [m_tableViewPeople reloadData];
                m_tableViewPeople.showLoadMoreView = true;
            }
            _dataPostCount += LOAD_DATA_COUNT;
            
        } error:^(Fault *fault) {
            
            [m_tableViewPeople finishLoadMore];
            [m_tableViewPeople reloadData];
            m_tableViewPeople.showLoadMoreView = true;
            
        }];
    }
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
    
    if (tableView.tag == 1) {  // People
        return self.searchPeopleDataArray.count;
    } else {  // Post
        return self.searchPostDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {  // People
        return 80 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
    } else {  // Post
        
        CGSize defaultSize = DEFAULT_CELL_SIZE;
        
        PostData *postData = self.searchPostDataArray[indexPath.row];
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {  // People
        
        BackendlessUser *user = self.searchPeopleDataArray[indexPath.row];
        
        UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PeopleCell" forIndexPath:indexPath];
        
        UIImageView *imgAvatar = (UIImageView*)[_cell viewWithTag:1];
        UILabel *lblName = (UILabel*)[_cell viewWithTag:2];
        UILabel *lblBio = (UILabel*)[_cell viewWithTag:3];
        
        NSURL *imageAvatarURL = [NSURL URLWithString:[user getProperty:KEY_PHOTO_URL]];
        [imgAvatar setShowActivityIndicatorView:YES];
        [imgAvatar setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [imgAvatar sd_setImageWithURL:imageAvatarURL placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        lblName.text = user.name;
        
        NSString *strBio = [user getProperty:KEY_BIO];
        NSData *strdata = [strBio dataUsingEncoding:NSUTF8StringEncoding];
        NSString *bioValue = [[NSString alloc] initWithData:strdata encoding:NSNonLossyASCIIStringEncoding];
        
        lblBio.text = bioValue;
        
        UIView* m_view = (UIView*)[_cell viewWithTag:20];
        if (m_view.frame.size.width < self.m_tableViewPeople.frame.size.width) {
            [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
        }
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2;
        
        return _cell;
        
    } else {  // Post
        
        PostData *postData = self.searchPostDataArray[indexPath.row];
        
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            BFPostPhotoTableViewCell *cell = (BFPostPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostPhotoTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithPhotoData:postData];
            
            [cell.btnUpVote addTarget:self action:@selector(onSearchUpVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownVote addTarget:self action:@selector(onSearchDownVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReadMore addTarget:self action:@selector(onSearchReadMore:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnComment addTarget:self action:@selector(onSearchComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReply addTarget:self action:@selector(onSearchReply:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnPhoto addTarget:self action:@selector(onSearchPhotoView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onShareSearchPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onShareSearchPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onShareSearchPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.imgAvatar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSearchUserProfile:)];
            tapAvatar.cancelsTouchesInView = NO;
            [cell.imgAvatar addGestureRecognizer:tapAvatar];
            
            return cell;
            
        } else {
            
            BFPostTableViewCell *cell = (BFPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithPostData:postData];
            
            [cell.btnUpVote addTarget:self action:@selector(onSearchUpVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownVote addTarget:self action:@selector(onSearchDownVote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReadMore addTarget:self action:@selector(onSearchReadMore:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnComment addTarget:self action:@selector(onSearchComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReply addTarget:self action:@selector(onSearchReply:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onShareSearchPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onShareSearchPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onShareSearchPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.imgAvatar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSearchUserProfile:)];
            tapAvatar.cancelsTouchesInView = NO;
            [cell.imgAvatar addGestureRecognizer:tapAvatar];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView.tag == 1) { // People
        
        [GlobalData sharedGlobalData].g_postUser = self.searchPeopleDataArray[indexPath.row];
        
        BFUserProfileViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_USER_PROFILE];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else { // Post
        
        [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
        [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
        [GlobalData sharedGlobalData].g_postData = self.searchPostDataArray[indexPath.row];
        
        [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
        
        BFPostDetailsViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_POST_DETAILS];
        [self.navigationController pushViewController:nextCtrl animated:true];
    }
}

-(void)onSearchUserProfile:(UITapGestureRecognizer*)sender {
    
    UIImageView *btn = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPeople indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.searchPostDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_postUser = postData.postUser;
    
    BFUserProfileViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_USER_PROFILE];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(void)onSearchUpVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility likePostInBackground:indexPath dataArray:self.searchPostDataArray];
    
    [m_tableViewPeople reloadData];
}

-(void)onSearchDownVote:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility dislikePostInBackground:sender indexPath:indexPath dataArray:self.searchPostDataArray];
    
    [m_tableViewPeople reloadData];
}

-(void)onSearchReadMore:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.searchPostDataArray[indexPath.row];
    
    if (!postData.toggleReadMore) {
        postData.toggleReadMore = true;
    } else {
        postData.toggleReadMore = false;
    }
    
    [self.searchPostDataArray replaceObjectAtIndex:indexPath.row withObject:postData];
    [m_tableViewPost reloadData];
}

-(void)onSearchPhotoView:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.searchPostDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_photoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoView];
}

-(void)onSearchComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = self.searchPostDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = false;
    
    BFCommentViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_COMMENT];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(void)onSearchReply:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = self.searchPostDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_toggleReplyIsOn = true;
    
    BFCommentViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_COMMENT];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(void)onShareSearchPostToFacebook:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.searchPostDataArray[indexPath.row];
    
    [BFUtility shareToSicial:0 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareSearchPostToTwitter:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.searchPostDataArray[indexPath.row];
    
    [BFUtility shareToSicial:1 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareSearchPostToInstagram:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableViewPost];
    NSIndexPath *indexPath = [self.m_tableViewPost indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.searchPostDataArray[indexPath.row];
    
    [BFUtility shareToSicial:2 viewCtrl:self text:record.content imageUrl:record.filePath];
}

@end
