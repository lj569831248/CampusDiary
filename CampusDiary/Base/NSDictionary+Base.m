//
//  NSDictionary+Base.m
//  Inker
//
//  Created by Jon on 2016/12/7.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "NSDictionary+Base.h"

@implementation NSDictionary (Base)

- (NSString *)descriptionWithNO_UTF8
{
    // 1.定义一个可变的字符串, 保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\n"];
    // 2.迭代字典中所有的key/value, 将这些值拼接到字符串中
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    [strM appendString:@"}"];
    
    // 删除最后一个逗号
    if (self.allKeys.count > 0) {
        NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
        [strM deleteCharactersInRange:range];
    }
    // 3.返回拼接好的字符串
    return strM;
}

- (void)descriptionWithModelStyle
{
    NSMutableString *strM = [NSMutableString string];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //  NSLog(@"%@,%@",key,[obj class]);
        
        NSString *className = NSStringFromClass([obj class]) ;
        
        if ([className isEqualToString:@"__NSCFString"] | [className isEqualToString:@"__NSCFConstantString"] | [className isEqualToString:@"NSTaggedPointerString"]) {
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\\\\n",key];
        }else if ([className isEqualToString:@"__NSCFArray"] |
                  [className isEqualToString:@"__NSArray0"] |
                  [className isEqualToString:@"__NSArrayI"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSArray *%@;\\\\n",key];
        }else if ([className isEqualToString:@"__NSCFDictionary"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSDictionary *%@;\\\\n",key];
        }else if ([className isEqualToString:@"__NSCFNumber"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSNumber *%@;\\\\n",key];
        }else if ([className isEqualToString:@"__NSCFBoolean"]){
            [strM appendFormat:@"@property (nonatomic, assign) BOOL   %@;\\\\n",key];
        }else if ([className isEqualToString:@"NSDecimalNumber"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\\\\n",[NSString stringWithFormat:@"%@",key]];
        }
        else if ([className isEqualToString:@"NSNull"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\\\\n",[NSString stringWithFormat:@"%@",key]];
        }else if ([className isEqualToString:@"__NSArrayM"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSMutableArray *%@;\\\\n",[NSString stringWithFormat:@"%@",key]];
        }
        
    }];
    NSLog(@"\\\\n\\\\n%@\\\\n",strM);
}
@end
