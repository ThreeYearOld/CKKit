//
//  CKLayoutButton.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CKLayoutButtonStyle) {
    CKLayoutButtonStyleLeftImageRightTitle,
    CKLayoutButtonStyleLeftTitleRightImage,
    CKLayoutButtonStyleUpImageDownTitle,
    CKLayoutButtonStyleUpTitleDownImage,
    CKLayoutButtonStyleBothCenter
};

@interface CKLayoutButton : UIButton

/** 布局方式 */
@property (nonatomic, assign) CKLayoutButtonStyle layoutStyle;

/** 图片和文字的间距，默认值8 */
@property (nonatomic, assign) CGFloat midSpacing;

/** 指定图片size - 设置最好在设置btn的frame之前，否则会有约束冲突 */
@property (nonatomic) CGSize imageSize;

/** 右上角数字 */
@property (nonatomic, copy) NSString * badgeStr;

/** 右上角数字背景的size */
@property (nonatomic, assign) CGFloat badgeSize;

/** 右上角数字的font */
@property (nonatomic, assign) CGFloat badgeFont;

/** 水平方向移动距离 正数 - 向右 ，负数 - 向左 */
@property (nonatomic, assign) CGFloat badgeHorOffset;

/** 垂直方向移动距离 正数 - 向下 ，负数 - 向上 */
@property (nonatomic, assign) CGFloat badgeVerOffset;

@end

