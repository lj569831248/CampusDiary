//
//  CDPublishDiaryVC.m
//  CampusDiary
//
//  Created by Jon on 2017/2/16.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDPublishDiaryVC.h"
#import "LJTextField.h"
#import "CDPhotoCell.h"
#import "User.h"
#import "CircleItem.h"

@interface CDPublishDiaryVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet LJTextField *textField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end

@implementation CDPublishDiaryVC

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        CDPhotoModel *model = [[CDPhotoModel alloc] init];
        [_dataSource addObject:model];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupUI{
    
    self.navigationView.backgroundColor = kBaseColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.textField.placeholder = @"想说什么...";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (kScreenWidth - (5 * 10.0)) / 4.0;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerCellWithClass:[CDPhotoCell class]];
    
    //添加手势 点击 collectionView 键盘收起
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.collectionView addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView =NO;
}

#pragma mark dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CDPhotoCell cellReuseIdentifier] forIndexPath:indexPath];
    CDPhotoModel *model = self.dataSource[indexPath.item];
    cell.model = model;
    return cell;
}

#pragma mark delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == (self.dataSource.count - 1)) {
        DLog(@"添加照片");
        [self addPhoto];
    }else{
        CDPhotoCell *cell =(CDPhotoCell *) [collectionView cellForItemAtIndexPath:indexPath];
        DLog(@"显示照片");
        [UIView showImage:cell.imageView];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CDPhotoModel *model = [[CDPhotoModel alloc] init];
    model.image =image;
    [self.dataSource insertObject:model atIndex:0];
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}

- (void)addPhoto{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    DLog(@"add");
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)publish:(UIButton *)sender {
    //配置权限
    DroiPermission *permisson = [[DroiPermission alloc] init];
    [permisson setPublicReadPermission:YES];
    [permisson setPublicWritePermission:NO];
    CircleItem *item = [[CircleItem alloc] init];
    item.permission = permisson;
    item.user = [User getCurrentUser];
    item.content = self.textField.text;
    item.type = 2; //保留字段，用来说明日记类型 先默认为2
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (CDPhotoModel *model in self.dataSource) {
        if (model.image) {
            NSData *imageData = UIImageJPEGRepresentation(model.image, 0.2);
             DroiFile *photo= [DroiFile fileWithData:imageData];
//            [photos addObject:photo];
//            因为是数组需要在外层使用 DroiReferenceObject 包装一下
            DroiReferenceObject *ref = [[DroiReferenceObject alloc] init];
            [ref setDroiObject:photo];
            [photos addObject:ref];
        }
    }
    item.photos = photos;
    [HUD show];
    [item saveInBackground:^(BOOL result, DroiError *error) {
        NSString *resultStr = nil;
        if (result) {
            resultStr = @"发表成功";
            [self.navigationController popViewControllerAnimated:YES];
            //通知首页刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:KPublishSuccessNotification object:nil];
        }
        else{
            resultStr = [NSString stringWithFormat:@"发表失败：%@",error.message];
        }
        [HUD showText:kLocalizedString(resultStr)];
        [HUD dismiss];

    }];
}

@end
