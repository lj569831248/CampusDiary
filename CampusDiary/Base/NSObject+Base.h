//
//  NSObject+Base.h
//  ruhang
//
//  Created by Jon on 2016/11/24.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Base)
+ (void)replaceMethod:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
