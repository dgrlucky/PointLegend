//
//  PLRewardListCell.h
//  PointLegend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseCell.h"

@interface PLRewardListCell : PLBaseCell
/**
 *  显示时间
 */
@property (nonatomic, strong) UILabel *subTitleLabel;
/**
 *  显示钱
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  是否展开
 */
@property (nonatomic, assign) BOOL showsDetail;

@property (nonatomic, strong) UIView *detailView;

@end
