//
//  MainViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/12.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MainViewController.h"
#import "RecommendTableView.h"
#import "Book.h"
#import "SearchViewController.h"
#import "QRScanViewController.h"
#import "MyListViewController.h"
#import "MyListView.h"
#import "QRCodeView.h"
#import "SearchResultViewController.h"

#import "BookListViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>
//主页滚动视图
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIView *mainContentView;
//导航栏及搜索框
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *searchView;
//作文模块
@property (nonatomic, strong) UIView *articleView;
//我的书单模块
@property (nonatomic, strong) UIView *myCollectionsView;//这个是用户没有收藏或未登录显示的view
@property (nonatomic, strong) UIView *myListContainer;//这个是用户有收藏时显示的view
@property (nonatomic, strong) MyListView *myListView;
@property (nonatomic, strong) NSMutableArray *myListViewData;
//为您推荐模块
@property (nonatomic, strong) UIView *recommendView;
@property (nonatomic, strong) RecommendTableView *recommendListView;
@property (nonatomic, strong) NSMutableArray *recommendListViewData;

//需要调整frame的控件
@property (nonatomic, strong) UIImageView *searchLogo;
@property (nonatomic, strong) UILabel *placeHolder;

//二维码弹窗
@property (nonatomic, strong) QRCodeView *testView;

/** 扫码获取的信息 */
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *codes;//存

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupView];
    [self setupNavView];
    [self downloadDataForRec];
    
    if ([TTUserManager sharedInstance].isLogin) {
        [self downloadDataForMyList];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"userLogout" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"loginSuccess" object:nil];
    }
    
}

#pragma mark - 通知处理
- (void)changeView:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"userLogout" object:nil];
    NSLog(@"接到用户登陆成功通知，改变主界面");
    [self downloadDataForMyList];
    [self downloadDataForRec];
}

- (void)userLogout:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLogout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"loginSuccess" object:nil];
    NSLog(@"接到用户登出通知，改变主界面");
    self.myListContainer.hidden = YES;
    [self downloadDataForRec];
    //    [self.myListView removeFromSuperview];
}

#pragma mark - 下载数据
//- (AFSecurityPolicy*)customSecurityPolicy
//
//{
//    //先导入证书
//    //在这加证书，一般情况适用于单项认证
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];//证书的路径
//
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    if (certData==nil) {
//        return nil;
//    }
//    // AFSSLPinningModeCertificate 使用证书验证模式
//
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//
//    // 如果是需要验证自建证书，需要设置为YES
//
//    securityPolicy.allowInvalidCertificates = YES;
//
//    //validatesDomainName 是否需要验证域名，默认为YES；
//
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//
//    securityPolicy.validatesDomainName = NO;
//
//    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil ,nil];
//
//    return securityPolicy;
//
//}

- (void)downloadDataForRec {
    
    NSString *openId = @"123";
    if ([TTUserManager sharedInstance].isLogin) {
        openId = [TTUserManager sharedInstance].currentUser.openId;
    }
    
    NSString *strToSign = [NSString stringWithFormat:@"openID=%@",openId];
    NSString *sign = [HMACSHA1 dataToBeEncrypted:strToSign];
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"sign":sign
                           };
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    //    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    //    NSSet *cerSet = [[NSSet alloc] initWithObjects:cerData, nil];
    //    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    security.allowInvalidCertificates = YES;
    //    security.validatesDomainName = NO;
    //    [security setPinnedCertificates:cerSet];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.requestSerializer.timeoutInterval = 20.0f;
    //    manager.securityPolicy = security;
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForRecommend] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *jsonDataArr = responseObject[@"datas"];
            self.recommendListViewData = [NSMutableArray array];
            //建立模型数组
            for (int i =0; i < jsonDataArr.count; i++) {
                NSDictionary *aDic = jsonDataArr[i];
                Book *aModel = [Book initWithDic:aDic];
                [self.recommendListViewData addObject:aModel];
            }
        }
        if (self.recommendListView) {
            [self.recommendListView reloadDataWithList:self.recommendListViewData];
        }
        else {
            [self setupViewWithData:self.recommendListViewData];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)setupViewWithData:(NSMutableArray *)array {
    //为您推荐
    RecommendTableView *rTableView = [[RecommendTableView alloc]initWithFrame:CGRectMake(0, 0.12 * SCREEN_WIDTH, SCREEN_WIDTH, array.count * 128 ) style:UITableViewStylePlain withArray:array];
    [self.recommendView addSubview:rTableView];
        self.mainView.contentSize = CGSizeMake(SCREEN_WIDTH, 456 + rTableView.frame.size.height);
}


