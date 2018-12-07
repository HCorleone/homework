//
//  AuthServer.h
//  YoudaoDict
//
//  Created by Miaowei Wu on 13-3-19.
//  Copyright (c) 2013年 Netease Youdao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthServer : NSObject
DECLARE_SHARED_INSTANCE(AuthServer)
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;
- (id)loginWithUserName:(NSString *)userName PassWord:(NSString *)password error:(NSError **)error;
- (BOOL)autoLogin;
- (NSString *)loginURLWithTp:(NSString *)tp;
- (BOOL)requestUserInfoAndCookie;
- (NSError *)loginURSSucessWithUserInfo:(NSDictionary *)userInfo;
- (void)logout;
- (void)setLoginCookie;
- (NSString *)getPciForLoginInSafari;
- (NSString *)formLoginUrlForSafariWithPci:(NSString *)pci andUrl:(NSString *)url;
@end
