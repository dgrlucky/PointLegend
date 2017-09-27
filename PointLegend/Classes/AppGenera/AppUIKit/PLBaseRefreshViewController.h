//
//  PLBaseRefreshViewController.h
//  PointLegend
//
//  Created by ydcq on 15/12/22.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"
#import "MJRefresh.h"

#define footerText(txt) ((MJRefreshAutoNormalFooter *)self.baseTableView.footer).stateLabel.text = txt;

typedef NS_ENUM(NSInteger, tableState)
{
    tableStateIdel, //空闲
    tableStateRefreshing, //刷新
    tableStateLoading //加载
};

@interface PLBaseRefreshViewController : PLBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) PLInterface interface;
@property (nonatomic, copy) NSString *index;
@property (nonatomic, strong) NSDictionary *param;

/**
 *  列表状态
 */
@property (nonatomic, assign) tableState state;
/**
 *  索引页
 */
@property (nonatomic, assign) NSInteger pageIndex;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  发送请求
 *
 *  @param interface 接口类型
 *  @param pageIndex 索引字段
 *  @param dic       第一次请求数据
 */
- (void)setRequestWithInterface:(PLInterface)interface index:(NSString *)index parameters:(NSDictionary *)dic;
/**
 *  刷新头部
 *
 *  @param selector 刷新方法
 */
- (void)setBaseTableViewHeader;
/**
 *  加载头部
 *
 *  @param selector 加载方法
 */
- (void)setBaseTableViewFooter;
/**
 *  开始刷新
 */
- (void)baseTableViewBeginRefreshing;
/**
 *  开始加载
 */
- (void)baseTableViewBeginLoadingMore;
/**
 *  请求成功，返回数据
 */
- (void)handleResponse:(NSDictionary *)rsp;
/**
 *  加载状态
 *
 *  @param flag 是否显示
 *  @param text 文字描述
 */
- (void)showFlagLabel:(BOOL)flag text:(NSString *)text;

@end
