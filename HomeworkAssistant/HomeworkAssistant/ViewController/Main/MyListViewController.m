//
//  MyListViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/5.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MyListViewController.h"
#import "AnswerViewController.h"
#import "RecommendTableView.h"
#import "SearchViewController.h"
#import "RecommendStaticCell.h"
#import "Book.h"

@interface MyListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSMutableArray *myListViewData;
@property (nonatomic, strong) NSMutableArray *selectorPatnArray;
@property (nonatomic, strong) RecommendTableView *myListView;

@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    
    [self setupNav];
    [self setupView];
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
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"我的书单";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
    //管理按钮
//    UIButton *manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [manageBtn setImage:[UIImage imageNamed:@"管理"] forState:UIControlStateNormal];
//    [manageBtn addTarget:self action:@selector(manageCell) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:manageBtn];
//    [manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(24, 24));
//        make.right.mas_equalTo(self.navView).with.offset(-20);
//        make.bottom.mas_equalTo(self.navView).with.offset(-10);
//    }];
}

- (void)manageCell {
//    if (self.myListView) {
//        [self.myListView setEditing:YES animated:YES];
//    }
}

- (void)setupView {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(30);
        //        make.top.mas_equalTo(self.myListView.tableFooterView).offset(41);
        make.size.mas_equalTo(CGSizeMake(111, 26));
    }];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = maincolor.CGColor;
    addBtn.layer.cornerRadius = 13;
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:maincolor forState:UIControlStateNormal];
    [addBtn setBackgroundColor:whitecolor];
    [addBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
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
                if (self.myListView) {
                    self.myListView.hidden = YES;
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
                if (self.myListView) {
                    self.myListView.hidden = NO;
                    [self.myListView reloadDataWithList:self.myListViewData];
                }
                else {
                    [self setupMyList:self.myListViewData];
                }
            }
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)setupMyList:(NSMutableArray *)array {
    self.myListView = [[RecommendTableView alloc]initWithFrame:CGRectMake(0, 66, screenWidth,screenHeight - 66) style:UITableViewStylePlain withArray:array];
    [self.view addSubview:self.myListView];
    self.myListView.dataSource = self;
    self.myListView.delegate = self;
    self.myListView.scrollEnabled = YES;
    self.myListView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 76)];
    self.myListView.tableFooterView.backgroundColor = whitecolor;
    
    //分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screenWidth - 40, 0.5)];
//    [line setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
    [line setBackgroundColor:[UIColor grayColor]];
    line.layer.opacity = 0.5;
    [self.myListView.tableFooterView addSubview:line];
    
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myListView.tableFooterView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.myListView.tableFooterView);
//        make.top.mas_equalTo(self.myListView.tableFooterView).offset(41);
        make.size.mas_equalTo(CGSizeMake(111, 26));
    }];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = maincolor.CGColor;
    addBtn.layer.cornerRadius = 13;
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:maincolor forState:UIControlStateNormal];
    [addBtn setBackgroundColor:whitecolor];
    [addBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toSearch {
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    
    [self downloadDataForMyList];

}

#pragma 重写tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myListViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendStaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendStaticCell" forIndexPath:indexPath];
    cell.model = self.myListViewData[indexPath.row];
    cell.saveBtn.hidden = YES;

    return cell;
}

#pragma 重写tableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerViewController *answerVC = [[AnswerViewController alloc]init];
    answerVC.bookModel = self.myListViewData[indexPath.row];
    [self.navigationController pushViewController:answerVC animated:YES];
}

#pragma 编辑方法

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Book *model = [self.myListViewData objectAtIndex:indexPath.row];
        [self.myListViewData removeObjectAtIndex:indexPath.row];
        [self.myListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self userDisLike:model];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消收藏";
}

- (void)userDisLike:(Book *)model {
    
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSString *URL = @"http://zuoyeapi.tatatimes.com/homeworkapi/api.s?";
    NSDictionary *dict = @{
                           @"h":@"ZYDelUserLikeHandler",
                           @"openID":openId,
                           @"answerIDs":model.answerID,
                           @"pkn":@"com.enjoytime.palmhomework",
                           @"sourceType":@"rec",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            NSLog(@"取消收藏");
            [self downloadDataForMyList];
        }
        
    } failure:nil];
    [dataTask resume];
    
}
@end
