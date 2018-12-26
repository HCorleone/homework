//
//  LoginViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/13.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextField.h"
#import "SingUpViewController.h"
#import "ForgetPwdViewController.h"
#import "FillOthersViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) NSDictionary *loginDict;
@property (nonatomic, strong) UITextField *acountF;
@property (nonatomic, strong) UITextField *passwordF;

@end

@implementation LoginViewController

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
    
    [self setupLoginView];
    [self thirdPartLogin];
}

#pragma mark - 建立UI
- (void)setupLoginView {
    //登陆框
    UIView *loginView = [[UIView alloc]init];
    loginView.layer.borderWidth = 0.5;
    loginView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    loginView.layer.cornerRadius = 4;
//    loginView.layer.opacity = 0.9;
    loginView.layer.masksToBounds = YES;
    loginView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.8 * SCREEN_WIDTH, 0.909 * 0.8 * SCREEN_WIDTH));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(0.42 * SCREEN_WIDTH);
    }];
    self.loginView = loginView;
    //帐号框
    LoginTextField *acountF = [[LoginTextField alloc]init:@"请输入手机号"];
    [loginView addSubview:acountF];
    [acountF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.689 * SCREEN_WIDTH, 0.15 * 0.689 * SCREEN_WIDTH));
        make.centerX.mas_equalTo(loginView);
        make.top.mas_equalTo(loginView).offset(0.10 * SCREEN_WIDTH);
    }];
    self.acountF = acountF;
    
    //密码框
    LoginTextField *passwordF = [[LoginTextField alloc]init:@"请输入密码"];
    passwordF.secureTextEntry = YES;//暗文
    [loginView addSubview:passwordF];
    passwordF.secureTextEntry = YES;
    [passwordF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.689 * SCREEN_WIDTH, 0.15 * 0.689 * SCREEN_WIDTH));
        make.centerX.mas_equalTo(loginView);
        make.top.mas_equalTo(acountF.mas_bottom).with.offset(0.04 * SCREEN_WIDTH);
    }];
    self.passwordF = passwordF;
    
    //登陆按钮
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0.689 * SCREEN_WIDTH, 0.15 * 0.689 * SCREEN_WIDTH);
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[UIColor colorWithHexString:@"#6FDDFF"].CGColor,
                              (id)[UIColor colorWithHexString:@"#33C2FF"].CGColor,
                              nil
                              ]];
    
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    gradientLayer.cornerRadius = 8;
    gradientLayer.masksToBounds = NO;
    
    
    //阴影
    CALayer *shadowLayer = [[CALayer alloc] init];
    shadowLayer.frame = CGRectMake(0, 0, 0.689 * SCREEN_WIDTH, 0.15 * 0.689 * SCREEN_WIDTH);
    shadowLayer.shadowOffset = CGSizeMake(0, 1);
    shadowLayer.backgroundColor = [UIColor colorWithHexString:@"#2983C8"].CGColor;
    shadowLayer.shadowColor = [UIColor colorWithHexString:@"#2983C8"].CGColor;
    shadowLayer.shadowOpacity = 1;
    shadowLayer.cornerRadius = 8;
    
    UIButton *signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signinBtn.layer addSublayer:shadowLayer];
    [signinBtn.layer addSublayer:gradientLayer];
    signinBtn.layer.cornerRadius = 8;
    
    [loginView addSubview:signinBtn];
    [signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.689 * SCREEN_WIDTH, 0.15 * 0.689 * SCREEN_WIDTH));
        make.centerX.mas_equalTo(loginView);
        make.top.mas_equalTo(passwordF.mas_bottom).with.offset(0.07 * SCREEN_WIDTH);
    }];
    [signinBtn setTitle:@"登录" forState:UIControlStateNormal];
    signinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [signinBtn addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    //注册账户
    UIButton *signupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:signupBtn];
    [signupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signinBtn);
        make.bottom.mas_equalTo(loginView).offset(-0.06 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.16 * SCREEN_WIDTH, 0.25 * 0.16 * SCREEN_WIDTH));
    }];
    signupBtn.backgroundColor = [UIColor clearColor];
    NSString *textStr = @"注册账号";
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    signupBtn.titleLabel.attributedText = attribtStr;
    [signupBtn setTitle:textStr forState:UIControlStateNormal];
    signupBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [signupBtn addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(signinBtn);
        make.bottom.mas_equalTo(loginView).offset(-0.06 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.16 * SCREEN_WIDTH, 0.25 * 0.16 * SCREEN_WIDTH));
    }];
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)thirdPartLogin {
    //第三方登录标题
    UILabel *thirdPart = [[UILabel alloc]init];
    thirdPart.text = @"第三方登录";
    thirdPart.font = [UIFont systemFontOfSize:14];
    thirdPart.textColor = whitecolor;
    thirdPart.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdPart];
    [thirdPart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 10));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(0.13 * SCREEN_WIDTH);
    }];
    //横线
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"第三方登录-渐变分割线"]];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(thirdPart.mas_bottom).with.offset(0.04 * SCREEN_WIDTH);
    }];
