//
//  PLInputCell.h
//  PointLegend
//
//  Created by ydcq on 15/11/30.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseCell.h"

@interface PLInputCell : PLBaseCell

/**
 *  输入框
 */
@property (nonatomic, strong) UITextField *inputTX;
/**
 *  获取验证码
 */
@property (nonatomic, strong) UIButton *vButton;

@end
