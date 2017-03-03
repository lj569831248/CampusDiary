//
//  LJTextField.m
//  CampusDiary
//
//  Created by Jon on 2017/2/16.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "LJTextField.h"

@interface LJTextField ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@end
@implementation LJTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"LJTextField" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
        self.textView.delegate = self;
        self.textView.layer.borderWidth = 1.0;
        UIColor *borderColor = [UIColor colorWithRed:231.0 / 255.0 green:231.0 / 255.0 blue:231.0 / 255.0 alpha:1];
        self.textView.layer.borderColor = [borderColor CGColor];
        self.textView.layer.cornerRadius = 5;
    }
    return self;
}

#pragma mark delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text == nil || [textView.text isEqualToString:@""]) {
        
        self.placeholderLabel.hidden = NO;
    }
    else{
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    if (_placeholder == placeholder) {
        return;
    }
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setText:(NSString *)text{
    if (_text == text) {
        return;
    }
    _text = text;
    self.textView.text = text;
}

- (NSString *)text{
    return self.textView.text;
}


@end
