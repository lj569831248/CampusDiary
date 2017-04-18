//
//  CDMyIconCell.m
//  CampusDiary
//
//  Created by Jon on 2017/2/28.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "CDMyIconCell.h"

@interface CDMyIconCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@end

@implementation CDMyIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUser:(User *)user{
    _user = user;
    [self.iconImageView sd_setImageWithURL:user.headIcon.getUrl placeholderImage:kImage(@"my_userIcon")];
    self.userIdLabel.text =user.UserId;
}
@end
