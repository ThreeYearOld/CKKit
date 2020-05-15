//
//  CKNarrowTextFieldView.m
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import "CKNarrowTextFieldView.h"
#import "CKLayoutButton.h"
#import "CKSpinnerNarrowView.h"
#import "UIColor+CKAdd.h"
#import "CKUitls.h"
#import <Masonry.h>

@interface CKNarrowTextFieldView()

/** 箭头 */
@property (nonatomic, weak) CKLayoutButton * narrowBtn;

@end

@implementation CKNarrowTextFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        // 圆角、边框
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        self.layer.borderColor = [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor;
        self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    }
    return self;
}

- (void)createUI {
    // 创建
    UITextField *textField = [self createTextField];
    self.textField = textField;
    CKLayoutButton *narrowBtn = [self createNarrowBtnWithImgSize:CGSizeMake(10, 5)];
    self.narrowBtn = narrowBtn;
    // 添加
    [self addSubview:textField];
    [self addSubview:narrowBtn];
    // 约束
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.left.equalTo(self);
    }];
    [narrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.top.equalTo(self);
        make.width.mas_equalTo(narrowBtn.mas_height);
        make.left.equalTo(self.textField.mas_right).offset(5);
    }];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedEditNotify:) name:UITextFieldTextDidChangeNotification object:textField];
}

#pragma mark - 箭头btn的点击事件
- (void)btnClickAction {
    if (self.btnClickBlock) {
        self.btnClickBlock(self.textField);
    }
}

#pragma mark - 设置图标以及size
- (void)setNarrowImg:(NSString *)imgName imgSize:(CGSize)size {
    [self.narrowBtn removeFromSuperview];
    CKLayoutButton *btn = [self createNarrowBtnWithImgSize:CGSizeMake(25, 25)];
    self.narrowBtn = btn;
    [self addSubview:btn];
    [self.narrowBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.top.equalTo(self);
        make.width.mas_equalTo(self.narrowBtn.mas_height);
        make.left.equalTo(self.textField.mas_right).offset(5);
    }];
}

#pragma mark - override setter
- (void)setIsHidden:(BOOL)isHidden {
    self.narrowBtn.hidden = isHidden;
}

#pragma mark - textField实时监听
- (void)changedEditNotify:(NSNotification *)notification {
    if (_isInputPhone) {
        self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        return;
    }
    if (!_isNumericKeyboard) return;
    if (self.textField.text.length == 1) {
        if ([self.textField.text containsString:@"."]) {
            self.textField.text = @"0.";
        }
    }else if (self.textField.text.length >= 2) {
        if ([self.textField.text containsString:@"."]) {
            // 截取最后一位之前的内容
            NSString *preContent = [self.textField.text substringWithRange:NSMakeRange(0, self.textField.text.length-1)];
            // 获取刚刚输入的内容
            NSString *lastCharacter = [self.textField.text substringWithRange:NSMakeRange(self.textField.text.length-1, 1)];
            if ([preContent containsString:@"."] && [lastCharacter isEqualToString:@"."]) {
                self.textField.text = preContent;
            }
        }else {
            // 防止出现类似02或者00的情况出现
            if (self.textField.text.length == 2) {
                NSString *firstContent = [self.textField.text substringWithRange:NSMakeRange(0, 1)];
                NSString *secContent = [self.textField.text substringWithRange:NSMakeRange(1, 1)];
                if (firstContent.intValue == 0) {
                    if (secContent.intValue == 0) {
                        self.textField.text = firstContent;
                    }else if (secContent.intValue > 0) {
                        self.textField.text = secContent;
                    }
                }
            }
        }
    }
}

#pragma mark - private method
- (UITextField *)createTextField {
    UITextField *tf = [[UITextField alloc] init];
    // 设置占位符的颜色
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor ck_colorWithHexString:@"#dcdcdc"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    tf.keyboardType = UIKeyboardTypeDefault;
    // 设置颜色、字体大小
    tf.font = [UIFont systemFontOfSize:16];
    tf.textColor = [UIColor ck_colorWithHexString:@"000000"];
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.leftViewMode = UITextFieldViewModeAlways;
    UIView *margin = [[UIView alloc] init];
    margin.frame = CGRectMake(0, 0, 5, 10);
    tf.leftView = margin;
    return tf;
}

- (CKLayoutButton *)createNarrowBtnWithImgSize:(CGSize)size {
    CKLayoutButton *btn = [CKLayoutButton buttonWithType:UIButtonTypeCustom];
    // 生成向下的箭头
    CKSpinnerNarrowView *narrowView = [[CKSpinnerNarrowView alloc] initWithFrame:CGRectMake(0, 0, 10, 5) narrowForward:CKSpinnerNarrowForwardForBottom narrowColor:[UIColor blackColor]];
    UIImage *dropDown = [CKUitls convertToImage:narrowView];
    [btn setImage:dropDown forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    btn.imageSize = size;
    return btn;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
}


@end
