//
//  UIViewController+loadingHUD.m
//  IOS-Categories
//
//  Created by chun on 15/7/4.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIViewController+loadingHUD.h"
#import <objc/runtime.h>

static const void *indicatorKey = @"indicatorKey";
static const void *labelKey = @"labelKey";

@implementation UIViewController (loadingHUD)

- (void)showLoadingHUD
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.view.bounds.size.width/2.f-40, self.view.bounds.size.height/2.f);
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    objc_setAssociatedObject(self, indicatorKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.bounds = CGRectMake(0, 0, 90, 20);
    loadingLabel.center = CGPointMake(indicator.frame.origin.x+27+45, indicator.center.y);
    loadingLabel.text = @"正在载入...";
    loadingLabel.font = [UIFont systemFontOfSize:15];
    loadingLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:loadingLabel];
    
    [self.view bringSubviewToFront:indicator];
    [self.view bringSubviewToFront:loadingLabel];
    
    objc_setAssociatedObject(self, labelKey, loadingLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideLoadingHUD
{
    UIActivityIndicatorView *indicator = objc_getAssociatedObject(self, indicatorKey);
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    
    UILabel *loadingLabel = objc_getAssociatedObject(self, labelKey);
    [loadingLabel removeFromSuperview];
}

@end
