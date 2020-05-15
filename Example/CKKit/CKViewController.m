//
//  CKViewController.m
//  CKKit
//
//  Created by 13035155560@163.com on 05/13/2020.
//  Copyright (c) 2020 13035155560@163.com. All rights reserved.
//

#import "CKViewController.h"
#import <CKKit/CKKit.h>

@interface CKViewController ()

/** <#param#> */
@property (nonatomic, strong) CKSpinnerView * spinnerView;

@end

@implementation CKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [CKUitls ck_createBtnWithTitle:@"测试"
                                        titleColor:@"#333333"
                                  selectTitleColor:nil
                                         titleFont:[UIFont systemFontOfSize:16.0]
                                     normalImgName:nil
                                   selectedImgName:nil tag:0];
    [btn ck_showBorderColor:[UIColor ck_colorWithHexString:@"#333333"] cornerRadius:5];
    [btn addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 0, 120, 35);
    btn.center = self.view.center;
}

- (void)btnClickAction {
    CKInputView *input = [[CKInputView alloc] initWithTitle:@"测试" style:CKInputViewTypeForTextField];
    input.keyboardType = CKKeyboardTypeForNumeric;
    [self.view addSubview:input];
    input.frame = CGRectMake(0, 0, 200, 35);
    input.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    
    self.spinnerView.datas = @[@"测试1",@"测试2",@"测试三"];
    __weak typeof(self) weakSelf = self;
    self.spinnerView.callback = ^(NSIndexPath *index, NSString *model) {
        [weakSelf.spinnerView hideWithAnimate:true];
        input.text = model;
    };
    [self.spinnerView showBelowWith:input displayForward:CKDisplayForwardForDownOnWindow];
}

#pragma mark - Lazy load
- (CKSpinnerView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[CKSpinnerView alloc] init];
    }
    return _spinnerView;
}


@end
