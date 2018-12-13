//
//  GradeViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "GradeViewController.h"
#import "ClassificationCell.h"
#import "CollectionHeaderView.h"

extern NSString * const YZUpdateMenuTitleNote;

@interface GradeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@end

@implementation GradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    _titles = @[@"全部年级",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",@"七年级",@"八年级",@"九年级",@"高一",@"高二",@"高三"];
    [self setupView];
}

- (void)setupView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth/3, 30);
    layout.minimumLineSpacing = 29.5;
    layout.headerReferenceSize = CGSizeMake(screenWidth, 20);
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight) collectionViewLayout:layout];
    [self.view addSubview:collectView];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.backgroundColor = whitecolor;
    [collectView registerClass:[ClassificationCell class] forCellWithReuseIdentifier:@"grade"];
    [collectView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview"];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
    
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
            break;
            
        default:
            break;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"grade" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.title.text = self.titles[indexPath.row];
            break;
        case 1:
            cell.title.text = self.titles[indexPath.row + 1];
            break;
        case 2:
            cell.title.text = self.titles[indexPath.row + 7];
            break;
        case 3:
            cell.title.text = self.titles[indexPath.row + 10];
            break;
        default:
            break;
    }
    
    return cell;
    
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            headerView.headerTitle.text = @"全部";
            break;
        case 1:
            headerView.headerTitle.text = @"小学";
            break;
        case 2:
            headerView.headerTitle.text = @"初中";
            break;
        case 3:
            headerView.headerTitle.text = @"高中";
            break;
        default:
            break;
    }
    
    
    return headerView;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 30);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *col = @"0";
    NSLog(@"%@",cell.title.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cell.title.text,@"col":col}];
    
}

@end
