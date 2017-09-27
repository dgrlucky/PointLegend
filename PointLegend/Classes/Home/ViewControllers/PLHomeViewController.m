//
//  PLNearbyViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLHomeViewController.h"
#import "PLMenu.h"
#import "PLCityViewController.h"
#import "UIButton+Indicator.h"
#import "NSString+Util.h"
#import "PLSearchViewController.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "UIImage+GIF.h"
#import "MCSwipeTableViewCell.h"
#import "UIImage+Scale.h"
#import "UIView+Arrange.h"
#import "PLGuessCell.h"

@interface PLHomeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,MCSwipeTableViewCellDelegate,UIScrollViewDelegate>
{
    UIButton *cityButton;
    
    NSString *cityName;
    
    NSNumber *cityId;
    
    NSMutableArray *list;
    
    NSInteger page;
    
    NSArray *catArray;
    
    NSArray *regArray;
    
    SDCycleScrollView *cycleScrollView;
}

@end

@implementation PLHomeViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [((UILabel *)[cityButton viewWithTag:1000]) removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:pointLegendUserCityChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:PointLegendUserLocationChangedNotification object:nil];
        list = [NSMutableArray new];
        
        catArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"plist"]];
        regArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"plist"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[PLLocationMgr sharedInstance] locationManager] setDelegate:[PLLocationMgr sharedInstance]];
    
    [[[PLLocationMgr sharedInstance] locationManager] stopUpdatingLocation];
    
    [[[PLLocationMgr sharedInstance] locationManager] startUpdatingLocation];
    
    [self setTableView];
    
    self.baseSearchBar.hidden = NO;
    self.baseNavBar.hidden = NO;
    
    baseNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu:)];
    
    cityButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cityButton setBackgroundImage:[imageWithColor([UIColor darkGrayColor]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    cityButton.frame = CGRectMake(8, 26, 62, 30);
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    cityLabel.tag = 1000;
    [cityLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    cityLabel.font = [UIFont systemFontOfSize:16];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [cityButton addSubview:cityLabel];
    cityLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [cityButton addTarget:self action:@selector(changeCity:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomarrow"]];
    imageView.frame = CGRectMake(45, 10, 17, 10);
    imageView.tag = 1000+1;
    [cityButton addSubview:imageView];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    baseNavItem.title = @"定位中...";
    if ([baseNavItem.title isEqualToString:@"定位中..."]) {
        [cityButton showIndicator];
    }
    
//    [self.baseNavBar addSubview:cityButton];
    
    self.baseSearchBar.hidden = YES;
    cityButton.hidden = YES;

    self.baseSearchBar.delegate = self;
    
    [self sendRequestWithMethod:GET interface:PLInterface_GetAllCitis parameters:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [cycleScrollView start];
    
    if (cityName && cityId) {
        return;
    }
    UILabel *cityLabel = (UILabel *)[cityButton viewWithTag:1000];
    WS(weakSelf);
    __weak typeof(cityLabel) weakCityLabel = cityLabel;
//    [PLLocationMgr updateUserLocationWithBlock:^(NSString *city, double latitude, double longitude, NSError *error) {
//        SS(strongSelf);
//        [strongSelf->cityButton hideIndicator];
//        if (error) {
//            weakCityLabel.text = @"定位失败";
//            weakCityLabel.textColor = [UIColor redColor];
//        }
//        else
//        {
//            weakCityLabel.text = city;
//            strongSelf->cityName = city;
//            weakCityLabel.textColor = [UIColor blackColor];
//            [strongSelf getCurrentCityId:city];
//        }
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [cycleScrollView stop];
}

- (void)setTableView
{
//    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
    [self setBaseTableViewWithStyle:UITableViewStyleGrouped frame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    [self.view addSubview:self.baseTableView];
    
    WS(weakSelf);
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.equalTo(weakSelf.view.mas_height).with.offset(-NAV_BAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NAV_BAR_HEIGHT);
    }];
    
    
    self.baseTableView.hidden = NO;
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, 170) imageURLStringsGroup:@[@"http://picture.1dian.la/group1/M00/00/BF/wKiohFYogAeAfSg4AANm1Y6PTB8438.jpg",@"http://picture.1dian.la/group1/M00/00/E3/wKiohFY906-AFj0VAAFM_z3we2k975.png"]];
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"legend_default"];
    self.baseTableView.tableHeaderView = cycleScrollView;
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 8)];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.sectionFooterHeight = 0.01f;
    self.baseTableView.sectionHeaderHeight = 0.01f;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf setData:1];
    }];
    
    NSArray *array = ^(){
        NSArray *arr = [[NSArray alloc] init];
        for (int i = 1; i <= 2; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_listheader_animation_%d",i]];
            image = [UIImage image:image byScalingToSize:CGSizeMake(image.size.width/2.f, image.size.height/2.f)];
            arr = [arr arrayByAddingObject:image];
        }
        return arr;
    }();
    [header setImages:array forState:MJRefreshStateRefreshing];
    [header setImages:array forState:MJRefreshStatePulling];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.baseTableView.header = header;
    [self.baseTableView.header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setData:2];
    }];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已无更多" forState:MJRefreshStateNoMoreData];
    self.baseTableView.footer = footer;
}

