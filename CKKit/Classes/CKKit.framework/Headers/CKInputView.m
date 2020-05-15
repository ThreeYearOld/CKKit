//
//  CKInputView.m
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import "CKInputView.h"
#import <Masonry.h>
#import "UIView+CKAdd.h"
#import "APNumberPad.h"
#import "UIColor+CKAdd.h"
#import "CKUitls.h"
#import "CKToolBar.h"


typedef NS_ENUM(NSInteger, CKInputViewWidthStatus) {
    /** 缺省值 */
    CKInputViewWidthDefault = -99,
};

@interface CKInputView() <APNumberPadDelegate>

/** 当前输入框的类型 */
@property (nonatomic, assign) CKInputViewType currentType;

/** 标题 */
@property (nonatomic, strong) UILabel * titleLabel;

/** 带边框的输入框 */
@property (nonatomic, strong) CKBorderTextField * borderTF;

/** 带边框的label */
@property (nonatomic, strong) CKBorderLabel * borderLabel;

/** 带向下箭头和边框的label */
@property (nonatomic, strong) CKDownwardView * downwardView;

/** 带向下箭头和边框的输入框 */
@property (nonatomic, strong) CKNarrowTextFieldView * narrowTF;

/** 删除btn */
@property (nonatomic, strong) UIButton * deleteBtn;

/** 当前的输入框 */
@property (nonatomic, weak) UIView * inputView;

/** 时间控件 */
@property (nonatomic, strong) UIDatePicker * datePicker;

/** 按钮 */
@property (nonatomic, strong) CKLayoutButton * selectBtn;

@end

@implementation CKInputView
@dynamic text;

- (instancetype)initWithTitle:(NSString *)title style:(CKInputViewType)style {
    if (self = [super init]) {
        self.indexTag = 0;
        self.isCanTap = true;
        _inputWidth = CKInputViewWidthDefault;
        _titleWidth = CKInputViewWidthDefault;
        _deleteBtnType = CKInputViewDeleteNone;
        _isIntegerInputOnly = false;
        // 确保所有的被移除界面
        [self removeAllSubviews];
        // 布局约束
        [self configUILayoutWithTitle:title type:style];
    }
    return self;
}

- (void)configUILayoutWithTitle:(NSString *)title type:(CKInputViewType)type {
    _currentType = type;
    __block UIView *view = nil;
    switch (type) {
        case CKInputViewTypeForLabel:{
            if (!_borderLabel.superview) {
                [self addSubview:self.borderLabel];
            }
            view = self.borderLabel;
            break;
        }
        case CKInputViewTypeForDownBorderLabel:{
            if (!_downwardView.superview) {
               [self addSubview:self.downwardView];
            }
            view = self.downwardView;
            break;
        }
        case CKInputViewTypeForTextField:{
            if (!_borderTF.superview) {
                [self addSubview:self.borderTF];
            }
            view = self.borderTF;
            break;
        }
        case CKInputViewTypeForDownTF:{
            if (!_narrowTF.superview) {
                [self addSubview:self.narrowTF];
            }
            view = self.narrowTF;
            break;
        }
        case CKInputViewTypeForButton:{
            if (!_selectBtn.superview) {
                [self addSubview:self.selectBtn];
            }
            view = self.selectBtn;
            break;
        }
        default:
            break;
    }
    if (view) {
        if (!_titleLabel.superview) {
            [self addSubview:self.titleLabel];
        }
        self.titleLabel.text = [NSString stringWithFormat:@"%@:",title];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
        }];
    }
    // 弱指针引用当前输入框
    self.inputView = view;
    if (type == CKInputViewTypeForTextField || type == CKInputViewTypeForDownTF) {
        // 在系统键盘上添加确认/取消按钮 - 仅仅是input是textField时，添加
        CKToolBar *toolbar = [self createToolBar];
        if (_borderTF) {
            _borderTF.inputAccessoryView = toolbar;
        }
        if (_narrowTF) {
            _narrowTF.textField.inputAccessoryView = toolbar;
        }
    }else {
        if (type == CKInputViewTypeForButton) return;
        __weak typeof(self) weakSelf = self;
        [view whenTapped:^{
            if (weakSelf.inputViewTapEventBlock) {
                weakSelf.inputViewTapEventBlock(weakSelf.inputView, weakSelf.indexTag);
            }
        }];
    }
}

