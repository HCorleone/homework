//
//  LoginViewController.m
//  sw-reader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "EnrollViewController.h"
#import "LoginView.h"
#import "YDUSerModel.h"
#import "YDUserManager.h"
#import "HttpUtil.h"
#import "NSUserDefaultsUtil.h"
#import "UIViewLinkmanTouch.h"

@interface EnrollViewController ()
{
    UITextField *passLabel;
    UITextField *nameLabel;
    UITextField *phoneLabel;
    UITextField *codeLabel;
    LoginView *codeview;
    LoginView *enrollView;
    
    NSTimer *upTimer;
    NSInteger leftTime;
}
@property (nonatomic, strong) UIScrollView* scrollView;
@end

@implementation EnrollViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"LoginViewController"];
    
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
    phoneLabel.borderStyle = UITextBorderStyleLine;// 设置文本框边框
    phoneLabel.clearsOnBeginEditing = YES;// 在开始编辑的时候清除上次余留的文本
    phoneLabel.tag = 101;
    phoneLabel.delegate = self;
    phoneLabel.adjustsFontSizeToFitWidth = YES;
    phoneLabel.placeholder = @"请输入手机号"; // 提示输入信息
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
    
    nameLabel = [[UITextField alloc]init];
    nameLabel.borderStyle = UITextBorderStyleLine;// 设置文本框边框
    nameLabel.clearsOnBeginEditing = YES;// 在开始编辑的时候清除上次余留的文本
    nameLabel.tag = 101;
    nameLabel.delegate = self;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.placeholder = @"请输入昵称"; // 提示输入信息
    [XUtil setTextFieldLeftPadding:nameLabel forWidth:10];
    [contentView addSubview:nameLabel];
    nameLabel.layer.borderColor = [XUtil hexToRGB:@"dedede"].CGColor;
    nameLabel.layer.borderWidth = 1;
    nameLabel.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    nameLabel.returnKeyType = UIReturnKeyDone;// return键名替换
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(phoneLabel.mas_bottom).with.offset(qqLoginViewX);
    }];

    
    passLabel = [[UITextField alloc]init];
    passLabel.layer.borderColor = [XUtil hexToRGB:@"dedede"].CGColor;
    passLabel.layer.borderWidth = 1;
    passLabel.clearsOnBeginEditing = YES;// 在开始编辑的时候清除上次余留的文本
    passLabel.tag = 102;
    passLabel.delegate = self;
    passLabel.secureTextEntry = YES;
    passLabel.adjustsFontSizeToFitWidth = YES;
    passLabel.placeholder = @"请输入密码"; // 提示输入信息
    [XUtil setTextFieldLeftPadding:passLabel forWidth:10];
    [contentView addSubview:passLabel];
    passLabel.clearButtonMode = UITextBorderStyleNone;// 右侧清除按钮
    passLabel.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    passLabel.returnKeyType = UIReturnKeyDone;// return键名替换
    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(nameLabel.mas_bottom).with.offset(qqLoginViewX);
    }];
    
    codeLabel = [[UITextField alloc]init];
    codeLabel.borderStyle = UITextBorderStyleLine;// 设置文本框边框
    codeLabel.clearsOnBeginEditing = YES;// 在开始编辑的时候清除上次余留的文本
    codeLabel.tag = 101;
    codeLabel.delegate = self;
    codeLabel.adjustsFontSizeToFitWidth = YES;
    codeLabel.placeholder = @"请输入验证码"; // 提示输入信息
    [XUtil setTextFieldLeftPadding:codeLabel forWidth:10];
    [contentView addSubview:codeLabel];
    codeLabel.layer.borderColor = [XUtil hexToRGB:@"dedede"].CGColor;
    codeLabel.layer.borderWidth = 1;
    codeLabel.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    codeLabel.returnKeyType = UIReturnKeyDone;// return键名替换
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width*3/5 - qqLoginViewX, qqLoginViewH));
        make.top.mas_equalTo(passLabel.mas_bottom).with.offset(qqLoginViewX);
    }];

    codeview = [[LoginView alloc] init];
    [self.view addSubview:codeview];
    codeview.backgroundColor = [XUtil hexToRGB:@"01A7F1"];
    codeview.typeLabel.text = @"获取验证码";
    codeview.typeLabel.font = font14;
    codeview.typeLabel.centerX = codeview.centerX;
    codeview.noImg = YES;
    UITapGestureRecognizer *codeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toCode)];
    [codeview addGestureRecognizer:codeTap];
    [codeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeLabel.mas_right).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width*2/5 - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(passLabel.mas_bottom).with.offset(qqLoginViewX);
    }];

    enrollView = [[LoginView alloc] init];
    [self.view addSubview:enrollView];
    enrollView.backgroundColor = [XUtil hexToRGB:@"01A7F1"];
    enrollView.typeLabel.text = @"注册";
    enrollView.typeLabel.font = font18;
    enrollView.typeLabel.centerX = enrollView.centerX;
    enrollView.noImg = YES;
    UITapGestureRecognizer *enrollTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toenroll)];
    [enrollView addGestureRecognizer:enrollTap];
    [enrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).with.offset(qqLoginViewX);
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width - qqLoginViewX*2, qqLoginViewH));
        make.top.mas_equalTo(codeLabel.mas_bottom).with.offset(qqLoginViewX*2);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(enrollView.mas_bottom).with.offset(2 * Main_Screen_Height / 1136);
    }];
    
}

