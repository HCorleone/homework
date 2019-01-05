//
//  ChineseViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ChineseViewController.h"
#import "ArticleDetailViewController.h"
#import "YZMenuButton.h"
#import "Article.h"
#import "ArticleCell.h"

#define MENU_HEIGHT 36

//static NSString *articleType = @"";
//static NSString *wordNum = @"";
//static NSString *grade = @"";
//static NSString *pageNo = @"";

@interface ChineseViewController ()<YZPullDownMenuDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) YZPullDownMenu *menu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *articleType;
@property (nonatomic, strong) NSString *wordNum;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *pageNo;

@end

@implementation ChineseViewController

- (NSString *)getLanguage {
    return @"1";
}

- (NSArray *)getTitles {
    return @[@"年级", @"题材", @"字数"];
}

- (From)getMenuType {
    return FromChineseArticle;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchView:) name:@"ChineseArticleNote" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChineseArticleNote" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.keyword = @"";
    self.articleType = @"";
    self.wordNum = @"";
    self.grade = @"";
    self.pageNo = @"1";
    [self setupNav];
    [self setupMenu];
    [self setupTableView];
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
        make.height.mas_equalTo(NAVBAR_HEIGHT + TOP_OFFSET);
    }];
    self.navView = navView;

    UISearchBar *testSearchBar = [[UISearchBar alloc]init];
    if(@available(iOS 11.0, *)) {
        [[testSearchBar.heightAnchor constraintEqualToConstant:44] setActive:YES];
    }
    testSearchBar.backgroundImage = [[UIImage alloc] init];
    testSearchBar.barTintColor = [UIColor whiteColor];
    testSearchBar.placeholder = @"请输入作文题目关键字";
    UITextField *searchField = [testSearchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.leftViewMode = UITextFieldViewModeNever;
        [testSearchBar setValue:searchField forKey:@"searchField"];
        //        testSearchBar.searchTextPositionAdjustment = (UIOffset){0, 0}; // 光标偏移量
    }
    testSearchBar.delegate = self;
    self.searchBar = testSearchBar;
    
    //用uiview的圆角去代替searchbar的圆角
    UIView *testView = [[UIView alloc]init];
    testView.backgroundColor = whitecolor;
    testView.layer.cornerRadius = 3;
    testView.layer.masksToBounds = YES;
    [self.navView addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.77 * SCREEN_WIDTH, 0.77 * SCREEN_WIDTH * 0.11));
        make.bottom.mas_equalTo(self.navView).offset(-10);
        make.left.mas_equalTo(self.navView).offset(20);
    }];
    
    [self.navView addSubview:testSearchBar];
    [testSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.77 * SCREEN_WIDTH, 0.77 * SCREEN_WIDTH * 0.11));
        make.bottom.mas_equalTo(self.navView).offset(-10);
        make.left.mas_equalTo(self.navView).offset(20);
    }];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [self.navView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(testView);
        make.right.mas_equalTo(self.navView).offset(-20);
    }];
    [cancelBtn addTarget:self action:@selector(hideNavView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hideNavView {
    [self.searchBar resignFirstResponder];
    self.fatherVC.navView.hidden = NO;
    self.fatherVC.articleScrollView.scrollEnabled = YES;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MENU_HEIGHT + TOP_OFFSET + NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - TOP_OFFSET - MENU_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"ArticleCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
}

#pragma mark - 下载数据操作
//下来刷新方法
- (void)pullToRefresh {
    //页数控制
    NSInteger flag = [self.pageNo integerValue];
    flag += 1;
    self.pageNo = [[NSNumber numberWithInteger:flag]stringValue];
    
    NSDictionary *dict = @{
                           @"keyword":self.keyword,
                           @"articleType":self.articleType,
                           @"language":self.language,
                           @"wordNum":self.wordNum,
                           @"grade":self.grade,
                           @"pageNo":self.pageNo,
                           @"pageSize":@""
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForArticle] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"没有数据"]) {
            [XWHUDManager showTipHUDInView:@"暂无搜索结果"];
        }
        if ([responseObject[@"code"] integerValue] == 200) {
                NSArray *jsonDataArr = responseObject[@"datas"];
                NSMutableArray *mArr = [NSMutableArray array];
                //建立模型数组
                for (int i =0; i < jsonDataArr.count; i++) {
                    NSDictionary *aDic = jsonDataArr[i];
                    Article *aModel = [Article initWithDic:aDic];
                    [mArr addObject:aModel];
                }
                [self.listData addObjectsFromArray:mArr];
                [self.tableView reloadData];
        }
        
    } failure:nil];
    [dataTask resume];
    
    
    [self.tableView.mj_footer endRefreshing];
}