/** 更新输入框类型 */
- (void)updateInputStyle:(CKInputViewType)style {
    _currentType = style;
    if (_inputView) {
        [_inputView removeFromSuperview];
    }
    __block UIView *view = nil;
    switch (style) {
        case CKInputViewTypeForLabel:{
            if (!_borderLabel.superview) {
                [self addSubview:self.borderLabel];
            }
            view = self.borderLabel;
            break;
        }
        case CKInputViewTypeForDownBorderLabel:{
            if (!_downwardView.superview) {
               [self addSubview:self.downwardView];
            }
            view = self.downwardView;
            break;
        }
        case CKInputViewTypeForTextField:{
            if (!_borderTF.superview) {
                [self addSubview:self.borderTF];
            }
            view = self.borderTF;
            break;
        }
        case CKInputViewTypeForDownTF:{
            if (!_narrowTF.superview) {
                [self addSubview:self.narrowTF];
            }
            view = self.narrowTF;
            break;
        }
        case CKInputViewTypeForButton:{
            if (!_selectBtn.superview) {
                [self addSubview:self.selectBtn];
            }
            view = self.selectBtn;
            break;
        }
        default:
            break;
    }
    if (view) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
        }];
    }
    // 弱指针引用当前输入框
    self.inputView = view;
    if (style == CKInputViewTypeForTextField || style == CKInputViewTypeForDownTF) {
        // 在系统键盘上添加确认/取消按钮 - 仅仅是input是textField时，添加
        CKToolBar *toolbar = [self createToolBar];
        if (_borderTF) {
            _borderTF.inputAccessoryView = toolbar;
        }
        if (_narrowTF) {
            _narrowTF.textField.inputAccessoryView = toolbar;
        }
    }else {
        if (style == CKInputViewTypeForButton) return;
        __weak typeof(self) weakSelf = self;
        [view whenTapped:^{
            if (weakSelf.inputViewTapEventBlock) {
                weakSelf.inputViewTapEventBlock(weakSelf.inputView, weakSelf.indexTag);
            }
        }];
    }
}

