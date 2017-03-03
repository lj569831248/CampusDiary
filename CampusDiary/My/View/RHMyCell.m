//
//  RHMyCell.m
//  ruhang
//
//  Created by Jon on 2016/11/24.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "RHMyCell.h"

@interface RHMyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation RHMyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(CDMyModel *)model{
    
    if (_model == model) {
        return;
    }
    _model = model;
    self.smallImageView.image = [UIImage imageNamed:_model.image];
    self.titleLabel.text = _model.title;
}


@end
