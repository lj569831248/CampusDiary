//
//  RHAboutVC.m
//  ruhang
//
//  Created by Jon on 2016/11/24.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "RHAboutVC.h"
#import "UINavigationBar+Color.h"
@interface RHAboutVC ()

@end

@implementation RHAboutVC


- (void)viewWillAppear:(BOOL)animated
{
    [self setupUI];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.title = @"关于我们";
}

@end
