# CKKit

[![CI Status](https://img.shields.io/travis/13035155560@163.com/CKKit.svg?style=flat)](https://travis-ci.org/13035155560@163.com/CKKit)
[![Version](https://img.shields.io/cocoapods/v/CKKit.svg?style=flat)](https://cocoapods.org/pods/CKKit)
[![License](https://img.shields.io/cocoapods/l/CKKit.svg?style=flat)](https://cocoapods.org/pods/CKKit)
[![Platform](https://img.shields.io/cocoapods/p/CKKit.svg?style=flat)](https://cocoapods.org/pods/CKKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CKKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CKKit'
```
## 使用说明

CKInputView：
1.自定义输入框，包含title，输入框类型有label 、带向下箭头的label、textField、带向下箭头的textField、button
```
/** 初始化 */
- (instancetype)initWithTitle:(NSString *)title style:(CKInputViewType)style;
如：
CKInputView *input = [[CKInputView alloc] initWithTitle:@"测试" style:CKInputViewTypeForTextField];
CKInputViewType 枚举有以下类型：
/** 输入框是带边框的label */
CKInputViewTypeForLabel
/** 输入框是label带边框和向下的箭头 */
CKInputViewTypeForDownBorderLabel
/** 输入框是带边框的textField */
CKInputViewTypeForTextField
/** 输入框是带边框和向下箭头的textField */
CKInputViewTypeForDownTF
/** 输入框为按钮 */
CKInputViewTypeForButton

```
2.输入框，键盘类型可设置和删除按钮的模式可设置
```
/** #扩展功能的属性 - 可不设置# 当输入框是TextField时，可以设置键盘的类型 */
@property (nonatomic, assign) CKKeyboardType keyboardType;
CKKeyboardType 枚举以下类型：
/** 数字键盘 */
CKKeyboardTypeForNumeric
/** 中文键盘 */
CKKeyboardTypeForChinese
/** 字母键盘 */
CKKeyboardTypeForEnglish
/** 日期时间键盘 */
CKKeyboardTypeForDateTime

/** #扩展功能的属性 - 可不设置# 非textField时，是否显示删除按钮 - 默认不显示 */
@property (nonatomic, assign) CKInputViewDeleteType deleteBtnType;
CKInputViewDeleteType 枚举以下类型：
/** 不显示 */
CKInputViewDeleteNone
/** 当有值才显示 */
CKInputViewDeleteShowWhenEditing
/** 一直显示 */
CKInputViewDeleteShowAlways
```
CKSpinnerView：下拉框
```
__weak typeof(self) weakSelf = self;
// 支持传入model对象，当传model对象时，对应的点击时，也是model
self.spinnerView.cellForRowExtendBlock = ^(CKSpinnerCell *cell, id model) {
    cell.content = model.
}
// 点击事件回调
self.spinnerView.callback = ^(NSIndexPath *index, id model) {
   [weakSelf.spinnerView hideWithAnimate:true];
   input.text = model;
};
// 刷新数据源
self.spinnerView.datas = @[@"测试1",@"测试2",@"测试三"];
[self.spinnerView showBelowWith:input displayForward:CKDisplayForwardForDownOnWindow];
```

## License

CKKit is available under the MIT license. See the LICENSE file for more info.
