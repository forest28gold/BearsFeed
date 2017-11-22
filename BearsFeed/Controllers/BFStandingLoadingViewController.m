//
//  BFStandingLoadingViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 4/27/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFStandingLoadingViewController.h"
#import "BFEliminatedTargetViewController.h"

@interface BFStandingLoadingViewController () <MFMailComposeViewControllerDelegate>
{
    NSTimer *m_timerUnlock;
    CGFloat countProgress;
    int countTime;
}

@end

@implementation BFStandingLoadingViewController

@synthesize m_progressViewBar, m_lblScore;
@synthesize m_btnEnd, m_btnRestart, m_lblSuccess, m_viewLoading, m_viewRestart;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_progressViewBar.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
    m_progressViewBar.percentagePosition = M13ProgressViewBarPercentagePositionBottom;
    m_progressViewBar.progressBarThickness = 4.0;
    m_progressViewBar.progressBarCornerRadius = 4.0;
    m_progressViewBar.primaryColor = [UIColor colorWithHexString:@"2ecc71"];
    m_progressViewBar.secondaryColor = [UIColor colorWithHexString:@"ffffff"];
    
    [self initLoadView];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_btnRestart.layer.cornerRadius = BUTTON_RADIUS;
    
    m_timerUnlock = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(onLoadingProcess) userInfo:nil repeats:YES];
    
    [self onLoadEliminatedTargetData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [m_timerUnlock invalidate];
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

#pragma mark - MFMailCompose delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail cancelled: you cancelled the operation and no email message was queued."];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail saved: you saved the email message in the drafts folder."];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail failed: the email message was not saved or queued, possibly due to an error."];
            break;
        default:
            NSLog(@"Mail not sent.");
            [[GlobalData sharedGlobalData] onErrorAlert:@"Mail not sent."];
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initLoadView {
    
    countProgress = 0.0;
    countTime = 0;
    
    m_lblScore.text = [NSString stringWithFormat:@"Score :  %d", [GlobalData sharedGlobalData].g_userData.score];
    [m_progressViewBar setProgress:countProgress animated:NO];
    
    m_btnEnd.hidden = YES;
    m_viewRestart.hidden = YES;
    m_viewLoading.hidden = NO;
}

- (void)initLoadRestartView {
    
    countProgress = 0.0;
    countTime = 0;
    
    m_lblScore.text = [NSString stringWithFormat:@"Score :  %d", [GlobalData sharedGlobalData].g_userData.score];
    [m_progressViewBar setProgress:countProgress animated:NO];
    
    m_btnEnd.hidden = NO;
    m_viewRestart.hidden = NO;
    m_viewLoading.hidden = YES;
}

- (IBAction)onEnd:(id)sender {    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRestart:(id)sender {
    
    [self initLoadView];
    
    m_timerUnlock = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(onLoadingProcess) userInfo:nil repeats:YES];
    [self onLoadEliminatedTargetData];
}

- (IBAction)onEmailUs:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[SUPPORT_EMAIL]];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (void)onLoadEliminatedTargetData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Target *target = [Target new];
        target.targetUser = [GlobalData sharedGlobalData].g_currentUser;
        
        [backendless.persistenceService save:target response:^(id response) {
            NSLog(@"saved new target data");
            [GlobalData sharedGlobalData].g_target = response;
        } error:^(Fault *fault) {
            NSLog(@"Failed save in background of target data, = %@ <%@>", fault.message, fault.detail);
        }];
    });
    
    [GlobalData sharedGlobalData].g_arrayTarget = [[NSMutableArray alloc] init];
    
    QueryOptions *queryOption = [QueryOptions new];
    [queryOption addRelated:@"targetUser"];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Target class]] find:query response:^(BackendlessCollection *targets) {
        
        if (targets.data.count > 0) {
            
            for (Target *target in targets.data) {
                
                if (![target.targetUser.email isEqualToString:[GlobalData sharedGlobalData].g_userData.email]) {
                    [[GlobalData sharedGlobalData].g_arrayTarget addObject:target];
                }
//                [[GlobalData sharedGlobalData].g_arrayTarget addObject:target];
            }
            [self onLoad];
        } else {
            [self onLoad];
        }
    } error:^(Fault *fault) {
        [self onLoad];
    }];
}

- (void)onLoadingProcess {
    
    countTime++;
    countProgress = 0.125 * countTime;
    
    [m_progressViewBar setProgress:countProgress animated:YES];
    
    if (countProgress >= 1.0) {
        [m_timerUnlock invalidate];
    }
}

- (void)onLoad {
    
    countProgress = 1.0;
    [m_progressViewBar setProgress:countProgress animated:NO];
    
    BFEliminatedTargetViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_ELIMINATED_TARGET];
    [self.navigationController pushViewController:nextCtrl animated:NO];
}

- (IBAction)unwindBearStanding:(UIStoryboardSegue *)unwindSegue {
    
    if ([[GlobalData sharedGlobalData].g_strLastBearStanding isEqualToString:BEARS_END]) {
        m_lblSuccess.text = RESULT_END;
    } else if ([[GlobalData sharedGlobalData].g_strLastBearStanding isEqualToString:BEARS_ELIMINATED]) {
        m_lblSuccess.text = RESULT_ELIMINATED;
    } else if ([[GlobalData sharedGlobalData].g_strLastBearStanding isEqualToString:BEARS_LAST]) {
        m_lblSuccess.text = RESULT_LAST_BEAR_STANDING;
        [self onSaveBearScore];
    } else {
        m_lblSuccess.text = RESULT_END;
    }
    
    [self initLoadRestartView];
}

- (void)onSaveBearScore {
    
    [GlobalData sharedGlobalData].g_userData.score += BEAR_SCORE;
    [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[GlobalData sharedGlobalData].g_currentUser setProperty:KEY_SCORE object:[NSString stringWithFormat:@"%i", [GlobalData sharedGlobalData].g_userData.score]];
        [backendless.userService update:[GlobalData sharedGlobalData].g_currentUser];
    });
}

@end
