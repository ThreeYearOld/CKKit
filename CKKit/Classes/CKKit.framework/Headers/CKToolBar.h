//
//  CKToolBar.h
//  CKUitlKit
//
//  Created by admin on 2020/5/12.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKToolBar : UIToolbar

/** 取消block */
@property (nonatomic, copy) void(^cancelActionBlock)(void);

/** 确定block */
@property (nonatomic, copy) void(^confirmActionBlock)(void);

@end


