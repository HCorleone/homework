//
//  AuthServer.m
//  YoudaoDict
//
//  Created by Miaowei Wu on 13-3-19.
//  Copyright (c) 2013年 Netease Youdao. All rights reserved.
//

#import "AuthServer.h"
#import "AuthServerV2RP.h"
#import "RSAEncrypt.h"
#import "NSData+Additions.h"
#import "JSONKit.h"
#import "MD5Encrypt.h"
#import "Constants.h"
#import "YDUserManager.h"
#import "YDUserModel.h"

@interface AuthServer() {}

@property (nonatomic, strong) AuthServerV2RP *authServerV2;

@end

@implementation AuthServer
IMPLEMENT_SHARED_INSTANCE(AuthServer)

- (id)loginWithUserName:(NSString *)userName PassWord:(NSString *)password error:(NSError *__autoreleasing *)error {
    self.userName = userName;
    self.password = [MD5Encrypt encrypt:password];
    return [self loginURS];
}

// 用PC换取DICT_SESS
//- (BOOL)autoLogin {
//    NSMutableString * cqURL = [NSMutableString new];
//    [cqURL appendString:@"http://"];
//    [cqURL appendString:AUTH_SERVER_HOST];
//    [cqURL appendFormat:@"/%@", AUTH_LOGIN_PATH];
//    [cqURL appendFormat:@"co/cq?cf=7&product=%@", PRODUCT];
//    [cqURL appendString:@"&um=true"];
//
//    DictSettings * settings = [DictSettings sharedInstance];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:cqURL]];
//    request.HTTPMethod = @"POST";
//    [request setValue:settings.authServerPC
//   forHTTPHeaderField:@"DICT-PC"];
//    NSError *error;
//    NSHTTPURLResponse *response;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
//    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *result = [responseString objectFromJSONString];
//    
//    if (result == nil) {
//        return YES; // 没网，假设登陆成功了
//    }
//    BOOL login = NO;
//    if ([[result objectForKey:@"login"] isKindOfClass:[NSNumber class]]) {
//        login = [[result objectForKey:@"login"] boolValue];
//    }
//    if (!login) {
//        return NO;
//    }
//    [self loginURSSucessWithUserInfo:result];
//    [self performSelectorInBackground:@selector(saveCookie) withObject:nil];
//    return YES;
//}

- (void)saveCookie {
    NSHTTPCookie *cookie = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        if ([[cookie name] isEqualToString:@"DICT_LOGIN"]) {
            [self saveCookie:cookie toKey:COOKIE_DICT_LOGIN_KEY];
        } else if ([[cookie name] isEqualToString:@"DICT_SESS"]) {
            [self saveCookie:cookie toKey:COOKIE_DICT_SESS_KEY];
        }
    }
}

- (void)saveCookie:(NSHTTPCookie *)cookie toKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[cookie value] forKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_VALUE]];
    [defaults setObject:[cookie domain] forKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_DOMAIN]];
    [defaults setObject:[cookie path] forKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_PATH]];
    [defaults setObject:[NSString stringWithFormat:@"%d", [cookie version]] forKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_VERSION]];
    [defaults synchronize];
}

- (void)clearCookieForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_VALUE]];
    [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_DOMAIN]];
    [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_PATH]];
    [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_VERSION]];
    [defaults synchronize];
}

- (void)setLoginCookie {
    NSHTTPCookie *cookie1 = [self cookieByKey:COOKIE_DICT_LOGIN_KEY withName:@"DICT_LOGIN"];
    NSHTTPCookie *cookie2 = [self cookieByKey:COOKIE_DICT_SESS_KEY withName:@"DICT_SESS"];
    if (cookie1 == nil || cookie2 == nil) {
        return;
    }
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage setCookie:cookie1];
    [storage setCookie:cookie2];
}

- (NSHTTPCookie *)cookieByKey:(NSString *)key withName:(NSString *)name {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_VALUE]];
    if (value == nil || [value length] == 0) {
        return nil;
    }
    NSString *domain = [defaults stringForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_DOMAIN]];
    NSString *path = [defaults stringForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_PATH]];
    NSString *version = [defaults stringForKey:[NSString stringWithFormat:@"%@%@", key, COOKIE_VERSION]];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:domain forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:path forKey:NSHTTPCookiePath];
    [cookieProperties setObject:version forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
    return cookie;
}

