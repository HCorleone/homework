//
//  LoginViewController.m
//  sw-reader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassViewController.h"
#import "EnrollViewController.h"
#import "LoginView.h"
#import "NetEaseMailController.h"
#import "YDUSerModel.h"
#import "YDUserManager.h"
#import "HttpUtil.h"
#import "WebViewController.h"
#import "SqlForFMDB.h"
#import "NSUserDefaultsUtil.h"
#import "RDVTabBarController.h"
#import "UIImageView+WebCaChe.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UIViewLinkmanTouch.h"

#define WeiBoUserInfoURL @"https://api.weibo.com/2/users/show.json"
#define DKColor_BACKGROUND_LOGIN DKColorWithRGB(0xFAFAFA, 0x28282A);

@interface LoginViewController () <WeiboSDKDelegate, WXApiDelegate>
{
    UITextField *passLabel;
    UITextField *phoneLabel;
    LoginView *loginview;
    UILabel *enrollLabel;
    UILabel *forgetLabel;
}
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, weak) UIImageView *appImgView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSDictionary *loginDict;
@property (nonatomic, strong) SqlForFMDB *sqlFMDB;
@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"LoginViewController"];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];

    //登录之前补发单词本的log记录
    //    [self sendWordsLog];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginViewController"];
}

- (void)viewDidLoad {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

    [super viewDidLoad];
    
    //设置导航条
    [self setUpNavBar];
    
    //设置界面
    [self setUpViews];
    
    self.sqlFMDB = [[SqlForFMDB alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - functions
- (void)setUpViews {
    //把登录的view都放在scrollview里面
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view .backgroundColor = [XUtil hexToRGB:@"ecf0f1"];
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    CGFloat qqLoginViewX = 20*Main_Screen_Width/640;
    CGFloat qqLoginViewH = 40;

    phoneLabel = [[UITextField alloc]init];
//    phoneLabel.borderStyle = UITextBorderStyleLine;// 设置文本框边框
    phoneLabel.clearsOnBeginEditing = YES;// 在开始编辑的时候清除上次余留的文本
    phoneLabel.tag = 101;
    phoneLabel.delegate = self;
    phoneLabel.adjustsFontSizeToFitWidth = YES;
    phoneLabel.placeholder = @"请输入手机号"; // 提示输入信息
    passLabel.clearButtonMode = UITextBorderStyleNone;// 右侧清除按钮
    [XUtil setTextFieldLeftPadding:phoneLabel forWidth:10];
    [contentView addSubview:phoneLabel];
    phoneLabel.layer.borderColor = [XUtil hexToRGB:@"dedede"].CGColor;
    phoneLabel.layer.borderWidth = 1;
    phoneLabel.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    phoneLabel.returnKeyType = UIReturnKeyDone;// return键名替换
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(contentView.mas_top).with.offset(qqLoginViewH);
    }];
    
    passLabel = [[UITextField alloc]init];
    passLabel.layer.borderColor = [XUtil hexToRGB:@"dedede"].CGColor;
    passLabel.layer.borderWidth = 1;
    passLabel.clearsOnBeginEditing = YES;// 在开始编辑的时候清除上次余留的文本
    passLabel.tag = 102;
    passLabel.delegate = self;
    [XUtil setTextFieldLeftPadding:passLabel forWidth:10];
    passLabel.secureTextEntry = YES;
    passLabel.adjustsFontSizeToFitWidth = YES;
    passLabel.placeholder = @"请输入密码"; // 提示输入信息
    [contentView addSubview:passLabel];
    passLabel.clearButtonMode = UITextBorderStyleNone;// 右侧清除按钮
    passLabel.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    passLabel.returnKeyType = UIReturnKeyDone;// return键名替换
    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(phoneLabel.mas_bottom).with.offset(qqLoginViewX);
    }];

    
    loginview = [[LoginView alloc] init];
    [self.view addSubview:loginview];
    loginview.backgroundColor = [XUtil hexToRGB:@"01A7F1"];
    loginview.typeLabel.text = @"登录";
    loginview.typeLabel.font = font18;
    loginview.noImg = YES;
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLogin)];
    [loginview addGestureRecognizer:loginTap];
    [loginview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(passLabel.mas_bottom).with.offset(qqLoginViewX*2);
    }];
    
    enrollLabel = [[UILabel alloc]init];
    enrollLabel.text = @"注册账号";
    enrollLabel.textColor = [XUtil hexToRGB:@"808080"];
    [contentView addSubview:enrollLabel];
    CGSize size1 = [XUtil sizeWithString:enrollLabel.text font:font14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UITapGestureRecognizer *enrolltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toEnroll)];
    [enrollLabel addGestureRecognizer:enrolltap];
    enrollLabel.font = font14;
    [enrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(size1.width*1.5, qqLoginViewH));
        make.top.mas_equalTo(loginview.mas_bottom).with.offset(qqLoginViewX);
    }];
    enrollLabel.userInteractionEnabled = YES;
    
    forgetLabel = [[UILabel alloc]init];
    forgetLabel.text = @"忘记密码？";
    forgetLabel.adjustsFontSizeToFitWidth = YES;
    forgetLabel.userInteractionEnabled = YES;
    forgetLabel.textColor = [XUtil hexToRGB:@"808080"];
    [contentView addSubview:forgetLabel];
    CGSize size2 = [XUtil sizeWithString:forgetLabel.text font:font14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UITapGestureRecognizer *forgettap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toForget)];
    [forgetLabel addGestureRecognizer:forgettap];
    forgetLabel.font = font14;
    [forgetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).with.offset(-qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(size2.width, qqLoginViewH));
        make.top.mas_equalTo(loginview.mas_bottom).with.offset(qqLoginViewX);
    }];

    
    
    //QQ登录
    CGFloat qqLoginViewT = Main_Screen_Height -kTopBarHeight -kStatusBarHeight - qqLoginViewH - qqLoginViewX;
    CGFloat qqLoginViewW = (Main_Screen_Width - qqLoginViewX*4)/3;
    LoginView *qqLoginView = [[LoginView alloc] init];
    qqLoginView.typeLabel.text = @"QQ登录";
    qqLoginView.iconImgView.image = [UIImage imageNamed:@"qq_icon_white"];
    UITapGestureRecognizer *qqLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toQQLogin:)];
    [qqLoginView addGestureRecognizer:qqLogin];
    [contentView addSubview:qqLoginView];
    [qqLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(qqLoginViewW, qqLoginViewH));
        make.top.mas_equalTo(0).with.offset(qqLoginViewT);
    }];
    qqLoginView.backgroundColor = [XUtil hexToRGB:@"61A2EE"];
    
    //新浪微博登录
    LoginView *sinaWeiBoLoginView = [[LoginView alloc] init];
    sinaWeiBoLoginView.typeLabel.text = @"微博登录";
    sinaWeiBoLoginView.iconImgView.image = [UIImage imageNamed:@"weibo_white"];
    UITapGestureRecognizer *sinaWeiBoLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSinaWeiBoLogin:)];
    [sinaWeiBoLoginView addGestureRecognizer:sinaWeiBoLogin];
    [contentView addSubview:sinaWeiBoLoginView];
    
    [sinaWeiBoLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqLoginView.mas_right).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(qqLoginViewW, qqLoginViewH));
        make.top.mas_equalTo(0).with.offset(qqLoginViewT);
    }];
    
    sinaWeiBoLoginView.backgroundColor = [XUtil hexToRGB:@"ED5C5C"];;
    
    //微信登录
    LoginView *wechatLoginView = [[LoginView alloc] init];
    wechatLoginView.typeLabel.text = @"微信登录";
    wechatLoginView.iconImgView.image = [UIImage imageNamed:@"weixin_white"];
    UITapGestureRecognizer *wechatLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toWeChatLogin:)];
    [wechatLoginView addGestureRecognizer:wechatLogin];
    [contentView addSubview:wechatLoginView];
    [wechatLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sinaWeiBoLoginView.mas_right).with.offset(qqLoginViewX );
        make.size.mas_equalTo(CGSizeMake(qqLoginViewW, qqLoginViewH));
        make.top.mas_equalTo(0).with.offset(qqLoginViewT);
    }];
    wechatLoginView.backgroundColor = [XUtil hexToRGB:@"15CF77"];
    
    if(![WXApi isWXAppInstalled] || [[UrlBuild getAppName] isEqualToString:@"英语听力"]|| [[UrlBuild getAppName] isEqualToString:@"英语阅读"]){
        wechatLoginView.hidden = YES;
    }
    
    if([[UrlBuild getAppName] isEqualToString:@"英语百科"] || [[UrlBuild getAppName] isEqualToString:@"英语视频"] ||[[UrlBuild getAppName] isEqualToString:@"英语听力"]|| [[UrlBuild getAppName] isEqualToString:@"英语阅读"]){
        sinaWeiBoLoginView.hidden = YES;
    }
    
    
    //标题
    UILabel *titleLabel = [UILabel new];
    [contentView addSubview:titleLabel];
    titleLabel.textColor = [XUtil hexToRGB:@"333333"];
    titleLabel.text = @"还可以选择以下方式登录";
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = font14;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [XUtil sizeWithString:titleLabel.text font:font14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.bottom.mas_equalTo(qqLoginView.mas_top).with.offset(-Main_Screen_Height * 20 / 1136);
    }];
    
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(qqLoginView.mas_bottom).with.offset(2 * Main_Screen_Height / 1136);
    }];

}