#pragma mark - 设置输入框textField的占位符和占位符的颜色
- (void)setTextFieldPlaceholder:(NSString *)placeholder
               placeholderColor:(UIColor *)color
                placeholderFont:(UIFont *)font
              isShowBorderColor:(BOOL)isShow {
    // 属性字符串
    NSAttributedString *attPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
    switch (_currentType) {
        case CKInputViewTypeForDownBorderLabel:{
            _downwardView.attributedPlaceholder = attPlaceholder;
            if (isShow) {
                _downwardView.layer.borderColor = color == [UIColor clearColor] ? [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor : color.CGColor;
                _downwardView.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
            }
            break;
        }
        case CKInputViewTypeForLabel:{
            _borderLabel.attributedPlaceholder = attPlaceholder;
            if (isShow) {
                _borderLabel.layer.borderColor = color == [UIColor clearColor] ? [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor : color.CGColor;
                _borderLabel.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
            }
            break;
        }
        case CKInputViewTypeForTextField:{
            _borderTF.attributedPlaceholder = attPlaceholder;
            if (isShow) {
                _borderTF.layer.borderColor = color == [UIColor clearColor] ? [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor : color.CGColor;
                _borderTF.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
            }
            break;
        }
        case CKInputViewTypeForDownTF:{
            _narrowTF.textField.attributedPlaceholder = attPlaceholder;
            if (isShow) {
                _narrowTF.layer.borderColor = color == [UIColor clearColor] ? [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor : color.CGColor;
                _narrowTF.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - 当输入框是textField时，设置键盘的类型
- (void)setKeyboardType:(CKKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    if (_currentType == CKInputViewTypeForDownBorderLabel || _currentType == CKInputViewTypeForLabel) {
        return;
    }
    switch (keyboardType) {
        case CKKeyboardTypeForChinese:{// 中文键盘
            if (_currentType == CKInputViewTypeForTextField && _borderTF) {
                _borderTF.keyboardType = UIKeyboardTypeDefault;
            }else if (_currentType == CKInputViewTypeForDownTF && _narrowTF) {
                _narrowTF.textField.keyboardType = UIKeyboardTypeDefault;
            }
            break;
        }
        case CKKeyboardTypeForEnglish:{// 英文键盘
            if (_currentType == CKInputViewTypeForTextField && _borderTF) {
                _borderTF.keyboardType = UIKeyboardTypeURL;
            }else if (_currentType == CKInputViewTypeForDownTF && _narrowTF) {
                _narrowTF.textField.keyboardType = UIKeyboardTypeURL;
            }
            break;
        }
        case CKKeyboardTypeForNumeric:{// 数字键盘
            if (_currentType == CKInputViewTypeForTextField && _borderTF) {
                _borderTF.isNumericKeyboard = true;
                _borderTF.inputView = ({
                    APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
                    [numberPad.leftFunctionButton setTitle:@"." forState:UIControlStateNormal];
                    numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                    numberPad;
                });
            }else if (_currentType == CKInputViewTypeForDownTF && _narrowTF) {
                _narrowTF.isNumericKeyboard = true;
                _narrowTF.textField.inputView = ({
                    APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
                    [numberPad.leftFunctionButton setTitle:@"." forState:UIControlStateNormal];
                    numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                    numberPad;
                });
            }
            break;
        }
        case CKKeyboardTypeForDateTime:{// 日期时间键盘
            if (_currentType == CKInputViewTypeForTextField && _borderTF) {
                _borderTF.inputView = self.datePicker;
            }else if (_currentType == CKInputViewTypeForDownTF && _narrowTF) {
                _narrowTF.textField.inputView = self.datePicker;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - 当输入框带有图标时，设置图标
- (void)setNarrowImgName:(NSString *)narrowImgName {
    _narrowImgName = narrowImgName;
    switch (_currentType) {
        case CKInputViewTypeForDownTF:{
            [_narrowTF setNarrowImg:narrowImgName imgSize:CGSizeMake(25, 25)];
            __weak typeof(self) weakSelf = self;
            _narrowTF.btnClickBlock = ^(UITextField *textField) {
                [weakSelf.narrowTF.textField becomeFirstResponder];
            };
            break;
        }
        case CKInputViewTypeForDownBorderLabel:{
            [_downwardView setNarrowImg:narrowImgName imgSize:CGSizeMake(25, 25)];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 设置删除btn的类型
- (void)setDeleteBtnType:(CKInputViewDeleteType)deleteBtnType {
    // 如果为只能，删除btn的状态只能是不显示
    if (_isShowOnly) {
        deleteBtnType = CKInputViewDeleteNone;
    }
    _deleteBtnType = deleteBtnType;
    if (!self.userInteractionEnabled) return;
    UIView *view = nil;
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            view = _borderLabel;
            break;
        case CKInputViewTypeForDownBorderLabel:
            view = _downwardView;
            break;
        default:
            break;
    }
    if (!view) return;
    switch (deleteBtnType) {
        case CKInputViewDeleteNone:{// 不显示
            [self removeDeleteBtnWithInputView:view];
            break;
        }
        case CKInputViewDeleteShowAlways:{// 一直显示
            [self addDeleteBtnWithInputView:view];
            break;
        }
        case CKInputViewDeleteShowWhenEditing:{// 当有值的显示
            if (self.text.length > 0) {
                [self addDeleteBtnWithInputView:view];
            }
            break;
        }
        default:
            break;
    }
}

- (void)setIsShowOnly:(BOOL)isShowOnly {
    _isShowOnly = isShowOnly;
    if (isShowOnly) {
        self.deleteBtnType = CKInputViewDeleteNone;
    }
    switch (_currentType) {
        case CKInputViewTypeForDownBorderLabel:{
            _downwardView.layer.borderColor = isShowOnly ? [UIColor clearColor].CGColor : [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor;
            _downwardView.isHidden = isShowOnly;
            break;
        }
        case CKInputViewTypeForLabel:{
            _borderLabel.layer.borderColor = isShowOnly ? [UIColor clearColor].CGColor : [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor;
            break;
        }
        case CKInputViewTypeForTextField:{
            _borderTF.layer.borderColor = isShowOnly ? [UIColor clearColor].CGColor : [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor;
            break;
        }
        case CKInputViewTypeForDownTF:{
            _narrowTF.layer.borderColor = isShowOnly ? [UIColor clearColor].CGColor : [UIColor ck_colorWithHexString:@"#d2d5e0"].CGColor;
            _narrowTF.isHidden = isShowOnly;
            break;
        }
        default:
            break;
    }
    self.userInteractionEnabled = !isShowOnly;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    switch (_currentType) {
        case CKInputViewTypeForDownBorderLabel:{
            _downwardView.textAligment = textAlignment;
            break;
        }
        case CKInputViewTypeForLabel:{
            _borderLabel.textAlignment = textAlignment;
            break;
        }
        case CKInputViewTypeForTextField:{
            _borderTF.textAlignment = textAlignment;
            break;
        }
        case CKInputViewTypeForDownTF:{
            _narrowTF.textField.textAlignment = textAlignment;
            break;
        }
        default:
            break;
    }
}

#pragma mark - 删除事件
- (void)deleteBtnClickAction {
    self.text = @"";
    if (self.clearValueBlock) {
        self.clearValueBlock();
    }
}

#pragma mark - APNumberPadDelegate
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    if (!_isIntegerInputOnly) {
        [textInput insertText:@"."];
    }
}

#pragma mark - 当输入框是TextField，且数字键盘时，是否输入电话、手机号
- (void)setIsInputPhone:(BOOL)isInputPhone {
    if (_keyboardType == CKKeyboardTypeForNumeric) {
        if (_currentType == CKInputViewTypeForDownTF) {
            _narrowTF.isInputPhone = isInputPhone;
        }else if (_currentType == CKInputViewTypeForTextField) {
            _borderTF.isInputPhone = isInputPhone;
        }
    }
}

#pragma mark - 当输入框是TextField时，设置textField的代理
- (void)setMyDelegate:(id)myDelegate {
    if (_currentType == CKInputViewTypeForDownBorderLabel || _currentType == CKInputViewTypeForLabel) {
        return;
    }
    _myDelegate = myDelegate;
    if (_currentType == CKInputViewTypeForTextField && _borderTF) {
        _borderTF.delegate = myDelegate;
    }else if (_currentType == CKInputViewTypeForDownTF && _narrowTF) {
        _narrowTF.textField.delegate = myDelegate;
    }
}

#pragma mark - 设置输入框字体加粗的字体
- (void)setTextBoldFont:(CGFloat)textBoldFont {
    // 标题不需要加粗
    self.titleLabel.font = [UIFont systemFontOfSize:textBoldFont];
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            _borderLabel.font = [UIFont boldSystemFontOfSize:textBoldFont];
            break;
        case CKInputViewTypeForDownBorderLabel:
            _downwardView.font = [UIFont boldSystemFontOfSize:textBoldFont];
            break;
        case CKInputViewTypeForTextField:
            _borderTF.font = [UIFont boldSystemFontOfSize:textBoldFont];
            break;
        case CKInputViewTypeForDownTF:
            _narrowTF.textField.font = [UIFont boldSystemFontOfSize:textBoldFont];
            break;
        default:
            break;
    }
}

#pragma mark - 设置输入框的背景颜色
- (void)setInputBgColor:(UIColor *)inputBgColor {
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            _borderLabel.backgroundColor = inputBgColor;
            break;
        case CKInputViewTypeForDownBorderLabel:
            _downwardView.backgroundColor = inputBgColor;
            break;
        case CKInputViewTypeForTextField:
            _borderTF.backgroundColor = inputBgColor;
            break;
        case CKInputViewTypeForDownTF:
            _narrowTF.textField.backgroundColor = inputBgColor;
            break;
        case CKInputViewTypeForButton:
            [_selectBtn setBackgroundColor:inputBgColor];
            break;
        default:
            break;
    }
}

#pragma mark - 设置输入框的字体颜色
- (void)setTextColor:(UIColor *)textColor {
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            _borderLabel.textColor = textColor;
            break;
        case CKInputViewTypeForDownBorderLabel:
            _downwardView.textColor = textColor;
            break;
        case CKInputViewTypeForTextField:
            _borderTF.textColor = textColor;
            break;
        case CKInputViewTypeForDownTF:
            _narrowTF.textField.textColor = textColor;
            break;
        default:
            break;
    }
}

#pragma mark - 获取当前的输入框类型对应的对象
- (id)inputObject {
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            return _borderLabel;
        case CKInputViewTypeForDownBorderLabel:
            return _downwardView;
        case CKInputViewTypeForTextField:
            return _borderTF;
        case CKInputViewTypeForDownTF:
            return _narrowTF;
        case CKInputViewTypeForButton:
            return _selectBtn;
        default:
            break;
    }
}

#pragma mark - 获取当前textField是否获取焦点
- (BOOL)getFirstResponse {
    BOOL response = false;
    switch (_currentType) {
        case CKInputViewTypeForTextField:{
            response = _borderTF.isFirstResponder;
            break;
        }
        case CKInputViewTypeForDownTF:{
            response = _narrowTF.textField.isFirstResponder;
            break;
        }
        default:
            break;
    }
    return response;
}

#pragma mark - 添加或移除tap事件
- (void)setIsCanTap:(BOOL)isCanTap {
    if (!isCanTap) {
        // 移除tap事件
        for (UIGestureRecognizer* gesture in [self.inputView gestureRecognizers]) {
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*)gesture;
                [self.inputView removeGestureRecognizer:tapGesture];
            }
        }
    }
}

#pragma mark - 扩展功能的方法# 输入框为按钮时，设置未选中和选中的icon
- (void)updateInputBtnWithNormalImage:(NSString *)normalImage
                        selectedImage:(NSString *)selectedImage
                           imageWidth:(CGFloat)imageWidth
                          imageHeight:(CGFloat)imageHeight {
    if (_currentType == CKInputViewTypeForButton && _selectBtn) {
        [_selectBtn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
        _selectBtn.imageSize = CGSizeMake(imageWidth, imageHeight);
    }
}

#pragma mark - UIToolBarActions
- (void)confirmActionEvent {
    if (_keyboardType == CKKeyboardTypeForDateTime) {
        NSDate *datePicker = [self.datePicker date];
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        // 当前选中的日期时间
        NSString *dateStr = [pickerFormatter stringFromDate:datePicker];
        if (self.inputViewSelectDateEventBlock) {
            if (!self.inputViewSelectDateEventBlock(dateStr, self)) {
                return;
            }
        }
        if (_currentType == CKInputViewTypeForTextField && _borderTF) {
            _borderTF.text = dateStr;
        }else if (_currentType == CKInputViewTypeForDownTF && _narrowTF) {
            _narrowTF.textField.text = dateStr;
        }
    }else if (_keyboardType == CKKeyboardTypeForNumeric) {
        if (self.numericSureUpdateBlock) {
            self.numericSureUpdateBlock(self);
        }
    }
    // 结束编辑
    [self endEditing:true];
}

- (void)cancelActionEvent {
    if (_keyboardType == CKKeyboardTypeForNumeric) {
        if (self.numericCancelUpdateBlock) {
            self.numericCancelUpdateBlock(self);
        }
    }
    // 结束编辑
    [self endEditing:true];
}

#pragma mark - override setter 设置值
- (void)setText:(NSString *)text {
    UIView *view = nil;
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            _borderLabel.text = text;
            view = _borderLabel;
            break;
        case CKInputViewTypeForDownBorderLabel:
            _downwardView.text = text;
            view = _downwardView;
            break;
        case CKInputViewTypeForTextField:
            _borderTF.text = text;
            break;
        case CKInputViewTypeForDownTF:
            _narrowTF.textField.text = text;
            break;
        case CKInputViewTypeForButton:
            _selectBtn.selected = [text isEqualToString:@"是"];
            return;
        default:
            break;
    }
    if (!self.userInteractionEnabled) return;
    if (!view) return;
    if (_deleteBtnType == CKInputViewDeleteShowWhenEditing) {
        if (text.length == 0) {
            if (_deleteBtn.superview) {
                [_deleteBtn removeFromSuperview];
            }
            if (_titleWidth > 0) {
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.bottom.equalTo(self);
                    make.left.equalTo(self.titleLabel.mas_right).offset(8);
                }];
            }else if (_inputWidth > 0) {
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.bottom.equalTo(self);
                    make.left.equalTo(self.titleLabel.mas_right).offset(8);
                    make.width.mas_equalTo(self.inputWidth);
                }];
            }else {
                if (_titleWidth == 0 && _inputWidth == CKInputViewWidthDefault) {
                    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.bottom.right.equalTo(self);
                    }];
                }
            }
        }else {
            [self addDeleteBtnWithInputView:view];
        }
    }
}

#pragma mark - 添加deleteBtn
- (void)addDeleteBtnWithInputView:(UIView *)view {
    if (!_deleteBtn || !_deleteBtn.superview) {
        [self addSubview:self.deleteBtn];
    }
    [_deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    if (_titleWidth > 0) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.right.equalTo(self.deleteBtn.mas_left).offset(-2);
        }];
    }else if (_inputWidth > 0) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.inputWidth);
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.right.equalTo(self.deleteBtn.mas_left).offset(-2);
        }];
    }else {
        if (_titleWidth == 0 && _inputWidth == CKInputViewWidthDefault) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.right.equalTo(self.deleteBtn.mas_left).offset(-2);
            }];
        }
    }
}

