//
//  PLGuessCell.m
//  PointLegend
//
//  Created by 1dcq on 15/12/7.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLGuessCell.h"

@implementation PLGuessCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel
{
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 60)];
    [logoImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"legend_default"]];
//    logoImgView.backgroundColor = [UIColor grayColor];
    [self addSubview:logoImgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoImgView.right+10, logoImgView.top, SCREEN_WIDTH - 100 - logoImgView.right, 20)];
    titleLabel.text = @"小肥羊连锁餐厅";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    
    
    double score = 4.5;
    NSInteger distace = 5;
    NSInteger starWidth = 12;
    UIView *starBgVIew = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, 4*distace+5*starWidth, 20)];
    [self addSubview:starBgVIew];
    
    for (int i=0; i<5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(distace+starWidth), 5, starWidth, starWidth)];
        if (i< score-1) {
            imageView.image = [UIImage imageNamed:@"rb_bg_normal"];
        }else{
            imageView.image = [UIImage imageNamed:@"rb_bg_select"];
        }
        
        [starBgVIew addSubview:imageView];
    }
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(starBgVIew.right+5, starBgVIew.top+2, 20, 20)];
    numLabel.text = @"4.0";
    numLabel.font = [UIFont systemFontOfSize:13];
    numLabel.textColor = [UIColor orangeColor];
    [self addSubview:numLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, starBgVIew.bottom+2, 40, 20)];
    typeLabel.text = @"火锅";
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.textColor = [UIColor grayColor];
    [self addSubview:typeLabel];
    
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, titleLabel.top, 15, 15)];
        imageView.image = [UIImage imageNamed:@"停车场"];
        [self addSubview:imageView];
    }
    
    [self changeNumberText:@"羊肉特价20元"];
}

- (void)changeNumberText:(NSString *)string
{
    
    
}

-(NSArray *)getAllNumberWithString:(NSString *)str{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    while (str != nil && ![str isKindOfClass:[NSNull class]] && ![str isEqualToString:@""]) {
        
        NSScanner *scanner = [NSScanner scannerWithString:str];
        
//        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
        int number;
        [scanner scanInt:&number];
        NSString *st = [NSString stringWithFormat:@"%d",number];
        
        NSArray *ary = [str componentsSeparatedByString:st];
        str = [ary lastObject];
        
        BOOL isallChar = NO;
        
        for (int i=0; i<str.length; i++) {
            char t = [str characterAtIndex:i];
            if (t >='0' && t<='9') {
                isallChar = NO;
                break;
            }
            else{
                isallChar = YES;
            }
        }
        
        [array addObject:st];
        
        if (isallChar) {
            break;
        }
        
    }
    
    return array;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
