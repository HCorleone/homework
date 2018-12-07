//
//  RecommendStaticCell.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN



@interface RecommendStaticCell : UITableViewCell

@property (nonatomic, strong) Book *model;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIButton *saveBtn;

@end

NS_ASSUME_NONNULL_END
