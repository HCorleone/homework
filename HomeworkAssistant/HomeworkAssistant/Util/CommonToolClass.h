//
//  CommonToolClass.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5.h"//MD5加密
#import "HMACSHA1.h"//HMACSHA1加密
#import "URLBuilder.h"//接口地址
#import "GetCurrentDevice.h"//判断当前设备是否为x及以上从而获得适配的上下边距
#import "UIColor+ColorChange.h"//hexstring转颜色
#import "UIView+YZCategory.h"//直接设置控件布局
#import "HttpTool.h"//初始化网络请求的manager
#import "DBManager.h"//管理浏览历史记录数据库
#import "TextCheckTool.h"//文字校验工具

NS_ASSUME_NONNULL_BEGIN

@interface CommonToolClass : NSObject

+ (NSString *)currentTimeStr;//获取时间戳，精确到毫秒

+ (NSString *)getURLFromDic:(NSDictionary *)dict;//取字典里的键值并拼接成长字符串

@end

NS_ASSUME_NONNULL_END
