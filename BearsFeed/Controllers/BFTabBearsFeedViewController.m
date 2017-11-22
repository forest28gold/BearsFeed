//
//  BFTabBearsFeedViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFTabBearsFeedViewController.h"
#import "BFNewestPostsViewController.h"
#import "BFMostVotesViewController.h"
#import "BFMostCommentedViewController.h"

@interface BFTabBearsFeedViewController () <ViewPagerDataSource, ViewPagerDelegate>
{
    BFNewestPostsViewController *viewNewestCtrl;
    BFMostCommentedViewController *viewMostCommentedCtrl;
    BFMostVotesViewController *viewMostVotesCtrl;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation BFTabBearsFeedViewController

@synthesize m_viewTab, m_btnNewest, m_btnMostCommented, m_btnMostVotes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewPagerCtrl = [[ViewPagerController alloc] init];
    self.viewPagerCtrl.view.frame = CGRectMake(0, 0, self.m_viewTab.frame.size.width, self.m_viewTab.frame.size.height + 5);
    self.viewPagerCtrl.delegate = self;
    self.viewPagerCtrl.dataSource = self;
    [self.m_viewTab addSubview:self.viewPagerCtrl.view];
    
    viewNewestCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_NEWEST_POSTS];
    viewMostCommentedCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_MOST_COMMENTED];
    viewMostVotesCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_MOST_VOTES];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
    [GlobalData sharedGlobalData].g_strSelectedTab = SELECT_NEWEST;
    
    [GlobalData sharedGlobalData].g_ctrlTabHome = self;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
    
    if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_NEWEST]) {
        [viewNewestCtrl viewWillAppear:NO];
    } else if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_MOST_COMMENTED]) {
        [viewMostCommentedCtrl viewWillAppear:NO];
    } else if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_MOST_VOTES]) {
        [viewMostVotesCtrl viewWillAppear:NO];
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

- (IBAction)onSearch:(id)sender {
    [[GlobalData sharedGlobalData].g_tabBar goToSearch];
}

- (void)onSetNewest {
    
    [m_btnNewest setBackgroundImage:[UIImage imageNamed:@"segument_newest_selected"] forState:UIControlStateNormal];
    [m_btnMostCommented setBackgroundImage:[UIImage imageNamed:@"segument_most_commented_normal"] forState:UIControlStateNormal];
    [m_btnMostVotes setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_normal"] forState:UIControlStateNormal];
    
    [m_btnNewest setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [m_btnMostCommented setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostVotes setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
}

- (void)onSetMostCommented {
    
    [m_btnNewest setBackgroundImage:[UIImage imageNamed:@"segument_newest_normal"] forState:UIControlStateNormal];
    [m_btnMostCommented setBackgroundImage:[UIImage imageNamed:@"segument_most_commented_selected"] forState:UIControlStateNormal];
    [m_btnMostVotes setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_normal"] forState:UIControlStateNormal];
    
    [m_btnNewest setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostCommented setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [m_btnMostVotes setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
}

- (void)onSetMostVotes {
    
    [m_btnNewest setBackgroundImage:[UIImage imageNamed:@"segument_newest_normal"] forState:UIControlStateNormal];
    [m_btnMostCommented setBackgroundImage:[UIImage imageNamed:@"segument_most_commented_normal"] forState:UIControlStateNormal];
    [m_btnMostVotes setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_selected"] forState:UIControlStateNormal];
    
    [m_btnNewest setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostCommented setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostVotes setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self.viewPagerCtrl reloadData];
}

#pragma mark - Helpers

- (void)loadContent {
    self.numberOfTabs = 3;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_viewTab.frame.size.width, 0)];
    view.backgroundColor = [UIColor clearColor];
    view.hidden = YES;
    return view;    
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        return viewNewestCtrl;
    } else if (index == 1) {
        return viewMostCommentedCtrl;
    } else {
        return viewMostVotesCtrl;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 0.0;
        case ViewPagerOptionTabHeight:
            return 0.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 0.0 : 0.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    return [UIColor clearColor];
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
    if (index == 0) {
        [self onSetNewest];
    } else if (index == 1) {
        [self onSetMostCommented];
    } else {
        [self onSetMostVotes];
    }
}

-(IBAction)onSelectNewest:(id)sender {
    
    [self onSetNewest];
    [self.viewPagerCtrl selectTabAtIndex:0];
}

-(IBAction)onSelectMostCommented:(id)sender {
    
    [self onSetMostCommented];
    [self.viewPagerCtrl selectTabAtIndex:1];
}

-(IBAction)onSelectMostVotes:(id)sender {
    
    [self onSetMostVotes];
    [self.viewPagerCtrl selectTabAtIndex:2];
}

@end
