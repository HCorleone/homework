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
#import "CommonAlterView.h"
#import "SHPlacePickerView.h"
#import "BookListViewController.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UITableView *menuView;
@property (nonatomic, strong) UIView *sloginView;
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

//扫描
- (void)toScan {
    QRScanViewController *scanVC = [[QRScanViewController alloc]init];
    scanVC.scanType = ScanTypeDefault;
    scanVC.shareCodeBlock = ^(NSString * _Nonnull shareCode) {
        BookListViewController *book = [[BookListViewController alloc] init];
        book.idStr = shareCode;
        book.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        [self presentViewController:book animated:NO completion:nil];
    };
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - 用户登录或注销
//发出用户注销通知，并改变界面
- (void)logout {
    NSLog(@"用户登出，发出通知，并更改myview界面");
    [TTUserManager sharedInstance].isLogin = NO;
    [[TTUserManager sharedInstance]clearCurrentUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"loginSuccess" object:nil];
    self.sloginView.hidden = YES;
    [self.sloginView removeFromSuperview];
    [self.menuView reloadData];
}

//接收登录成功的通知来改变界面
- (void)changeView:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    NSLog(@"接到用户登陆成功通知，更改MyView的界面");
    [self setupSLoginView];
    [self.menuView reloadData];
}

#pragma mark - 顶部登录框

//未登录状态下的框
- (void)setupLoginView {
    //登陆框
    self.loginView = [[UIView alloc]init];
    [self.view addSubview:self.loginView];
    self.loginView.backgroundColor = [UIColor whiteColor];
    
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0.1 * SCREEN_HEIGHT + TOP_OFFSET);
        make.size.mas_equalTo(CGSizeMake(0.889 * SCREEN_WIDTH, 0.889 * SCREEN_WIDTH * 0.369));
    }];
    
    self.loginView.layer.cornerRadius = 2;
    self.loginView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 2);
    self.loginView.layer.shadowOpacity = 0.1;
    
    
    //logo
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.image = [UIImage imageNamed:@"logo"];
    [self.loginView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginView).offset(20);
        make.top.mas_equalTo(self.loginView).offset(0.053 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.194 * SCREEN_WIDTH, 0.194 * SCREEN_WIDTH));
    }];
    
    //登陆注册按钮
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, 0, 0.405 * SCREEN_WIDTH, 0.236 * 0.405 * SCREEN_WIDTH);
//    [gradientLayer setColors:[NSArray arrayWithObjects:
//                              (id)[UIColor colorWithHexString:@"#FFC94C"].CGColor,
//                              (id)[UIColor colorWithHexString:@"#FF8800"].CGColor,
//                              nil
//                              ]];
//
//
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    gradientLayer.locations = @[@0,@1];
//
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [logoBtn.layer addSublayer:gradientLayer];
//    logoBtn.layer.masksToBounds = YES;
//    logoBtn.layer.cornerRadius = 0.236 * 0.405 * SCREEN_WIDTH/2;
    [logoBtn setBackgroundColor:whitecolor];
    [logoBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
    [logoBtn setTitleColor:[UIColor colorWithHexString:@"#0F0F0F"] forState:UIControlStateNormal];
    logoBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginView addSubview:logoBtn];
    [logoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImg.mas_right).with.offset(15);
        make.centerY.mas_equalTo(headImg);
    }];
    [logoBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
}

//登陆成功的框
- (void)setupSLoginView {
    
    UIView *sloginView = [[UIView alloc]init];
    [self.view addSubview:sloginView];
    sloginView.backgroundColor = [UIColor whiteColor];
    sloginView.layer.cornerRadius = 10;
    [sloginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0.1 * SCREEN_HEIGHT + TOP_OFFSET);
        make.size.mas_equalTo(CGSizeMake(0.889 * SCREEN_WIDTH, 0.889 * SCREEN_WIDTH * 0.369));
    }];
    self.sloginView = sloginView;
    
    UIImageView *headImg = [[UIImageView alloc]init];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[TTUserManager sharedInstance].currentUser.headImgUrl]];
    [sloginView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sloginView).offset(20);
        make.top.mas_equalTo(sloginView).offset(0.053 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.194 * SCREEN_WIDTH, 0.194 * SCREEN_WIDTH));
    }];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 0.187 * SCREEN_WIDTH/2;
    
    //用户名
    UILabel *userName = [[UILabel alloc]init];
    [sloginView addSubview:userName];
    userName.font = [UIFont systemFontOfSize:18];
    userName.text = [TTUserManager sharedInstance].currentUser.name;
    userName.numberOfLines = 2;
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImg.mas_right).with.offset(10);
        make.top.mas_equalTo(sloginView).offset(0.07 * SCREEN_WIDTH);
        make.width.mas_equalTo(0.288 * SCREEN_WIDTH);
    }];
    
    //年级
    UILabel *gradeLabel = [[UILabel alloc]init];
    [sloginView addSubview:gradeLabel];
    gradeLabel.text = [TTUserManager sharedInstance].currentUser.grade;
    gradeLabel.textColor =  [UIColor colorWithRed:143/255.0 green:147/255.0 blue:148/255.0 alpha:1/1.0];
    gradeLabel.font = [UIFont systemFontOfSize:10];
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userName);
        make.top.mas_equalTo(userName.mas_bottom).with.offset(0.02 * SCREEN_WIDTH);
    }];
    self.gradeLabel = gradeLabel;
    
    //学校
