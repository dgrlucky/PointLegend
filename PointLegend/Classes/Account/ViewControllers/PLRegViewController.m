//
//  PLRegViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/24.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLRegViewController.h"
#import "UIButton+Indicator.h"
#import "UIButton+Block.h"
#import "PLUserAgreementViewController.h"

@interface PLRegViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *userName;
    NSString *password;
    NSString *confirmPassword;
    NSString *verifyCode;
    
    NSString *verifyCodeButtonTitle;
    
    IQKeyboardReturnKeyHandler    *returnKeyHandler;
}

@end

@implementation PLRegViewController

- (void)dealloc
{
    returnKeyHandler = nil;
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:60];
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _recommended = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//    returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarByPosition;
    
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
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
        
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
        [button addTarget:weakSelf action:@selector(regButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"马上注册" forState:UIControlStateNormal];
        
        //协议
        UIButton *cbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:cbutton];
        [cbutton setImage:[UIImage imageNamed:@"login_checkbox"] forState:UIControlStateNormal];
        [cbutton setImage:[UIImage imageNamed:@"login_checkbox_sel"] forState:UIControlStateSelected];
        [cbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakFooterView.mas_left).with.offset(16);
            make.bottom.equalTo(weakFooterView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        cbutton.selected = YES;
        [cbutton setImageEdgeInsets:UIEdgeInsetsMake(-7, 0, 0, 0)];
        __weak typeof(cbutton) weakButton = cbutton;
        [cbutton addActionHandler:^(NSInteger tag) {
            weakButton.selected = !weakButton.selected;
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        [footerView addSubview:label];
        NSString *str = @"我接受《一点传奇APP用户注册协议》";
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:str];
        [mStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 3)];
        [mStr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x3d4245)} range:NSMakeRange(3, str.length-3)];
        [label setAttributedText:mStr];
        label.font = [UIFont systemFontOfSize:15];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.equalTo(weakFooterView.mas_left).with.offset(45);
            make.bottom.equalTo(weakFooterView.mas_bottom);
            make.right.equalTo(weakFooterView.mas_right).with.offset(-16);
        }];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(labelClicked:)]];

        return footerView;
    }();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (userName.length == 0) {
        [(UITextField *)[[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView viewWithTag:6002] becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            make.width.mas_equalTo(67);
        }];
        
        UITextField *inputTX = [[UITextField alloc] initWithFrame:CGRectZero];
        inputTX.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputTX.tag = 6002;
        [cell.contentView addSubview:inputTX];
        UIFont *font = [UIFont systemFontOfSize:15];
        inputTX.font = font;
        [inputTX addTarget:[IQKeyboardManager sharedManager] action:@selector(goNext) forControlEvents:UIControlEventEditingDidEndOnExit];
        [inputTX setValue:font forKeyPath:@"_placeholderLabel.font"];
        [inputTX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).with.offset(5);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.equalTo(weakContentView.mas_right).with.offset(-15);
        }];
        inputTX.enablesReturnKeyAutomatically = YES;
        [inputTX addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [inputTX addTarget:self action:@selector(beginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.hidden = YES;
        verifyCodeButtonTitle = @"获取验证码";
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        button.tag = 6003;
        [cell.contentView addSubview:button];
        [button addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakContentView.mas_right).with.offset(0);
            make.width.mas_equalTo(80);
            make.top.equalTo(weakContentView.mas_top);
            make.centerY.equalTo(weakContentView.mas_centerY);
        }];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:6001];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:6000];
    imageView.image = [UIImage imageNamed:@"login_user"];
    
    UITextField *inputTX = (UITextField *)[cell.contentView viewWithTag:6002];
    inputTX.secureTextEntry = (indexPath.row==1||indexPath.row==2)?YES:NO;
    
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:6003];
    
    if (indexPath.row == 3) {
        [inputTX mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).with.offset(8);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.equalTo(button.mas_left).with.offset(10);
        }];
    }
    
    if (!_recommended) {
        switch (indexPath.row) {
            case 0:
                nameLabel.text = @"用户名";
                inputTX.placeholder = @"请输入手机号";
                break;
            case 1:
                nameLabel.text = @"密码";
                inputTX.placeholder = @"请输入密码";
                break;
            case 2:
                nameLabel.text = @"确认密码";
                inputTX.placeholder = @"请再次输入手机号";
                break;
            case 3:
                nameLabel.text = @"验证码";
                inputTX.placeholder = @"请输入验证码";
                button.hidden = NO;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                nameLabel.text = @"用户名";
                inputTX.placeholder = @"请输入手机号";
                break;
            case 1:
                nameLabel.text = @"密码";
                inputTX.placeholder = @"请输入密码";
                break;
            case 2:
                nameLabel.text = @"确认密码";
                inputTX.placeholder = @"请再次输入手机号";
                break;
            case 4:
                nameLabel.text = @"推荐人";
                inputTX.text = nil;
                break;
            case 3:
                nameLabel.text = @"验证码";
                inputTX.placeholder = @"请输入验证码";
                button.hidden = NO;
                break;
            default:
                break;
        }
    }
    
    if (indexPath.row==0 || indexPath.row == 3 || indexPath.row == 4) {
        inputTX.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row==1 || indexPath.row == 2) {
        inputTX.returnKeyType = UIReturnKeyNext;
    }
    if (userName.length>0 && indexPath.row == 0) {
        inputTX.text = userName;
    }
    if (password.length>0 && indexPath.row == 1) {
        inputTX.text = password;
    }
    if (confirmPassword.length>0 && indexPath.row == 2) {
        inputTX.text = confirmPassword;
    }
    if (verifyCode.length>0 && indexPath.row == 3) {
        inputTX.text = verifyCode;
    }
    if (verifyCodeButtonTitle.length>0 && indexPath.row == 3) {
        [button setTitle:verifyCodeButtonTitle forState:UIControlStateNormal];
    }
    if (_recommended && indexPath.row == 4) {
        inputTX.text = _recommender;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommended?5:4;
}

