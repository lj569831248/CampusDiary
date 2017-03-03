//
//  NSDate+Base.h
//  ruhang
//
//  Created by Jon on 2016/12/1.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Base)
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

- (NSString *)getLocalDateString;

@end
