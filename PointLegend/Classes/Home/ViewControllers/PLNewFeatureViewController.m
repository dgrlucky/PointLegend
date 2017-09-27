//
//  PLNewFeatureViewController.m
//  PointLegend
//
//  Created by leon guo on 15/9/11.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLNewFeatureViewController.h"
#import "PLRollScrollView.h"
#import "NSString+Util.h"
#import "PLHomeViewController.h"
#import "AppDelegate.h"

@interface PLNewFeatureViewController ()<UIScrollViewDelegate>
{
    NSArray       *imagesSmall;
    NSArray       *images;
    UIScrollView  *imgScrollView;
    UIPageControl *pageControl;
}
@end

@implementation PLNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    //隐藏状态栏
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    [self _initScrollView];
}


- (void)_initScrollView
{
    images = @[@"boot_01_img",@"boot_02_img",@"boot_03_img"];
    imagesSmall = @[@"boot_01_title",@"boot_02_title",@"boot_03_title"];
    
    imgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imgScrollView.delegate = self;
    imgScrollView.showsHorizontalScrollIndicator = NO;
    imgScrollView.showsVerticalScrollIndicator = NO;
    imgScrollView.bounces = NO;
    imgScrollView.contentSize = CGSizeMake(images.count * SCREEN_WIDTH , SCREEN_HEIGHT);
    imgScrollView.pagingEnabled = YES;
    
    NSArray *backColor = @[@"f35741",@"70c9f3",@"f7b32e"];
    for (int i = 0; i < images.count; i++) {
        
        //标题
        UIImageView *tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 250/660.f*SCREEN_WIDTH)];
        tImageView.contentMode = UIViewContentModeScaleAspectFit;
        tImageView.image = [UIImage imageNamed:imagesSmall[i]];
        tImageView.backgroundColor = [UIColor HexColorSixteen:backColor[i]];
        tImageView.tag = 20000+i;
        tImageView.clipsToBounds = YES;
        [imgScrollView addSubview:tImageView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 250/660.f*SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_HEIGHT-(250/660.f*SCREEN_WIDTH))];
        bottomView.backgroundColor = [UIColor HexColorSixteen:backColor[i]];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_WIDTH*(750/700.f))];
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 10000+i;
        [bottomView addSubview:imageView];
        [imgScrollView addSubview:bottomView];
        
        if (iPhone4) {
            bottomView.frame = CGRectMake(SCREEN_WIDTH * i, 250/660.f*SCREEN_WIDTH-40, SCREEN_WIDTH, SCREEN_HEIGHT-(250/660.f*SCREEN_WIDTH)+40);
        }
        
        [imgScrollView insertSubview:bottomView belowSubview:tImageView];
        
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
        bottomView.userInteractionEnabled = YES;
        [bottomView addGestureRecognizer:tap];
        
        if (i == images.count-1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 7;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 1;
            [button setBackgroundColor:[UIColor clearColor]];
            if (iPhone4) {
                button.center = CGPointMake(SCREEN_WIDTH/2.f, bottomView.frame.size.height-50);
            }
            else
            {
                button.center = CGPointMake(SCREEN_WIDTH/2.f, bottomView.frame.size.height-80);
            }
            button.bounds = CGRectMake(0, 0, 315/750.f*SCREEN_WIDTH, 86/1333.f*SCREEN_HEIGHT);
            [button addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:button];
        }
    }
    [self.view addSubview:imgScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-20, SCREEN_WIDTH, 10)];
    pageControl.numberOfPages = images.count;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
}

- (void)changeRootVC
{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.window.rootViewController = appdelegate.tabbar;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offsetx = (int)scrollView.contentOffset.x;
    int width = (int)SCREEN_WIDTH;
    CGFloat page = offsetx/width;
    
    int iPage = (int)page;
    if (page > iPage) {
        if (page-iPage > 0.5) {
            iPage = iPage+1;
        }
    }
    
    pageControl.currentPage = iPage;
}


- (void)imgClick
{
    if (imgScrollView.contentOffset.x/SCREEN_WIDTH != 2) {
        return;
    }
    [self _showTabBarController];
}


- (void)_showTabBarController
{
    WS(weakSelf);
    [UIView animateWithDuration:.3 animations:^{
        SS(strongSelf);
        strongSelf->imgScrollView.hidden = YES;
        [strongSelf changeRootVC];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   }

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
