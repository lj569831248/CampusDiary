//
//  User.h
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>

@interface User : DroiUser
DroiExpose
@property (copy, nonatomic)NSString *nickName;
DroiExpose
@property (copy, nonatomic)NSString *headUrl;
DroiReference
@property (strong, nonatomic)DroiFile *headIcon;

+ (BOOL)currentUserIsLogin;
- (NSString *)displayName;
@end
