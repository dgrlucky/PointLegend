//
//  CollectionGoodsModel.h
//  Legend
//
//  Created by wuzhantu on 15/8/4.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "BaseModel.h"

@interface PLCollectionGoodsModel : BaseModel
@property(nonatomic, strong)NSNumber *shopId;
@property(nonatomic, strong)NSNumber *goodsId;
@property(nonatomic, strong)NSString *goodsName;
@property(nonatomic, strong)NSString *goodsLogo;
@property(nonatomic, strong)NSString *favoriteUrl;
@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSNumber *soldNumber;
@property(nonatomic, strong)NSNumber *zanNumber;
@property(nonatomic, strong)NSNumber *standardPrice;
@property(nonatomic, strong)NSString *unit;
@property(nonatomic, strong)NSNumber *goodsStatus; //是否下架
@property(nonatomic, strong)NSNumber *distance;
@property(nonatomic, strong)NSNumber *bizType;//收藏类型 1 商品 2 商品族
@end
