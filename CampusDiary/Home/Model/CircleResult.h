//
//  CircleResult.h
//  CampusDiary
//
//  Created by Jon on 2017/5/10.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>
#import "CircleItem.h"
@interface CircleResult : DroiObject
DroiExpose
@property (strong, nonatomic)NSArray <CircleItem *> *data;
DroiExpose
@property (assign, nonatomic)NSInteger code;
DroiExpose
@property (copy, nonatomic)NSString *desc;
@end
