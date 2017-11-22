//
//  BFTwitterFeedViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 5/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFTwitterFeedViewController.h"
#import "BFTwitterUserTimelineViewController.h"
#import "BFTwitterHomeTimelineViewController.h"

@interface BFTwitterFeedViewController () <ViewPagerDataSource, ViewPagerDelegate>
{
    BFTwitterUserTimelineViewController *viewUserCtrl;
    BFTwitterHomeTimelineViewController *viewHomeCtrl;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation BFTwitterFeedViewController

@synthesize m_btnHome, m_viewTab, m_btnUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewPagerCtrl = [[ViewPagerController alloc] init];
    self.viewPagerCtrl.view.frame = CGRectMake(0, 0, self.m_viewTab.frame.size.width, self.m_viewTab.frame.size.height + 5);
    self.viewPagerCtrl.delegate = self;
    self.viewPagerCtrl.dataSource = self;
    [self.m_viewTab addSubview:self.viewPagerCtrl.view];
    
    viewUserCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TWITTER_USER];
    viewHomeCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TWITTER_HOME];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
    [GlobalData sharedGlobalData].g_toggleTwitterIsOn = false;
    
    [GlobalData sharedGlobalData].g_ctrlTwitter = self;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([GlobalData sharedGlobalData].g_toggleTwitterIsOn) {
        [viewUserCtrl viewWillAppear:NO];
    } else {
        [viewHomeCtrl viewWillAppear:NO];
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

- (IBAction)onNavClose:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSetHome {
    
    [m_btnHome setBackgroundImage:[UIImage imageNamed:@"segument_newest_selected"] forState:UIControlStateNormal];
    [m_btnUser setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_normal"] forState:UIControlStateNormal];
    
    [m_btnHome setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [m_btnUser setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
}

- (void)onSetTweets {
    
    [m_btnHome setBackgroundImage:[UIImage imageNamed:@"segument_newest_normal"] forState:UIControlStateNormal];
    [m_btnUser setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_selected"] forState:UIControlStateNormal];
    
    [m_btnHome setTitleColor:[UIColor colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnUser setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
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
    self.numberOfTabs = 2;
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
        return viewHomeCtrl;
    } else {
        return viewUserCtrl;
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
        [self onSetHome];
    } else {
        [self onSetTweets];
    }
}

-(IBAction)onSelectHome:(id)sender {
    
    [self onSetHome];
    [self.viewPagerCtrl selectTabAtIndex:0];
}

-(IBAction)onSelectTweets:(id)sender {
    
    [self onSetTweets];
    [self.viewPagerCtrl selectTabAtIndex:1];
}

- (void)goToPhotoView {
    
    [self performSegueWithIdentifier:SEGUE_PHOTO_TWITTER sender:nil];
}

- (void)goToPostLink {
    
    [GlobalData sharedGlobalData].g_strTitle = @"";
    [GlobalData sharedGlobalData].g_toggleTwitterLinkIsOn = true;
    
    [self performSegueWithIdentifier:SEGUE_LINK_TWITTER sender:nil];
}

@end
