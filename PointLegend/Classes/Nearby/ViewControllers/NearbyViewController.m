//
//  NearbyViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "NearbyViewController.h"

@implementation NearbyViewController

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
    self.baseSearchBar.hidden = NO;
}

@end
