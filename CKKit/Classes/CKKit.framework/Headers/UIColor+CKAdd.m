//
//  UIColor+CKAdd.m
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import "UIColor+CKAdd.h"
#import "NSString+CKAdd.h"

@implementation UIColor (CKAdd)

+ (UIColor *)ck_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (ck_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL ck_hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str ck_stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = ck_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = ck_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = ck_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = ck_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = ck_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = ck_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = ck_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = ck_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}


static inline NSUInteger ck_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

@end
