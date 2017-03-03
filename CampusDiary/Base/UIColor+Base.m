//
//  UIColor+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/24.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UIColor+Base.h"

@implementation UIColor (Base)

- (NSString *)getHexString
{
    NSDictionary *colorDic
    = [self getRGBDictionary];
    int r = [colorDic[@"R"] floatValue] * 255;
    int g = [colorDic[@"G"] floatValue] * 255;
    int b = [colorDic[@"B"] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

- (NSDictionary *)getRGBDictionary
{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @{@"R":@(r),
             @"G":@(g),
             @"B":@(b),
             @"A":@(a)};
}

+ (UIColor *)ColorFromHex:(NSString *)hexStr{
    
    int hex = hexStr.intValue;
    return [UIColor colorWithRed:(((hex & 0xFF0000) >> 16))/255.0 green:(((hex & 0xFF00) >> 8))/255.0 blue:((hex & 0xFF))/255.0 alpha:1.0];
}

@end
