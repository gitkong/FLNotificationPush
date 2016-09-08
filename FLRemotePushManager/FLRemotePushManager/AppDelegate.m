//
//  AppDelegate.m
//  FLRemotePushManager
//
//  Created by clarence on 16/9/9.
//  Copyright © 2016年 clarence. All rights reserved.
//

#import "AppDelegate.h"
#import "FLRemotePushManager.h"
#import "FLSecondVcRemoteModel.h"
#import "FLThirdVcRemoteModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushSecond];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pushThird];
        });
    });
    return YES;
}

- (void)pushSecond
{
    // 跟服务端沟通好跳转对应的界面需要对应的参数以及格式
    NSDictionary *userInfo = @{
                               @"className": @"SecondViewController",
                               @"id": @"12",
                               @"content": @"测试推送内容消息"
                               };
    
    [[FLRemotePushManager fl_shareInstance] fl_pushWithRemotePushModel:[FLSecondVcRemoteModel fl_remotePushModel:userInfo]];
}

- (void)pushThird{
    NSDictionary *userInfo = @{
                               @"className": @"ThirdViewController",
                               @"msg"      : @{
                                    @"name": @"clarence",
                                     @"age": @12
                                             }
                               };
    
    [[FLRemotePushManager fl_shareInstance] fl_pushWithRemotePushModel:[FLThirdVcRemoteModel fl_remotePushModel:userInfo]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
