//
//  AnswerDetail.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerDetail : NSObject

@property (nonatomic, strong) NSString *thumbsAnswerURL;//答案缩略图
@property (nonatomic, strong) NSString *detailAnswerURL;//答案高清图
@property (nonatomic, strong) NSString *idx1;//缩略图页码
@property (nonatomic, strong) NSString *idx2;//高清图页码
@property (nonatomic, strong) NSString *lastViewIdx;//上一次查看的进度
@property (nonatomic, strong) NSString *answerCount;
+ (AnswerDetail *)initWithDic1:(NSDictionary *)thumbs Dic2:(NSDictionary *)detail;//Dic1为缩略图，Dic2为高清图

@end

NS_ASSUME_NONNULL_END
