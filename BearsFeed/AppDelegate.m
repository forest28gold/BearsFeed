//
//  AppDelegate.m
//  BearsFeed
//
//  Created by AppsCreationTech on 3/16/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AppDelegate.h"
#import "BFMainViewController.h"
#import "BFTabBarViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BFCreatePostViewController.h"

@interface AppDelegate () <IBEPushReceiver>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [GlobalData sharedGlobalData].g_autoFormat = [AutoFormatter getInstance];
    
    [backendless initApp:BACKEND_APP_ID secret:BACKEND_SECRET_KEY version:BACKEND_VERSION_NUM];
    backendless.messagingService.pushReceiver = self;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [GlobalData sharedGlobalData].twitter = nil;
    [GlobalData sharedGlobalData].twitter_bears = nil;
    [GlobalData sharedGlobalData].g_twitterUserID = @"";
    [GlobalData sharedGlobalData].g_toggleTwitterLinkIsOn = false;
    
    [GlobalData sharedGlobalData].g_dBHandler = [DBHandler connectDB];
    sqlite3* dbHandler = [[GlobalData sharedGlobalData].g_dBHandler getDbHandler];
    [GlobalData sharedGlobalData].g_dataModel = [[DataModel alloc] initWithDBHandler:dbHandler];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([GlobalData sharedGlobalData].g_target != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[backendless.persistenceService of:[Target class]] remove:[GlobalData sharedGlobalData].g_target];
        });
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [backendless.messaging applicationWillTerminate];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [backendless.messaging didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    [backendless.messaging didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [backendless.messaging didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    
    [backendless.messaging didReceiveRemoteNotification:userInfo];
    handler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"bearsfeedtwitter"] == YES) {
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
        
        NSString *token = d[@"oauth_token"];
        NSString *verifier = d[@"oauth_verifier"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BFCreatePostViewController *viewPostCtrl = [storyboard instantiateViewControllerWithIdentifier:VIEW_CREATE_POST];
        [viewPostCtrl setOAuthToken:token oauthVerifier:verifier];
        
        return YES;
        
    } else {
        
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        // Add any custom logic here.
        return handled;
    }
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

#pragma mark -
#pragma mark IBEPushReceiver Methods

-(void)didReceiveRemoteNotification:(NSString *)notification headers:(NSDictionary *)headers {
    
}

-(void)didRegisterForRemoteNotificationsWithDeviceId:(NSString *)deviceId fault:(Fault *)fault {
    
    if (fault) {
        NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: (FAULT) %@", fault);
        return;
    }
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: %@", deviceId);
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", err);
}

@end
