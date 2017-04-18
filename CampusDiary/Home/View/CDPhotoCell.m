//
//  CDPhotoCell.m
//  CampusDiary
//
//  Created by Jon on 2017/2/17.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDPhotoCell.h"
#import <UIImageView+WebCache.h>
@interface CDPhotoCell ()

@end
@implementation CDPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CDPhotoModel *)model{
    if (_model == model) {
        return;
    }
    _model = model;
    [self.imageView setImage:(_model.image?_model.image:kImage(@"publish_add_photo"))];
}
- (void)setPhoto:(PhotoInfo *)photo{
    if (_photo == photo) {
        return;
    }
    _photo = photo;
    [self.imageView setImage:[UIImage new]];
    [self.imageView sd_setImageWithURL:_photo.icon.getUrl placeholderImage:kImage(@"home_placeholder")];
}
@end
