//
//  PLHelpRegisterViewController.m
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLHelpRegisterViewController.h"
#import "UIButton+Indicator.h"
#import "IQKeyboardManager.h"

static int count = 60;

#define BackGroupHeight (iPhone4?180:210)

@interface PLHelpRegisterViewController ()<UIScrollViewDelegate>
{
    UIScrollView *backScrollView;
    UIImageView *imageBG;
    
    NSString *phoneNum;
    NSString *veriCode;
    
    UITextField *tx1;
    
    UITextField *tx2;
}

@end

@implementation PLHelpRegisterViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
    count = 60;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        count = 60;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubViews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.shouldRelease) {
        [_vTimer invalidate];
        _vTimer = nil;
    }
}

#pragma mark Delegate

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
    }
    
    return;
}

- (void)addSubViews
{
    if (!backScrollView) {
        backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        backScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        backScrollView.delegate = self;
        backScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:backScrollView];
        backScrollView.showsVerticalScrollIndicator = backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.contentInset=UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    }
    
    if (!imageBG) {
        imageBG=[[UIImageView alloc]init];
        imageBG.frame=CGRectMake(0, -BackGroupHeight, SCREEN_WIDTH, BackGroupHeight);
        imageBG.image=[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banner-2@2x" ofType:@"png"]];
//        imageBG.contentMode = UIViewContentModeScaleAspectFill;
        imageBG.clipsToBounds = YES;
        [backScrollView addSubview:imageBG];
    }
    
    self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.baseNavBar setTintColor:[UIColor whiteColor]];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1]) forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.baseNavBar];
    self.baseNavBar.shadowImage = [UIImage new];
    [self.view bringSubviewToFront:self.baseNavBar];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    self.baseNavBar.items = @[item];
    item.title = @"帮人注册";
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:self action:@selector(popToPreviousVC)];
    
    //输入框
    tx1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH-10*2, 30)];
    tx1.clearButtonMode = UITextFieldViewModeWhileEditing;
    tx1.borderStyle = UITextBorderStyleRoundedRect;
    tx1.enablesReturnKeyAutomatically = YES;
    [tx1 setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [tx1 setFont:[UIFont systemFontOfSize:15]];
    tx1.keyboardType = UIKeyboardTypeNumberPad;
    [tx1 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    tx1.placeholder = @"请输入被推荐人的手机号";
    tx1.tag = 100;
    [backScrollView addSubview:tx1];
    
    tx2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 55, SCREEN_WIDTH-10*2-96, 30)];
    tx2.clearButtonMode = UITextFieldViewModeWhileEditing;
    tx2.borderStyle = UITextBorderStyleRoundedRect;
    [tx2 setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    tx2.enablesReturnKeyAutomatically = YES;
    [tx2 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    tx2.keyboardType = UIKeyboardTypeNumberPad;
    tx2.placeholder = @"请输入被推荐人的验证码";
    tx2.tag = 101;
    [tx2 setFont:[UIFont systemFontOfSize:15]];
    [backScrollView addSubview:tx2];
    
    UIButton *veriCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    veriCodeBtn.frame = CGRectMake(SCREEN_WIDTH-98, 55, 88, 30);
    veriCodeBtn.tag = 999;
    veriCodeBtn.clipsToBounds = YES;
    veriCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    veriCodeBtn.enabled = NO;
    [veriCodeBtn setTitle:@"生成验证码" forState:UIControlStateNormal];
    [veriCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [veriCodeBtn setBackgroundImage:imageWithColor([UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1]) forState:UIControlStateNormal];
    [veriCodeBtn addTarget:self action:@selector(veriBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    veriCodeBtn.layer.cornerRadius = 2;
    [backScrollView addSubview:veriCodeBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.tag = 1000;
    doneBtn.clipsToBounds = YES;
    doneBtn.layer.cornerRadius = 2;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    doneBtn.frame = CGRectMake(10, 130, SCREEN_WIDTH-10*2, 40);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageWithColor([UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1]) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setEnabled:NO];
    [backScrollView addSubview:doneBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (SCREEN_HEIGHT>568) {
        [tx1 becomeFirstResponder];
    }
}

#pragma mark UserActions

- (void)textChanged:(UITextField *)tx
{
    if (tx.tag == 100) {
        phoneNum = tx1.text;
        if (phoneNum.length>=11) {
            [((UIButton *)[backScrollView viewWithTag:999]) setEnabled:YES];
        }
        else
        {
            [((UIButton *)[backScrollView viewWithTag:999]) setEnabled:NO];
        }
    }
    else if (tx.tag == 101) {
        veriCode = tx2.text;
    }
    
    UIButton *btn = ((UIButton *)[backScrollView viewWithTag:1000]);
    if (phoneNum.length > 0 && veriCode.length > 0) {
        if (!btn.enabled) {
            [btn setEnabled:YES];
        }
    }
    else
    {
        [btn setEnabled:NO];
    }
}

- (void)veriBtnClicked:(UIButton *)btn
{
    if ([PLHelpRegisterViewController isMobileNumValid:phoneNum]) {
        [btn showIndicator];
        [self getVeriCode];
    }
}

- (void)doneBtnClicked:(UIButton *)btn
{
    if (veriCode.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
        return;
    }
    if ([PLHelpRegisterViewController isMobileNumValid:phoneNum]) {
        [btn showIndicator];
        [self startRegister];
    }
}

#pragma mark Network

- (void)getVeriCode
{
    UIButton *button = ((UIButton *)[backScrollView viewWithTag:999]);
//    [self.networkOperationArray addObject:[BaseHttpRequest getWithUrl:[self formatUrl:@"interface/common/getVeriCode"] parameters:@{@"mobile":tx1.text,@"usage":@"帮人注册"} sucess:^(id json) {
//        [button hideIndicator];
//        [weakSelf handleRequestResult:json WithServiceName:@"interface/common/getVeriCode"];
//    } failur:^(NSError *error) {
//        [button hideIndicator];
//        [weakSelf handleFailed:error];
//    }]];
    
    [self sendRequestWithMethod:GET interface:PLInterface_GetVeriCode parameters:@{@"mobile":tx1.text,@"usage":@"帮人注册"}];
}

- (void)startRegister
{
    WS(weakSelf);
    NSString *userId = @"";
    userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (userId.length==0) {
        return;
    }
    NSDictionary *dic = @{@"mobile":phoneNum,
                          @"veriCode":veriCode,
                          @"refeType":@0,
                          @"refeUser":userId,
                          @"registerWay":@"9"};
    
    UIButton *button = ((UIButton *)[backScrollView viewWithTag:1000]);
//    [self.networkOperationArray addObject:[BaseHttpRequest getWithUrl:[self formatUrl:@"interface/user/register"] parameters:dic sucess:^(id json) {
//        [button hideIndicator];
//        [weakSelf handleRequestResult:json WithServiceName:@"interface/user/register"];
//    } failur:^(NSError *error) {
//        [button hideIndicator];
//        [weakSelf handleFailed:error];
//    }]];
    
    [self sendRequestWithMethod:GET interface:PLInterface_Register parameters:dic];
}

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    if (interface == PLInterface_GetVeriCode) {
        [((UIButton *)[backScrollView viewWithTag:999]) hideIndicator];
        if (response) {
            if ([response[@"code"] intValue] == 0) {
                _vTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:_vTimer forMode:NSRunLoopCommonModes];
            }
        }
        if (error) {
            
        }
    }
    if (interface == PLInterface_Register) {
        [((UIButton *)[backScrollView viewWithTag:1000]) hideIndicator];
        if (response) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLRefreshRewardNumNotification" object:nil];
            [_vTimer invalidate];_vTimer=nil;
            UIButton *btn = (UIButton *)[backScrollView viewWithTag:999];
            btn.enabled = YES;
            [btn setTitle:@"生成验证码" forState:UIControlStateNormal];
            
            [self popToPreviousVC];
            [SVProgressHUD showSuccessWithStatus:@"帮人注册成功！"];
        }
        if (error) {
            
        }
    }
}

#pragma mark Others

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

- (void)countDown:(NSTimer *)timer
{
    UIButton *btn = (UIButton *)[backScrollView viewWithTag:999];
    btn.enabled = NO;
    if (count == 0) {
        [_vTimer invalidate];_vTimer=nil;
        [btn setTitle:@"生成验证码" forState:UIControlStateNormal];
        btn.enabled = YES;
    }
    else if (count > 0) {
        [btn setTitle:[NSString stringWithFormat:@"%d",count--] forState:UIControlStateNormal];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
