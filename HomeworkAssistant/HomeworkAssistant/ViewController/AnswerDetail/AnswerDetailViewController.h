//
//  AnswerDetailViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/26.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerDetailViewController : UIViewController

@property (nonatomic, strong) AnswerDetail *answerModel;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

NS_ASSUME_NONNULL_END
