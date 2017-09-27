//
//  PLButton.m
//  PointLegend
//
//  Created by ydcq on 15/12/15.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLButton.h"
#import "UIButton+Indicator.h"

@interface PLButton ()

@property (nonatomic, copy) void (^actionBlock)(NSInteger tag);

@end

@implementation PLButton

+ (instancetype)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)color title:(NSString *)title titleFont:(UIFont *)font tag:(NSInteger)tag actionBlock:(void (^)(NSInteger tag))block
{
    return [[[self class] alloc] initWithFrame:frame backgroundColor:color title:title titleFont:font cornerRadius:NO tag:tag actionBlock:block];
}

+ (instancetype)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)color title:(NSString *)title titleFont:(UIFont *)font cornerRadius:(BOOL)redius tag:(NSInteger)tag actionBlock:(void (^)(NSInteger tag))block
{
    return [[[self class] alloc] initWithFrame:frame backgroundColor:color title:title titleFont:font cornerRadius:YES tag:tag actionBlock:block];
}

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color title:(NSString *)title titleFont:(UIFont *)font cornerRadius:(BOOL)redius tag:(NSInteger)tag actionBlock:(void (^)(NSInteger tag))block
{
    PLButton *button = [PLButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:imageWithColor(color) forState:UIControlStateNormal];
    if (!redius) {
        [button setBackgroundImage:imageWithColor([UIColor whiteColor]) forState:UIControlStateHighlighted];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    button.tag = tag;
    if (redius) {
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
    }
    button.actionBlock = block;
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClicked:(PLButton *)btn
{
    NSInteger tag = btn.tag;
    if (btn.actionBlock) {
        btn.actionBlock(tag);
    }
}

@end
