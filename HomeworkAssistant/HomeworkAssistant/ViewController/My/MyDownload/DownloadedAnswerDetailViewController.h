//
//  DownloadedAnswerDetailViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/8.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "BaseViewController.h"
#import "DownloadedBook.h"
#import "AnswerDetail.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^needToReloadCell)(BOOL IsSelected);

@interface DownloadedAnswerDetailViewController : BaseViewController

@property (nonatomic, strong) DownloadedBook *bookModel;

//@property (nonatomic, strong) AnswerDetail *answerModel;
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *answerCount;
@property (nonatomic, strong) NSString *answerID;
@property (nonatomic, assign) BOOL isSelected;

//用于分享的内容
@property (nonatomic, strong) UIImage *bookImg;
@property (nonatomic, strong) NSString *bookTitle;

@property (nonatomic, copy) needToReloadCell reloadBlock;

@end

NS_ASSUME_NONNULL_END
