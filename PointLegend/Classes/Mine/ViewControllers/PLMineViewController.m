//
//  PLMineViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLMineViewController.h"
#import "Masonry.h"
#import "UIScrollView+Direction.h"
#import "UIScrollView+Addition.h"
#import "PLSuggessionViewController.h"
#import "UIImage+Scale.h"
#import "PLLoginViewController.h"
#import "PLBaseNavigationController.h"
#import "PLQRcodeWindow.h"
#import "UIButton+Block.h"
#import "PLUserInfoViewController.h"
#import "PLBaseNavigationController.h"
#import "UIImageView+WebCache.h"
#import "PLMsgViewcontroller.h"
#import "PLSettingViewController.h"
#import "PLCollectViewController.h"

#define lineHeight 0.5

#define BackGroupHeight (iPhone4?92:222)
const CGFloat HeadImageHeight= 60;

#pragma mark Class--PLMineViewController

@interface PLMineViewController ()<UITableViewDataSource,UITableViewDelegate,PLLoginViewControllerDelegate>
{
    UIImageView *imageBG;
    UIView *BGView;
    
    UIButton *headButton;
    UILabel *nameLabel;
    UILabel *phoneNumLabel;
    UIButton *loginButton;
    UILabel *titleLabel;
    
    NSDictionary *infoDic;
    
    NSString *money;
    
    PLQRcodeWindow *qrWindow;
    
    NSString *msgNum;
}

@end

@implementation PLMineViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        infoDic = @{@"img":@[@[@"order"],@[@"wallet"],@[@"collect",@"msg"],@[@"suggestion"],@[@"order"]],
                    @"title":@[@[@"订单"],@[@"钱包"],@[@"收藏",@"消息"],@[@"意见"],@[@"设置"]]};
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headImgChanged:) name:PLUserHeadImgChanedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.baseNavBar setShadowImage:[[UIImage alloc] init]];
//    
//    [self.baseNavBar setBackgroundImage:imageWithColor([[UIColor whiteColor]colorWithAlphaComponent:0]) forBarMetrics:UIBarMetricsDefault];

    [self.baseNavBar removeFromSuperview];
    self.baseNavBar = nil;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOOL_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.hidden = NO;
    
    self.baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = iPhone4?11:20;
    self.baseTableView.sectionFooterHeight = 0.1f;
    self.baseTableView.contentInset=UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    self.baseTableView.showsVerticalScrollIndicator = NO;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.rowHeight = 50;
    
    self.state = loginStateUnlog;
    
    [self addUserInfoView];
    
    [self.view bringSubviewToFront:self.baseNavBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getWalletMoney];
}

#pragma mark Network

- (void)getWalletMoney
{
    NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
    if (!userId) {
        return;
    }
    [self sendRequestWithMethod:GET interface:PLInterface_GetAccountMoney parameters:@{@"userId":userId}];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    id data = response[@"data"];
    if ((NSNull *)data == [NSNull null]) {
        return;
    }
    
    if (interface == PLInterface_GetAccountMoney) {
        if (response) {
            id obj = data[@"amount"];
            if ((NSNull *)obj == [NSNull null]) {
                return;
            }
            money = [NSString stringWithFormat:@"余额：%.2f",[data[@"amount"] doubleValue]];
            [self.baseTableView reloadData];
        }
    }
}

#pragma mark UserActions

