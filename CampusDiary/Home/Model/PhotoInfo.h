//
//  PhotoInfo.h
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>

@interface PhotoInfo : DroiObject
DroiReference
@property (strong, nonatomic)DroiFile *icon;
@end