- (void)downloadDataForMyList {
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSString *strToSign = [NSString stringWithFormat:@"openID=%@&pkn=com.enjoytime.palmhomework",openId];
    NSString *sign = [HMACSHA1 dataToBeEncrypted:strToSign];
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"pkn":@"com.enjoytime.palmhomework",
                           @"sign":sign
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForMyCollections] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"] == [NSNull null]) {
                NSLog(@"数组为空");
                if (self.myListContainer) {
                    self.myListContainer.hidden = YES;
                }
            }
            else {
                NSArray *jsonDataArr = responseObject[@"datas"];
                self.myListViewData = [NSMutableArray array];
                //建立模型数组
                for (int i =0; i < jsonDataArr.count; i++) {
                    NSDictionary *aDic = jsonDataArr[i];
                    Book *aModel = [Book initWithDic:aDic];
                    [self.myListViewData addObject:aModel];
                }
                if (self.myListContainer) {
                    self.myListContainer.hidden = NO;
                    [self.myListView reloadDataWithList:self.myListViewData];
                }
                else {
                    [self setupMyListViewWithData:self.myListViewData];
                }
            }
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void) setupMyListViewWithData:(NSMutableArray *)array {
    
    UIView *myListContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0.68 * SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_WIDTH * 0.69)];
    myListContainer.backgroundColor = whitecolor;
    [self.mainContentView addSubview:myListContainer];
    self.myListContainer = myListContainer;
    
    UILabel *myListTitle = [[UILabel alloc]init];
    [myListContainer addSubview:myListTitle];
    myListTitle.text = @"我的书单";
    myListTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [myListTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myListContainer).offset(20);
        make.top.mas_equalTo(myListContainer).offset(0.04 * SCREEN_WIDTH);
    }];
    
    //蓝色小标记1
    UILabel *blueSign_one = [[UILabel alloc]init];
    blueSign_one.backgroundColor = [UIColor colorWithHexString:@"#49ACF2"];
    [myListContainer addSubview:blueSign_one];
    [blueSign_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myListContainer);
        make.centerY.mas_equalTo(myListTitle);
        make.size.mas_equalTo(CGSizeMake(3, 18));
    }];
    
    //查看全部按钮
    UIButton *checkMyList = [UIButton buttonWithType:UIButtonTypeCustom];
    [myListContainer addSubview:checkMyList];
    [checkMyList setTitle:@"查看全部" forState:UIControlStateNormal];
    [checkMyList setTitleColor:[UIColor colorWithHexString:@"#C4C8CC"] forState:UIControlStateNormal];
    checkMyList.titleLabel.font = [UIFont systemFontOfSize:12];
    [checkMyList setBackgroundColor:[UIColor clearColor]];
    [checkMyList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(myListContainer).offset(-20);
        make.centerY.mas_equalTo(myListTitle);
//        make.size.mas_equalTo(CGSizeMake(60, 12));
    }];
    [checkMyList addTarget:self action:@selector(toMyList) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"分享给同学"] forState:UIControlStateNormal];
    [myListContainer addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(myListContainer);
        make.bottom.mas_equalTo(myListContainer).offset(-0.066 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(80, 18));
    }];
    [shareBtn addTarget:self action:@selector(shareMyList) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(83.5, 150);
    MyListView *myListView = [[MyListView alloc]initWithFrame:CGRectMake(0, 0.125 * SCREEN_WIDTH, SCREEN_WIDTH, 0.41 * SCREEN_WIDTH) collectionViewLayout:layout withArray:array];
    [myListContainer addSubview:myListView];
    self.myListView = myListView;
}


