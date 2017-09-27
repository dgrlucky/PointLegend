//
//  PLMySuggestionCell.h
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLBaseCell.h"

@interface PLMySuggestionCell : PLBaseCell

/**
 *  显示姓名
 */
@property (nonatomic, strong) UILabel *subTitleLabel;
/**
 *  通过xx推荐
 */
@property (nonatomic, strong) UILabel *rightLabel1;
/**
 *  显示时间
 */
@property (nonatomic, strong) UILabel *rightLabel2;

@end
