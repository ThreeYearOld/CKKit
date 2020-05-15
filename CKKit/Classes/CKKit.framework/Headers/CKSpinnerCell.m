//
//  CKSpinnerCell.m
//  CKKit
//
//  Created by admin on 2019/12/16.
//  Copyright © 2019 Chengkun. All rights reserved.
//

#import "CKSpinnerCell.h"
#import <Masonry.h>

@interface CKSpinnerCell()

/** 内容 */
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation CKSpinnerCell

- (void)layoutSubviews {
    [super layoutSubviews];
    // 左侧view
    if (!_leftView || !_leftView.superview) {
        [self.contentView addSubview:self.leftView];
    }
    // 右侧rightView
    if (!_rightView || !_rightView.superview) {
        [self.contentView addSubview:self.rightView];
    }
    // 内容
    if (!_contentLabel || !_contentLabel.superview) {
        [self.contentView addSubview:self.contentLabel];
    }
    // 获取左侧和右侧的宽度
    CGFloat cellWidth  = self.bounds.size.width;
    CGFloat leftWidth  = self.leftView.frame.size.width;
    CGFloat rightWidth = self.rightView.frame.size.width;
    // 设置文字的frame
    self.leftView.frame = CGRectMake(0, 0, leftWidth, self.bounds.size.height);
    self.contentLabel.frame = CGRectMake(leftWidth+2, 0, cellWidth-leftWidth-rightWidth-4, self.bounds.size.height);
    self.rightView.frame = CGRectMake(cellWidth-rightWidth, 0, rightWidth, self.bounds.size.height);
}

#pragma mark - override setter
- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

#pragma mark - lazy load
- (UILabel *)createLabel {
    UILabel *lb     = [[UILabel alloc] init];
    lb.font         = [UIFont systemFontOfSize:15];
    lb.textColor    = [UIColor colorWithRed:46/255.0 green:64/255.0 blue:80/255.0 alpha:1.000];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.adjustsFontSizeToFitWidth = true;
    return lb;
}

#pragma mark - Lazy load
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    }
    return _rightView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [self createLabel];
    }
    return _contentLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

@end
