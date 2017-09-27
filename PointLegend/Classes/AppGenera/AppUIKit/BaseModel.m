//
//  BaseModel.m
//  WZTMovie
//
//  Created by 吴展图 on 13-9-3.
//  Copyright (c) 2013年 ios5. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initContentwith:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self dicToObject:dic];
    }
    return self;
}

- (SEL)stringTosel:(NSString *)modelKey
{
    //首字母大写
    //NSString *modelkey = modelKey.capitalizedString;
    NSString *first = [[modelKey substringToIndex:1]uppercaseString];
    NSString *end = [modelKey substringFromIndex:1];
    NSString *methestr = [NSString stringWithFormat:@"set%@%@:",first,end];
    return NSSelectorFromString(methestr);
}
- (NSDictionary *)dicObjectAtt:(NSDictionary *)jsonDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:jsonDic.count];
    for (id key in jsonDic) {
        //object与key同名，这是为了方便才用，当子类没有覆写此方法时调用
        [dic setObject:key forKey:key];
    }
    
    return dic;
}
- (void)dicToObject:(NSDictionary *)dic
{
    for (id key in dic) {
        if ([key isEqualToString:@"imgSmall"]) {
            NSLog(@"111");
        }
        //如果model写了对象名，那就返回该对象名称，如@"type":@"typeId"
        id modelKey = [[self dicObjectAtt:dic]objectForKey:key];
        
        if (modelKey) {
            SEL action = [self stringTosel:modelKey];
            if ([self respondsToSelector:action]) {
                id value = [dic objectForKey:key];
                if ((NSNull *)value == [NSNull null]) {
                    continue;
                }
                else
                {
                    //调用该方法存入数据，映射关系
                    [self performSelector:action withObject:value];
                }
            }
        }
    }
    
}
@end
