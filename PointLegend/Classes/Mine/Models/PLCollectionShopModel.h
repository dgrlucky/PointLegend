//
//  CollectionShopModel.h
//  Legend
//
//  Created by wuzhantu on 15/8/4.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "BaseModel.h"

@interface PLCollectionShopModel : BaseModel
@property(nonatomic, strong)NSNumber *shopId;
@property(nonatomic, strong)NSString *shopName;
@property(nonatomic, strong)NSString *shopLogoUrl;
@property(nonatomic, strong)NSNumber *starLevelGrade;
@property(nonatomic, strong)NSNumber *serviceGrade;
@property(nonatomic, strong)NSNumber *envGrade;
@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSString *telephone;
@property(nonatomic, strong)NSString *shopInfrastructure;
@property(nonatomic, strong)NSNumber *distance;
@property(nonatomic, strong)NSNumber *soldNumber;
@property(nonatomic, strong)NSNumber *redPacketFlag;
@property(nonatomic, strong)NSNumber *cashCouponFlag;
@property(nonatomic, strong)NSNumber *couponFlag;
@property(nonatomic, strong)NSNumber *timedDiscountFlag;
@property(nonatomic, strong)NSString *favoriteUrl;
@property(nonatomic, strong)NSNumber *shopStatus;
@end
