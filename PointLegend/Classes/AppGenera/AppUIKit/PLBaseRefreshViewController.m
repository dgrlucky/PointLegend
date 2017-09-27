//
//  PLBaseRefreshViewController.m
//  PointLegend
//
//  Created by ydcq on 15/12/22.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseRefreshViewController.h"

@interface PLBaseRefreshViewController ()
{
    UILabel *flagLabel;
}

@end

@implementation PLBaseRefreshViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _pageIndex = 1;
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseTableView.hidden = NO;
    [self setBaseTableViewHeader];
}

#pragma mark Network

- (void)setRequestWithInterface:(PLInterface)interface index:(NSString *)pageIndex parameters:(NSDictionary *)dic
{
    _interface = interface;
    _index = pageIndex;
    _param = dic;
    _pageIndex = 1;
    [self.baseTableView.header beginRefreshing];
    self.state = tableStateRefreshing;
//    [self sendRequestWithMethod:GET interface:interface parameters:dic];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    id data = response[@"data"];
    if ((NSNull *)data == [NSNull null]) {
        return;
    }
    if (interface == _interface) {
        if (_state == tableStateLoading) {
            [self.baseTableView.footer endRefreshing];
            self.state = tableStateIdel;
        }
        else if (_state == tableStateRefreshing) {
            [self.baseTableView.header endRefreshing];
            self.state = tableStateIdel;
        }
        if (error) {
            if (_pageIndex>1) {
                _pageIndex--;
                footerText(@"加载失败")
            }
            else
            {
                if (_dataArray.count==0) {
                    [self showFlagLabel:YES text:@"加载失败"];
                }
            }
        }
        if (response) {
            if (_pageIndex == 1) {
                [_dataArray removeAllObjects];
            }
            [self handleResponse:response];
        }
    }
}

- (void)handleResponse:(NSDictionary *)rsp
{
    //仅处理数据，不考虑列表状态
}

#pragma mark Others

- (void)setBaseTableViewHeader
{
    if (self.baseTableView.header) {
        return;
    }
    self.baseTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(baseTableViewBeginRefreshing)];
    ((MJRefreshNormalHeader *)self.baseTableView.header).lastUpdatedTimeLabel.hidden = YES;
}

- (void)setBaseTableViewFooter
{
    if (self.baseTableView.footer) {
        return;
    }
    self.baseTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(baseTableViewBeginLoadingMore)];
}

- (void)baseTableViewBeginRefreshing
{
    if (!self.baseTableView.header.isRefreshing) {
        [self.baseTableView.header beginRefreshing];
    }
    self.state = tableStateRefreshing;
    _pageIndex=1;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:_param];
    [mDic setObject:@(_pageIndex) forKey:_index];
    [self showFlagLabel:NO text:@""];
    [self sendRequestWithMethod:GET interface:_interface parameters:_param];
}

- (void)baseTableViewBeginLoadingMore
{
    if (!self.baseTableView.footer.isRefreshing) {
        [self.baseTableView.footer beginRefreshing];
    }
    self.state = tableStateLoading;
    _pageIndex++;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:_param];
    [mDic setObject:@(_pageIndex) forKey:_index];
    [self showFlagLabel:NO text:@""];
    [self sendRequestWithMethod:GET interface:_interface parameters:mDic];
}

- (void)setState:(tableState)state
{
    _state = state;
    if (state == tableStateRefreshing) {
        if (self.baseTableView.footer.isRefreshing) {
            [self.baseTableView.footer endRefreshing];
        }
        [self.baseTableView.footer removeFromSuperview];
        self.baseTableView.footer = nil;
    }
    else if (state == tableStateLoading) {
        if (self.baseTableView.header.isRefreshing) {
            [self.baseTableView.header endRefreshing];
        }
        [self.baseTableView.header removeFromSuperview];
        self.baseTableView.header = nil;
    }
    else if (state == tableStateIdel) {
        [self setBaseTableViewHeader];
        if (_dataArray.count>10) {
            [self setBaseTableViewFooter];
        }
    }
}

- (void)showFlagLabel:(BOOL)flag text:(NSString *)text
{
    if (flagLabel) {
        [flagLabel removeFromSuperview];
        flagLabel = nil;
    }
    flagLabel = [[UILabel alloc] init];
    flagLabel.text = text;
    flagLabel.font = [UIFont boldSystemFontOfSize:30];
    flagLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    flagLabel.textAlignment = NSTextAlignmentCenter;
    flagLabel.center = CGPointMake(SCREEN_WIDTH/2.f, self.baseTableView.frame.size.height/2.f);
    flagLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self.baseTableView addSubview:flagLabel];
    [self.baseTableView bringSubviewToFront:flagLabel];
    if (!flag) {
        [flagLabel removeFromSuperview];
        flagLabel = nil;
    }
}

@end