-(void)toEnroll{
    EnrollViewController *con = [[EnrollViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)toForget{
    ForgetPassViewController *con = [[ForgetPassViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)toLogin{
    [[YDUserManager sharedInstance] clearCurrentUserInfo];
    NSString *pass = passLabel.text;
    NSString *mobile = phoneLabel.text;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(![XUtil validPhone:mobile]){
        [MBProgressHUD showError:@"手机号格式不对"];
        return;
    }
    if(![XUtil validPass:pass]){
        [MBProgressHUD showError:@"密码至少6位"];
        return;
    }
    [YDUserManager sharedInstance].currentUser.passwd = pass;
    [YDUserManager sharedInstance].currentUser.mobile = mobile;
    
    //登录成功后请求用户数据
    AFHTTPSessionManager *manager = [HttpUtil initializeHttpManager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"passwd"] = [YDUserManager sharedInstance].currentUser.passwd;
    param[@"mobile"] = [YDUserManager sharedInstance].currentUser.mobile;
    [manager GET:[Consts USER_TATA_Login] parameters:param success:^(NSURLSessionTask *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSString *code =[NSString stringWithFormat:@"%@",responseDic[@"code"]];
        if([@"200" isEqualToString:code]){
            [YDUserManager sharedInstance].currentUser.avatarImage = responseDic[@"headImgUrl"];
            [YDUserManager sharedInstance].currentUser.nickName = responseDic[@"name"];
            [YDUserManager sharedInstance].currentUser.openid = responseDic[@"openId"];
            [YDUserManager sharedInstance].currentUser.userID = responseDic[@"openId"];

            [YDUserManager sharedInstance].currentUser.typeLogin = TypeLoginTata;
            self.loginDict = responseDic;
            [self loginSuccess];
            YDLog(@"%@", responseDic);
        }else{
            NSString *msg =responseDic[@"msg"];
            [MBProgressHUD showError:msg];
        }
      
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD showError:@"登录失败"];
    }];

}

- (void)setUpNavBar{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGSize barSize = CGSizeMake(25,25);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width * 82 /640, kTopBarHeight)];
    UIImageView *leftPicView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kTopBarHeight - barSize.height - 9, barSize.width, barSize.height)];
    [leftPicView setImage:[UIImage imageNamed:@"back"]];
    [leftView addSubview:leftPicView];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backIndex)];
    [leftView addGestureRecognizer:leftTap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = font16;
    titleLabel.textColor = [XUtil hexToRGB:@"666666"];
    NSString *titleStr = @"登录账号";
    CGSize titleStrSize = [XUtil sizeWithString:titleStr font:font16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    titleLabel.frame = CGRectMake(0,50, titleStrSize.width,titleStrSize.height);
    titleLabel.text = titleStr;
    self.navigationItem.titleView = titleLabel;
}

-(void) backIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击屏幕，让键盘弹回
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}


