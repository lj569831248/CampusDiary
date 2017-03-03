//
//  NSDictionary+Base.h
//  Inker
//
//  Created by Jon on 2016/12/7.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Base)

//中文字符使用 UTF8 
- (NSString *)descriptionWithNO_UTF8;

//将字典打印为 model 的属性格式可以直接复制粘贴 Model 的属性
- (void)descriptionWithModelStyle;

@end
