//
//  CommentItem.h
//  CampusDiary
//
//  Created by Jon on 2017/2/22.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>
#import "User.h"
@interface CommentItem : DroiObject

DroiExpose
@property (copy, nonatomic)NSString *content;
DroiExpose
@property (copy, nonatomic)NSString *circleId;
DroiReference
@property (nonatomic , strong) User *user;
DroiReference
@property (nonatomic , strong) User *toReplyUser;
@end
