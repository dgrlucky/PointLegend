//
//  AppDelegate.h
//  PointLegend
//
//  Created by leon guo on 15/9/7.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PLTabbarController.h"
#import "PLHomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)PLTabbarController *tabbar;

@end

