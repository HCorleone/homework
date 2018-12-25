//
//  EnglishViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "EnglishViewController.h"
#import "YZPullDownMenu.h"

#define MENU_HEIGHT 36

@interface EnglishViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation EnglishViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChineseArticleNote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchView:) name:@"EnglishArticleNote" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnglishArticleNote" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)getLanguage {
    return @"2";
}

- (NSArray *)getTitles {
    return @[@"年级", @"字数"];
}

- (From)getMenuType {
    return FromEnglishArticle;
}

#pragma mark - 搜索菜单栏

- (void)setupAllChildViewController {
    ArticleGradeViewController *test1 =[[ArticleGradeViewController alloc] init];
    test1.from = FromEnglish;
    WordsNumViewController *test2 = [[WordsNumViewController alloc] init];
    test2.from = FromEnglish;
    [self addChildViewController:test1];
    [self addChildViewController:test2];
    
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return 2;
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return 0.61 * SCREEN_WIDTH;
    }
    
    // 第3列 高度
    return 0.4 * SCREEN_WIDTH;
    
}

@end
