//
//  UIView+Arrange.h
//  AutoLayoutDemo
//
//  Created by chun on 15/7/16.
//  Copyright (c) 2015年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Arrange)

- (void)arrangeViews:(NSArray *)views numbersPerrow:(NSInteger)number topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin spacing:(CGFloat)spacing usingFixedWidth:(BOOL)useFixedWidth fixedWidth:(CGFloat)fixedWidth usingFixedHeight:(BOOL)useFixedHeight fixedHeight:(CGFloat)fixedHeight;

@end
