//
//  UIImage+Scale.h
//  PointLegend
//
//  Created by ydcq on 15/11/12.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

+ (UIImage *)image:(UIImage *)image byScalingToSize:(CGSize)size;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

@end
