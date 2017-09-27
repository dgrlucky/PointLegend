//
//  PLCityViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/10.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLCityViewController.h"
#import "PLCityModel.h"

#define FailMsg @"定位失败，再试一次？"

NSString *pointLegendUserCityChangedNotification = @"pointLegendUserCityChangedNotification";

@interface PLCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *dataArray;
    
    NSArray *allCities;
    
    PLCityModel *currentCityModel;
    
    UISearchDisplayController *dispVC;
    
    NSMutableArray *searchResultArray;
}

@end

@implementation PLCityViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        dataArray = [NSMutableArray new];
        currentCityModel = [[PLCityModel alloc] init];
        currentCityModel.cityName = @"正在定位...";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.baseTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.baseNavBar.hidden = NO;
    
    [self setBaseSearchBarOnBaseNavBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-55-8, NAV_BAR_HEIGHT-30) placeHolder:@"深圳"];
    
    self.baseNavBar.tintColor = [UIColor redColor];
    
    baseNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(closeVC:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WS(weakSelf);
    
    //正在定位
    currentCityModel.cityId = @(NSNotFound);
    currentCityModel.cityName = @"正在定位...";
    [dataArray insertObject:@{@"当前城市":@[currentCityModel]} atIndex:0];
}

#pragma mark UI

- (void)setBaseSearchBarOnBaseNavBarWithFrame:(CGRect)rect placeHolder:(NSString *)placeHolder
{
    [super setBaseSearchBarOnBaseNavBarWithFrame:rect placeHolder:placeHolder];
    
    self.baseSearchBar.delegate = self;
    
    dispVC = [[UISearchDisplayController alloc] initWithSearchBar:self.baseSearchBar contentsController:self];
    dispVC.delegate = self;
    dispVC.searchResultsDataSource = self;
    dispVC.searchResultsDelegate = self;
    dispVC.searchBar.placeholder = @"深圳";
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(8, 20, SCREEN_WIDTH-55-8, 44)];
    titleView.clipsToBounds = YES;
    UIColor *color =  [UIColor clearColor];
    [titleView setBackgroundColor:color];
    
    [self.baseSearchBar removeFromSuperview];
    self.baseSearchBar.bounds = titleView.bounds;
    [titleView addSubview:self.baseSearchBar];
    
    [self.baseNavBar addSubview:titleView];
}

#pragma mark NetWork

