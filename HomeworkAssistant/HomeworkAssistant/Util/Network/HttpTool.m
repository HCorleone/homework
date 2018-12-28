//
//  HttpTool.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

+ (AFHTTPSessionManager *)initializeHttpManager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //很重要
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    return manager;
    
}

@end
