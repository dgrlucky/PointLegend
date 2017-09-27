//
//  PLBaseCell.h
//  PointLegend
//
//  Created by ydcq on 15/11/27.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, cellType)
{
    //高度40
    cellTypeDefault, //头像+标题
    cellTypeSubTitle, //头像+标题+子标题
    //高度70,我的
    cellTypeMine,
    //头像+名称+输入框
    cellTypeInput,
    //奖励统计
    cellTypeReward,
    //消息
    cellTypeMsg
};

@interface PLBaseCell : UITableViewCell
/**
 *  Cell类型
 */
@property (nonatomic, assign) cellType type;
/**
 *  左侧头像
 */
@property (nonatomic, strong) UIImageView *headImageView;
/**
 *  Title
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  Cell类型
 */
- (instancetype)initWithType:(cellType)type;
/**
 *  根据类型获取复用字段
 */
+ (NSString *)cellReuseIdentifier:(cellType)type;
/**
 *  信息(头像url、title、右侧文字等) {@"img":@"xx",@"title":@"yy",@"subTitle":@"zz",@"rText":@"rr"}
 */
@property (nonatomic, strong) NSDictionary *infoDic;

@end
