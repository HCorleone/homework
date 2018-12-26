//
//  AnswerCell.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/27.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetail.h"
#import "ImgScrollView.h"

NS_ASSUME_NONNULL_BEGIN

//书单答案详情大图Cell
@interface AnswerDetailCell : UICollectionViewCell

@property (nonatomic, strong) AnswerDetail *model;
@property (nonatomic, strong) ImgScrollView *imgScrollView;


@end

NS_ASSUME_NONNULL_END
