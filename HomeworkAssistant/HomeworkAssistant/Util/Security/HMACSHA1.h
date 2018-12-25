//
//  HMACSHA1.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMACSHA1 : NSObject

/*
 这个类是用于进行网络请求的时候加密所要传输的信息
*/


//将所有参数排序后加密后再上传
+(NSString *)dataToBeEncrypted:(NSString *)data;

+ (NSDictionary *)encryptDicForRequest:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
