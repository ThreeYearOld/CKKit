//
//  NSString+CKAdd.m
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import "NSString+CKAdd.h"

@implementation NSString (CKAdd)

- (NSString *)ck_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

@end
