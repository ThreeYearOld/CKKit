//
//  UIView+CKAdd.h
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CKTappedBlock)(void);

@interface UIView (CKAdd) <UIGestureRecognizerDelegate>

/** 设置view圆角以及边框颜色 */
- (void)ck_showBorderColor:(UIColor *)borderColor
              cornerRadius:(CGFloat)radius;

/** 设置view圆角以及边框颜色和宽度 */
- (void)ck_showBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)width
              cornerRadius:(CGFloat)radius;


- (void)whenTapped:(CKTappedBlock)block;
- (void)whenDoubleTapped:(CKTappedBlock)block;
- (void)whenTwoFingerTapped:(CKTappedBlock)block;
- (void)whenTouchedDown:(CKTappedBlock)block;
- (void)whenTouchedUp:(CKTappedBlock)block;

@end

