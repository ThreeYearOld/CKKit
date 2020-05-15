//
//  CKDownwardView.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKDownwardView : UIView

/** 选中的值 */
@property (nonatomic, copy) NSString * title;

/** 获取值 */
@property (nonatomic, copy) NSString * text;

/** 单位 */
@property (nonatomic, copy) NSString * unitName;

/** 设置placeholder */
@property (nonatomic, copy) NSAttributedString * attributedPlaceholder;

/** 设置text字体大小 */
@property (nonatomic, strong) UIFont *font;

/** 文字位置 */
@property (nonatomic, assign) NSTextAlignment textAligment;

/** 设置text字体颜色 */
@property (nonatomic, strong) UIColor * textColor;

/** 是否隐藏图标 */
@property (nonatomic, assign) BOOL isHidden;

/** 设置图标以及size */
- (void)setNarrowImg:(NSString *)imgName imgSize:(CGSize)size;


@end

