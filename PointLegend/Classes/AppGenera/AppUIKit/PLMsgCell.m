//
//  PLMsgCell.m
//  PointLegend
//
//  Created by ydcq on 15/12/21.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLMsgCell.h"

@implementation PLMsgCell

- (void)setInfoDic:(NSDictionary *)infoDic
{
    [super setInfoDic:infoDic];
}

- (void)setType:(cellType)type
{
    [super setType:type];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_subTitleLabel];
        _subTitleLabel.frame = CGRectMake(15, 30, SCREEN_WIDTH-30, 17);
        self.titleLabel.frame = CGRectMake(15, 5, SCREEN_WIDTH-30, 22);
        self.subTitleLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setModel:(PLMsgModel *)model
{
    _model = model;
    self.titleLabel.text = model.msgTitle;
    self.subTitleLabel.text = model.msgDesc;
    CGFloat height = [model.msgDesc heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:(SCREEN_WIDTH-30)];
    if (height > 40) {
        height = 40;
    }
    self.subTitleLabel.height = height;
}

@end
