//
//  BaseModel.h
//  WZTMovie
//
//  Created by 吴展图 on 13-9-3.
//  Copyright (c) 2013年 ios5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initContentwith:(NSDictionary *)dic;
- (void)dicToObject:(NSDictionary *)dic;
- (NSDictionary *)dicObjectAtt:(NSDictionary *)jsonDic;
@end
