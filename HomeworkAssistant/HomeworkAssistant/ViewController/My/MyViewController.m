//
//  MyViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/12.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MyViewController.h"
#import "MyViewStaticCell.h"
#import "JYViewController.h"
#import "LoginViewController.h"
#import "shareDialog.h"
#import <UShareUI/UShareUI.h>
#import "UIImageView+WebCache.h"
#import "QRScanViewController.h"
#import "EditorNameView.h"
#import "NIDropDown.h"
#import "YTQGetUserManager.h"
#import "CommonAlterView.h"
#import "SHPlacePickerView.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource, NIDropDownDelegate>

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UITableView *menuView;
@property (nonatomic, strong) UIView *sloginView;
@property (nonatomic, strong) UIButton *logoutBtn;
/** 视图 */
@property (nonatomic, strong) EditorNameView *editor;
/** 下拉菜单 */
@property (nonatomic, strong) NIDropDown *dropDown;
/** 年级 */
@property (nonatomic, strong) UILabel *gradeLabel;
/** 地区选择器 */
@property (nonatomic, strong) SHPlacePickerView *shplacePicker;

@end

@implementation MyViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setupLoginView];
    [self setupMenu];
    
    
    if ([TTUserManager sharedInstance].isLogin) {
        [self setupSLoginView];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"loginSuccess" object:nil];
    }
    
    
}

- (void)changeView:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    NSLog(@"接到用户登陆成功通知，更改MyView的界面");
    [self setupSLoginView];
}


- (void)setupSLoginView {
    UIView *sloginView = [[UIView alloc]init];
    [self.view addSubview:sloginView];
    sloginView.backgroundColor = [UIColor whiteColor];
    sloginView.layer.cornerRadius = 10;
    [sloginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(31.5);
        make.right.mas_equalTo(self.view).offset(-31.5);
        make.top.mas_equalTo(self.view).offset(0.1 * screenHeight + TOP_OFFSET);
        make.height.mas_equalTo(0.3 * screenHeight);
    }];
    self.sloginView = sloginView;
    
    UIImageView *headImg = [[UIImageView alloc]init];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[TTUserManager sharedInstance].currentUser.headImgUrl]];
    [sloginView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sloginView).offset(20);
        make.top.mas_equalTo(sloginView).offset(0.03 * screenHeight);
        make.size.mas_equalTo(CGSizeMake(0.15 * screenHeight, 0.15 * screenHeight));
    }];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 0.15 * screenHeight/2;
    
    //用户名
    UILabel *userName = [[UILabel alloc]init];
    [sloginView addSubview:userName];
    userName.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:20];
    userName.text = [TTUserManager sharedInstance].currentUser.name;
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImg.mas_right).with.offset(15);
        make.top.mas_equalTo(sloginView).offset(0.05 * screenHeight);
        
    }];
    
    //年级
    _gradeLabel = [[UILabel alloc]init];
    [sloginView addSubview:_gradeLabel];
    _gradeLabel.text = [TTUserManager sharedInstance].currentUser.grade;
    _gradeLabel.textColor =  [UIColor colorWithRed:143/255.0 green:147/255.0 blue:148/255.0 alpha:1/1.0];
    _gradeLabel.font = [UIFont systemFontOfSize:14];
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImg.mas_right).with.offset(15);
        make.top.mas_equalTo(userName.mas_bottom).with.offset(10);
        
    }];
    
    //编辑个人信息
    UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    editorBtn.backgroundColor = [UIColor grayColor];
    [editorBtn setImage:[UIImage imageNamed:@"修改信息"] forState:UIControlStateNormal];
    [editorBtn addTarget:self action:@selector(clickEditor) forControlEvents:UIControlEventTouchUpInside];
    [sloginView addSubview:editorBtn];
    [editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(sloginView).offset(-20);
        make.centerY.mas_equalTo(userName);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    //注销
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-50 - BOT_OFFSET);
    }];
    logoutBtn.backgroundColor = [UIColor clearColor];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#8F9394"] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.logoutBtn = logoutBtn;
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sloginView addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(sloginView).offset(-20);
        make.left.mas_equalTo(sloginView).offset(20);
        make.top.mas_equalTo(headImg.mas_bottom).with.offset(0.05 * screenHeight);
        make.height.mas_equalTo(0.05 * screenHeight);
    }];
    uploadBtn.layer.masksToBounds = YES;
    uploadBtn.layer.cornerRadius = 0.05 * screenHeight/2;
    uploadBtn.backgroundColor = maincolor;
    [uploadBtn setTitleColor:whitecolor forState:UIControlStateNormal];
    [uploadBtn setTitle:@"上传答案" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(toUpLoad) forControlEvents:UIControlEventTouchUpInside];
}

