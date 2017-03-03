//
//  UILabel+Base.h
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Base)

+ (CGFloat)heightWithFont:(UIFont *)font String:(NSString *)string Width:(CGFloat)width;
+ (CGFloat)widthWithFont:(UIFont *)font String:(NSString *)string Height:(CGFloat)height;

@end
