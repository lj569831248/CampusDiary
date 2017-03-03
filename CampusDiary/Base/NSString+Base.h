//
//  NSString+Base.h
//  Inker
//
//  Created by Jon on 2016/12/15.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Base)


//UIColor转16进制
+ (NSString *) ColorToHex:(UIColor *)color;

#pragma mark Base64
+ (NSString *)base64EncodedWithString:(NSString *)orginString;
+ (NSString *)base64DecodedWithString:(NSString *)encodeString;

#pragma mark MD5相关

/**
 获取文件 MD5
 @param path 文件 FilePath
 @return  文件 MD5
 */
+ (NSString*)getFileMD5WithPath:(NSString*)path;

/**
 获取字符串 MD5
 @param string 字符串
 @return 字符串 MD5
 */
+ (NSString *)md5WithString:(NSString *)string;

#pragma mark 正则相关
+ (BOOL)checkMatch:(NSString *)string regex:(NSString *)regex;

// 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
// 正则匹配用户密码6-16位数字或字母组合
+ (BOOL)checkPassword:(NSString *) password;
//  正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *) userName;
// 正则匹配用户身份证号
+ (BOOL)checkIdCard:(NSString *) idCard;
// 正则匹配URL
+ (BOOL)checkURL:(NSString *) url;
// 匹配 Email
+ (BOOL)checkEmail:(NSString *)email;

// 验证码
+ (BOOL)checkVerificationCode:(NSString *)verificationCode;


- (BOOL)isMatchRegex:(NSString *)regex;

// 正则匹配手机号
- (BOOL)isTelNumber;
// 正则匹配用户密码6-16位数字或字母组合
- (BOOL)isPassword;
//  正则匹配用户姓名,20位的中文或英文
- (BOOL)isUserName;
// 正则匹配用户身份证号
- (BOOL)isIdCard;
// 正则匹配URL
- (BOOL)isURL;

//4位数字验证码
- (BOOL)isVerificationCode;
- (BOOL)isEmail;


+ (NSString *)dictToJsonStr:(NSDictionary *)dict;

@end
