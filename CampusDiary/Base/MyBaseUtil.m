//
//  MyBaseUtil.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "MyBaseUtil.h"

#define kIsLaunched @"kIsLaunched"

@implementation MyBaseUtil

+ (BOOL)isFirstLaunch{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isLaunched = [user boolForKey:kIsLaunched];
    if (isLaunched) {
        NSLog(@"不是第一次启动应用!");
        return NO;
    }
    else{
        [user setBool:YES forKey:kIsLaunched];
        [user synchronize];
        NSLog(@"第一次启动应用!");
        return YES;
    }
}

@end
