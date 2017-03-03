//
//  UIViewController+Base.m
//  ruhang
//
//  Created by Jon on 2016/11/23.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UIViewController+Base.h"
#import "NSObject+Base.h"
#define kAlertBackgroundViewTag  10584156
#define kPresentBackgroundViewTag  1224345

@implementation UIViewController (Base)
+ (void)load{
    NSLog(@"%@ Load",[self class]);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelectorViewDidLoad = @selector(viewDidLoad);
        SEL swizzledSelectorViewDidLoad = @selector(msl_viewDidLoad);
        
        SEL originalSelectorViewWillAppear = @selector(viewWillAppear:);
        SEL swizzledSelectorViewWillAppear = @selector(msl_viewWillAppear:);
        
        SEL originalSelectorViewWillDisappear = @selector(viewWillDisappear:);
        SEL swizzledSelectorViewWillDisappear = @selector(msl_viewWillDisappear:);
        
        
        [self replaceMethod:class originalSelector:originalSelectorViewDidLoad swizzledSelector:swizzledSelectorViewDidLoad];
        [self replaceMethod:class originalSelector:originalSelectorViewWillAppear swizzledSelector:swizzledSelectorViewWillAppear];
        [self replaceMethod:class originalSelector:originalSelectorViewWillDisappear swizzledSelector:swizzledSelectorViewWillDisappear];
        
    });
}


//利用runtime 进行替换viewDidLoad 默认运行一些方法
- (void)msl_viewDidLoad{
    
    [self msl_viewDidLoad];
    SEL prepareDataSource = NSSelectorFromString(@"prepareDataSource");
    SEL setupUI = NSSelectorFromString(@"setupUI");
    
    if ([self respondsToSelector:prepareDataSource]) {
        
        IMP imp = [self methodForSelector:prepareDataSource];
        void (*func)(id, SEL) = (void *)imp;
        func(self, prepareDataSource);
        
        //下面这个方法相当于上面的简写 如果直接使用[self performSelector:(SEL)] 会有警告报出,但其实是
        //        ((void (*)(id, SEL))[self methodForSelector:prepareDataSource])(self, prepareDataSource);
    }
    if ([self respondsToSelector:setupUI]) {
        ((void (*)(id, SEL))[self methodForSelector:setupUI])(self, setupUI);
    }
}

- (void)msl_viewWillAppear:(BOOL)animated{
    [self msl_viewWillAppear:animated];
    
    SEL pageName = NSSelectorFromString(@"pageName");
    if ([self respondsToSelector:pageName]) {
        
        NSString *pageNameStr = [self performSelector:pageName];
        NSLog(@"%@ msl_viewWillAppear",pageNameStr);
    }
}

- (void)msl_viewWillDisappear:(BOOL)animated{
    
    [self msl_viewWillDisappear:animated];
    SEL pageName = NSSelectorFromString(@"pageName");
    if ([self respondsToSelector:pageName]) {
        
        NSString *pageNameStr = [self performSelector:pageName];
        NSLog(@"%@ msl_viewWillDisappear",pageNameStr);
    }
}


- (void)my_presentViewController:(UIViewController *)viewController{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    backgroundView.tag = kPresentBackgroundViewTag;
    [self.view addSubview:backgroundView];
    [UIView animateWithDuration:0.1 animations:^{
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } completion:^(BOOL finished) {
        [self.view addSubview:viewController.view];
        viewController.view.frame = self.view.bounds;

        [self addChildViewController:viewController];
    }];
}

- (void)my_dismissViewController{
    
    UIView *backgroundView = [self.view.superview viewWithTag:kPresentBackgroundViewTag];
    [backgroundView removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)alertViewController:(UIViewController *)viewController{

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    backgroundView.tag = kAlertBackgroundViewTag;
    
    [self.view addSubview:backgroundView];
    [UIView animateWithDuration:0.1 animations:^{
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [viewController.view.layer addAnimation:popAnimation forKey:nil];
    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
    
}

- (void)dismissAlertViewController{
    
    UIView *backgroundView = [self.view.superview viewWithTag:kAlertBackgroundViewTag];
    [backgroundView removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)alertConfirmWithMessage:(NSString *)message callback:(void(^)(BOOL result))callback{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKBtn = [UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kSafeBlcok(callback,YES);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        kSafeBlcok(callback,NO);
    }];
    [alert addAction:OKBtn];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//全局设置 statusBar 样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


@end
