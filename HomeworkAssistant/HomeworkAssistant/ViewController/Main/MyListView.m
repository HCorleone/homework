//
//  MyListView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/30.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MyListView.h"
#import "MyListViewCell.h"
#import "AnswerViewController.h"
#import "SearchViewController.h"

@interface MyListView()<UICollectionViewDelegate,  UICollectionViewDataSource>

@end

@implementation MyListView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout withArray:(nonnull NSMutableArray *)array {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = whitecolor;
    [self registerClass:[MyListViewCell class] forCellWithReuseIdentifier:@"MyListCell"];
    self.dataList = array;
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    
    return self;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyListViewCell *cell = (MyListViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyListCell" forIndexPath:indexPath];
    if (indexPath.row == self.dataList.count) {
        cell.topImage.image = [UIImage imageNamed:@"添加书籍"];
        cell.title.text = @"添加书籍";
    }
    else {
        cell.model = self.dataList[indexPath.row];
    }
    return cell;
}

////设置每个item的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(90, 160);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 20;
//}



//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataList.count) {
        SearchViewController *searchVC = [[SearchViewController alloc]init];
        [[self viewController].navigationController pushViewController:searchVC animated:YES];
    }
    else {
        AnswerViewController *answerVC = [[AnswerViewController alloc]init];
        answerVC.bookModel = self.dataList[indexPath.row];
        [[self viewController].navigationController pushViewController:answerVC animated:YES];
    }
}

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
