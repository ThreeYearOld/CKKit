//
//  UIView+CKAdd.m
//  CKUitlKit
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 Chengkun. All rights reserved.
//

#import "UIView+CKAdd.h"
#import <objc/runtime.h>

@interface UIView (CKTappedBlocks_Private)

- (void)runBlockForKey:(void *)blockKey;
- (void)setBlock:(CKTappedBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger) taps touches:(NSUInteger) touches selector:(SEL)selector;
- (void) addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer;
- (void) addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer;

@end

@implementation UIView (CKAdd)

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenTwoFingerTappedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

- (void)ck_showBorderColor:(UIColor *)borderColor
              cornerRadius:(CGFloat)radius {
    [self ck_showBorderColor:borderColor
                 borderWidth:1/[UIScreen mainScreen].scale
                cornerRadius:radius];
}

/** 设置view圆角以及边框颜色和宽度 */
- (void)ck_showBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)width
              cornerRadius:(CGFloat)radius {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = radius;
}

- (void)runBlockForKey:(void *)blockKey {
    CKTappedBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block();
}

- (void)setBlock:(CKTappedBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)whenTapped:(CKTappedBlock)block {
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    [self addRequiredToDoubleTapsRecognizer:gesture];
    
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)whenDoubleTapped:(CKTappedBlock)block {
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];
    [self addRequirementToSingleTapsRecognizer:gesture];
    [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

- (void)whenTwoFingerTapped:(CKTappedBlock)block {
    [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];
    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)whenTouchedDown:(CKTappedBlock)block {
    [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
}

- (void)whenTouchedUp:(CKTappedBlock)block {
    [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

- (void)viewWasTapped {
    [self runBlockForKey:&kWhenTappedBlockKey];
}

- (void)viewWasDoubleTapped {
    [self runBlockForKey:&kWhenDoubleTappedBlockKey];
}

- (void)viewWasTwoFingerTapped {
    [self runBlockForKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self runBlockForKey:&kWhenTouchedDownBlockKey];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self runBlockForKey:&kWhenTouchedUpBlockKey];
}



- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    return tapGesture;
}

- (void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    UIView *view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return false;
    }
    return true;
}

@end