//    UILabel *schoolName = [[UILabel alloc]init];
//    [sloginView addSubview:schoolName];
//    schoolName.text = [TTUserManager sharedInstance].currentUser.schoolName;
//    schoolName.text = @"北京市第二实验小学";
//    schoolName.textColor =  [UIColor colorWithRed:143/255.0 green:147/255.0 blue:148/255.0 alpha:1/1.0];
//    schoolName.font = [UIFont systemFontOfSize:10];
//    [schoolName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(userName);
//        make.top.mas_equalTo(gradeLabel.mas_bottom).with.offset(0.01 * SCREEN_WIDTH);
//    }];
    
    //编辑个人信息
    UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editorBtn setImage:[UIImage imageNamed:@"修改信息"] forState:UIControlStateNormal];
    [editorBtn addTarget:self action:@selector(clickEditor) forControlEvents:UIControlEventTouchUpInside];
    [sloginView addSubview:editorBtn];
    [editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(sloginView).offset(-20);
        make.centerY.mas_equalTo(userName);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
//    //注销
//    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:logoutBtn];
//    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view).offset(-20);
//        make.bottom.mas_equalTo(self.view).offset(-60 - BOT_OFFSET);
//    }];
//    logoutBtn.backgroundColor = [UIColor clearColor];
//    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#8F9394"] forState:UIControlStateNormal];
//    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
//    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//    self.logoutBtn = logoutBtn;

}

- (NSInteger)getBonusPointToLevelUp:(NSInteger)level {
    switch (level) {
        case 0:
            return 5;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 15;
            break;
        case 3:
            return 25;
            break;
        case 4:
            return 40;
            break;
        case 5:
            return 65;
            break;
        case 6:
            return 100;
            break;
        case 7:
            return 150;
            break;
        case 8:
            return 200;
            break;
        case 9:
            return 300;
            break;
        case 10:
            return 300;
            break;
        default:
            break;
    }
    return 300;
}

//编辑界面
-(void)getEditorView {
    
    _editor = [[EditorNameView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
                    [XWHUDManager showTipHUDInView:@"请选择年级和地区"];
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





- (void)login:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - 请求接口
-(void)getManager {
    
    NSDictionary *dic = @{
                          @"openID":userValue(@"openId"),
                          @"grade":self.editor.downBtn.titleLabel.text,
                          @"city":self.editor.cityBtn.titleLabel.text
                          };
    dic = [HMACSHA1 encryptDicForRequest:dic];
    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    //设置请求方式
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    //接收数据是json形式给出
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    __weak typeof(self) weakSelf = self;
    [manager GET:[URLBuilder getURLForUpsertUserExt] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

#pragma mark - 菜单列表
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
        make.top.mas_equalTo(self.loginView.mas_bottom).with.offset(20);
        make.height.mas_equalTo( 8 * 0.07 * SCREEN_HEIGHT);
    }];
}

#pragma mark - 静态tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([TTUserManager sharedInstance].isLogin) {
        return 8;
    }
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyViewStaticCell *cell = [MyViewStaticCell cellWithTableView:tableView];
    switch (indexPath.row) {
        case 0:{
            cell.icon.image = [UIImage imageNamed:@"我的下载v2"];
            cell.title.text = @"我的下载";
            break;
        }
        case 1:{
            cell.icon.image = [UIImage imageNamed:@"上传答案v2"];
            cell.title.text = @"上传答案";
            break;
        }
        case 2:{
            cell.icon.image = [UIImage imageNamed:@"我要反馈v2"];
            cell.title.text = @"反馈缺失书籍";
            break;
        }
        case 3:{
            cell.icon.image = [UIImage imageNamed:@"提供建议v2"];
            cell.title.text = @"提供建议";
            break;
        }
        case 4:{
            cell.icon.image = [UIImage imageNamed:@"给个好评v2"];
            cell.title.text = @"给个好评";
            break;
        }
        case 5:{
            cell.icon.image = [UIImage imageNamed:@"检查更新v2"];
            cell.title.text = @"检查更新";
            break;
        }
        case 6:{
            cell.icon.image = [UIImage imageNamed:@"分享应用v2"];
            cell.title.text = @"分享应用";
            break;
        }
        case 7:{
            cell.icon.image = [UIImage imageNamed:@"注销v2"];
            cell.title.text = @"注销";
            break;
        }
        default:
            break;
    }
    return cell;
}


#pragma mark - 静态tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.07 * SCREEN_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{    //我的下载
            NSDictionary *testDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyDownload"];
            NSLog(@"+++Test:%@",testDic);
            break;
        }
        case 1:{    //上传答案
            QRScanViewController *scanVC = [[QRScanViewController alloc] init];
            scanVC.scanType = ScanTypeUploadAnswer;
            [self.navigationController pushViewController:scanVC animated:YES];
            break;
        }
        case 2:{    //我要反馈
            QRScanViewController *scanVC = [[QRScanViewController alloc] init];
            scanVC.scanType = ScanTypeFeedBack;
            [self.navigationController pushViewController:scanVC animated:YES];
            break;
        }
        case 3:{    //提供建议
            JYViewController *jyVC = [[JYViewController alloc]init];
            [self.navigationController pushViewController:jyVC animated:YES];
            break;
        }
        case 4:{    //给个好评
            NSString *urlStr = [self getReviewUrlByAppId:1];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            break;
        }
        case 5:{    //检查更新
            NSString *urlStr = [self getReviewUrlByAppId:2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            break;
        }
        case 6:{    //分享应用
            [self showDialog];
            break;
        }
        case 7:{    //注销
            [self logout];
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

//跳转到appstore应用页面
- (NSString *)getReviewUrlByAppId:(NSInteger)type{
    // type = 1 为评论界面；type = 2 为更新界面
    NSString *appId = @"1446237904";
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
