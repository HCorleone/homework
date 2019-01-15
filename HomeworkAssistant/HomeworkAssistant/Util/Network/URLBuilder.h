//
//  URLBuilder.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLBuilder : NSObject

//作业接口
+ (NSString *)getURLForRecommend;//推荐书单

+ (NSString *)getURLForMyCollections;//我的收藏

+ (NSString *)getURLForAnswerSearch;//书籍搜索

+ (NSString *)getURLForAnswerDetail;//获取答案详情

+ (NSString *)getURLForCopyUserLike;//将他人的书单导入自己的书单

+ (NSString *)getURLForUserLike;//收藏书籍

+ (NSString *)getURLForDelUserLike;//删除收藏的书籍

+ (NSString *)getURLForSearchHotWords;//获取搜索热词

+ (NSString *)getURLForUploadAnswerBaseInfo;//上传书籍基本信息

+ (NSString *)getURLForUploadAnswerPic;//上传答案图片

+ (NSString *)getURLForUploadFeedBack;//反馈接口

+ (NSString *)getURLForShareBook;//分享书籍接口

//作文接口
+ (NSString *)getURLForArticle;//作文搜索

+ (NSString *)getURLForArticleDetail;//作文详情

//用户信息管理接口
+ (NSString *)getURLForGetUserExt;//获取用户额外信息

+ (NSString *)getURLForUpsertUserExt;//上传或更新用户信息

//登陆接口
+ (NSString *)getURLForLogin;//登陆

+ (NSString *)getURLForSignup;//注册

+ (NSString *)getURLForFindBackPassword;//找回密码

+ (NSString *)getURLForVerificationCode;//验证码

//用户通用信息
+ (NSDictionary *)getCommonInfo;

@end

NS_ASSUME_NONNULL_END