- (void)addUserInfoView
{
    if (!imageBG) {
        imageBG=[[UIImageView alloc]init];
        imageBG.frame=CGRectMake(0, -BackGroupHeight, SCREEN_WIDTH, BackGroupHeight+70);
        imageBG.image=[UIImage imageNamed:@"bg"];
        imageBG.contentMode = UIViewContentModeScaleAspectFill;
        imageBG.clipsToBounds = YES;
        [self.baseTableView addSubview:imageBG];
        [self.baseTableView sendSubviewToBack:imageBG];
    }
    
    if (!BGView) {
        BGView=[[UIView alloc]init];
        BGView.backgroundColor=[UIColor clearColor];
        BGView.frame=CGRectMake(0, -BackGroupHeight, SCREEN_WIDTH, BackGroupHeight+70);
        [self.baseTableView addSubview:BGView];
        [self.baseTableView sendSubviewToBack:BGView];
    }
    
//    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    setBtn.bounds = CGRectMake(0, 0, 25, 25);
//    setBtn.center = CGPointMake(SCREEN_WIDTH-30, 40);
//    UIImage *image = [UIImage imageNamed:@"setting"];
//    [setBtn setImage:image forState:UIControlStateNormal];
//    [setBtn setImage:[image imageByApplyingAlpha:0.4] forState:UIControlStateHighlighted];
//    [setBtn addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    baseNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
}

#pragma mark TableViewDelegate

