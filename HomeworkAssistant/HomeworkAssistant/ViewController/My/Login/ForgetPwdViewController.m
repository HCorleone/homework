//
//  ForgetPwdViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/4.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ForgetPwdView.h"

@interface ForgetPwdViewController ()

@property (nonatomic, strong) ForgetPwdView *pwdView;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[UIColor colorWithHexString:@"#F2B830"].CGColor,
                              (id)[UIColor colorWithHexString:@"#FF8800"].CGColor,
                              nil
                              ]];
    
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    
    self.view.layer.masksToBounds = YES;
    [self.view.layer addSublayer:gradientLayer];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.view).with.offset(20);
        make.top.mas_equalTo(self.view).with.offset(35 + TOP_OFFSET);
    }];
    
    [self GetView];
}

-(AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        _manager = [[AFHTTPSessionManager alloc] init];
        //设置请求方式
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //接收数据是json形式给出
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    }
    return _manager;
}

- (void)GetView {
    _pwdView = [[ForgetPwdView alloc] init];
    _pwdView.pwdField.placeholder = @"请输入新密码";
    __weak typeof(self) weakSelf = self;
    _pwdView.block = ^(UIButton * _Nonnull btn) {
        switch (btn.tag) {
            case 1001:
            {
                NSLog(@"获取验证码");
                [weakSelf getVerification];
            }
                break;
            case 1002:
            {
                NSLog(@"确认修改");
                [weakSelf getUpdatePwd];
            }
                break;
        }
    };
    _pwdView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    _pwdView.layer.borderWidth = 0.5;
    _pwdView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    _pwdView.layer.cornerRadius = 4;
    [self.view addSubview:_pwdView];
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.4 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.8 * SCREEN_WIDTH, 0.96 * 0.8 * SCREEN_WIDTH) );
        make.centerX.mas_equalTo(self.view);
    }];
}

//获取验证码
-(void)getVerification
{
    //时间戳
    NSString *timesStr = [CommonToolClass currentTimeStr];
    NSString *md5 = [NSString stringWithFormat:@"%@%@2017", timesStr, self.pwdView.phoneField.text];
    NSString *digest = [NSString MD5ForUpper32Bate:md5];
    
    NSDictionary *dic = @{
                          @"mobile":self.pwdView.phoneField.text,
                          @"digest":digest,
                          @"salt":timesStr,
                          };
    
    [self.manager GET:[URLBuilder getURLForVerificationCode] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@", responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            [XWHUDManager showTipHUDInView:@"已发送验证码"];
        }else if ([responseObject[@"code"] integerValue] == 400)
        {
            [XWHUDManager showTipHUDInView:@"验证码发送失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
    
}

//确认修改
-(void)getUpdatePwd{
    
    NSDictionary *dic = @{
                          @"mobile":self.pwdView.phoneField.text,
                          @"passwd":self.pwdView.pwdField.text,
                          @"validCode":self.pwdView.codeField.text,
                          };
    //    __weak typeof(self) weakSelf = self;
    [self.manager GET:[URLBuilder getURLForFindBackPassword] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@", responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            [XWHUDManager showSuccessTipHUDInView:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([responseObject[@"code"] integerValue] == 400)
        {
            [XWHUDManager showWarningTipHUDInView:@"验证码错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
