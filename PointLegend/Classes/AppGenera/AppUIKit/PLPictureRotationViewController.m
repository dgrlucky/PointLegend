//
//  PLPictureRotationViewController.m
//  PointLegend
//
//  Created by leon guo on 15/9/10.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLPictureRotationViewController.h"

@interface PLPictureRotationViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int pageCount;

@end

@implementation PLPictureRotationViewController


-(UIScrollView *)scrollview{
    if (_scrollview==nil) {
        _scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollview.backgroundColor=[UIColor redColor];
        
        [self.view addSubview:_scrollview];
        //取消弹簧效果
        _scrollview.bounces=NO;
        //取消水平滚动
        _scrollview.showsHorizontalScrollIndicator=NO;
        //取消垂直滚动
        _scrollview.showsVerticalScrollIndicator=NO;
        //开启分页
        _scrollview.pagingEnabled=YES;
        //contentSize
        _scrollview.contentSize=CGSizeMake(_scrollview.width*_pageCount, 0);
        _scrollview.delegate=self;
    }
    
    return _scrollview;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        // 总页数
        _pageControl.numberOfPages = _pageCount;
        // 控件尺寸
        CGSize size = [_pageControl sizeForNumberOfPages:_pageCount];
        
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.centerX, self.view.height-15);
        
        // 设置颜色
//        _pageControl.pageIndicatorTintColor = [UIColor redColor];
//        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        [self.view addSubview:_pageControl];
        
        // 添加监听方法
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

//-(NSTimer *)timer{
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageCount=_PicArrar.count;
    for (int i = 0; i < _pageCount; i++) {
        //UIImage *image = [UIImage imageNamed:_PicArrar[i]];
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], _PicArrar[i]];
        UIImage *image=[UIImage imageWithContentsOfFile:path];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollview.bounds];
        if (i==_pageCount-1&&_button!=nil) {
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:self.button];
        }
        imageView.image = image;
        
        [_scrollview addSubview:imageView];
    }
    
    // 计算imageView的位置
    [self.scrollview.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        
        // 调整x => origin => frame
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        
        imageView.frame = frame;
    }];
    
    
    // 分页初始页数为0
    self.pageControl.currentPage = 0;
}


-(void)pageChanged:(UIPageControl *)page{
    
    // 根据页数，调整滚动视图中的图片位置 contentOffset
    CGFloat x = page.currentPage * self.scrollview.width;
    [self.scrollview setContentOffset:CGPointMake(x, 0) animated:YES];

}

#pragma mark scrollView代理方法

// 滚动视图停下来，修改页面控件的小点（页数）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算页数
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
//    if(scrollView.contentOffset.x==scrollView.contentSize.width-scrollView.width)
//    {
//        page=0;
//    }
    
    self.pageControl.currentPage = page;
}

-(PLPictureRotationViewController *)initwithArrar:(NSArray *)array andWithButton:(UIButton *)button{
    self.PicArrar=array;
    self.button=button;
    return [self init];
    
}

//+ (instancetype)pictureRotationWithArray:(NSArray *)picArray starButton:(UIButton *)button
//{
//    return [];
//}

@end
