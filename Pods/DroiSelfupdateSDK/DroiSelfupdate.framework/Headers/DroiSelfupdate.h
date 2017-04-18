//
//  DroiSelfupdate.h
//  DroiSelfupdateSDK
//
//  Created by Jon on 2016/10/27.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DroiSelfupdate : NSObject


/**
 根据 APPID 检测更新
 @param appId             这里的APPID是是app在appStore的ID
 @param useDefaultUI      是否使用默认UI，默认UI下，有更新会弹出Alert提示用户，用户点击更新按钮会跳转对应的app在appStore中下载页，如果不适用默认UI，需要开发者自己在completionHandler中做判断，跳转appStore的工作
 @param completionHandler 检测完成之后回调 其中 result 为结果updateInfo 为更新的相关信息
 */
+ (void)checkUpdateWithAppID:(NSString *)appId
                useDefaultUI:(BOOL)useDefaultUI
       withCompletionHandler:(void(^)(BOOL result, NSDictionary *updateInfo))completionHandler;

/**
 根据 APPID 检测更新
 @param appId             这里的APPID是是app在appstore的ID
 @param checkUrl          appstore检测更新的url，填入nil将使用默认的url
 @param homeUrl           appstore首页url，填入nil将使用默认的url
 @param useDefaultUI      是否使用默认UI，默认UI下，有更新会弹出Alert提示用户，用户点击更新按钮会跳转对应的app在appStore中下载页，如果不适用默认UI，需要开发者自己在completionHandler中做判断，跳转appStore的工作
 @param completionHandler 检测完成之后回调 其中 result 为结果updateInfo 为更新的相关信息
 */
+ (void)checkUpdateWithAppID:(NSString *)appId
              checkUpdateUrl:(NSString *)checkUrl
                     homeUrl:(NSString *)homeUrl
                useDefaultUI:(BOOL)useDefaultUI
       withCompletionHandler:(void(^)(BOOL result, NSDictionary *updateInfo))completionHandler;

/**
 根据 APPID 检测更新 使用默认UI
 @param appId             这里的APPID是是app在appstore的ID
 @param checkUrl          appstore检测更新的url，填入nil将使用默认的url
 @param homeUrl           appstore首页url，填入nil将使用默认的url
 @param title             默认提示框标题
 @param cancelTitle       取消按钮标题
 @param otherTitle        其他按钮标题
 @param completionHandler 检测完成之后回调 其中 result 为结果updateInfo 为更新的相关信息
 */
+ (void)checkUpdateWithAppID:(NSString *)appId
              checkUpdateUrl:(NSString *)checkUrl
                     homeUrl:(NSString *)homeUrl
                       title:(NSString *)title
           cancelButtonTitle:(NSString *)cancelTitle
            otherButtonTitle:(NSString *)otherTitle
       withCompletionHandler:(void(^)(BOOL result, NSDictionary *updateInfo))completionHandler;

/**
 获取SDK版本号
 @return SDK版本号
 */
+ (NSString *)getSDKVersion;

/**
 SDK Log开关，默认为YES，设置为NO表示关闭Log
 */
+ (void)setLogEnabled:(BOOL)enabled;

/**
 检测应用内更新文件
 @param fileName          文件名
 @param fileVersion       文件版本号 需开发者做好版本控制
 @param completionHandler 检测完成后回调 result 为结果，fileUrl 为文件url地址
 */
+ (void)inappUpdateWithFileName:(NSString *)fileName
                    fileVersion:(int)fileVersion
          withCompletionHandler:(void(^)(BOOL result, NSString *fileUrl))completionHandler;


@end
