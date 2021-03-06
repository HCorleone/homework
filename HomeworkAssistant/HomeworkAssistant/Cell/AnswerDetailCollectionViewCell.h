//
//  AnswerDetailCollectionViewCell.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AnswerDetail *model;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
