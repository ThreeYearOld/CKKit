//
//  CKNarrowView.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CKNarrowForward) {
    CKNarrowForwardForLeft = 1,
    CKNarrowForwardForRight,
    CKNarrowForwardForTop,
    CKNarrowForwardForBottom
};

@interface CKNarrowView : UIView

/**
 *  创建三角形的箭头
 *  @param color 箭头的填充颜色
 */
- (instancetype)initWithFrame:(CGRect)frame narrowForward:(CKNarrowForward)forward narrowColor:(UIColor *)color;

@end


