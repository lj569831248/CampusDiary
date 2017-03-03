//
//  UICollectionViewCell+Base.h
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Base)
+ (UINib *)nib;
+ (NSString *)cellReuseIdentifier;
@end
