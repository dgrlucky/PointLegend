//
//  PLMsgViewcontroller.m
//  PointLegend
//
//  Created by ydcq on 15/12/21.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLMsgViewcontroller.h"
#import "PLMsgCell.h"
#import "PLMsgDetailViewController.h"
#import "MJRefresh.h"

@interface PLMsgViewcontroller ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PLMsgViewcontroller

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self setRequestWithInterface:PLInterface_GetMsg index:@"pNo" parameters:@{@"userId":[PLUserInfoModel sharedInstance].userId,@"pNo":@(1),@"pSize":@(10)}];
}

#pragma mark Network

- (void)handleResponse:(NSDictionary *)rsp
{
    NSArray *msgArray = rsp[@"data"][@"lst"];
    if (msgArray.count==0) {
        if (self.pageIndex>1) {
            self.pageIndex--;
            footerText(@"已无更多");
        }
        else
        {
            [self showFlagLabel:YES text:@"暂无数据"];
        }
    }
    for (NSDictionary *d in msgArray) {
        PLMsgModel *model = [[PLMsgModel alloc] initContentwith:d];
        [self.dataArray addObject:model];
    }
    
    [self.baseTableView reloadData];
}

#pragma mark Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLBaseCell cellReuseIdentifier:cellTypeMsg]];
    if (cell == nil) {
        cell = [[PLMsgCell alloc] initWithType:cellTypeMsg];
    }
    if (self.dataArray.count) {
        [cell setModel:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLMsgModel *model = self.dataArray[indexPath.row];
    CGFloat height = [model.msgDesc heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:(SCREEN_WIDTH-30)];
    if (height > 40) {
        height = 40;
    }
    if (height < 11) {
        height = 11;
    }
    return height+33;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLMsgModel *model = self.dataArray[indexPath.row];
    PLMsgDetailViewController *vc = [[PLMsgDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark Others

@end
