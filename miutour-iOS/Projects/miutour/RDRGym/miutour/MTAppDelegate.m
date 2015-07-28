
//
//  MTAppDelegate.m
//  miutour
//
//  Created by Dong on 12/20/14.
//  Copyright (c) 2014 Dong. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTNavigationController.h"
#import "ThemeManager.h"
#import "MTHomeViewController.h"
#import "MTLoginViewController.h"
#import "CDVPlugin.h"
#import "TalkingData.h"
#import "APService.h"
#import "MTBlockOrderDetailViewController.h"
#import "MTPickupOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"
#import "MTGroupOrderDetailViewController.h"
#import "MTMessageDetailViewController.h"
#import "HideUpperDataSource.h"

@interface MTAppDelegate ()

@property (nonatomic,strong) MTNavigationController* navigationController;

@end

/*
 "type类型：
 1：已接订单包车
 2：已接订单接送机
 3：已接订单拼车
 4：已接订单组合
 5：未接订单包车
 6：未接订单接送机
 7：未接订单拼车
 8：未接订单组合
 9：消息"
 */

typedef enum {
    TAKEN_BLOCK = 1,
    TAKEN_PICKUP = 2,
    TAKEN_SPLICE = 3,
    TAKEN_GROUP = 4,
    SUPPLY_BLOCK = 5,
    SUPPLY_PICKUP = 6,
    SUPPLY_SPLICE = 7,
    SUPPLY_GROUP = 8,
    MESSAGE = 9,
    ACTIVITY = 10,
    NEWS = 11,

} PushType;

@implementation MTAppDelegate

- (id)init
{
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
    NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
    NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
    [NSURLCache setSharedURLCache:sharedCache];
    
    self = [super init];
    
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(pushToRootVC) name:@"EMEUserNotificationNameForLogout" object:nil];

    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化应用，appKey和appSecret从后台申请得到
    
    [_window makeKeyAndVisible];
    
    [[ThemeManager shareInstance] registerThemeWithConfigName:nil
                                             forViewContrller:nil];
    
    _navigationController = nil;

    [[UserManager shareInstance] init_singleton_from_disk];

    
    if ([UserManager shareInstance].user.loginName == nil) {
        MTLoginViewController *loginVC = [[MTLoginViewController alloc] init];
        _navigationController = [[MTNavigationController alloc] initWithRootViewController:loginVC];
    }
    else
    {
        MTHomeViewController *homeVC = [[MTHomeViewController alloc] init];
        homeVC.dataSource = [[HideUpperDataSource alloc] init];

        homeVC.isFirst = YES;
        _navigationController = [[MTNavigationController alloc] initWithRootViewController:homeVC];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = _navigationController;

    [TalkingData sessionStarted:@"C946A3FA5A77538B1E0FA84E6CD127E8" withChannelId:@"TalkingData"];
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)setHomeViewControllerToRoot
{
    MTHomeViewController *homeVC = [[MTHomeViewController alloc] init];
    homeVC.dataSource = [[HideUpperDataSource alloc] init];
    homeVC.isFirst = NO;
    MTNavigationController *navigationController = [[MTNavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navigationController;
}

- (void)setLoginViewControllerToRoot
{
    MTLoginViewController *loginVC = [[MTLoginViewController alloc] init];
    MTNavigationController *navigationController = [[MTNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EMEUserNotificationNameForResign" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if HelloCordova-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if (!url) {
        return NO;
    }
    
    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
    
    return YES;
}

// repost all remote and local notification using the default NSNotificationCenter so multiple plugins may respond
- (void)            application:(UIApplication*)application
    didReceiveLocalNotification:(UILocalNotification*)notification
{
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVLocalNotification object:notification];
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NIF_DEBUG(@"%@",[NSString stringWithFormat:@"%@", deviceToken]);
//    rootViewController.deviceTokenValueLabel.text =
//    [NSString stringWithFormat:@"%@", deviceToken];
//    rootViewController.deviceTokenValueLabel.textColor =
//    [UIColor colorWithRed:0.0 / 255
//                    green:122.0 / 255
//                     blue:255.0 / 255
//                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSString *theID = [NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"id"]];
    switch ([[userInfo valueForKeyPath:@"type"] intValue]) {
        case TAKEN_BLOCK:
        {
            MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
            vc.isTaken = YES;
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case TAKEN_PICKUP:
        {
            MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
            vc.isTaken = YES;
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case TAKEN_SPLICE:
        {
            MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
            vc.isTaken = YES;
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case TAKEN_GROUP:
        {
            MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
            vc.isTaken = YES;
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case SUPPLY_BLOCK:
        {
            MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case SUPPLY_PICKUP:
        {
            MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case SUPPLY_SPLICE:
        {
            MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case SUPPLY_GROUP:
        {
            MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
            if (![CommonUtils isEmptyString:theID]) {
                vc.orderId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case MESSAGE:
        {
            MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
            vc.title = @"消息详情";
            if (![CommonUtils isEmptyString:theID]) {
                vc.messageId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case ACTIVITY:
        {
            MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
            vc.title = @"活动详情";
            if (![CommonUtils isEmptyString:theID]) {
                vc.messageId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case NEWS:
        {
            NSLog(@"新闻详情");
            MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
            vc.title = @"新闻详情";
            if (![CommonUtils isEmptyString:theID]) {
                vc.messageId = theID;
                [_navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(void)pushToRootVC
{
    [[UserManager shareInstance] clear_all_data];
    [_navigationController popToRootViewControllerAnimated:YES];
    MTLoginViewController *loginVC = [[MTLoginViewController alloc] init];
    _navigationController = [[MTNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = _navigationController;
}

-(void)pushToWebView
{

}



- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
