//
//  PLTakePictureViewController.h
//  PointLegend
//
//  Created by ydcq on 15/11/27.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastttCamera.h"

@interface PLTakePictureViewController : FastttCamera

@property (nonatomic, copy) void (^finishCameraBlock)(NSData *data);

@end
