//
//  UIViewController+Base.h
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewController (Base)

- (void)alertViewController:(UIViewController *)viewController;
- (void)dismissAlertViewController;

- (void)my_presentViewController:(UIViewController *)viewController;
- (void)my_dismissViewController;


/**
 确定操作提示框
 @param message 提示内容
 @param callback 点击确定或取消的操作
 */
- (void)alertConfirmWithMessage:(NSString *)message callback:(void(^)(BOOL result))callback;

@end