//    //QQ登录
//    UIImageView *qqLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qq"]];
//    qqLogo.userInteractionEnabled = YES;
//    [self.view addSubview:qqLogo];
//    [qqLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view).offset(-50);
//        make.top.mas_equalTo(line.mas_bottom).with.offset(25);
//    }];
//    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    qqBtn.frame = qqLogo.frame;
//    qqBtn.backgroundColor = [UIColor clearColor];
//    [qqLogo addSubview:qqBtn];
//    [qqBtn addTarget:self action:@selector(qqUser) forControlEvents:UIControlEventTouchUpInside];
//
    
    //微信登录
    UIImageView *wechatLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信"]];
    wechatLogo.userInteractionEnabled = YES;
    [self.view addSubview:wechatLogo];
    [wechatLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view).offset(50);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(0.12 * SCREEN_WIDTH, 0.12 * SCREEN_WIDTH));
        make.top.mas_equalTo(line.mas_bottom).with.offset(0.04 * SCREEN_WIDTH);
    }];
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatBtn.frame = wechatLogo.frame;
    wechatBtn.backgroundColor = [UIColor clearColor];
    [wechatLogo addSubview:wechatBtn];
    [wechatBtn addTarget:self action:@selector(wechatUser) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - QQ登陆
- (void)qqUser {
    
}

#pragma mark - 微信登陆
- (void)wechatUser {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLogin" object:self];

    
    [[TTUserManager sharedInstance] clearCurrentUserInfo];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"HA_APP";
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];//发送三方登陆授权请求
    }
    else {
        //未安装微信处理
    }
}

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        if (temp.errCode == 0) {
            //用户同意授权
            NSString *URL = @"https://api.weixin.qq.com/sns/oauth2/access_token?";
            NSDictionary *dict = @{
                                   @"appid":WX_APPID,
                                   @"secret":WXAPPKEYSECRET,
                                   @"code":temp.code,
                                   @"grant_type":@"authorization_code"
                                   };
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            
            NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [TTUserManager sharedInstance].currentUser.accessToken = responseObject[@"access_token"];
                [TTUserManager sharedInstance].currentUser.refreshToken = responseObject[@"refresh_token"];
                [TTUserManager sharedInstance].currentUser.expires_in = responseObject[@"expires_in"];
                [TTUserManager sharedInstance].currentUser.scope = responseObject[@"scope"];
                [TTUserManager sharedInstance].currentUser.unionid = responseObject[@"unionid"];
                [TTUserManager sharedInstance].currentUser.openid = responseObject[@"openid"];
                [TTUserManager sharedInstance].currentUser.openId = responseObject[@"openid"];
                
                [self getUserInfoFromWechat];
            } failure:nil];
            [dataTask resume];
            
        }
        else {
            
        }
    }
}

- (void)getUserInfoFromWechat {
    
    NSString *URL = @"https://api.weixin.qq.com/sns/userinfo?";
    NSDictionary *dict = @{
                           @"access_token":[TTUserManager sharedInstance].currentUser.accessToken,
                           @"openid":[TTUserManager sharedInstance].currentUser.openid,
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [TTUserManager sharedInstance].currentUser.headImgUrl = responseObject[@"headimgurl"];
        [TTUserManager sharedInstance].currentUser.name = responseObject[@"nickname"];
        [self getExtraUserInfo];
        
    } failure:nil];
    [dataTask resume];
    
}


#pragma mark - 手机号登陆
- (void)signin {
    [[TTUserManager sharedInstance] clearCurrentUserInfo];
    
    
    NSDictionary *dict = @{
                           @"mobile":self.acountF.text,
                           @"passwd":self.passwordF.text,
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForLogin] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [TTUserManager sharedInstance].currentUser.headImgUrl = responseObject[@"headImgUrl"];
            [TTUserManager sharedInstance].currentUser.name = responseObject[@"name"];
            [TTUserManager sharedInstance].currentUser.openId = responseObject[@"openId"];
            [self getExtraUserInfo];
            
        }
        else {
            [XWHUDManager showWarningTipHUDInView:@"用户名或密码错误"];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

#pragma mark - 最终登陆汇总
- (void)getExtraUserInfo {
    
    NSDictionary *dict = @{
                           @"openID":[TTUserManager sharedInstance].currentUser.openId,
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForGetUserExt] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"] != [NSNull null]) {
                [TTUserManager sharedInstance].currentUser.grade = [responseObject[@"datas"] valueForKey:@"grade"];
                [TTUserManager sharedInstance].currentUser.bonusPoint = [responseObject[@"datas"] valueForKey:@"bonusPoint"];
                [TTUserManager sharedInstance].currentUser.city = [responseObject[@"datas"] valueForKey:@"city"];
                [TTUserManager sharedInstance].currentUser.createTime = [responseObject[@"datas"] valueForKey:@"creatTime"];
                [TTUserManager sharedInstance].currentUser.level = [responseObject[@"datas"] valueForKey:@"level"];
                [TTUserManager sharedInstance].currentUser.schoolName = [responseObject[@"datas"] valueForKey:@"schoolName"];
                [TTUserManager sharedInstance].currentUser.qqkey = [responseObject[@"datas"] valueForKey:@"qqkey"];
                [TTUserManager sharedInstance].currentUser.updateTime = [responseObject[@"datas"] valueForKey:@"updateTime"];
            }
            [self loginSuccess];
        }
        else {
            //登陆失败
        }
        
    } failure:nil];
    [dataTask resume];
}

- (void)loginSuccess {
    [XWHUDManager showSuccessTipHUD:@"登陆成功"];
    [TTUserManager sharedInstance].isLogin = YES;
    [[TTUserManager sharedInstance]saveLoginUserInfo];
    [[TTUserManager sharedInstance]loadCurrentUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    
    if ([TTUserManager sharedInstance].currentUser.grade) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationController pushViewController:[[FillOthersViewController alloc] init] animated:YES];
    }
    
}


#pragma mark - 跳转页面
//注册账号
- (void)signup {
    SingUpViewController *singUp = [[SingUpViewController alloc] init];
    [self.navigationController pushViewController:singUp animated:YES];
}

//忘记密码
- (void)forget {
    ForgetPwdViewController *forgetPwd = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetPwd animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
