//
//  UIView+Arrange.m
//  AutoLayoutDemo
//
//  Created by chun on 15/7/16.
//  Copyright (c) 2015年 chun. All rights reserved.
//

#import "UIView+Arrange.h"
#import "Masonry.h"

@implementation UIView (Arrange)

- (void)arrangeViews:(NSArray *)views numbersPerrow:(NSInteger)number topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin spacing:(CGFloat)spacing usingFixedWidth:(BOOL)useFixedWidth fixedWidth:(CGFloat)fixedWidth usingFixedHeight:(BOOL)useFixedHeight fixedHeight:(CGFloat)fixedHeight
{
    if (topMargin<0 || bottomMargin<0 || views.count<=0 || leftMargin<0 || rightMargin<0 || spacing<0 || number<=0) {
        return;
    }
    
    if (useFixedWidth && fixedWidth<=0) {
        return;
    }
    
    if (useFixedHeight && fixedHeight<=0) {
        return;
    }
    
    BOOL isSuperView = YES;
    for (UIView *v in views) {
        if (![v.superview isEqual:self]) {
            isSuperView = NO;
        }
    }
    
    if (!isSuperView) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //如果最后一行不够，则添加凑足number个
    int num = views.count;
    NSMutableArray *mViews = [views mutableCopy];
    if (number * (num/number) < num) {
        int number1 = num-number * (num/number);
        number1 = number-number1;
        for (int i = 0; i < number1; i++) {
            NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:views[0]];
            UIView *v = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
            [weakSelf addSubview:v];
            v.hidden = YES;
            [mViews addObject:v];
        }
    }
    
    num = mViews.count;
    
    views = [mViews copy];
    
    for (int i = 0; i < num; i++) {
        UIView *v = views[i];
        UIView *upView,*downView,*leftView,*rightView;
        upView=downView=leftView=rightView=nil;
        if (i>=number) {
            upView = views[i-number];
        }
        if (i%number>0) {
            leftView = views[i-1];
        }
        if (i%number<number-1) {
            if (i+1<=num-1) {
                rightView = views[i+1];
            }
        }
        if (i+number<num) {
            downView = views[i+number];
        }
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (upView) {
                make.top.equalTo(upView.mas_bottom).with.offset(spacing);
                make.width.equalTo(upView.mas_width);
            }
            else
            {
                make.top.equalTo(weakSelf.mas_top).with.offset(topMargin);
            }
            
            if (leftView) {
                make.left.equalTo(leftView.mas_right).with.offset(spacing);
                make.width.equalTo(leftView.mas_width);
            }
            else
            {
                make.left.equalTo(weakSelf.mas_left).with.offset(leftMargin);
            }
            
            if (rightView) {
                make.right.equalTo(rightView.mas_left).with.offset(-spacing);
                make.width.equalTo(rightView.mas_width);
            }
            else
            {
                make.right.equalTo(weakSelf.mas_right).with.offset(-rightMargin);
            }
            
            if (useFixedHeight) {
                make.height.mas_equalTo(fixedHeight);
            }
            
            if (downView) {
                make.bottom.equalTo(downView.mas_top).with.offset(-spacing);
                make.width.equalTo(downView.mas_width);
            }
            else
            {
                make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-bottomMargin);
            }
        }];
    }
}

@end
