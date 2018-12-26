//
//  MyListViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/5.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MyListViewController.h"
#import "AnswerViewController.h"
#import "SearchViewController.h"
#import "BookView.h"
#import "BookCell.h"
#import "Book.h"

@interface MyListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSMutableArray *myListViewData;
@property (nonatomic, strong) BookView *myListView;
@property (nonatomic, strong) UIView *editingView;
@property (nonatomic, strong) UIButton *managerBtn;

@end

@implementation MyListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    [self downloadDataForMyList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    
    [self setupNav];
    [self setupView];
}

#pragma mark - 建立UI
- (void)setupNav {
    //导航栏
    UIView *navView = [[UIView alloc]init];
    [self.view addSubview:navView];
    navView.backgroundColor = maincolor;
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(72);
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
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"我的书单";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
    //管理按钮
    UIButton *manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    manageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [manageBtn setTitle:@"管理" forState:UIControlStateNormal];
    [manageBtn setTitle:@"取消" forState:UIControlStateSelected];
    [manageBtn addTarget:self action:@selector(manageCell:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:manageBtn];
    [manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 24));
        make.right.mas_equalTo(self.navView).with.offset(-20);
        make.centerY.mas_equalTo(backBtn);
    }];
    self.managerBtn = manageBtn;
}

- (void)setupView {
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(30);
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

#pragma mark - 按钮点击方法
- (void)manageCell:(UIButton *)btn {
    if (self.myListView) {
        if (btn.isSelected) {
            [self showEitingView:NO];
            btn.selected = !btn.isSelected;
        }
        else if (!btn.isSelected && self.myListViewData.count) {
            [self showEitingView:YES];
            btn.selected = !btn.isSelected;
        }
        [self.myListView setEditing:!self.myListView.isEditing animated:YES];
    }
}

- (void)toSearch {
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - 下载我的书单列表
- (void)downloadDataForMyList {
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSDictionary *dict = @{
                           @"openID":openId
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForMyCollections] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
    self.myListView = [[BookView alloc]initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH,SCREEN_HEIGHT - 66) style:UITableViewStylePlain withArray:array];
    [self.view addSubview:self.myListView];
    self.myListView.dataSource = self;
    self.myListView.delegate = self;
    self.myListView.scrollEnabled = YES;
    self.myListView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    self.myListView.tableFooterView.backgroundColor = whitecolor;
    [self.myListView registerClass:[BookCell class] forCellReuseIdentifier:@"RecommendStaticCell"];
    
    
    
    //分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 0.5)];
    [line setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
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
    
    //编辑框
    [self.view addSubview:self.editingView];
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(self.view).offset(48);
    }];
}

//删除书籍
- (void)userDisLike:(NSArray *)indexPathArr {
    
    NSMutableArray *selectModelArr = [NSMutableArray array];
    NSMutableArray *selectAnswerIDArr = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexPathArr) {
        [selectModelArr addObject:self.myListViewData[indexPath.row]];
    }
    for (Book *model in selectModelArr) {
        [selectAnswerIDArr addObject:model.answerID];
    }
    NSString *answerIDs = [selectAnswerIDArr componentsJoinedByString:@","];
    
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;

    NSDictionary *dict = @{
                           @"openID":openId,
                           @"answerIDs":answerIDs,
                           @"sourceType":@"rec"
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForDelUserLike] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"]integerValue] == 200) {
            NSLog(@"删除书籍成功！");
        }

    } failure:nil];
    [dataTask resume];

}

#pragma mark - tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myListViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendStaticCell" forIndexPath:indexPath];
    
    cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];

    cell.model = self.myListViewData[indexPath.row];
    cell.saveBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

#pragma mark - tableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AnswerViewController *answerVC = [[AnswerViewController alloc]init];
    answerVC.bookModel = self.myListViewData[indexPath.row];
    [self.navigationController pushViewController:answerVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - 编辑状态底部框及处理方法

- (UIView *)editingView{
    if (!_editingView) {
        
        
        UIView *editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = maincolor;
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(editingView);
            make.width.equalTo(editingView).multipliedBy(0.5);
        }];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = whitecolor;
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:maincolor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(editingView);
            make.width.equalTo(editingView).multipliedBy(0.5);
        }];
        
        UIView *grayline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        grayline.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.12];
        [editingView addSubview:grayline];
        
        _editingView = editingView;
    }
    return _editingView;
}

- (void)p_buttonClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.myListView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
        }];
        
        [self userDisLike:[self.myListView indexPathsForSelectedRows]];
        [self.myListViewData removeObjectsAtIndexes:insets];
        [self.myListView deleteRowsAtIndexPaths:[self.myListView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        
        /** 数据清空情况下取消编辑状态*/
        if (self.myListViewData.count == 0) {
            [self.myListView setEditing:NO animated:YES];
            [self showEitingView:NO];
            self.managerBtn.selected = NO;
            /** 带MJ刷新控件重置状态
             [self.tableView.footer resetNoMoreData];
             [self.tableView reloadData];
             */
        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.myListViewData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.myListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]) {
        [self.myListView reloadData];
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        
    }
}


- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(isShow?0:48);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
