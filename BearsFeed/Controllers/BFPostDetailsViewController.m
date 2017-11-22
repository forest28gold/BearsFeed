//
//  BFPostDetailsViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFPostDetailsViewController.h"
#import "BFCommentTableViewCell.h"
#import "BFUserProfileViewController.h"
#import "BFPostTableViewCell.h"
#import "BFPostPhotoTableViewCell.h"

static NSString *BFPostTableViewCellIdentifier = @"BFPostTableViewCellIdentifier";
static NSString *BFPostPhotoTableViewCellIdentifier = @"BFPostPhotoTableViewCellIdentifier";
static NSString *BFCommentTableViewCellIdentifier = @"BFCommentTableViewCellIdentifier";

@interface BFPostDetailsViewController () <UITableViewDragLoadDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    BOOL toggleKeyboardIsOn;
    int _dataCount;
}

@property (nonatomic, strong) NSMutableArray *commentDataArray;

@end

@implementation BFPostDetailsViewController

@synthesize m_tableView, m_btnSend, textView, containerView, m_btnReport;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([GlobalData sharedGlobalData].g_toggleMyPostIsOn) {
        [m_btnReport setImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    } else {
        [m_btnReport setImage:[UIImage imageNamed:@"nav_report"] forState:UIControlStateNormal];
    }
    
    toggleKeyboardIsOn = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.m_tableView addGestureRecognizer:tapGestureRecognizer];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    textView.userInteractionEnabled = YES;
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.font = [UIFont fontWithName:@"HelveticaNeue" size:13 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Write a comment...";
    textView.textColor = [UIColor darkGrayColor];
    
    [m_btnSend addTarget:self action:@selector(onCommentPost:) forControlEvents:UIControlEventTouchUpInside];
    
    _dataCount = 0;
    
    [m_tableView registerClass:[BFPostTableViewCell class] forCellReuseIdentifier:BFPostTableViewCellIdentifier];
    [m_tableView registerClass:[BFPostPhotoTableViewCell class] forCellReuseIdentifier:BFPostPhotoTableViewCellIdentifier];
    [m_tableView registerClass:[BFCommentTableViewCell class] forCellReuseIdentifier:BFCommentTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    if ([[GlobalData sharedGlobalData].g_postData.postUser.email isEqualToString:[GlobalData sharedGlobalData].g_userData.email]) {
        [GlobalData sharedGlobalData].g_toggleMyPostIsOn = true;
        [m_btnReport setImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    }
    
    self.commentDataArray = [[NSMutableArray alloc] init];
    [self.commentDataArray addObject:[GlobalData sharedGlobalData].g_postData];
    
    if ([GlobalData sharedGlobalData].g_postData.commentCount > 0) {
        SVPROGRESSHUD_SHOW;
        [self initLoadPostCommentData];
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

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    if (!toggleKeyboardIsOn) {
        CGRect tableViewFrame = m_tableView.frame;
        tableViewFrame.size.height = m_tableView.frame.size.height - keyboardBounds.size.height;
        m_tableView.frame = tableViewFrame;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = true;
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    if (toggleKeyboardIsOn) {
        CGRect tableViewFrame = m_tableView.frame;
        tableViewFrame.size.height = self.view.bounds.size.height - containerFrame.size.height - 60 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
        m_tableView.frame = tableViewFrame;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = false;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // set views with new info
    containerView.frame = containerFrame;
    
    CGRect tableViewFrame = m_tableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - containerFrame.size.height - 60 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
    m_tableView.frame = tableViewFrame;
    
    toggleKeyboardIsOn = false;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
    
    CGRect tableViewFrame = m_tableView.frame;
    tableViewFrame.size.height += diff;
    m_tableView.frame = tableViewFrame;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    
    if (growingTextView.text.length > 400) {
        growingTextView.text = [growingTextView.text substringToIndex:400];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (growingTextView.text.length > 400) {
        growingTextView.text = [growingTextView.text substringToIndex:400];
    }
    
    return true;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onReportPost:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_toggleMyPostIsOn) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Are you sure you want to delete this post?"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:@"Cancel", nil];
        
        [alert show];
        
    } else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Report Post", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        // do something here...
        [self onDeletePost];
    } else if (buttonIndex == 1) { // Cancel
        //Code for cancel button
        
    }
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            [self onReportPost];
            break;
        }
        default:
            break;
    }
}

- (void)initLoadPostCommentData {
    
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"fromUser"];
    [queryOption addRelated:@"toUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Comment class]] find:query response:^(BackendlessCollection *comments) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (comments.data.count > 0) {
            
            for (Comment *comment in comments.data) {
                
                CommentData *record = [[CommentData alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParseCommentData:comment];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [self.commentDataArray addObject:record];
                }
                
            }
            
            [m_tableView reloadData];
            
        } else {
            [m_tableView reloadData];
        }
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [m_tableView reloadData];
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
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Comment class]] find:query response:^(BackendlessCollection *comments) {
        
        if (comments.data.count > 0) {
            
            self.commentDataArray = [[NSMutableArray alloc] init];
            [self.commentDataArray addObject:[GlobalData sharedGlobalData].g_postData];
            
            for (Comment *comment in comments.data) {
                
                CommentData *record = [[CommentData alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParseCommentData:comment];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [self.commentDataArray addObject:record];
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
    [queryOption addRelated:@"fromUser"];
    [queryOption addRelated:@"toUser"];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Comment class]] find:query response:^(BackendlessCollection *comments) {
        
        if (comments.data.count > 0) {
            
            for (Comment *comment in comments.data) {
                
                CommentData *record = [[CommentData alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                record = [[GlobalData sharedGlobalData] onParseCommentData:comment];
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userData.userId]) {
                    [self.commentDataArray addObject:record];
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
    return self.commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PostData *postData = self.commentDataArray[indexPath.row];
        
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            BFPostPhotoTableViewCell *cell = (BFPostPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostPhotoTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithPhotoData:postData];
            
            [cell.btnUpVote addTarget:self action:@selector(onUpVotePost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownVote addTarget:self action:@selector(onDownVotePost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReadMore addTarget:self action:@selector(onReadMorePost:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btnReply addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnPhoto addTarget:self action:@selector(onPostPhotoView:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onShareDetailPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onShareDetailPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onShareDetailPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnReply.hidden = YES;

            cell.imgAvatar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPostDetailUserProfile:)];
            tapAvatar.cancelsTouchesInView = NO;
            [cell.imgAvatar addGestureRecognizer:tapAvatar];
            
            return cell;
            
        } else {
            
            BFPostTableViewCell *cell = (BFPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFPostTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithPostData:postData];
            
            [cell.btnUpVote addTarget:self action:@selector(onUpVotePost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDownVote addTarget:self action:@selector(onDownVotePost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnReadMore addTarget:self action:@selector(onReadMorePost:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btnReply addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareFB addTarget:self action:@selector(onShareDetailPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareTW addTarget:self action:@selector(onShareDetailPostToTwitter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnShareINS addTarget:self action:@selector(onShareDetailPostToInstagram:) forControlEvents:UIControlEventTouchUpInside];

            cell.btnReply.hidden = YES;
            
            cell.imgAvatar.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPostDetailUserProfile:)];
            tapAvatar.cancelsTouchesInView = NO;
            [cell.imgAvatar addGestureRecognizer:tapAvatar];
            
            return cell;
        }
        
    } else {
        
        CommentData *commentData = self.commentDataArray[indexPath.row];
        
        BFCommentTableViewCell *cell = (BFCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BFCommentTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithData:commentData];
        
        [cell.btnUpVote addTarget:self action:@selector(onUpVoteComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDownVote addTarget:self action:@selector(onDownVoteComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReadMore addTarget:self action:@selector(onReadMoreComment:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgAvatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPostDetailUserProfile:)];
        tapAvatar.cancelsTouchesInView = NO;
        [cell.imgAvatar addGestureRecognizer:tapAvatar];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        CGSize defaultSize = DEFAULT_CELL_SIZE;
        
        PostData *postData = self.commentDataArray[indexPath.row];
        
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
        
    } else { // Comment
        
        CGSize defaultSize = DEFAULT_CELL_SIZE_COMMENT;
        
        CommentData *dataDict = self.commentDataArray[indexPath.row];
        
        // Create our size
        CGSize cellSize = [BFCommentTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            
            [((BFCommentTableViewCell *)cellToSetup) setupCellWithData:dataDict];
            
            // return cell
            return cellToSetup;
        }];
        
        return cellSize.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)onPostDetailUserProfile:(UITapGestureRecognizer*)sender {
    
    UIImageView *btn = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    if (indexPath.row == 0) {
        
        PostData *postData = self.commentDataArray[indexPath.row];

        [GlobalData sharedGlobalData].g_postUser = postData.postUser;

        [[GlobalData sharedGlobalData].g_tabBar goToUserProfile];
        
    } else {
        
        CommentData *commentData = self.commentDataArray[indexPath.row];
        
        [GlobalData sharedGlobalData].g_postUser = commentData.fromUser;
        
        [[GlobalData sharedGlobalData].g_tabBar goToUserProfile];
        
    }
}

-(void)onPostPhotoView:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.commentDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_photoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoView];
}

-(void)onUpVotePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility likePostInBackground:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

-(void)onDownVotePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility dislikePostInBackground:sender indexPath:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

-(void)onReadMorePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.commentDataArray[indexPath.row];
    
    if (!postData.toggleReadMore) {
        postData.toggleReadMore = true;
    } else {
        postData.toggleReadMore = false;
    }
    
    [self.commentDataArray replaceObjectAtIndex:indexPath.row withObject:postData];
    [m_tableView reloadData];
}

-(void)onShareDetailPostToFacebook:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.commentDataArray[indexPath.row];
    
    [BFUtility shareToSicial:0 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareDetailPostToTwitter:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.commentDataArray[indexPath.row];
    
    [BFUtility shareToSicial:1 viewCtrl:self text:record.content imageUrl:record.filePath];
}

-(void)onShareDetailPostToInstagram:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *record = self.commentDataArray[indexPath.row];
    
    [BFUtility shareToSicial:2 viewCtrl:self text:record.content imageUrl:record.filePath];
}

- (void)onReadMoreComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    CommentData *commentData = self.commentDataArray[indexPath.row];
    
    if (!commentData.toggleReadMore) {
        commentData.toggleReadMore = true;
    } else {
        commentData.toggleReadMore = false;
    }
    
    [self.commentDataArray replaceObjectAtIndex:indexPath.row withObject:commentData];
    [m_tableView reloadData];
}

-(void)onUpVoteComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility likeCommentInBackground:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

-(void)onDownVoteComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [BFUtility dislikeCommentInBackground:sender indexPath:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

- (void)onDeletePost {
    
    SVPROGRESSHUD_SHOW;
    
    if (![[GlobalData sharedGlobalData].g_postData.filePath isEqualToString:@""] && [GlobalData sharedGlobalData].g_postData.filePath != nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *items = [[GlobalData sharedGlobalData].g_postData.filePath componentsSeparatedByString:@"/"];
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", BACKEND_URL_POST, [items lastObject]];
            [backendless.fileService remove:fileName];
            NSLog(@"***************** Post photo file is deleted. **********************");
        });
    }
    
    NSString *strDeletePostId = [GlobalData sharedGlobalData].g_postData.objectId;
    
    [[backendless.persistenceService of:[Post class]] removeID:strDeletePostId response:^(id response) {
        NSLog(@"=================== Post data is deleted. ===================");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
            [[backendless.persistenceService of:[Comment class]] removeAll:query];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
            [[backendless.persistenceService of:[Notification class]] removeAll:query];
        });
        
        SVPROGRESSHUD_SUCCESS(@"Deletion of the post is succeed.");
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(Fault *fault) {
        NSLog(@"Failed remove post data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Deletion of the post is failed. Please try again."];
    }];
}

- (void)onReportPost {
    
    SVPROGRESSHUD_SHOW;
    
    [[GlobalData sharedGlobalData].g_postData.reportTypeArray addObject:[GlobalData sharedGlobalData].g_userData.userId];
    
    [GlobalData sharedGlobalData].g_postData.reportCount = [GlobalData sharedGlobalData].g_postData.reportCount + 1;
    
    [GlobalData sharedGlobalData].g_postData.reportType = @"";
    
    if ([GlobalData sharedGlobalData].g_postData.reportTypeArray.count > 1) {
        
        [GlobalData sharedGlobalData].g_postData.reportType = [GlobalData sharedGlobalData].g_postData.reportTypeArray[0];
        
        for (int i = 1; i < [GlobalData sharedGlobalData].g_postData.reportTypeArray.count; i++) {
            [GlobalData sharedGlobalData].g_postData.reportType = [NSString stringWithFormat:@"%@;%@", [GlobalData sharedGlobalData].g_postData.reportType, [GlobalData sharedGlobalData].g_postData.reportTypeArray[i]];
        }
    } else if ([GlobalData sharedGlobalData].g_postData.reportTypeArray.count == 1) {
        [GlobalData sharedGlobalData].g_postData.reportType = [GlobalData sharedGlobalData].g_postData.reportTypeArray[0];
    }
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            Post *updatedData = posts.data[0];
            
            [updatedData setReportCount:[GlobalData sharedGlobalData].g_postData.reportCount];
            [updatedData setReportType:[GlobalData sharedGlobalData].g_postData.reportType];
            
            [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                NSLog(@"******************* Post Report is succeed!********************");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                    
                    [deviceIDArray addObject:[[GlobalData sharedGlobalData].g_postData.postUser getProperty:KEY_DEVICE_ID]];
                    
                    PublishOptions *options = [PublishOptions new];
                    options.headers = @{@"ios-alert":ALERT_REPORT,
                                        @"ios-badge":PUSH_BADGE,
                                        @"ios-sound":PUSH_SOUND,
                                        @"android-ticker-text":PUSH_TITLE,
                                        @"android-content-title":PUSH_TITLE,
                                        @"android-content-text":ALERT_REPORT};
                    
                    
                    DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                    deliveryOptions.pushSinglecast = deviceIDArray;
                    
                    [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_REPORT publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                        NSLog(@"showMessageStatus: %@", res.status);
                    } error:^(Fault *fault) {
                        NSLog(@"sendMessage: fault = %@", fault);
                    }];
                    
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    Notification *notification = [Notification new];
                    notification.type = NOTI_REPORT;
                    notification.fromUser = [GlobalData sharedGlobalData].g_currentUser;
                    notification.toUser = [GlobalData sharedGlobalData].g_postData.postUser;
                    notification.time = [[GlobalData sharedGlobalData] getCurrentDate];
                    notification.commentId = @"";
                    notification.postId = [GlobalData sharedGlobalData].g_postData.objectId;
                    notification.userId = [GlobalData sharedGlobalData].g_postData.postUser.objectId;
                    [backendless.persistenceService save:notification];
                });
                
                SVPROGRESSHUD_SUCCESS(@"Report of the post is succeed.");
                [self.navigationController popViewControllerAnimated:YES];
            } error:^(Fault *fault) {
                NSLog(@"******************* Post Report is failed!********************");
                SVPROGRESSHUD_DISMISS;
                [[GlobalData sharedGlobalData] onErrorAlert:@"Report of this post is failed. Please try again."];
            }];
        } else {
            NSLog(@"******************* Post Report is not found!********************");
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:@"Report of this post is failed. Please try again."];
        }
    } error:^(Fault *fault) {
        NSLog(@"******************* Post Report is time out!********************");
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:@"Report of this post is failed. Please try again."];
    }];
}

