//
//  PLUserInfoModel.m
//  PointLegend
//
//  Created by 1dcq on 15/12/18.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLUserInfoModel.h"

@implementation PLUserInfoModel

static PLUserInfoModel *obj = nil;

+ (void)load
{
    [PLUserInfoModel sharedInstance];
}

+ (void)initialize
{
    obj = [[PLUserInfoModel alloc] init];
}

+ (instancetype)sharedInstance
{
    return obj;
}

@end
