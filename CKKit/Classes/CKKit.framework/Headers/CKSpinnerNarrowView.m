//
//  CKSpinnerNarrowView.m
//  CKKit
//
//  Created by admin on 2019/12/16.
//  Copyright © 2019 Chengkun. All rights reserved.
//

#import "CKSpinnerNarrowView.h"

@interface CKSpinnerNarrowView()

/** 三角形的填充颜色 */
@property (nonatomic, strong) UIColor * fillColor;

/** 箭头的方向 */
@property (nonatomic, assign) CKSpinnerNarrowForward narrowForward;

@end

@implementation CKSpinnerNarrowView

/**
 *  创建三角形的箭头
 *  @param color 箭头的填充颜色
 */
- (instancetype)initWithFrame:(CGRect)frame narrowForward:(CKSpinnerNarrowForward)forward narrowColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _fillColor = color;
        _narrowForward = forward;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 定义画图的path
    UIBezierPath * path = [[UIBezierPath alloc] init];
    switch (_narrowForward) {
        case CKSpinnerNarrowForwardForTop:{
            // path移动到开始画图的位置
            [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y)];
            break;
        }
        case CKSpinnerNarrowForwardForLeft:{
            // path移动到开始画图的位置
            [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/2.0)];
            [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
            break;
        }
        case CKSpinnerNarrowForwardForBottom:{
            // path移动到开始画图的位置
            [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
            [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
            break;
        }
        case CKSpinnerNarrowForwardForRight:{
            // path移动到开始画图的位置
            [path moveToPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y + rect.size.height/2.0)];
            [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
            [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
            break;
        }
        default:
            break;
    }
    
    // 关闭path
    [path closePath];
    // 三角形内填充颜色
    [_fillColor setFill];
    [path fill];
   
}


@end
