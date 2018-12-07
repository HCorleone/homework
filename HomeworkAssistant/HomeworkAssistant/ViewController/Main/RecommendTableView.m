//
//  RecommendTableView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "RecommendTableView.h"
#import "RecommendStaticCell.h"
#import "Book.h"
#import "AnswerViewController.h"
#import "MyListViewController.h"

@interface RecommendTableView()<UITableViewDelegate, UITableViewDataSource>

@end


@implementation RecommendTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withArray:(NSMutableArray *)array {
    self = [super initWithFrame:frame style:style];
    [self registerClass:[RecommendStaticCell class] forCellReuseIdentifier:@"RecommendStaticCell"];
    self.dataList = array;
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    [self setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    
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
    RecommendStaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendStaticCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}



#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerViewController *answerVC = [[AnswerViewController alloc]init];
    answerVC.bookModel = self.dataList[indexPath.row];
    [[self viewController].navigationController pushViewController:answerVC animated:YES];
}

// 获取当前View的控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
    
}


- (void)reloadDataWithList:(NSMutableArray *)arr {
    self.dataList = arr;
    [self reloadData];
}

@end
