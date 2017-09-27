//
//  PLUserAgreementViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/25.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLUserAgreementViewController.h"
#import "UIWebView+AFNetworking.h"

@interface PLUserAgreementViewController ()
{
    UIProgressView *progressView;
}

@end

@implementation PLUserAgreementViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户使用协议";

    _uWebView = [[UIWebView alloc] init];
    [self.view addSubview:_uWebView];
    _uWebView.scalesPageToFit = YES;
    
    progressView = [[UIProgressView alloc] init];
    progressView.progress = 0.f;
    [self.view addSubview:progressView];
    WS(weakSelf);
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(NAV_BAR_HEIGHT);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(2);
    }];
    
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.001];
    
    [_uWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.144:6003/Home/RegistProtocol.html"]] progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        SS(strongSelf);
        if (totalBytesWritten == totalBytesExpectedToWrite) {
            [strongSelf->progressView removeFromSuperview];
        }
        else
        {
            strongSelf->progressView.progress = totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
        }
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        SS(strongSelf);
        [strongSelf->progressView removeFromSuperview];
        return HTML;
    } failure:^(NSError *error) {
        SS(strongSelf);
        [strongSelf->progressView removeFromSuperview];
        [weakSelf handleNetworkError:error];
    }];
    
    [_uWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(NAV_BAR_HEIGHT);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

@end
