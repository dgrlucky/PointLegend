//
//  PLMySuggestionCell.m
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLMySuggestionCell.h"

@implementation PLMySuggestionCell

- (void)setInfoDic:(NSDictionary *)infoDic
{
    [super setInfoDic:infoDic];
}

- (void)setType:(cellType)type
{
    [super setType:type];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.headImageView removeFromSuperview];
        self.headImageView = nil;
        
        self.titleLabel.textColor = [UIColor darkGrayColor];
        
        _rightLabel1 = [[UILabel alloc] init];
        _rightLabel1.textAlignment = NSTextAlignmentRight;
        _rightLabel1.font = [UIFont systemFontOfSize:15.4];
        _rightLabel1.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_rightLabel1];
        _rightLabel1.frame = CGRectMake(SCREEN_WIDTH-200, 8, 185, 20);
        
        _rightLabel2 = [[UILabel alloc] init];
        _rightLabel2.textColor = [UIColor lightGrayColor];
        _rightLabel2.textAlignment = NSTextAlignmentRight;
        _rightLabel2.font = [UIFont systemFontOfSize:13.4];
        [self.contentView addSubview:_rightLabel2];
        _rightLabel2.frame = CGRectMake(SCREEN_WIDTH-150, 30, 142, 20);
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_subTitleLabel];
        _subTitleLabel.frame = CGRectMake(15, 30, SCREEN_WIDTH-25-130, 17);
        self.titleLabel.frame = CGRectMake(15, 5, SCREEN_WIDTH-25-200, 22);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}


@end
