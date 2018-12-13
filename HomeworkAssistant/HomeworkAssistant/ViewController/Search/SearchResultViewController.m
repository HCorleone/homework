//
//  SearchResultViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/26.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SearchResultViewController.h"
#import "RecommendTableView.h"
#import "Book.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "GradeViewController.h"
#import "SubjectViewController.h"
#import "VersionViewController.h"

static NSString *grade = @"";
static NSString *subject = @"";
static NSString *version = @"";
static NSString *volume = @"";
static NSString *page = @"1";

@interface SearchResultViewController ()<UISearchBarDelegate, YZPullDownMenuDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) RecommendTableView *searchResultView;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =whitecolor;
    
    [self setupNav];
    [self setupMenu];
    [self downloadData];
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
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).offset(20);
        make.bottom.mas_equalTo(self.navView).offset(-15);
    }];
    
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
    searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    [searchBar setBackgroundImage:searchBarBg];
    searchBar.placeholder = @"搜书名找答案";
    searchBar.text = self.searchContent;
    [self.navView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navView).with.offset(48);
        make.centerY.mas_equalTo(backBtn);
        make.right.mas_equalTo(self.navView).with.offset(-68);
    }];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor clearColor];
    [self.navView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backBtn);
        make.right.mas_equalTo(self.navView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 24));
    }];
    [searchBtn addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)downloadData {
    page = @"1";
    NSDictionary *dict = @{
                           @"h":@"ZYSearchAnswerHandler",
                           @"keyword":self.searchContent,
                           @"grade":grade,
                           @"subject":subject,
                           @"bookVersion":version,
                           @"volume":volume,
                           @"year":@"",
                           @"pageNo":@"",
                           @"pageSize":@"",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:zuoyeURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"] == [NSNull null]) {
//                NSLog(@"数组为空");
                [CommonAlterView showAlertView:@"无搜索结果"];
            }
            else {
                NSArray *jsonDataArr = responseObject[@"datas"];
                self.searchResult = [NSMutableArray array];
                //建立模型数组
                for (int i =0; i < jsonDataArr.count; i++) {
                    NSDictionary *aDic = jsonDataArr[i];
                    Book *aModel = [Book initWithDic:aDic];
                    [self.searchResult addObject:aModel];
                }
                if (self.searchResultView) {
                    [self.searchResultView reloadDataWithList:self.searchResult];
                }
                else {
                    [self setupViewWithList:self.searchResult];
                }
            }
        }
        
    } failure:nil];
    [dataTask resume];
    
    
    
}

- (void)setupViewWithList:(NSMutableArray *)array {
    
    RecommendTableView *rTableView = [[RecommendTableView alloc]initWithFrame:CGRectMake(0, 108 + TOP_OFFSET, screenWidth,screenHeight - 108 - TOP_OFFSET) style:UITableViewStylePlain withArray:array];
    [self.view addSubview:rTableView];
    rTableView.scrollEnabled = YES;
    rTableView.estimatedRowHeight = 0;
    rTableView.estimatedSectionHeaderHeight = 0;
    rTableView.estimatedSectionFooterHeight = 0;
    self.searchResultView = rTableView;
    self.searchResultView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
}

- (void)pullToRefresh {
    //页数控制
    NSInteger flag = [page integerValue];
    flag += 1;
    page = [[NSNumber numberWithInteger:flag]stringValue];
    
    NSDictionary *dict = @{
                           @"h":@"ZYSearchAnswerHandler",
                           @"keyword":self.searchContent,
                           @"grade":grade,
                           @"subject":subject,
                           @"bookVersion":version,
                           @"volume":volume,
                           @"year":@"",
                           @"pageNo":page,
                           @"pageSize":@"",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:zuoyeURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"] == [NSNull null]) {
//                NSLog(@"数组为空");
                [CommonAlterView showAlertView:@"无更多搜索结果"];
            }
            else {
                NSArray *jsonDataArr = responseObject[@"datas"];
                NSMutableArray *mArr = [NSMutableArray array];
                //建立模型数组
                for (int i =0; i < jsonDataArr.count; i++) {
                    NSDictionary *aDic = jsonDataArr[i];
                    Book *aModel = [Book initWithDic:aDic];
                    [mArr addObject:aModel];
                }
                if (self.searchResultView) {
                    [self.searchResult addObjectsFromArray:mArr];
                    [self.searchResultView reloadDataWithList:self.searchResult];
                }
            }
        }
        
    } failure:nil];
    [dataTask resume];
    
    
    [self.searchResultView.mj_footer endRefreshing];
}



- (void)setupMenu {
    
    //菜单栏
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 72 + TOP_OFFSET, screenWidth, 36);
    [self.view addSubview:menu];
    
    menu.dataSource = self;
    
    _titles = @[@"年级",@"科目",@"版本"];
    
    [self setupAllChildViewController];
}

- (void)setupAllChildViewController {
    GradeViewController *test1 =[[GradeViewController alloc] init];
    SubjectViewController *test2 =[[SubjectViewController alloc] init];
    VersionViewController *test3 =[[VersionViewController alloc] init];
    [self addChildViewController:test1];
    [self addChildViewController:test2];
    [self addChildViewController:test3];
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    
    if ([TextCheckTool lc_checkingSpecialChar:self.searchBar.text]) {
//        NSLog(@"不能含有非法字符");
        [CommonAlterView showAlertView:@"不能含有非法字符"];
        return;
    }
    
    self.searchContent = self.searchBar.text;
    [self downloadData];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YZUpdateMenuTitleNote" object:nil];
    grade = @"";
    subject = @"";
    version = @"";
    volume = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchView:) name:@"YZUpdateMenuTitleNote" object:nil];
    
}

- (void)refreshSearchView:(NSNotification *)note {
    NSDictionary *dic = [note userInfo];
    if ([dic[@"col"] integerValue] == 0) {
        grade = dic[@"title"];
        if ([grade isEqualToString:@"全部年级"]) {
            grade = @"";
        }
    }
    else if ([dic[@"col"] integerValue] == 1) {
        subject = dic[@"title"];
        if ([subject isEqualToString:@"全部科目"]) {
            subject = @"";
        }
    }
    else if ([dic[@"col"] integerValue] == 2) {
        if ([dic[@"section"] integerValue] == 0) {
            volume = dic[@"volume"];
        }
        else if ([dic[@"section"] integerValue] == 1) {
            version = dic[@"version"];
            if ([version isEqualToString:@"全部版本"]) {
                version = @"";
            }
        }
    }
    [self downloadData];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return 450;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 300;
    }
    
    // 第3列 高度
    return 500;
}

@end
