//
//  SingUpView.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/4.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "SingUpView.h"


@implementation SingUpView

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        _phoneField = [[LoginTextField alloc]init:@"请输入手机号"];
        [_phoneField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_phoneField];
        [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(36);
        }];
        
        _pwdField = [[LoginTextField alloc]init:@"请输入密码"];
        [_pwdField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        _pwdField.secureTextEntry = YES;
        [self addSubview:_pwdField];
        [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneField.mas_bottom).offset(16);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(36);
        }];
        
        _nameField = [[LoginTextField alloc]init:@"请输入昵称"];
        [_nameField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_nameField];
        [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pwdField.mas_bottom).offset(16);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(36);
        }];
        
        _codeField = [[LoginTextField alloc]init:@"请输入验证码"];
        [_codeField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_codeField];
        [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameField.mas_bottom).offset(16);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(136);
            make.height.mas_equalTo(36);
        }];
        
        //获取验证码
        _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getBtn.tag = 1001;
        _getBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _getBtn.layer.cornerRadius = 10;
        _getBtn.layer.shadowOffset =  CGSizeMake(0, 1);
        _getBtn.layer.shadowOpacity = 0.5;
        _getBtn.layer.shadowColor =  [UIColor colorWithHexString:@"#2983C8"].CGColor;
        _getBtn.backgroundColor = [UIColor colorWithHexString:@"#6FDDFF"];
        [self addSubview:_getBtn];
        [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameField.mas_bottom).offset(16);
            make.size.mas_equalTo(CGSizeMake(104, 38));
            make.left.mas_equalTo(self.codeField.mas_right).offset(8);
        }];
        [_getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getBtn addTarget:self action:@selector(clinkBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //注册
        _registered = [UIButton buttonWithType:UIButtonTypeCustom];
        _registered.tag = 1002;
        _registered.layer.cornerRadius = 10;
        _registered.layer.shadowOffset =  CGSizeMake(0, 1);
        _registered.layer.shadowOpacity = 1;
        _registered.layer.shadowColor =  [UIColor colorWithHexString:@"#2983C8"].CGColor;
        _registered.backgroundColor = [UIColor colorWithHexString:@"#6FDDFF"];
        [self addSubview:_registered];
        [_registered mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.getBtn.mas_bottom).offset(34);
            make.size.mas_equalTo(CGSizeMake(248, 38));
            make.left.mas_equalTo(20);
        }];
        [_registered setTitle:@"注册" forState:UIControlStateNormal];
        [_registered addTarget:self action:@selector(clinkBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)clinkBtn:(UIButton *)btn{
    if (_block) {
        _block(btn);
    }
}
@end
