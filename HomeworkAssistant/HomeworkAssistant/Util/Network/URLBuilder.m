//
//  URLBuilder.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>

#import "URLBuilder.h"

@implementation URLBuilder

#pragma mark - 作业接口
+ (NSString *)getURLForRecommend {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYRecHandler";
//    URLString = [URLString stringByAppendingString:@"&"];
//    URLString = [URLString stringByAppendingString:[self getCommonUrlInfo]];
    return URLString;
}

+ (NSString *)getURLForMyCollections {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYListUserLikeHandler";
    
    return URLString;
}

+ (NSString *)getURLForAnswerSearch {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYSearchAnswerHandler";

    return URLString;
}

+ (NSString *)getURLForUserLike {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYUserLikeHandler";
    
    return URLString;
}

+ (NSString *)getURLForDelUserLike {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYDelUserLikeHandler";
    
    return URLString;
}

+ (NSString *)getURLForSearchHotWords {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYSearchHotWordsHandler";
    
    return URLString;
}

+ (NSString *)getURLForAnswerDetail {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYAnswerDetailHandler";
    
    return URLString;
}

+ (NSString *)getURLForUploadAnswerBaseInfo {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYUploadAnswerBaseInfoHandler";
    
    return URLString;
}

+ (NSString *)getURLForUploadAnswerPic {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/upload.s?h=ZYUploadAnswerPicHandler";
    
    return URLString;
}

+ (NSString *)getURLForUploadFeedBack {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/upload.s?h=ZYFeedBackHander";
    
    return URLString;
}

+ (NSString *)getURLForCopyUserLike {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYCopyUserLikeHandler";
    
    return URLString;
}

+ (NSString *)getURLForShareBook {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/h5.s?h=ZYBookShareXiaZaiQiHandler";
    
    return URLString;
}

#pragma mark - 作文接口
+ (NSString *)getURLForArticle {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYSearchArticleHandler";
    
    return URLString;
}

+ (NSString *)getURLForArticleDetail {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYArticleDetailHandler";
    
    return URLString;
}

#pragma mark - 用户信息管理
+ (NSString *)getURLForGetUserExt {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYGetUserExtHander";
    
    return URLString;
}

+ (NSString *)getURLForUpsertUserExt {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYUpsertUserExtHander";
    
    return URLString;
}

#pragma mark - 用户登录
+ (NSString *)getURLForLogin { //登录
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/tataeraapi/api.s?h=LoginTataUserHandler";
    
    return URLString;
}

+ (NSString *)getURLForSignup { //注册
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/tataeraapi/api.s?h=RegUserHandler";
    
    return URLString;
}

+ (NSString *)getURLForFindBackPassword { //找回密码
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/tataeraapi/api.s?h=UpdateUserPasswdHandler";
    
    return URLString;
}

+ (NSString *)getURLForVerificationCode { //验证码
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/tataeraapi/api.s?h=SendValidCodeUpdateHandler";
    
    return URLString;
}

#pragma mark - 通用信息
+ (NSDictionary *)getCommonInfo {
    NSDictionary *dict = [NSDictionary dictionary];
    dict = @{
             @"pkn":@"com.tataera.downloadhomework",//包名，与后台协商
             @"av":@"1.0.1",//app版本号
             @"agent":@"1",//防代理抓包
             @"channel":@"appstore",//安装渠道
             @"cn":[URLBuilder getOperatorInfomation],//运营商
             @"ts":[CommonToolClass currentTimeStr],//时间戳
//             @"wifi":[URLBuilder getWifiSSID],//wifi
             @"iso":[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],//语言
             @"uuid":[[UIDevice currentDevice].identifierForVendor UUIDString],//和应用和设备有关的identifierForVendor
             @"dn":[URLBuilder getDeviceModel],//设备名称
             @"sv":[[UIDevice currentDevice] systemVersion],//ios系统版本
             };
    return dict;
}

//IOS设备型号
+ (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

//获取wifi
+ (NSString *)getWifiSSID {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    return [dctySSID objectForKey:@"SSID"];
}

// 获取运营商信息
+ (NSString *)getOperatorInfomation {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    //NSLog(@"info = %@", info);
    CTCarrier *carrier = [info subscriberCellularProvider];
    //NSLog(@"carrier = %@", carrier);
    if (carrier == nil) {
        return @"不能识别";
    }
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil) {
        return @"不能识别";
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        return @"移动运营商";
    } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
        return @"联通运营商";
    } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
        return @"电信运营商";
    } else if ([code isEqualToString:@"20"]) {
        return @"铁通运营商";
    }
    return @"不能识别";
}

//系统版本号
+ (NSString *)getSystemInformation {
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return [NSString stringWithFormat:@"%@%@", systemName, systemVersion];
}

@end
