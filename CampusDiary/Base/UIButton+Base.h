//
//  UIButton+Base.h
//  ruhang
//
//  Created by Jon on 2016/12/3.
//  Copyright © 2016年 Droi. All rights reserved.
//

// 添加计时器 防止连点

#import <UIKit/UIKit.h>

@interface UIButton (Base)
@property (nonatomic, assign) NSTimeInterval timeInterval;

//为不同状态 设置背景色 （但是之后不能设置背景图片）
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
