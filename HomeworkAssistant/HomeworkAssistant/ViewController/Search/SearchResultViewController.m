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

@interface SearchResultViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResult;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =whitecolor;
    
    [self setupNav];
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
        make.height.mas_equalTo(66);
    }];
    self.navView = navView;
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).with.offset(20);
        make.bottom.mas_equalTo(self.navView).with.offset(-10);
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
    

    NSString *URL = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?";
    
    NSDictionary *dict = @{
                           @"h":@"ZYSearchAnswerHandler",
                           @"keyword":self.searchContent,
                           @"grade":@"",
                           @"subject":@"",
                           @"bookVersion":@"",
                           @"volume":@"",
                           @"year":@"",
                           @"pageNo":@"",
                           @"pageSize":@"",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *jsonDataArr = responseObject[@"datas"];
            self.searchResult = [NSMutableArray array];
            //建立模型数组
            for (int i =0; i < jsonDataArr.count; i++) {
                NSDictionary *aDic = jsonDataArr[i];
                Book *aModel = [Book initWithDic:aDic];
                [self.searchResult addObject:aModel];
            }
        }
        [self setupViewWithList:self.searchResult];
        
        
    } failure:nil];
    [dataTask resume];
    
    
    
}

- (void)setupViewWithList:(NSMutableArray *)array {
    //为您推荐
    RecommendTableView *rTableView = [[RecommendTableView alloc]initWithFrame:CGRectMake(0, 102, screenWidth,screenHeight - 102) style:UITableViewStylePlain withArray:array];
    [self.view addSubview:rTableView];
    rTableView.scrollEnabled = YES;

}

- (void)setupView {
    
    //菜单栏
    UIView *meunView = [[UIView alloc]init];
    
    //搜索结果列表
    
    
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

@end
