//
//  PLWebViewController.h
//  PointLegend
//
//  Created by ydcq on 15/9/17.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"

@interface PLWebViewController : PLBaseViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *urlString;

@end
