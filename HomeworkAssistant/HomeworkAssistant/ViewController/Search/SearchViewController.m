//
//  SearchViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/22.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "ButtonLinks.h"
#import "QRScanViewController.h"
#import "BookListViewController.h"

@interface SearchViewController ()<PYSearchViewControllerDelegate>

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) NSMutableArray *hotwordsList;

@property (nonatomic, strong) PYSearchViewController *searchViewController;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    
    [self setupSearchView];
    [self setupNav];
}

- (void)setupSearchView {
    NSArray *hotSeaches = @[@"数学课本", @"全品作业本", @"名校课堂", @"能力培养与测试", @"同步导学案课时练", @"同步测控优化设计", @"优翼学练优", @"基础训练", @"全品学练考", @"同步指导训练", @"同步解析与测评"];
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜书名找答案"];
    
    [self addChildViewController:searchViewController];
    searchViewController.view.frame = CGRectMake(0, 72 + TOP_OFFSET, SCREEN_WIDTH, SCREEN_HEIGHT - 72 - TOP_OFFSET);
    [self.view addSubview:searchViewController.view];
    self.searchViewController = searchViewController;
    self.searchViewController.delegate = self;
    
    
}

- (void)loadHotWords {

    NSDictionary *dict = [NSDictionary dictionary];
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForSearchHotWords] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *jsonDataArr = responseObject[@"datas"];
            self.hotwordsList = [NSMutableArray array];
            [self.hotwordsList addObjectsFromArray:jsonDataArr];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)setupNav {
    
    //导航栏
    UIView *navView = [[UIView alloc]init];
    [self.view addSubview:navView];
    navView.backgroundColor = maincolor;
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(72 + TOP_OFFSET);
    }];
    self.navView = navView;
    
    //扫描按钮
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setImage:[UIImage imageNamed:@"扫一扫v2"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(toScan) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).offset(16);
        make.bottom.mas_equalTo(self.navView).offset(-15);
    }];

    UISearchBar *testSearchBar = self.searchViewController.searchBar;
    if(@available(iOS 11.0, *)) {
        [[testSearchBar.heightAnchor constraintEqualToConstant:44] setActive:YES];
    }
    testSearchBar.backgroundImage = [[UIImage alloc] init];
    testSearchBar.barTintColor = [UIColor whiteColor];
    
    UITextField *searchField = [testSearchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.font = [UIFont systemFontOfSize:14];
        [testSearchBar setValue:searchField forKey:@"searchField"];
        testSearchBar.searchTextPositionAdjustment = (UIOffset){13, 0}; // 光标偏移量
        
    }
    
    //用uiview的圆角去代替searchbar的圆角
    UIView *testView = [[UIView alloc]init];
    testView.backgroundColor = whitecolor;
    testView.layer.cornerRadius = 3;
    testView.layer.masksToBounds = YES;
    [self.navView addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.67 * SCREEN_WIDTH, 0.67 * SCREEN_WIDTH * 0.125));
        make.centerY.mas_equalTo(scanBtn);
        make.left.mas_equalTo(self.navView).offset(0.14 * SCREEN_WIDTH);
    }];
    
    [self.navView addSubview:testSearchBar];
    [testSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.67 * SCREEN_WIDTH, 0.67 * SCREEN_WIDTH * 0.125));
        make.centerY.mas_equalTo(scanBtn);
        make.left.mas_equalTo(self.navView).offset(0.14 * SCREEN_WIDTH);
    }];

    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [self.navView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(scanBtn);
        make.right.mas_equalTo(self.navView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 24));
    }];
    [cancelBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    
}



//前往扫描
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar: (UISearchBar *)searchBar searchText:(NSString *)searchText {
    
    if ([TextCheckTool lc_checkingSpecialChar:searchText]) {
        [XWHUDManager showWarningTipHUDInView:@"不能含有非法字符"];
        return;
    }
    SearchResultViewController *searchResultVC = [[SearchResultViewController alloc]init];
    searchResultVC.searchContent = searchText;
    [self.navigationController pushViewController:searchResultVC animated:YES];
    
}
@end
