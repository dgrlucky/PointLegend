//
//  PLWebViewController.h
//  PointLegend
//
//  Created by ydcq on 15/9/17.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"

@interface PLRewardRuleController : PLBaseViewController

@property (nonatomic, strong) UIWebView *aboutWebView;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) UIProgressView *progressView;

@end
