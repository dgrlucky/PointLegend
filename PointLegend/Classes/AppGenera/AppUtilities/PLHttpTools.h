//
//  PLHttpTools.h
//  PointLegend
//
//  Created by leon guo on 15/9/11.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLHttpTools : NSObject

/**
 *  http get方法封装
 *
 *  @param url     要请求的url
 *  @param params  参数
 *  @param success 请求成功执行的block
 *  @param failure 请求失败执行的block
 */
+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params result:(void (^)(NSDictionary *dic,NSError *error,NSURLSessionDataTask *task))result;

/**
 *  http post方法封装
 *
 *  @param url     要请求的url
 *  @param params  参数
 *  @param success 请求成功执行的block
 *  @param failure 请求失败执行的block
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params result:(void (^)(NSDictionary *dic,NSError *error,NSURLSessionDataTask *task))result;
/**
 *  上传头像
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params imageData:(NSData *)data result:(void (^)(NSDictionary *dic,NSError *error,NSURLSessionDataTask *task))result;

@end