- (void)updateUIWithResponse:(NSDictionary *)dic
{
    [super updateUIWithResponse:dic];
    NSError *error = dic[@"error"];
    NSDictionary *response = dic[@"response"];
    PLInterface interface = (PLInterface)[dic[@"interface"] intValue];
    NSURLSessionDataTask *task = dic[@"task"];
}

- (void)getCurrentCityId:(NSString *)name
{
    WS(weakSelf);
    
//    [self.dataTaskArray addObject:[PLHttpTools get:PLInterface_GetCityInfo params:@{@"cityName":cityName?:@""} result:^(NSDictionary *dic, NSError *error) {
//        SS(strongSelf);
//        if (error) {
//            [weakSelf handleNetworkError:error];
//        }
//        else
//        {
//            NSDictionary *infoDic = dic[@"data"];
//            if (![infoDic isKindOfClass:[NSNull class]]) {
//                strongSelf->cityId = infoDic[@"cityId"];
//                [[NSUserDefaults standardUserDefaults] setObject:@{@"cityId":strongSelf->cityId,@"cityName":strongSelf->cityName} forKey:@"cityInfo"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
//    }]];
}

- (void)showMenu:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    WS(weakSelf);
    NSArray *items = @[
                        [PLMenuItem menuItem:@"消息"
                                       image:[UIImage imageNamed:@"menu_msg"]
                                         tag:100
                                    userInfo:@{@"class":@"PLQRCodeViewController"}],
                        [PLMenuItem menuItem:@"首页"
                                       image:[UIImage imageNamed:@"menu_home"]
                                         tag:101
                                    userInfo:@{@"class":@"PLHomeViewController"}],
                        ];;
    [PLMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-(iPhone6_plus?57:50), NAV_BAR_HEIGHT, (iPhone6_plus?57:50), 0) menuItems:items selected:^(NSInteger index, PLMenuItem *item) {
            NSLog(@"%@",item);
        [weakSelf pushViewController:item];
        }];
}

