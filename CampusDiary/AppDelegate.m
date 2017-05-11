//
//  AppDelegate.m
//  CampusDiary
//
//  Created by Jon on 2017/2/15.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "AppDelegate.h"
#import "CDHomeViewController.h"
#import <DroiCoreSDK/DroiCoreSDK.h>
#import "CircleItem.h"
#import "User.h"
#import "CommentItem.h"
#import "CircleParameter.h"
#import "CircleDeleteParameter.h"
#import "CircleResult.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    CDHomeViewController *homeVC = [[CDHomeViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = rootNav;
    [self setupNavgaitionBar];
    [self setupBaaSSDK];
    [self.window makeKeyAndVisible];
      return YES;
}

- (void)setupNavgaitionBar{
    
   [[UINavigationBar appearance] setBarTintColor:kBaseColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //全局隐藏返回按钮Title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)setupBaaSSDK{
//    [DroiLogInternal setLevelPrint:4];
    [DroiCore  initializeCore];
    [DroiObject registerCustomClass:[User class]];
    
    [DroiObject registerCustomClass:[CircleItem class]];
    [DroiObject registerCustomClass:[CommentItem class]];
    [DroiObject registerCustomClass:[CircleParameter class]];
    [DroiObject registerCustomClass:[CircleDeleteParameter class]];
    [DroiObject registerCustomClass:[CircleResult class]];

    DroiPermission *permission = [[DroiPermission alloc] init];
    [permission setPublicReadPermission:YES];
    [DroiPermission setDefaultPermission:permission];
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


@end
