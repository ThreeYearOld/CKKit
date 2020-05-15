//
//  CKNarrowTextFieldView.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKNarrowTextFieldView : UIView

/** 输入框 */
@property (nonatomic, weak) UITextField * textField;

/** 是否为数字键盘 */
@property (nonatomic, assign) BOOL isNumericKeyboard;

/** 是否输入手机号 */
@property (nonatomic, assign) BOOL isInputPhone;

/** 是否隐藏向下箭头 */
@property (nonatomic, assign) BOOL isHidden;

/** 箭头点击的回调 */
@property (nonatomic, copy) void(^btnClickBlock)(UITextField *textField);

/** 设置图标以及size */
- (void)setNarrowImg:(NSString *)imgName imgSize:(CGSize)size;

@end

