//
//  TTUserModel.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TTUserModel : NSObject

//微信登陆
@property (nonatomic, copy) NSString *accessToken; //token
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *refreshToken; //刷新token
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *scope;

@property (nonatomic, copy) NSString *userID; //用户id
@property (nonatomic, copy) NSString *unionid;

//基本信息
@property (nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *grade;//年级

@end
