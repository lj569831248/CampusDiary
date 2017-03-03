//
//  HUD.h
//  ruhang
//
//  Created by Jon on 2016/11/29.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface HUD : MBProgressHUD
+ (void)show;
+ (void)showText:(NSString *)text;
+ (void)showProgress:(CGFloat)progress;
+ (void)showProgress:(CGFloat)progress text:(NSString *)text;

+ (void)dismiss;
+ (void)dismissAfterDelay:(NSTimeInterval)delay;
@end
