//
//  GradeViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "GradeViewController.h"
#import "ClassificationCell.h"
#import "SearchMenuHeaderView.h"

extern NSString * const YZUpdateMenuTitleNote;

@interface GradeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *titles;
/** 旧cell */
@property (nonatomic, strong) NSIndexPath *oldIndexPath;

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
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3, 30);
    layout.minimumLineSpacing = 29.5;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 20);
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    [self.view addSubview:collectView];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.showsVerticalScrollIndicator = NO;
    collectView.backgroundColor = whitecolor;
    [collectView registerClass:[ClassificationCell class] forCellWithReuseIdentifier:@"grade"];
    [collectView registerClass:[SearchMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview"];
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

//headerheight
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 40);
    
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SearchMenuHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview" forIndexPath:indexPath];
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
    return CGSizeMake(0.245 * SCREEN_WIDTH, 0.27 * 0.245 * SCREEN_WIDTH);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.048 * SCREEN_WIDTH;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 1, 20);
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *col = @"0";
    NSLog(@"%@",cell.title.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cell.title.text,@"col":col}];
    
}

//设置点击高亮和非高亮效果！
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassificationCell *cell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:ClickColor];
    cell.layer.borderColor = ClickColor.CGColor;
    cell.title.textColor = whitecolor;
    
    if (_oldIndexPath != indexPath) {
        //改变旧的cell恢复颜色
        ClassificationCell *oldCell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:_oldIndexPath];
        oldCell.backgroundColor  = [UIColor whiteColor];
        oldCell.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
        oldCell.title.textColor = [UIColor colorWithHexString:@"#7A7D80"];
    }
    _oldIndexPath = indexPath;
}

@end
