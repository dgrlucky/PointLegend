//
//  PLCollectViewController.m
//  PointLegend
//
//  Created by ydcq on 15/12/23.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLCollectViewController.h"
#import "PLButton.h"
#import "PLBaseRefreshViewController.h"
#import "PLCollectionShopModel.h"
#import "PLCollectionGoodsModel.h"

@interface PLCollectViewController ()
{
    PLCollectShopViewController *storeVC;
    PLCollectGoodsViewController *goodsVC;
}

@end

@implementation PLCollectViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"收藏";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //店铺、商品
    WS(weakSelf);
    for (int i = 0; i < 2; i++) {
        PLButton *button = [PLButton buttonWithFrame:CGRectMake(i==0?0:(SCREEN_WIDTH/2.f+0.25), NAV_BAR_HEIGHT, (SCREEN_WIDTH-0.5)/2.f, 44) backgroundColor:[UIColor whiteColor] title:i==0?@"店铺":@"商品" titleFont:[UIFont systemFontOfSize:15]  tag:1000+i actionBlock:^(NSInteger tag) {
            [weakSelf handleButtonClick:tag];
        }];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.view addSubview:button];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2.f-0.25), NAV_BAR_HEIGHT+7, 0.5, 30)];
        line.backgroundColor = [UITableView new].separatorColor;
        [self.view addSubview:line];
        
        if (i == 0) {
            [self handleButtonClick:1000+i];
        }
    }
}

#pragma mark Others

- (void)handleButtonClick:(NSInteger)tag
{
    PLButton *button = (PLButton *)[self.view viewWithTag:tag];
    if (button.selected) {
        return;
    }
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[PLButton class]]) {
            if (v.tag != tag) {
                [((PLButton *)v) setSelected:NO];
                [((PLButton *)v) setUserInteractionEnabled:YES];
                ((PLButton *)v).titleLabel.font = [UIFont systemFontOfSize:15];
            }
        }
    }
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.selected = YES;
    button.userInteractionEnabled = NO;
    if (tag == 1000) {
        if (!storeVC) {
            storeVC = [[PLCollectShopViewController alloc] init];
            [self addChildViewController:storeVC];
            storeVC.view.frame = CGRectMake(0, NAV_BAR_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT-44);
            [storeVC.baseNavBar removeFromSuperview];
            storeVC.baseNavBar = nil;
            storeVC.baseTableView.y = 0;
            storeVC.baseTableView.height = SCREEN_HEIGHT-NAV_BAR_HEIGHT-44;
            [self.view addSubview:storeVC.view];
        }
        if (!storeVC.index) {
            [storeVC setRequestWithInterface:PLInterface_GetMyFavoriteShop index:@"pNo" parameters:@{@"pNo":@"1",@"pSize":@10,@"userId":[PLUserInfoModel sharedInstance].userId,@"longitude":@"",@"latitude":@""}];
        }
        if (goodsVC) {
            [self transitionFromViewController:goodsVC toViewController:storeVC duration:0.3 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:nil];
        }
    }
    if (tag == 1001) {
        if (!goodsVC) {
            goodsVC = [[PLCollectGoodsViewController alloc] init];
            [self addChildViewController:goodsVC];
            goodsVC.view.frame = CGRectMake(0, NAV_BAR_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT-44);
            [goodsVC.baseNavBar removeFromSuperview];
            goodsVC.baseNavBar = nil;
            goodsVC.baseTableView.y = 0;
            goodsVC.baseTableView.height = SCREEN_HEIGHT-NAV_BAR_HEIGHT-44;
            [self.view addSubview:goodsVC.view];
        }
        if (!goodsVC.index) {
            [goodsVC setRequestWithInterface:PLInterface_GetMyFavoriteGoods index:@"pNo" parameters:@{@"pNo":@"1",@"pSize":@10,@"userId":[PLUserInfoModel sharedInstance].userId,@"longitude":@"",@"latitude":@""}];
        }
        if (storeVC) {
            [self transitionFromViewController:storeVC toViewController:goodsVC duration:0.3 options:UIViewAnimationOptionLayoutSubviews animations:nil completion:nil];
        }
    }
}

@end

#pragma mark 店铺

@implementation PLCollectShopViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
}

#pragma mark Network

- (void)handleResponse:(NSDictionary *)rsp
{
    id data = rsp[@"data"];
    if (isNull(data)) {
        return;
    }
    NSArray *lst = data[@"lst"];
    if (isNull(lst)) {
        return;
    }
    if (lst.count==0) {
        if (self.pageIndex>1) {
            self.pageIndex--;
            footerText(@"已无更多");
        }
        else
        {
            [self showFlagLabel:YES text:@"暂无数据"];
        }
    }
    if (lst.count) {
        for (NSDictionary *d in lst) {
            PLCollectionShopModel *model = [[PLCollectionShopModel alloc] initContentwith:d];
            [self.dataArray addObject:model];
        }
        [self.baseTableView reloadData];
    }
}

#pragma mark Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.dataArray.count) {
        cell.textLabel.text = ((PLCollectionShopModel *)self.dataArray[indexPath.row]).shopName;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

@end

#pragma mark 商品

@implementation PLCollectGoodsViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
}

#pragma mark Network

- (void)handleResponse:(NSDictionary *)rsp
{
    id data = rsp[@"data"];
    if (isNull(data)) {
        return;
    }
    NSArray *lst = data[@"lst"];
    if (isNull(lst)) {
        return;
    }
    if (lst.count==0) {
        if (self.pageIndex>1) {
            self.pageIndex--;
            footerText(@"已无更多");
        }
        else
        {
            [self showFlagLabel:YES text:@"暂无数据"];
        }
    }
    if (lst.count) {
        for (NSDictionary *d in lst) {
            PLCollectionGoodsModel *model = [[PLCollectionGoodsModel alloc] initContentwith:d];
            [self.dataArray addObject:model];
        }
        [self.baseTableView reloadData];
    }
}

#pragma mark Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.dataArray.count) {
        cell.textLabel.text = ((PLCollectionGoodsModel *)self.dataArray[indexPath.row]).goodsName;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

@end
