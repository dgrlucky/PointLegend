//
//  UIDevice+Model.m
//  JSDemo
//
//  Created by 王春林 on 9/9/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "UIDevice+Model.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (Model)

- (NSString *)deviceDescription
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (DeviceType)deviceType
{
    NSNumber *deviceType = [[self deviceTypeLookupTable] objectForKey:[self deviceDescription]];
    return [deviceType unsignedIntegerValue];
}

- (NSDictionary *)deviceTypeLookupTable
{
    return @{
             @"i386": @(DeviceAppleSimulator),
             @"x86_64": @(DeviceAppleSimulator),
             @"iPod1,1": @(DeviceAppleiPodTouch),
             @"iPod2,1": @(DeviceAppleiPodTouch2G),
             @"iPod3,1": @(DeviceAppleiPodTouch3G),
             @"iPod4,1": @(DeviceAppleiPodTouch4G),
             @"iPhone1,1": @(DeviceAppleiPhone),
             @"iPhone1,2": @(DeviceAppleiPhone3G),
             @"iPhone2,1": @(DeviceAppleiPhone3GS),
             @"iPhone3,1": @(DeviceAppleiPhone4),
             @"iPhone3,3": @(DeviceAppleiPhone4),
             @"iPhone4,1": @(DeviceAppleiPhone4S),
             @"iPhone5,1": @(DeviceAppleiPhone5),
             @"iPhone5,2": @(DeviceAppleiPhone5),
             @"iPhone5,3": @(DeviceAppleiPhone5C),
             @"iPhone5,4": @(DeviceAppleiPhone5C),
             @"iPhone6,1": @(DeviceAppleiPhone5S),
             @"iPhone6,2": @(DeviceAppleiPhone5S),
             @"iPhone7,1": @(DeviceAppleiPhone6_Plus),
             @"iPhone7,2": @(DeviceAppleiPhone6),
             @"iPad1,1": @(DeviceAppleiPad),
             @"iPad2,1": @(DeviceAppleiPad2),
             @"iPad3,1": @(DeviceAppleiPad3G),
             @"iPad3,4": @(DeviceAppleiPad4G),
             @"iPad2,5": @(DeviceAppleiPadMini),
             @"iPad4,1": @(DeviceAppleiPad5G_Air),
             @"iPad4,2": @(DeviceAppleiPad5G_Air),
             @"iPad4,4": @(DeviceAppleiPadMini2G),
             @"iPad4,5": @(DeviceAppleiPadMini2G)
             };
}

- (NSString *)networkStatus
{
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology; //获取当前网络描述
    
    __weak typeof(networkStatus) weakObj = networkStatus;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CTRadioAccessTechnologyDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"New Radio Access Technology: %@", weakObj.currentRadioAccessTechnology);
    }];
    
    NSString *p = @"";
    NSString *provider = networkStatus.subscriberCellularProvider.mobileNetworkCode;
    
    networkStatus.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier){
        NSLog(@"%@",weakObj.subscriberCellularProvider);
    };
    
    if ([provider isEqualToString:@"00"] || [provider isEqualToString:@"02"] || [provider isEqualToString:@"07"]) {
        //移动
        p = @"CM";
    }
    if ([provider isEqualToString:@"01"] || [provider isEqualToString:@"06"]) {
        //联通
        p = @"CU";
    }
    if ([provider isEqualToString:@"03"] || [provider isEqualToString:@"05"]) {
        //电信
        p = @"CT";
    }
    if ([provider isEqualToString:@"20"]) {
        //铁通
        p = @"TT";
    }

    NSString *status = @"";
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        status = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        status = @"2.75G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        status = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        status = @"3.5G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        status = @"3.5G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        status = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G吧?)
        status = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G吧?)
        status = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORevB(应该还是算3G吧?)
        status = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //HRPD网络
        status = @"3.75G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        status = @"4G";
    }
    
    return [NSString stringWithFormat:@"%@_%@",p,status];
}

@end