#pragma mark - 移除deleteBtn
- (void)removeDeleteBtnWithInputView:(UIView *)view {
    if (_deleteBtn.superview) {
        [_deleteBtn removeFromSuperview];
    }
    if (_titleWidth > 0) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.right.equalTo(self.mas_right);
        }];
    }else if (_inputWidth > 0) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.inputWidth);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
        }];
    }else {
        if (_titleWidth == 0 && _inputWidth == CKInputViewWidthDefault) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.right.equalTo(self);
            }];
        }
    }
}

#pragma mark - override getter 获取值
- (NSString *)text {
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            return _borderLabel.text;
            break;
        case CKInputViewTypeForDownBorderLabel:
            return _downwardView.text;
            break;
        case CKInputViewTypeForTextField:
            return _borderTF.text;
            break;
        case CKInputViewTypeForDownTF:
            return _narrowTF.textField.text;
            break;
        case CKInputViewTypeForButton:
            return _selectBtn.selected ? @"是" : @"否";
        default:
            break;
    }
    return @"";
}

#pragma mark - 设置输入框的宽度
- (void)setInputWidth:(CGFloat)inputWidth {
    if (inputWidth < 0) {
        inputWidth = 0;
    }
    _inputWidth = inputWidth;
    _titleWidth = CKInputViewWidthDefault;
    UIView *view = nil;
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            view = _borderLabel;
            break;
        case CKInputViewTypeForDownBorderLabel:
            view = _downwardView;
            break;
        case CKInputViewTypeForTextField:
            view = _borderTF;
            break;
        case CKInputViewTypeForDownTF:
            view = _narrowTF;
            break;
        case CKInputViewTypeForButton:
            view = _selectBtn;
            break;
        default:
            break;
    }
    if (view) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(inputWidth);
        }];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(view.mas_left).offset(-8);
        }];
    }
}

