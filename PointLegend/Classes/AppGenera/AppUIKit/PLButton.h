//
//  PLButton.h
//  PointLegend
//
//  Created by ydcq on 15/12/15.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLButton : UIButton

+ (instancetype)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)color title:(NSString *)title titleFont:(UIFont *)font tag:(NSInteger)tag actionBlock:(void (^)(NSInteger tag))block;

+ (instancetype)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)color title:(NSString *)title titleFont:(UIFont *)font cornerRadius:(BOOL)redius tag:(NSInteger)tag actionBlock:(void (^)(NSInteger tag))block;

@end
