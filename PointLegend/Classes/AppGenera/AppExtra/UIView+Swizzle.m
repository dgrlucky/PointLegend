//
//  UIScrollView+KeyboardDismissOnDrag.m
//  Legend
//
//  Created by ydcq on 15/10/16.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "UIView+Swizzle.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>
#import "IQKeyboardManager.h"

@implementation UIScrollView (KeyboardDismissOnDrag)

+ (void)load
{
    NSError *error;

    [[self class] jr_swizzleMethod:@selector(initWithFrame:) withMethod:@selector(SY_initWithFrame:) error:&error];
    NSLog(@"%@",error);
    [[self class] jr_swizzleMethod:@selector(initWithCoder:) withMethod:@selector(SY_initWithCoder:) error:&error];
    NSLog(@"%@",error);
}

- (instancetype)SY_initWithFrame:(CGRect)rect
{
    id obj = [self SY_initWithFrame:rect];
    if ([obj isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)obj).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        ((UIScrollView *)obj).delaysContentTouches = NO;
    }
    if (([obj isKindOfClass:[UIScrollView class]] && ![obj isMemberOfClass:[UITextView class]]) || ([obj isKindOfClass:[UIWebView class]])) {
        ((UIView *)obj).autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    }
    return obj;
}

- (instancetype)SY_initWithCoder:(NSCoder *)aDecoder
{
    id obj = [self SY_initWithCoder:aDecoder];
    if ([obj isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)obj).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        ((UIScrollView *)obj).delaysContentTouches = NO;
    }
    if (([obj isKindOfClass:[UIScrollView class]] && ![obj isMemberOfClass:[UITextView class]]) || ([obj isKindOfClass:[UIWebView class]])) {
        ((UIView *)obj).autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    }
    return obj;
}

@end