#pragma mark - 分享书单二维码
- (void)shareMyList {
    
    QRCodeView *testView = [[QRCodeView alloc]init];
    [testView showQRCode];
    self.testView = testView;
}



#pragma mark - 建立UI
//导航栏
- (void)setupNavView {
    
    UIView *topOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_OFFSET)];
    topOffsetView.backgroundColor = maincolor;
    [self.view addSubview:topOffsetView];
    
    self.navView = [[UIView alloc]init];
    self.navView.hidden = YES;
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(TOP_OFFSET);
        make.height.mas_equalTo(72);
    }];
    self.navView.backgroundColor = maincolor;
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = whitecolor;
    searchView.layer.cornerRadius = 3;
    searchView.layer.shadowColor = [UIColor colorWithHexString:@"#DFE2E6"].CGColor;
    searchView.layer.shadowOffset = CGSizeMake(0, 2);
    searchView.layer.shadowOpacity = 1;
    [self.navView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navView).offset(20);
        make.right.mas_equalTo(self.navView.mas_right).with.offset(-60);
        make.bottom.mas_equalTo(self.navView).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UIImageView *searchLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    [searchView addSubview:searchLogo];
    [searchLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchView).offset(14);
    }];
    
    UILabel *placeHolder = [[UILabel alloc]init];
    placeHolder.text = @"搜书名找答案";
    placeHolder.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    placeHolder.textColor = [UIColor colorWithHexString:@"#909499"];
    [searchView addSubview:placeHolder];
    [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchLogo.mas_right).with.offset(10);
    }];
    UITapGestureRecognizer *toSearchGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSearch)];
    [searchView addGestureRecognizer:toSearchGes];
    
    //浏览记录
    UIImageView *historyLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"更新时间v2"]];
    [self.navView addSubview:historyLogo];
    [historyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(self.navView).offset(33);
        make.right.mas_equalTo(self.navView).offset(-20);
    }];
    historyLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *toHistoryGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHistory)];
    [historyLogo addGestureRecognizer:toHistoryGes];
    
}

