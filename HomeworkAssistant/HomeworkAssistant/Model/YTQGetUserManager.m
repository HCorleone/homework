//
//  YTQGetUserManager.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/8.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "YTQGetUserManager.h"
#import "GetUserModel.h"

@implementation YTQGetUserManager

-(NSMutableDictionary *)getUserManager:(void(^)(NSMutableDictionary *dic))mudic
{
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSDictionary *dic = @{@"h":@"ZYGetUserExtHander",
                          @"openID":userValue(@"openId"),
                          @"av":@"_debug_"};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OnLineIP]];
    //设置请求方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //接收数据是json形式给出
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    __weak typeof(self) weakSelf = self;
    [manager GET:getURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@------------------------------", responseObject);
        
        //返回成功
        if ([responseObject[@"code"] intValue] == 200) {
            
            mudic(responseObject[@"datas"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
    return nil;
}

@end