//上传答案
- (void)toUpLoad {
    [self.navigationController pushViewController:[[QRScanViewController alloc] init] animated:YES];
}

- (void)logout {
    NSLog(@"用户登出，发出通知，并更改myview界面");
    [TTUserManager sharedInstance].isLogin = NO;
    [[TTUserManager sharedInstance]clearCurrentUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"loginSuccess" object:nil];
    self.sloginView.hidden = YES;
    self.logoutBtn.hidden = YES;
    [self.logoutBtn removeFromSuperview];
    [self.sloginView removeFromSuperview];
    
}

//编辑界面
-(void)getEditorView {
    
    _editor = [[EditorNameView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _editor.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    __weak typeof(self) weakSelf = self;
    _editor.clickBlock = ^(UIButton * _Nonnull btn) {
        switch (btn.tag) {
            case 1001:
            {
                NSLog(@"选择年级");
               NSArray *arr = [NSArray arrayWithObjects:@"学前", @"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"七年级", @"八年级", @"九年级", @"高一", @"高二", @"高三", nil];
                if(weakSelf.dropDown == nil) {
                    CGFloat f = 300;
                    weakSelf.dropDown = [[NIDropDown alloc]showDropDown:weakSelf.editor.downBtn theHeight:&f theArr:arr theImgArr:nil theDirection:@"down" withViewController:weakSelf];
                    [weakSelf.dropDown setCellHeigth:30];
                    [weakSelf.dropDown setDropDownSelectionColor:[UIColor whiteColor]];
                    [weakSelf.dropDown setDropDownItemBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1/1.0]];
                    weakSelf.dropDown.delegate = weakSelf;
                }
                else {
                    [weakSelf.dropDown hideDropDown:weakSelf.editor.downBtn];
                }
            }
                break;
                
            case 1002:
            {
                NSLog(@"地区");
                [weakSelf selectCity];
            }
                break;
                
            case 1003:
            {
                NSLog(@"确认");
                
                if (![weakSelf.editor.downBtn.titleLabel.text isEqualToString:@"请选择年级"]) {
                    [weakSelf getManager];
                    
                    weakSelf.gradeLabel.text = weakSelf.editor.downBtn.titleLabel.text;
                }
                else
                {
                    [CommonAlterView showAlertView:@"请选择年级"];
                }
                
            }
                break;
            case 1004:
                
            {
                NSLog(@"取消");
                weakSelf.editor.hidden = YES;
                [weakSelf.editor removeFromSuperview];
                weakSelf.shplacePicker.hidden = YES;
                [weakSelf.shplacePicker removeFromSuperview];
                [[weakSelf rdv_tabBarController] setTabBarHidden:NO animated:NO];
            }
                break;
                
        }
    };
    [self.view addSubview:_editor];
    
}

//选择城市
-(void)selectCity {
    
    __weak __typeof(self)weakSelf = self;
    self.shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
        
        NSLog(@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]);
        [weakSelf.editor.cityBtn setTitle:[NSString stringWithFormat:@"%@", placeArray[1]] forState:UIControlStateNormal];
        
    }];
    self.shplacePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shplacePicker];
}

-(void)clickEditor {
    
    NSLog(@"编辑个人信息");
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    [self getEditorView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //隐藏
    [self.dropDown hideDropDown:self.editor.downBtn];

}

- (void)setupLoginView {
    //登陆框
    self.loginView = [[UIView alloc]init];
    [self.view addSubview:self.loginView];
    self.loginView.backgroundColor = [UIColor whiteColor];
    
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(31.5);
        make.right.mas_equalTo(self.view).offset(-31.5);
        make.top.mas_equalTo(self.view).offset(0.1 * screenHeight + TOP_OFFSET);
        make.height.mas_equalTo(0.3 * screenHeight);
    }];
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.loginView.bounds];
//    self.loginView.layer.shadowPath = path.CGPath;
    
    self.loginView.layer.cornerRadius = 2;
    self.loginView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 2);
    self.loginView.layer.shadowOpacity = 0.1;
    
    
    //logo
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.image = [UIImage imageNamed:@"logo"];
    [self.loginView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.loginView);
        make.centerY.mas_equalTo(self.loginView).offset(-0.1*screenHeight/2);
        make.size.mas_equalTo(CGSizeMake(0.1*screenHeight, 0.1*screenHeight));
    }];
    //登陆注册按钮
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.backgroundColor = maincolor;
    logoBtn.layer.cornerRadius = 0.054 * screenHeight/2;
    [logoBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
    logoBtn.titleLabel.textColor = whitecolor;
    logoBtn.titleLabel.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [self.loginView addSubview:logoBtn];
    [logoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.loginView);
        make.centerY.mas_equalTo(self.loginView).offset(0.054 * screenHeight/2 + 20);
        make.width.mas_equalTo(0.4 * screenWidth + BOT_OFFSET);
        make.height.mas_equalTo(0.054 * screenHeight);
    }];
    [logoBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupMenu {
    //菜单选项
    self.menuView = [[UITableView alloc]init];
    [self.view addSubview:self.menuView];
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuView.backgroundColor = [UIColor whiteColor];
    self.menuView.scrollEnabled = NO;
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(41.5);
        make.right.mas_equalTo(self.view).offset(-41.5);
        make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(36);
        make.height.mas_equalTo( 4 * 0.08 * screenHeight);
    }];
}