- (void)setupView {
    self.view.backgroundColor = whitecolor;
    
    //适配所用的view
    UIView *topOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2 * TOP_OFFSET)];
    topOffsetView.backgroundColor = maincolor;
    [self.view addSubview:topOffsetView];
    
    //主页视图滚动的view
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_OFFSET, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT - BOT_OFFSET - TOP_OFFSET)];
    [self.view addSubview:mainView];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.bounces = NO;
    mainView.backgroundColor = maincolor;
    mainView.delegate = self;
    self.mainView = mainView;
    self.mainView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 500);
    
    UIView *mainContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainContentView.backgroundColor = whitecolor;
    [mainView addSubview:mainContentView];
    self.mainContentView = mainContentView;
    
    //头部视图
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.34 * SCREEN_WIDTH)];
    headerView.image = [UIImage imageNamed:@"首页头图"];
    [mainContentView addSubview:headerView];
    
    //浏览记录
    UIImageView *historyLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"更新时间v2"]];
    [self.view addSubview:historyLogo];
    [historyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(self.view).offset(33 + TOP_OFFSET);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    historyLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *toHistoryGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHistory)];
    [historyLogo addGestureRecognizer:toHistoryGes];
    
    //作文模块
    UIView *articleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.34 * SCREEN_WIDTH, SCREEN_WIDTH, 0.32 * SCREEN_WIDTH)];
    articleView.backgroundColor = whitecolor;
    [mainContentView addSubview:articleView];
    self.articleView = articleView;
    
    UIImageView *chineseArticleLogo = [[UIImageView alloc]init];
    chineseArticleLogo.image = [UIImage imageNamed:@"中文作文v2"];
    chineseArticleLogo.frame = CGRectMake(0.1 * SCREEN_WIDTH, 0.13 * SCREEN_WIDTH, 0.3 * SCREEN_WIDTH, 0.12 * SCREEN_WIDTH);
    [articleView addSubview:chineseArticleLogo];
    
    UIImageView *englishArticleLogo = [[UIImageView alloc]init];
    englishArticleLogo.image = [UIImage imageNamed:@"英文作文v2"];
    englishArticleLogo.frame = CGRectMake(0.6 * SCREEN_WIDTH, 0.13 * SCREEN_WIDTH, 0.3 * SCREEN_WIDTH, 0.12 * SCREEN_WIDTH);
    [articleView addSubview:englishArticleLogo];
    
    chineseArticleLogo.userInteractionEnabled = YES;
    englishArticleLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *toArticleGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toArticle)];
    [chineseArticleLogo addGestureRecognizer:toArticleGes];
    [englishArticleLogo addGestureRecognizer:toArticleGes];
    
    //搜索框
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = whitecolor;
    searchView.layer.cornerRadius = 3;
    searchView.layer.shadowColor = [UIColor colorWithHexString:@"#DFE2E6"].CGColor;
    searchView.layer.shadowOffset = CGSizeMake(0, 2);
    searchView.layer.shadowOpacity = 1;
    [mainContentView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(mainContentView);
        make.size.mas_equalTo(CGSizeMake(0.89 * SCREEN_WIDTH, 0.89 * SCREEN_WIDTH * 0.14));
        make.top.mas_equalTo(mainContentView).offset(0.277 * SCREEN_WIDTH);
    }];
    self.searchView = searchView;
    
    UIImageView *searchLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    [mainContentView addSubview:searchLogo];
    [searchLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchView).offset(14);
    }];
    self.searchLogo = searchLogo;
    
    UILabel *placeHolder = [[UILabel alloc]init];
    placeHolder.text = @"搜书名找答案";
    placeHolder.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    placeHolder.textColor = [UIColor colorWithHexString:@"#909499"];
    [mainContentView addSubview:placeHolder];
    [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchLogo.mas_right).with.offset(10);
    }];
    UITapGestureRecognizer *toSearchGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSearch)];
    [searchView addGestureRecognizer:toSearchGes];
    self.placeHolder = placeHolder;
    
    //分割线
    UILabel *line_one = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.66 * SCREEN_WIDTH, SCREEN_WIDTH, 0.02 * SCREEN_WIDTH)];
    line_one.backgroundColor = [[UIColor colorWithHexString:@"#F7F9FA"] colorWithAlphaComponent:0.8];
    [mainContentView addSubview:line_one];
    
    //我的书单
    UIView *myCollectionsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.68 * SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_WIDTH * 0.69)];
    myCollectionsView.backgroundColor = whitecolor;
    [mainContentView addSubview:myCollectionsView];
    self.myCollectionsView = myCollectionsView;
    
    UILabel *myListTitle = [[UILabel alloc]init];
    [myCollectionsView addSubview:myListTitle];
    myListTitle.text = @"我的书单";
    myListTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [myListTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myCollectionsView).offset(20);
        make.top.mas_equalTo(myCollectionsView).offset(0.04 * SCREEN_WIDTH);
    }];
    
    //蓝色小标记1
    UILabel *blueSign_one = [[UILabel alloc]init];
    blueSign_one.backgroundColor = [UIColor colorWithHexString:@"#49ACF2"];
    [myCollectionsView addSubview:blueSign_one];
    [blueSign_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(myCollectionsView);
        make.centerY.mas_equalTo(myListTitle);
        make.size.mas_equalTo(CGSizeMake(3, 18));
    }];
    
    
    UIImageView *blankStatusLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空状态"]];
    [myCollectionsView addSubview:blankStatusLogo];
    [blankStatusLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myListTitle.mas_bottom).offset(0.04 * SCREEN_WIDTH);
        make.centerX.mas_equalTo(myCollectionsView);
        make.size.mas_equalTo(CGSizeMake(0.37 * SCREEN_WIDTH, 0.37 * SCREEN_WIDTH));
    }];
    
    UILabel *blankStatusTitle = [[UILabel alloc]init];
    blankStatusTitle.text = @"书单是空的，快去搜索试试吧";
    blankStatusTitle.font = [UIFont systemFontOfSize:12];
    blankStatusTitle.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
    [myCollectionsView addSubview:blankStatusTitle];
    [blankStatusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blankStatusLogo.mas_bottom).with.offset(2);
        make.centerX.mas_equalTo(myCollectionsView);
        make.height.mas_equalTo(12);
    }];
    
    //分割线
    UILabel *line_two = [[UILabel alloc]initWithFrame:CGRectMake(0, 1.37 * SCREEN_WIDTH, SCREEN_WIDTH, 0.02 * SCREEN_WIDTH)];
    line_two.backgroundColor = [[UIColor colorWithHexString:@"#F7F9FA"] colorWithAlphaComponent:0.8];
    [mainContentView addSubview:line_two];
    
    //推荐模块
    UIView *recommendView = [[UIView alloc]initWithFrame:CGRectMake(0, 1.39 * SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_HEIGHT)];
    recommendView.backgroundColor = whitecolor;
    [mainContentView addSubview:recommendView];
    self.recommendView = recommendView;
    
    //为您推荐
    UILabel *recommendTitle = [[UILabel alloc]init];
    [recommendView addSubview:recommendTitle];
    recommendTitle.text = @"为您推荐";
    recommendTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [recommendTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(recommendView).offset(20);
        make.top.mas_equalTo(recommendView).offset(0.04 * SCREEN_WIDTH);
    }];
    
    //蓝色小标记2
    UILabel *blueSign_two = [[UILabel alloc]init];
    blueSign_two.backgroundColor = [UIColor colorWithHexString:@"#49ACF2"];
    [recommendView addSubview:blueSign_two];
    [blueSign_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(recommendView);
        make.centerY.mas_equalTo(recommendTitle);
        make.size.mas_equalTo(CGSizeMake(3, 18));
    }];
    
}

