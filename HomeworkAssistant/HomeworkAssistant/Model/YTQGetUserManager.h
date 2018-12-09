//
//  YTQGetUserManager.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/8.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssignToObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTQGetUserManager : NSObject

-(NSMutableDictionary *)getUserManager:(void(^)(NSMutableDictionary *dic))mudic;

@end

NS_ASSUME_NONNULL_END
