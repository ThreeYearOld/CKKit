//
//  CKSpinnerCell.h
//  CKKit
//
//  Created by admin on 2019/12/16.
//  Copyright © 2019 Chengkun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CKSpinnerCell : UITableViewCell

/** 左侧view */
@property (nonatomic, strong) UIView * leftView;

/** 右侧view */
@property (nonatomic, strong) UIView * rightView;

/** 值 */
@property (nonatomic, assign) NSString * content;

+ (NSString *)identifier;

@end

