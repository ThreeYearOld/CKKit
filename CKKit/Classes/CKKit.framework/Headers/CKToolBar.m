//
//  CKToolBar.m
//  CKUitlKit
//
//  Created by admin on 2020/5/12.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import "CKToolBar.h"

@implementation CKToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    // 取消
    UIButton *cancelBtn = [self createBtnWithTitle:@"取消" titleColor:[UIColor lightGrayColor] action:@selector(cancelAction)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    // 确定
    UIButton *confirmBtn = [self createBtnWithTitle:@"确定" titleColor:[UIColor blackColor] action:@selector(confirmAction)];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL];
    [self setItems:@[cancelItem,spaceItem,confirmItem]];
}

- (void)cancelAction {
    if (_cancelActionBlock) {
        _cancelActionBlock();
    }
}

- (void)confirmAction {
    if (_confirmActionBlock) {
        _confirmActionBlock();
    }
}

- (UIButton *)createBtnWithTitle:(NSString *)title
                      titleColor:(UIColor *)color
                          action:(SEL)btnAction {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
