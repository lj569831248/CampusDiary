//
//  CDMyViewController.m
//  CampusDiary
//
//  Created by Jon on 2017/2/15.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDMyViewController.h"
#import "UINavigationBar+Color.h"
#import "CDMyModel.h"
#import "RHMyCell.h"
#import "User.h"
#import "RHLoginViewController.h"
#import <UIButton+WebCache.h>
#import "RHAboutVC.h"
#import <DroiFeedback/DroiFeedback.h>
#import "CDMyInfoVC.h"
@interface CDMyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *userHeaderIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@implementation CDMyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUserData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setColor:kBaseColor];

}

- (void)requestUserData{
    User *currentUser = [User getCurrentUser];
    if (currentUser.isLoggedIn && (!currentUser.isAnonymous)) {
        self.userNickNameLabel.text = currentUser.displayName;
        NSURL *iconUrl = currentUser.headIcon.getUrl;
        [self.userHeaderIconBtn sd_setImageWithURL:iconUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_userIcon"]];
    }
    else {
        self.userNickNameLabel.text = @"未登录";
        [self.userHeaderIconBtn setBackgroundImage:[UIImage imageNamed:@"my_userIcon"] forState:UIControlStateNormal];
    }
    
}

- (NSMutableArray *)dataSource{
    if(_dataSource == nil){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的";
    [self.tableView registerCellWithClass:[RHMyCell class]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView.backgroundColor = kBaseColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


- (void)prepareDataSource{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"My" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];
    for (NSArray *array in plistArray) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary *dict in array) {
            CDMyModel *model = [[CDMyModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [dataArray addObject:model];
        }
        [self.dataSource addObject:dataArray];
    }
}

#pragma mark dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDMyModel *model = self.dataSource[indexPath.section][indexPath.row];
    RHMyCell *cell = [tableView dequeueReusableCellWithIdentifier:[RHMyCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDMyModel *model = self.dataSource[indexPath.section][indexPath.row];
    if (model.nextVC && ![model.nextVC isEqualToString:@""]) {
        Class class = NSClassFromString(model.nextVC);
        UIViewController *nextVC = [[class alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }else{
        [DroiFeedback setColor:kBaseColor];
        [DroiFeedback callFeedbackWithViewController:self];
    }
    
}


- (IBAction)didCheckIconButton:(UIButton *)sender {
    if ([User currentUserIsLogin]) {
        CDMyInfoVC *myInfoVC = [[CDMyInfoVC alloc] init];
        [self.navigationController pushViewController:myInfoVC animated:YES];
    }else{
        RHLoginViewController *loginVC = [[RHLoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}
@end
