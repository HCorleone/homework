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
#import "YTQGetUserManager.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) NSDictionary *loginDict;
@property (nonatomic, strong) UITextField *acountF;
@property (nonatomic, strong) UITextField *passwordF;

@end

@implementation LoginViewController

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
    
    [self setupLoginView];
    [self thirdPartLogin];
}
- (void)thirdPartLogin {
    //第三方登录标题
    UILabel *thirdPart = [[UILabel alloc]init];
    thirdPart.text = @"第三方登录";
    thirdPart.textColor = whitecolor;
    thirdPart.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdPart];
    [thirdPart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 10));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(25);
    }];
    //横线
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"第三方登录-渐变分割线"]];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(thirdPart.mas_bottom).with.offset(25);
    }];
    //QQ登录
    UIImageView *qqLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qq"]];
    qqLogo.userInteractionEnabled = YES;
    [self.view addSubview:qqLogo];
    [qqLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(-50);
        make.top.mas_equalTo(line.mas_bottom).with.offset(25);
    }];
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = qqLogo.frame;
    qqBtn.backgroundColor = [UIColor clearColor];
    [qqLogo addSubview:qqBtn];
    [qqBtn addTarget:self action:@selector(qqUser) forControlEvents:UIControlEventTouchUpInside];
    
    
    //微信登录
    UIImageView *wechatLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信"]];
    wechatLogo.userInteractionEnabled = YES;
    [self.view addSubview:wechatLogo];
    [wechatLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(50);
        make.top.mas_equalTo(line.mas_bottom).with.offset(25);
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
    [[TTUserManager sharedInstance] clearCurrentUserInfo];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"HA_APP";
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];
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
        [self loginSuccess];
        
    } failure:nil];
    [dataTask resume];
    
}

#pragma functions
- (void)setupLoginView {
    //登陆框
    UIView *loginView = [[UIView alloc]init];
    loginView.layer.borderWidth = 1;
    loginView.layer.borderColor = whitecolor.CGColor;
    loginView.layer.cornerRadius = 2;
    loginView.layer.opacity = 0.9;
    loginView.layer.masksToBounds = YES;
    loginView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(0.2 * screenHeight);
    }];
    self.loginView = loginView;
    //帐号框
    LoginTextField *acountF = [[LoginTextField alloc]init:@"请输入手机号"];
    [loginView addSubview:acountF];
    [acountF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.centerX.mas_equalTo(loginView);
        make.top.mas_equalTo(loginView).with.offset(50);
    }];
    self.acountF = acountF;
    
    //密码框
    LoginTextField *passwordF = [[LoginTextField alloc]init:@"请输入密码"];
    passwordF.secureTextEntry = YES;//暗文
    [loginView addSubview:passwordF];
    passwordF.secureTextEntry = YES;
    [passwordF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.centerX.mas_equalTo(loginView);
        make.top.mas_equalTo(acountF.mas_bottom).with.offset(15);
    }];
    self.passwordF = passwordF;
    
    //登陆按钮
    UIButton *signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signinBtn.layer.cornerRadius = 10;
    signinBtn.layer.shadowOffset =  CGSizeMake(0, 1);
    signinBtn.layer.shadowOpacity = 1;
    signinBtn.layer.shadowColor =  [UIColor colorWithHexString:@"#2983C8"].CGColor;
    signinBtn.backgroundColor = [UIColor colorWithHexString:@"#6FDDFF"];
    [loginView addSubview:signinBtn];
    [signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.centerX.mas_equalTo(loginView);
        make.top.mas_equalTo(passwordF.mas_bottom).with.offset(25);
    }];
    [signinBtn setTitle:@"登录" forState:UIControlStateNormal];
    [signinBtn addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
    
    //注册账户
    UIButton *signupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:signupBtn];
    [signupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signinBtn);
        make.top.mas_equalTo(signinBtn.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    signupBtn.backgroundColor = [UIColor clearColor];
    [signupBtn setTitle:@"注册帐号" forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(signinBtn);
        make.top.mas_equalTo(signinBtn.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - 手机号登陆
- (void)signin {
    [[TTUserManager sharedInstance] clearCurrentUserInfo];
    
    NSString *URL = @"http://ecomment.tatatimes.com/tataeraapi/api.s?";
    
    NSDictionary *dict = @{
                           @"h":@"LoginTataUserHandler",
                           @"mobile":self.acountF.text,
                           @"passwd":self.passwordF.text,
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [TTUserManager sharedInstance].currentUser.headImgUrl = responseObject[@"headImgUrl"];
            [TTUserManager sharedInstance].currentUser.name = responseObject[@"name"];
            [TTUserManager sharedInstance].currentUser.openId = responseObject[@"openId"];
            [self loginSuccess];
            
        }
        else {
            //登陆失败
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)loginSuccess {
    [TTUserManager sharedInstance].isLogin = YES;
    [[TTUserManager sharedInstance]saveLoginUserInfo];
    [[TTUserManager sharedInstance]loadCurrentUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    
    __weak typeof(self) weakSelf = self;
    [[YTQGetUserManager alloc] getUserManager:^(NSMutableDictionary * _Nonnull dic) {
        if ([dic valueForKey:@"grade"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [weakSelf.navigationController pushViewController:[[FillOthersViewController alloc] init] animated:YES];
        }
        
    }];
    NSLog(@"发送用户登陆成功的通知");
//    [self backToVc];
    
}

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

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

@end
