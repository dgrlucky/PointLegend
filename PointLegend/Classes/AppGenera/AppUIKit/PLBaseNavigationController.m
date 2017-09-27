//
//  PLBaseNavigationController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseNavigationController.h"
#import <objc/runtime.h>
#import "PLBaseViewController.h"
#import "JRSwizzle.h"
#import "PLRewardListViewController.h"

@interface PLBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation PLBaseNavigationController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([self.topViewController isKindOfClass:[NSClassFromString(@"PLRewardListViewController") class]]) {
        setSelectedIndexToZero();
        [((PLRewardListViewController *)self.topViewController).chooseWindow dismiss];
    }
    return [super popViewControllerAnimated:animated];
}

//横竖屏支持
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait/* ||
                                                                   interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                                                                   interfaceOrientation == UIInterfaceOrientationLandscapeRight*/);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait/* | UIInterfaceOrientationMaskLandscape*/;
}

@end
