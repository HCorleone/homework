//
//  FillOthersView.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/10.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FillOthersView : UIView
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 地区 */
@property (nonatomic, strong) UILabel *areaLabel;
/** 地区选择 */
@property (nonatomic, strong) UIButton *areaBtn;
/** 确认 */
@property (nonatomic, strong) UIButton *okBtn;

typedef void(^chooseBlock)(UIButton *btn);
@property (nonatomic, copy) chooseBlock block;

@end

NS_ASSUME_NONNULL_END
