//
//  CommonDefine.h
//  党建
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018年 wx. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

//用于适配x及以上的设备
#define TOP_OFFSET [GetCurrentDevice getTopOffset]
#define BOT_OFFSET [GetCurrentDevice getBotOffset]


//tabbarheight
#define tabbarheight 48

//color
#define whitecolor [UIColor whiteColor]
#define maincolor [UIColor colorWithHexString:@"#3DC5F2"]
/** 选中年级，科目，版本 */
#define ClickColor [UIColor colorWithRed:85/255.0 green:195/255.0 blue:242/255.0 alpha:1/1.0]

//screensize
#define screenWidth [[UIScreen mainScreen]bounds].size.width
#define screenHeight [[UIScreen mainScreen]bounds].size.height

//umeng appkey:5bed3ff1b465f50e1200008e
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

//Wechat appID:wxdd59bf4228be5b2d
//Wechat appSecret:e21f45c9103b92de4b64cea1fb304ab3
#import "WXApi.h"
#define WX_APPID @"wxdd59bf4228be5b2d"
#define WXAPPKEYSECRET @"e21f45c9103b92de4b64cea1fb304ab3"
#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define userDefaults(object, key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define userValue(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]

/** 上传答案-书籍基本信息 */
#define GetUpAnswerID getURL
/** 上传答案的封面图 */
#define UpLoadAnswer @"/homeworkapi/upload.s?"
/** 获取验证码 */
#define getVerificationCode oldURl
/** 上传或更新用户额外信息 */
#define upUserInform getURL

//域名
#define OldIP @"http://ecomment.tatatimes.com"
#define OnLineIP @"http://zuoyeapi.tatatimes.com"

#define getURL @"/homeworkapi/api.s?"
#define oldURl @"/tataeraapi/api.s?"

#define zuoyeURL @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?"

#define tataURL @"http://ecomment.tatatimes.com/tataeraapi/api.s?"

#endif /* CommonDefine_h */
