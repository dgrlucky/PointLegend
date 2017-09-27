//
//  PLTestViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/17.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLTestViewController.h"
#import "PLHomeViewController.h"
#import "PLMapViewController.h"
#import "PLQRCodeViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PLCityViewController.h"
#import "PLLoginViewController.h"
#import "PLBaseNavigationController.h"
#import "PLButton.h"
#import "Person.h"

@interface PLTestViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    NSArray *array;
}

@end

@implementation PLTestViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)init
{
    if (self = [super init]) {
        array = @[@"autolayout：iOS6.0+||自动布局"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    baseNavItem.title = @"相关功能";
    
    Person *person = [Person MR_createEntity];
    person.age = @(100);
    person.firstName = @"王";
    person.lastName = @"春林";
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    Person *p = [Person MR_findFirst];
    NSLog(@"%@_%@_%@",p.age,p.firstName,p.lastName);
    
    
    [self.baseNavBar addSubview:[PLButton buttonWithFrame:CGRectMake(100, 10, 100, 30) backgroundColor:RGB(251, 66, 66) title:@"查看" titleFont:[UIFont systemFontOfSize:17] tag:1000 actionBlock:^(NSInteger tag) {
        NSLog(@"点击事件");
    }]];
    
    self.baseTableView.hidden = NO;
    
//    [self setBaseTableViewWithStyle:UITableViewStylePlain frame:CGRectZero];
    
    CGRect rect = self.baseTableView.frame;
    rect.size.height = SCREEN_HEIGHT-NAV_BAR_HEIGHT-TOOL_BAR_HEIGHT;
    self.baseTableView.frame = rect;
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 1;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (array.count && indexPath.section == 0) {
        NSArray *arr = [array[indexPath.row] componentsSeparatedByString:@"||"];
        cell.textLabel.text = arr[0];
        cell.detailTextLabel.text = arr[1];
    }
    else
    {
        cell.detailTextLabel.text = nil;
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.textLabel.text = @"百度地图";
        }
        else if (indexPath.section == 1 && indexPath.row == 1) {
            cell.textLabel.text = @"友盟分享";
        }
        else if (indexPath.section == 1 && indexPath.row == 2) {
            cell.textLabel.text = @"二维码";
        }
        else if (indexPath.section == 1 && indexPath.row == 3) {
            cell.textLabel.text = @"通讯录";
        }
        else if (indexPath.section == 1 && indexPath.row == 4) {
            cell.textLabel.text = @"城市选择";
        }
        else if (indexPath.section == 1 && indexPath.row == 5) {
            cell.textLabel.text = @"登录";
        }
    }
    return cell;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    //获取联系人姓名
    NSLog(@"name：%@",(__bridge NSString*)ABRecordCopyCompositeName(person));
    
    
    //获取联系人电话
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
    {
        
        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        
        NSString *aLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
        
        NSLog(@"PhoneLabel:%@ Phone#:%@",aLabel,aPhone);
        
        if([aLabel isEqualToString:@"_$!<Mobile>!$_"])
            
            {
                [phones addObject:aPhone];
            }
    }
    
    
    if([phones count]>0)
        
    {
        NSString *mobileNo = [phones objectAtIndex:0];
        NSLog(@"phoneNo：%@",mobileNo);
        
    }
    //获取联系人邮箱
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    
    for (i = 0;i < ABMultiValueGetCount(emailMulti); i++)
        
    {
        NSString *emailAdress = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailMulti, i);
        
        [emails addObject:emailAdress];
    }
    
    if([emails count]>0)
        
    {
        NSString *emailFirst=[emails objectAtIndex:0];
        NSLog(@"email：%@",emailFirst);
    }
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
    
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        PLMapViewController *mapVC = [[PLMapViewController alloc] init];
        [self.navigationController pushViewController:mapVC animated:YES];
        return;
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        PLQRCodeViewController *mapVC = [[PLQRCodeViewController alloc] init];
        [self.navigationController pushViewController:mapVC animated:YES];
        return;
    }
    else if (indexPath.section == 1 && indexPath.row == 4) {
        PLCityViewController *mapVC = [[PLCityViewController alloc] init];
        [self.navigationController presentViewController:mapVC animated:YES completion:nil];
        return;
    }
    else if (indexPath.section == 1 && indexPath.row == 5) {
        PLLoginViewController *mapVC = [[PLLoginViewController alloc] init];
        PLBaseNavigationController *nav = [[PLBaseNavigationController alloc] initWithRootViewController:mapVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"564ae692e0f55af4ed0050fe"
                                          shareText:@"你要分享的文字"
                                         shareImage:[UIImage imageNamed:@"a1.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToQQ,nil]
                                           delegate:self];
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        
        picker.peoplePickerDelegate = self;
        
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 3) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [SVProgressHUD showInfoWithStatus:@"待完成"];
            return;
        }
        PLHomeViewController *vc = [[PLHomeViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"布局";
    }
    else if (section == 1) {
        return @"其他";
    }
    return nil;
}

@end
