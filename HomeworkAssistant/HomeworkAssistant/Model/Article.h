//
//  Article.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Article : NSObject

@property (nonatomic, strong) NSString *id;//作文ID
@property (nonatomic, strong) NSString *articleType;//作文类别
@property (nonatomic, strong) NSString *title;//作文标题
@property (nonatomic, strong) NSString *grade;//年级
@property (nonatomic, strong) NSString *bookVersion;//书籍版本
@property (nonatomic, strong) NSString *subContent;//作文部分内容
@property (nonatomic, strong) NSString *wordsNum;//作文字数


+ (Article *)initWithDic:(NSDictionary *)articleDic;

@end

NS_ASSUME_NONNULL_END
