//
//  HomeViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "HomeViewController.h"
#import "PLMenu.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseTableView.hidden = NO;
//    self.baseTableView.delegate = self;
//    self.baseTableView.dataSource = self;
    self.baseSearchBar.hidden = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu:)];
}

- (void)showMenu:(id)sender
{
    [PLMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-(iPhone6_plus?57:50), NAV_BAR_HEIGHT, (iPhone6_plus?57:50), 0) menuItems:^(){
        PLMenuItem *menuTitle = [PLMenuItem menuTitle:@"Menu" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:15.0f];
        
        //set item
        return [@[
                    [PLMenuItem menuItem:@"消息"
                                    image:[UIImage imageNamed:@"menu_msg"]
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [PLMenuItem menuItem:@"首页"
                                    image:[UIImage imageNamed:@"menu_home"]
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    ] mutableCopy];}() selected:^(NSInteger index, PLMenuItem *item) {
            NSLog(@"%@",item);
        }];
}

@end
