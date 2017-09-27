//
//  PLLocationMgr.h
//  PointLegend
//
//  Created by ydcq on 15/9/10.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define SUCCESS_CODE 1000
#define ERROR_CODE 1001
#define GEO_ERROR_CODE 1002

extern NSString *PointLegendUserLocationChangedNotification;

@interface PLLocationMgr : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end
