//
//  RecommendTableView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "BookView.h"
#import "BookCell.h"
#import "Book.h"
#import "AnswerViewController.h"
#import "MyListViewController.h"

@interface BookView()<UITableViewDelegate, UITableViewDataSource>

@end


@implementation BookView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withArray:(NSMutableArray *)array {
    self = [super initWithFrame:frame style:style];
    [self registerClass:[BookCell class] forCellReuseIdentifier:@"RecommendStaticCell"];
    self.dataList = array;
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    [self setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    
    return self;
}



#pragma TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendStaticCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    cell.saveBtn.layer.borderColor = [UIColor colorWithHexString:@"#1698D9"].CGColor;
    [cell.saveBtn setTitleColor:[UIColor colorWithHexString:@"#1698D9"] forState:UIControlStateNormal];
    return cell;
}



#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    AnswerViewController *answerVC = [[AnswerViewController alloc]init];
    answerVC.bookModel = self.dataList[indexPath.row];
    answerVC.isSelected = cell.saveBtn.isSelected;
    [_currentVC.navigationController pushViewController:answerVC animated:YES];
}

- (void)reloadDataWithList:(NSMutableArray *)arr {
    self.dataList = arr;
    [self reloadData];
}

@end
