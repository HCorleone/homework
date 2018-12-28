//
//  HttpTool.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpTool : NSObject

+ (AFHTTPSessionManager *)initializeHttpManager;

@end

NS_ASSUME_NONNULL_END
