//
//  NSObject+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/24.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "NSObject+Base.h"
#import <objc/runtime.h>
@implementation NSObject (Base)

+ (void)replaceMethod:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    class_replaceMethod(class,originalSelector,swizzledIMP,swizzledType);
    class_replaceMethod(class,swizzledSelector,originalIMP,originalType);
}

@end
