//
//  PLRewardListCell.m
//  PointLegend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLRewardListCell.h"

@implementation PLRewardListCell

- (void)setInfoDic:(NSDictionary *)infoDic
{
    [super setInfoDic:infoDic];
}

- (void)setType:(cellType)type
{
    [super setType:type];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setShowsDetail:(BOOL)showsDetail
{
    _showsDetail = showsDetail;
    
    if (_showsDetail) {
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _detailView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 50);
        [self.contentView addSubview:_detailView];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 77;
        label.frame = CGRectMake(15, 0, SCREEN_WIDTH-15*2, _detailView.frame.size.height);
        label.font = [UIFont systemFontOfSize:14];
        [_detailView addSubview:label];
        label.numberOfLines = 2;
    }
    else
    {
        [_detailView removeFromSuperview];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.headImageView removeFromSuperview];
        self.headImageView = nil;
        
        self.titleLabel.textColor = RGB(102, 102, 102);
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor redColor];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = [UIFont systemFontOfSize:21];
        [self.contentView addSubview:_rightLabel];
        _rightLabel.frame = CGRectMake(SCREEN_WIDTH-130, 0, 115, 50);
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_subTitleLabel];
        _subTitleLabel.frame = CGRectMake(15, 30, SCREEN_WIDTH-25-130, 17);
        self.titleLabel.frame = CGRectMake(15, 5, SCREEN_WIDTH-25-130, 22);
    }
    return self;
}

@end
