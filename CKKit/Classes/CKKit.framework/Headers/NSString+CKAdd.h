//
//  NSString+CKAdd.h
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CKAdd)

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)ck_stringByTrim;

@end

