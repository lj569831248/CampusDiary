//
//  CDHomeTableViewCell.m
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDHomeTableViewCell.h"

@interface CDHomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
@implementation CDHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CommentItem *)model{
    if (_model == model) {
        return;
    }
    _model = model;
    if (_model.content == nil) {
        self.commentLabel.text = @"拉取评论失败！";
    }else{
        if (_model.toReplyUser) {
            self.commentLabel.text = [NSString stringWithFormat:@"%@回复%@:%@",_model.user.displayName,_model.toReplyUser.displayName,_model.content];
        }else{
            self.commentLabel.text = [NSString stringWithFormat:@"%@:%@",_model.user.displayName,_model.content];
        }
    }
}
@end
