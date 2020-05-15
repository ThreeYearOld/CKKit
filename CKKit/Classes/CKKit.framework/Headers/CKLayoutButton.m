//
//  CKLayoutButton.m
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import "CKLayoutButton.h"
#import <Masonry.h>

@interface CKLayoutButton ()

/** 显示消息未读数量 */
@property (nonatomic, strong) UILabel * badgeLabel;

@end


@implementation CKLayoutButton

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.layer.cornerRadius = 16.0 * (1/[UIScreen mainScreen].scale);
        _badgeLabel.layer.masksToBounds = true;
    }
    return _badgeLabel;
}

- (void)setBadgeStr:(NSString *)badgeStr {
    _badgeStr = badgeStr;
    self.badgeLabel.text = badgeStr;
    if (badgeStr.length == 0 || badgeStr == nil || badgeStr.integerValue == 0) {
        if (self.badgeLabel.superview) {
            [self.badgeLabel removeFromSuperview];
        }
        return;
    }
    if (!self.badgeLabel.superview) {
        [self addSubview:self.badgeLabel];
    }
    [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(self.badgeVerOffset);
        make.centerX.equalTo(self.mas_right).offset(self.badgeHorOffset);
    }];
    // 设置size
    if (badgeStr.intValue < 100) {
        self.badgeLabel.text = badgeStr;
        if (badgeStr.intValue >= 10) {
            [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_top).offset(self.badgeVerOffset);
                make.centerX.equalTo(self.mas_right).offset(self.badgeHorOffset-5);
            }];
        }
    }else {
        self.badgeLabel.text = @"99+";
        [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_top).offset(self.badgeVerOffset);
            make.centerX.equalTo(self.mas_right).offset(self.badgeHorOffset-9);
        }];
    }
    // 判断是否设置badgeSize
    if (_badgeSize == 0) {
        _badgeSize = 32.0 * (1/[UIScreen mainScreen].scale);
    }
    [self setBadgeSize:_badgeSize];
    // 显示在图层最上面
    [self bringSubviewToFront:self.badgeLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.midSpacing = 8;
        self.imageSize = CGSizeZero;
        self.clipsToBounds = false;
        _badgeSize      = 0.0;
        _badgeVerOffset = 0.0;
        _badgeHorOffset = 0.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGSizeEqualToSize(CGSizeZero, self.imageSize)) {
        [self.imageView sizeToFit];
    }
    else {
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,
                                    self.imageView.frame.origin.y,
                                          self.imageSize.width,
                                          self.imageSize.height);
    }
    [self.titleLabel sizeToFit];
    
    switch (self.layoutStyle) {
        case CKLayoutButtonStyleLeftImageRightTitle:
            [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
            break;
        case CKLayoutButtonStyleLeftTitleRightImage:
            [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
            break;
        case CKLayoutButtonStyleUpImageDownTitle:
            [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
            break;
        case CKLayoutButtonStyleUpTitleDownImage:
            [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
            break;
        case CKLayoutButtonStyleBothCenter:
            [self layoutHorizontalAndVerticalWithCenter];
            break;
        default:
            break;
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    CGRect leftViewFrame = leftView.frame;
    CGRect rightViewFrame = rightView.frame;
    
    CGFloat totalWidth = CGRectGetWidth(leftViewFrame) + self.midSpacing + CGRectGetWidth(rightViewFrame);
    
    leftViewFrame.origin.x = (CGRectGetWidth(self.frame) - totalWidth) / 2.0;
    leftViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(leftViewFrame)) / 2.0;
    leftView.frame = leftViewFrame;
    
    rightViewFrame.origin.x = CGRectGetMaxX(leftViewFrame) + self.midSpacing;
    rightViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(rightViewFrame)) / 2.0;
    rightView.frame = rightViewFrame;
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    CGRect upViewFrame = upView.frame;
    CGRect downViewFrame = downView.frame;
    
    CGFloat totalHeight = CGRectGetHeight(upViewFrame) + self.midSpacing + CGRectGetHeight(downViewFrame);
    
    upViewFrame.origin.y = (CGRectGetHeight(self.frame) - totalHeight) / 2.0;
    upViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(upViewFrame)) / 2.0;
    upView.frame = upViewFrame;
    
    downViewFrame.origin.y = CGRectGetMaxY(upViewFrame) + self.midSpacing;
    downViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(downViewFrame)) / 2.0;
    downView.frame = downViewFrame;
}

- (void)layoutHorizontalAndVerticalWithCenter {
    if (self.imageSize.width > 0 && self.imageSize.height > 0) {
        self.imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
    }else {
        self.imageView.frame = self.bounds;
    }
    self.imageView.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    
    self.titleLabel.frame = self.bounds;
    
    // label现在在最前面
    [self bringSubviewToFront:self.titleLabel];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
}

- (void)setMidSpacing:(CGFloat)midSpacing {
    _midSpacing = midSpacing;
    [self layoutSubviews];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self layoutSubviews];
}

- (void)setLayoutStyle:(CKLayoutButtonStyle)layoutStyle {
    _layoutStyle = layoutStyle;
    [self layoutSubviews];
}

- (void)setBadgeSize:(CGFloat)badgeSize {
    _badgeSize = badgeSize;
    if (_badgeStr.intValue < 10) {
        [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(badgeSize, badgeSize));
        }];
    }else if (_badgeStr.intValue > 9 && _badgeStr.intValue < 100) {
        [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(badgeSize+10, badgeSize));
        }];
    }else {
        [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(badgeSize+18, badgeSize));
        }];
    }
    self.badgeLabel.layer.cornerRadius = badgeSize/2.0;
    [self layoutSubviews];
}

- (void)setBadgeFont:(CGFloat)badgeFont {
    _badgeFont = badgeFont;
    self.badgeLabel.font = [UIFont systemFontOfSize:badgeFont];
}

- (void)setBadgeHorOffset:(CGFloat)badgeHorOffset {
    _badgeHorOffset = badgeHorOffset;
    if (!_badgeLabel.superview) {
        return;
    }
    [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(badgeHorOffset);
    }];
}

- (void)setBadgeVerOffset:(CGFloat)badgeVerOffset {
    _badgeVerOffset = badgeVerOffset;
    if (!_badgeLabel.superview) {
        return;
    }
    [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(badgeVerOffset);
    }];
}

@end
