//
//  SearchViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/22.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "SearchHistoryCell.h"
#import "ButtonLinks.h"
#import "FLJSearchBar.h"

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *hotWordsView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSMutableArray *hotwordsList;
@property (nonatomic, strong) NSMutableArray *searchWordsArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    [self setupNav];
    [self loadHotWords];
    [self setupHistory];
    
    
}

- (void)setupHistory {
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    grayLine.layer.opacity = 0.3;
    [self.view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(210 + TOP_OFFSET);
        make.height.mas_equalTo(8);
    }];
    
    UIView *historyView = [[UIView alloc]init];
    historyView.backgroundColor = whitecolor;
    [self.view addSubview:historyView];
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(grayLine.mas_bottom);
    }];
    
    UILabel *history = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 20)];
    [historyView addSubview:history];
    history.text = @"历史搜索";
    history.textColor = [UIColor colorWithHexString:@"#909499"];
    history.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    
    UIImageView *clearHistory = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"清除历史"]];
    clearHistory.userInteractionEnabled = YES;
    [historyView addSubview:clearHistory];
    [clearHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(historyView).offset(-20);
        make.centerY.mas_equalTo(history);
    }];
    UITapGestureRecognizer *clearBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearHistory)];
    [clearHistory addGestureRecognizer:clearBtn];
    
    //分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, screenWidth - 40, 0.5)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
    line.layer.opacity = 0.3;
    [historyView addSubview:line];
      
      //搜索历史
    UITableView *historyTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [historyView addSubview:historyTableView];
    [historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.bounces = NO;
    historyTableView.scrollEnabled = NO;
    historyTableView.showsVerticalScrollIndicator = NO;
    [historyTableView registerClass:[SearchHistoryCell class] forCellReuseIdentifier:@"SearchHistoryCell"];
    self.historyTableView = historyTableView;
}

- (void)clearHistory {
    NSArray *arr = [NSArray array];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"historyWords"];
    self.searchWordsArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"];
    [self.historyTableView reloadData];
}

- (void)loadHotWords {
    
    //    NSString *URL = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?h=ZYRecHandler&openID=123&av=_debug_";
    
    NSDictionary *dict = @{
                           @"h":@"ZYSearchHotWordsHandler",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:zuoyeURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *jsonDataArr = responseObject[@"datas"];
            self.hotwordsList = [NSMutableArray array];
            [self.hotwordsList addObjectsFromArray:jsonDataArr];
        }
        [self loadHotWordsViewWithArr:self.hotwordsList];
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)loadHotWordsViewWithArr:(NSMutableArray *)array {
    int flag = 0;
    UIView *hotWordsView = [[UIView alloc]init];
    [self.view addSubview:hotWordsView];
    [hotWordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(screenWidth, 120));
    }];
    self.hotWordsView = hotWordsView;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            ButtonLinks *hotWordsBtn = [ButtonLinks buttonWithType:UIButtonTypeCustom];
            [hotWordsView addSubview:hotWordsBtn];
            [hotWordsBtn setTitle:(NSString *)array[flag] forState:UIControlStateNormal];
            flag++;
            [hotWordsBtn setTitleColor:UIColorFromRGB(0x169ED9) forState:UIControlStateNormal];
            hotWordsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            //设置下划线
            [hotWordsBtn setLinkColor:UIColorFromRGB(0x169ED9)];
            hotWordsBtn.frame = CGRectMake(j * screenWidth/3, i * 40, screenWidth/3, 40);
            [hotWordsBtn addTarget:self action:@selector(toSearch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
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
    FLJSearchBar *searchBar = [[FLJSearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth * 0.787, 34)];
    searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    searchBar.placeHolderStringFont = [UIFont systemFontOfSize:14.0];
    searchBar.cornerRadius = 4;
    searchBar.tintColor = ClickColor;//光标颜色
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    [searchBar setBackgroundImage:searchBarBg];
    searchBar.placeholder = @"搜书名找答案";
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





- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
//    [self.searchBar resignFirstResponder];
    
    if (self.searchWordsArr == nil) {
        self.searchWordsArr = [NSMutableArray array];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"]) {
        self.searchWordsArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"];
    }
    else {
        NSMutableArray *arr = [NSMutableArray array];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"historyWords"];
        self.searchWordsArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"];
    }
    
    if (self.historyTableView) {
        [self.historyTableView reloadData];
    }
    
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

- (void)toSearch:(UIButton *)sender {
    self.searchBar.text = sender.titleLabel.text;
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    
    if ([TextCheckTool lc_checkingSpecialChar:self.searchBar.text]) {
//        NSLog(@"不能含有非法字符");
        [CommonAlterView showAlertView:@"不能含有非法字符"];
        return;
    }
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"];
    self.searchWordsArr = [NSMutableArray arrayWithArray:arr];
    if ([self.searchWordsArr containsObject:self.searchBar.text]) {
        NSUInteger flag = [self.searchWordsArr indexOfObject:self.searchBar.text];
        [self.searchWordsArr removeObjectAtIndex:flag];
    }
    [self.searchWordsArr insertObject:self.searchBar.text atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.searchWordsArr forKey:@"historyWords"];
    
    SearchResultViewController *searchResultVC = [[SearchResultViewController alloc]init];
    searchResultVC.searchContent = self.searchBar.text;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchWordsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell" forIndexPath:indexPath];
    cell.historyWords.text = self.searchWordsArr[indexPath.row];
    return cell;
}

#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.text = self.searchWordsArr[indexPath.row];
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
