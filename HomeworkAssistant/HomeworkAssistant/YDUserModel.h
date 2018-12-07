//
//  YDUserModel.h
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import <Foundation/Foundation.h>

//通用
#define kAccessToken     @"kAccessToken"
#define kUserID          @"kUserID"
#define kRefreshToken    @"kRefreshToken"

//普通字段
#define kNickName        @"kNickName"
#define kAvatarImage     @"kAvatarImage"
#define kUserDescription @"kUserDescription"
#define kGender          @"kGender"
#define kAge             @"kAge"
#define kBirthday        @"kBirthday"
#define kCity            @"kCity"
#define kCountry         @"kCountry"
#define kProvince        @"kProvince"
#define kTypeLoginFrom   @"kTypeLoginFrom"
#define kLoginType       @"kLoginType"

//163特有
#define kFrom            @"kFrom"
#define kDictpc          @"kDictpc"

//QQ
#define kExpirationDate  @"kExpirationDate"

//微信
#define kScope           @"kScope"
#define kExpires_in      @"kExpires_in"
#define kUnionid         @"kUnionid"
#define kOpenid          @"kOpenid" 

//阅读历史记录
#define kReadCountTotal  @"kReadCountTotal"
#define kReadDayTotal    @"kReadDayTotal"
#define kWordCountTotal    @"kWordCountTotal"
#define kReadTimeTotal    @"kReadTimeTotal"

typedef NS_ENUM(NSInteger, TypeLoginFrom){
    TypeLoginFromWeibo = 0,
    TypeLoginFromQQ,
    TypeLoginFromWeChat,
    TypeLoginFromNetEaseMail,
    TypeLoginFromOther,
    TypeLoginTata
};

@interface YDUserModel : NSObject

#pragma mark - 163邮箱登录返回4个字段,下面两个是163特有的字段，userid 与其他登录方式的userID相同， username 与 nickname相同
/*
 163登录返回
 {
 "DICT-PC" = "v2|urstoken||DICT||mobile||-1||1469006577189||210.12.222.134||chujunhe1234@163.com||6yn4YMOfYA0QLkLO5nHpy0wyhfkE64OA0zW0fPL6MQFRzfPLUm64PS0OMRMOYhLl50UERMUYhHkf0TZO4kGRfwuR";
 from = urstoken;
 userid = "chujunhe1234@163.com";
 username = "chujunhe1234@163.com";
 }
 */
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *dictpc;

#pragma mark - 其他登录方式的字段，这三个基本都有，只不过对应上会有些差别
@property (nonatomic, copy) NSString *accessToken; //token
@property (nonatomic, copy) NSString *userID; //用户id
@property (nonatomic, copy) NSString *refreshToken; //刷新token

#pragma mark - 微信登录特有字段
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *unionid;
@property (nonatomic, copy) NSString *openid;

#pragma mark - QQ登录特有字段
@property (nonatomic, strong) NSDate *expirationDate;  //过期时间

#pragma mark - 下面是通用字段,通用字段保存需要有userID唯一标识
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *avatarImage; //头像
@property (nonatomic, copy) NSString *userDescription; //个人介绍
@property (nonatomic, copy) NSString *gender; //性别
@property (nonatomic, copy) NSString *age; //年龄
@property (nonatomic, copy) NSString *birthday; //用户选择的生日日期，根据这个算年龄
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, assign) TypeLoginFrom typeLogin; //登录类型

#pragma mark - 手机号登录特有字段
@property (nonatomic, strong) NSString *mobile;  //过期时间
@property (nonatomic, strong) NSString *passwd;  //过期时间

@end
