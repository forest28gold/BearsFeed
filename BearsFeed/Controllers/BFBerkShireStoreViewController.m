//
//  BFBerkShireStoreViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFBerkShireStoreViewController.h"
#import <WebKit/WebKit.h>

@interface BFBerkShireStoreViewController ()

@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) CALayer *progresslayer;

@end

@implementation BFBerkShireStoreViewController

@synthesize m_view, m_lblTitle, m_btnBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_lblTitle.text = [GlobalData sharedGlobalData].g_strTitle;
    
    if ([GlobalData sharedGlobalData].g_toggleTwitterLinkIsOn) {
        [m_btnBack setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    } else {
        [m_btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    }
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.m_view.bounds];
    [self.m_view addSubview:webView];
    self.webView = webView;

    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor colorWithHexString:@"#0e82fe"].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getRequestUrl:[GlobalData sharedGlobalData].g_strTitle]]]];
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

- (NSString*)getRequestUrl:(NSString*)strTitle {
    
    NSString *strUrl = BEARSFEED_SHOPPING_LINK;
    
    if ([strTitle isEqualToString:TITLE_TERMS_OF_USE]) {
        strUrl = BEARSFEED_TERMS_OF_USE_LINK;
    } else if ([strTitle isEqualToString:TITLE_PRIVACY_POLICY]) {
        strUrl = BEARSFEED_PRIVACY_POLICY_LINK;
    } else if ([strTitle isEqualToString:TITLE_HELP]) {
        strUrl = BEARSFEED_HELP_LINK;
    } else if ([strTitle isEqualToString:TITLE_BERKSHIRE_STORE]) {
        strUrl = BEARSFEED_SHOPPING_LINK;
    } else if ([strTitle isEqualToString:@""]) {
        strUrl = [GlobalData sharedGlobalData].g_strPostLink;
    }
    
    return strUrl;
}

- (IBAction)onBack:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_toggleTwitterLinkIsOn) {
        [GlobalData sharedGlobalData].g_toggleTwitterLinkIsOn = false;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        NSLog(@"%@", change);
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
