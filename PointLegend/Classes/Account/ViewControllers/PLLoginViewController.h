//
//  PLLoginViewController.h
//  PointLegend
//
//  Created by ydcq on 15/9/18.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"

@protocol PLLoginViewControllerDelegate <NSObject>

@optional
- (void)changeState:(NSNumber *)state;

@end

@interface PLLoginViewController : PLBaseViewController

@property (nonatomic, weak) id <PLLoginViewControllerDelegate> delegate;

@end
