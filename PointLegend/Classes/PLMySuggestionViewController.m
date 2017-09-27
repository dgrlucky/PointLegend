//
//  PLMySuggestionViewController.m
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLMySuggestionViewController.h"
#import "PLMySuggestionCell.h"
#import "MJRefresh.h"
#import "PLSugListModel.h"

typedef NS_ENUM(NSInteger, tableState)
{
    tableStateIdel,
    tableStateRefreshing,
    tableStateLoding
};

const int pSize = 10;

@interface PLMySuggestionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex; //索引页
    
    NSMutableArray *dataArray; //数据源
    
    UILabel *flagLabel;
}

@property (nonatomic, assign) tableState state; //列表状态

@end

@implementation PLMySuggestionViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
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
    item.title = @"我的推荐";
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:self action:@selector(popToPreviousVC)];
    
    [self setHeader:YES];
    
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 56;
    
    [self.baseTableView.header beginRefreshing];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        dataArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark Delegate

static NSString *identy = @"cell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLMySuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLMySuggestionCell cellReuseIdentifier:cellTypeReward]];
    if (cell == nil) {
        cell = [[PLMySuggestionCell alloc] initWithType:cellTypeReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataArray.count) {
        PLSugListModel *model = dataArray[indexPath.row];
        
        NSString *tel = [NSString stringWithFormat:@"%@",model.recommendedUserTel];
        if (tel.length>=8) {
            NSRange range = NSMakeRange(tel.length-8, 4);
            NSString *str = [tel substringWithRange:range];
            tel = [tel stringByReplacingOccurrencesOfString:str withString:@"****" options:NSCaseInsensitiveSearch range:NSMakeRange(tel.length-8, 4)];
        }
        
        cell.titleLabel.text = tel;
        cell.subTitleLabel.text = model.recommendedUserName;
        cell.rightLabel1.text = [NSString stringWithFormat:@"通过%@推荐",RecommandWayDic[[NSString stringWithFormat:@"%d",model.recommendedWay]]];
        cell.rightLabel2.text = model.recommendedTime;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

#pragma mark Network

- (void)getsugList
{
    NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
    if (!userId) {
        return;
    }
    [self sendRequestWithMethod:GET interface:PLInterface_getMyRefUserList parameters:@{@"userId":userId,@"pNo":@(pageIndex),@"pSize":@(pSize)}];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    if (response) {
        if (_state==tableStateRefreshing) {
            [self.baseTableView.header endRefreshing];
            _state = tableStateIdel;
        }
        else if (_state==tableStateLoding) {
            [self.baseTableView.footer endRefreshing];
            _state = tableStateIdel;
        }
        
        NSDictionary *dic = response[@"data"];
        if ([(NSNull *)dic isEqual:[NSNull null]]) {
            return;
        }
        if (interface == PLInterface_getMyRefUserList) {
            if (pageIndex==1) {
                [dataArray removeAllObjects];
            }
            NSArray *lst = ((NSDictionary *)dic)[@"lst"];
            if ([(NSNull *)lst isEqual:[NSNull null]]) {
                return;
            }
            if (pageIndex > 1 && lst.count == 0) {
                pageIndex--;
                ((MJRefreshAutoStateFooter *)self.baseTableView.footer).stateLabel.text = @"已无更多";
                return;
            }
            for (NSDictionary *d in lst) {
                PLSugListModel *model = [[PLSugListModel alloc] init];
                model.recommendedUserId = [d[@"recommendedUserId"] longLongValue];
                model.recommendedUserType = [d[@"recommendedUserType"] intValue];
                model.recommendedUserName = d[@"recommendedUserName"];
                model.recommendedWay = [d[@"recommendWay"] intValue];
                if (model.recommendedWay < 0 || model.recommendedWay > 11) {
                    model.recommendedWay = 0;
                }
                model.recommendedUserTel = d[@"recommendedUserTel"];
                model.recommendedTime = d[@"recommendTime"];
                [dataArray addObject:model];
            }
            if (pageIndex==1&&dataArray.count<pSize) {
                [self setFooter:NO];
                if (dataArray.count==0) {
                    [self showFlagLabel:YES text:@"暂无数据"];
                }
                else
                {
                    [self.baseTableView reloadData];
                    [self showFlagLabel:NO text:@""];
                }
                return;
            }
            else if(dataArray.count>=pSize)
            {
                [self showFlagLabel:NO text:@""];
                [self setFooter:YES];
            }
            [self.baseTableView reloadData];
        }
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
            if (pageIndex==1&&dataArray.count<pSize) {
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

- (void)refreshViews:(id)responseObject WithServiceName:(NSString *)name
{
    
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
    [self getsugList];
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
    [self getsugList];
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
    flagLabel.center = CGPointMake(SCREEN_WIDTH/2.f, self.baseTableView.frame.size.height/2.f);
    flagLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self.baseTableView addSubview:flagLabel];
    [self.baseTableView bringSubviewToFront:flagLabel];
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