#pragma mark third login
- (BOOL)getPciWithTp:(NSString *)tp {
    if (self.authServerV2 == nil) {
        self.authServerV2 = [[AuthServerV2RP alloc] init];
    }
    [self.authServerV2 authServerRP:tp withAL:nil];
    if ([self.authServerV2.userInfo objectForKey:kAuthServerPCI] && [self.authServerV2.userInfo objectForKey:kAuthServerPC]) {
        return YES;
    }
    return NO;
}

- (NSString *)loginURLWithTp:(NSString *)tp {
    if (![self getPciWithTp:tp]) {
        return nil;
    }
    NSMutableString * url = [NSMutableString new];
    [url appendString:[AuthServerV2RP authServerLoginURL:NO]];
    [url appendFormat:@"?app=mobile"];
    [url appendFormat:@"&product=%@", PRODUCT];
    [url appendFormat:@"&tp=%@", tp];
    [url appendFormat:@"&cf=7"];
    [url appendFormat:@"&pci=%@", [self.authServerV2.userInfo objectForKey:kAuthServerPCI]];
    [url appendString:@"&um=true"];
    return [NSString stringWithString:url];
}

//- (BOOL)requestUserInfoAndCookie {
//    NSMutableString * url = [NSMutableString new];
//    [url appendString:[AuthServerV2RP authServerPollURL]];
//    [url appendFormat:@"?product=%@", PRODUCT];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    [request setValue:[self.authServerV2.userInfo objectForKey:kAuthServerPC] forHTTPHeaderField:@"pc"];
//    NSError *error;
//    NSHTTPURLResponse *response;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
//    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary *result = [responseString objectFromJSONString];
//    
//    BOOL login = (BOOL)[result valueForKey:@"login"];
//    if (!login) {
//        return NO;
//    }
//    if ([result valueForKey:@"from"]) {
//        NSString *from = [result valueForKey:@"from"];
//        if ([from isEqualToString:@"tsina"] || [from isEqualToString:@"tsina-normal"]) {
//            [[DictStatistics sharedInstance]logLoginDoneEventFrom:@"sina"];
//        } else if ([from isEqualToString:@"qq"] || [from isEqualToString:@"qq-normal"] || [from isEqualToString:@"cqq"] || [from isEqualToString:@"cqq-normal"]) {
//            [[DictStatistics sharedInstance]logLoginDoneEventFrom:@"qq"];
//        }
//    }
//    // cq接口请求用户信息和DICT_SESS
//    NSMutableString * cqURL = [NSMutableString new];
//    [cqURL appendString:@"http://"];
//    [cqURL appendString:AUTH_SERVER_HOST];
//    [cqURL appendFormat:@"/%@", AUTH_LOGIN_PATH];
//    [cqURL appendFormat:@"co/cq?product=%@", PRODUCT];
//    [cqURL appendString:@"&um=true"];
//    NSMutableURLRequest *sessionRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:cqURL]];
//    for (NSString *key in [result allKeys]) {
//        if ([key isEqualToString:[NSString stringWithFormat:@"%@-PC", PRODUCT]]) {
//            [sessionRequest setValue:[result valueForKey:key] forHTTPHeaderField:key];
//        }
//    }
//    NSError *sessionError;
//    NSHTTPURLResponse *sessionResponse;
//    NSData *sessionData = [NSURLConnection sendSynchronousRequest:sessionRequest
//                                                returningResponse:&sessionResponse
//                                                            error:&sessionError];
//    NSString *sessionResponseString = [[NSString alloc] initWithData:sessionData encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *cqResult = [sessionResponseString objectFromJSONString];
//    login = (BOOL)[cqResult valueForKey:@"login"];
//    if (!login) {
//        return NO;
//    }
//    [self loginURSSucessWithUserInfo:result];
//    return YES;
//}

#pragma mark private functions
// 登录urs
- (NSError *)loginURS
{
    NSError *error = nil;
    error = [self loginURSWithHTTPS];
    if (!error) {
        return nil;
    }
    
    if ([error.domain isEqualToString:LOGIN_STATE_DOMAIN]) {
        return error;
    }
    // https登录失败，再用http尝试
    AuthServerV2RP *rp = [[AuthServerV2RP alloc] init];
    error = [rp authServerRP:kTPURSToken withAL:@"RE1"];
    if (error) {
        return error;
    }
    return [self loginURSWithHTTP:rp.userInfo];
}

