//
//  SubjectViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SubjectViewController.h"
#import "ClassificationCell.h"
#import "CollectionHeaderView.h"

extern NSString * const YZUpdateMenuTitleNote;

@interface SubjectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *titles;
/** 旧cell */
@property (nonatomic, strong) NSIndexPath *oldIndexPath;

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    _titles = @[@"全部科目",@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理",@"科学"];
    [self setupView];
}

- (void)setupView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth/3, 30);
    layout.minimumLineSpacing = 29.5;
    layout.headerReferenceSize = CGSizeMake(screenWidth, 20);
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) collectionViewLayout:layout];
    [self.view addSubview:collectView];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.backgroundColor = whitecolor;
    [collectView registerClass:[ClassificationCell class] forCellWithReuseIdentifier:@"grade"];
//    [collectView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview"];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"grade" forIndexPath:indexPath];
    cell.title.text = self.titles[indexPath.row];
    return cell;
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
    ClassificationCell *cell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *col = @"1";
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cell.title.text,@"col":col}];
    NSLog(@"%@",cell.title.text);
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
        oldCell.title.textColor = UIColorFromRGB(0x353B3C);
    }
    _oldIndexPath = indexPath;
}

@end
