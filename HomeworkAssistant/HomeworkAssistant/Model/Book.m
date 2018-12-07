//
//  Book.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/12.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (Book *)initWithDic:(NSDictionary *)bookDic {
    
    Book *model = [Book new];
    model.coverURL = bookDic[@"coverURL"];
    model.title = bookDic[@"title"];
    model.subject = bookDic[@"subject"];
    model.bookVersion = bookDic[@"bookVersion"];
    model.uploaderName = bookDic[@"uploaderName"];
    model.answerID = bookDic[@"id"];
    model.grade = bookDic[@"grade"];
    
    return model;
}

@end