- (NSError *)loginURSWithHTTP:(NSDictionary *)rpUserInfo
{
    // 加密
    NSString *pc = [rpUserInfo objectForKey:kAuthServerPC];
    NSString *plainText = [NSString stringWithFormat:@"username=%@&password=%@", self.userName, self.password];
    
    NSData *cipherData = [RSAEncrypt encryptText:plainText withHexPublicKey:pc];
    if (!cipherData) {
        DebugLog(@"cipher error");
        return [self normalError];
    }
    DebugLog(@"cipher:%@", cipherData);
    
    NSMutableString *url = [NSMutableString string];
    [url appendString:[AuthServerV2RP authServerLoginURL:NO]];
    [url appendFormat:@"?app=mobile"];
    [url appendFormat:@"&product=%@", PRODUCT];
    [url appendFormat:@"&tp=%@", kTPURSToken];
    [url appendFormat:@"&cf=7"];
    [url appendFormat:@"&show=true"];
    [url appendFormat:@"&format=json"];
    [url appendFormat:@"&pci=%@", [rpUserInfo objectForKey:kAuthServerPCI]];
    [url appendString:@"&um=true"];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:[cipherData hexString] forHTTPHeaderField:@"lo"];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error) {
        return error;
    }
    return [self handleLoginURSWithData:data andResponse:response];
}


- (NSError *)loginURSWithHTTPS
{
    NSMutableString *url = [NSMutableString string];
    [url appendString:[AuthServerV2RP authServerLoginURL:YES]];
    [url appendFormat:@"?app=mobile"];
    [url appendFormat:@"&product=%@", PRODUCT];
    [url appendFormat:@"&tp=urstoken"];
    [url appendFormat:@"&cf=7"];
    [url appendFormat:@"&show=true"];
    [url appendFormat:@"&format=json"];
    [url appendFormat:@"&username=%@", self.userName];
    [url appendFormat:@"&password=%@", self.password];
    [url appendString:@"&um=true"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSError *error;
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error) {
        return error;
    }
    return [self handleLoginURSWithData:data andResponse:response];
}

- (NSError *)handleLoginURSWithData:(NSData *)data andResponse:(NSHTTPURLResponse *)response
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [responseString objectFromJSONString];
    if ((response.statusCode == 200) && [userInfo objectForKey:kAuthServerV2PC]
        && [userInfo objectForKey:kAuthServerV2UserID]) {
        // 登录成功
        return [self loginURSSucessWithUserInfo:userInfo];
    }
    return [self loginURSFailWithUserInfo:userInfo];
}

- (NSError *)loginURSSucessWithUserInfo:(NSDictionary *)userInfo {
#warning 登录成功后会来到这里
    YDLog(@"neteaseMailLoginSuccess:%@", userInfo);
    [[YDUserManager sharedInstance] clearCurrentUserInfo];
    if ([userInfo objectForKey:kAuthServerV2PC]) {
        [YDUserManager sharedInstance].currentUser.dictpc = [userInfo objectForKey:kAuthServerV2PC];
    }
    if ([userInfo objectForKey:kAuthServerV2UserID]) {
        [YDUserManager sharedInstance].currentUser.userID = [userInfo objectForKey:kAuthServerV2UserID];
    }
    if ([userInfo objectForKey:kAuthServerV2UserName]) {
        [YDUserManager sharedInstance].currentUser.nickName = [userInfo objectForKey:kAuthServerV2UserName];
    }
    if ([userInfo objectForKey:kAuthServerV2ImageUrl]) {
        [YDUserManager sharedInstance].currentUser.avatarImage = [userInfo objectForKey:kAuthServerV2ImageUrl];
    }
    [YDUserManager sharedInstance].currentUser.typeLogin = TypeLoginFromNetEaseMail;
    return nil;
}

