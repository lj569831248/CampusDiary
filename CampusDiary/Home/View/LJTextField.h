//
//  LJTextField.h
//  CampusDiary
//
//  Created by Jon on 2017/2/16.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJTextField : UIView
{
    NSString *_text;
}
@property (copy, nonatomic)NSString *placeholder;

- (void)setText:(NSString *)text;
- (NSString *)text;
@end
