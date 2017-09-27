//
//  PLBaseViewController.h
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLHttpTools.h"

#define baseNavItem ((UINavigationItem *)self.baseNavBar.items[0])

@interface PLBaseViewController : UIViewController

/**
 *  基类TableView，默认plain模式、隐藏
 */
@property (nonatomic,strong) UITableView *baseTableView;
/**
 *  基类导航栏，默认隐藏
 */
@property (nonatomic,strong) UINavigationBar *baseNavBar;
/**
 *  基类工具栏，默认隐藏
 */
@property (nonatomic,strong) UIToolbar *baseToolBar;
/**
 *  基类搜索框，默认隐藏
 */
@property (nonatomic,strong) UISearchBar *baseSearchBar;
/**
 *  定时器，用于验证码倒计时
 */
@property (nonatomic,weak) NSTimer *timer;
/**
 *  网络请求
 */
@property (nonatomic,strong) NSMutableArray *dataTaskArray;
/**
 *  在pop或者dismiss的时候做清理工作，取消线程、停止Timer、停止WebView的加载等
 **/
@property (nonatomic,assign) BOOL shouldRelease;
/**
 *  网络请求错误处理
 **/
- (void)handleNetworkError:(NSError *)error;
/**
 *  网络请求成功
 *
 *  @param dic 返回数据
 */
- (void)updateUIWithResponse:(NSDictionary *)dic;
/**
 * 返回上一页面
 **/
- (void)popToPreviousVC;
/**
 * 账号合法性检查
 **/
+ (BOOL)isMobileNumValid:(NSString *)mobileNum;
/**
 * 密码合法性检查
 **/
+ (BOOL)isPasswordValid:(NSString *)password;
/**
 * 显示返回按钮
 **/
- (void)showsBackButton;
/**
 * 设置TableView，一般用于更改Style
 **/
- (void)setBaseTableViewWithStyle:(UITableViewStyle)style frame:(CGRect)rect;
/**
 *  设置搜索框
 *
 *  @param rect        坐标
 *  @param placeHolder 占位字符
 */
- (void)setBaseSearchBarOnBaseNavBarWithFrame:(CGRect)rect placeHolder:(NSString *)placeHolder;

/**
 *  网络请求方式
 */
typedef NS_ENUM(NSInteger, requestMethod){
    /**
     *  get
     */
    GET,
    /**
     *  post
     */
    POST,
    /**
     *  头像上传
     */
    UPLOAD
};
/**
 *  请求
 *
 *  @param method    get/post
 *  @param interface 接口
 *  @param dic       参数
 *  @param selector  回调方法，传空=updateUIWithResponse:
 */
- (void)sendRequestWithMethod:(requestMethod)method interface:(PLInterface)interface parameters:(NSDictionary *)dic;
- (void)sendRequestWithMethod:(requestMethod)method interface:(PLInterface)interface parameters:(NSDictionary *)dic callbackMethod:(SEL)selector;

@end
