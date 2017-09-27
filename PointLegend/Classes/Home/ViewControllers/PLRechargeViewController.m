//
//  PLRechargeViewController.m
//  PointLegend
//
//  Created by 1dcq on 15/11/25.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLRechargeViewController.h"

#define BGVIEW_HEIGHT 42
#define DISTANCE_TOP  11
#define DISTANCE_LEFT 15
@interface PLRechargeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITextField *amountTF;
@property(nonatomic, strong)UITableView *rechargeTableView;
@property(nonatomic, strong)NSArray     *titleArr;
@property(nonatomic, strong)NSArray     *picArr;
@end

@implementation PLRechargeViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    baseNavItem.title = @"充值";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initViews];
}

- (void)initDatas
{
    self.titleArr = @[@"支付宝",@"贷记卡",@"借记卡"];
    
}

- (void)initViews
{
    
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
    
    UIView *rechargeMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, BGVIEW_HEIGHT)];
    rechargeMoneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rechargeMoneyView];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(DISTANCE_LEFT, DISTANCE_TOP, 80, 21);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"充值金额";
    [rechargeMoneyView addSubview:titleLabel];
    
//    __weak typeof(rechargeMoneyView) weakRechargeView = rechargeMoneyView;
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(weakRechargeView).width.offset(DISTANCE_LEFT);
//        make.top.mas_equalTo(weakRechargeView).width.offset(DISTANCE_TOP);
//        make.width.equalTo(@70);
//        make.height.equalTo(@21);
//    }];
    
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, DISTANCE_TOP, 21, 21)];
    symbolLabel.text = @"¥";
    symbolLabel.font = [UIFont systemFontOfSize:14];
    [rechargeMoneyView addSubview:symbolLabel];
    
    self.amountTF = [[UITextField alloc] initWithFrame:CGRectMake(symbolLabel.right, DISTANCE_TOP, 150, 21)];
    self.amountTF.placeholder = @"请输入充值金额";
    self.amountTF.font = [UIFont systemFontOfSize:14];
    self.amountTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [rechargeMoneyView addSubview:self.amountTF];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