- (void)setTitleWidth:(CGFloat)titleWidth {
    // _inputWidth 优先级 高于 _titleWidth
    if (_inputWidth >= 0) {
        _titleWidth = CKInputViewWidthDefault;
        return;
    }
    if (titleWidth < 0) {
        titleWidth = 0;
    }
    _titleWidth = titleWidth;
    UIView *view = nil;
    switch (_currentType) {
        case CKInputViewTypeForLabel:
            view = _borderLabel;
            break;
        case CKInputViewTypeForDownBorderLabel:
            view = _downwardView;
            break;
        case CKInputViewTypeForTextField:
            view = _borderTF;
            break;
        case CKInputViewTypeForDownTF:
            view = _narrowTF;
            break;
        case CKInputViewTypeForButton:
            view = _selectBtn;
            break;
        default:
            break;
    }
    if (view) {
        if (titleWidth == 0) {
            if (self.titleLabel.superview) {
                [self.titleLabel removeFromSuperview];
            }
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self);
            }];
        }else {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self);
            }];
            if (!self.titleLabel.superview) {
                [self addSubview:self.titleLabel];
            }
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.mas_equalTo(titleWidth);
                make.right.equalTo(view.mas_left).offset(-8);
            }];
        }
    }
}

#pragma mark - btn点击
- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.inputIsBtnClickBlock) {
        self.inputIsBtnClickBlock(sender.selected);
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

#pragma mark - prviate method
- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *lb = [CKUitls ck_createLabelWithTitle:title
                                          withFont:16.0
                                         withColor:@"#333333"];
    lb.textAlignment = NSTextAlignmentRight;
    return lb;
}

