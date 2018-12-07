//
//  NetEaseMailController.m
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "NetEaseMailController.h"
#import "NetEaseMailLoginView.h"
#import "AuthServer.h"
#import "YDUserModel.h"
#import "YDUserManager.h"
#import "EmailFilter.h"
#import "MBProgressHUD.h"
#import "NSUserDefaultsUtil.h"
#import "SqlForFMDB.h"

#define kLastSuccessLoginUserName @"kLastSuccessLoginUserName"
#define USER_NAME_TEXT_SUGGEST_HEIGHT 35
typedef void (^BSBasicBlock) (void);

static dispatch_queue_t bs_operation_processing_queue;
static dispatch_queue_t operation_processing_queue() {
    if (bs_operation_processing_queue == NULL) {
        bs_operation_processing_queue = dispatch_queue_create("operation.bisheng.youdao.com", 0);
    }
    return bs_operation_processing_queue;
}
@interface NetEaseMailController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, weak) NetEaseMailLoginView *userNameView;
@property (nonatomic, weak) NetEaseMailLoginView *passwordView;
@property (nonatomic, weak) UIButton *loginBtn;
//输入时提示用户是哪个邮箱
@property (nonatomic, strong) UITableView * suggestTableView;
@property (nonatomic, strong) NSArray *filterEmails;
@property (nonatomic, strong) SqlForFMDB *sqlFMDB;
@end

@implementation NetEaseMailController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NetEaseMailController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NetEaseMailController"];
}
#pragma mark - functions
- (void)setUpViews {
    //登录界面
    CGFloat viewHeight = 48;
    UIView *loginView = [UIView new];
    //    loginView.layer.cornerRadius = 6;
    //    loginView.layer.borderColor = [XUtil isDay] ? [[XUtil hexToRGB:@"E6E6E6"] CGColor ]: [[XUtil hexToRGB:@"3A3F44"] CGColor];
    //    loginView.layer.borderWidth = 1;
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(Main_Screen_Height * 80 / 1136);
        make.left.equalTo(self.view).with.offset(Main_Screen_Width * 40 / 640);
        make.right.equalTo(self.view).with.offset(-Main_Screen_Width * 40 / 640);
        make.height.mas_equalTo(viewHeight * 2 + 16);
    }];
    
    //用户名
    NetEaseMailLoginView *userNameView = [[NetEaseMailLoginView alloc] init];
    [loginView addSubview:userNameView];
    self.userNameView = userNameView;
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(loginView);
        make.height.mas_equalTo(viewHeight);
    }];
    userNameView.iconImgView.image = [UIImage imageNamed:@"ic_loginhead"];
    userNameView.inputView.placeholder = @"网易邮箱（如163邮箱）";
    userNameView.inputView.keyboardType = UIKeyboardTypeURL;
    [userNameView.inputView setValue:[XUtil hexToRGB:@"CCCCCC"]forKeyPath:@"_placeholderLabel.textColor"];
    userNameView.inputView.delegate = self;
    [userNameView.inputView addTarget:self action:@selector(userNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    NSString *lastSuccessLoginUserName = [[NSUserDefaults standardUserDefaults] stringForKey:kLastSuccessLoginUserName];
    if (lastSuccessLoginUserName && lastSuccessLoginUserName.length) {
        userNameView.inputView.text = lastSuccessLoginUserName;
    }
    
    //密码
    NetEaseMailLoginView *passwordView = [[NetEaseMailLoginView alloc] init];
    [loginView addSubview:passwordView];
    self.passwordView = passwordView;
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(loginView);
        make.height.mas_equalTo(viewHeight);
    }];
    passwordView.iconImgView.image = [UIImage imageNamed:@"ic_password"];
    passwordView.inputView.delegate = self;
    passwordView.inputView.placeholder = @"密码";
    passwordView.inputView.secureTextEntry = YES;
    passwordView.inputView.clearsOnBeginEditing = YES;
    [passwordView.inputView setValue:[XUtil hexToRGB:@"CCCCCC"]forKeyPath:@"_placeholderLabel.textColor"];
    [passwordView.inputView addTarget:self action:@selector(passwordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //分割线
    //    UIView *spaceView = [UIView new];
    //    spaceView.dk_backgroundColorPicker = DKColor_BORDER;
    //    [loginView addSubview:spaceView];
    //    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.and.right.equalTo(loginView);
    //        make.height.mas_equalTo(1);
    //        make.centerY.mas_equalTo(loginView.mas_centerY);
    //    }];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn.layer setCornerRadius:viewHeight * 0.5];
    loginBtn.clipsToBounds = YES;
    [loginBtn setBackgroundImage:[XUtil createImageWithColor:[XUtil hexToRGB:MAIN_COLOR]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[XUtil createImageWithColor:[XUtil hexToRGB:@"08A175"]] forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:font16];
    [loginBtn addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight);
        make.left.and.right.equalTo(loginView);
        make.top.mas_equalTo(loginView.mas_bottom).with.offset(32);
    }];
    self.loginBtn = loginBtn;
    [self checkLoginBtnStatus];
    
    self.suggestTableView = [[UITableView alloc] init];
    [self.view addSubview:self.suggestTableView];
    [self.suggestTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameView.inputView.mas_left);
        make.top.equalTo(userNameView.inputView.mas_bottom);
        make.width.mas_equalTo(userNameView.inputView.mas_width).with.offset(-3);
        make.height.mas_equalTo(200);
    }];
    [self.suggestTableView setHidden:YES];
    self.suggestTableView.dataSource = self;
    self.suggestTableView.delegate = self;
    self.suggestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)toLogin:(UIButton *)loginBtn {
    //处理登录逻辑
    [self.userNameView.inputView resignFirstResponder];
    [self.passwordView.inputView resignFirstResponder];
    
    if ([self.userNameView.inputView.text length] == 0) {
        [HUDUtil show:self.view text:@"用户名不能为空"];
        return;
    }
    
    if ([self.passwordView.inputView.text length] == 0) {
        [HUDUtil show:self.view text:@"密码不能为空"];
        return;
    }
    
    //登录
    __weak NetEaseMailController *weakSelf = self;
    __block NSError * error;
    [self addOperation:^{
        error = [[AuthServer sharedInstance] loginWithUserName:weakSelf.userNameView.inputView.text PassWord:weakSelf.passwordView.inputView.text error:nil];
    } beginBlock:^{
        [MBProgressHUD showMessage:@"正在登录" toView:weakSelf.view];
    } finishBlock:^{
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (error == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:weakSelf.userNameView.inputView.text forKey:kLastSuccessLoginUserName];
            [YDUserManager sharedInstance].isLogin = YES;

            [self loginSuccess];
            
        }else{
            [MBProgressHUD showError:@"用户名或密码错误"];
        }
    }];
}

