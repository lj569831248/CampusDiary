//
//  HUD.m
//  ruhang
//
//  Created by Jon on 2016/11/29.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "HUD.h"

@interface HUD ()

@end
@implementation HUD

static HUD *_instance = nil;

+ (void)instance{
    if (_instance == nil) {
        _instance = [self showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
}

+ (void)show{
    
    [self instance];
}



+ (void)showText:(NSString *)text{
    
    [self instance];
    _instance.mode = MBProgressHUDModeText;
    _instance.label.text = text;
}

+ (void)showProgress:(CGFloat)progress{
    
    [self instance];
    dispatch_async(dispatch_get_main_queue(), ^{
        _instance.mode = MBProgressHUDModeDeterminate;
        _instance.progress = progress;
    });
}

+ (void)showProgress:(CGFloat)progress text:(NSString *)text{
    [self instance];
    dispatch_async(dispatch_get_main_queue(), ^{
        _instance.mode = MBProgressHUDModeDeterminate;
        _instance.progress = progress;
        _instance.label.text = text;
    });
}

    
+ (void)dismissAfterDelay:(NSTimeInterval)delay{
    
    if (_instance) {
        [_instance hideAnimated:YES afterDelay:delay];
        _instance = nil;
    }
}

+ (void)dismiss{
    
    [self dismissAfterDelay:1.0];
}


@end
