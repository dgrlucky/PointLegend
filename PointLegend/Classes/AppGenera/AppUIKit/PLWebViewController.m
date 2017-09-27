//
//  PLWebViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/17.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLWebViewController.h"
#import "UIWebView+AFNetworking.h"

@interface PLWebViewController ()<UIWebViewDelegate>

@end

@implementation PLWebViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_webView loadRequest:request];
    
    _webView.delegate = self;
    [self showLoadingHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingHUD];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    baseNavItem.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingHUD];
    [SVProgressHUD showErrorWithStatus:@"WebView加载失败！"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
