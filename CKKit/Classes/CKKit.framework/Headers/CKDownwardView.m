//
//  CKDownwardView.m
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import "CKDownwardView.h"
#import "UIView+CKAdd.h"
#import "UIColor+CKAdd.h"
#import "CKSpinnerNarrowView.h"
#import "CKUitls.h"
#import <Masonry.h>

@interface CKDownwardView()

/** 向下的箭头 */
@property (nonatomic, weak) UIImageView * downwardImgView;

/** 内容 */
@property (nonatomic, weak) UILabel * contentLabel;

/** placeholder */
@property (nonatomic, strong) UILabel * placeholderLabel;

@end

@implementation CKDownwardView
@dynamic font;
@dynamic textColor;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        // 圆角、边框
        [self ck_showBorderColor:[UIColor ck_colorWithHexString:@"#d2d5e0"] cornerRadius:4];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self createUI];
    // 圆角、边框
    [self ck_showBorderColor:[UIColor ck_colorWithHexString:@"#d2d5e0"] cornerRadius:4];
}

#pragma mark - override getter
- (NSString *)text {
    return [_title stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - override setter
- (void)setIsHidden:(BOOL)isHidden {
    self.downwardImgView.hidden = isHidden;
}

- (void)setText:(NSString *)text {
    _title = text;
    if (self.unitName.length > 0) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",text,self.unitName];
    }else {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",text];
    }
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
}

- (void)setTitle:(NSString *)title {
    _title = title;
    // 赋值
    self.text = title;
}

- (void)setFont:(UIFont *)font {
    self.contentLabel.font = font;
}

- (UIFont *)font {
    return self.contentLabel.font;
}

- (void)setTextAligment:(NSTextAlignment)textAligment {
    self.contentLabel.textAlignment = textAligment;
}

- (void)setTextColor:(UIColor *)textColor {
    self.contentLabel.textColor = textColor;
}

- (UIColor *)textColor {
    return self.contentLabel.textColor;
}

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

/** 设置图标以及size */
- (void)setNarrowImg:(NSString *)imgName imgSize:(CGSize)size {
    self.downwardImgView.image = [UIImage imageNamed:imgName];
    [self.downwardImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

- (void)createUI {
    // 生成向下的箭头
    CKSpinnerNarrowView *narrowView = [[CKSpinnerNarrowView alloc] initWithFrame:CGRectMake(0, 0, 10, 5) narrowForward:CKSpinnerNarrowForwardForBottom narrowColor:[UIColor blackColor]];
    UIImage *dropDown = [CKUitls convertToImage:narrowView];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:dropDown];
    self.downwardImgView = imgView;
    UILabel *content = [self createLabel];
    self.contentLabel = content;
    
    [self addSubview:imgView];
    [self addSubview:content];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(10, 5));
    }];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(imgView.mas_left).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (UILabel *)createLabel {
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor ck_colorWithHexString:@"#33333"];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.adjustsFontSizeToFitWidth = true;
    return lb;
}

#pragma mark - Lazy load
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [self createLabel];
    }
    return _placeholderLabel;
}

@end
