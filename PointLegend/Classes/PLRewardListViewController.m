//
//  PLRewardListViewController.m
//  PointLegend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLRewardListViewController.h"
#import "PLRewardListCell.h"
#import "MJRefresh.h"
#import "PLRewardListModel.h"

typedef NS_ENUM(NSInteger, tableState)
{
    tableStateIdel,
    tableStateRefreshing,
    tableStateLoding
};

const int pageSize = 10;

@interface PLRewardListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex; //索引页
    
    NSInteger rewardType; //筛选条件
    
    NSMutableArray *dataArray; //数据源
    
    UILabel *flagLabel; //状态标记
    
    NSMutableArray *typeArray; //奖励类型
}

@property (nonatomic, assign) tableState state; //列表状态

@end

@implementation PLRewardListViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _state = tableStateIdel;
        rewardType = 0;
        pageIndex = 1;
        dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63.7)];
    [self.baseNavBar setTintColor:[UIColor whiteColor]];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1]) forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.baseNavBar];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    self.baseNavBar.items = @[item];
    item.title = @"奖励统计";
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:self action:@selector(popToPreviousVC)];
    [self rightBarButtonShowIndicator:NO];
    
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 56;
    
    [self setHeader:YES];
    
    [self.baseTableView.header beginRefreshing];
}

