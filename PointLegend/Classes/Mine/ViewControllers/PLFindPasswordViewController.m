//
//  PLFindPasswordViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/30.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLFindPasswordViewController.h"
#import "PLInputCell.h"
#import "UIButton+Block.h"
#import "UIButton+Indicator.h"

@interface PLFindPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
    NSString *phoneNum;
    NSString *verifyCode;
    NSString *verifyCodeButtonTitle;
}

@end

@implementation PLFindPasswordViewController

#pragma mark lifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        phoneNum = verifyCode = @"";
        dataArray = [[NSMutableArray alloc] initWithArray:@[@{@"placeholder":@"请输入手机号",@"title":@"手机号",@"text":phoneNum},@{@"placeholder":@"请输入验证码",@"title":@"验证码",@"text":verifyCode}]];
        verifyCodeButtonTitle = @"获取验证码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"重设密码";
    
    [self setBaseTableViewWithStyle:UITableViewStyleGrouped frame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
    //footerView
    WS(weakSelf);
    self.baseTableView.tableFooterView = ^(){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:button];
        
        __weak typeof(footerView) weakFooterView = footerView;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakFooterView.mas_left).with.offset(16);
            make.right.equalTo(weakFooterView.mas_right).with.offset(-16);
            make.top.equalTo(weakFooterView.mas_top).with.offset(0);
            make.height.mas_equalTo(38);
        }];
        
        [button setTitleColor:UIColorFromRGB(0xc8c7cc) forState:UIControlStateNormal];
        button.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        button.tag = 5000;
        button.enabled = NO;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1.5f;
        [button addTarget:weakSelf action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        
        return footerView;
    }();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    PLInputCell *cell = (PLInputCell *)[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.inputTX.text.length==0) {
        [cell.inputTX becomeFirstResponder];
    }
}

#pragma mark delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLInputCell cellReuseIdentifier:cellTypeInput]];
    if (cell == nil) {
        cell = [[PLInputCell alloc] initWithType:cellTypeInput];
        cell.inputTX.keyboardType = UIKeyboardTypeNumberPad;
        [cell.inputTX addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
    }
    [cell.vButton addTarget:self action:@selector(getVeriCode:) forControlEvents:UIControlEventTouchUpInside];
    if (dataArray.count) {
        cell.infoDic = dataArray[indexPath.row];
    }
    if (indexPath.row == 1) {
        cell.vButton.hidden = NO;
        [cell.vButton setTitle:verifyCodeButtonTitle forState:UIControlStateNormal];
    }
    else
    {
        cell.vButton.hidden = YES;
        [cell.vButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark useractions

- (void)getVeriCode:(UIButton *)btn
{
    WS(weakSelf);
//    [self.dataTaskArray addObject:[PLHttpTools get:PLInterface_GetVeriCode params:@{@"mobile":phoneNum,@"usage":@"找回密码"} result:^(NSDictionary *dic, NSError *error) {
//        if (error) {
//            [weakSelf handleNetworkError:error];
//        }
//        else
//        {
//            [weakSelf updateUIWithResponse:dic interface:PLInterface_GetVeriCode];
//            if ([dic[@"code"] intValue] == 0) {
//                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(countDown:) userInfo:nil repeats:YES];
//                [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
//            }
//        }
//    }]];
}

- (void)countDown:(NSTimer *)timer
{
    static int count = 60;
    verifyCodeButtonTitle = [NSString stringWithFormat:@"%ds后再次获取",count--];
    PLInputCell *cell = [self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIButton *button = cell.vButton;
    [button setTitle:verifyCodeButtonTitle forState:UIControlStateNormal];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
    }];
    if (count>0 && button.enabled) {
        button.enabled = NO;
    }
    
    if (count == 0) {
        [self.timer invalidate];self.timer=nil;
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
        button.enabled = YES;
        count = 60;
    }
}

- (void)changeText:(UITextField *)textField
{
    UIResponder *rsp = textField;
    UITableViewCell *cell = ^(UIResponder *r){
        while(r && ![r isKindOfClass:[UITableViewCell class]]){
            r = r.nextResponder;}
        return (UITableViewCell *)r;}
    (rsp);
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        phoneNum = textField.text;
    }
    if (indexPath.row == 1) {
        verifyCode = textField.text;
    }
    
    UIButton *button = (UIButton *)[self.baseTableView.tableFooterView viewWithTag:5000];
    if (phoneNum.length>0 && verifyCode.length>0) {
        [button setTitleColor:UIColorFromRGB(0x3d4245) forState:UIControlStateNormal];
        button.layer.borderColor = UIColorFromRGB(0x929292).CGColor;
        button.enabled = YES;
    }
    else
    {
        [button setTitleColor:UIColorFromRGB(0xc8c7cc) forState:UIControlStateNormal];
        button.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
        button.enabled = NO;
    }
}

- (void)returnClicked:(UITextField *)tx
{
    [tx resignFirstResponder];
    [self nextButtonClicked:nil];
}

- (void)nextButtonClicked:(UIButton *)btn
{
    WS(weakSelf);
    if ([PLFindPasswordViewController isMobileNumValid:phoneNum] && ^{
        if (verifyCode.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
            return NO;
        }
        return YES;
    }()) {
        [btn showIndicator];
//        [self.dataTaskArray addObject:[PLHttpTools get:PLInterface_checkVeriCode params:@{@"mobile":phoneNum,@"veriCode":verifyCode} result:^(NSDictionary *dic, NSError *error) {
//            [btn hideIndicator];
//            if (error) {
//                [weakSelf handleNetworkError:error];
//            }
//            else
//            {
//                [weakSelf updateUIWithResponse:dic interface:PLInterface_checkVeriCode];
//            }
//        }]];
    }
}

#pragma other

@end
