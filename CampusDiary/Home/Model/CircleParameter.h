//
//  CircleParameter.h
//  CampusDiary
//
//  Created by Jon on 2017/5/10.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>

@interface CircleParameter : DroiObject
DroiExpose
@property (assign, nonatomic)NSInteger offset;
DroiExpose
@property (assign, nonatomic)NSInteger limit;
@end
