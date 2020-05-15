//
//  CKUitls.m
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import "CKUitls.h"
#import "UIColor+CKAdd.h"

@implementation CKUitls

#pragma mark - 根据view获取最近的控制器
+ (UIViewController *)ck_getCurrentController:(UIView *)view {
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

+ (UIViewController *)ck_getCurrentController {
    // 先获取根控制器
    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        }else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        }else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        }else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

+ (UIViewController *)jsd_getRootViewController {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

#pragma mark - 显示弹框
+ (void)ck_showAlertViewWithTitle:(NSString *)title okTitle:(NSString *)okTitle target:(id)target cancelAction:(void(^)(void))cancel okAction:(void(^)(void))okAction {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            cancel();
        }];
        [cancelAction setValue:[UIColor ck_colorWithHexString:@"#999999"] forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
    }
    if (okAction) {
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            okAction();
        }];
        [alert addAction:defaultAction];
    }
    // 获取当前控制器
    UIViewController *vc = nil;
    if ([target isKindOfClass:[UIViewController class]]) {
        vc = (UIViewController *)target;
    }else if ([target isKindOfClass:[UIView class]]) {
        vc = [self ck_getCurrentController:target];
    }else {
        vc = [self ck_getCurrentController];
    }
    if (vc) {
        [vc presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 创建label
+ (UILabel *)ck_createLabelWithTitle:(NSString *)title withFont:(CGFloat)textFont withColor:(NSString *)textColor {
    UILabel * lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:textFont];
    UIColor *color = nil;
    if (textColor.length > 0) {
        color = [UIColor ck_colorWithHexString:textColor];
    }
    lb.textColor = color?color:[UIColor blackColor];
    lb.text = title;
    lb.textAlignment = NSTextAlignmentCenter;
    return lb;
}

#pragma mark - 创建label
+ (UITextField *)ck_createTextFieldWithTitle:(NSString *)title withFont:(CGFloat)textFont withColor:(NSString *)textColor {
    UITextField *tf = [[UITextField alloc] init];
    tf.text = title;
    tf.font = [UIFont systemFontOfSize:textFont];
    if (textColor.length > 0) {
        tf.textColor = [UIColor ck_colorWithHexString:textColor];
    }
    return tf;
}

#pragma mark - 创建textView
+ (UITextView *)ck_createTextViewWithTitle:(NSString *)title withFont:(CGFloat)textFont withColor:(NSString *)textColor {
    UITextView *tf = [[UITextView alloc] init];
    tf.text = title;
    tf.font = [UIFont systemFontOfSize:textFont];
    if (textColor.length > 0) {
        tf.textColor = [UIColor ck_colorWithHexString:textColor];
    }
    return tf;
}

#pragma mark - 创建btn
+ (UIButton *)ck_createBtnWithTitle:(NSString *)title
                         titleColor:(NSString *)titleColor
                   selectTitleColor:(NSString *)selectTitleColor
                          titleFont:(UIFont *)titleFont
                      normalImgName:(NSString *)norImg
                    selectedImgName:(NSString *)selectImg
                                tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (tag > 0) {
        btn.tag = tag;
    }
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleFont) {
        btn.titleLabel.font = titleFont;
    }
    if (titleColor.length > 0) {
        [btn setTitleColor:[UIColor ck_colorWithHexString:titleColor] forState:UIControlStateNormal];
    }
    if (selectTitleColor.length > 0) {
        [btn setTitleColor:[UIColor ck_colorWithHexString:selectTitleColor] forState:UIControlStateSelected];
    }
    if (norImg.length > 0) {
        [btn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    }
    if (selectImg.length > 0) {
        [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
    }
    return btn;
}

+ (CKLayoutButton *)ck_createJXBtnWithTitle:(NSString *)title
                              titleColor:(NSString *)titleColor
                        selectTitleColor:(NSString *)selectTitleColor
                               titleFont:(UIFont *)titleFont
                           normalImgName:(NSString *)norImg
                         selectedImgName:(NSString *)selectImg
                                     tag:(NSInteger)tag {
    CKLayoutButton *btn = [[CKLayoutButton alloc] init];
    if (tag > 0) {
        btn.tag = tag;
    }
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleFont) {
        btn.titleLabel.font = titleFont;
    }
    if (titleColor.length > 0) {
        [btn setTitleColor:[UIColor ck_colorWithHexString:titleColor] forState:UIControlStateNormal];
    }
    if (selectTitleColor.length > 0) {
        [btn setTitleColor:[UIColor ck_colorWithHexString:selectTitleColor] forState:UIControlStateSelected];
    }
    if (norImg.length > 0) {
        [btn setImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    }
    if (selectImg.length > 0) {
        [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
    }
    return btn;
}

#pragma mark - 生成image
+ (UIImage *)convertToImage:(UIView *)view {
    UIImage *image = nil;
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *sv = (UIScrollView *)view;
        CGSize contentSize = sv.contentSize;
        // scrollView 的原始rect
        CGRect orignalSVRect = sv.frame;
        // scrollView 父视图的原始react
        CGRect orignalSuperRect = CGRectZero;
        sv.frame = CGRectMake(orignalSVRect.origin.x, orignalSVRect.origin.y, contentSize.width, contentSize.height);
        if (sv.superview) {
            orignalSuperRect = sv.superview.frame;
            sv.superview.frame = CGRectMake(orignalSuperRect.origin.x, orignalSuperRect.origin.y, contentSize.width, contentSize.height);
        }
        // 绘制
        UIGraphicsBeginImageContext(view.bounds.size);
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 重置size
        sv.frame = orignalSVRect;
        if (sv.superview) {
            sv.superview.frame = CGRectMake(orignalSuperRect.origin.x, orignalSuperRect.origin.y, contentSize.width, contentSize.height);
        }
    }else {
        UIGraphicsBeginImageContext(view.bounds.size);
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return  image;
}


@end
