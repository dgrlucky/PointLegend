//
//  PLTabbarController.m
//  TestDemo
//
//  Created by ydcq on 15/9/7.
//  Copyright (c) 2015年 黄国桥. All rights reserved.
//

#import "PLTabbarController.h"
#import "PLTabbarItem.h"
#import "PLBaseNavigationController.h"
#import "PLBaseViewController.h"

#define ITEM_NUMBER infoArray.count

NSString *str1 = @"http://kstu.jp/img/kstu-logo.png";
NSString *str2 = @"http://hayakawamitsuhiko.com/logo.png";
NSString *str3 = @"http://chengjiyun.com/zsjz-senior/sites/zsjz-senior/modules/weike_misc/images/zhiwei-logo-footer.png";
NSString *str4 = @"http://www.realkiwiadventures.com/themes/realkiwiadventures/images/twitter-logo.png";

@implementation PLTabbarController
{
    NSArray *infoArray;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithInfoArray:(NSArray *)arr
{
//    infoArray = arr;
    return [super init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor redColor];
    
   infoArray = @[
                                                                                   @{@"title":@"首页",@"class":@"PLHomeViewController",@"imageName":@"grey_home",@"selectedImageName":@"red_home",@"itemUrl":@"",@"selectedItemUrl":@""},
                                                                                   @{@"title":@"奖励",@"class":@"PLRewardViewController",@"imageName":@"grey_reward",@"selectedImageName":@"red_reward",@"itemUrl":@"",@"selectedItemUrl":@""},
                                                                                   @{@"title":@"我的",@"class":@"PLMineViewController",@"imageName":@"grey_my",@"selectedImageName":@"red_my",@"itemUrl":@"",@"selectedItemUrl":@""}];
    
    NSMutableArray *vcArray = [NSMutableArray new];
    for (int i = 0; i < ITEM_NUMBER; i++) {
        PLBaseViewController *vc = [[NSClassFromString(infoArray[i][@"class"]) alloc] init];
        vc.tabBarItem = [[PLTabbarItem alloc] initWithInfo:infoArray[i]];
        PLBaseNavigationController *nav = [[PLBaseNavigationController alloc] initWithRootViewController:vc];
        [vcArray addObject:nav];
    }
    
    [self setViewControllers:vcArray animated:NO];
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
