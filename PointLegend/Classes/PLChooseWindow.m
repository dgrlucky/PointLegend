//
//  PLChooseWindow.m
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLChooseWindow.h"

NSInteger selectedIndex = 0;

#define chooseViewHeight (20*2+38*(((_itemArray.count+1)%4==0)?((_itemArray.count+1)/4):((_itemArray.count+1)/4+1))-10)

@implementation PLChooseWindow
{
    UIView *chooseView;
    
    NSInteger index;
}

void setSelectedIndexToZero()
{
    selectedIndex = 0;
}

- (void)dealloc
{
    NSLog(@"%s ",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)]) {
        self.windowLevel = UIWindowLevelAlert;
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.alpha = 0;
        
        index = selectedIndex;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setItemArray:(NSArray *)itemArray
{
    _itemArray = itemArray;
    chooseView = [[UIView alloc] init];
    chooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, chooseViewHeight);
    chooseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:chooseView];
    
    CGFloat width = (SCREEN_WIDTH-15*2-10*3)/4;
    CGFloat height = 28;
    NSMutableArray *titleArray = [itemArray mutableCopy];
    [titleArray insertObject:@{@"rewardType":@"0",@"rewardTypeName":@"全部"} atIndex:0];
    titleArray = [[titleArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
        int index1 = [obj1[@"rewardType"] intValue];
        int index2 = [obj2[@"rewardType"] intValue];
        if (index1 > index2) {
            return NSOrderedDescending;
        }
        else if (index1 < index2) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }] mutableCopy];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15+(width+10)*(i%4), 20+(i/4)*(28+10), width, height);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        button.clipsToBounds = YES;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.borderWidth = 0.3;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundImage:imageWithColor([UIColor colorWithRed:251/255.0 green:66/255.0 blue:66/255.0 alpha:1]) forState:UIControlStateSelected];
        button.tag = 100+i;
        button.layer.cornerRadius = 2.5;
        [button setTitle:titleArray[i][@"rewardTypeName"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [chooseView addSubview:button];
    }
}

- (void)show
{
    [((UIButton *)[chooseView viewWithTag:100+index]) setSelected:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    int type = 0;
    for (UIView *v in chooseView.subviews) {
        if ([v isKindOfClass:[UIButton class]] && ((UIButton *)v).isSelected) {
            NSString *title = ((UIButton *)v).titleLabel.text;
            if ([title isEqualToString:@"全部"]) {
                type = 0;
            }
            else
            {
                for (NSDictionary *dic in _itemArray) {
                    if ([dic[@"rewardTypeName"] isEqualToString:title]) {
                        type = [dic[@"rewardType"] intValue];
                    }
                }
            }
        }
    }
    
    if (index != selectedIndex) {
        selectedIndex = index;
        if (_delegate && [_delegate respondsToSelector:@selector(shouldRefresh:withType:)]) {
            [_delegate performSelector:@selector(shouldRefresh:withType:) withObject:@YES withObject:@(type)];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldRefresh:withType:)]) {
            [_delegate performSelector:@selector(shouldRefresh:withType:) withObject:@NO withObject:nil];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)buttonClicked:(UIButton *)button
{
    index = button.tag-100;
    for (UIView * v in chooseView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [((UIButton *)v) setSelected:NO];
        }
    }
    button.selected = YES;
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.3];
}

@end
