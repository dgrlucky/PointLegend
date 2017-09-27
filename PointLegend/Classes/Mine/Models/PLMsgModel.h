//
//  PLMsgModel.h
//  PointLegend
//
//  Created by ydcq on 15/12/21.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface PLMsgModel : BaseModel

@property (nonatomic, strong) NSNumber *messageId;

@property (nonatomic, strong) NSNumber *msgType;

@property (nonatomic, copy) NSString *msgTitle;

@property (nonatomic, copy) NSString *msgImg;

@property (nonatomic, copy) NSString *msgDesc;

@property (nonatomic, copy) NSString *pubTime;

@property (nonatomic, strong) NSNumber *shopId;

@property (nonatomic, copy) NSString *shopName;

@end
