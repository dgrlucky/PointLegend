//
//  PLQRcodeWindow.h
//  PointLegend
//
//  Created by ydcq on 15/11/26.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLQRcodeWindow : UIWindow

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id delegate;

- (void)setQRImageWithString:(NSString *)str;

@end