#pragma mark UserActions
- (void)regButtonClicked:(UIButton *)sender
{
    if ([userName isEqualToString:_recommender]) {
        [SVProgressHUD showInfoWithStatus:@"用户名不能跟推荐人一样！"];
        return;
    }
    if (![password isEqualToString:confirmPassword]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致！"];
        return;
    }
    if ([[self class] isMobileNumValid:userName] && [[self class] isPasswordValid:password] && [[self class] isPasswordValid:confirmPassword] && ^{
        if (verifyCode.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
            return NO;
        }
        return YES;
    }())
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [sender showIndicator];
        
        [SVProgressHUD showWithStatus:nil];
        
        WS(weakSelf);
//        [self.dataTaskArray addObject:[PLHttpTools get:PLInterface_Register params:@{@"mobile":userName,@"password":md5(password),@"veriCode":verifyCode,@"refeType":@0,@"refeUser":@""} result:^(NSDictionary *dic, NSError *error) {
//            [sender hideIndicator];
//            if (error) {
//                [weakSelf handleNetworkError:error];
//            }
//            else
//            {
//                [weakSelf updateUIWithResponse:dic interface:PLInterface_Register];
//                if ([dic[@"code"] intValue] == 0) {
//                    [SVProgressHUD showSuccessWithStatus:@"注册成功！"];
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }
//            }
//        }]];
    }
}

- (void)beginEditing:(UITextField *)textField
{
    UIResponder *rsp = textField;
    UITableViewCell *cell = ^(UIResponder *r){
        while(r && ![r isKindOfClass:[UITableViewCell class]]){
            r = r.nextResponder;}
        return (UITableViewCell *)r;}
    (rsp);
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    
    if (indexPath.row == 3 && _recommender.length>0) {
        [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:120];
    }
    if (indexPath.row == 4) {
        [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:60];
    }

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
        userName = textField.text;
    }
    if (indexPath.row == 1) {
        password = textField.text;
    }
    if (indexPath.row == 2) {
        confirmPassword = textField.text;
    }
    if (indexPath.row == 3) {
        verifyCode = textField.text;
    }
    if (indexPath.row == 4) {
        _recommender = textField.text;
    }
    
    UIButton *button = (UIButton *)[self.baseTableView.tableFooterView viewWithTag:5000];
    if (userName.length>0 && password.length>0 && confirmPassword.length>0 && verifyCode.length>0) {
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

- (void)getVerifyCode:(UIButton *)button
{
    WS(weakSelf);
    if (![[self class] isMobileNumValid:userName]) {
        return;
    }
//    [self.dataTaskArray addObject:[PLHttpTools get:PLInterface_GetVeriCode params:@{@"mobile":userName,@"usage":@"注册"} result:^(NSDictionary *dic, NSError *error) {
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
    UITableViewCell *cell = [self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:6003];
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

- (void)labelClicked:(UITapGestureRecognizer *)tap
{
    PLUserAgreementViewController *vc = [[PLUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
