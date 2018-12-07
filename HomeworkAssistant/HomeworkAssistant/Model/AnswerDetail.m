//
//  AnswerDetail.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerDetail.h"

@implementation AnswerDetail

+ (AnswerDetail *)initWithDic1:(NSDictionary *)thumbs Dic2:(NSDictionary *)detail {
    
    AnswerDetail *model = [AnswerDetail new];
    model.thumbsAnswerURL = thumbs[@"answerURL"];
    model.idx1 = [NSString stringWithFormat:@"%@",thumbs[@"idx"]];
    model.detailAnswerURL = detail[@"answerURL"];
    model.idx2 = [NSString stringWithFormat:@"%@",detail[@"idx"]];
    
    return model;
}

@end
