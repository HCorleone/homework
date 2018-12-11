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

@interface MainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIView *mainContentView;
@property (nonatomic, strong) RecommendTableView *recommendListView;
@property (nonatomic, strong) MyListView *myListView;
@property (nonatomic, strong) UIView *myListContainer;
@property (nonatomic, strong) NSMutableArray *myListViewData;
@property (nonatomic, strong) NSMutableArray *recommendListViewData;
@property (nonatomic, strong) QRCodeView *testView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
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

- (void)downloadDataForMyList {
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSString *URL = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?";
    NSDictionary *dict = @{
                           @"h":@"ZYListUserLikeHandler",
                           @"openID":openId,
                           @"pkn":@"com.enjoytime.palmhomework",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
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
    
    UIView *myListContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 220, screenWidth, 200)];
    [self.mainContentView addSubview:myListContainer];
    self.myListContainer = myListContainer;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"分享给同学"] forState:UIControlStateNormal];
    [myListContainer addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(myListContainer);
        make.bottom.mas_equalTo(myListContainer).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 16.5));
    }];
    [shareBtn addTarget:self action:@selector(shareMyList) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(83.5, 150);
    MyListView *myListView = [[MyListView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 175) collectionViewLayout:layout withArray:array];
    [myListContainer addSubview:myListView];
    self.myListView = myListView;
}

- (void)shareMyList {
    
    QRCodeView *testView = [[QRCodeView alloc]init];
    [testView showQRCode];
    self.testView = testView;
}

- (void)downloadDataForRec {
    
    NSString *openId = @"";
    if ([TTUserManager sharedInstance].isLogin) {
        openId = [TTUserManager sharedInstance].currentUser.openId;
    }
    
    NSString *URL = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?";
    NSDictionary *dict = @{
                           @"h":@"ZYRecHandler",
                           @"openID":openId,
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
    RecommendTableView *rTableView = [[RecommendTableView alloc]initWithFrame:CGRectMake(0, 456, screenWidth,array.count * 128 ) style:UITableViewStylePlain withArray:array];
    [self.mainContentView addSubview:rTableView];
    //    self.mainView.contentSize = CGSizeMake(screenWidth, 456 + rTableView.frame.size.height);
}

//导航栏
- (void)setupNavView {
    
    UIView *topOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, TOP_OFFSET)];
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
    searchView.layer.cornerRadius = 4;
    //    searchView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    searchView.layer.shadowOffset = CGSizeMake(0, 1);
    //    searchView.layer.shadowOpacity = 0.3;
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
    
    //二维码扫描
    UIImageView *scanLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"扫一扫"]];
    [self.navView addSubview:scanLogo];
    [scanLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(self.navView).offset(33);
        make.right.mas_equalTo(self.navView).offset(-20);
    }];
    scanLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *toScanGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toScan)];
    [scanLogo addGestureRecognizer:toScanGes];
    
}

