//
//  PLNearbyViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLRewardViewController.h"
#import "PLBaseCell.h"
#import "PLRewardListViewController.h"
#import "PLMySuggestionViewController.h"
#import "PLInvitViewController.h"
#import "PLHelpRegisterViewController.h"
#import "UILabel+indicator.h"
#import "PLRewardRuleController.h"
#import "PLLoginViewController.h"
#import "PLBaseNavigationController.h"

NSString *PLRefreshRewardNumNotification = @"PLRefreshRewardNumNotification";

#define BackGroupHeight (iPhone4?152:(254*SCREEN_HEIGHT/375.f))

#define CellHeight (iPhone4?50:(67*SCREEN_WIDTH/375.f))

@interface PLRewardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arr;
    
    UIImageView *imageBG;
    UIView *BGView;
    
    UILabel *moneyLabel;//大余额
    UILabel *rLabel;//累计奖励
    
    NSString *remMoney;//余额
    NSString *pNum;//会员数
    
    UIButton *setBtn; //帮助
    
    BOOL isLoading;
}
@end

@implementation PLRewardViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        arr = @[@[@{@"img":@"icon-Statistics",@"title":@"奖励统计"},@{@"img":@"icon-recommend",@"title":@"我的推荐"}],@[@{@"img":@"icon-gift",@"title":@"邀请有礼"},@{@"img":@"icon-help-people",@"title":@"帮人注册"}]];
        
        isLoading = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoneyNum) name:@"PLUserLoginNotification" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoneyNum) name:PLRefreshRewardNumNotification object:nil];
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 8;
    self.baseTableView.sectionFooterHeight = 0.1f;
    self.baseTableView.contentInset=UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    self.baseTableView.showsVerticalScrollIndicator = NO;
    
    [self addUserInfoView];
    
    [self getMoneyNum];
}

#pragma mark Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLBaseCell cellReuseIdentifier:cellTypeSubTitle]];
    if (cell == nil) {
        cell = [[PLBaseCell alloc] initWithType:cellTypeSubTitle];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section) {
        cell.infoDic = arr[indexPath.section-1][indexPath.row];
        cell.titleLabel.frame = CGRectMake(59, 0, 200, CellHeight);
        cell.headImageView.frame = CGRectMake(15, (CellHeight-25)/2.f, 25, 25);
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //奖励余额+推荐会员
        for (int i = 0; i < 2; i++) {
            UIView *v = [[UIView alloc] init];
            v.tag = 100+i;
            [cell.contentView addSubview:v];
            v.frame = CGRectMake((SCREEN_WIDTH/2.f)*i, 0, SCREEN_WIDTH/2.f, CellHeight+10);
            
            UILabel *lab = [[UILabel alloc] init];
            lab.textColor = RGB(102, 102, 102);
            lab.textAlignment = NSTextAlignmentCenter;
            [v addSubview:lab];
            lab.tag = 1;
            lab.frame = CGRectMake(0, 8, SCREEN_WIDTH/2.f, 20);
            
            UILabel *lab2 = [[UILabel alloc] init];
            lab2.textAlignment = NSTextAlignmentCenter;
            lab2.textColor = [UIColor redColor];
            lab2.font = [UIFont systemFontOfSize:23];
            lab2.tag = 2;
            [v addSubview:lab2];
            lab2.frame = CGRectMake(0, 30, SCREEN_WIDTH/2.f, CellHeight-30);
        }
        //分隔线
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:imageView];
        imageView.frame = CGRectMake(SCREEN_WIDTH/2.f-0.25, 0, 0.5, CellHeight+10);
        
        ((UILabel *)[[cell.contentView viewWithTag:100] viewWithTag:1]).text = @"奖励余额(元)";
        ((UILabel *)[[cell.contentView viewWithTag:100] viewWithTag:2]).text = remMoney;
        ((UILabel *)[[cell.contentView viewWithTag:101] viewWithTag:1]).text = @"推荐会员数(人)";
        ((UILabel *)[[cell.contentView viewWithTag:101] viewWithTag:2]).text = pNum;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0?CellHeight+10:CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        PLRewardListViewController *vc = [[PLRewardListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        PLMySuggestionViewController *vc = [[PLMySuggestionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        PLInvitViewController *vc = [[PLInvitViewController alloc] initWithNibName:@"PLInvitViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        PLHelpRegisterViewController *vc = [[PLHelpRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    
    if (yOffset < -BackGroupHeight) {
        
        CGRect rect = imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        
        imageBG.frame = rect;
        
        NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
        if (!userId) {
            return;
        }
        
        if (!isLoading && ((yOffset+BackGroupHeight)<-15)) {
            [moneyLabel showIndicator];
        }
    }
    
    return;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!isLoading && moneyLabel.indicator.superview) {
        [self getMoneyNum];
    }
}

- (void)logOut
{
    NSLog(@"%s",__func__);
    [moneyLabel hideIndicator];
    moneyLabel.text = nil;
    remMoney = pNum = nil;
    [self.baseTableView reloadData];
}

#pragma mark NetWork

- (void)getMoneyNum
{
    if (isLoading) {
        return;
    }
    NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
    if (!userId) {
        return;
    }
    if (!isLoading) {
        isLoading = YES;
    }
    [moneyLabel showIndicator];
    
    //网络请求
    [self sendRequestWithMethod:GET interface:PLInterface_Rewardsum parameters:@{@"userId":userId}];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    isLoading = NO;
    [moneyLabel hideIndicator];
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    NSDictionary *dic = response[@"data"];
    if ([(NSNull *)dic isEqual:[NSNull null]]) {
        return;
    }
    moneyLabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"rewardSum"] doubleValue]];
    remMoney = [NSString stringWithFormat:@"%.2f",[dic[@"rewardBalance"] doubleValue]];
    pNum = [NSString stringWithFormat:@"%d",[dic[@"recommendedUserSum"] intValue]];
    [self.baseTableView reloadData];
}