- (void)login:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - 请求接口
-(void)getManager {
    
    NSDictionary *dic = @{@"h":@"ZYUpsertUserExtHander",
                          @"openID":userValue(@"openId"),
                          @"grade":self.editor.downBtn.titleLabel.text,
                          @"city":self.editor.cityBtn.titleLabel.text,
                          @"av":@"_debug_"};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OnLineIP]];
    //设置请求方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //接收数据是json形式给出
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [manager GET:upUserInform parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@------------------------------", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            
            weakSelf.editor.hidden = YES;
            [weakSelf.editor removeFromSuperview];
            [[weakSelf rdv_tabBarController] setTabBarHidden:NO animated:NO];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}


#pragma mark - 静态tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyViewStaticCell *cell = [MyViewStaticCell cellWithTableView:tableView];
    switch (indexPath.row) {
        case 0:{
            cell.icon.image = [UIImage imageNamed:@"用户反馈"];
            cell.title.text = @"提供建议";
            break;
        }
        case 1:{
            cell.icon.image = [UIImage imageNamed:@"用户好评"];
            cell.title.text = @"给个好评";
            break;
        }
        case 2:{
            cell.icon.image = [UIImage imageNamed:@"检查更新"];
            cell.title.text = @"检查更新";
            break;
        }
        case 3:{
            cell.icon.image = [UIImage imageNamed:@"分享应用"];
            cell.title.text = @"分享应用";
            break;
        }
        default:
            break;
    }
    return cell;
}


#pragma mark - 静态tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.08 * screenHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{    //提供建议
            JYViewController *jyVC = [[JYViewController alloc]init];
            [self.navigationController pushViewController:jyVC animated:YES];
            break;
        }
        case 1:{    //给个好评
            NSString *urlStr = [self getReviewUrlByAppId:1];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            break;
        }
        case 2:{    //检查更新
            NSString *urlStr = [self getReviewUrlByAppId:2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            break;
        }
        case 3:{    //分享应用
            [self showDialog];
            break;
        }
        default:
            break;
    }
}

- (void)showDialog {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage *logoImg = [UIImage imageNamed:@"logo"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"作业答案助手" descr:@"作业答案助手 k12学校作业辅导答案大全 海量作业答案任你搜索 一键同步书单" thumImage:logoImg];
        //设置网页地址
        shareObject.webpageUrl = @"http://abc.tatatimes.com/palmhomework.html";
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }];
}

// app页面 http://itunes.apple.com/cn/app/id1281806378?mt=8
// app评论页面[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1232138855&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];

//跳转到appstore应用页面
- (NSString *)getReviewUrlByAppId:(NSInteger)type{
    // type = 1 为评论界面；type = 2 为更新界面
    NSString *appId = @"1225090488";
    NSString *templatePL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8";
    NSString *templateGX = @"http://itunes.apple.com/cn/app/idAPP_ID?mt=8";
    
    if (type == 1) {
        return [templatePL stringByReplacingOccurrencesOfString:@"APP_ID" withString:appId];
    }
    return [templateGX stringByReplacingOccurrencesOfString:@"APP_ID" withString:appId];
    
}

#pragma mark - NIDropDownDelegate 代理
- (void) niDropDownDelegateMethod:(UIView *)sender withTitle:(NSString *)title {
    
    
    NSLog(@"%@", self.editor.downBtn.titleLabel.text);
    [self.editor.downBtn setTitle:title forState:UIControlStateNormal];
    
    
}

- (void)niDropDownHidden{
    _dropDown = nil;
}


@end
