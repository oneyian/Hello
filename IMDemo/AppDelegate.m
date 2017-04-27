//
//  AppDelegate.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadViewController.h"
#import "HomeViewController.h"
#import <UMSocialCore/UMSocialCore.h>

//APP ID 1106000167
//APP KEY CP1aABluTdHSVA3R

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:0.66];//设置启动页面时间
    //分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5901608f04e2050c8a0015bb"];
    [self setAppKey];
    _mcManager=[[MCManager alloc]init];
    
    _window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"]==NULL
        ||[[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isEqualToString:@""]) {
        LoadViewController *Load=[LoadViewController new];
        [_window setRootViewController:Load];
    }else{
        HomeViewController *Home=[HomeViewController new];
        [_window setRootViewController:Home];
    }
    return YES;
}
-(void)setAppKey{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106000167"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark ##### 表情Plist文件 #####
//NSString *DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//DocumentPath =[DocumentPath stringByAppendingPathComponent:@"emoji.plist"];
//NSMutableArray *emojiArray=[NSMutableArray new];
//
//
//for (int i=1; i<=184; i++) {
//    if (i<10) {
//        NSMutableDictionary *emojiDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"[00%d]",i],@"cht",[NSString stringWithFormat:@"00%d",i],@"png", nil];
//        [emojiArray addObject:emojiDict];
//    }else if (i<100){
//        NSMutableDictionary *emojiDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"[0%d]",i],@"cht",[NSString stringWithFormat:@"0%d",i],@"png", nil];
//        [emojiArray addObject:emojiDict];
//    }
//    else if (i>120 && i<143){ }
//    else{
//        NSMutableDictionary *emojiDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"[%d]",i],@"cht",[NSString stringWithFormat:@"%d",i],@"png", nil];
//        [emojiArray addObject:emojiDict];
//    }
//}
//[emojiArray writeToFile:DocumentPath atomically:YES];
//NSLog(@"%@",DocumentPath);

@end