#pragma mark - 跳转
//前往我的列表
- (void)toMyList {
    if ([TTUserManager sharedInstance].isLogin) {
        MyListViewController *mylistVC = [[MyListViewController alloc]init];
        [self.navigationController pushViewController:mylistVC animated:YES];
    }
    else {
        [CommonAlterView showAlertView:@"请先登录"];
//        NSLog(@"请先登录");
    }
}

//前往作文页面
- (void)toArticle {
    NSLog(@"前往作文view");
}
//前往浏览记录
- (void)toHistory {
    NSLog(@"前往浏览记录");
}

//前往扫描
- (void)toScan {

    
    //注册通知：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBooKList:) name:@"shareCode" object:nil];
    
    QRScanViewController *scanVC = [[QRScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

-(void)showBooKList:(NSNotification *)notification {
    
    _code = notification.userInfo[@"shareCode"];
    _codes = notification.userInfo[@"shareCode"];
    NSLog(@"%@", _code);
    
}
//前往搜索界面
- (void)toSearch {

    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}




#pragma mark - 其他
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + 20;
    //0.79 0.1 * screenwidth = offsety/x
    CGFloat searchViewWidth = 0.89 * SCREEN_WIDTH;
    CGFloat searchViewHeight = 0.89 * SCREEN_WIDTH * 0.14;
    CGFloat xPosi = 0.055 * SCREEN_WIDTH;
    CGFloat yPosi = 0.277 * SCREEN_WIDTH;

    if (offsetY >= 0 && offsetY <= 0.34 * SCREEN_WIDTH - 52) {
        self.searchView.frame = CGRectMake(xPosi, yPosi - (offsetY/2.963) + (offsetY/11.6), searchViewWidth - (offsetY/2.02), searchViewHeight - (offsetY/5.81));
        self.searchLogo.y = yPosi - (offsetY/2.963) + (offsetY/11.6) + 11 - (offsetY/12.6);
        self.placeHolder.y = yPosi - (offsetY/2.963) + (offsetY/11.6) + 13 - (offsetY/12.6);
    }

    if (offsetY >= 0.34 * SCREEN_WIDTH - 52) {
        self.navView.hidden = NO;
    }
    else {
        self.navView.hidden = YES;
    }
}

#pragma mark - view生命周期
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLikeOrNot" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    if ([TTUserManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataForMyList) name:@"userLikeOrNot" object:nil];
        [self downloadDataForMyList];
    }
    
    if (self.code) {
        self.code = nil;
        BookListViewController *book = [[BookListViewController alloc] init];
        book.idStr = self.codes;
        book.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        [self presentViewController:book animated:NO completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


@end