- (void)changeCity:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PLCityViewController *vc = [[PLCityViewController alloc] init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)pushViewController:(PLMenuItem *)item
{
    Class class = NSClassFromString(item.userInfo[@"class"]);
    class = class?:NSClassFromString(@"PLBaseViewController");
    if (class == NSClassFromString(@"PLHomeViewController")) {
        self.tabBarController.selectedIndex = 0;
        return;
    }
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cityChanged:(NSNotification *)notify
{
    NSLog(@"%@",notify.object);
    if ([notify.object[@"cityName"] rangeOfString:@"定位"].location != NSNotFound) {
        return;
    }
    [cityButton hideIndicator];
    UILabel *label = ((UILabel *)[cityButton viewWithTag:1000]);
    label.text = notify.object[@"cityName"];
    cityName = label.text;
    if (![notify.object[@"cityId"] isEqualToNumber:@(NSNotFound)]) {
        cityId = notify.object[@"cityId"];
    }
    label.textColor = [UIColor blackColor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UILabel *label = ((UILabel *)[cityButton viewWithTag:1000]);
    if ([keyPath isEqualToString:@"text"] && [object isEqual:label]) {
        NSString *str2 = change[@"new"];
        CGFloat width2 = [str2 widthWithFont:[UIFont systemFontOfSize:16] constrainedToHeight:30];
        label.width = width2;
        cityButton.width = label.width+17;
    }
}

- (void)locationChanged:(NSNotification *)notify
{
    NSDictionary *address = notify.object[@"INFO"];
    if ([notify.object[@"CODE"] intValue] == SUCCESS_CODE) {
//        baseNavItem.title = [address[@"Name"] substringFromIndex:([address[@"Country"] length] + [address[@"State"] length] + [address[@"City"] length])];
        [cityButton hideIndicator];
    }
}

- (void)setData:(NSInteger)index
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"]];
    [list removeAllObjects];
    if (index == 1) {
        page = 1;
    }
    else
    {
        page++;
        if (page*10 > array.count) {
            page = array.count/10;
        }
    }
    
    for (int i = 0; i < 10*page; i++) {
        [list addObject:array[i]];
    }
    
    WS(weakSelf);
    [self.baseTableView reloadData];
    if (page == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.baseTableView.header endRefreshing];
        });
    }
    else
    {
        [weakSelf.baseTableView.footer endRefreshing];
        if (page == array.count/10) {
            ((MJRefreshAutoNormalFooter *)self.baseTableView.footer).stateLabel.text = @"已无更多";
        }
    }
}

#pragma mark searchbardelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    PLSearchViewController *searchVC = [[PLSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark TableViewDelegate