//新浪微博登录
- (void)toSinaWeiBoLogin:(UITapGestureRecognizer *)ges{
    [[YDUserManager sharedInstance] clearCurrentUserInfo];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaWeiBoRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
#pragma mark - 新浪微博登录回调代理
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    YDLog(@"%ld", (long)request.userInfo);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    YDLog(@"%ld", (long)response.statusCode);
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            
            [YDUserManager sharedInstance].currentUser.accessToken = [(WBAuthorizeResponse *)response accessToken];
            [YDUserManager sharedInstance].currentUser.userID = [(WBAuthorizeResponse *)response userID];
            [YDUserManager sharedInstance].currentUser.refreshToken = [(WBAuthorizeResponse *)response refreshToken];
            
            //登录成功后请求用户数据
            AFHTTPSessionManager *manager = [HttpUtil initializeHttpManager];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"access_token"] = [YDUserManager sharedInstance].currentUser.accessToken;
            param[@"uid"] = [YDUserManager sharedInstance].currentUser.userID;
            [manager GET:WeiBoUserInfoURL parameters:param success:^(NSURLSessionTask *operation, id responseObject) {
                NSError *error = nil;
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                YDLog(@"weibo response:%@", responseDic);
                [YDUserManager sharedInstance].currentUser.avatarImage = responseDic[@"avatar_large"];
                [YDUserManager sharedInstance].currentUser.nickName = responseDic[@"screen_name"];
                [YDUserManager sharedInstance].currentUser.userDescription = responseDic[@"description"];
                NSString *userSex = responseDic[@"gender"];
                if ([userSex isEqualToString:@"m"]) {
                    [YDUserManager sharedInstance].currentUser.gender = @"男";
                }else if ([userSex isEqualToString:@"f"]){
                    [YDUserManager sharedInstance].currentUser.gender = @"女";
                }else{
                    [YDUserManager sharedInstance].currentUser.gender = @"保密";
                }
                [YDUserManager sharedInstance].currentUser.city = responseDic[@"city"];
                [YDUserManager sharedInstance].currentUser.province = responseDic[@"province"];
                //微博返回数据没有country
                [YDUserManager sharedInstance].currentUser.country = @"";
                [YDUserManager sharedInstance].currentUser.typeLogin = TypeLoginFromWeibo;
                self.loginDict = responseDic;
                [self loginSuccess];
                YDLog(@"%@", responseDic);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [MBProgressHUD showError:@"获取用户信息失败"];
            }];
        }else {
            //            [MBProgressHUD showError:@"登录失败"];
        }
    }
}


