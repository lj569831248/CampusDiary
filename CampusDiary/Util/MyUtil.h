//
//  MyUtil.h
//  PartyMusic
//
//  Created by Jon on 2017/1/10.
//  Copyright © 2017年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtil : NSObject
+ (BOOL)isFirstLaunch;
+ (NSString *)documentsPathWithFileName:(NSString *)fileName;
+ (NSString *)inboxPathWithFileName:(NSString *)fileName;
+ (void)copyResourcetoDocument:(NSArray *)ResourceNames;

@end
