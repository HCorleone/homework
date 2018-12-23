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

//作文接口
+ (NSString *)getURLForArticle;

//登陆接口
+ (NSString *)getURLForLogin;//登陆

+ (NSString *)getURLForSignup;//注册

+ (NSString *)getURLForFindBackPassword;//找回密码

+ (NSString *)getURLForVerificationCode;//验证码

@end

NS_ASSUME_NONNULL_END
