//
//  CDHomeViewController.m
//  CampusDiary
//
//  Created by Jon on 2017/2/15.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDHomeViewController.h"
#import "UINavigationBar+Color.h"
#import "CDMyViewController.h"
#import "CDPublishDiaryVC.h"
#import "CircleItem.h"
#import "CDHomeTableHeaderView.h"
#import "CDHomeFooterView.h"
#import "CDHomeTableViewCell.h"
#import "CommentItem.h"
#import "UILabel+Base.h"
#import <MJRefresh.h>
#import <UIButton+WebCache.h>
#import "RHLoginViewController.h"
#import <objc/runtime.h>
#import "EwenTextView.h"
#define kTableHeaderViewHeight 233.0
#define kPadding 8.0
@interface CDHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CDHomeTableHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , strong) NSMutableArray *commentDataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
@property (weak, nonatomic) IBOutlet UIButton *userIconButton;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;

@end

@implementation CDHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    CGFloat contentOffsetY = self.tableView.contentOffset.y;
    [self setNavigationBarWithOffsetY:contentOffsetY];
    [super viewWillAppear:animated];
    [self requestUserData];
}

- (void)requestUserData{
    User *currentUser = [User getCurrentUserByUserClass:[User class]];
    if (currentUser.isLoggedIn && (!currentUser.isAnonymous)) {
        self.userNickNameLabel.text = currentUser.displayName;
        NSURL *iconUrl = currentUser.headIcon.getUrl;
        [self.userIconButton sd_setImageWithURL:iconUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_userIcon"]];
    }
    else {
        self.userNickNameLabel.text = @"未登录";
        [self.userIconButton sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_userIcon"]];
    }
}

- (NSMutableArray *)commentDataSource{
    if (_commentDataSource == nil) {
        _commentDataSource = [[NSMutableArray alloc] init];
    }
    return _commentDataSource;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.title = @"校园日记";
    
    //取消图片渲染
    UIImage *image = [[UIImage imageNamed:@"home_new_diary"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(newDiary)];
    
    //添加一层渐变色蒙版 让最上方的白色文字不会看不清
    CAGradientLayer *gradientLayer= [CAGradientLayer layer];//设置渐变效果
    gradientLayer.frame=CGRectMake(0,0,kScreenWidth,64);
    UIColor *color1 = kColorFromRGBA(0, 0, 0, 0.5);
    UIColor *color2 = kColorFromRGBA(0, 0, 0, 0.25);
    UIColor *color3 = kColorFromRGBA(0, 0, 0, 0.0);
    gradientLayer.colors=@[ (__bridge id)color1.CGColor,(__bridge id)color2.CGColor,(__bridge id)color3.CGColor];
    [self.view.layer addSublayer:gradientLayer];
    
    //注册section头尾视图
    [self.tableView registerNib:[UINib nibWithNibName:@"CDHomeTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CDHomeTableHeaderView"];
    [self.tableView registerCellWithClass:[CDHomeTableViewCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:@"CDHomeFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CDHomeFooterView"];
   
    
    //添加手势 点击 collectionView 键盘收起
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCommentView)];
    [self.tableView addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView =NO;
    
    UIRefreshControl *control=[[UIRefreshControl alloc] init];
    control.tintColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    [control beginRefreshing];
    [self refreshStateChange:control];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
}
- (void)dismissCommentView{
//    NSLog(@"dismissCommentView");
}


-(void)refreshStateChange:(UIRefreshControl *)control{
    
    DroiTaskDispatcher* taskDispatcher = [DroiTaskDispatcher getTaskDispatcher:BackgroundThreadDispatcher];
    [taskDispatcher enqueueTask:^{
        DroiQuery *query = [[[[[DroiQuery create] queryByClass:[CircleItem class]] orderBy:@"_CreationTime" ascending:NO] limit:5] offset:0];
        DroiError *error = nil;
        NSArray *result = [query runQuery:&error];
        if (error.isOk) {
            NSMutableArray *commentArray = [[NSMutableArray alloc] init];
            for (CircleItem *circleItem in result) {
                DroiQuery *query1 = [[[[DroiQuery create] queryByClass:[CommentItem class]] orderBy:@"_CreationTime" ascending:NO] whereStatement:@"circleId" opType:DroiCondition_EQ arg2:circleItem.objectId];
                DroiError *error1 = nil;
                NSArray *result1 = [query1 runQuery:&error1];
                NSLog(@"result1:%ld",result1.count);
                if (error1.isOk) {
                    [commentArray addObject:result1];
                }else{
                    CommentItem *item = [[CommentItem alloc] init];
                    [commentArray addObject:@[item]];
                    DLog(@"查询评论失败:%@",error.message);
                }
            }
            [self.commentDataSource removeAllObjects];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:result];
            [self.commentDataSource addObjectsFromArray:commentArray];
        }else{
            DLog(@"查询圈子失败:%@",error.message);
        }
    DroiTaskDispatcher* mainTaskDispatcher = [DroiTaskDispatcher getTaskDispatcher:MainThreadDispatcher];
        [mainTaskDispatcher enqueueTask:^{
            [control endRefreshing];
            [self.tableView reloadData];
        }];
    }];
}

- (void)reloadNewData{
    DLog(@"reloadNewData");
    [self.tableView.mj_header endRefreshing];
}

- (void)reloadMoreData{
    DroiTaskDispatcher* taskDispatcher = [DroiTaskDispatcher getTaskDispatcher:BackgroundThreadDispatcher];
    [taskDispatcher enqueueTask:^{
        DroiQuery *query = [[[[[DroiQuery create] queryByClass:[CircleItem class]] orderBy:@"_CreationTime" ascending:NO] limit:5] offset:(int)(self.dataSource.count)];
        DroiError *error = nil;
        NSArray *result = [query runQuery:&error];
        if (error.isOk) {
            [self.dataSource addObjectsFromArray:result];
            for (CircleItem *circleItem in result) {
                DroiQuery *query1 = [[[[DroiQuery create] queryByClass:[CommentItem class]] orderBy:@"_CreationTime" ascending:NO] whereStatement:@"circleId" opType:DroiCondition_EQ arg2:circleItem.objectId];
                DroiError *error1 = nil;
                NSArray *result1 = [query1 runQuery:&error1];
                NSLog(@"result1:%ld",result1.count);
                if (error1.isOk) {
                    [self.commentDataSource addObject:result1];
                }else{
                    DLog(@"查询评论失败:%@",error.message);
                }
            }
        }else{
            DLog(@"查询圈子失败:%@",error.message);
        }
        DroiTaskDispatcher* mainTaskDispatcher = [DroiTaskDispatcher getTaskDispatcher:MainThreadDispatcher];
        [mainTaskDispatcher enqueueTask:^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }];
    }];
    DLog(@"reloadMoreData");
}


#pragma mark dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.commentDataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentItem *model = self.commentDataSource[indexPath.section][indexPath.row];
    CDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CDHomeTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


#pragma mark delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentItem *model = self.commentDataSource[indexPath.section][indexPath.row];
    [self showEwenTextView:^(NSString *text) {
        CommentItem *comment = [[CommentItem alloc] init];
        comment.content = text;
        User *currentUser = [User getCurrentUser];
        comment.user = currentUser;
        comment.circleId = model.circleId;
        comment.toReplyUser = model.user;
        [HUD show];
        [comment saveInBackground:^(BOOL result, DroiError *error) {
            if (result) {
                [HUD dismissAfterDelay:0.0];
            }else{
                [HUD showText:@"发生错误"];
                [HUD dismiss];
                DLog(@"发生错误%@",error.message);
            }
        }];
    }];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CircleItem *model = self.dataSource[section];
    CDHomeTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CDHomeTableHeaderView"];
    if (headerView == nil) {
        headerView = [[CDHomeTableHeaderView alloc] initWithReuseIdentifier:@"CDHomeTableHeaderView"];
    }
    headerView.delegate = self;
    headerView.section = section;
    headerView.model = model;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CDHomeFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CDHomeFooterView"];
    if (footerView == nil) {
        footerView = [[CDHomeFooterView alloc] initWithReuseIdentifier:@"CDHomeFooterView"];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CircleItem *model = self.dataSource[section];
    CGFloat nickLabelHeight = 15.0;
    CGFloat iconImageWidth = 40.0;
    CGFloat contentLabelWidth = kScreenWidth - kPadding - iconImageWidth - kPadding - kPadding;
    CGFloat contentLabelHeight = [UILabel heightWithFont:[UIFont systemFontOfSize:12.0] String:model.content Width:contentLabelWidth];
    CGFloat height1 = nickLabelHeight + kPadding + contentLabelHeight;
    if (height1 < 40.0) {
        height1 = 40.0;
    }
    NSInteger a = model.photos.count / 3;
    int b = model.photos.count % 3;
    if (b > 0) {
        a = a + 1;
    }
    CGFloat colletcViewWidth = kScreenWidth - kPadding - 40.0 - kPadding - kPadding;
    CGFloat width = (colletcViewWidth - kPadding * 2) / 3;
    CGFloat collectionViewHeight = a * width + (a - 1) * kPadding;
    CGFloat height = height1 + kPadding + collectionViewHeight + kPadding + 13.5 + kPadding ;
    return height;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"%f",contentOffsetY);
    [self setNavigationBarWithOffsetY:contentOffsetY];
}

- (void)tableHeaderView:(CDHomeTableHeaderView *)tableHeaderView didCheckCommentButton:(UIButton *)commentButton{
    
    CircleItem *model = tableHeaderView.model;
    NSLog(@"%@",commentButton);
    
    [self showEwenTextView:^(NSString *text) {
        CommentItem *comment = [[CommentItem alloc] init];
        comment.content = text;
        User *currentUser = [User getCurrentUser];
        comment.user = currentUser;
        comment.circleId = model.objectId;
        [HUD show];
        [comment saveInBackground:^(BOOL result, DroiError *error) {
            if (result) {
                [HUD dismissAfterDelay:0.0];
            }else{
                [HUD showText:@"发生错误"];
                [HUD dismiss];
                DLog(@"发生错误%@",error.message);
            }
        }];
    }];
//    [self showCommentChooser:commentButton];
//    CGRect frame = [tableHeaderView convertRect:commentButton.frame toView:self.tableView];
////    NSLog(@"%@",NSStringFromCGRect(frame));
//    CGRect newFrame = CGRectMake(frame.origin.x - 100, frame.origin.y, 100, 29.5);
//    UIView *view = [[UIView alloc] initWithFrame:newFrame];
//    view.backgroundColor = [UIColor redColor];
//    [self.tableView addSubview:view];
}

- (void)setNavigationBarWithOffsetY:(CGFloat)contentOffsetY{
    if (contentOffsetY > 0) {
        self.imageViewTop.constant = 0;
        CGFloat alpha = 1 - (kTableHeaderViewHeight - 64.0 - contentOffsetY) / (kTableHeaderViewHeight - 64.0);
        UIColor *color = kColorFromHexA(0X1296db, alpha);
        [self.navigationController.navigationBar setColor:color];
        
    }else{
        UIColor *color = kColorFromHexA(0X1296db, 0);
        [self.navigationController.navigationBar setColor:color];
        self.imageViewTop.constant = contentOffsetY;
    }

}

- (IBAction)checkUserIcon:(UIButton *)sender {
    if ([User currentUserIsLogin]) {

        CDMyViewController *myVC = [[CDMyViewController alloc] init];
        [self.navigationController pushViewController:myVC animated:YES];
    }else{
        RHLoginViewController *loginVC = [[RHLoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

- (void)newDiary{
    CDPublishDiaryVC *pubDiaryVC = [[CDPublishDiaryVC alloc] init];
    [self.navigationController pushViewController:pubDiaryVC animated:YES];
    DLog(@"发日记");
}


- (void)showEwenTextView:(void(^)(NSString *text))block{
    EwenTextView *textView = [[EwenTextView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    [textView setPlaceholderText:@"请输入文字"];
    [self.view addSubview:textView];
    textView.EwenTextViewBlock = block;
}

- (void)showCommentChooser:(UIButton *)button{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
   CGRect commentBtnFrame = [button convertRect:button.bounds toView:window];
    backgroundView.backgroundColor=[UIColor clearColor];
    [window addSubview:backgroundView];
    UIView *chooser = [[[UINib nibWithNibName:@"CommentChooserView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    chooser.tag = 1001;
    chooser.frame = CGRectMake(commentBtnFrame.origin.x, commentBtnFrame.origin.y, 0, 30);
    [backgroundView addSubview:chooser];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChooser:)];
    [backgroundView addGestureRecognizer: tap];
    CGRect chooserNewFrame = CGRectMake(chooser.frame.origin.x - 100, chooser.frame.origin.y, 100, chooser.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        chooser.frame = chooserNewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideChooser:(UITapGestureRecognizer *)tap{
    UIView *backgroundView=tap.view;
    UIView *chooser = [backgroundView viewWithTag:1001];
    CGRect chooserNewFrame = CGRectMake(chooser.frame.origin.x + 100 , chooser.frame.origin.y, 0, chooser.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        chooser.frame = chooserNewFrame;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
@end
