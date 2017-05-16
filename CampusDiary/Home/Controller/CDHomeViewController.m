//
//  CDHomeViewController.m
//  CampusDiary
//
//  Created by Jon on 2017/2/15.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "CDHomeViewController.h"
#import <objc/runtime.h>
#import <MJRefresh.h>
#import <UIButton+WebCache.h>
#import "UINavigationBar+Color.h"
#import "CDMyViewController.h"
#import "CDPublishDiaryVC.h"
#import "CDHomeTableHeaderView.h"
#import "CDHomeFooterView.h"
#import "CDHomeTableViewCell.h"
#import "CircleItem.h"
#import "CommentItem.h"
#import "UILabel+Base.h"
#import "RHLoginViewController.h"
#import "EwenTextView.h"
#import "CircleParameter.h"
#import "CircleDeleteParameter.h"
#import "CircleResult.h"

#define kTableHeaderViewHeight 233.0
#define kPadding 8.0

static NSString *const kAPIKey = @"TfO1XdOKxTaxTitvGd9KZXt7drSXm2axjlDIcsFUJ4h6jVUzLQBwBNqIQe3bL_ZY";
static NSString *const kGetCircleListAPIPath = @"/api/v2/getCircleList";
static NSString *const kDeleteCircleAPIPath = @"/api/v2/removeCircle";


@interface CDHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CDHomeTableHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
@property (weak, nonatomic) IBOutlet UIButton *userIconButton;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;

@end

@implementation CDHomeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
        [self.userIconButton sd_setImageWithURL:iconUrl forState:UIControlStateNormal placeholderImage:kImage(@"my_userIcon")];
    }
    else {
        self.userNickNameLabel.text = @"未登录";
        [self.userIconButton setImage:kImage(@"my_userIcon") forState:UIControlStateNormal];
    }
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
    [control addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    [control beginRefreshing];
    [self refreshData:control];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:KPublishSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kUserStateUpdate object:nil];
}
- (void)dismissCommentView{
//    NSLog(@"dismissCommentView");
}

- (void)refreshData:(UIRefreshControl *)control{
    [HUD show];
    CircleParameter *param = [[CircleParameter alloc] init];
    param.offset = 0;
    param.limit = 10;
    [DroiCloud callRestApiInBackground:kAPIKey apiPath:kGetCircleListAPIPath method:DROIMETHOD_POST parameter:param andCallback:^(id result, DroiError *error) {
        if (control && [control isKindOfClass:[UIRefreshControl class]]) {
            [control endRefreshing];
        }
        if (error.isOk) {
            CircleResult *circleResult = (CircleResult *)result;
            //error.isOK 且 result.code == 0 说明数据获取成功
            if (circleResult.code == 0) {
                [HUD showText:@"刷新成功"];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:circleResult.data];
                [self.tableView reloadData];
            }else{
                [HUD showText:@"发生错误"];
                DLog(@"result 结果获取错误：%ld",circleResult.code);
            }
        }else{
            [HUD showText:@"发生错误"];
            DLog(@"云代码请求出错 %@",error.message);
        }
        [HUD dismiss];

    } withClassType:CircleResult.class];

}

- (void)reloadMoreData{
    CircleParameter *param = [[CircleParameter alloc] init];
    param.offset = self.dataSource.count;
    param.limit = 10;
    [DroiCloud callRestApiInBackground:kAPIKey apiPath:kGetCircleListAPIPath method:DROIMETHOD_POST parameter:param andCallback:^(id result, DroiError *error) {
         [self.tableView.mj_footer endRefreshing];
        if (error.isOk) {
            CircleResult *circleResult = (CircleResult *)result;
            //error.isOK 且 result.code == 0 说明数据获取成功
            if (circleResult.code == 0) {
                if (circleResult.data.count == 0) {
                    [HUD showText:@"没有更多了"];
                    [HUD dismiss];
                }else{
                    [self.dataSource addObjectsFromArray:circleResult.data];
                    [self.tableView reloadData];
                }
            }else{
                DLog(@"result 结果获取错误：%ld",circleResult.code);
            }
        }else{
            DLog(@"云代码请求出错 %@",error.message);
        }
    } withClassType:CircleResult.class];

}


#pragma mark dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CircleItem *circleItem = self.dataSource[section];
    return  circleItem.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleItem *circleItem = self.dataSource[indexPath.section];
    CommentItem *model = circleItem.commentList[indexPath.row];
    CDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CDHomeTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


#pragma mark delegate
//点击评论的信息执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([User currentUserIsLogin]) {
        CircleItem *circleItem = self.dataSource[indexPath.section];
        CommentItem *model = circleItem.commentList[indexPath.row];
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
    }else{
        [self toLogin];
    }
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

//点击评论按钮的 delegate 方法
- (void)tableHeaderView:(CDHomeTableHeaderView *)tableHeaderView didCheckCommentButton:(UIButton *)commentButton{
    if ([User currentUserIsLogin]) {
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
    }else{
        [self toLogin];

    }
}

- (void)tableHeaderView:(CDHomeTableHeaderView *)tableHeaderView didCheckDeleteButton:(UIButton *)deleteButton{
    CircleItem *model = tableHeaderView.model;
    [self deleteCircle:model];
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
        [self toLogin];
    }
}

- (void)newDiary{
    if ([User currentUserIsLogin]) {
        CDPublishDiaryVC *pubDiaryVC = [[CDPublishDiaryVC alloc] init];
        [self.navigationController pushViewController:pubDiaryVC animated:YES];
        DLog(@"发日记");
    }else{
        RHLoginViewController *loginVC = [[RHLoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
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

- (void)toLogin{
    RHLoginViewController *loginVC = [[RHLoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNav animated:YES completion:nil];
}

- (void)deleteCircle:(CircleItem *)circleItem{
    [HUD show];
    CircleDeleteParameter *param = [[CircleDeleteParameter alloc] init];
    param.circleId = circleItem.objectId;
    [DroiCloud callRestApiInBackground:kAPIKey apiPath:kDeleteCircleAPIPath method:DROIMETHOD_POST parameter:param andCallback:^(id result, DroiError *error) {
        if (error.isOk) {
            CircleResult *circleResult = (CircleResult *)result;
            //error.isOK 且 result.code == 0 说明数据获取成功
            if (circleResult.code == 0) {
                [HUD showText:@"删除成功"];
                [self.dataSource removeObject:circleItem];
                [self.tableView reloadData];
            }else{
                [HUD showText:@"删除失败"];
                DLog(@"result 结果获取错误：%ld",circleResult.code);
            }
        }else{
            [HUD showText:@"发送错误"];
            DLog(@"云代码请求出错 %@",error.message);
        }
        [HUD dismiss];
    } withClassType:CircleResult.class];
}
@end
