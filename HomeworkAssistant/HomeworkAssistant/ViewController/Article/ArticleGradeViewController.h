//
//  ArticleGradeViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "GradeViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GradeFrom) {
    FromChinese,
    FromEnglish
};

@interface ArticleGradeViewController : GradeViewController

@property (nonatomic, assign) GradeFrom from;

@end

NS_ASSUME_NONNULL_END
