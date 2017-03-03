//
//  DB.h
//  PartyMusic
//
//  Created by Jon on 2017/1/10.
//  Copyright © 2017年 Droi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

#define MYDB [DB standardDataBase]

@interface DB : FMDatabase
+ (instancetype)standardDataBase;

@end
