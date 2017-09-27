//
//  UINavigationBar+Swizzle.m
//  PointLegend
//
//  Created by ydcq on 15/11/18.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "UINavigationBar+Swizzle.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Swizzle)

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
    ((UIView *)obj).autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    return obj;
}

- (instancetype)SY_initWithCoder:(NSCoder *)aDecoder
{
    id obj = [self SY_initWithCoder:aDecoder];
    ((UIView *)obj).autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    return obj;
}

@end
