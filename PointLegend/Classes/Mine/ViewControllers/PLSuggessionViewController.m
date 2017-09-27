//
//  PLSuggessionViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/9.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLSuggessionViewController.h"
#import "UIBarButtonItem+Action.h"
#import "PLMenu.h"
#import "UIButton+Indicator.h"

@interface PLSuggessionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSString *inputContent;
    
    CGPoint curOffSet;
}

@end

@implementation PLSuggessionViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.sectionFooterHeight = 8;
    [self.view addSubview:self.baseTableView];
    
    //表尾视图
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(44, 0, SCREEN_WIDTH-44*2, 38);
    [button setTitleColor:RGB(112, 112, 112) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = RGB(146, 146, 146).CGColor;
    button.layer.borderWidth = 1.5f;
    [button addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78)];
    [view addSubview:button];
    self.baseTableView.tableFooterView = view;
    
    baseNavItem.title = @"意见";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(UITextView *)[[self.baseTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].contentView viewWithTag:6002] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static NSString *identy1 = @"identy1";
static NSString *identy2 = @"identy2";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8*2, 80)];
                label.tag = 9999;
                label.textColor = RGB(112, 112, 112);
                label.font = iPhone4?[UIFont systemFontOfSize:13]:[UIFont systemFontOfSize:15];
                label.numberOfLines = 0;
                label.text = @"亲爱的朋友，我们期待听到您的心声，帮助我们完善我们的产品，最终给您呈现最佳的使用体验。\n请输入您的宝贵意见(500字以内)：";
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.alignment = NSTextAlignmentLeft;
                paragraphStyle.lineSpacing = 3;  //行自定义行高度
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
                label.text = @"";
                label.attributedText = attributedString;
                
                [cell.contentView addSubview:label];
            }
            if (inputContent.length > 0) {
                ((UILabel *)[cell.contentView viewWithTag:9999]).text = inputContent;
            }
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8*2, iPhone4?100:180)];
                textView.tag = 6002;
                textView.layer.cornerRadius = 7;
                textView.delegate = self;
                textView.returnKeyType = UIReturnKeySend;
                textView.layer.masksToBounds = YES;
                textView.backgroundColor = UIColorFromRGB(0xf0eff5);
                textView.enablesReturnKeyAutomatically = YES;
                [cell.contentView addSubview:textView];
            }
            return cell;
        }
            
        default:
            break;
    }
    return [UITableViewCell new];
}

#pragma mark TableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    
    return iPhone4?108:188;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = inputContent;
    textView.font = [UIFont systemFontOfSize:15];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    inputContent = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    inputContent = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark userAction

- (void)submitButtonClicked:(UIButton *)sender
{
    if (inputContent.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入内容！"];
        return;
    }
    [sender showIndicator];
    [SVProgressHUD showWithStatus:nil];
    
    [self.view endEditing:YES];
    
    NSString *dateString = ^(){
        NSArray *array = [[[NSDate date] description] componentsSeparatedByString:@" "];
        NSString *str = @"";
        if (array.count>2) {
            str = [str stringByAppendingString:array[0]];
            str = [str stringByAppendingString:@" "];
            str = [str stringByAppendingString:array[1]];
        }
        return str;
    }();
    
    WS(weakSelf);
//    NSURLSessionDataTask *task = [PLHttpTools get:PLInterface_GiveFeedback params:@{@"userId":@"2910057629",@"feedback":inputContent,@"createTime":dateString} result:^(NSDictionary *dic, NSError *error) {
//        [sender hideIndicator];
//        if (error) {
//            [weakSelf handleNetworkError:error];
//        }
//        else
//        {
//            [weakSelf updateUIWithResponse:dic interface:PLInterface_GiveFeedback];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//            [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
//        }
//    }];
//    [self.dataTaskArray addObject:task];
}

@end
