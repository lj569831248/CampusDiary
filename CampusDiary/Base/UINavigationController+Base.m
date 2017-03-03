//
//  UINavigationController+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UINavigationController+Base.h"
#import "NSObject+Base.h"

@implementation UINavigationController (Base)

//+ (void)load{
//    NSLog(@"%@ Load",[self class]);
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        SEL originalSelectorPush = @selector(pushViewController:animated:);
//        SEL swizzledSelectorPush = @selector(my_pushViewController:animated:);
//        [self replaceMethod:class originalSelector:originalSelectorPush swizzledSelector:swizzledSelectorPush];
//    });
//}


- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
}

- (void)pushViewControllerAndHideBottomBar:(UIViewController *)viewController{
    
    viewController.hidesBottomBarWhenPushed = YES;
    [self pushViewController:viewController animated:YES];
}

@end
