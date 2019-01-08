//
//  RecommendStaticCell.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "DownloadedModel.h"

NS_ASSUME_NONNULL_BEGIN

//首页推荐、答案搜索、我的书单列表、历史浏览记录的Cell
@interface BookCell : UITableViewCell

@property (nonatomic, strong) DownloadedModel *downloadedModel;
@property (nonatomic, strong) Book *model;
@property (nonatomic, strong) UIButton *saveBtn;

@end

NS_ASSUME_NONNULL_END
