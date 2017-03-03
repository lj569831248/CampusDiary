//
//  CircleItem.h
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>
#import "User.h"
@interface CircleItem : DroiObject

DroiExpose
@property (copy, nonatomic)NSString *content;
DroiExpose
@property (copy, nonatomic)NSString *type;
DroiExpose
@property (strong, nonatomic)NSArray *photos;
DroiReference
@property (nonatomic , strong) User *user;

@end
