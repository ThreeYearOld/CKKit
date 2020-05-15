//
//  CKBorderLabel.m
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import "CKBorderLabel.h"
#import "UILabel+CKAddMarign.h"
#import "UIView+CKAdd.h"
#import "UIColor+CKAdd.h"
#import <Masonry.h>

@interface CKBorderLabel()

/** 单位 */
@property (nonatomic, strong) UILabel * unitLabel;

/** placeholder */
@property (nonatomic, strong) UILabel * placeholderLabel;

@end

@implementation CKBorderLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self ck_showBorderColor:[UIColor ck_colorWithHexString:@"#d2d5e0"] cornerRadius:4];
        // 设置颜色、字体大小
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor ck_colorWithHexString:@"000000"];
        // 设置左侧的内间距
        self.ck_contentInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    return self;
}

- (void)setUnitName:(NSString *)unitName {
    _unitName = unitName;
    // 添加单位
    if (!self.unitLabel.superview) {
        [self addSubview:self.unitLabel];
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
    };
    self.unitLabel.text = unitName;
}

#pragma mark - override setter
- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = attributedPlaceholder;
    if (self.text.length == 0) {
        if (!_placeholderLabel || !_placeholderLabel.superview) {
            [self addSubview:self.placeholderLabel];
            [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(5);
            }];
        }
    }
}

- (void)setText:(NSString *)text {
    if (text.length == 0) {
        if (!_placeholderLabel || !_placeholderLabel.superview) {
            [self addSubview:self.placeholderLabel];
            [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).offset(5);
            }];
        }
    }else {
        if (self.placeholderLabel.superview) {
            [self.placeholderLabel removeFromSuperview];
        }
    }
    [super setText:text];
}

#pragma mark - private method
- (UILabel *)createLabel {
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor whiteColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.adjustsFontSizeToFitWidth = true;
    return lb;
}

#pragma mark - Lazy load
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [self createLabel];
        _unitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _unitLabel;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [self createLabel];
    }
    return _placeholderLabel;
}


@end
