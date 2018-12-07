//
//  SingUpView.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/4.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingUpView : UIView

/** 文本框 */
@property (nonatomic, strong) LoginTextField *phoneField;
@property (nonatomic, strong) LoginTextField *pwdField;
@property (nonatomic, strong) LoginTextField *nameField;
/** 验证码 */
@property (nonatomic, strong) LoginTextField *codeField;
/** 获取验证码 */
@property (nonatomic, strong) UIButton *getBtn;
/** 注册 */
@property (nonatomic, strong) UIButton *registered;

typedef void(^clickBlock)(UIButton *btn);
@property (nonatomic, copy) clickBlock block;

@end

NS_ASSUME_NONNULL_END
