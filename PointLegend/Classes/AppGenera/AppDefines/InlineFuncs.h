//
//  InlineFuncs.h
//  PointLegend
//
//  Created by ydcq on 15/9/10.
//  Copyright (c) 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#ifndef PointLegend_InlineFuncs_h
#define PointLegend_InlineFuncs_h

#import <CommonCrypto/CommonDigest.h>

static inline UIImage* imageWithColor(UIColor *clr)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [clr CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

static inline NSString * md5(NSString *str)
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, str.length, digest );
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#endif
