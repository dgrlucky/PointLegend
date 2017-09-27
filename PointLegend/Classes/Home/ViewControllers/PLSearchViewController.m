//
//  PLSearchViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/21.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLSearchViewController.h"

@interface PLSearchViewController ()<UISearchBarDelegate>
{
    
}
@end

@implementation PLSearchViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBaseSearchBarOnBaseNavBarWithFrame:CGRectMake(8, 27, SCREEN_WIDTH-16, NAV_BAR_HEIGHT-15*2) placeHolder:@"搜索"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
