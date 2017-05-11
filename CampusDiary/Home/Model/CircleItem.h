//
//  CircleItem.h
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <DroiCoreSDK/DroiCoreSDK.h>
#import "User.h"
#import "CommentItem.h"
#import "FavorItem.h"
@interface CircleItem : DroiObject

DroiExpose
@property (copy, nonatomic)NSString *content;
DroiExpose
@property (assign, nonatomic)NSInteger type;
DroiExpose
@property (strong, nonatomic)NSArray *photos;
DroiReference
@property (nonatomic , strong) User *user;

DroiExpose
@property (strong, nonatomic)NSArray <CommentItem *> *commentList;
DroiExpose
@property (strong, nonatomic)NSArray <FavorItem *> *favorList;
DroiExpose
@property (assign, nonatomic)NSInteger favorCount;
@end
