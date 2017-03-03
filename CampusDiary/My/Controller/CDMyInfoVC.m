//
//  CDMyInfoVC.m
//  CampusDiary
//
//  Created by Jon on 2017/2/27.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDMyInfoVC.h"
#import "CDMyIconCell.h"
#import "CDMyInfoCell.h"
@interface CDMyInfoVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic , strong) User *user;

@end

@implementation CDMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupUI{
    self.title = @"个人信息";
    self.tableView.tableFooterView =[UIView new];
    [self.tableView registerCellWithClass:[CDMyIconCell class]];
    [self.tableView registerCellWithClass:[CDMyInfoCell class]];
}

- (User *)user{
    if (_user == nil) {
        _user = [User getCurrentUser];
    }
    return _user;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CDMyIconCell *cell = [tableView dequeueReusableCellWithIdentifier:[CDMyIconCell cellReuseIdentifier] forIndexPath:indexPath];
        cell.user = self.user;
        return cell;
    }else{
        CDMyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[CDMyInfoCell cellReuseIdentifier] forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.label.text = @"昵称";
                cell.detailLabel.text = self.user.displayName;
                break;
            case 1:
                cell.label.text = @"修改密码";
                cell.detailLabel.text = @"";
                break;
            case 2:
                cell.label.text = @"退出登录";
                cell.detailLabel.text = @"";
                break;
            default:
                break;
        }
        return cell;
    }
}


#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.0;
    }else{
        return 44.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1.0;
    }else{
        return 10.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self uploadIcon];
    }else{
        switch (indexPath.row) {
            case 0:
                [self updateNickName];
                break;
            case 1:
                [self updatePassword];
                break;
            case 2:
                [self logout];
                break;
            default:
                break;
        }
    }
}

- (void)updateNickName{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.user.nickName = alert.textFields[0].text;
        [self updateCurrentUser];
        [self.tableView reloadData];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kLocalizedString(@"请输入昵称");
    }];
    [alert addAction:OKAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updatePassword{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"修改密码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入旧密码";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新密码";
    }];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *oldPassword = [alert.textFields[0] text];
        NSString *newPassword = [alert.textFields[1] text];
        [HUD show];
        [self.user changePasswordInBackground:oldPassword newPassword:newPassword callback:^(BOOL result, DroiError *error) {
            if (result) {
                [HUD showText:@"修改成功"];
                [self.tableView reloadData];
            }
            else{
                [HUD showText:[NSString stringWithFormat:@"修改失败%@",error.message]];
            }
            [HUD dismissAfterDelay:1.5f];
        }];
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logout {
    [HUD show];
    [self.user logoutInBackground:^(BOOL result, DroiError *error) {
        if (result) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [HUD showText:kLocalizedString(@"退出登录失败")];
            [HUD dismissAfterDelay:1.5];
        }
        [HUD dismissAfterDelay:0.0f];
    }];
}

// 上传图片
- (void)uploadIcon{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
    }
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        NSData *data;
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage * smallImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(128, 128)];
        if (UIImagePNGRepresentation(smallImage) == nil) {
            data = UIImageJPEGRepresentation(smallImage, 1.0);
        } else {
            data = UIImagePNGRepresentation(smallImage);
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            self.user.headIcon = [DroiFile fileWithData:data];
            [self updateCurrentUser];
            [self.tableView reloadData];
        }];
    }
}

- (void)updateCurrentUser{
    [HUD show];
    [self.user saveInBackground:^(BOOL result, DroiError *error) {
        if (result) {
            [HUD showText:kLocalizedString(@"保存成功")];
        }
        else{
            [HUD showText:kLocalizedString(@"保存失败")];
        }
        [HUD dismissAfterDelay:1.5f];
    }];
}

@end