//QQ登录
- (void)toQQLogin:(UITapGestureRecognizer *)ges{
    [[YDUserManager sharedInstance] clearCurrentUserInfo];
    NSArray *permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    
//    [self.tencentOAuth setAuthShareType:AuthShareType_QQ];
    [self.tencentOAuth authorize:permissions inSafari:NO];
}
#pragma mark - QQ登录回调代理

//登录成功：
- (void)tencentDidLogin {
    YDLog(@"登录完成");
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *result = [NSString stringWithFormat:@"accessToken:%@\nopenId:%@", _tencentOAuth.accessToken, _tencentOAuth.openId];
        YDLog(@"%@", result);
        [self.tencentOAuth getUserInfo];
    }
    else
    {
        YDLog(@"登录不成功 没有获取accesstoken");
    }
}

//非网络错误导致登录失败：
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled)
    {
        YDLog(@"用户取消登录");
    }
    else
    {
        YDLog(@"登录失败");
    }
}

//网络错误导致登录失败：
- (void)tencentDidNotNetWork {
    YDLog(@"无网络连接，请设置网络");
}

//退出登录
- (void)tencentDidLogout {
    YDLog(@"用户退出登录");
}

//获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        NSMutableString *str = [NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse) {
            [str appendString: [NSString stringWithFormat:
                                @"%@:%@\n", key, [response.jsonResponse objectForKey:key]]];
        }
        YDLog(@"QQ Response:%@", response.jsonResponse);
        [YDUserManager sharedInstance].currentUser.accessToken = self.tencentOAuth.accessToken;
        [YDUserManager sharedInstance].currentUser.userID = self.tencentOAuth.openId;
        [YDUserManager sharedInstance].currentUser.expirationDate = self.tencentOAuth.expirationDate;
        [YDUserManager sharedInstance].currentUser.nickName = response.jsonResponse[@"nickname"];
        [YDUserManager sharedInstance].currentUser.avatarImage = response.jsonResponse[@"figureurl_qq_2"];
        [YDUserManager sharedInstance].currentUser.gender = response.jsonResponse[@"gender"];
        [YDUserManager sharedInstance].currentUser.city = response.jsonResponse[@"city"];
        [YDUserManager sharedInstance].currentUser.province = response.jsonResponse[@"province"];
        //QQ返回没有country
        [YDUserManager sharedInstance].currentUser.country = @"";
        [YDUserManager sharedInstance].currentUser.typeLogin = TypeLoginFromQQ;
        self.loginDict = response.jsonResponse;
        [self loginSuccess];
    } else {
        [MBProgressHUD showCustomMessage:@"登录失败" toView:self.view];
    }
}

//微信登录
- (void)toWeChatLogin:(UITapGestureRecognizer *)ges{
#warning 这里需要判断是否要更新
    [[YDUserManager sharedInstance] clearCurrentUserInfo];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];
    }
    else {
        [WXApi sendAuthReq:req viewController:self delegate:self
         ];
        YDLog(@"未安装微信");
    }
}

