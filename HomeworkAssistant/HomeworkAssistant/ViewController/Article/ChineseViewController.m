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

static NSString *articleType = @"";
//static NSString *language = @"1";
static NSString *wordNum = @"";
static NSString *grade = @"";
static NSString *pageNo = @"";

@interface ChineseViewController ()<YZPullDownMenuDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) YZPullDownMenu *menu;
@property (nonatomic, strong) UITableView *tableView;

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
    articleType = @"";
    wordNum = @"";
    grade = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupMenu];
    [self setupTableView];
    [self downloadData];
    
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MENU_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - TOP_OFFSET - MENU_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"ArticleCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
}

#pragma mark - 下载数据操作
//下来刷新方法
- (void)pullToRefresh {
    //页数控制
    NSInteger flag = [pageNo integerValue];
    flag += 1;
    pageNo = [[NSNumber numberWithInteger:flag]stringValue];
    
    NSDictionary *dict = @{
                           @"keyword":@"",
                           @"articleType":articleType,
                           @"language":self.language,
                           @"wordNum":wordNum,
                           @"grade":grade,
                           @"pageNo":pageNo,
                           @"pageSize":@"",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForArticle] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"] == [NSNull null]) {
                [XWHUDManager showHUDMessage:@"暂无搜索结果"];
            }
            else {
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
        }
        
    } failure:nil];
    [dataTask resume];
    
    
    [self.tableView.mj_footer endRefreshing];
}

- (void)downloadData {
    self.language = [self getLanguage];
    pageNo = @"1";
    NSDictionary *dict = @{
                           @"keyword":@"",
                           @"articleType":articleType,
                           @"language":self.language,
                           @"wordNum":wordNum,
                           @"grade":grade,
                           @"pageNo":@"",
                           @"pageSize":@"",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForArticle] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"] == [NSNull null]) {
                [XWHUDManager showHUDMessage:@"暂无搜索结果"];
            }
            else {
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
        }
        
    } failure:nil];
    [dataTask resume];
    
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ArticleDetailViewController *articleDetailVC = [[ArticleDetailViewController alloc] init];
//    articleDetailVC.model = self.listData[indexPath.row];
//    [self.navigationController pushViewController:articleDetailVC animated:YES];
//}

#pragma mark - 搜索菜单栏
- (void)setupMenu {
    
    //菜单栏
    YZPullDownMenu *menu = [YZPullDownMenu alloc];
    menu.from = [self getMenuType];
    menu = [menu initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MENU_HEIGHT)];
    [self.view addSubview:menu];
    
    menu.dataSource = self;
    
    _titles = [self getTitles];
    
    [self setupAllChildViewController];
}

- (void)setupAllChildViewController {
    ArticleGradeViewController *test1 =[[ArticleGradeViewController alloc] init];
    test1.from = FromChinese;
    UIViewController *test2 = [[UIViewController alloc] init];
    UIViewController *test3 = [[UIViewController alloc] init];
    [self addChildViewController:test1];
    [self addChildViewController:test2];
    [self addChildViewController:test3];

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
    return 450;

}

@end
