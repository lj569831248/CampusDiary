//
//  UICollectionViewCell+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UICollectionViewCell+Base.h"

@implementation UICollectionViewCell (Base)
+ (UINib *)nib{
    
    return [UINib nibWithNibName:[self cellReuseIdentifier] bundle:nil];
}
+ (NSString *)cellReuseIdentifier{
    
    return [[self class] description];
}
@end
