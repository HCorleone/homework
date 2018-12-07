//
//  CommonDefine.h
//  党建
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018年 wx. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

//tabbarheight
#define tabbarheight 48

//color
#define whitecolor [UIColor whiteColor]
#define maincolor [UIColor colorWithHexString:@"#3DC5F2"]

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


#endif /* CommonDefine_h */