#pragma mark Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLRewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLRewardListCell cellReuseIdentifier:cellTypeReward]];
    if (cell == nil) {
        cell = [[PLRewardListCell alloc] initWithType:cellTypeReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showsDetail = NO;
    }
    [cell setShowsDetail:NO];
    PLRewardListModel *model = dataArray[indexPath.row];
    if (model.selected)
    {
        [cell setShowsDetail:YES];
    }
    else
    {
        [cell setShowsDetail:NO];
    }
    if (dataArray.count) {
        PLRewardListModel *model = dataArray[indexPath.row];
        cell.titleLabel.text = RewardTypeDic[[NSString stringWithFormat:@"%d",model.rewardType]];
        cell.subTitleLabel.text = model.settleTime;
        cell.rightLabel.text = [NSString stringWithFormat:@"%.2f",model.rewardNum];
        ((UILabel *)[cell.detailView viewWithTag:77]).text = [NSString stringWithFormat:@"%@\n%@",model.orderId,model.orderDesc];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLRewardListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.showsDetail = !cell.showsDetail;
    
    PLRewardListModel *model = dataArray[indexPath.row];
    if (cell.showsDetail) {
        model.selected = YES;
    }
    else
    {
        model.selected = NO;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLRewardListModel *model = dataArray[indexPath.row];
    if (model.selected) {
        return 100;
    }
    return 50;
}

#pragma mark Network

- (void)getRewardList
{
    NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
    if (!userId) {
        return;
    }
    [self sendRequestWithMethod:GET interface:PLInterface_Allrewards parameters:@{@"userId":userId,@"rewardType":@(rewardType),@"pNo":@(pageIndex),@"pSize":@(pageSize)}];
}

- (void)getMyRewardType
{
    NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
    if (!userId) {
        return;
    }
    
    [self sendRequestWithMethod:GET interface:PLInterface_GetMyRewardType parameters:@{@"userId":userId}];
}

- (void)updateUIWithResponse:(NSDictionary *)dic
{
    [super updateUIWithResponse:dic];
    PLInterface interface = (PLInterface)[dic[@"interface"] intValue];
    NSDictionary *response = dic[@"response"];
    NSError *error = dic[@"error"];
    
    id d = dic[@"data"];
    if ([(NSNull *)d isEqual:[NSNull null]]) {
        return;
    }
    
    if (interface == PLInterface_Allrewards) {
        if (response) {
            if (_state==tableStateRefreshing) {
                [self.baseTableView.header endRefreshing];
                _state = tableStateIdel;
            }
            else if (_state==tableStateLoding) {
                [self.baseTableView.footer endRefreshing];
                _state = tableStateIdel;
            }
            
            if (pageIndex==1) {
                [dataArray removeAllObjects];
            }
            
            NSArray *lst = ((NSDictionary *)response)[@"lst"];
            if ([(NSNull *)lst isEqual:[NSNull null]]) {
                return;
            }
            if (pageIndex > 1 && lst.count == 0) {
                pageIndex--;
                ((MJRefreshAutoStateFooter *)self.baseTableView.footer).stateLabel.text = @"已无更多";
                return;
            }
            for (NSDictionary *d in lst) {
                PLRewardListModel *model = [[PLRewardListModel alloc] init];
                model.rewardNum = [d[@"rewardNum"] doubleValue];
                model.rewardType = [d[@"rewardType"] intValue];
                model.settleTime = d[@"settleTime"];
                model.orderId = d[@"orderId"];
                model.orderDesc = d[@"orderDesc"];
                model.selected = NO;
                [dataArray addObject:model];
            }
            //如果没数据，就隐藏footerView
            if (pageIndex==1&&dataArray.count<pageSize) {
                [self setFooter:NO];
                if (dataArray.count==0) {
                    [self showFlagLabel:YES text:@"暂无数据"];
                }
                else
                {
                    [self showFlagLabel:NO text:@""];
                    [self.baseTableView reloadData];
                }
                return;
            }
            else if(dataArray.count>=pageSize)
            {
                [self showFlagLabel:NO text:@""];
                [self setFooter:YES];
            }
            
            [self.baseTableView reloadData];
        }
        if (error) {
            if (_state==tableStateRefreshing) {
                if (pageIndex==1) {
                    [self showFlagLabel:YES text:@"加载失败"];
                }
                [self.baseTableView.header endRefreshing];
                _state = tableStateIdel;
            }
            else if (_state==tableStateLoding) {
                pageIndex--;
                [self.baseTableView.footer endRefreshing];
                _state = tableStateIdel;
                if (pageIndex==1&&dataArray.count<pageSize) {
                    [self setFooter:NO];
                }
                else
                {
                    [self setFooter:YES];
                    ((MJRefreshAutoStateFooter *)self.baseTableView.footer).stateLabel.text = @"加载失败";
                }
            }
        }
    }
    else if (interface == PLInterface_GetMyRewardType) {
        [self performSelector:@selector(rightBarButtonShowIndicator:) withObject:NO afterDelay:0.2];
        if (response) {
            typeArray = [NSMutableArray new];
            [typeArray addObjectsFromArray:((NSArray *)response[@"data"])];
            [self showChooseWindow];
        }
        if (error) {
            
        }
    }
}

#pragma mark UserActions

- (void)chooseAction:(UIBarButtonItem *)button
{
    //已经打开则隐藏，否则打开
    if (_chooseWindow) {
        [_chooseWindow dismiss];
        return;
    }
    
    if (typeArray.count) {
        [self showChooseWindow];
        return;
    }
    [self getMyRewardType];
    [self rightBarButtonShowIndicator:YES];
}

- (void)shouldRefresh:(NSNumber *)flag withType:(NSNumber *)type
{
    _chooseWindow = nil;
    if ([flag boolValue]) {
        rewardType = [type intValue];
        pageIndex = 1;
        
        if ([type intValue] == 0) {
            (self.baseNavBar.items[0]).title = @"奖励统计";
        }
        else
        {
            for (NSDictionary *dic in typeArray) {
                if ([dic[@"rewardType"] isEqual:type]) {
                    (self.baseNavBar.items[0]).title = dic[@"rewardTypeName"];
                    break;
                }
            }
        }
        
        [self showFlagLabel:NO text:@""];
        [dataArray removeAllObjects];
        [self.baseTableView reloadData];
        [self.baseTableView.header beginRefreshing];
        [self setFooter:NO];
    }
}

- (void)showChooseWindow
{
    _chooseWindow = [[PLChooseWindow alloc] initWithFrame:CGRectZero];
    [_chooseWindow setItemArray:typeArray];
    _chooseWindow.delegate = self;
    [_chooseWindow show];
}

#pragma mark Others

- (void)setState:(tableState)state
{
    _state = state;
    if (state == tableStateRefreshing) {
        [self setFooter:NO];
    }
    if (state == tableStateLoding) {
        [self setHeader:NO];
    }
}

- (void)setHeader:(BOOL)flag
{
    //刷新
    if (flag) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.autoChangeAlpha = YES;
        self.baseTableView.header = header;
    }
    else
    {
        self.baseTableView.header = nil;
    }
}

- (void)refresh
{
    pageIndex=1;
    _state = tableStateRefreshing;
    [self getRewardList];
}

- (void)setFooter:(BOOL)flag
{
    if (flag) {
        self.baseTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    else
    {
        self.baseTableView.footer = nil;
    }
}

- (void)loadMore
{
    pageIndex++;
    _state = tableStateLoding;
    [self getRewardList];
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

- (void)rightBarButtonShowIndicator:(BOOL)flag
{
    if (flag) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator startAnimating];
        (self.baseNavBar.items[0]).rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
        (self.baseNavBar.items[0]).rightBarButtonItem.enabled = NO;
    }
    else
    {
        (self.baseNavBar.items[0]).rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-screen"] style:UIBarButtonItemStyleDone target:self action:@selector(chooseAction:)];
        (self.baseNavBar.items[0]).rightBarButtonItem.enabled = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
