//
//  CDHomeTableHeaderView.m
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import "CDHomeTableHeaderView.h"
#import "CDPhotoCell.h"
#import "NSDate+Base.h"
@interface CDHomeTableHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@end
@implementation CDHomeTableHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    NSLog(@"awakeFromNib");
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (IBAction)comment:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:didCheckCommentButton:)]) {
        [self.delegate tableHeaderView:self didCheckCommentButton:sender];
    }
}

- (void)setup{
    [self.collectionView registerCellWithClass:[CDPhotoCell class]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = self.flowLayout;
}

- (void)setModel:(CircleItem *)model{
    if (_model == model) {
        return;
    }
    _model = model;
    self.contentLabel.text = _model.content;
    self.userNickNameLabel.text = _model.user.displayName;
    self.createTimeLabel.text =[_model.creationTime getLocalDateString];
    self.flowLayout.itemSize = [CDHomeTableHeaderView colletionItmeSize];
    [self.iconImageView sd_setImageWithURL:_model.user.headIcon.getUrl placeholderImage:kImage(@"my_userIcon")];
    [self.collectionView reloadData];
}


#pragma mark dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.photos.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DroiReferenceObject * photo = self.model.photos[indexPath.item];
    CDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CDPhotoCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.photo = photo.droiObject;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CDPhotoCell *cell = (CDPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView showImage:cell.imageView];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}

+ (CGSize)colletionItmeSize{
    CGFloat colletcViewWidth = kScreenWidth - 8.0 - 40.0 - 8.0 - 8.0;
    CGFloat width = (colletcViewWidth - 8.0 * 2) / 3;
    return CGSizeMake(width, width);
}


@end
