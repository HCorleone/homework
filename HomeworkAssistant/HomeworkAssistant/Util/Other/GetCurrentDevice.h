//
//  GetCurrentDevice.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/10.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetCurrentDevice : NSObject

//判断当前设备是否为刘海屏设备而获取适配使用的上下边距
+ (CGFloat)getTopOffset;
+ (CGFloat)getBotOffset;

@end

NS_ASSUME_NONNULL_END
