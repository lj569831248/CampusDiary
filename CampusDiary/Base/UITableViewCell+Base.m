//
//  UITableViewCell+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UITableViewCell+Base.h"

@implementation UITableViewCell (Base)
+ (UINib *)nib{
    
    return [UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil];
}
+ (NSString *)cellReuseIdentifier{
    
    return [[self class] description];
}
@end
