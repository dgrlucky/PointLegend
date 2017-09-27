//
//  PLBankListViewController.m
//  PointLegend
//
//  Created by 1dcq on 15/11/25.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBankListViewController.h"

@interface PLBankListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)NSMutableArray *bankArr;
@property(nonatomic, assign)int            page;
@property(nonatomic, strong)UITableView    *listTableView;
@end

@implementation PLBankListViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    baseNavItem.title = @"我的银行卡";
    
    
    
    [self initViews];
    
//    WS(weakSelf);
    // 上拉刷新
//    self.listTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf getUserBankCards];
//    }];
    
}

- (void)initDatas
{
    self.page = 0;
    self.bankArr = [NSMutableArray array];
}

- (void)initViews
{
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    self.listTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 48)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, footerView.height-5)];
    lab.text = @"目前支持：工行、招行、建行、中行、农行、交行、浦发、广发、中信、光大、兴业、民生、平安、杭州银行、邮政储蓄、宁波银行";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor darkGrayColor];
    lab.numberOfLines = 2;
    lab.font = [UIFont systemFontOfSize:10];
    lab.backgroundColor = [UIColor clearColor];
    [footerView addSubview:lab];
    self.listTableView.tableFooterView = footerView;
    

    
    baseNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:0 target:self action:@selector(addBankCard)];

    
}

- (void)addBankCard
{
    
}

- (void)getUserBankCards
{
    self.page++;
    
    
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:@"我的银行卡"];
    cell.textLabel.text = @"中国银行";
    cell.detailTextLabel.text = @"卡号后4位1234";
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
