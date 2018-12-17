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

//将所有参数排序后加密后再上传
+(NSString *)HMACSHA1:(NSString *)data;

@end

NS_ASSUME_NONNULL_END
