//
//  Interfaces.h
//  PointLegend
//
//  Created by ydcq on 15/11/27.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#ifndef Interfaces_h
#define Interfaces_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//--------------------网络---------------------------
//测试环境 192.168.1.174:9101   演示环境 192.168.1.147:7080  开发环境 192.168.1.121:9101  预发环境 192.168.1.165:8080  线上环境 appserver.1dian.la

#define ceshihtml  1
#define BaseUrl  ceshihtml ? @"http://192.168.1.121:9101/appServer/" : @"http://192.168.1.121:9101/appServer/"
//拼接一个url
#define API(name) [BaseUrl stringByAppendingString:(name)]

#define BaseHtmlUrl @"http://192.168.1.144:6003/"

//接口列表

typedef NS_ENUM(NSInteger, PLInterface)
{
    /*=========用户类接口=========*/
    PLInterface_Login,       //登录
    PLInterface_GetBaseInfo, //基本信息
    PLInterface_Register,    //注册
    PLInterface_GetVeriCode,  //获取验证码
    PLInterface_checkVeriCode,//检测验证码
    PLInterface_GiveFeedback, //反馈
    PLInterface_uploadFile,  //上传文件
    PLInterface_Rewardsum,  //奖励余额
    PLInterface_Allrewards, //奖励列表
    PLInterface_GetMyRewardType,//奖励类型
    PLInterface_getMyRefUserList,//推荐列表
    
    /*=========商铺类接口=========*/
    PLInterface_GetAllCitis, //城市列表
    PLInterface_GetCityInfo, //城市信息
    PLInterface_GetDistricts,//区县列表
    PLInterface_GetCitis,    //省内城市列表
    PLInterface_GetAllProvinces,//所有省份
    PLInterface_GetTowns,//街道列表
    PLInterface_GetMyFavoriteShop, //收藏店铺
    PLInterface_GetMyFavoriteGoods, //收藏商品
    
    /*=========消息类接口=========*/
    PLInterface_GetMsg,       //消息
    PLInterface_GetUnreadMsgNumber, //未读消息数
    PLInterface_getMsgDetail, //消息详情
    
    /*=========支付类接口=========*/
    PLInterface_GetAccountMoney,
};

static NSString *fullInterfaceName(PLInterface interface)
{
    switch (interface) {
        case PLInterface_Login: {
            return API(@"interface/user/login");
            break;
        }
        case PLInterface_GetBaseInfo: {
            return API(@"interface/user/getBaseInfo");
            break;
        }
        case PLInterface_Register: {
            return API(@"interface/user/register");
            break;
        }
        case PLInterface_GetVeriCode: {
            return API(@"interface/common/getVeriCode");
            break;
        }
        case PLInterface_checkVeriCode: {
            return API(@"interface/common/checkVeriCode");
            break;
        }
        case PLInterface_GiveFeedback: {
            return API(@"interface/commonconf/giveFeedback");
            break;
        }
        case PLInterface_uploadFile: {
            return API(@"interface/user/uploadFile");
            break;
        }
        case PLInterface_GetAllCitis: {
            return API(@"interface/home/getAllCitis");
            break;
        }
        case PLInterface_GetCityInfo: {
            return API(@"interface/home/GetCityInfo");
            break;
        }
        case PLInterface_GetDistricts: {
            return API(@"interface/home/GetDistricts");
            break;
        }
        case PLInterface_GetCitis: {
            return API(@"interface/home/GetCitis");
            break;
        }
        case PLInterface_GetAllProvinces: {
            return API(@"interface/home/GetAllProvinces");
            break;
        }
        case PLInterface_GetTowns: {
            return API(@"interface/home/GetTowns");
            break;
        }
        case PLInterface_Rewardsum: {
            return API(@"interface/user/rewardsum");
            break;
        }
        case PLInterface_Allrewards: {
            return API(@"interface/user/allrewards");
            break;
        }
        case PLInterface_GetMyRewardType: {
            return API(@"interface/user/getMyRewardType");
            break;
        }
        case PLInterface_getMyRefUserList: {
            return API(@"interface/user/getMyRefUserList");
            break;
        }
        case PLInterface_GetMsg: {
            return API(@"interface/msg/getMsg");
            break;
        }
        case PLInterface_GetUnreadMsgNumber: {
            return API(@"interface/msg/getUnreadMsgNumber");
            break;
        }
        case PLInterface_GetAccountMoney: {
            return API(@"interface/user/getAccountMoney");
            break;
        }
        case PLInterface_getMsgDetail: {
            return API(@"interface/msg/getMsgDetail");
            break;
        }
        case PLInterface_GetMyFavoriteShop: {
            return API(@"interface/user/getMyFavoriteShop");
            break;
        }
        case PLInterface_GetMyFavoriteGoods: {
            return API(@"interface/user/getMyFavoriteGoods");
            break;
        }
        default: {
            break;
        }
    }
    return nil;
}

#endif /* Interfaces_h */
