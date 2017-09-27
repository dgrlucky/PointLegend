//
//  PLSugListModel.m
//  Legend
//
//  Created by ydcq on 15/12/4.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLSugListModel.h"

@implementation PLSugListModel

- (instancetype)init
{
    if (self = [super init]) {
        _recommendedUserName = _recommendedUserTel = @"";
    }
    return self;
}

@end
