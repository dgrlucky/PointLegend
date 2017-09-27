//
//  PLHttpTools.m
//  PointLegend
//
//  Created by leon guo on 15/9/11.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLHttpTools.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation PLHttpTools

+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params result:(void (^)(NSDictionary *dic,NSError *error,NSURLSessionDataTask *t))result
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (![[AFNetworkActivityIndicatorManager sharedManager] isEnabled]) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    
    // 2.发送请求
    return [mgr GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (result) {
            result([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil],nil,task);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (result) {
            result(nil,error,task);
        }
    }];
}

+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params result:(void (^)(NSDictionary *dic,NSError *error,NSURLSessionDataTask *t))result
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (![[AFNetworkActivityIndicatorManager sharedManager] isEnabled]) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    
    // 2.发送请求
    return [mgr POST:url parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        if (result) {
            result([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil],nil,operation);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (result) {
            result(nil,error,operation);
        }
    }];
}

+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params imageData:(NSData *)data result:(void (^)(NSDictionary *dic,NSError *error,NSURLSessionDataTask *))result
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (![[AFNetworkActivityIndicatorManager sharedManager] isEnabled]) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    
    return [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (result) {
            result([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil],nil,task);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (result) {
            result(nil,error,task);
        }
    }];
}

@end