#pragma mark - 微信登录回调代理
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}



-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        if (temp.errCode == 0) {
            //用户同意授权
            AFHTTPSessionManager *manager = [HttpUtil initializeHttpManager];
            NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWeChatURL, kWeChatAppID, kWeChatAppKeySecret, temp.code];
            [manager GET:accessUrlStr parameters:nil success:^(NSURLSessionTask *operation, id responseObject) {
                NSError *error = nil;
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                
                [YDUserManager sharedInstance].currentUser.accessToken = responseDic[@"access_token"];
                [YDUserManager sharedInstance].currentUser.userID = responseDic[@"openid"];
                [YDUserManager sharedInstance].currentUser.refreshToken = responseDic[@"refresh_token"];
                [YDUserManager sharedInstance].currentUser.expires_in = responseDic[@"expires_in"];
                [YDUserManager sharedInstance].currentUser.scope = responseDic[@"scope"];
                [YDUserManager sharedInstance].currentUser.unionid = responseDic[@"unionid"];
                [YDUserManager sharedInstance].currentUser.openid = responseDic[@"openid"];
                YDLog(@"请求access的response = %@", responseDic);
                self.loginDict = responseDic;
                [self wechatLoginByRequesphoneLabelorUserInfo];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                YDLog(@"获取access_token时出错 = %@", error);
                [MBProgressHUD showCustomMessage:@"登录失败" toView:self.view];
            }];
        }else {
            //用户拒绝
            [MBProgressHUD showCustomMessage:@"登录失败" toView:self.view];
        }
    }
}

- (void)wechatLoginByRequesphoneLabelorUserInfo {
    AFHTTPSessionManager *manager = [HttpUtil initializeHttpManager];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", kWeChatURL, [YDUserManager sharedInstance].currentUser.accessToken, [YDUserManager sharedInstance].currentUser.userID];
    // 请求用户数据
    [manager GET:userUrlStr parameters:nil success:^(NSURLSessionTask *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        [YDUserManager sharedInstance].currentUser.nickName = responseDic[@"nickname"];
        [YDUserManager sharedInstance].currentUser.avatarImage = responseDic[@"headimgurl"];
        NSString *sexStr = [NSString stringWithFormat:@"%@", responseDic[@"sex"]];
        if ([sexStr isEqualToString:@"1"]) {
            [YDUserManager sharedInstance].currentUser.gender = @"男";
        }else if ([sexStr isEqualToString:@"2"]){
            [YDUserManager sharedInstance].currentUser.gender = @"女";
        }else{
            [YDUserManager sharedInstance].currentUser.gender = @"保密";
        }
        [YDUserManager sharedInstance].currentUser.city = responseDic[@"city"];
        [YDUserManager sharedInstance].currentUser.province = responseDic[@"province"];
        [YDUserManager sharedInstance].currentUser.country = responseDic[@"country"];
        [YDUserManager sharedInstance].currentUser.typeLogin = TypeLoginFromWeChat;
        [self loginSuccess];
        YDLog(@"%@", responseDic);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD showCustomMessage:@"获取用户信息失败" toView:self.view];
    }];
}

- (void)loginSuccess {
    NSString *loginType = @"";
    switch ([YDUserManager sharedInstance].currentUser.typeLogin) {
        case TypeLoginFromWeibo:{
            loginType = @"weibo";
            break;
        }
        case TypeLoginFromQQ:{
            loginType = @"qq";
            break;
        }
        case TypeLoginFromWeChat:{
            loginType = @"weixin";
            break;
        }
        case TypeLoginFromNetEaseMail:{
            loginType = @"netease";
            break;
        }
        case TypeLoginFromOther:{
            
            break;
        }
            
        default:
            break;
    }
    [YDUserManager sharedInstance].isLogin = YES;
    [YDUserManager sharedInstance].currentUser.loginType = loginType;
    //登录成功后保存当前用户信息，同时读取看看有没有历史保存过当前用户的个人信息
    [[YDUserManager sharedInstance] saveLoginUserInfo];
    [[YDUserManager sharedInstance] loadCurrentUserInfo];
    [self updateToken];
    [self sendLogin];
    [self handleListenDownloads];
    [self handleListenCollects];
    [self handleBaikeCollects];
    [self handleReadCollects];
    [MBProgressHUD showMessage:@"登录成功" toView:self.view];
}

