//
//  CKSpinnerView.m
//  CKKit
//
//  Created by admin on 2019/12/16.
//  Copyright © 2019 Chengkun. All rights reserved.
//

#import "CKSpinnerView.h"
#import "CKSpinnerNarrowView.h"

#define narrow_width   10
#define narrow_height  5
#define narrow_margin  10

@interface CKSpinnerView()

/** 箭头 */
@property (nonatomic, strong) CKSpinnerNarrowView * narrowView;

/** 蒙层 - 移除下拉框 */
@property (nonatomic, strong) UIButton * dismissCover;

/** 记录当前的展示方式 */
@property (nonatomic, assign) CKDisplayForward currDisplayForward;

/** 显示的baseWindow */
@property (nonatomic, strong) UIWindow * myWindow;

@end

@implementation CKSpinnerView

#pragma mark - 生命周期方法
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

#pragma mark - 私有方法
- (void)initialize {
    _touchOutsideHide     = true;
    _isDisplayCoverView   = true;
    _iskeyboardShow       = false;
    _defaultSelectedIndex = NSNotFound;
    _narrowLocation       = CKNarrowLocationForRight;
    _selfHeight           = 0.0;
    
    self.layer.cornerRadius = 2.f;
    self.delegate   = self;
    self.dataSource = self;
    self.rowHeight  = 44;
    self.showsVerticalScrollIndicator = false;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self registerClass:[CKSpinnerCell class] forCellReuseIdentifier:[CKSpinnerCell identifier]];
}

#pragma mark - 公开开发
- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    // 刷新数据
    [self reloadData];
}

