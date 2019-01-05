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
            make.size.mas_equalTo(CGSizeMake(0.69 * SCREEN_WIDTH, 0.15 * 0.69 * SCREEN_WIDTH));
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(0.09 * SCREEN_WIDTH);
        }];
        
        _pwdField = [[LoginTextField alloc]init:@"请输入密码"];
        [_pwdField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        _pwdField.secureTextEntry = YES;
        [self addSubview:_pwdField];
        [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneField.mas_bottom).with.offset(0.04 * SCREEN_WIDTH);
            make.size.mas_equalTo(CGSizeMake(0.69 * SCREEN_WIDTH, 0.15 * 0.69 * SCREEN_WIDTH));
            make.centerX.mas_equalTo(self);
        }];
        
        _nameField = [[LoginTextField alloc]init:@"请输入昵称"];
        [_nameField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_nameField];
        [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pwdField.mas_bottom).with.offset(0.04 * SCREEN_WIDTH);
            make.size.mas_equalTo(CGSizeMake(0.69 * SCREEN_WIDTH, 0.15 * 0.69 * SCREEN_WIDTH));
            make.centerX.mas_equalTo(self);
        }];
        
        _codeField = [[LoginTextField alloc]init:@"请输入验证码"];
        [_codeField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_codeField];
        [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameField.mas_bottom).with.offset(0.04 * SCREEN_WIDTH);
            make.size.mas_equalTo(CGSizeMake(0.38 * SCREEN_WIDTH, 0.26 * 0.38 * SCREEN_WIDTH));
            make.left.mas_equalTo(self.nameField);
        }];
        
        //渐变色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 0.29 * SCREEN_WIDTH, 0.29 * SCREEN_WIDTH * 0.365);
        [gradientLayer setColors:[NSArray arrayWithObjects:
                                  (id)[UIColor colorWithHexString:@"#FFC94C"].CGColor,
                                  (id)[UIColor colorWithHexString:@"#FF8800"].CGColor,
                                  nil
                                  ]];
        
        
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = @[@0,@1];
        gradientLayer.cornerRadius = 8;
        gradientLayer.masksToBounds = NO;
        
        
        //阴影
        CALayer *shadowLayer = [[CALayer alloc] init];
        shadowLayer.frame = CGRectMake(0, 0, 0.29 * SCREEN_WIDTH, 0.29 * SCREEN_WIDTH * 0.365);
        shadowLayer.shadowOffset = CGSizeMake(0, 1);
        shadowLayer.backgroundColor = [UIColor colorWithHexString:@"#C3733A"].CGColor;
        shadowLayer.shadowColor = [UIColor colorWithHexString:@"#C3733A"].CGColor;
        shadowLayer.shadowOpacity = 1;
        shadowLayer.cornerRadius = 8;
        
        
        //获取验证码
        _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getBtn.tag = 1001;
        _getBtn.layer.cornerRadius = 8;
        [_getBtn.layer addSublayer:shadowLayer];
        [_getBtn.layer addSublayer:gradientLayer];
        [self addSubview:_getBtn];
        [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.codeField);
            make.size.mas_equalTo(CGSizeMake(0.29 * SCREEN_WIDTH, 0.29 * SCREEN_WIDTH * 0.365));
            make.right.mas_equalTo(self.nameField.mas_right);
        }];
        [_getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_getBtn addTarget:self action:@selector(clinkBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //渐变色
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
//        gradientLayer.frame = CGRectMake(0, 0, 0.29 * SCREEN_WIDTH, 0.29 * SCREEN_WIDTH * 0.365);
        [gradientLayer2 setColors:[NSArray arrayWithObjects:
                                  (id)[UIColor colorWithHexString:@"#FFC94C"].CGColor,
                                  (id)[UIColor colorWithHexString:@"#FF8800"].CGColor,
                                  nil
                                  ]];
        
        
        gradientLayer2.startPoint = CGPointMake(0, 0);
        gradientLayer2.endPoint = CGPointMake(0, 1);
        gradientLayer2.locations = @[@0,@1];
        gradientLayer2.cornerRadius = 8;
        gradientLayer2.masksToBounds = NO;
        
        //阴影
        CALayer *shadowLayer2 = [[CALayer alloc] init];
//        shadowLayer.frame = CGRectMake(0, 0, 0.29 * SCREEN_WIDTH, 0.29 * SCREEN_WIDTH * 0.365);
        shadowLayer2.shadowOffset = CGSizeMake(0, 1);
        shadowLayer2.backgroundColor = [UIColor colorWithHexString:@"#C3733A"].CGColor;
        shadowLayer2.shadowColor = [UIColor colorWithHexString:@"#C3733A"].CGColor;
        shadowLayer2.shadowOpacity = 1;
        shadowLayer2.cornerRadius = 8;
        
        //注册
        _registered = [UIButton buttonWithType:UIButtonTypeCustom];
        _registered.tag = 1002;
        _registered.layer.cornerRadius = 8;
        
        shadowLayer2.frame = CGRectMake(0, 0, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.15);
        gradientLayer2.frame = CGRectMake(0, 0, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.15);
        [_registered.layer addSublayer:shadowLayer2];
        [_registered.layer addSublayer:gradientLayer2];
        [self addSubview:_registered];
        [_registered mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-0.09 * SCREEN_WIDTH);
            make.size.mas_equalTo(CGSizeMake(0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.15));
            make.centerX.mas_equalTo(self);
        }];
        [_registered setTitle:@"注册" forState:UIControlStateNormal];
        _registered.titleLabel.font = [UIFont systemFontOfSize:14.0];
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
