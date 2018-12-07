//
//  MD5Encrypt.m
//  YNote
//
//  Created by Liu Deqing on 11-4-25.
//  Copyright 2011 Youdao. All rights reserved.
//

#import "MD5Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Encrypt

+ (NSString*) encrypt: (NSString*) str
{
    const char* cStr =[str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString] ;
}

@end
