//
//  BookListView.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/11.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookListView : UIView

@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIImageView *lingView;
@property (nonatomic, strong) UIButton *insertBtn;

typedef void (^clickBlock)(UIButton *btn);
@property (nonatomic, copy) clickBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
