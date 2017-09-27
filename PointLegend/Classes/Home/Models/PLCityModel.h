//
//  PLCityModel.h
//  PointLegend
//
//  Created by ydcq on 15/9/16.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLCityModel : NSObject

@property(nonatomic, strong)NSNumber *cityId;

@property(nonatomic, strong)NSString *cityName;

@property(nonatomic, strong)NSString *firstLetterOfCity;

@property(nonatomic, strong)NSNumber *provinceId;

@property(nonatomic, strong)NSString *provinceName;

@end
