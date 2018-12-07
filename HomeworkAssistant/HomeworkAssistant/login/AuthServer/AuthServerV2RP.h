//
//  AuthServerV2RP.h
//  YNote
//
//  Created by Liu Deqing on 13-1-6.
//  Copyright (c) 2013年 Youdao. All rights reserved.
//

// 获取临时index接口
@interface AuthServerV2RP : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;

- (NSError *)authServerRP:(NSString *)tp withAL:(NSString *)al;
+ (NSString *)authServerLoginURL:(BOOL)isHttps;
+ (NSString *)authServerPollURL;
@end
