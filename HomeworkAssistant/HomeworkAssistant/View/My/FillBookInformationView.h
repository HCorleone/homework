//
//  FillBookInformationView.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/5.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

NS_ASSUME_NONNULL_BEGIN

@interface FillBookInformationView : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *chooseBtn1;
@property (nonatomic, strong) UIButton *chooseBtn2;
@property (nonatomic, strong) UIButton *chooseBtn3;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIImageView *downImgView;

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UILabel *codeLabel;

typedef void(^clickBlock)(UIButton *btn);
@property (nonatomic, copy) clickBlock clickBlock;
@property (nonatomic, strong) NSArray *arr;

@end

NS_ASSUME_NONNULL_END
