//
//  FavorItem.h
//  CampusDiary
//
//  Created by Jon on 2017/5/10.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>
#import "User.h"
@interface FavorItem : DroiObject
DroiExpose
@property (copy, nonatomic)NSString *circleId;
DroiReference
@property (strong, nonatomic)User *user;
@end
