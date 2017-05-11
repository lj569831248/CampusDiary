//
//  CDPhotoCell.h
//  CampusDiary
//
//  Created by Jon on 2017/2/17.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DroiCoreSDK/DroiCoreSDK.h>
#import "CDPhotoModel.h"
@interface CDPhotoCell : UICollectionViewCell
@property (nonatomic , strong) CDPhotoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic , strong) DroiFile *photo;

@end
