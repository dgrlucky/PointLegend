//
//  PLTabbarController.h
//  TestDemo
//
//  Created by ydcq on 15/9/7.
//  Copyright (c) 2015年 黄国桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLTabbarController : UITabBarController

@property (nonatomic, strong) NSDictionary *itemInfoDic; //服务器返回的item信息
/**
 *  Tabbar每个节点所需的数据（VC类型、title、image、selectedImage、、、）
 *
 *  @param dic 输入
 *
 *  @return 生成对象
 */
- (instancetype)initWithInfoArray:(NSArray *)arr;

@end
