//
//  CDPrivacyPolicyVC.m
//  CampusDiary
//
//  Created by Jon on 2017/2/28.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDPrivacyPolicyVC.h"

@interface CDPrivacyPolicyVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CDPrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PrivacyPolicy" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    self.title = @"隐私条款";
}
@end
