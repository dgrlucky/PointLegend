//
//  PLMenu.h
//  PLMenuDemo_ObjC
//
//  Created by 牛萌 on 15/5/6.
//  Copyright (c) 2015年 NiuMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLMenuItem.h"

typedef void(^PLMenuSelectedItem)(NSInteger index, PLMenuItem *item);

typedef enum {
    PLMenuBackgrounColorEffectSolid      = 0, //!<背景显示效果.纯色
    PLMenuBackgrounColorEffectGradient   = 1, //!<背景显示效果.渐变叠加
} PLMenuBackgrounColorEffect;

@interface PLMenu : NSObject

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems selected:(PLMenuSelectedItem)selectedItem;

+ (void)dismissMenu;

// 主题色
+ (UIColor *)tintColor;
+ (void)setTintColor:(UIColor *)tintColor;

// 标题字体
+ (UIFont *)titleFont;
+ (void)setTitleFont:(UIFont *)titleFont;

// 背景效果
+ (PLMenuBackgrounColorEffect)backgrounColorEffect;
+ (void)setBackgrounColorEffect:(PLMenuBackgrounColorEffect)effect;

// 是否显示阴影
+ (BOOL)hasShadow;
+ (void)setHasShadow:(BOOL)flag;

@end
