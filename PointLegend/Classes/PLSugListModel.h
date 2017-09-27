//
//  PLSugListModel.h
//  Legend
//
//  Created by ydcq on 15/12/4.
//  Copyright © 2015年 frocky. All rights reserved.
//


@interface PLSugListModel : NSObject

@property (nonatomic, assign) long long recommendedUserId;

@property (nonatomic, assign) NSInteger recommendedUserType;

@property (nonatomic, copy) NSString *recommendedUserName;

@property (nonatomic, copy) NSString *recommendedUserTel;

@property (nonatomic, assign) NSInteger recommendedWay;

@property (nonatomic, copy) NSString *recommendedTime;

@end