- (void)showBelowWith:(UIView *)target displayForward:(CKDisplayForward)forward {
    if (self.datas.count == 0) return;
    if (forward == CKDisplayForwardForUp || forward == CKDisplayForwardForDown || forward == CKDisplayForwardForDownOnWindow) {
        self.currDisplayForward = forward;
    }else {
        self.currDisplayForward = CKDisplayForwardForDown;
    }
    
    switch (self.currDisplayForward) {
        case CKDisplayForwardForDown:{// 在当前控制器向下显示选择框，有显示动画
            [self showSelectViewDownForward:target];
            break;
        }
        case CKDisplayForwardForUp:{// 在当前控制器向上显示选择框，此时没有显示的动画
            [self showSelectViewUpForward:target];
            break;
        }
        case CKDisplayForwardForDownOnWindow:{// 在window上向下显示选择框，有显示的动画
            [self showSelectViewDownForwardOnWindow:target];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 向下展示选择框
- (void)showSelectViewDownForward:(UIView *)target {
    __block UIViewController *vc = [self getCurrentController:target];
    if (!vc) {
        return;
    }
    // 蒙层
    if (self.isDisplayCoverView) {
        self.dismissCover.userInteractionEnabled = self.touchOutsideHide;
        self.dismissCover.frame = vc.view.frame;
        [vc.view addSubview:self.dismissCover];
    }
    CGRect frame = [target.superview convertRect:target.frame toView:vc.view];
    // 计算targetview之下还有多少高度
    CGFloat useHeight = vc.view.bounds.size.height - CGRectGetMaxY(frame) - 15.f;
    
    CGRect tableF = vc.view.frame;
    
    tableF.size.height = 0.f;
    tableF.size.width = frame.size.width + _extraWidth;
    tableF.origin = CGPointMake(frame.origin.x, CGRectGetMaxY(frame) + narrow_height);
    self.frame = tableF;
    [vc.view addSubview:self];
    // 添加箭头
    // 设置箭头显示的初始位置
    self.narrowView.frame = [self setNarrowViewFrameWithTableFrame:tableF];
    [vc.view addSubview:self.narrowView];
    // 显示动画
    [UIView animateWithDuration:0.25f delay:0.f usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.dismissCover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
        CGRect tableF = self.frame;
        if (useHeight >= self.contentSize.height) {
            tableF.size.height = self.contentSize.height;
        }else {
            tableF.size.height = (self.selfHeight == 0 || self.selfHeight > useHeight) ? useHeight : self.selfHeight;
        }
        tableF.origin.y = tableF.origin.y + narrow_height;
        self.frame = tableF;
        self.narrowView.frame = [self setNarrowViewFrameWithTableFrame:tableF];
    } completion:^(BOOL finished) {
        // 确保在图层的最上层
        [vc.view bringSubviewToFront:self.narrowView];
        [vc.view bringSubviewToFront:self];
    }];
}

#pragma mark - 向上显示选择框
- (void)showSelectViewUpForward:(UIView *)target {
    if (self.isDisplayCoverView) {
        // 蒙层
        self.dismissCover.userInteractionEnabled = self.touchOutsideHide;
        self.dismissCover.frame = target.window.frame;
        [target.window addSubview:self.dismissCover];
    }
    
    CGRect frame = [target.superview convertRect:target.frame toView:target.window];
    // 计算target之上还有多少高度
    CGFloat useHeight = CGRectGetMaxY(frame) - frame.size.height - 15;
    
    CGRect tableF = self.frame;
    
    tableF.size.height = useHeight;
    tableF.size.width = frame.size.width+self.extraWidth;
    if (useHeight >= self.contentSize.height) {
        tableF.size.height = self.contentSize.height;
        tableF.origin = CGPointMake(frame.origin.x, useHeight - self.contentSize.height + narrow_height);
    }else {
        tableF.size.height = (self.selfHeight == 0 || self.selfHeight > useHeight) ? useHeight : self.selfHeight;
        tableF.origin = CGPointMake(frame.origin.x, narrow_height);
    }
    self.frame = tableF;
    [target.window addSubview:self];
    // 箭头
    self.narrowView.frame = [self setNarrowViewFrameWithTableFrame:tableF];
    [target.window addSubview:self.narrowView];
}

#pragma mark - 在window上 向下展示选择框
- (void)showSelectViewDownForwardOnWindow:(UIView *)target {
    // 蒙层
    if (self.isDisplayCoverView) {
        self.dismissCover.userInteractionEnabled = self.touchOutsideHide;
        self.dismissCover.frame = self.myWindow.frame;
        [self.myWindow addSubview:self.dismissCover];
        // 现在在图层最上层
        [self.myWindow bringSubviewToFront:self.dismissCover];
        [self.myWindow bringSubviewToFront:self];
    }
    
    CGRect frame = [target.superview convertRect:target.frame toView:target.window];
    // 计算targetview之下还有多少高度
    CGFloat useHeight = self.myWindow.bounds.size.height - CGRectGetMaxY(frame) - 15.f;
    
    CGRect tableF = self.frame;
    
    tableF.size.height = 0.f;
    tableF.size.width = frame.size.width+self.extraWidth;
    tableF.origin = CGPointMake(frame.origin.x, CGRectGetMaxY(frame) + narrow_height);
    self.frame = tableF;
    [self.myWindow addSubview:self];
    // 添加箭头
    // 设置箭头显示的初始位置
    self.narrowView.frame = [self setNarrowViewFrameWithTableFrame:tableF];
    [self.myWindow addSubview:self.narrowView];
    // 显示动画
    [UIView animateWithDuration:0.25f delay:0.f usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.dismissCover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
        CGRect tableF = self.frame;
        if (useHeight >= self.contentSize.height) {
            tableF.size.height = self.contentSize.height;
        }else {
            tableF.size.height = self.selfHeight == 0 || self.selfHeight > useHeight ? useHeight : self.selfHeight;
        }
        tableF.origin.y = tableF.origin.y + narrow_height;
        self.frame = tableF;
        self.narrowView.frame = [self setNarrowViewFrameWithTableFrame:tableF];
    } completion:^(BOOL finished) {
        // 确保在图层的最上层
        [self.myWindow bringSubviewToFront:self.narrowView];
        [self.myWindow bringSubviewToFront:self];
    }];
}

#pragma mark - 获取箭头的frame,并添加箭头
- (CGRect)setNarrowViewFrameWithTableFrame:(CGRect)tableF {
    CGFloat narrow_x = 0;
    switch (self.narrowLocation) {
        case CKNarrowLocationForRight:{// 右侧
            narrow_x = CGRectGetMaxX(tableF) - narrow_width - narrow_margin;
            break;
        }
        case CKNarrowLocationForLeft:{// 左侧
            narrow_x = tableF.origin.x + narrow_margin;
            break;
        }
        case CKNarrowLocationForCenter:{// 中间
            narrow_x = (tableF.origin.x + CGRectGetMaxX(tableF) - narrow_width) / 2.0;
            break;
        }
        default:
            break;
    }
    CGFloat narrow_y = _currDisplayForward == CKDisplayForwardForUp ? CGRectGetMaxY(tableF) : tableF.origin.y - narrow_height;
    return CGRectMake(narrow_x, narrow_y, narrow_width, narrow_height);
}

#pragma mark - btn的点击事件
- (void)coverClicked {
    [self hideWithAnimate:YES];
}

#pragma mark - 隐藏下拉框
- (void)hideWithAnimate:(BOOL)animate {
    switch (self.currDisplayForward) {
        case CKDisplayForwardForDown:{// 在当前控制器上 向下显示
            if (self.iskeyboardShow) {
                UIViewController *vc = [self getCurrentController:self.superview];
                if (vc) {
                    [vc.view endEditing:true];
                }
                return;
            }
            // 移除蒙层
            if (self.dismissCover.superview && self.dismissCover) {
                [self.dismissCover removeFromSuperview];
            }
            [UIView animateWithDuration:animate ? 0.25f : 0.f delay:0.f usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect tableF = self.frame;
                tableF.size.height = 0.f;
                self.frame = tableF;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [UIView animateWithDuration:animate?0.15f:0.f delay:0.f usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect narrowF = self.narrowView.frame;
                    narrowF.size.height = 0.f;
                    self.narrowView.frame = narrowF;
                } completion:^(BOOL finished) {
                    [self.narrowView removeFromSuperview];
                    self.dismissCover = nil;
                    self.narrowView = nil;
                }];
            }];
            break;
        }
        case CKDisplayForwardForUp:{// 在当前window上 向上显示
            // 移除蒙层
            if (self.datas.count > 0) {
                [self.window endEditing:true];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.narrowView.superview) {
                    [self.narrowView removeFromSuperview];
                }
                if (self.dismissCover.superview && self.dismissCover) {
                    [self.dismissCover removeFromSuperview];
                }
                if (self.superview) {
                    [self removeFromSuperview];
                }
                self.dismissCover = nil;
                self.narrowView = nil;
            });
            break;
        }
        case CKDisplayForwardForDownOnWindow:{// 在新的window上显示
            // 移除蒙层
            if (self.dismissCover.superview && self.dismissCover) {
                [self.dismissCover removeFromSuperview];
            }
            [UIView animateWithDuration:animate ? 0.25f : 0.f delay:0.f usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect tableF = self.frame;
                tableF.size.height = 0.f;
                self.frame = tableF;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [UIView animateWithDuration:animate?0.15f:0.f delay:0.f usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect narrowF = self.narrowView.frame;
                    narrowF.size.height = 0.f;
                    self.narrowView.frame = narrowF;
                } completion:^(BOOL finished) {
                    [self.narrowView removeFromSuperview];
                    self.narrowView = nil;
                    self.dismissCover = nil;
                    self.myWindow = nil;
                }];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CKSpinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:[CKSpinnerCell identifier]];
    // 获取点击的数据model
    id data = _datas[indexPath.row];
    // 设置数据
    if (self.cellForRowExtendBlock) {
        self.cellForRowExtendBlock(cell, data);
    }else {
        if ([data isKindOfClass:[NSString class]]) {
            cell.content = data;
        }else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"CKSpinner数据源必须为NSString或者为Model类型时，实现cellForRowExtendBlock方法" userInfo:nil];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_callback && indexPath.row < _datas.count) {
        self.iskeyboardShow = false;
        // 获取点击的数据model
        id data = _datas[indexPath.row];
        self.callback(indexPath, data);
    }
}

