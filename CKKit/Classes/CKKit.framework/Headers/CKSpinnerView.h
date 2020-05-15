//
//  CKSpinnerView.h
//  CKKit
//
//  Created by admin on 2019/12/16.
//  Copyright © 2019 Chengkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSpinnerCell.h"

typedef NS_ENUM(NSInteger, CKDisplayForward) {
    CKDisplayForwardForUp = 1,            // 在当前控制器向上展示
    CKDisplayForwardForDown = 2,          // 在当前控制器向下展示
    CKDisplayForwardForDownOnWindow = 3   // 在window上向下展示,仅在ios13以下使用有效
};

typedef NS_ENUM(NSInteger, CKNarrowLocation) {
    CKNarrowLocationForRight = 1,      // 箭头在右侧
    CKNarrowLocationForLeft = 2,       // 箭头在左侧
    CKNarrowLocationForCenter = 3      // 箭头在中间
};


@interface CKSpinnerView : UITableView <UITableViewDataSource, UITableViewDelegate>

/** 数据模型，Model或者NSString */
@property (nonatomic, strong) NSArray *datas;

/** 默认选中的序号 */
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

/** 点击dim是否消失 */
@property (nonatomic, assign) BOOL touchOutsideHide;

/** 是否显示蒙层 - 默认显示 */
@property (nonatomic, assign) BOOL isDisplayCoverView;

/** 箭头的位置 - 默认在右侧 */
@property (nonatomic, assign) CKNarrowLocation narrowLocation;

/** 是否增加展示的宽度 */
@property (nonatomic, assign) CGFloat extraWidth;

/** 自定义下拉框的高度 - 高度为 0 时，高度自适应屏幕可视区域 */
@property (nonatomic, assign) CGFloat selfHeight;

/** 键盘是否显示 - 如果键盘显示，第一次点击干掉键盘，第二次干掉所有 */
@property (nonatomic, assign) BOOL iskeyboardShow;

/** 点击时的回掉 */
@property (nonatomic, copy) void(^callback)(NSIndexPath *index, id model);

/** cellForRowAtIndexPath 方法执行时 扩展block */
@property (nonatomic, copy) void(^cellForRowExtendBlock)(CKSpinnerCell *cell, id model);

/**
 *  spinnerView显示在哪个view下面
 *  @param target 显示在目标的view下面，并且宽度和目标View等宽。
 */
- (void)showBelowWith:(UIView *)target displayForward:(CKDisplayForward)forward;

/**
 *  隐藏spinnerView
 *  @param animate 动画
 */
- (void)hideWithAnimate:(BOOL)animate;

@end