- (void)setUpNavBar {
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
    titleLabel.textColor = [UIColor blackColor];
    NSString *titleStr = @"登录";
    CGSize titleStrSize = [XUtil sizeWithString:titleStr font:font16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    titleLabel.frame = CGRectMake(0,50, titleStrSize.width,titleStrSize.height);
    titleLabel.text = titleStr;
    self.navigationItem.titleView = titleLabel;
}

-(void) backIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userNameValueChanged:(UITextField *)sender {
    self.filterEmails = [EmailFilter filterEmails:sender.text];
    if ([self.filterEmails count] == 0) {
        self.suggestTableView.hidden = YES;
    } else {
        self.suggestTableView.hidden = NO;
        CGRect rect = self.suggestTableView.frame;
        rect.size.height = [self.filterEmails count] * USER_NAME_TEXT_SUGGEST_HEIGHT;
        self.suggestTableView.frame = rect;
    }
    [self.suggestTableView reloadData];
    [self checkLoginBtnStatus];
}

- (void)passwordValueChanged:(UITextField *)sender {
    [self checkLoginBtnStatus];
}

- (void)checkLoginBtnStatus {
    if (self.userNameView.inputView.text.length && self.passwordView.inputView.text.length) {
        [self.loginBtn setTitleColor:[XUtil hexToRGB:@"FFFFFF" setAlpha:1] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
    }else {
        [self.loginBtn setTitleColor:[XUtil hexToRGB:@"FFFFFF" setAlpha:0.5] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.superview.layer.borderColor = [[XUtil hexToRGB:MAIN_COLOR] CGColor];
    [self checkLoginBtnStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.suggestTableView.hidden = YES;
    textField.superview.layer.borderColor = [[XUtil hexToRGB:@"E6E6E6"] CGColor ];
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterEmails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"chooseEmailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = font15;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, USER_NAME_TEXT_SUGGEST_HEIGHT - 0.5f, self.suggestTableView.frame.size.width, 0.5)];
        [line setBackgroundColor:RGBCOLOR(0xCA, 0xCA, 0xCA)];
        [cell.contentView addSubview:line];
    }
    cell.textLabel.text = [self.filterEmails objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return USER_NAME_TEXT_SUGGEST_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.userNameView.inputView.text = [self.filterEmails objectAtIndex:indexPath.row];
    [self.passwordView.inputView becomeFirstResponder];
}


- (void)loginSuccess {
    NSString *loginType = @"";
    
    loginType = @"netease";
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
        NSDictionary *dict = responseDict[@"datas"];
        //                [self handleUserInfoWithDict:dict];
        //登录成功后1s回到主界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void) sendLogin{
    NSString *url = [Consts USER_Login];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [UrlBuild appendBaseParames:param];
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
        NSDictionary *dict = responseDict[@"datas"];
        //                [self handleUserInfoWithDict:dict];
        //登录成功后1s回到主界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)addOperation:(BSBasicBlock)operation beginBlock:(BSBasicBlock)begin finishBlock:(BSBasicBlock)finish {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (begin) {
            begin();
        }
        dispatch_async(operation_processing_queue(), ^{
            if (operation) {
                operation();
            }
            dispatch_async(dispatch_get_main_queue(),^{
                if (finish) {
                    finish();
                }
            });
        });
    });
}

@end
