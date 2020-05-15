//
//  CKBorderLabel.h
//  HINT3
//
//  Created by admin on 2020/4/18.
//  Copyright © 2020 Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKBorderLabel : UILabel

/** 单位 */
@property (nonatomic, copy) NSString * unitName;

/** 设置placeholder */
@property (nonatomic, copy) NSAttributedString * attributedPlaceholder;

/** 科大讯飞语音识别 - 识别完成后的回调 */
@property (nonatomic, copy) void(^borderLabelDidEndEditing)(NSString *content);

/** 科大讯飞语音识别 - 防止识别结束时的两次回调，只需要一次 */
@property (nonatomic, assign) BOOL isCanRecogn;

@end

