//
//  PLSearchBar.m
//  PointLegend
//
//  Created by leon guo on 15/9/14.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLSearchBar.h"

@implementation PLSearchBar



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode=UITextFieldViewModeAlways;
        self.textAlignment=NSTextAlignmentLeft;
        self.keyboardType=UIKeyboardAppearanceDefault;
        self.returnKeyType =UIReturnKeySearch;
        
        //加上左侧放大镜
        UIImageView *searchIco=[[UIImageView alloc] init];
        searchIco.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        searchIco.image=[UIImage imageNamed:@"searchbar_icon"];
        searchIco.width=30;
        searchIco.height=30;
        searchIco.contentMode=UIViewContentModeCenter;
        self.leftView=searchIco;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}


+ (instancetype)searchBar:(NSString *)placeholder withBackgroundImageName:(NSString *)imageName
{
    PLSearchBar *searchBar=[[self alloc]init];
    searchBar.placeholder=placeholder;
    searchBar.background=[UIImage imageNamed:imageName];
    return searchBar;
}

@end
