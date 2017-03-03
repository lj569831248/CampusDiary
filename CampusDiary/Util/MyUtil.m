//
//  MyUtil.m
//  PartyMusic
//
//  Created by Jon on 2017/1/10.
//  Copyright © 2017年 Droi. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil
+ (BOOL)isFirstLaunch{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isLaunched = [user boolForKey:@"kMSLIsLaunched"];
    if (isLaunched) {
        NSLog(@"不是第一次启动应用!");
        return NO;
    }
    else{
        [user setBool:YES forKey:@"kMSLIsLaunched"];
        [user synchronize];
        NSLog(@"第一次启动应用!");
        return YES;
    }
}

+ (void)copyResourcetoDocument:(NSArray *)ResourceNames{
    
    if ([ResourceNames count]) {
        
        for (NSString *fileName in ResourceNames) {
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSString *fileDocPath = [self documentsPathWithFileName:fileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileDocPath]) {
                NSLog(@" %@ 数据已经初始化成功 ！",fileDocPath);
            }
            else{
                NSLog(@" %@ 数据初始化中... ！",fileDocPath);
                if ([fileData writeToFile:fileDocPath atomically:YES]) {
                    NSLog(@" %@ 数据初始化完成！",fileDocPath);
                }
                else{
                    NSLog(@" %@ 数据初始化失败！",fileDocPath);
                }
                
            }
        }
    }
}

+ (NSString *)inboxPathWithFileName:(NSString *)fileName{
    return [self documentsPathWithFileName:[NSString stringWithFormat:@"/Inbox/%@",fileName]];
}
+ (NSString *)documentsPathWithFileName:(NSString *)fileName{
    NSString *documentsPath = [self documentsPath];
    NSString *fileDocPath = [documentsPath stringByAppendingPathComponent:fileName];
    return fileDocPath;
}

- (NSString *)inboxPath{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/Inbox", documentPath];
    return path;
}

+ (NSString *)documentsPath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"documentsPath:%@",path);
    return path;
}

@end
