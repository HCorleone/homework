//
//  Article.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "Article.h"

@implementation Article

+ (Article *)initWithDic:(NSDictionary *)articleDic {
    
    Article *model = [Article new];
    model.id = articleDic[@"id"];
    model.articleType = articleDic[@"articleType"];
    model.title = articleDic[@"title"];
    model.grade = articleDic[@"grade"];
    model.bookVersion = articleDic[@"bookVersion"];
    model.subContent = articleDic[@"subContent"];
    model.wordsNum = articleDic[@"wordsNum"];
    
    return model;
}

@end