#pragma mark - 根据view获取最近的控制器
- (UIViewController *)getCurrentController:(UIView *)view {
    id target = view;
    //当target指向一个视图时
    while (target) {
        //通过响应链，可以获取其视图指向的视图控制器
        target = ((UIResponder *)target).nextResponder;
        //如果找到视图的控制器，即停止循环。
        if ([target isKindOfClass:[UIViewController class]]) {
            return target;
            break;
        }
    }
    return nil;
}

#pragma mark - Lazy load
- (UIButton *)dismissCover {
    if (!_dismissCover) {
        _dismissCover = [UIButton new];
        _dismissCover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_dismissCover addTarget:self action:@selector(coverClicked) forControlEvents:UIControlEventTouchUpInside];
        _dismissCover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _dismissCover;
}

- (CKSpinnerNarrowView *)narrowView {
    if (!_narrowView) {
        CKSpinnerNarrowForward narrowForward = CKSpinnerNarrowForwardForTop;
        switch (_currDisplayForward) {
            case CKDisplayForwardForUp:
                narrowForward = CKSpinnerNarrowForwardForBottom;
                break;
            case CKDisplayForwardForDown:
                narrowForward = CKSpinnerNarrowForwardForTop;
                break;
            default:
                break;
        }
        _narrowView = [[CKSpinnerNarrowView alloc] initWithFrame:CGRectMake(0, 0, narrow_width, narrow_height) narrowForward:narrowForward narrowColor:self.backgroundColor];
    }
    return _narrowView;
}

- (UIWindow *)myWindow {
    if (!_myWindow) {
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in windowScene.windows) {
                        // 隐藏的 或者 透明的 跳过
                        if (window.hidden == true || window.opaque == false) continue;
                        // 不是全屏的 跳过
                        if (!CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) continue;
                        _myWindow = window;
                        break;
                    }
                }
            }
//            NSArray <UIWindow *>*windows = [UIApplication sharedApplication].windows;
//            for (UIWindow *window in windows.reverseObjectEnumerator) {
//                // 隐藏的 或者 透明的 跳过
//                if (window.hidden == true || window.opaque == false) continue;
//                // 不是全屏的 跳过
//                if (!CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) continue;
//                _myWindow = window;
//                break;
//            }
            if (!_myWindow) {
                _myWindow = [UIApplication sharedApplication].delegate.window;
            }
        }else {
            _myWindow = [UIApplication sharedApplication].keyWindow;
        }
    }
    return _myWindow;
}

@end
