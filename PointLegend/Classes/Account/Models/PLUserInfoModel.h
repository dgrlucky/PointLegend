//
//  PLUserInfoModel.h
//  PointLegend
//
//  Created by 1dcq on 15/12/18.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "BaseModel.h"

@interface PLUserInfoModel : BaseModel
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *imgBig;
@property (nonatomic, strong) NSString *imgSmall;
@property (nonatomic, strong) NSString *nikeName;
@property (nonatomic, strong) NSString *payPasswordFlag;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *sessionId;

+ (instancetype)sharedInstance;

@end
