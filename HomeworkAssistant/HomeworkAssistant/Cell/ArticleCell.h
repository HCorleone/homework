//
//  ArticleCell.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

//作文模块列表Cell
@interface ArticleCell : UITableViewCell

@property (nonatomic, strong) Article *model;

@end

NS_ASSUME_NONNULL_END