static NSString *identy1 = @"identy1";
static NSString *identy2 = @"identy2";
static NSString *identy3 = @"identy3";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    if (indexPath.section == 2) {
       
        PLGuessCell *cell = [tableView dequeueReusableCellWithIdentifier:identy3];
        if (!cell) {
            cell = [[PLGuessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy3];
             [cell setModel];
        }
       
        /*
        MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy3];
        if (cell == nil) {
            cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identy3];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 60, 60)];
            imageView.tag = 100;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
            
            __weak typeof(cell.contentView) weakContentView = cell.contentView;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakContentView.mas_left).with.offset(15);
                make.top.equalTo(weakContentView.mas_top).with.offset(5);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(60);;
            }];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15+60+8, 5, SCREEN_WIDTH-15-60-8-8, 40)];
            label.tag = 101;
            label.textColor = RGB(112, 112, 112);
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakContentView.mas_left).with.offset(15+60+8);
                make.top.equalTo(weakContentView.mas_top).with.offset(5);
                make.right.equalTo(weakContentView.mas_right).with.offset(-8);
                make.height.mas_equalTo(40);
            }];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15+60+8, 50, 100, 16)];
            label2.tag = 102;
            label2.textColor = [UIColor redColor];
            label2.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:label2];
            
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakContentView.mas_left).with.offset(15+60+8);
                make.top.equalTo(weakContentView.mas_top).with.offset(50);
                make.right.equalTo(weakContentView.mas_right).with.offset(-8);
                make.height.mas_equalTo(16);
            }];
        }
        [cell setDefaultColor:tableView.backgroundView.backgroundColor];
        cell.firstTrigger = 70/SCREEN_WIDTH;
        cell.secondTrigger = 0.5;
        
        WS(weakSelf);
        __weak typeof(cell) weakCell = cell;
        [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            NSLog(@"Did swipe \"Checkmark\" cell");
            [weakSelf collectCell:weakCell atIndex:indexPath state:state mode:mode];
        }];
        
        [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            NSLog(@"Did swipe \"Cross\" cell");
            [weakSelf deleteCell:weakCell atIndex:indexPath state:state mode:mode];
        }];
        [cell setDefaultColor:[UIColor lightGrayColor]];
        cell.delegate = self;
        if (list.count) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
            [imageView sd_setImageWithURL:[NSURL URLWithString:list[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"legend_default"]];
            ((UILabel *)[cell.contentView viewWithTag:101]).text = regArray[indexPath.row%6][@"subTitle"];
            ((UILabel *)[cell.contentView viewWithTag:102]).text = list[indexPath.row][@"price"];
         
        }
         */
        return cell;
    }
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56*2+4)];
            scroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, 56*2+4);
            scroll.tag = 50000;
            scroll.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            scroll.delegate = self;
            scroll.showsHorizontalScrollIndicator = NO;
            scroll.showsVerticalScrollIndicator = NO;
            scroll.pagingEnabled = YES;
            [cell.contentView addSubview:scroll];
            
            CGFloat x = (SCREEN_WIDTH*2-30*8)/8;
            
            NSMutableArray *imgArray = [NSMutableArray new];
            NSMutableArray *labArray = [NSMutableArray new];
            for (int i = 0; i < 16; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x/2.f+(x+30)*(i%8), 5+((116-5*2)/2)*(i/8), 30, 30)];
                imageView.tag = 6000;
                [scroll addSubview:imageView];
                [imgArray addObject:imageView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x/2.f+(x+30)*(i%8), 5+((116-5*2)/2)*(i/8)+30, 30, 16)];
                label.bounds = CGRectMake(0, 0, 52, 16);
                label.tag = 6001;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = RGB(112, 112, 112);
                label.font = [UIFont systemFontOfSize:11];
                [scroll addSubview:label];
                
                if (catArray.count) {
                    if (i == 14 || i == 15) {
                        [imageView setImage:[UIImage imageNamed:catArray[i-5][@"img"]]];
                    }
                    else
                    {
                        [imageView setImage:[UIImage imageNamed:catArray[i][@"img"]]];
                    }
                    label.text = catArray[i][@"title"];
                }
            }
            
        }
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (int i = 0; i < 6; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2.f-48)+(SCREEN_WIDTH/2.f)*(i%2), 5+70*(i/2), 40, 60)];
                imageView.tag = 5000;
                [cell.contentView addSubview:imageView];
                
                __weak typeof(cell.contentView) weakContentView = cell.contentView;
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5+70*(i/2));
                    if (i%2 == 1)
                    {
                        make.right.equalTo(weakContentView.mas_right).with.offset(-8);
                    }
                    make.height.mas_equalTo(60);
                    make.width.mas_equalTo(40);
                    if (i%2 == 0) {
                        make.centerX.equalTo(weakContentView.mas_centerX).with.offset(-28);
                    }
                }];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8+(SCREEN_WIDTH/2.f)*(i%2), 8+70*(i/2), SCREEN_WIDTH/2.f-8*2-48, 16)];
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = RGB(229, 72, 167);
                label.textAlignment = NSTextAlignmentCenter;
                label.tag = 5001;
                [cell.contentView addSubview:label];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8+(SCREEN_WIDTH/2.f)*(i%2), 8+16+8+70*(i/2), SCREEN_WIDTH/2.f-8*2-48, 30)];
                label2.font = [UIFont systemFontOfSize:12];
                label2.numberOfLines = 0;
                label2.tag = 5002;
                label2.textColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:label2];
                
                if (regArray.count) {
                    [imageView setImage:[UIImage imageNamed:[regArray[i][@"img"] stringByAppendingPathExtension:@"jpg"]]];
                    label.text = regArray[i][@"title"];
                    label2.text = regArray[i][@"subTitle"];
                }
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(imageView.mas_left).with.offset(8);
                    make.top.equalTo(imageView.mas_top);
                    make.height.mas_equalTo(16);
                    if (i % 2 == 0) {
                        make.left.equalTo(weakContentView.mas_left).with.offset(-8);
                    }
                    else
                    {
                        make.left.equalTo(weakContentView.mas_centerX).with.offset(8);
                    }
                }];
                
                [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(imageView.mas_left).with.offset(8);
                    make.top.equalTo(imageView.mas_top).with.offset(8+16+8);
                    make.height.mas_equalTo(30);
                    if (i % 2 == 0) {
                        make.left.equalTo(weakContentView.mas_left).with.offset(8);
                    }
                    else
                    {
                        make.left.equalTo(weakContentView.mas_centerX).with.offset(8);
                    }
                }];
                
                //线条
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.f-0.3, 5, 0.6, 200)];
                line.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [cell.contentView addSubview:line];
                
                UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 70-0.3, SCREEN_WIDTH-30, 0.6)];
                line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [cell.contentView addSubview:line2];
                
                UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 140-0.3, SCREEN_WIDTH-30, 0.6)];
                line3.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [cell.contentView addSubview:line3];
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(weakContentView.mas_centerX).with.offset(0);
                    make.top.equalTo(weakContentView.mas_top).with.offset(5);
                    make.bottom.equalTo(weakContentView.mas_bottom).with.offset(-5);
                    make.width.mas_equalTo(0.6);
                }];
                [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(weakContentView.mas_centerY).with.offset(-35);
                    make.left.equalTo(weakContentView.mas_left).with.offset(15);
                    make.right.equalTo(weakContentView.mas_right).with.offset(-15);
                    make.height.mas_equalTo(0.6);
                }];
                [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(weakContentView.mas_centerY).with.offset(35);
                    make.left.equalTo(weakContentView.mas_left).with.offset(15);
                    make.right.equalTo(weakContentView.mas_right).with.offset(-15);
                    make.height.mas_equalTo(0.6);
                }];
            }
        }
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
//        return list.count;
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 56*2+4;
    }
    if (indexPath.section == 1) {
        return 70*3;
    }
    return 120;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (section) {
//        case 1:
//            return @"热门推荐";
//            break;
//        case 2:
//            return @"猜你喜欢";
//            break;
//        default:
//            return nil;
//            break;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 40;
    }else{
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 100, 20);
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    switch (section) {
        case 1:
            label.text = @"热门推荐";
            break;
        case 2:
            label.text = @"猜你喜欢";
            break;
        default:
            break;
    }
    return view;
}
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell
{
    
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)deleteCell:(MCSwipeTableViewCell *)cell atIndex:(NSIndexPath *)indexPath state:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode
{
    [cell swipeToOriginWithCompletion:nil];
    if (state == MCSwipeTableViewCellState3 && mode == MCSwipeTableViewCellModeSwitch) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
    }
}

