//
//  Macros.h
//  PointLegend
//
//  Created by ydcq on 15/9/8.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#ifndef PointLegend_Macros_h
#define PointLegend_Macros_h

#define NUMBERS @"0123456789\n"  //键盘数字输入判断
#define MoneyNUMBERS @"0123456789.\n"  //金额数字输入判断


//--------------------设备---------------------------
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAV_BAR_HEIGHT 64
#define TOOL_BAR_HEIGHT 49

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//不考虑放大模式
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.f)

//----------------------打印----------------------------
//NSLog
#ifndef __OPTIMIZE__
#define NSLog(FORMAT,...)  NSLog(@"\n文件:%@ 行号:%d 打印:%@\n",[[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject], __LINE__,[NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define NSLog(...) {}
#endif

//----------------------颜色---------------------------
//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
//compiling without ARC
#endif

//系统版本
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
//5+
#else
//5-
#endif

//创建self对象的弱引用
#define WS(weakSelf) __weak __typeof(self)weakSelf = self;


#define __IPHONE_OS_VERSION_MAX [[[UIDevice currentDevice] systemVersion] floatValue];

//创建weakSelf对象的强引用
#define SS(strongSelf) __strong __typeof(weakSelf)strongSelf = weakSelf;

#define FilePathInBundle(a) [[NSBundle mainBundle] pathForResource:[a stringByDeletingPathExtension] ofType:[a pathExtension]]

#define FilePathInDocDir(a) [[NSHomeDirectory() stringByAppendingString:@"/Documents"] stringByAppendingString:a]

//奖励
#define RewardTypeDic (@{@"0":@"全部",@"4":@"消费返利",@"5":@"推荐会员",@"6":@"推荐店铺",@"7":@"服务店铺",@"8":@"市级代理",@"9":@"区县代理",@"10":@"乡镇代理"})
#define RecommandWayDic (@{@"0":@"未知渠道",@"1":@"二维码",@"2":@"商家后台",@"3":@"收银机",@"4":@"帮人注册",@"5":@"路由器",@"6":@"分享",@"7":@"分享",@"8":@"公众号",@"9":@"帮人注册",@"10":@"分享",@"11":@"分享"})

#define isNull(obj) (((NSNull *)obj == [NSNull null])?YES:NO)

#endif
