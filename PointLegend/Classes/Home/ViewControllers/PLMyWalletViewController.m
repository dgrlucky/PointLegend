//
//  PLMyWalletViewController.m
//  PointLegend
//
//  Created by 1dcq on 15/11/24.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLMyWalletViewController.h"
//#import "PLRechargeViewController.h"
#import "PLBankListViewController.h"

@interface PLMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *walletTableView;
}

@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *picArr;
@end

@implementation PLMyWalletViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    baseNavItem.title = @"我的钱包";
    
    self.titleArr = @[@[@"当前账户余额",@"充值"],@[@"我的银行卡",@"消费卡"]];
    self.picArr = @[@[@"",@""],@[@"我的银行卡",@"消费卡"]];
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)initViews
{
    UIButton *billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    billBtn.frame = CGRectMake(0, 0, 80, 44);
    [billBtn setTitle:@"我的账单" forState:UIControlStateNormal];
    [billBtn setTitleColor:COLOR(87, 108, 137, 1) forState:UIControlStateNormal];
    billBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [billBtn addTarget:self action:@selector(billClick) forControlEvents:UIControlEventTouchUpInside];
    billBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    billBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:billBtn];
    baseNavItem.rightBarButtonItem = barButton;
   
    
    walletTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
    walletTableView.delegate = self;
    walletTableView.dataSource = self;
    [self.view addSubview:walletTableView];
    
    if ([walletTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [walletTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([walletTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [walletTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)billClick
{
    NSLog(@"跳转到我的账单");
}


#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.titleArr objectAtIndex:section];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
        [cell.contentView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(15, 13, 100, 21);
        if(indexPath.row == 0){
            UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-300, 65, 300, 30)];
            moneyLabel.textColor = [UIColor redColor];
            moneyLabel.textAlignment = NSTextAlignmentRight;
            moneyLabel.font = [UIFont systemFontOfSize:27];
            moneyLabel.text = [NSString stringWithFormat:@"¥%@",@"23456789.00"];
            NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:moneyLabel.text];
            [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
            [moneyLabel setAttributedText:moneyStr];
            
            [cell.contentView addSubview:moneyLabel];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }else {
        
       cell.imageView.image = [UIImage imageNamed:self.picArr[indexPath.section][indexPath.row]];
        cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
        
    }
    
   return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
            {
//                PLRechargeViewController *rechargeVC = [[PLRechargeViewController alloc] init];
//                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                PLBankListViewController *bankListVC = [[PLBankListViewController alloc] init];
                [self.navigationController pushViewController:bankListVC animated:YES];
            }
                break;
             case 1:
            {
            
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 100;
    }else{
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