- (CKToolBar *)createToolBar {
    CKToolBar *toolBar = [[CKToolBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    __weak typeof(self) weakSelf = self;
    toolBar.cancelActionBlock = ^{
        [weakSelf cancelActionEvent];
    };
    toolBar.confirmActionBlock = ^{
        [weakSelf confirmActionEvent];
    };
    return toolBar;
}

#pragma mark - Lazy load
- (CKBorderTextField *)borderTF {
    if (!_borderTF) {
        _borderTF = [[CKBorderTextField alloc] init];
        _borderTF.font = [UIFont systemFontOfSize:16];
        _borderTF.textColor = [UIColor grayColor];
        _borderTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _borderTF;
}

- (CKDownwardView *)downwardView {
    if (!_downwardView) {
        _downwardView = [[CKDownwardView alloc] init];
    }
    return _downwardView;
}

- (CKNarrowTextFieldView *)narrowTF {
    if (!_narrowTF) {
        _narrowTF = [[CKNarrowTextFieldView alloc] init];
        _narrowTF.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _narrowTF;
}

- (CKBorderLabel *)borderLabel {
    if (!_borderLabel) {
        _borderLabel = [[CKBorderLabel alloc] init];
    }
    return _borderLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self createLabelWithTitle:@""];
    }
    return _titleLabel;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(100, 100, 400, 300)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        // 设置为中文显示
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _datePicker;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"Sources.bundle/images/sc_03.png"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (CKLayoutButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[CKLayoutButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"Sources.bundle/images/icon_changeTable_off.png"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"Sources.bundle/images/icon_changeTable_on.png"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.imageSize = CGSizeMake(51.0/31.0*25.0, 25.0);
    }
    return _selectBtn;
}

@end
