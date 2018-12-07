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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#6FDDFF"];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.view).with.offset(20);
        make.top.mas_equalTo(self.view).with.offset(35);
    }];
    
    
    [self GetView];
}

-(AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ecomment.tatatimes.com"]];
        //设置请求方式
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //接收数据是json形式给出
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
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
                [weakSelf getVerificationCode];
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
    _singUpView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    _singUpView.layer.borderWidth = 1;
    _singUpView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:_singUpView];
    [_singUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(129);
        make.width.mas_equalTo(288);
        make.height.mas_equalTo(328);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
}

//返回操作
- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
-(void)getVerificationCode
{
    NSDictionary *dic = @{@"h":@"SendValidCodeUpdateHandler",
                          @"mobile":self.singUpView.phoneField.text,
                          @"av":@"_debug_"};
    
    [self.manager GET:@"/tataeraapi/api.s?" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    NSDictionary *dic = @{@"h":@"RegUserHandler",
                          @"mobile":self.singUpView.phoneField.text,
                          @"passwd":self.singUpView.pwdField.text,
                          @"validCode":self.singUpView.codeField.text,
                          @"name":self.singUpView.nameField.text,
                          @"av":@"_debug_"};
//    __weak typeof(self) weakSelf = self;
    [self.manager GET:@"/tataeraapi/api.s?" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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

@end
