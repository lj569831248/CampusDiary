//
//  MyBaseModel.h
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBaseModel : NSObject<NSCoding>
//model转字典
- (NSDictionary *)dictionaryFromModel;

@end
