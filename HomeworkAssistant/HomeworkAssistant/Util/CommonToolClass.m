//
//  CommonToolClass.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "CommonToolClass.h"

@implementation CommonToolClass

+ (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)getURLFromDic:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id obj2) {
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    
    //将排序好的字典的键值逐个取出并拼接成一个长字符串(为空的参数不参与加密)
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < afterSortKeyArray.count; i++) {
        if (![valueArray[i] isEqualToString:@""]) {
            NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",afterSortKeyArray[i],valueArray[i]];
            [signArray addObject:keyValueStr];
        }
    }
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    return sign;
}

@end
