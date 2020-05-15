//
//  CKBorderTextField.m
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import "CKBorderTextField.h"
#import "UIColor+CKAdd.h"
#import "UIView+CKAdd.h"

@implementation CKBorderTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化圆角值
        _cornerRadius = 5.0;
        UIColor *borderColor = [UIColor ck_colorWithHexString:@"#d2d5e0"];
        [self ck_showBorderColor:borderColor cornerRadius:_cornerRadius];
        // 设置占位符的颜色
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor ck_colorWithHexString:@"#dcdcdc"], NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        self.keyboardType = UIKeyboardTypeDefault;
        // 设置颜色、字体大小
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor ck_colorWithHexString:@"000000"];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView *margin = [[UIView alloc] init];
        margin.frame = CGRectMake(0, 0, 5, 10);
        self.leftView = margin;
        // 添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditNotify:) name:UITextFieldTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditNotify:) name:UITextFieldTextDidEndEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedEditNotify:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    NSMutableAttributedString *attriPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attriPlaceholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor lightGrayColor]
                        range:NSMakeRange(0, placeholder.length)];
    self.attributedPlaceholder = attriPlaceholder;
}

- (void)beginEditNotify:(NSNotification *)notification {
    if (notification.object == self) {
        [self ck_showBorderColor:[UIColor redColor]
                     borderWidth:1
                    cornerRadius:_cornerRadius];
    }
}

#pragma mark - textField实时监听
- (void)changedEditNotify:(NSNotification *)notification {
    if (_isInputPhone) {
        self.text = [self.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        return;
    }
    if (!_isNumericKeyboard) return;
    if (self.text.length == 1) {
        if ([self.text containsString:@"."]) {
            self.text = @"0.";
        }
    }else if (self.text.length >= 2) {
        if ([self.text containsString:@"."]) {
            // 截取最后一位之前的内容
            NSString *preContent = [self.text substringWithRange:NSMakeRange(0, self.text.length-1)];
            // 获取刚刚输入的内容
            NSString *lastCharacter = [self.text substringWithRange:NSMakeRange(self.text.length-1, 1)];
            if ([preContent containsString:@"."] && [lastCharacter isEqualToString:@"."]) {
                self.text = preContent;
            }
        }else {
            // 防止出现类似02或者00的情况出现
            if (self.text.length == 2) {
                NSString *firstContent = [self.text substringWithRange:NSMakeRange(0, 1)];
                NSString *secContent = [self.text substringWithRange:NSMakeRange(1, 1)];
                if (firstContent.intValue == 0) {
                    if (secContent.intValue == 0) {
                        self.text = firstContent;
                    }else if (secContent.intValue > 0) {
                        self.text = secContent;
                    }
                }
            }
        }
    }
}

- (void)endEditNotify:(NSNotification *)notification {
    if (notification.object == self) {
        UIColor *borderColor = [UIColor ck_colorWithHexString:@"#d2d5e0"];
        [self ck_showBorderColor:borderColor cornerRadius:_cornerRadius];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}

@end
