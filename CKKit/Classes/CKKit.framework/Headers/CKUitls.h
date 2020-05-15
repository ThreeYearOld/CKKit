//
//  CKUitls.h
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKLayoutButton.h"


@interface CKUitls : NSObject

/** 根据view获取最近的控制器 */
+ (UIViewController *)ck_getCurrentController:(UIView *)view;

/** 从rootController获取当前的控制器 */
+ (UIViewController *)ck_getCurrentController;

/** 显示弹框 */
+ (void)ck_showAlertViewWithTitle:(NSString *)title
                          okTitle:(NSString *)okTitle
                           target:(id)target
                     cancelAction:(void(^)(void))cancelAction
                         okAction:(void(^)(void))okAction;

/**
 * 创建label
 * @param title 值
 * @param textFont 字体大小
 * @param textColor 文字颜色
 */
+ (UILabel *)ck_createLabelWithTitle:(NSString *)title
                         withFont:(CGFloat)textFont
                        withColor:(NSString *)textColor;

/**
 * 创建textField
 * @param title 值
 * @param textFont 字体大小
 * @param textColor 文字颜色
 */
+ (UITextField *)ck_createTextFieldWithTitle:(NSString *)title
                                 withFont:(CGFloat)textFont
                                withColor:(NSString *)textColor;

/**
 * 创建textView
 * @param title 值
 * @param textFont 字体大小
 * @param textColor 文字颜色
 */
+ (UITextView *)ck_createTextViewWithTitle:(NSString *)title
                               withFont:(CGFloat)textFont
                              withColor:(NSString *)textColor;

/**
 * 创建Btn
 * @param title                   btn的文字
 * @param titleColor        btn文字的颜色
 * @param selectTitleColor  btn选中的文字颜色
 * @param titleFont          btn文字的大小
 * @param norImg             正常状态的图片
 * @param selectImg      选中状态的图片
 * @param tag                    btn的下标
 */
+ (UIButton *)ck_createBtnWithTitle:(NSString *)title
                      titleColor:(NSString *)titleColor
                selectTitleColor:(NSString *)selectTitleColor
                       titleFont:(UIFont *)titleFont
                   normalImgName:(NSString *)norImg
                 selectedImgName:(NSString *)selectImg
                             tag:(NSInteger)tag;

/**
 * 创建JXBtn
 * @param title             btn的文字
 * @param titleColor        btn文字的颜色
 * @param selectTitleColor  btn选中的文字颜色
 * @param norImg              正常状态的图片
 * @param selectImg       选中状态的图片
 * @param tag                     btn的下标
 */
+ (CKLayoutButton *)ck_createJXBtnWithTitle:(NSString *)title
                              titleColor:(NSString *)titleColor
                        selectTitleColor:(NSString *)selectTitleColor
                               titleFont:(UIFont *)titleFont
                           normalImgName:(NSString *)norImg
                         selectedImgName:(NSString *)selectImg
                                     tag:(NSInteger)tag;

#pragma mark - 生成image
+ (UIImage *)convertToImage:(UIView *)view;

@end