- (void)updateUIWithResponseString:(NSDictionary *)jsonDic interface:(NSString *)str
{
    self.baseTableView.hidden = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    NSArray *cityDicArray = jsonDic[@"data"][@"lst"];
    if (cityDicArray.count > 1) {
        if (![cityDicArray writeToFile:FilePathInDocDir(@"/cities.plist") atomically:YES]) {
            NSLog(@"111");
        }
    }
    allCities = cityDicArray;
    NSMutableArray *cityModelArray = [NSMutableArray new];
    NSMutableArray *cityFirstLetterArray = [NSMutableArray new];
    for (NSDictionary *dic in cityDicArray) {
        PLCityModel *model = [[PLCityModel alloc] init];
        model.cityId = dic[@"cityId"];
        model.cityName = dic[@"cityName"];
        model.firstLetterOfCity = [dic[@"firstLetterOfCity"] uppercaseString];
        if ([dic[@"firstLetterOfCity"] length] > 1) {
            NSString *first = [[dic[@"firstLetterOfCity"] substringToIndex:1] uppercaseString];
            if (![cityFirstLetterArray containsObject:first]) {
                [cityFirstLetterArray addObject:first];
            }
        }
        model.provinceId = dic[@"provinceId"];
        model.provinceName = dic[@"provinceName"];
        [cityModelArray addObject:model];
        
        if ([currentCityModel.cityName isEqualToString:model.cityName]) {
            currentCityModel = model;
        }
    }
    
    for (NSString *str in cityFirstLetterArray) {
        NSMutableArray *arr = [NSMutableArray new];
        for (PLCityModel *model in cityModelArray) {
            if ([[model.firstLetterOfCity uppercaseString] hasPrefix:[str uppercaseString]]) {
                [arr addObject:model];
            }
        }
        [dataArray addObject:@{str:arr}];
    }
    
    if ([[dataArray.firstObject allKeys][0] isEqualToString:@"当前城市"]) {
        [dataArray removeObjectAtIndex:0];
    }
    
    [dataArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSString *str1 = [obj1 allKeys][0];
        NSString *str2 = [obj2 allKeys][0];
        if ([str1 characterAtIndex:0] < [str2 characterAtIndex:0]) {
            return NSOrderedAscending;
        }
        else if ([str1 characterAtIndex:0] > [str2 characterAtIndex:0]) {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    
    if (![[dataArray.firstObject allKeys][0] isEqualToString:@"当前城市"]) {
        [dataArray insertObject:@{@"当前城市":@[currentCityModel]} atIndex:0];
    }
    
    [self.baseTableView reloadData];
}

- (void)closeVC:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:pointLegendUserCityChangedNotification object:@{@"cityName":currentCityModel.cityName?:@"",@"cityId":currentCityModel.cityId?:@(NSNotFound)}];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == dispVC.searchResultsTableView) {
        static NSString *identifier1 = @"dispcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        cell.textLabel.text = searchResultArray[indexPath.row][@"cityName"];
        return cell;
    }
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *str = ((PLCityModel *)[dataArray[indexPath.section] allValues][0][indexPath.row]).cityName;
    if (![str isEqualToString:FailMsg] && ![str isEqualToString:@"正在定位..."]) {
        cell.textLabel.text = str;
    }
    else
    {
        cell.textLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                                                                                                               NSForegroundColorAttributeName:[str isEqualToString:FailMsg]?[UIColor redColor]:[UIColor orangeColor],
                                                                                                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13]
                                                                                                                     }];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == dispVC.searchResultsTableView)
    {
        return searchResultArray.count;
    }
    return [[dataArray[section] allValues][0] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == dispVC.searchResultsTableView)
    {
        return 1;
    }
    return dataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == dispVC.searchResultsTableView)
    {
        return nil;
    }
    return [dataArray[section] allKeys][0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == dispVC.searchResultsTableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = RGB(0.216*255, 0.471*255, 0.871*255);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:pointLegendUserCityChangedNotification object:@{@"cityName":searchResultArray[indexPath.row][@"cityName"],@"cityId":searchResultArray[indexPath.row][@"cityId"]}];
        self.view.userInteractionEnabled = NO;
        WS(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    PLCityModel *model = [dataArray[indexPath.section] allValues][0][indexPath.row];
    if ([model.cityName isEqualToString:@"正在定位..."]) {
        return;
    }
    if ([model.cityName isEqualToString:FailMsg]) {
//        WS(weakSelf);
//        [PLLocationMgr updateUserLocationWithBlock:^(NSString *city, double latitude, double longitude, NSError *error) {
//            SS(strongSelf);
//            if (error) {
//                NSLog(@"%@",error);
//                strongSelf->currentCityModel.cityName = FailMsg;
//            }
//            else
//            {
//                strongSelf->currentCityModel.cityName = city;
//            }
//            
//            if (strongSelf->dataArray.count && [[(strongSelf->dataArray.firstObject) allKeys][0] isEqualToString:@"当前城市"]) {
//                [strongSelf->dataArray removeObjectAtIndex:0];
//                [strongSelf->dataArray insertObject:@{@"当前城市":@[currentCityModel]} atIndex:0];
//                [strongSelf.baseTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//            else
//            {
//                NSDictionary *dic = @{@"data":@{@"lst":@[@{@"cityName":@""}]}};
//                [strongSelf updateUIWithResponseString:dic];
//            }
//        }];
//        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.textColor = RGB(56, 89, 255);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:pointLegendUserCityChangedNotification object:@{@"cityName":model.cityName?:@"",@"cityId":model.cityId?:@(NSNotFound)}];
    self.view.userInteractionEnabled = NO;
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.baseTableView) {
        return index+1;
    }
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == dispVC.searchResultsTableView) {
        return nil;
    }
    NSMutableArray *firstLetterArray = [NSMutableArray new];
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:dataArray];
    if ([[dataArray.firstObject allKeys][0] isEqualToString:@"当前城市"]) {
        [newArray removeObjectAtIndex:0];
    }
    for (NSDictionary *dic in newArray) {
        [firstLetterArray addObject:dic.allKeys[0]];
    }
    return firstLetterArray;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchResultArray = [NSMutableArray new];
    for (NSDictionary *dic in allCities) {
        NSLog(@"%d",[dic[@"cityName"] rangeOfString:[searchText uppercaseString]].location);
        NSLog(@"%d",[dic[@"firstLetterOfCity"] rangeOfString:[searchText uppercaseString]].location);
        if ([dic[@"cityName"] rangeOfString:[searchText uppercaseString]].location != NSNotFound || (dic[@"firstLetterOfCity"] && [dic[@"firstLetterOfCity"] rangeOfString:[searchText uppercaseString]].location != NSNotFound)) {
            [searchResultArray addObject:dic];
        }
    }
    [dispVC.searchResultsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self closeVC:nil];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:YES animated:NO];
    UIView *topView = controller.searchBar.subviews[0];
    
    baseNavItem.rightBarButtonItem = nil;
    UIView *titleView = self.baseSearchBar.superview;
    titleView.width = SCREEN_WIDTH-10;
    self.baseSearchBar.width = SCREEN_WIDTH-10;
    
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton *)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];  //@"取消"
        }
    }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    baseNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(closeVC:)];
    UIView *titleView = self.baseSearchBar.superview;
    titleView.width = SCREEN_WIDTH-55-8;
}

#pragma mark Action

@end
