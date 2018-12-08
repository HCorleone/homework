//
//  AssignToObject.h
//  数据库
//
//  Created by apple on 2018/9/15.
//  Copyright © 2018年 CHF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface AssignToObject : NSObject
//把从json中得到的数组中的字典转化为具体的对象，其里面都是封装好的具体对象。
+ (NSMutableArray *)customModel:(NSString *)modelClass ToArray:(id)array;
//获取类的各个属性，存到数组中
+ (id)propertyKeysWithString:(NSString *)classStr;
//用字典为类的各个属性赋值
+ (id)reflectDataFromOtherObject:(id)dataSource andObjectStr:(NSString *)classStr;
@end
