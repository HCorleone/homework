//
//  MyDownloadViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/7.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "MyDownloadViewController.h"
#import "DownloadedAnswerViewController.h"
#import "BookCell.h"

@interface MyDownloadViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSMutableArray *downloadedListData;
@property (nonatomic, strong) UITableView *downloadedListView;
@property (nonatomic, strong) UIView *editingView;
@property (nonatomic, strong) UIButton *managerBtn;

@end

@implementation MyDownloadViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    title.text = @"我的下载";
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
    
    self.downloadedListData = [NSMutableArray arrayWithArray:[DBManager selectDataForDownloadedView]];
    
    UITableView *downloadedView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:downloadedView];
    [downloadedView registerClass:[BookCell class] forCellReuseIdentifier:@"BookCell"];
    downloadedView.delegate = self;
    downloadedView.dataSource = self;
    downloadedView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    self.downloadedListView = downloadedView;
    
    //分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 0.5)];
    [line setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    [self.downloadedListView.tableFooterView addSubview:line];
    
    //编辑框
    [self.view addSubview:self.editingView];
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(self.view).offset(48);
    }];
    
}

#pragma mark - 按钮点击方法
- (void)manageCell:(UIButton *)btn {
    if (self.downloadedListView) {
        if (btn.isSelected) {
            [self showEitingView:NO];
            btn.selected = !btn.isSelected;
        }
        else if (!btn.isSelected && self.downloadedListData.count) {
            [self showEitingView:YES];
            btn.selected = !btn.isSelected;
        }
        [self.downloadedListView setEditing:!self.downloadedListView.isEditing animated:YES];
    }
}

#pragma mark - 批量删除历史记录
- (void)cleanDownloaded:(NSArray *)indexPathArr {
    
    //删除数据库内容
    NSMutableArray *selectModelArr = [NSMutableArray array];
    NSMutableArray *selectAnswerIDArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPathArr) {
        [selectModelArr addObject:self.downloadedListData[indexPath.row]];
    }
    for (DownloadedBook *model in selectModelArr) {
        [selectAnswerIDArr addObject:model.answerID];
    }
    [DBManager deleteFromDataBase_downloadedBook:selectAnswerIDArr];
    
    //删除沙盒文件内容
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgFilePath = [docsdir stringByAppendingPathComponent:@"MyDownloadImages"];
    for (NSString *selectAnswerID in selectAnswerIDArr) {
        NSString *answerIDPath = [imgFilePath stringByAppendingPathComponent:selectAnswerID];
        [[NSFileManager defaultManager] removeItemAtPath:answerIDPath error:nil];
    }
    
    
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.downloadedListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
    
    cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.downloadedBook = self.downloadedListData[indexPath.row];
    //    cell.saveBtn.layer.borderColor = [UIColor colorWithHexString:@"#FA8919"].CGColor;
    //    [cell.saveBtn setTitleColor:[UIColor colorWithHexString:@"#FA8919"] forState:UIControlStateNormal];
    cell.saveBtn.hidden = YES;
    return cell;
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DownloadedAnswerViewController *answerVC = [[DownloadedAnswerViewController alloc]init];
    answerVC.bookModel = self.downloadedListData[indexPath.row];
    [self.navigationController pushViewController:answerVC animated:YES];
    
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
        [[self.downloadedListView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
        }];
        [self cleanDownloaded:[self.downloadedListView indexPathsForSelectedRows]];
        [self.downloadedListData removeObjectsAtIndexes:insets];
        [self.downloadedListView deleteRowsAtIndexPaths:[self.downloadedListView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        
        /** 数据清空情况下取消编辑状态*/
        if (self.downloadedListData.count == 0) {
            [self.downloadedListView setEditing:NO animated:YES];
            [self showEitingView:NO];
            self.managerBtn.selected = NO;
            /** 带MJ刷新控件重置状态
             [self.tableView.footer resetNoMoreData];
             [self.tableView reloadData];
             */
        }
        
    }
    else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.downloadedListData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.downloadedListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }
    else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]) {
        [self.downloadedListView reloadData];
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
