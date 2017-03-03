//
//  DB.m
//  PartyMusic
//
//  Created by Jon on 2017/1/10.
//  Copyright © 2017年 Droi. All rights reserved.
//

#import "DB.h"
#import "MyUtil.h"
@implementation DB

static DB *standardDataBase = nil;
+ (instancetype)standardDataBase{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //#if TARGET_IPHONE_SIMULATOR
        //        NSString *dbPath = @"/Users/jon/Desktop/DB.db";
        //#else
        //
        NSString *dbPath = [MyUtil documentsPathWithFileName:@"DB.db"];
        //#endif
        //        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"quran_v4" ofType:@"db"];
        standardDataBase = (DB *)[FMDatabase databaseWithPath:dbPath];
    });
    return standardDataBase;
}
@end