static NSString *identy3 = @"itenty3";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy3];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy3];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIColor *color = [UITableView new].separatorColor;
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lineHeight)];
        line1.backgroundColor = color;
        line1.tag = 55;
        [cell addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-lineHeight, SCREEN_WIDTH, lineHeight)];
        line2.backgroundColor = color;
        line2.tag = 56;
        [cell addSubview:line2];
        
        __weak typeof(cell) weakCell = cell;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell addSubview:imageView];
        imageView.tag = 8999;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakCell.mas_left).with.offset(15);
            make.top.equalTo(weakCell.mas_top).with.offset(7.5);
            make.bottom.equalTo(weakCell.mas_bottom).with.offset(-7.5);
            make.width.equalTo(imageView.mas_height);
        }];
        
        //姓名
        UILabel *lab = [[UILabel alloc] init];
        lab.tag = 8888;
        [cell addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).with.offset(15);
            make.top.equalTo(weakCell.mas_top).with.offset(lineHeight);
            make.bottom.equalTo(weakCell.mas_bottom);
            make.right.equalTo(weakCell.mas_right).with.offset(-52);
        }];
        
        //手机号
        UILabel *phoneNumLab = [[UILabel alloc] init];
        phoneNumLab.tag = 8889;
        [cell addSubview:phoneNumLab];
        phoneNumLab.font = [UIFont systemFontOfSize:15];
        phoneNumLab.textColor = [UIColor whiteColor];
        [phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_left);
            make.top.equalTo(lab.mas_bottom).with.offset(5);
            make.bottom.equalTo(weakCell.mas_bottom).with.offset(-13);
            make.right.equalTo(lab.mas_right);
        }];
        
        //二维码
        UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:qrButton];
        qrButton.tag = 8890;
        [qrButton setImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
        [qrButton setImage:[[UIImage imageNamed:@"qrcode"] imageByApplyingAlpha:0.4] forState:UIControlStateHighlighted];
        [qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakCell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.right.equalTo(weakCell.mas_right).with.offset(-30);
        }];
        WS(weakSelf);
        [qrButton addActionHandler:^(NSInteger tag) {
            SS(strongSelf);
            strongSelf->qrWindow = [[PLQRcodeWindow alloc] initWithFrame:CGRectZero];
            [strongSelf->qrWindow setQRImageWithString:@"http://www.baidu.com"];
            strongSelf->qrWindow.delegate = weakSelf;
            [UIView animateWithDuration:0.2 animations:^{
                strongSelf->qrWindow.alpha = 1;
            }];
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.tag = 9000;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakCell.mas_right).with.offset(-28);
            make.width.mas_equalTo(200);
            make.top.equalTo(weakCell.mas_top).with.offset(lineHeight);
            make.bottom.equalTo(weakCell.mas_bottom);
        }];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:9000];
    UILabel *lab = (UILabel *)[cell viewWithTag:8888];
    UILabel *phoneNumLab = (UILabel *)[cell viewWithTag:8889];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:8999];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[cell viewWithTag:55] setHidden:YES];
        [[cell viewWithTag:56] setHidden:YES];
        
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.bounds.size.width/2.f;
        
        cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        cell.selectedBackgroundView = view;
        cell.tintColor = [UIColor whiteColor];
        __weak typeof(cell) weakCell = cell;
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakCell.mas_top).with.offset(7.5);
            make.bottom.equalTo(weakCell.mas_bottom).with.offset(-7.5);
        }];
        
        imageView.image = [UIImage imageNamed:@"head"];
        
        if (self.state != loginStatelog)
        {
            [[cell viewWithTag:8890] setHidden:YES];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (self.state == loginStateUnlog) {
                lab.text = @"请点击登录";
            }
            else if (self.state == loginStatelogging)
            {
                lab.text = @"登录中...";
            }
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont boldSystemFontOfSize:18];
        }
        else
        {
            [[cell viewWithTag:8890] setHidden:NO];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[PLUserInfoModel sharedInstance].imgSmall] placeholderImage:[UIImage imageNamed:@"head"]];
            
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakCell.mas_top).with.offset(10);
                make.bottom.equalTo(weakCell.mas_bottom).with.offset(-37);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            lab.text = [PLUserInfoModel sharedInstance].nikeName?:@"一点传奇";
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:17];
            phoneNumLab.text = [PLUserInfoModel sharedInstance].phoneNum;
        }
    }
    else
    {
        imageView.clipsToBounds = NO;
        imageView.layer.cornerRadius = 0;
        [[cell viewWithTag:8889] setHidden:YES];
        [[cell viewWithTag:8890] setHidden:YES];
        [[cell viewWithTag:55] setHidden:NO];
        [[cell viewWithTag:56] setHidden:NO];
        if (indexPath.section == 3 && indexPath.row == 0) {
            [[cell viewWithTag:55] setHeight:0.5];
            [[cell viewWithTag:56] setHidden:YES];
        }
        if (indexPath.section == 3 && indexPath.row == 1) {
            [[cell viewWithTag:55] setX:29+15*2];
            [[cell viewWithTag:55] setHeight:0.5];
        }
    }
    
    if (indexPath.section == 2 || indexPath.section == 4) {
        label.hidden = NO;
        if (indexPath.section == 2) {
            label.text = money;
        }
        if (indexPath.section == 4) {
            label.text = @"让我们更好！";
        }
    }
    else {
        label.hidden = YES;
    }
    
    if (infoDic && indexPath.section > 0) {
        imageView.image = [UIImage imageNamed:infoDic[@"img"][indexPath.section-1][indexPath.row]];
        lab.text = infoDic[@"title"][indexPath.section-1][indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 3:
            return 2;
        default:
            return 1;
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 0) {
        PLSuggessionViewController *vc = [[PLSuggessionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        PLCollectViewController *vc = [[PLCollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        PLMsgViewcontroller *vc = [[PLMsgViewcontroller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_state != loginStatelog) {
            PLLoginViewController *loginVC = [[PLLoginViewController alloc] init];
            loginVC.delegate = self;
            PLBaseNavigationController *nav = [[PLBaseNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            PLUserInfoViewController *vc = [[PLUserInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 5) {
        PLSettingViewController *vc = [[PLSettingViewController alloc] init];
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
        rect.size.height =  -yOffset+70;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        
        imageBG.frame = rect;
    }
    
    return;
}

#pragma mark PLLoginDelegate

- (void)changeState:(NSNumber *)state
{
    self.state = [state intValue];
}

- (void)setState:(loginState)state
{
    _state = state;
    
    [self.baseTableView reloadData];
}

#pragma mark statusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark WindowDelegate

- (void)touchesBegin
{
    qrWindow = nil;
}

#pragma mark others

- (void)headImgChanged:(NSNotification *)notify
{
    [self.baseTableView reloadData];
}

@end
