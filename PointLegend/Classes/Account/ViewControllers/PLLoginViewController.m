//
//  PLLoginViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/18.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLLoginViewController.h"
#import "UIBarButtonItem+Action.h"
#import "UIDevice+Hardware.h"
#import "UIButton+Indicator.h"
#import "UIButton+Block.h"
#import "PLRegViewController.h"
#import "PLFindPasswordViewController.h"
#import "ConfirmViewController.h"

@interface PLLoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *phoneNum;
    NSString *password;
}
@end

@implementation PLLoginViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"登录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self showsBackButton];
    
    self.baseNavBar.hidden = NO;
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    
    [self.view addSubview:self.baseTableView];
    
    WS(weakSelf);
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(NAV_BAR_HEIGHT);
        make.bottom.mas_equalTo(0);
    }];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
    //footerView
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
        [button addTarget:weakSelf action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        
        for (int i = 0; i < 2; i++) {
            UIButton *fButton = [UIButton buttonWithType:UIButtonTypeCustom];
            fButton.tag = 7000+i;
            fButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [fButton setTitleColor:RGB(112, 112, 112) forState:UIControlStateNormal];
            [fButton setTitle:i==0?@"忘记密码？":@"现在注册" forState:UIControlStateNormal];
            [fButton setTitleColor:[RGB(112, 112, 112) colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
            WS(weakSelf);
            [fButton addActionHandler:^(NSInteger tag) {
                if (tag == 7001) {
                    PLRegViewController *vc = [[PLRegViewController alloc] init];
                    vc.recommended = YES;
                    vc.recommender = @"13068703912";
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                else if (tag == 7000) {
                    PLFindPasswordViewController *vc = [[PLFindPasswordViewController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
            [footerView addSubview:fButton];
        }
        
        for (int i = 0; i < 2; i++) {
            UIButton *lButton = (UIButton *)[footerView viewWithTag:7000+i];
            __weak typeof(footerView) weakFooterView = footerView;
            [lButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(weakFooterView.mas_left).with.offset(15);
                    lButton.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
                }
                else if (i == 1) {
                    make.right.equalTo(weakFooterView.mas_right).with.offset(-15);
                    lButton.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
                }
                make.width.mas_equalTo(90);
                make.top.equalTo(weakFooterView.mas_top).with.offset(45);
                make.bottom.equalTo(weakFooterView.mas_bottom);
            }];
        }
        
        return footerView;
    }();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (phoneNum.length == 0) {
        [(UITextField *)[[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView viewWithTag:6002] becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark TableViewDelegate

static NSString *identy = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //图标 类型 输入框
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 6000;
        [cell.contentView addSubview:imageView];
        __weak typeof(cell.contentView) weakContentView = cell.contentView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakContentView.mas_left).with.offset(15);
            make.width.mas_equalTo(22);
            make.centerY.equalTo(weakContentView.mas_centerY);
            make.height.mas_equalTo(22);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.tag = 6001;
        [cell.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).with.offset(8);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(55);
        }];
        
        UITextField *inputTX = [[UITextField alloc] init];
        inputTX.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputTX.tag = 6002;
        [cell.contentView addSubview:inputTX];
        UIFont *font = [UIFont systemFontOfSize:15];
        inputTX.font = font;
        [inputTX setValue:font forKeyPath:@"_placeholderLabel.font"];
        [inputTX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).with.offset(8);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.equalTo(weakContentView.mas_right).with.offset(-15);
        }];
        [inputTX addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:6001];
    nameLabel.text = indexPath.row==0?@"用户名":@"密码";
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:6000];
    imageView.image = [UIImage imageNamed:@"login_user"];
    
    UITextField *inputTX = (UITextField *)[cell.contentView viewWithTag:6002];
    inputTX.placeholder = indexPath.row==0?@"请输入手机号":@"请输入密码";
    inputTX.secureTextEntry = indexPath.row==1?YES:NO;
    if (indexPath.row==0) {
        inputTX.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row==1) {
        [inputTX addTarget:self action:@selector(returnClicked:) forControlEvents:UIControlEventEditingDidEndOnExit];
        inputTX.returnKeyType = UIReturnKeyDone;
    }
    inputTX.enablesReturnKeyAutomatically = YES;
    if (phoneNum.length>0 && indexPath.row == 0) {
        inputTX.text = phoneNum;
    }
    if (password.length>0 && indexPath.row == 1) {
        inputTX.text = password;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark UserActions
- (void)loginButtonClicked:(UIButton *)sender
{
    if ([[self class] isMobileNumValid:phoneNum] && [[self class] isPasswordValid:password]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        if (_delegate && [_delegate respondsToSelector:@selector(changeState:)]) {
            [_delegate changeState:@2];
        }
        
        [sender showIndicator];
        [SVProgressHUD showWithStatus:@"正在登录..."];
        [self sendRequestWithMethod:GET interface:PLInterface_Login parameters:@{@"mobile":phoneNum,@"password":md5(password),@"model":[UIDevice currentDevice].model,@"osInfo":[UIDevice currentDevice].systemVersion,@"SN":[UIDevice macAddress]}];
    }
}

- (void)updateUIWithResponse:(NSDictionary *)dic
{
    UIButton *button = (UIButton *)[self.baseTableView.tableFooterView viewWithTag:5000];
    [button hideIndicator];
    [SVProgressHUD dismiss];
    [super updateUIWithResponse:dic];
    
    NSDictionary *data = dic[@"response"][@"data"];
    if ((NSNull *)data == [NSNull null]) {
        return;
    }
    
    NSError *error = dic[@"error"];
    if (error) {
        if (_delegate && [_delegate respondsToSelector:@selector(changeState:)]) {
            [_delegate changeState:@0];
        }
        return;
    }
    else
    {
        [PLUserInfoModel sharedInstance].phoneNum = phoneNum;
        [PLUserInfoModel sharedInstance].password = md5(password);
        [[PLUserInfoModel sharedInstance] dicToObject:data];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLRefreshRewardNumNotification" object:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(changeState:)]) {
            [_delegate changeState:@1];
        }
        [self dismissViewControllerAnimated:YES completion:^{[SVProgressHUD showSuccessWithStatus:@"登录成功！"];}];
    }
    
    [PLUserInfoModel sharedInstance].sessionId = ^(){
        NSString *jsessionID = nil;
        NSURL *cookieHost = [NSURL URLWithString:BaseUrl];
        NSArray *backCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieHost];
        for (NSHTTPCookie *cookie in backCookies) {
            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                jsessionID = cookie.value;
                break;
            }
        }
        return jsessionID;
    }();
    
//    [self getCookie];
}


- (void)getCookie
{
    
    [PLUserInfoModel sharedInstance].sessionId = nil;
    //获取h5的cookie
    NSURL *cookieHost = [NSURL URLWithString:BaseHtmlUrl];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieHost];
    
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"LATITUDE"]
            ||[cookie.name isEqualToString:@"LONGITUDE"]
            ||[cookie.name isEqualToString:@"USERID"]
            ||[cookie.name isEqualToString:@"CITYID"]
            ||[cookie.name isEqualToString:@"TOKEN"]
            ||[cookie.name isEqualToString:@"JSESSIONID"]) {
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    [PLUserInfoModel sharedInstance].sessionId = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:BaseUrl]];
    
}


- (NSString *)requestCookieSessionID{
    
    NSString *jsessionID = nil;
    
    NSURL *cookieHost = [NSURL URLWithString:BaseUrl];
    
    NSArray *backCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieHost];
    
    for (NSHTTPCookie *cookie in backCookies) {
        
        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            jsessionID = cookie.value;
            break;
        }
    }
    
    return jsessionID;
    
}


- (void)textChange:(UITextField *)textField
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
        password = textField.text;
    }
    
    UIButton *button = (UIButton *)[self.baseTableView.tableFooterView viewWithTag:5000];
    if (phoneNum.length>0 && password.length>0) {
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
    [self loginButtonClicked:nil];
}

@end