- (void)collectCell:(MCSwipeTableViewCell *)cell atIndex:(NSIndexPath *)indexPath state:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode
{
    [cell swipeToOriginWithCompletion:nil];
    if (state == MCSwipeTableViewCellState1 && mode == MCSwipeTableViewCellModeSwitch) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
    }
}

#pragma mark ScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        if (scrollView.contentOffset.y > 170 && cycleScrollView.timer) {
            [cycleScrollView stop];
        }
        if (scrollView.contentOffset.y <= 170 && !cycleScrollView.timer) {
            [cycleScrollView start];
        }
        return;
    }
    if (scrollView.tag != 50000) {
        return;
    }
    
    UITableViewCell *cell = ^(){
        UIResponder *responder = scrollView;
        while (![responder isKindOfClass:[UITableViewCell class]]) {
            responder = responder.nextResponder;
        }
        return (UITableViewCell *)responder;
    }();
    
    return;
    
    ((UIPageControl *)[cell.contentView viewWithTag:50001]).currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%d",toInterfaceOrientation);
    WS(weakSelf);
    if (toInterfaceOrientation==3 || toInterfaceOrientation==4) {
        [self.baseNavBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(41.7);
        }];
        
        [self.baseTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.height.equalTo(weakSelf.view.mas_height).with.offset(-42);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(42);
        }];
    }
    else if (toInterfaceOrientation==1 || toInterfaceOrientation==2) {
        [self.baseNavBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(63.7);
        }];
        
        [self.baseTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.height.equalTo(weakSelf.view.mas_height).with.offset(-NAV_BAR_HEIGHT);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(NAV_BAR_HEIGHT);
        }];
    }
}

@end
