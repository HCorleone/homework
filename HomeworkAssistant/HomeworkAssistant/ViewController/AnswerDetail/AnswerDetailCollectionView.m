//
//  AnswerDetailCollectionView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerDetailCollectionView.h"
#import "AnswerDetailCollectionViewCell.h"
#import "AnswerDetailViewController.h"

@interface AnswerDetailCollectionView() <UICollectionViewDelegate,  UICollectionViewDataSource>

@end

@implementation AnswerDetailCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout withArray:(nonnull NSMutableArray *)array {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = whitecolor;
    [self registerClass:[AnswerDetailCollectionViewCell class] forCellWithReuseIdentifier:@"ADCVC"];
    self.dataList = array;
    self.delegate = self;
    self.dataSource = self;
    
    return self;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerDetailCollectionViewCell *cell = (AnswerDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ADCVC" forIndexPath:indexPath];
    cell.isSelected = self.isSelected;
    cell.model = self.dataList[indexPath.row];
    return cell;
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 160);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AnswerDetailCollectionViewCell *cell = (AnswerDetailCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    AnswerDetailViewController *answerDetailVC = [[AnswerDetailViewController alloc]init];
    answerDetailVC.answerModel = self.dataList[indexPath.row];
    answerDetailVC.dataList = self.dataList;
    answerDetailVC.isSelected = cell.isSelected;
    [[self viewController].navigationController pushViewController:answerDetailVC animated:YES];
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

@end
