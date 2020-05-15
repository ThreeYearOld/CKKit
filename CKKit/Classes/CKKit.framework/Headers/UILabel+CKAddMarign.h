//
//  UILabel+CKAddMarign.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel (CKAddMarign)

/**
 修改label内容距 `top` `left` `bottom` `right` 边距
 */
@property (nonatomic, assign) UIEdgeInsets ck_contentInsets;

@end

