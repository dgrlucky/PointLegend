//
//  UIDevice+Model.h
//  JSDemo
//
//  Created by 王春林 on 9/9/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DeviceType) {
    DeviceAppleUnknown,
    DeviceAppleSimulator,
    DeviceAppleiPhone,
    DeviceAppleiPhone3G,
    DeviceAppleiPhone3GS,
    DeviceAppleiPhone4,
    DeviceAppleiPhone4S,
    DeviceAppleiPhone5,
    DeviceAppleiPhone5C,
    DeviceAppleiPhone5S,
    DeviceAppleiPhone6,
    DeviceAppleiPhone6_Plus,
    DeviceAppleiPodTouch,
    DeviceAppleiPodTouch2G,
    DeviceAppleiPodTouch3G,
    DeviceAppleiPodTouch4G,
    DeviceAppleiPad,
    DeviceAppleiPad2,
    DeviceAppleiPad3G,
    DeviceAppleiPad4G,
    DeviceAppleiPad5G_Air,
    DeviceAppleiPadMini,
    DeviceAppleiPadMini2G
};

@interface UIDevice (Model)
/**
 *  设备型号
 *
 *  @return 型号描述(iPhone6,2)
 */
- (NSString *)deviceDescription;
/**
 *  类型
 *
 *  @return 枚举类型
 */
- (DeviceType)deviceType;
/**
 *  网络状态
 *
 *  @return 3G?4G...
 */
- (NSString *)networkStatus;


@end
