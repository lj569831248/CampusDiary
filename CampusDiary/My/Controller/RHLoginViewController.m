 //
//  RHLoginViewController.m
//  ruhang
//
//  Created by Jon on 2016/11/28.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "RHLoginViewController.h"
#import "User.h"
#import "HUD.h"
#import "UIView+Base.h"
//#import "RHRegisterViewController.h"
#import "UIButton+Base.h"
@interface RHLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *userNameStateBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordStateBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation RHLoginViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Base
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareDataSource{
    
}

- (void)setupUI{
    self.navigationController.navigationBarHidden = YES;
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    [self.registerBtn setBackgroundColor:kBaseColor forState:UIControlStateNormal];
    [self.registerBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundColor:kBaseColor forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self addKeyboardObserver];
    
}

#pragma mark dataSource



#pragma mark delegate


#pragma mark method

- (IBAction)toRegister:(UIButton *)sender {
    [self registerUser];
    
}

- (IBAction)login:(UIButton *)sender {
    [self login];
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//用户注册
- (void)registerUser{
    NSString *userName = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    [HUD show];
    //因为使用了继承 DroiUser 的 User 所以注册的话要用这个方法
    User *user = [User getCurrentUserByUserClass:[User class]];
    NSLog(@"%@  %d",user,user.isLoggedIn);
    user.UserId = userName;
    user.Password = password;
    [user signUpInBackground:^(BOOL result, DroiError *error) {
        NSString *resultStr = nil;
        if (error.isOk && user != nil && [user  isLoggedIn]) {
            resultStr = @"注册成功，已自动登录";
            //通知用户状态改变
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserStateUpdate object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            resultStr = [NSString stringWithFormat:@"注册失败：%@",error.message];
            NSLog(@"%@  %d",user,user.isLoggedIn);
        }
        NSLog(@"%@",resultStr);
        [HUD showText:kLocalizedString(resultStr)];
        [HUD dismiss];
    }];
    
}

//用户登录
- (void)login{
    NSString *userName = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    [HUD show];
    [User loginInBackground:userName password:password callback:^(DroiUser *user, DroiError *error) {
        NSString *resultStr = nil;
        if (error.isOk && user != nil && [user isLoggedIn]) {
            resultStr = @"登录成功";
            //通知用户状态改变
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserStateUpdate object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            resultStr = [NSString stringWithFormat:@"登录失败：%@",error.message];
        }
        [HUD showText:kLocalizedString(resultStr)];
        [HUD dismiss];
    }];
}

#pragma mark Keyboard Notification

- (void)addKeyboardObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat Y = self.registerBtn.bottomY -  keyboardRect.origin.y;
    if (Y > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.bounds = CGRectMake(0, Y, self.view.width, self.view.height);
        }];
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, self.view.width, self.view.height);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
