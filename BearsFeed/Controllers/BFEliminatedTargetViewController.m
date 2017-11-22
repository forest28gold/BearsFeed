//
//  BFEliminatedTargetViewController.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "BFEliminatedTargetViewController.h"
#import "BubbleAnimationView.h"

@interface BFEliminatedTargetViewController () <IBEPushReceiver>

@property (nonatomic, strong) BubbleAnimationView *bubbleAnimationView;

@end

@implementation BFEliminatedTargetViewController

@synthesize m_view, m_activity;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    backendless.messagingService.pushReceiver = self;
    [GlobalData sharedGlobalData].g_ctrlEliminatedTarget = self;
    m_activity.hidden = YES;
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];

    if ([GlobalData sharedGlobalData].g_arrayTarget.count > 0) {
        [self addBubbleAnimationView];
    } else {
        m_activity.hidden = NO;
        [self onLoadTargetData];
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

- (void)onLoadTargetData {
    
    dispatch_async(dispatch_get_main_queue(), ^{

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
//                    [[GlobalData sharedGlobalData].g_arrayTarget addObject:target];
                }
                
                if ([GlobalData sharedGlobalData].g_arrayTarget.count > 0) {
                    m_activity.hidden = YES;
                    [self addBubbleAnimationView];
                } else {
                    [self onLoadTargetData];
                }
            } else {
                [self onLoadTargetData];
            }
        } error:^(Fault *fault) {
            [self onLoadTargetData];
        }];
    
    });
}

#pragma mark -
#pragma mark IBEPushReceiver Methods

-(void)didReceiveRemoteNotification:(NSString *)notification headers:(NSDictionary *)headers {
    
    if ([notification isEqualToString:ALERT_ELIMINATED]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[backendless.persistenceService of:[Target class]] remove:[GlobalData sharedGlobalData].g_target];
        });
        
        [GlobalData sharedGlobalData].g_strLastBearStanding = BEARS_ELIMINATED;
        
        [self performSegueWithIdentifier:UNWIND_BEAR_STANDING sender:nil];
    }
}

- (IBAction)onBack:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[backendless.persistenceService of:[Target class]] remove:[GlobalData sharedGlobalData].g_target];
    });
    
    [GlobalData sharedGlobalData].g_strLastBearStanding = BEARS_END;
    
    [self performSegueWithIdentifier:UNWIND_BEAR_STANDING sender:nil];
}

- (void)addBubbleAnimationView
{
    [self.bubbleAnimationView removeFromSuperview];
    self.bubbleAnimationView = nil;
    
    self.bubbleAnimationView = [[BubbleAnimationView alloc] initWithFrame:self.m_view.frame];
    [self.m_view addSubview:self.bubbleAnimationView];
    [self.bubbleAnimationView animateBuubleViews];
}

- (void)onEliminateLastTarget {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *targetDeviceId = [[GlobalData sharedGlobalData].g_targetUser.targetUser getProperty:KEY_DEVICE_ID];
        
        [[backendless.persistenceService of:[Target class]] remove:[GlobalData sharedGlobalData].g_targetUser response:^(id response) {
            NSLog(@"removed eliminated target");
            
            [GlobalData sharedGlobalData].g_strLastBearStanding = BEARS_LAST;
            [self performSegueWithIdentifier:UNWIND_BEAR_STANDING sender:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                
                [deviceIDArray addObject:targetDeviceId];
                
                PublishOptions *options = [PublishOptions new];
                options.headers = @{@"ios-alert":ALERT_ELIMINATED,
                                    @"ios-badge":PUSH_BADGE,
                                    @"ios-sound":PUSH_SOUND,
                                    @"android-ticker-text":PUSH_TITLE,
                                    @"android-content-title":PUSH_TITLE,
                                    @"android-content-text":ALERT_ELIMINATED};
                
                
                DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                deliveryOptions.pushSinglecast = deviceIDArray;
                
                [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_ELIMINATED publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                    NSLog(@"showMessageStatus: %@", res.status);
                } error:^(Fault *fault) {
                    NSLog(@"sendMessage: fault = %@", fault);
                }];
            });
            
        } error:^(Fault *fault) {
            NSLog(@"Failed remove eliminated target, = %@ <%@>", fault.message, fault.detail);
        }];
    });
}

- (void)onEliminateTarget {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *targetDeviceId = [[GlobalData sharedGlobalData].g_targetUser.targetUser getProperty:KEY_DEVICE_ID];
        
        [[backendless.persistenceService of:[Target class]] remove:[GlobalData sharedGlobalData].g_targetUser response:^(id response) {
            NSLog(@"removed eliminated target");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                
                [deviceIDArray addObject:targetDeviceId];
                
                PublishOptions *options = [PublishOptions new];
                options.headers = @{@"ios-alert":ALERT_ELIMINATED,
                                    @"ios-badge":PUSH_BADGE,
                                    @"ios-sound":PUSH_SOUND,
                                    @"android-ticker-text":PUSH_TITLE,
                                    @"android-content-title":PUSH_TITLE,
                                    @"android-content-text":ALERT_ELIMINATED};
                
                DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                deliveryOptions.pushSinglecast = deviceIDArray;
                
                [backendless.messagingService publish:MESSAGING_CHANNEL message:ALERT_ELIMINATED publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                    NSLog(@"showMessageStatus: %@", res.status);
                } error:^(Fault *fault) {
                    NSLog(@"sendMessage: fault = %@", fault);
                }];
            });
            
        } error:^(Fault *fault) {
            NSLog(@"Failed remove eliminated target, = %@ <%@>", fault.message, fault.detail);
        }];
    });
}

@end
