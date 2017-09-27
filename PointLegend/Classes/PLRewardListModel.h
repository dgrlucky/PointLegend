//
//  RewardListModel.h
//  Legend
//
//  Created by ydcq on 15/12/4.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLRewardListModel : NSObject

@property (nonatomic, assign) CGFloat rewardNum;

@property (nonatomic, assign) NSInteger rewardType;

@property (nonatomic, copy) NSString *settleTime;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *orderDesc;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
