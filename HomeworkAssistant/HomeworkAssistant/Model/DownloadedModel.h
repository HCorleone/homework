//
//  DownloadedModel.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/5.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "AnswerDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadedModel : NSObject

@property (nonatomic, strong) UIImage *coverImg;//背景图
@property (nonatomic, strong) NSString *title;//书名
@property (nonatomic, strong) NSString *subject;//科目
@property (nonatomic, strong) NSString *bookVersion;//书籍版本
@property (nonatomic, strong) NSString *uploaderName;//上传者姓名
@property (nonatomic, strong) NSString *answerID;//答案ID
@property (nonatomic, strong) NSString *grade;//年级

@property (nonatomic, strong) UIImage *thumbsAnswerImg;//答案缩略图
@property (nonatomic, strong) UIImage *detailAnswerImg;//答案高清图
@property (nonatomic, strong) NSString *idx1;//缩略图页码
@property (nonatomic, strong) NSString *idx2;//高清图页码
@property (nonatomic, strong) NSString *lastViewIdx;//上一次查看的进度
@property (nonatomic, strong) NSString *answerCount;

@end

NS_ASSUME_NONNULL_END
