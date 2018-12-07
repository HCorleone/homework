//
//  AuthServerV2RP.m
//  YNote
//
//  Created by Liu Deqing on 13-1-6.
//  Copyright (c) 2013年 Youdao. All rights reserved.
//

#import "AuthServerV2RP.h"
#import "JSONKit.h"
#import "Constants.h"
@implementation AuthServerV2RP

- (NSError *)authServerRP:(NSString *)tp withAL:(NSString *)al
{
    debugMethod();
    NSMutableString *url = [NSMutableString string];
    [url appendString:[self authServerRPURL]];
    [url appendFormat:@"?app=mobile"];
    [url appendFormat:@"&product=%@", PRODUCT];
    [url appendFormat:@"&tp=%@", tp];
    if (al) {
        [url appendFormat:@"&al=%@", al];
    }
    [url appendFormat:@"&format=json"];
    YDLog(@"url is %@", url);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSError *requestError;
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                   returningResponse:&response
                                               error:&requestError];
    if (requestError) {
        return requestError;
    }
    NSString *responseString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [responseString objectFromJSONString];
    if ([userInfo objectForKey:kAuthServerPCI]) {
        self.userInfo = userInfo;
        return nil;
    }

    NSError *error = nil;
    if ([userInfo objectForKey:kAuthServerV2ECode]) {
        error = [NSError errorWithDomain:AUTH_SERVER_DOMAIN code:[[userInfo objectForKey:kAuthServerV2ECode] integerValue] userInfo:userInfo];
    } else {
        error = [self normalError];
    }
    return error;
}

- (NSString *)authServerRPURL
{
    NSMutableString *url = [NSMutableString string];
    [url appendString:@"http://"];
    [url appendString:AUTH_SERVER_HOST];
    [url appendString:AUTH_LOGIN_PATH];
    [url appendString:@"rp"];
    return url;
}

+ (NSString *)authServerLoginURL:(BOOL)isHttps
{
    NSMutableString *url = [NSMutableString string];
    if (isHttps) {
        [url appendString:@"https://"];
    } else {
        [url appendString:@"http://"];
    }
    [url appendString:AUTH_SERVER_HOST];
    [url appendString:AUTH_LOGIN_PATH];
    [url appendString:@"login"];
    return url;
}

+ (NSString *)authServerPollURL
{
    NSMutableString *url = [NSMutableString string];
    [url appendString:@"http://"];
    [url appendString:AUTH_SERVER_HOST];
    [url appendString:AUTH_LOGIN_PATH];
    [url appendString:@"poll"];
    return url;
}

- (NSError*)normalError
{
    NSString* description = [NSString stringWithFormat: @"Dict Error"];
    NSError* err = [NSError errorWithDomain: DICT_REQUEST_ERROR_DOMAIN
                                       code: DictError
                                   userInfo: [NSDictionary dictionaryWithObjectsAndKeys: description, NSLocalizedDescriptionKey,nil]];
    return err;
}

@end
