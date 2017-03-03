//
//  UICollectionView+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UICollectionView+Base.h"

@implementation UICollectionView (Base)

- (void)registerCellWithClass:(Class)cellClass{
    
    [self registerNib:[UINib nibWithNibName:[cellClass description] bundle:nil] forCellWithReuseIdentifier:[cellClass description]];
}

@end
