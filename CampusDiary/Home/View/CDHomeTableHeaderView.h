//
//  CDHomeTableHeaderView.h
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleItem.h"
@class CDHomeTableHeaderView;
@protocol CDHomeTableHeaderViewDelegate <NSObject>

- (void)tableHeaderView:(CDHomeTableHeaderView *)tableHeaderView didCheckCommentButton:(UIButton *)commentButton;

@end
@interface CDHomeTableHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic)id<CDHomeTableHeaderViewDelegate> delegate;
@property (assign, nonatomic)NSInteger section;
@property (nonatomic , strong) CircleItem *model;

@end
