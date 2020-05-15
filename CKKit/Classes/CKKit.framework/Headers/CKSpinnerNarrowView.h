//
//  CKSpinnerNarrowView.h
//  CKKit
//
//  Created by admin on 2019/12/16.
//  Copyright © 2019 Chengkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CKSpinnerNarrowForward) {
    CKSpinnerNarrowForwardForLeft = 1,
    CKSpinnerNarrowForwardForRight,
    CKSpinnerNarrowForwardForTop,
    CKSpinnerNarrowForwardForBottom
};

@interface CKSpinnerNarrowView : UIView

/**
 *  创建三角形的箭头
 *  @param color 箭头的填充颜色
 */
- (instancetype)initWithFrame:(CGRect)frame narrowForward:(CKSpinnerNarrowForward)forward narrowColor:(UIColor *)color;

@end

