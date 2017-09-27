//
//  PLBaseViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"

@implementation PLBaseViewController

#pragma mark VCLifeCycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT-0.3)];
        
        self.baseNavBar.tintColor = RGB(112, 112, 112);
        
        UINavigationItem *item = [[UINavigationItem alloc] init];
        self.baseNavBar.items = @[item];
        
        if ([self isMemberOfClass:[NSClassFromString(@"PLHomeViewController") class]] || [self isMemberOfClass:[NSClassFromString(@"PLRewardViewController") class]] || [self isMemberOfClass:[NSClassFromString(@"PLVisitViewController") class]]) {

           
        }
        else if (![self isMemberOfClass:[NSClassFromString(@"PLMineViewController") class]]) {
            self.hidesBottomBarWhenPushed = YES;
        }
        
        _dataTaskArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.baseNavBar];
    
    if ((self.tabBarController && self.navigationController.viewControllers.count>1) || !self.tabBarController) {
        [self showsBackButton];
    }
    
    [self setBaseTableViewWithStyle:UITableViewStylePlain frame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    self.baseTableView.hidden = YES;
    
    WS(weakSelf);
    [self.baseNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(63.7);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.navigationController.viewControllers.count>=1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)setBaseSearchBarOnBaseNavBarWithFrame:(CGRect)rect placeHolder:(NSString *)placeHolder
{
    _baseSearchBar = [[UISearchBar alloc] initWithFrame:rect];
    _baseSearchBar.placeholder = placeHolder;
    _baseSearchBar.searchBarStyle = 2;
    [self.baseNavBar addSubview:_baseSearchBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.baseTableView.hidden) {
        for (NSIndexPath *p in self.baseTableView.indexPathsForSelectedRows) {
            [self.baseTableView deselectRowAtIndexPath:p animated:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _shouldRelease = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (!self.navigationController || (!self.tabBarController && self.navigationController.viewControllers.count == 1) || (self.navigationController && ![self.navigationController.viewControllers containsObject:self])) {
        _shouldRelease = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_shouldRelease) {
        for (NSURLSessionDownloadTask *task in _dataTaskArray) {
            if (task && task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }
        [_timer invalidate];_timer=nil;
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark UserActions

- (void)setBaseTableViewWithStyle:(UITableViewStyle)style frame:(CGRect)rect
{
    self.baseTableView = [[UITableView alloc] initWithFrame:rect style:style];
    self.baseTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.baseTableView.hidden = NO;
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableFooterView = [UIView new];
    
    if (style == UITableViewStyleGrouped) {
        self.baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    
    if ([self.baseTableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.baseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.baseTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.baseTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic interface:(NSString *)interface;
{
    
}

- (void)showsBackButton
{
    if (!baseNavItem) {
        return;
    }
    baseNavItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:self action:@selector(popToPreviousVC)];
}

- (void)popToPreviousVC
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setTitle:(NSString *)title
{
    baseNavItem.title = title;
}

#pragma mark Network

- (void)sendRequestWithMethod:(requestMethod)method interface:(PLInterface)interface parameters:(NSDictionary *)dic
{
    [self sendRequestWithMethod:method interface:interface parameters:dic callbackMethod:nil];
}

- (void)sendRequestWithMethod:(requestMethod)method interface:(PLInterface)interface parameters:(NSDictionary *)dic callbackMethod:(SEL)selector
{
    WS(weakSelf);
    
    if (!selector) {
        selector = @selector(updateUIWithResponse:);
    }
    
    if (method == GET) {
        NSString *interfaceName = fullInterfaceName(interface);
        [_dataTaskArray addObject:[PLHttpTools get:interfaceName params:dic result:^(NSDictionary *dict, NSError *error, NSURLSessionDataTask *task) {
            if (error) {
                [weakSelf handleNetworkError:error];
            }
            
            if (error && [weakSelf respondsToSelector:selector]) {
                [weakSelf performSelector:selector withObject:@{@"error":error,@"interface":@(interface),@"task":task}];
            }
            else if (dict && [weakSelf respondsToSelector:selector])
            {
                NSDictionary *d = @{@"response":dict,
                                    @"interface":@(interface),
                                    @"task":task};
                if (selector != @selector(updateUIWithResponse:)) {
                    [self updateUIWithResponse:d];
                    [weakSelf performSelector:selector withObject:d];
                }
                else
                {
                    [weakSelf updateUIWithResponse:d];
                }
            }
            
            [weakSelf removeTaskFromArray:task];
        }]];
    }
    if (method == POST) {
        
    }
    if (method == UPLOAD) {
        
    }
}

- (void)removeTaskFromArray:(NSURLSessionDataTask *)task
{
    [_dataTaskArray removeObject:task];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    if (!error && response.allKeys.count==0) {
        [SVProgressHUD showInfoWithStatus:@"返回数据异常！"];
        return;
    }
    /*
     1XXXX	数据库异常，XXXX为四位mysql的错误码	mysql的错误码请见《mysql错误码》
     20000	Java系统级异常	将Exception的首行信息作为msg返回
     3XXXX	安全类异常
     30001	请求过于频繁，请稍后重试	同含义
     30002	本接口需要HTTPS来请求	同含义
     30003	无效的cookie信息
     4XXXX	网络级异常
     40001	请求的URL长度过长	同含义
     40002	仅支持GET和POST方法，不支持其他方法	同含义
     40003	后台处理超时	同含义
     500XX	通用的异常校验码
     50000	请求消息JSON无法解析	同含义
     50001	XXXX不存在	{字段名}不存在
     50002	XXXX不能为空	{字段名}不能为空
     50003	XXXX数据格式错误	{字段名}数据格式错误
     50004	手机号码已经被注册过	同含义
     50005	手机验证密码错误	同含义
     50006	支付密码错误	同含义
     50007	提现密码错误	同含义
     50008	推荐码错误	同含义
     50009	推荐码超时	同含义
     70001	该时段不可预订	同含义
     70002	该时段已被其他人预订	同含义
     70003	推荐人手机号码不存在	同含义
     
     
     53101   短信验证码错误
     1       系统异常
     4012    用户名不能为空
     502     不存在该会员信息
     5002    密码错误
     */
    
    int code = [response[@"code"] intValue];
    switch (code) {
        case 0:
            NSLog(@"返回正常");
            break;
        default:
            [SVProgressHUD showInfoWithStatus:response[@"msg"]];
            break;
    }
}

- (void)handleNetworkError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
    NSLog(@"%@",error);
    
    /*
     NSURLErrorUnknown = -1,
     NSURLErrorCancelled = -999,
     NSURLErrorBadURL = -1000,
     NSURLErrorTimedOut = -1001,
     NSURLErrorUnsupportedURL = -1002,
     NSURLErrorCannotFindHost = -1003,
     NSURLErrorCannotConnectToHost = -1004,
     NSURLErrorDataLengthExceedsMaximum = -1103,
     NSURLErrorNetworkConnectionLost = -1005,
     NSURLErrorDNSLookupFailed = -1006,
     NSURLErrorHTTPTooManyRedirects = -1007,
     NSURLErrorResourceUnavailable = -1008,
     NSURLErrorNotConnectedToInternet = -1009,
     NSURLErrorRedirectToNonExistentLocation = -1010,
     NSURLErrorBadServerResponse = -1011,
     NSURLErrorUserCancelledAuthentication = -1012,
     NSURLErrorUserAuthenticationRequired = -1013,
     NSURLErrorZeroByteResource = -1014,
     NSURLErrorCannotDecodeRawData = -1015,
     NSURLErrorCannotDecodeContentData = -1016,
     NSURLErrorCannotParseResponse = -1017,
     NSURLErrorFileDoesNotExist = -1100,
     NSURLErrorFileIsDirectory = -1101,
     NSURLErrorNoPermissionsToReadFile = -1102,
     NSURLErrorSecureConnectionFailed = -1200,
     NSURLErrorServerCertificateHasBadDate = -1201,
     NSURLErrorServerCertificateUntrusted = -1202,
     NSURLErrorServerCertificateHasUnknownRoot = -1203,
     NSURLErrorServerCertificateNotYetValid = -1204,
     NSURLErrorClientCertificateRejected = -1205,
     NSURLErrorClientCertificateRequired = -1206,
     NSURLErrorCannotLoadFromNetwork = -2000,
     NSURLErrorCannotCreateFile = -3000,
     NSURLErrorCannotOpenFile = -3001,
     NSURLErrorCannotCloseFile = -3002,
     NSURLErrorCannotWriteToFile = -3003,
     NSURLErrorCannotRemoveFile = -3004,
     NSURLErrorCannotMoveFile = -3005,
     NSURLErrorDownloadDecodingFailedMidStream = -3006,
     NSURLErrorDownloadDecodingFailedToComplete = -3007
     */
}

#pragma mark 账号密码
+ (BOOL)isMobileNumValid:(NSString *)mobileNum
{
    if (mobileNum.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号！"];
        return NO;
    }
    NSString * PHS = @"1[3|4|5|7|8|9][0-9]{9}";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([regextestct evaluateWithObject:mobileNum] == YES) {
        return YES;
    }else{
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号！"];
        return NO;
    }
}

+ (BOOL)isPasswordValid:(NSString *)password
{
    if (password.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码！"];
        return NO;
    }
    if (password.length<6 || password.length>28) {
        [SVProgressHUD showInfoWithStatus:@"请输入6~28位密码！"];
        return NO;
    }
    NSString * PHS = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,28}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([regextestct evaluateWithObject:password] == YES) {
        return YES;
    }else{
        [SVProgressHUD showInfoWithStatus:@"密码只能为英文字母和数字的组合！"];
        return NO;
    }
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
