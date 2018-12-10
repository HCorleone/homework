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
    _pwdView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    _pwdView.layer.borderWidth = 1;
    _pwdView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:_pwdView];
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(149);
        make.width.mas_equalTo(288);
        make.height.mas_equalTo(276);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

//返回操作
- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

//时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//获取验证码
-(void)getVerification
{
    //时间戳
//    NSInteger timesTamp = [NSString getNowTimestamp];
//    NSString *timesStr = [NSString stringWithFormat:@"%ld", timesTamp];
//    NSString *timesStr = [[NSNumber numberWithInteger:timesTamp]stringValue];
    NSString *timesStr = [self currentTimeStr];
    
    NSString *md5 = [NSString stringWithFormat:@"%@%@2017", timesStr, self.pwdView.phoneField.text];
//    NSString *digest = [NSString md5:md5];
    NSString *digest = [NSString MD5ForUpper32Bate:md5];
//    NSString *digest = [NSString MD5ForLower16Bate:md5];
//    NSString *digest = [NSString MD5ForUpper16Bate:md5];
    
    NSDictionary *dic = @{@"h":@"SendValidCodeUpdateHandler",
                          @"mobile":self.pwdView.phoneField.text,
                          @"digest":digest,
                          @"salt":timesStr,
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

//确认修改
-(void)getUpdatePwd{
    
    NSDictionary *dic = @{@"h":@"UpdateUserPasswdHandler",
                          @"mobile":self.pwdView.phoneField.text,
                          @"passwd":self.pwdView.pwdField.text,
                          @"validCode":self.pwdView.codeField.text,
                          @"av":@"_debug_"};
    //    __weak typeof(self) weakSelf = self;
    [self.manager GET:@"/tataeraapi/api.s?" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@", responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showArtleMessage:@"修改成功" isJump:YES];
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
