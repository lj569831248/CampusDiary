//
//  UITableView+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UITableView+Base.h"

@implementation UITableView (Base)

- (void)registerCellWithClass:(Class)cellClass{
    
    [self registerNib:[UINib nibWithNibName:[cellClass description] bundle:nil] forCellReuseIdentifier:[cellClass description]];
}

@end
