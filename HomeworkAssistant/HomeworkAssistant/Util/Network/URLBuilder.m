//
//  URLBuilder.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/17.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "URLBuilder.h"

@implementation URLBuilder

+ (NSString *)getURLForRecommend {
    NSString *URLString = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?h=ZYRecHandler";
//    URLString = [URLString stringByAppendingString:@"&"];
//    URLString = [URLString stringByAppendingString:[self getCommonUrlInfo]];
    return URLString;
}

+ (NSString *)getURLForMyCollections {
    NSString *URLString = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?h=ZYListUserLikeHandler";
    
    return URLString;
}

+ (NSString *)getURLForArticle {
    NSString *URLString = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?h=ZYSearchArticleHandler";
    
    return URLString;
}

+ (NSDictionary *)getCommonInfo {
    NSDictionary *dic = @{
                          
                          };
    
    
    return dic;
}
@end
