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

//HmacSHA1加密
+(NSString *)dataToBeEncrypted:(NSString *)data{
    const char *cKey  = [HMACSHA1_KEY cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
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

@end