- (NSError *)loginURSFailWithUserInfo:(NSDictionary *)userInfo
{
    YDLog(@"login urs fail %@ error:%@", self.userName, userInfo);
    
    if (![userInfo objectForKey:@"tpcode"]) {
        return [self normalError];
    }
    
    int tpCode = [[userInfo objectForKey:@"tpcode"] intValue];
    NSError* error = nil;
    if (412 == tpCode) {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_MORE_TIMES_ERROR userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN STATE MORE TIMES ERROR", NSLocalizedDescriptionKey,nil]];
    } else if(420 == tpCode) {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_USERNAME_ERROR userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN_STATE_USERNAME_ERROR", NSLocalizedDescriptionKey,nil]];
    } else if(422 == tpCode) {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_ACCOUNT_LOCKED userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN_STATE_ACCOUNT_LOCKED", NSLocalizedDescriptionKey,nil]];
    } else if(460 == tpCode) {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_PASSWORD_ERROR userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN_STATE_PASSWORD_ERROR", NSLocalizedDescriptionKey,nil]];
    } else if(500 == tpCode) {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_SERVER_ERROR userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN_STATE_SERVER_ERROR", NSLocalizedDescriptionKey,nil]];
    } else if(503 == tpCode) {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_SERVER_ERROR userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN_STATE_SERVER_ERROR", NSLocalizedDescriptionKey,nil]];
    } else {
        error = [NSError errorWithDomain: LOGIN_STATE_DOMAIN code: LOGIN_STATE_OTHER_ERROR userInfo: [NSDictionary dictionaryWithObjectsAndKeys: @"LOGIN_STATE_OTHER_ERROR", NSLocalizedDescriptionKey,nil]];
    }
    return error;
}

- (NSError*)normalError
{
    NSString* description = [NSString stringWithFormat: @"Dict Error"];
    NSError* err = [NSError errorWithDomain: DICT_REQUEST_ERROR_DOMAIN
                                       code: DictError
                                   userInfo: [NSDictionary dictionaryWithObjectsAndKeys: description, NSLocalizedDescriptionKey,nil]];
    return err;
}

//- (void)logout {
//    DictSettings * settings = [DictSettings sharedInstance];
//    settings.lastLoginUser = settings.currentUser;
//    settings.authServerPC = nil;
//    settings.authUserId = nil;
//    settings.authUserName = nil;
//    settings.userImageUrl = nil;
//    settings.userEmail = nil;
//    settings.localTimeStamp = nil;
//    settings.currentUser = nil;
//    settings.syncWordNum = 0;
//    settings.syncWordTime = 0;
//    settings.profileUnLocked = NO;
//    [settings saveSettings];
//    [[YDWordBook sharedInstance] didLogout];
//    [self renewWordBookView];
//    // 清除cookie DICT_SESS
//    NSHTTPCookie *cookie = nil;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        if ([[cookie name] isEqualToString:@"DICT_SESS"]) {
//            [storage deleteCookie:cookie];
//            [self clearCookieForKey:COOKIE_DICT_SESS_KEY];
//        } else if ([[cookie name] isEqualToString:@"DICT_LOGIN"]) {
//            [storage deleteCookie:cookie];
//            [self clearCookieForKey:COOKIE_DICT_LOGIN_KEY];
//        }
//    }
//}

//- (void)renewWordBookView {
//    // 清除单词本view的状态
//    YoudaoDictAppDelegate* appDelegate = (YoudaoDictAppDelegate *)[UIApplication sharedApplication].delegate;
//    YoudaoDictTabViewController * cv = appDelegate.tabViewController;
//    if ([cv isKindOfClass:[YoudaoDictTabViewController class]]) {
//        [cv clearWordBookViewStatus];
//    }
//}

- (NSString *)getPciForLoginInSafari {
    NSString *sess = nil;
    NSString *login = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([[cookie name] isEqualToString:@"DICT_SESS"]) {
            sess = [NSString stringWithString:[cookie value]];
        } else if ([[cookie name] isEqualToString:@"DICT_LOGIN"]) {
            login = [NSString stringWithString:[cookie value]];
        }
    }
    if ([sess length] == 0 || [login length] == 0) {
        return nil;
    }
    NSError *error;
    NSHTTPURLResponse *response;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:AUTH_SERVER_CROSS_FIRST_URL]];
    [request setValue:sess forHTTPHeaderField:@"DICT_SESS"];
    [request setValue:login forHTTPHeaderField:@"DICT_LOGIN"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [responseString objectFromJSONString];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *pci = [dict objectForKey:@"pci"];
        if ([pci length] > 0) {
            return pci;
        }
    }
    return nil;
}

- (NSString *)formLoginUrlForSafariWithPci:(NSString *)pci andUrl:(NSString *)url {
    CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    if (IOS_VERSION >= 7) {
         CFAutorelease(encodedValue);
    }
    return [NSString stringWithFormat:AUTH_SERVER_CROSS_SECOND_URL, pci, encodedValue];
}

@end
