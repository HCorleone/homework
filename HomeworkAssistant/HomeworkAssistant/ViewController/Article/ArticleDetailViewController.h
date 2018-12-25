//
//  ArticleDetailViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailViewController : BaseViewController

@property (nonatomic, strong) Article *model;

@end

NS_ASSUME_NONNULL_END
