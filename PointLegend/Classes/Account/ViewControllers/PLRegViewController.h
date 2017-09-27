//
//  PLRegViewController.h
//  PointLegend
//
//  Created by ydcq on 15/11/24.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseViewController.h"

@interface PLRegViewController : PLBaseViewController

/**
 *  是否有推荐人
 **/
@property (nonatomic, assign) BOOL recommended;
/**
 *  推荐人手机号
 **/
@property (nonatomic, strong) NSString *recommender;

@end
