//
//  PLLocationMgr.m
//  PointLegend
//
//  Created by ydcq on 15/9/10.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLLocationMgr.h"
#import "JZLocationConverter.h"
#import "UIAlertView+Block.h"

NSString *PointLegendUserLocationChangedNotification = @"userLocationChangedNotification";

#define DEFAULT_FILTER 5

@interface PLLocationMgr ()<CLLocationManagerDelegate>

@end

@implementation PLLocationMgr

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

static PLLocationMgr *mgr = nil;

+ (void)initialize
{
    if (mgr == nil) {
        mgr = [[PLLocationMgr alloc] init];
        mgr.locationManager = [[CLLocationManager alloc] init];
        mgr.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        mgr.locationManager.distanceFilter = DEFAULT_FILTER;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.f) {
            [mgr.locationManager requestWhenInUseAuthorization];
        }
    }
}

+ (instancetype)sharedInstance
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        if([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
        {
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex)
         {
             if (buttonIndex == 0) {NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];if ([[UIApplication sharedApplication] canOpenURL:url]) {[[UIApplication sharedApplication] openURL:url];}}} title:@"提示" message:@"当前手机未开启定位功能" cancelButtonName:@"前去设置" otherButtonTitles:@"取消", nil];}else{[SVProgressHUD showErrorWithStatus:@"当前手机未开启定位服务！" maskType:SVProgressHUDMaskTypeNone];
             }
    }
    
    return mgr;
}

#pragma cllocation  delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"定位成功");
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D  coordinate2D= [JZLocationConverter wgs84ToGcj02:location.coordinate];
    CLLocation *afterlocation = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    
    __block NSString *cityName = nil;
    
    WS(weakSelf);
    
    //地理信息反编码
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:afterlocation completionHandler:^(NSArray *placemark,NSError *error)
     {
         if (error) {
             NSNotification *notify = [[NSNotification alloc] initWithName:PointLegendUserLocationChangedNotification object:@{@"CODE":@(GEO_ERROR_CODE),@"ERROR":error} userInfo:nil];
             [[NSNotificationCenter defaultCenter] postNotification:notify];
         }
         else
         {
             CLPlacemark *mark=[placemark objectAtIndex:0];
             
             NSDictionary *dic = mark.addressDictionary;
             
             if (dic) {
                 NSNotification *notify = [[NSNotification alloc] initWithName:PointLegendUserLocationChangedNotification object:@{@"CODE":@(SUCCESS_CODE),@"INFO":dic} userInfo:nil];
                 [[NSNotificationCenter defaultCenter] postNotification:notify];
             }
         }
     }];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@",error);
    
    NSNotification *notify = [[NSNotification alloc] initWithName:PointLegendUserLocationChangedNotification object:@{@"CODE":@(ERROR_CODE),@"ERROR":error} userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

@end
