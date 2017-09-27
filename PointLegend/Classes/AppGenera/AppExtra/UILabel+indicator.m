//
//  UILabel+indicator.m
//  Legend
//
//  Created by ydcq on 15/12/4.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "UILabel+indicator.h"
#import <objc/runtime.h>
#import "NSString+Util.h"

const void *indKey = "indKey";

@implementation UILabel (indicator)

- (void)showIndicator
{
    [self setIndicator:nil];
}

- (void)setIndicator:(UIActivityIndicatorView *)indicator
{
    if (self.indicator.superview) {
        return;
    }
    UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGFloat width = [self.text widthWithFont:[UIFont boldSystemFontOfSize:45] constrainedToHeight:30];
    ind.center = CGPointMake(self.bounds.size.width/2.f-(width/2.f)-20, self.bounds.size.height/2);
    ind.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [ind startAnimating];
    [self addSubview:ind];
    objc_setAssociatedObject(self, indKey, ind, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideIndicator
{
    UIActivityIndicatorView *ind = objc_getAssociatedObject(self, indKey);
    [ind stopAnimating];
    [ind removeFromSuperview];
    ind = nil;
}

- (UIActivityIndicatorView *)indicator
{
    return objc_getAssociatedObject(self, indKey);
}

@end
