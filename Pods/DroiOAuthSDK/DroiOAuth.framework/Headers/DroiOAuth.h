//
//  DroiOAuth.h
//  DroiOAuth
//
//  Created by Jon on 16/4/7.
//  Copyright © 2016年 icewind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kDroiOAuthLoginSuccess;

typedef void (^DroiOAuthResultBlock)(id object,NSError *error);

typedef NS_ENUM(NSUInteger, DroiOAuthLanguage) {
    DroiOAuthLanguageZH = 0,
    DroiOAuthLanguageEN
};

typedef NS_OPTIONS(NSUInteger, DroiOAuthScope) {
    DroiOAuthScopeUserInfo        = 1 << 0,
    DroiOAuthScopeUserPhoneNumber = 1 << 1,
    DroiOAuthScopeUserEmail       = 1 << 2
};
@interface DroiOAuth : NSObject


/**登录接口
 *  @param viewController 调用接口的viewController
 *  @param callback       回调Token数据
 */
+ (void)requestTokenWithViewController:(UIViewController *)viewController Callback:(DroiOAuthResultBlock)callback;
/**
 *  获取用户信息接口
 *
 *  @param token    通过登录接口返回的token
 *  @param openId   通过登录接口返回的openId
 *  @param scope    需要获取的数据scope
 *  @param callback 回调用户数据
 */
+ (void)getUserInfoWithToken:(NSString *)token  openId:(NSString *)openId Scope:(DroiOAuthScope)scope Callback:(DroiOAuthResultBlock)callback;

+ (void)getUserInfoWithToken:(NSString *)token  openId:(NSString *)openId Callback:(DroiOAuthResultBlock)callback;

/**
 验证Token有效性
 */
+ (void)checkTokenExpire:(NSString *)token Callback:(DroiOAuthResultBlock)callback;

/**
 设置语言
 */
+ (void)setLanguage:(DroiOAuthLanguage)language;

/**
  Log 开关
 */
+ (void)setLogEnabled:(BOOL)enabled;


/**
 获取SDK 版本号
 */
+ (NSString *)getVersion;


@end
