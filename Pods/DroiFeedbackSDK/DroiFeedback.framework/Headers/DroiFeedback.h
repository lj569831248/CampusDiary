//
//  DroiFeedback.h
//  DroiFeedbackDemo
//
//  Created by Jon on 16/6/27.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DroiFeedback : NSObject

/**
 调用默认反馈页面
 @param viewController 需要调用反馈页面的ViewController
 */
+ (void)callFeedbackWithViewController:(UIViewController *)viewController;

/**
 设置UserId
 @param userId 填入自定义的UserId 如果使用了DroiUser账号体系,则不需要填写,默认为已登录账号的UserId
 */
+ (void)setUserId:(NSString *)userId;

/**
 设置色调
 */
+ (void)setColor:(UIColor *)color;

/**
 获取当前的UserId
 */
+ (NSString *)getCurrentUserId;

/**
 请求已反馈的内容
 */
+ (void)requestToGetFeedback:(void(^)(BOOL result,id data))callback;

/**
 上传新的反馈
 @param feedbackString 反馈内容
 @param contact        联系方式
 */
+ (void)requestToSummitFeedback:(NSString *)feedbackString contact:(NSString *)contact callback:(void(^)(BOOL result))callback;

/**
 获取 SDK 版本号
 */
+ (NSString *)getVersion;
@end