-(void) updateToken{
    NSString *url = [Consts USER_Token];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
    YDUserModel *user = [YDUserManager sharedInstance].currentUser;
    param[@"openId"] = [BYHttpTool handleStr:user.userID];
    param[@"loginType"] = [BYHttpTool handleStr:user.loginType];
    
    [BYHttpTool POST:url parameters:param success:^(NSDictionary *responseDict) {
        YDLog(@"login response:%@", responseDict);
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void) sendLogin{
    NSString *url = [Consts USER_Login];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
    if (self.loginDict) {
        for (id akey in [self.loginDict allKeys]) {
            param[akey] = [self.loginDict objectForKey:akey];
        }
    }
    YDUserModel *user = [YDUserManager sharedInstance].currentUser;
    param[@"openId"] = [BYHttpTool handleStr:user.userID];
    param[@"method"] = @"login";
    param[@"loginType"] = [BYHttpTool handleStr:user.loginType];
    param[@"imei"] = [[UIDevice currentDevice].identifierForVendor UUIDString];
    param[@"username"] = [BYHttpTool handleStr:user.nickName];
    param[@"nickname"] = [BYHttpTool handleStr:user.nickName];
    
    if ([user.gender isEqualToString:@"男"]) {
        param[@"sex"] = @"0";
    }else if ([user.gender isEqualToString:@"女"]){
        param[@"sex"] = @"1";
    }else{
        param[@"sex"] = @"-1";
    }
    param[@"headImgUrl"] = [BYHttpTool handleStr:user.avatarImage];
    param[@"city"] = [BYHttpTool handleStr:user.city];
    param[@"province"] = [BYHttpTool handleStr:user.province];
    param[@"age"] = [BYHttpTool handleStr:user.age];
    param[@"country"] = [BYHttpTool handleStr:user.country];
    param[@"birthday"] = [BYHttpTool handleStr:user.birthday];
    param[@"unionId"] = [BYHttpTool handleStr:user.unionid];
    
    [BYHttpTool POST:url parameters:param success:^(NSDictionary *responseDict) {
        YDLog(@"login response:%@", responseDict);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self backIndex];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


-(void)handleListenCollects{
    NSString *url = [Consts USER_PROFILE];
    url = [url stringByAppendingString:@"&type=listen_favor"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
    
    YDUserModel *user = [YDUserManager sharedInstance].currentUser;
    param[@"openId"] = [BYHttpTool handleStr:user.userID];
    param[@"loginType"] = [BYHttpTool handleStr:user.loginType];
    param[@"values"] = [NSUserDefaultsUtil getStringObject:@"collects"];
    
    [BYHttpTool POST:url parameters:param success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
    }];
}

-(void)handleListenDownloads{
    NSString *url = [Consts USER_PROFILE];
    url = [url stringByAppendingString:@"&type=listen_download"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
    
    YDUserModel *user = [YDUserManager sharedInstance].currentUser;
    param[@"openId"] = [BYHttpTool handleStr:user.userID];
    param[@"loginType"] = [BYHttpTool handleStr:user.loginType];
    param[@"values"] = [NSUserDefaultsUtil getStringObject:@"downloads"];
    
    [BYHttpTool POST:url parameters:param success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
    }];
}

-(void)handleBaikeCollects{
    NSString *url = [Consts USER_PROFILE];
    url = [url stringByAppendingString:@"&type=baike_favor"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
    
    YDUserModel *user = [YDUserManager sharedInstance].currentUser;
    param[@"openId"] = [BYHttpTool handleStr:user.userID];
    param[@"loginType"] = [BYHttpTool handleStr:user.loginType];
    param[@"values"] = [NSUserDefaultsUtil getStringObject:@"baikecollects"];
    
    [BYHttpTool POST:url parameters:param success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
    }];
}

-(void)handleReadCollects{
    NSString *url = [Consts USER_PROFILE];
    url = [url stringByAppendingString:@"&type=read_favor"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
    
    YDUserModel *user = [YDUserManager sharedInstance].currentUser;
    param[@"openId"] = [BYHttpTool handleStr:user.userID];
    param[@"loginType"] = [BYHttpTool handleStr:user.loginType];
    param[@"values"] = [NSUserDefaultsUtil getStringObject:@"readcollects"];
    
    [BYHttpTool POST:url parameters:param success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark -屏幕恢复
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    [textField endEditing:YES];
    
}

//点击完成，隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
