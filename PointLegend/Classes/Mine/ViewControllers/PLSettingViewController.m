//
//  PLSettingViewController.m
//  PointLegend
//
//  Created by ydcq on 15/12/22.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLSettingViewController.h"
#import "PLBaseCell.h"
#import "PLButton.h"

@interface PLSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *infoArray;
}

@end

@implementation PLSettingViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"设置";
        infoArray = @[@{@"title":@"关于我们",@"img":@"icon-Statistics"},@{@"title":@"帮助中心",@"img":@"icon-Statistics"},@{@"title":@"用户授权",@"img":@"icon-Statistics"},@{@"title":@"检测更新",@"img":@"icon-Statistics"}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBaseTableViewWithStyle:UITableViewStyleGrouped frame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    PLButton *extButton = [PLButton buttonWithFrame:CGRectMake(10, 15, SCREEN_WIDTH-10*2, 40) backgroundColor:[UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1] title:@"退出登录" titleFont:[UIFont systemFontOfSize:20] cornerRadius:YES tag:1000 actionBlock:^(NSInteger tag) {
        
    }];
    [footerView addSubview:extButton];
    self.baseTableView.tableFooterView = footerView;
    self.baseTableView.sectionFooterHeight = 8;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 96)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-QQ"]];
    logoImg.center = CGPointMake(SCREEN_WIDTH/2.f, 40);
    logoImg.bounds = CGRectMake(0, 0, 40, 40);
    [headerView addSubview:logoImg];
    UILabel *versionLabel = [[UILabel alloc] init];
    NSString *versionString = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]][@"CFBundleShortVersionString"];
    versionLabel.text = [@"V" stringByAppendingString:versionString];
    
    versionLabel.frame = CGRectMake(0, 60, SCREEN_WIDTH, 20);
    versionLabel.font = [UIFont systemFontOfSize:16];
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:versionLabel];
    self.baseTableView.tableHeaderView = headerView;
}

#pragma mark Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLBaseCell cellReuseIdentifier:cellTypeDefault]];
    if (!cell) {
        cell = [[PLBaseCell alloc] initWithType:cellTypeDefault];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = infoArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"img"]];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return infoArray.count;
}

#pragma mark Others

@end
