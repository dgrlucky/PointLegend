//
//  PLRollScrollView.h
//  PointLegend
//
//  Created by leon guo on 15/9/11.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLRollScrollView : UIView

@property(nonatomic,strong)NSArray *PicArrar;
@property(nonatomic,strong)UIButton *startButton;
-(void)start;
@end
