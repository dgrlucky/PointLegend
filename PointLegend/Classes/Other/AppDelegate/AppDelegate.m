//
//  AppDelegate.m
//  PointLegend
//
//  Created by leon guo on 15/9/7.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "PLNewFeatureViewController.h"
#import "PLJPushTools.h"
#import "UIAlertView+Block.h"
#import "SYSafeCategory.h"
#import "WXApi.h"

@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

+ (void)load
{
    [[UINavigationBar appearance] setBarTintColor:RGB(246, 246, 248)];
    [[UINavigationBar appearance] setTintColor:RGB(112, 112, 112)];
    
    //设置导航栏字体及颜色
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    //去除title的阴影
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont boldSystemFontOfSize:17], NSFontAttributeName,
                                              RGB(68, 69, 71), NSForegroundColorAttributeName,
                                              shadow, NSShadowAttributeName,
                                              nil]];
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:5];
    
    //友盟分享
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:FilePathInBundle(@"UMengConfig.plist")];
//    [UMSocialData setAppKey:dic[@"UMeng"]];
    //横屏
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
//    [UMSocialWechatHandler setWXAppId:@"wx79b509c86613deb0" appSecret:nil url:@"http://www.baidu.com"];
    if (![WXApi registerApp:@"wx79b509c86613deb0" withDescription:@"weixin"]) {
        NSLog(@"注册微信分享失败！");
    }
    
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
//    [UMSocialQQHandler setQQWithAppId:@"1104640160" appKey:nil url:@"http://www.baidu.com"];
    
    [SYSafeCategory callSafeCategory];
    
//    [[CrashReporter sharedInstance] enableLog:YES];
    [[CrashReporter sharedInstance] installWithAppId:[NSDictionary dictionaryWithContentsOfFile:FilePathInBundle(@"BuglyConfig.plist")][@"AppID"]];
    
    //第三方键盘
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].canAdjustTextView = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 60;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    NSString *key = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BaiduMapConfig" ofType:@"plist"]][@"key"];
    BOOL ret = [_mapManager start:key  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
    
    //CoreData
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"1dcq.sqlite"];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    PLNewFeatureViewController *newFeatureVC=[[PLNewFeatureViewController alloc]init];
    
    
    [PLJPushTools setupWithOptions:launchOptions];
    
    [self checkNetworkStatus];
    
    
    /*
    PLTabbarController *tabbarVC = [[PLTabbarController alloc] initWithInfoArray:@[
                                                                                   @{@"title":@"首页",@"class":@"PLHomeViewController",@"imageName":@"grey_home",@"selectedImageName":@"red_home",@"itemUrl":@"",@"selectedItemUrl":@""},
                                                                                   @{@"title":@"奖励",@"class":@"PLRewardViewController",@"imageName":@"grey_reward",@"selectedImageName":@"red_reward",@"itemUrl":@"",@"selectedItemUrl":@""},
                                                                                   @{@"title":@"我的",@"class":@"PLMineViewController",@"imageName":@"grey_my",@"selectedImageName":@"red_my",@"itemUrl":@"",@"selectedItemUrl":@""}]];
   */
    
    _tabbar = [[PLTabbarController alloc] init];
    //    判断应用是否第一次登陆
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _window.rootViewController=newFeatureVC;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _window.rootViewController = _tabbar;
    }

//    _window.rootViewController = tabbarVC;
    
    return YES;
}
#pragma Mark 极光推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [PLJPushTools registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PLJPushTools handleRemoteNotification:userInfo completion:nil];
    return;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [PLJPushTools showLocalNotificationAtFront:notification];
    return;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error is %@",error);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    
//    [[[PLLocationMgr sharedInstance] locationManager] setDelegate:[PLLocationMgr sharedInstance]];
//    
//    [[[PLLocationMgr sharedInstance] locationManager] startUpdatingLocation];
    
    return;
}

#pragma end

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[[PLLocationMgr sharedInstance] locationManager] stopUpdatingLocation];
    
    [[[PLLocationMgr sharedInstance] locationManager] setDelegate:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//    return  [UMSocialSnsService handleOpenURL:url];
    UIViewController *vc = ((UINavigationController *)((UITabBarController *)self.window.rootViewController).viewControllers[1]).viewControllers[1];
    
    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        }];
        
    }else if([url.absoluteString rangeOfString:@"wechat"].location != NSNotFound){
        return [WXApi handleOpenURL:url delegate:[vc isKindOfClass:[NSClassFromString(@"PLInvitViewController") class]]?vc:nil];
    }
    else if([url.absoluteString rangeOfString:@"mqqapi"].location != NSNotFound){
        if (vc && [vc respondsToSelector:@selector(handleQQResponse:)]) {
            [vc performSelector:@selector(handleQQResponse:) withObject:url.absoluteString];
        }
    }
    
    return YES;
}

- (void)checkNetworkStatus
{    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSString *text = nil;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
            case AFNetworkReachabilityStatusNotReachable:{
                text = @"网络异常！";
                [SVProgressHUD showInfoWithStatus:text];
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                text = @"网络通过WIFI连接！";
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                text = @"网络通过WWAN连接！";
                break;
            }
            default:
                break;
        }
        
        NSLog(@"%@", AFStringFromNetworkReachabilityStatus(status));
    }];
}

@end
