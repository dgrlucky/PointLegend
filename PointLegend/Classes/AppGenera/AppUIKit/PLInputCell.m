//
//  PLInputCell.m
//  PointLegend
//
//  Created by ydcq on 15/11/30.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLInputCell.h"

@implementation PLInputCell

- (void)setInfoDic:(NSDictionary *)infoDic
{
    [super setInfoDic:infoDic];
    _inputTX.placeholder = infoDic[@"placeholder"];
}

- (void)setType:(cellType)type
{
    [super setType:type];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self.contentView) weakContentView = self.contentView;
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakContentView.mas_left).with.offset(15);
        make.width.mas_equalTo(22);
        make.centerY.equalTo(weakContentView.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    WS(weakSelf);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImageView.mas_right).with.offset(8);
        make.top.mas_equalTo(0);
        make.bottom.equalTo(weakContentView.mas_bottom);
        make.width.mas_equalTo(55);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _inputTX = [[UITextField alloc] init];
        _inputTX.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_inputTX];
        UIFont *font = [UIFont systemFontOfSize:15];
        _inputTX.font = font;
        [_inputTX setValue:font forKeyPath:@"_placeholderLabel.font"];
        WS(weakSelf);
        __weak typeof(self.contentView) weakContentView = self.contentView;
        
        _vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_vButton setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
        [_vButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_vButton];
        [_vButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakContentView.mas_right).with.offset(0);
            make.width.mas_equalTo(80);
            make.top.equalTo(weakContentView.mas_top);
            make.centerY.equalTo(weakContentView.mas_centerY);
        }];
        
        [_inputTX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_right).with.offset(8);
            make.top.equalTo(weakContentView.mas_top);
            make.bottom.equalTo(weakContentView.mas_bottom);
            make.right.equalTo(weakSelf.vButton.mas_left).with.offset(-15);
        }];
    }
    return self;
}

@end
