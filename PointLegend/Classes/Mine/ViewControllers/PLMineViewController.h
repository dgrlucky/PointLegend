//
//  PLMineViewController.h
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"

typedef NS_ENUM(NSInteger, loginState)
{
    loginStateUnlog, //未登录
    loginStatelog,   //已登录
    loginStatelogging//正在登录
};

@interface PLMineViewController : PLBaseViewController

@property (nonatomic, assign) loginState state;

@end
