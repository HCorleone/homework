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

//书单答案列表Cell
@interface AnswerCell : UICollectionViewCell

@property (nonatomic, strong) AnswerDetail *model;

@end

NS_ASSUME_NONNULL_END