#pragma mark UserActions

- (void)setButtonClicked:(UIButton *)btn
{
    PLRewardRuleController *webVC = [[PLRewardRuleController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark Others

- (void)addUserInfoView
{
    if (!imageBG) {
        imageBG=[[UIImageView alloc]init];
        imageBG.frame=CGRectMake(0, -BackGroupHeight, SCREEN_WIDTH, BackGroupHeight);
        imageBG.image=[UIImage imageNamed:@"bg-Reward.jpg"];
        imageBG.contentMode = UIViewContentModeScaleAspectFill;
        imageBG.clipsToBounds = YES;
        [self.baseTableView addSubview:imageBG];
    }
    
    if (!BGView) {
        BGView=[[UIView alloc]init];
        BGView.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
        BGView.frame=CGRectMake(0, -BackGroupHeight, SCREEN_WIDTH, BackGroupHeight);
        [self.baseTableView addSubview:BGView];
    }
    
    if (!moneyLabel) {
        moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, SCREEN_WIDTH, BackGroupHeight-44-20)];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        moneyLabel.textColor = [UIColor whiteColor];
        moneyLabel.font = [UIFont boldSystemFontOfSize:45];
        moneyLabel.adjustsFontSizeToFitWidth = YES;
        [BGView addSubview:moneyLabel];
    }
    
    if (!rLabel) {
        rLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 20)];
        rLabel.text = @"累计奖励(元)";
        rLabel.font = [UIFont systemFontOfSize:18];
        rLabel.textAlignment = NSTextAlignmentCenter;
        rLabel.textColor = [UIColor whiteColor];
        rLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [BGView addSubview:rLabel];
    }
    
    if (!setBtn) {
        setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setBtn.frame = CGRectMake(SCREEN_WIDTH-54,29,50,50);
        UIImage *image = [UIImage imageNamed:@"icon-help"];
        [setBtn setImage:image forState:UIControlStateNormal];
        [setBtn setImage:[self imageByApplyingAlpha:0.4 image:image] forState:UIControlStateHighlighted];
        [setBtn addTarget:self action:@selector(setButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [BGView addSubview:setBtn];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