- (void)downloadData {
    self.language = [self getLanguage];
    NSDictionary *dict = @{
                           @"keyword":self.keyword,
                           @"articleType":self.articleType,
                           @"language":self.language,
                           @"wordNum":self.wordNum,
                           @"grade":self.grade,
                           @"pageNo":@"",
                           @"pageSize":@""
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForArticle] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"没有数据"]) {
            [XWHUDManager showTipHUDInView:@"暂无搜索结果"];
        }
        if ([responseObject[@"code"] integerValue] == 200) {
                NSArray *jsonDataArr = responseObject[@"datas"];
                self.listData = [NSMutableArray array];
                //建立模型数组
                for (int i =0; i < jsonDataArr.count; i++) {
                    NSDictionary *aDic = jsonDataArr[i];
                    Article *aModel = [Article initWithDic:aDic];
                    [self.listData addObject:aModel];
                }
                [self.tableView reloadData];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

//分类搜索
- (void)refreshSearchView:(NSNotification *)note {
    NSDictionary *dic = [note userInfo];
    if ([dic[@"col"] integerValue] == 0) {
        self.grade = dic[@"title"];
        if ([self.grade isEqualToString:@"全部年级"]) {
            self.grade = @"";
        }
    }
    else if ([dic[@"col"] integerValue] == 1) {
        self.articleType = dic[@"title"];
        if ([self.articleType isEqualToString:@"全部题材"]) {
            self.articleType = @"";
        }
    }
    else if ([dic[@"col"] integerValue] == 2) {
        self.wordNum = dic[@"title"];
        if ([self.wordNum isEqualToString:@"全部字数"]) {
            self.wordNum = @"";
        }
    }
    
    [self downloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    cell.model = self.listData[indexPath.row];
 
    return cell;
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 136;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailViewController *articleDetailVC = [[ArticleDetailViewController alloc] init];
    articleDetailVC.model = self.listData[indexPath.row];
    [self.navigationController pushViewController:articleDetailVC animated:YES];
}

#pragma mark - 搜索菜单栏
- (void)setupMenu {
    
    //菜单栏
    YZPullDownMenu *menu = [YZPullDownMenu alloc];
    menu.from = [self getMenuType];
    menu = [menu initWithFrame:CGRectMake(0, NAVBAR_HEIGHT + TOP_OFFSET, SCREEN_WIDTH, MENU_HEIGHT)];
    [self.view addSubview:menu];
    
    menu.dataSource = self;
    
    _titles = [self getTitles];
    
    [self setupAllChildViewController];
}

- (void)setupAllChildViewController {
    ArticleGradeViewController *test1 =[[ArticleGradeViewController alloc] init];
    test1.from = FromChinese;
    ArticleTypeViewController *test2 = [[ArticleTypeViewController alloc] init];
    test2.from = FromChinese;
    WordsNumViewController *test3 = [[WordsNumViewController alloc] init];
    test3.from = FromChinese;
    [self addChildViewController:test1];
    [self addChildViewController:test2];
    [self addChildViewController:test3];

}

#pragma mark - SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    
    if ([TextCheckTool lc_checkingSpecialChar:self.searchBar.text]) {
        [XWHUDManager showWarningTipHUDInView:@"不能含有非法字符"];
        return;
    }
    
    self.keyword = self.searchBar.text;
    [self downloadData];
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor colorWithHexString:@"#939699"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#FA8919"] forState:UIControlStateSelected];
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
        return 0.61 * SCREEN_WIDTH;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 1.27 * SCREEN_WIDTH;
    }
    
    // 第3列 高度
    return 0.4 * SCREEN_WIDTH;

}

@end
