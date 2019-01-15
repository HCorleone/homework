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
#import "MyDownloadViewController.h"
#import "EditInfoView.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UITableView *menuView;
@property (nonatomic, strong) UIView *sloginView;

@property (nonatomic, strong) EditInfoView *editView;

@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *cityLabel;

@end

@implementation MyViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.editView.isShow) {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
    self.gradeLabel.text = [TTUserManager sharedInstance].currentUser.grade;
    self.cityLabel.text = [TTUserManager sharedInstance].currentUser.city;
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
    headImg.image = [UIImage imageNamed:@"头像logov2"];
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
    
    //城市
    UILabel *cityLabel = [[UILabel alloc]init];
    [sloginView addSubview:cityLabel];
    cityLabel.text = [TTUserManager sharedInstance].currentUser.city;
//    schoolName.text = @"北京市第二实验小学";
    cityLabel.textColor =  [UIColor colorWithRed:143/255.0 green:147/255.0 blue:148/255.0 alpha:1/1.0];
    cityLabel.font = [UIFont systemFontOfSize:10];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userName);
        make.top.mas_equalTo(gradeLabel.mas_bottom).with.offset(0.01 * SCREEN_WIDTH);
    }];
    self.cityLabel = cityLabel;
    
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

}

- (void)clickEditor {
    EditInfoView *editView = [[EditInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    editView.isShow = YES;
    editView.currentVC = self;
    editView.reloadInfo = ^(NSDictionary * _Nonnull dict) {
        self.gradeLabel.text = dict[@"grade"];
        self.cityLabel.text = dict[@"city"];
    };
    [self.view addSubview:editView];
    [self.view bringSubviewToFront:editView];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.editView = editView;
}

- (void)login:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
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
            MyDownloadViewController *downloadedVC = [[MyDownloadViewController alloc] init];
            [self.navigationController pushViewController:downloadedVC animated:YES];
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
        UIImage *logoImg = [UIImage imageNamed:@"头像logov2"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"作业答案下载器" descr:@"作业答案下载器是一款写作业必备神器，一键缓存方便查看答案，一键扫码搜索查询书籍答案，亦可将缓存答案同步分享给好友，让家长更好地辅导孩子，引导孩子走上学霸之路！" thumImage:logoImg];
        //设置网页地址
        shareObject.webpageUrl = @"http://abc.tatatimes.com/downloadhomework.html";
        
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

@end
