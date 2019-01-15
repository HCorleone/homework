//
//  AnswerDetailViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/26.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetail.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^needToReloadCell)(BOOL IsSelected);

@interface AnswerDetailViewController : BaseViewController

@property (nonatomic, strong) AnswerDetail *answerModel;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *answerID;
@property (nonatomic, assign) BOOL isSelected;

//用于分享的内容
@property (nonatomic, strong) UIImage *bookImg;
@property (nonatomic, strong) NSString *bookTitle;

@property (nonatomic, copy) needToReloadCell reloadBlock;

@end

NS_ASSUME_NONNULL_END
