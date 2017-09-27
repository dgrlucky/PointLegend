//
//  PLBaseCell.m
//  PointLegend
//
//  Created by ydcq on 15/11/27.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLBaseCell.h"
#import "UIImageView+WebCache.h"

@implementation PLBaseCell

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)setType:(cellType)type
{
    _type = type;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"img"]] placeholderImage:[UIImage imageNamed:infoDic[@"img"]]];
    _titleLabel.text = infoDic[@"title"];
}

- (instancetype)initWithType:(cellType)type
{
    PLBaseCell *obj = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier:type]];
    obj.type = type;
    return obj;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25, 25)];
        [self.contentView addSubview:_headImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 0, 200, 50)];
        _titleLabel.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

+ (NSString *)cellReuseIdentifier:(cellType)type
{
    return [NSString stringWithFormat:@"cell_%d",(int)type];
}

@end
