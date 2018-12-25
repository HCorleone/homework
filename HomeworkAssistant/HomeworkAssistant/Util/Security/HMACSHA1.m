//
//  HMACSHA1.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "HMACSHA1.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#define HMACSHA1_KEY @"adkjffdkajkjkjnm"

@implementation HMACSHA1

//第一步：将必要参数字典与通用信息字典融合成一个字典
+ (NSDictionary *)getCommonInfoIntoDicWith:(NSDictionary *)adic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *bdic = [URLBuilder getCommonInfo];
    [dic addEntriesFromDictionary:adic];
    [dic addEntriesFromDictionary:bdic];
    return dic;
}

//第二步：将融合之后的字典排序之后拼接成一个需要加密的字符串
+ (NSString *)getSignFromCombinedDic:(NSDictionary *)dict{
    
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

//第三步：给需要加密的长字符串用HmacSHA1加密
//HmacSHA1加密
+(NSString *)dataToBeEncrypted:(NSString *)data{
    const char *cKey  = [HMACSHA1_KEY cStringUsingEncoding:NSUTF8StringEncoding];//utf-8主要为了用于中文编码
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    //将加密结果进行一次BASE64编码。
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}

//总方法：将传入的字典加入签名之后再返回一个用于上传的字典
+ (NSDictionary *)encryptDicForRequest:(NSDictionary *)dic{
    dic = [HMACSHA1 getCommonInfoIntoDicWith:dic];//融合字典
    NSString *sign = [HMACSHA1 getSignFromCombinedDic:dic];//得到需要加密的长字符串
    sign = [HMACSHA1 dataToBeEncrypted:sign];//加密长字符串
    sign = [sign stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];//防止base64编码中的加号在http传输过程中变成空格
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic addEntriesFromDictionary:dic];
    [tempDic setValue:sign forKey:@"sign"];
    return tempDic;
}

@end
