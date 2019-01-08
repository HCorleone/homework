//
//  URLBuilder.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

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
//    NSString *URLString = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?h=ZYSearchAnswerHandler";
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
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYUploadAnswerPicHandler";
    
    return URLString;
}

+ (NSString *)getURLForUploadFeedBack {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYFeedBackHander";
    
    return URLString;
}

+ (NSString *)getURLForCopyUserLike {
    NSString *URLString = @"https://zuoyeapi.shengxueweilai.com/homeworkapi/api.s?h=ZYCopyUserLikeHandler";
    
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
             @"pkn":@"com.enjoytime.palmhomework"
             };
    return dict;
}
@end
