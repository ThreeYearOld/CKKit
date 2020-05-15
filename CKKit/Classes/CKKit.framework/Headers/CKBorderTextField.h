//
//  CKBorderTextField.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKBorderTextField : UITextField

/** 圆角值 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 是否为数字键盘 */
@property (nonatomic, assign) BOOL isNumericKeyboard;

/** 是否输入手机号 */
@property (nonatomic, assign) BOOL isInputPhone;

@end

