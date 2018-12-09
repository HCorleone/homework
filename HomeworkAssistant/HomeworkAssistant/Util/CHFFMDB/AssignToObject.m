//
//  AssignToObject.m
//  数据库
//
//  Created by apple on 2018/9/15.
//  Copyright © 2018年 CHF. All rights reserved.
//

#import "AssignToObject.h"

@implementation AssignToObject
+ (NSMutableArray *)customModel:(NSString *)modelClass ToArray:(id)jsonArray
{
    //存放对象的数组
    NSMutableArray * objArr = [[NSMutableArray alloc]initWithCapacity:1];
    for (int i = 0; i < [jsonArray count]; i++)
    {
        //取出json数组中的一个对象
        id jsonDic = jsonArray[i];
        //若数组中的对象不是字典就跳过，继续下一个
        if(![jsonDic isKindOfClass:[NSDictionary class]])
        {
            continue;
        }
        //创建一个传过来字符串（类名）响应的对象
        const char * modelStr = [modelClass UTF8String];
        id model = [[objc_getClass(modelStr) alloc] init];
        [model setValuesForKeysWithDictionary:jsonDic];
        //把转化完成的对象加到数组中
        [objArr addObject:model];
    }
    return objArr;
}

+ (id)propertyKeysWithString:(NSString *)classStr
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(classStr) class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc]initWithCapacity:1];
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    
    return keys;
}








@end