-(void)toenroll{
    NSString *pass = passLabel.text;
    NSString *mobile = phoneLabel.text;
    NSString *name = nameLabel.text;
    NSString *validCode = codeLabel.text;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    [YDUserManager sharedInstance].currentUser.passwd = pass;
    [YDUserManager sharedInstance].currentUser.mobile = mobile;
    [YDUserManager sharedInstance].currentUser.nickName = name;

    //登录成功后请求用户数据
    AFHTTPSessionManager *manager = [HttpUtil initializeHttpManager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"passwd"] = [YDUserManager sharedInstance].currentUser.passwd;
    param[@"mobile"] = [YDUserManager sharedInstance].currentUser.mobile;
    param[@"name"] = [YDUserManager sharedInstance].currentUser.nickName;
    param[@"validCode"] = validCode;

    if(![XUtil validPhone:mobile]){
        [MBProgressHUD showError:@"手机号格式不对"];
        return;
    }
    
    if([XUtil isNull:validCode]){
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    if([XUtil isNull:name]){
        [MBProgressHUD showError:@"昵称不能为空"];
        return;
    }
    
    if(![XUtil validPass:pass]){
        [MBProgressHUD showError:@"密码至少6位"];
        return;
    }
    
    [manager GET:[Consts USER_ENROLL] parameters:param success:^(NSURLSessionTask *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSString *code =[NSString stringWithFormat:@"%@",responseDic[@"code"]];
        if([@"200" isEqualToString:code]){
            [MBProgressHUD showMessage:@"注册成功" toView:self.view];
            [self backIndex];
        }else{
            NSString *msg =responseDic[@"msg"];
            [MBProgressHUD showError:msg];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD showError:@"注册失败"];
    }];
    
}

-(void)toCode{
    if(upTimer != nil){
        [MBProgressHUD showError:@"如果没收到，请稍等"];
        return;
    }
    NSString *mobile = phoneLabel.text;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(![XUtil validPhone:mobile]){
        [MBProgressHUD showError:@"手机号格式不对"];
        return;
    }
    //登录成功后请求用户数据
    AFHTTPSessionManager *manager = [HttpUtil initializeHttpManager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    
    [manager GET:[Consts USER_CODE] parameters:param success:^(NSURLSessionTask *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSString *code =[NSString stringWithFormat:@"%@",responseDic[@"code"]];
        if([@"200" isEqualToString:code]){
            [HUDUtil show:self.view text:@"发送验证码成功"];
            [self timer];
        }else{
            NSString *msg =responseDic[@"msg"];
            [MBProgressHUD showError:msg];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD showError:@"发送验证码失败"];
    }];
    
}

-(void)timer{
    leftTime = 60;
    //取消原来的定时器
    if(upTimer != nil){
        [upTimer invalidate];
        upTimer = nil;
    }
    
    upTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)updateTime {
    leftTime = leftTime - 1;
    if(leftTime == 0){
        codeview.typeLabel.text = @"发送验证码";
        [upTimer invalidate];
        upTimer = nil;
    }
    codeview.typeLabel.text = [NSString stringWithFormat:@"%lds",leftTime];
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
    NSString *titleStr = @"注册账号";
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
