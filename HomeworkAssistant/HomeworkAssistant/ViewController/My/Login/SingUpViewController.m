//
//  SingUpViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/4.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "SingUpViewController.h"
#import "SingUpView.h"


@interface SingUpViewController ()

@property (nonatomic, strong) SingUpView *singUpView;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation SingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[UIColor colorWithHexString:@"#55CEF2"].CGColor,
                              (id)[UIColor colorWithHexString:@"#3DB6F2"].CGColor,
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
        
        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    return _manager;
}


//视图显示
- (void)GetView {
    _singUpView = [[SingUpView alloc] init];
    __weak typeof(self) weakSelf = self;
    _singUpView.block = ^(UIButton * _Nonnull btn) {
        switch (btn.tag) {
            case 1001:
            {
                NSLog(@"获取验证码");
//                [weakSelf showArtleMessage:@"请注意接收短信验证" jumpBlock:nil];
                [weakSelf getVerification];
            }
                break;
            case 1002:
            {
                NSLog(@"注册");
                [weakSelf getRegistered];
            }
                break;
        }
    };
    _singUpView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    _singUpView.layer.borderWidth = 0.5;
    _singUpView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    _singUpView.layer.cornerRadius = 4;
    [self.view addSubview:_singUpView];
    [_singUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.4 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.8 * SCREEN_WIDTH, 1.14 * 0.8 * SCREEN_WIDTH) );
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
}

//获取验证码
-(void)getVerification
{
    //时间戳
    NSString *timesStr = [CommonToolClass currentTimeStr];
    NSString *md5 = [NSString stringWithFormat:@"%@%@2017", timesStr, self.singUpView.phoneField.text];
    NSString *digest = [NSString MD5ForUpper32Bate:md5];
    
    NSDictionary *dic = @{
                          @"mobile":self.singUpView.phoneField.text,
                          @"digest":digest,
                          @"salt":timesStr,
                          };
    
    [self.manager GET:[URLBuilder getURLForVerificationCode] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@", responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showArtleMessage:@"已发送验证码" isJump:NO];
        }else if ([responseObject[@"code"] integerValue] == 400)
        {
            [self showArtleMessage:@"验证码发送失败" isJump:NO];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
    
}

//注册
-(void)getRegistered{
    
    NSDictionary *dic = @{
                          @"mobile":self.singUpView.phoneField.text,
                          @"passwd":self.singUpView.pwdField.text,
                          @"validCode":self.singUpView.codeField.text,
                          @"name":self.singUpView.nameField.text,
                          };
//    __weak typeof(self) weakSelf = self;
    [self.manager POST:[URLBuilder getURLForSignup] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"------------------------------%@", responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showArtleMessage:@"注册成功" isJump:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([responseObject[@"code"] integerValue] == 400)
        {
            [self showArtleMessage:@"验证码错误" isJump:NO];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}

//显示警告框
-(void)showArtleMessage:(NSString *)str isJump:(BOOL)is
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [[UIAlertAction alloc] init];
    if (is == 0)
    {
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    }
    else
    {
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
