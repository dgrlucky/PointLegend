//
//  PLMsgDetailViewController.m
//  PointLegend
//
//  Created by ydcq on 15/12/22.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLMsgDetailViewController.h"
#import "PLBaseCell.h"

@interface PLMsgDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PLMsgDetailViewController

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
    
    //无需再发请求
//    [self getMsgDetail];
    
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
}

#pragma mark Network

- (void)getMsgDetail
{
    [self sendRequestWithMethod:GET interface:PLInterface_getMsgDetail parameters:@{@"messageId":_model.messageId}];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    if (interface == PLInterface_getMsgDetail) {
        if (response) {
            
        }
        if (error) {
            
        }
    }
}

#pragma mark Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLBaseCell cellReuseIdentifier:cellTypeDefault]];
    if (cell == nil) {
        cell = [[PLBaseCell alloc] initWithType:cellTypeDefault];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.titleLabel.textColor = [UIColor lightGrayColor];
        cell.titleLabel.text = _model.pubTime;
    }
    else
    {
        cell.titleLabel.numberOfLines = 0;
        cell.titleLabel.textColor = RGB(102, 102, 102);
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.titleLabel.text = _model.msgDesc;
        CGFloat height = [_model.msgDesc heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:(SCREEN_WIDTH-23)];
        cell.titleLabel.frame = CGRectMake(15, 10, SCREEN_WIDTH-15-8, height);
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 44;
    }
    CGFloat height = [_model.msgDesc heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:(SCREEN_WIDTH-23)]+20;
    if (height < 44) {
        height = 44;
    }
    return height;
}

#pragma mark Others

- (void)setModel:(PLMsgModel *)model
{
    _model = model;
    self.title = _model.msgTitle;
}

@end