- (void)setupView {
    self.view.backgroundColor = whitecolor;
    
    UIView *topOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, TOP_OFFSET)];
    topOffsetView.backgroundColor = maincolor;
    [self.view addSubview:topOffsetView];
    
    UIScrollView *mainView = [[UIScrollView alloc]init];
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(TOP_OFFSET);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(screenHeight - tabbarheight - BOT_OFFSET - TOP_OFFSET);
    }];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.bounces = NO;
    mainView.backgroundColor = maincolor;
    mainView.delegate = self;
    self.mainView =mainView;
    
    
    self.mainView.contentSize = CGSizeMake(screenWidth, 30*128 + 456);
    //    self.mainView.userInteractionEnabled = NO;
    
    UIView *mainContentView = [[UIView alloc]init];
    mainContentView.backgroundColor = whitecolor;
    [self.mainView addSubview:mainContentView];
    [mainContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(self.mainView);
        make.size.mas_equalTo(self.mainView.contentSize);
    }];
    self.mainContentView = mainContentView;
    
    UIImageView *headerView = [UIImageView new];
    headerView.image = [UIImage imageNamed:@"首页头图"];
    [mainContentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(mainContentView);
        make.height.mas_equalTo(132);
    }];
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = whitecolor;
    searchView.layer.cornerRadius = 4;
    searchView.layer.shadowColor = [UIColor blackColor].CGColor;
    searchView.layer.shadowOffset = CGSizeMake(0, 1);
    searchView.layer.shadowOpacity = 0.3;
    [mainContentView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).with.offset(20);
        make.right.mas_equalTo(headerView.mas_right).with.offset(-20);
        make.height.mas_equalTo(48);
        make.centerY.mas_equalTo(headerView.mas_bottom);
    }];
    self.searchView = searchView;
    
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
    
    //二维码扫描
    UIImageView *scanLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"扫一扫"]];
    [self.view addSubview:scanLogo];
    [scanLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(self.view).offset(33 + TOP_OFFSET);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    scanLogo.userInteractionEnabled = YES;
    UITapGestureRecognizer *toScanGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toScan)];
    [scanLogo addGestureRecognizer:toScanGes];
    
    //我的书单
    UILabel *mylist = [[UILabel alloc]init];
    [self.mainContentView addSubview:mylist];
    mylist.text = @"我的书单";
    mylist.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [mylist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainContentView).offset(20);
        make.top.mas_equalTo(self.mainContentView).offset(185);
        make.size.mas_equalTo(CGSizeMake(72, 25));
    }];
    
    UIImageView *blankStatus = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空状态"]];
    [self.mainContentView addSubview:blankStatus];
    [blankStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainContentView).offset(225);
        make.centerX.mas_equalTo(self.mainContentView);
        make.size.mas_equalTo(CGSizeMake(137, 137));
    }];
    
    UILabel *blankLable = [[UILabel alloc]init];
    blankLable.text = @"书单是空的，快去搜索试试吧";
    blankLable.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:6];
    blankLable.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
    [self.mainContentView addSubview:blankLable];
    [blankLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blankStatus.mas_bottom).with.offset(2);
        make.centerX.mas_equalTo(self.mainContentView);
        make.height.mas_equalTo(12);
    }];
    
    //查看全部按钮
    UIButton *checkMyList = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainContentView addSubview:checkMyList];
    [checkMyList setTitle:@"查看全部" forState:UIControlStateNormal];
    [checkMyList setTitleColor:[UIColor colorWithHexString:@"#909499"] forState:UIControlStateNormal];
    checkMyList.titleLabel.font = [UIFont systemFontOfSize:12];
    [checkMyList setBackgroundColor:[UIColor clearColor]];
    [checkMyList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainContentView).offset(-20);
        make.top.mas_equalTo(self.mainContentView).offset(192);
        make.size.mas_equalTo(CGSizeMake(60, 12));
    }];
    [checkMyList addTarget:self action:@selector(toMyList) forControlEvents:UIControlEventTouchUpInside];
    
    //为您推荐
    UILabel *recommend = [[UILabel alloc]init];
    [self.mainContentView addSubview:recommend];
    recommend.text = @"为您推荐";
    recommend.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [recommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainContentView).offset(20);
        make.top.mas_equalTo(self.mainContentView).offset(420.5);
        make.size.mas_equalTo(CGSizeMake(72, 25));
    }];
    
    
}

- (void)toMyList {
    if ([TTUserManager sharedInstance].isLogin) {
        MyListViewController *mylistVC = [[MyListViewController alloc]init];
        [self.navigationController pushViewController:mylistVC animated:YES];
    }
    else {
        NSLog(@"请先登录");
    }
}

- (void)toScan {
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"shareCode" object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        NSDictionary *dic = [note userInfo];
//        NSLog(@"%@",dic[@"shareCode"]);
//        QRCodeView *testView = [[QRCodeView alloc]init];
//        [testView showQRCode];
//    }];
    
    QRScanViewController *scanVC = [[QRScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)toSearch {
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + 20;
    CGFloat searchViewWidth = screenWidth - 40;
    CGFloat searchViewHeight = self.searchView.frame.size.height;
    CGFloat xPosi = self.searchView.frame.origin.x;
    CGFloat yPosi = 109;
    
    if (offsetY >= 0 && offsetY <= 80) {
        self.searchView.frame = CGRectMake(xPosi, yPosi - (offsetY/2.963), searchViewWidth - (offsetY/2), searchViewHeight);
        
    }
    
    if (offsetY >= 80) {
        self.navView.hidden = NO;
    }
    else {
        self.navView.hidden = YES;
    }
}

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([TTUserManager sharedInstance].isLogin) {
        [self downloadDataForMyList];
    }
}

@end
