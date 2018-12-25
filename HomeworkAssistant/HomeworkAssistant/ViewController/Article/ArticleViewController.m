//
//  ArticleViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ArticleViewController.h"
#import "ChineseViewController.h"
#import "EnglishViewController.h"
#import "YZPullDownMenu.h"

@interface ArticleViewController ()<JXCategoryViewDelegate>

@property (nonatomic, assign) BOOL shouldHandleScreenEdgeGesture;

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UIScrollView *articleScrollView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation ArticleViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldHandleScreenEdgeGesture = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    [self setupNav];
    [self setupScroll];
    [self setupIndicator];
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
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).offset(20);
        make.bottom.mas_equalTo(self.navView).offset(-10);
    }];
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"搜索_白色v2"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(self.navView).offset(-20);
        make.bottom.mas_equalTo(self.navView).offset(-10);
    }];
}

- (void)setupScroll {
    
    UIScrollView *articleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT + TOP_OFFSET, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - TOP_OFFSET)];
    articleScrollView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - TOP_OFFSET);
    articleScrollView.bounces = NO;
    articleScrollView.pagingEnabled = YES;
    [self.view addSubview:articleScrollView];
    self.articleScrollView = articleScrollView;
    
    ChineseViewController *chineseArticleVC = [[ChineseViewController alloc] init];
    chineseArticleVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - TOP_OFFSET);
    [self addChildViewController:chineseArticleVC];
    [articleScrollView addSubview:chineseArticleVC.view];
    
    EnglishViewController *englishArticleVC = [[EnglishViewController alloc] init];
    englishArticleVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - TOP_OFFSET);
    [self addChildViewController:englishArticleVC];
    [articleScrollView addSubview:englishArticleVC.view];
    
}

- (void)setupIndicator {
    
    NSArray *titles = @[@"中文",@"英文"];
    
    JXCategoryTitleView *titleCategoryView = [[JXCategoryTitleView alloc] init];
    [self.navView addSubview:titleCategoryView];
    [titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(0.51 * SCREEN_WIDTH, 24));
        make.bottom.mas_equalTo(self.navView).offset(-10);
    }];
    titleCategoryView.layer.borderWidth = 1.5;
    titleCategoryView.layer.borderColor = whitecolor.CGColor;
    titleCategoryView.layer.cornerRadius = 4;
    titleCategoryView.layer.masksToBounds = YES;
    titleCategoryView.contentEdgeInsetLeft = 0;
    titleCategoryView.contentEdgeInsetRight = 0;
    titleCategoryView.cellWidth = 0.51 * SCREEN_WIDTH/2;
    titleCategoryView.cellSpacing = 0;
    titleCategoryView.titles = titles;
    titleCategoryView.titleColorGradientEnabled = YES;
    titleCategoryView.titleColor = whitecolor;
    titleCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#2988CC"];
    titleCategoryView.defaultSelectedIndex = _offsetX;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.backgroundViewColor = whitecolor;
    backgroundView.backgroundViewWidthIncrement = 0;
    backgroundView.backgroundViewWidth = 0.51 * SCREEN_WIDTH/2;
    backgroundView.backgroundViewHeight = 24;
    backgroundView.backgroundViewCornerRadius = 0;
    titleCategoryView.indicators = @[backgroundView];
    titleCategoryView.delegate = self;
    titleCategoryView.contentScrollView = self.articleScrollView;

}

- (void)toSearch {
    
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    if (_shouldHandleScreenEdgeGesture) {
        self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    }
//    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
