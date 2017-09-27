//
//  PLWebViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/17.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLRewardRuleController.h"
#import "UIWebView+AFNetworking.h"

#define DefaultUrlString ([BaseHtmlUrl stringByAppendingString:@"Home/About/about"])

@interface PLRewardRuleController ()<UIWebViewDelegate>
{
    UILabel *flagLabel;
}

@end

@implementation PLRewardRuleController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏
    self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.baseNavBar setTintColor:[UIColor whiteColor]];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1]) forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.baseNavBar];
    self.baseNavBar.shadowImage = [UIImage new];
    [self.view bringSubviewToFront:self.baseNavBar];
    UINavigationItem *item = [[UINavigationItem alloc] init];
    self.baseNavBar.items = @[item];
    item.title = @"奖励规则";
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:self action:@selector(popToPreviousVC)];
    
    //进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 62, SCREEN_WIDTH, 2)];
    _progressView.progressViewStyle = UIProgressViewStyleBar;
    _progressView.progressTintColor = [UIColor greenColor];
    [_progressView setProgress:0.6 animated:YES];
    [self.baseNavBar addSubview:_progressView];
    
    //WebView
    _aboutWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _aboutWebView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_aboutWebView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(_urlString?:DefaultUrlString)]];
    WS(weakSelf);
    [_aboutWebView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
        [weakSelf setProgress:progress];
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [weakSelf setProgress:1];
        return HTML;
    } failure:^(NSError *error) {
        [weakSelf setProgress:-2];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.shouldRelease) {
        [_aboutWebView stopLoading];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeProgressView) object:nil];
    }
}

#pragma mark Others

- (void)setProgress:(CGFloat)progress
{
    if (progress==-2) {
        [self showFlagLabel:YES text:@"加载失败"];
        [_progressView removeFromSuperview];
    }
    if (progress < 0.6) {
        return;
    }
    [_progressView setProgress:progress animated:YES];
    if (progress==1) {
        [self performSelector:@selector(removeProgressView) withObject:nil afterDelay:0.8];
        return;
    }
}

- (void)removeProgressView
{
    [_progressView removeFromSuperview];
}

- (void)showFlagLabel:(BOOL)flag text:(NSString *)str
{
    if (flagLabel) {
        [flagLabel removeFromSuperview];
        flagLabel = nil;
    }
    flagLabel = [[UILabel alloc] init];
    flagLabel.text = str;
    flagLabel.font = [UIFont boldSystemFontOfSize:30];
    flagLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    flagLabel.textAlignment = NSTextAlignmentCenter;
    flagLabel.center = CGPointMake(SCREEN_WIDTH/2.f, _aboutWebView.frame.size.height/2.f);
    flagLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [_aboutWebView addSubview:flagLabel];
    [_aboutWebView bringSubviewToFront:flagLabel];
    if (!flag) {
        [flagLabel removeFromSuperview];
        flagLabel = nil;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