-(IBAction)onCommentPost:(id)sender {
    
    NSString *strComment = textView.text;
    
    if ([strComment isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:@"Please input comment."];
        return;
    }
    
    NSData *data = [strComment dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *commentValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    Comment *commentData = [Comment new];
    commentData.postId = [GlobalData sharedGlobalData].g_postData.objectId;
    commentData.comment = commentValue;
    commentData.fromUser = [GlobalData sharedGlobalData].g_currentUser;
    commentData.toUser = [GlobalData sharedGlobalData].g_postData.postUser;
    commentData.time = [[GlobalData sharedGlobalData] getCurrentDate];
    commentData.likeCount = 0;
    commentData.likeType = @"";
    commentData.reportCount = 0;
    commentData.reportType = @"";
    
    SVPROGRESSHUD_SHOW;
    
    [backendless.persistenceService save:commentData response:^(id response) {
        
        NSLog(@"saved new comment data");
        
        Comment *comment = response;
        
        SVPROGRESSHUD_DISMISS;
        
        textView.text = @"";
        [textView resignFirstResponder];
        
        CommentData *record = [[CommentData alloc] init];
        record.objectId = comment.objectId;
        record.postId = comment.postId;
        record.comment = comment.comment;
        record.fromUser = comment.fromUser;
        record.toUser = comment.toUser;
        record.time = comment.time;
        record.likeCount = comment.likeCount;
        record.likeType = comment.likeType;
        record.reportCount = comment.reportCount;
        record.reportType = comment.reportType;
        record.toggleReadMore = false;
        
        record.likeTypeArray = [[NSMutableArray alloc] init];
        record.reportTypeArray = [[NSMutableArray alloc] init];
        
        if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
            
            if ([record.likeType containsString:@";"]) {
                NSArray *itemsLike = [comment.likeType componentsSeparatedByString:@";"];
                record.likeTypeArray = [itemsLike mutableCopy];
            } else {
                [record.likeTypeArray addObject:record.likeType];
            }
        }
        
        if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
            
            if ([record.reportType containsString:@";"]) {
                NSArray *itemsLike = [comment.reportType componentsSeparatedByString:@";"];
                record.reportTypeArray = [itemsLike mutableCopy];
            } else {
                [record.reportTypeArray addObject:record.reportType];
            }
        }
        
        [self.commentDataArray insertObject:record atIndex:0];
        [self.m_tableView reloadData];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
            
            [deviceIDArray addObject:[record.toUser getProperty:KEY_DEVICE_ID]];
            
            PublishOptions *options = [PublishOptions new];
            options.headers = @{@"ios-alert":ALERT_COMMENT,
                                @"ios-badge":PUSH_BADGE,
                                @"ios-sound":PUSH_SOUND,
                                @"android-ticker-text":PUSH_TITLE,
                                @"android-content-title":PUSH_TITLE,
                                @"android-content-text":ALERT_COMMENT};
            
            DeliveryOptions *deliveryOptions = [DeliveryOptions new];
            deliveryOptions.pushSinglecast = deviceIDArray;
            
            [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_COMMENT publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                NSLog(@"showMessageStatus: %@", res.status);
            } error:^(Fault *fault) {
                NSLog(@"sendMessage: fault = %@", fault);
            }];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            Notification *notification = [Notification new];
            notification.type = NOTI_COMMENT;
            notification.fromUser = [GlobalData sharedGlobalData].g_currentUser;
            notification.toUser = record.toUser;
            notification.time = [[GlobalData sharedGlobalData] getCurrentDate];
            notification.commentId = record.objectId;
            notification.postId = record.postId;
            notification.userId = record.toUser.objectId;
            [backendless.persistenceService save:notification];
        });
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of comment data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_comment_failed", "")];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [GlobalData sharedGlobalData].g_postData.commentCount = [GlobalData sharedGlobalData].g_postData.commentCount + 1;
        
        [[GlobalData sharedGlobalData].g_postData.commentTypeArray addObject:[GlobalData sharedGlobalData].g_userData.userId];
        
        [GlobalData sharedGlobalData].g_postData.commentType = @"";
        
        if ([GlobalData sharedGlobalData].g_postData.commentTypeArray.count > 1) {
            
            [GlobalData sharedGlobalData].g_postData.commentType = [GlobalData sharedGlobalData].g_postData.commentTypeArray[0];
            
            for (int i = 1; i < [GlobalData sharedGlobalData].g_postData.commentTypeArray.count; i++) {
                [GlobalData sharedGlobalData].g_postData.commentType = [NSString stringWithFormat:@"%@;%@", [GlobalData sharedGlobalData].g_postData.commentType, [GlobalData sharedGlobalData].g_postData.commentTypeArray[i]];
            }
        } else if ([GlobalData sharedGlobalData].g_postData.commentTypeArray.count == 1) {
            [GlobalData sharedGlobalData].g_postData.commentType = [GlobalData sharedGlobalData].g_postData.commentTypeArray[0];
        }
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, [GlobalData sharedGlobalData].g_postData.objectId];
        [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
            
            if (posts.data.count > 0) {
                
                Post *updatedData = posts.data[0];
                
                [updatedData setCommentCount:[GlobalData sharedGlobalData].g_postData.commentCount];
                [updatedData setCommentType:[GlobalData sharedGlobalData].g_postData.commentType];
                
                [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                    NSLog(@"******************* Post Comment Count is succeed!********************");
                } error:^(Fault *fault) {
                    NSLog(@"******************* Post Comment Count is failed!********************");
                }];
            } else {
                NSLog(@"******************* Post Comment Count is not found!********************");
            }
        } error:^(Fault *fault) {
            NSLog(@"******************* Post Comment Count is time out!********************");
        }];
    });
}

@end
