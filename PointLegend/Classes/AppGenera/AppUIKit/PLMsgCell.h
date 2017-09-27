//
//  PLMsgCell.h
//  PointLegend
//
//  Created by ydcq on 15/12/21.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseCell.h"
#import "PLMsgModel.h"

@interface PLMsgCell : PLBaseCell

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) PLMsgModel *model;

@end
