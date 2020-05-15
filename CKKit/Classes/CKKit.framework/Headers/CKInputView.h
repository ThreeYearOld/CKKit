//
//  CKInputView.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKNarrowTextFieldView.h"
#import "CKDownwardView.h"
#import "CKBorderTextField.h"
#import "CKBorderLabel.h"
#import "CKLayoutButton.h"

typedef NS_ENUM(NSInteger, CKInputViewType) {
    /** 输入框是带边框的label */
    CKInputViewTypeForLabel = 100,
    /** 输入框是label带边框和向下的箭头 */
    CKInputViewTypeForDownBorderLabel,
    /** 输入框是带边框的textField */
    CKInputViewTypeForTextField,
    /** 输入框是带边框和向下箭头的textField */
    CKInputViewTypeForDownTF,
    /** 输入框为按钮 */
    CKInputViewTypeForButton
};

typedef NS_ENUM(NSInteger, CKKeyboardType) {
    /** 数字键盘 */
    CKKeyboardTypeForNumeric = 200,
    /** 中文键盘 */
    CKKeyboardTypeForChinese,
    /** 字母键盘 */
    CKKeyboardTypeForEnglish,
    /** 日期时间键盘 */
    CKKeyboardTypeForDateTime
};

typedef NS_ENUM(NSInteger, CKInputViewDeleteType) {
    /** 不显示 */
    CKInputViewDeleteNone = 300,
    /** 当有值才显示 */
    CKInputViewDeleteShowWhenEditing,
    /** 一直显示 */
    CKInputViewDeleteShowAlways
};

@interface CKInputView : UIView

/** 输入框当前的值 */
@property (nonatomic, copy) NSString * text;

/** tag标记 */
@property (nonatomic, assign) NSInteger indexTag;

/** 获取当前输入框的对象 */
@property (nonatomic, weak, readonly) id inputObject;

/** 获取当前的textField是否获取焦点 */
@property (nonatomic, assign, readonly) BOOL getFirstResponse;

/**
 * 点击事件回调
 * @param view 输入框
 * @param tag 编号id
 */
@property (nonatomic, copy) void(^inputViewTapEventBlock)(UIView *view, NSInteger tag);

/** 当选择日期时间时的block */
@property (nonatomic, copy) BOOL(^inputViewSelectDateEventBlock)(NSString *dateStr, CKInputView *inputView);

/** 数字键盘输入点击确定的block */
@property (nonatomic, copy) void(^numericSureUpdateBlock)(CKInputView *inputView);

/** 数字键盘输入点击确定的block */
@property (nonatomic, copy) void(^numericCancelUpdateBlock)(CKInputView *inputView);

/** 清除输入框值的回调block */
@property (nonatomic, copy) void(^clearValueBlock)(void);

/** 输入框为按钮时，点击按钮的block */
@property (nonatomic, copy) void(^inputIsBtnClickBlock)(BOOL isSelect);

/** 初始化 */
- (instancetype)initWithTitle:(NSString *)title style:(CKInputViewType)style;

/** 更新输入框类型 */
- (void)updateInputStyle:(CKInputViewType)style;

#pragma mark - 以下为扩展属性，以满足不同需求
/**
 * #扩展功能的属性 - 可不设置# 用于修改输入框的宽度
 * 当同时设置 inputWidth 和 titleWidth 时，inputWidth优先级高，titleWidth重置为0 ，title宽度自适应
 */
@property (nonatomic, assign) CGFloat titleWidth;

/** #扩展功能的属性 - 可不设置# 用于修改输入框的宽度 */
@property (nonatomic, assign) CGFloat inputWidth;

/** #扩展功能的属性 - 可不设置# 输入框的背景颜色 - 默认透明 */
@property (nonatomic, strong) UIColor * inputBgColor;

/** #扩展功能的属性 - 可不设置# 设置输入框字体的颜色 */
@property (nonatomic, strong) UIColor * textColor;

/** #扩展功能的属性 - 可不设置# 设置输入框加粗的字体大小 - 默认正常字体16 */
@property (nonatomic, assign) CGFloat textBoldFont;

/** #扩展功能的属性 - 可不设置# 设置输入框是否可以被点击 - 默认可以点击 */
@property (nonatomic, assign) BOOL isCanTap;

/** #扩展功能的属性 - 可不设置# 非textField时，是否显示删除按钮 - 默认不显示 */
@property (nonatomic, assign) CKInputViewDeleteType deleteBtnType;

/** #扩展功能的属性 - 可不设置# 当输入框是TextField时，可以设置键盘的类型 */
@property (nonatomic, assign) CKKeyboardType keyboardType;

/** #扩展功能的属性 - 可不设置# 当输入框带有图标时，设置图标 */
@property (nonatomic, copy) NSString * narrowImgName;

/** #扩展功能的属性 - 可不设置# 当输入框是TextField时，设置textField的代理 */
@property (nonatomic, weak) id <UITextFieldDelegate> myDelegate;

/** #扩展功能的属性 - 可不设置# 当输入框是TextField且为数字键盘时，输入类型是否为手机、电话 */
@property (nonatomic, assign) BOOL isInputPhone;

/** #扩展功能的属性 - 可不设置# 当输入框是TextField且为数字键盘时，是否只能为整数，默认可以输入小数 */
@property (nonatomic, assign) BOOL isIntegerInputOnly;

/** #扩展功能的属性 - 可不设置# 设置为只读时，边框和向下的箭头隐藏 */
@property (nonatomic, assign) BOOL isShowOnly;

/** #扩展功能的属性 - 可不设置# 设置文字的对齐方式，默认左对齐 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/** #扩展功能的方法# 设置输入框textField的占位符和占位符的颜色 */
- (void)setTextFieldPlaceholder:(NSString *)placeholder
               placeholderColor:(UIColor *)color
                placeholderFont:(UIFont *)font
              isShowBorderColor:(BOOL)isShow;

/** #扩展功能的方法# 输入框为按钮时，设置未选中和选中的icon */
- (void)updateInputBtnWithNormalImage:(NSString *)normalImage
                        selectedImage:(NSString *)selectedImage
                           imageWidth:(CGFloat)imageWidth
                          imageHeight:(CGFloat)imageHeight;

@end

