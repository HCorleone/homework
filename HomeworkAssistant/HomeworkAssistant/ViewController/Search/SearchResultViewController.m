//
//  SearchResultViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/26.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SearchResultViewController.h"
#import "RecommendStaticCell.h"
#import "RecommendTableView.h"
#import "AnswerViewController.h"
#import "Book.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "GradeViewController.h"
#import "SubjectViewController.h"
#import "VersionViewController.h"
#import "QRScanViewController.h"
#import "YearViewController.h"

static NSString *grade = @"";
static NSString *subject = @"";
static NSString *version = @"";
static NSString *volume = @"";
static NSString *page = @"1";

@interface SearchResultViewController ()<UISearchBarDelegate, YZPullDownMenuDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) RecommendTableView *searchResultView;

@end

@implementation SearchResultViewController
#pragma mark - view生命周期
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =whitecolor;
    
    [self setupNav];
    [self setupMenu];
    [self downloadData];
}



#pragma mark - 搜索结果view
//请求搜索
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
//初始化搜索结果view
- (void)setupViewWithList:(NSMutableArray *)array {
    
    RecommendTableView *rTableView = [[RecommendTableView alloc]initWithFrame:CGRectMake(0, 108 + TOP_OFFSET, SCREEN_WIDTH,SCREEN_HEIGHT - 108 - TOP_OFFSET) style:UITableViewStylePlain withArray:array];
    [self.view addSubview:rTableView];
    rTableView.scrollEnabled = YES;
    rTableView.estimatedRowHeight = 0;
    rTableView.estimatedSectionHeaderHeight = 0;
    rTableView.estimatedSectionFooterHeight = 0;
    rTableView.delegate = self;
    self.searchResultView = rTableView;
    self.searchResultView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
}
//下来刷新方法
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

//分类搜索
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

#pragma mark - SearchBarDelegate
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







#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendStaticCell *cell = [self.searchResultView cellForRowAtIndexPath:indexPath];
    
    AnswerViewController *answerVC = [[AnswerViewController alloc]init];
    answerVC.bookModel = self.searchResult[indexPath.row];
    answerVC.isSelected = cell.isSelected;
    [self.navigationController pushViewController:answerVC animated:YES];
    
}

#pragma mark - 搜索菜单栏
- (void)setupMenu {
    
    //菜单栏
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 72 + TOP_OFFSET, SCREEN_WIDTH, 36);
    [self.view addSubview:menu];
    
    menu.dataSource = self;
    
    _titles = @[@"年级", @"科目", @"版本", @"年份"];
    
    [self setupAllChildViewController];
}

- (void)setupAllChildViewController {
    GradeViewController *test1 =[[GradeViewController alloc] init];
    SubjectViewController *test2 =[[SubjectViewController alloc] init];
    VersionViewController *test3 =[[VersionViewController alloc] init];
    YearViewController *test4 = [[YearViewController alloc] init];
    [self addChildViewController:test1];
    [self addChildViewController:test2];
    [self addChildViewController:test3];
    [self addChildViewController:test4];
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return 4;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor colorWithHexString:@"#939699"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#2988CC"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"下拉icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"上拉icon"] forState:UIControlStateSelected];
    
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
        return 1.1 * SCREEN_WIDTH;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 0.53 * SCREEN_WIDTH;
    }
    
    // 第3列 高度
    if (index == 2) {
        return 450;
    }
    
    // 第4列 高度
    return 0.3 * SCREEN_WIDTH;
}

#pragma mark - other
//前往扫描
- (void)toScan {
    QRScanViewController *scanVC = [[QRScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UISearchBar *testSearchBar = [[UISearchBar alloc]init];
    if(@available(iOS 11.0, *)) {
        [[testSearchBar.heightAnchor constraintEqualToConstant:44] setActive:YES];
    }
    testSearchBar.backgroundImage = [[UIImage alloc] init];
    testSearchBar.barTintColor = [UIColor whiteColor];
    testSearchBar.placeholder = @"搜书名找答案";
    UITextField *searchField = [testSearchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.leftViewMode = UITextFieldViewModeNever;
        [testSearchBar setValue:searchField forKey:@"searchField"];
//        testSearchBar.searchTextPositionAdjustment = (UIOffset){0, 0}; // 光标偏移量
    }
    testSearchBar.delegate = self;
    testSearchBar.text = self.searchContent;
    self.searchBar = testSearchBar;
    
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

@end
