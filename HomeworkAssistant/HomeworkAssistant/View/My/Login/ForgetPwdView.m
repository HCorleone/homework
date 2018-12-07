//
//  ForgetPwdView.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/4.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "ForgetPwdView.h"

@implementation ForgetPwdView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.nameField.hidden = YES;
        
        [self addSubview:self.codeField];
        [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pwdField.mas_bottom).offset(16);
        }];
//        //验证码
        [self addSubview:self.getBtn];
        [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pwdField.mas_bottom).offset(16);
        }];
        //注册
        [self addSubview:self.registered];
        [self.registered mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.getBtn.mas_bottom).offset(32);
        }];
        [self.registered setTitle:@"确认修改" forState:UIControlStateNormal];
    }
    return self;
}

@end
