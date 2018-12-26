//
//  VersionViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "VersionViewController.h"
#import "ClassificationCell.h"
#import "SearchMenuHeaderView.h"

@interface VersionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *titles;
/** 旧cell */
@property (nonatomic, strong) NSIndexPath *oldIndexPath;

@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    _titles = @[@"上册",@"下册",@"全册",@"全部版本",@"人教版",@"北师大版",@"苏教版",@"翼教版",@"外研版",@"沪科版",@"湘教版",@"青岛版",@"鲁教版",@"浙教版",@"教科版",@"华师大版",@"译林版",@"苏科版",@"语文版",@"西师大版",@"牛津版",@"沪粤版",@"北京课改版",@"鲁科版",@"沪教版",@"岳麓版",@"人民版",@"粤教版",@"河大版",@"长春版",@"语文S版",@"冀少版",@"商务星球版",@"济南版",@"鄂教版",@"江苏版",@"中华书局版",@"中图版",@"科粤版",@"川教版",@"晋教版",@"粤人民版",@"冀人民版",@"陕旅版",@"语文A版",@"仁爱版",@"苏人版",@"其他"];
    [self setupView];
}

- (void)setupView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3, 30);
    layout.minimumLineSpacing = 29.5;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 20);
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 450) collectionViewLayout:layout];
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
    return 2;
    
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 45;
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
            cell.title.text = self.titles[indexPath.row + 3];
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
            headerView.headerTitle.text = @"上下册";
            break;
        case 1:
            headerView.headerTitle.text = @"版本";
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
//    ClassificationCell *cell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"YZUpdateMenuTitleNote" object:self userInfo:@{@"title":cell.title.text}];
//    NSLog(@"%@",cell.title.text);
    
    ClassificationCell *cell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *col = @"2";
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"YZUpdateMenuTitleNote" object:self userInfo:@{@"title":cell.title.text,@"col":col}];
    if (indexPath.section == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YZUpdateMenuTitleNote" object:self userInfo:@{@"title":cell.title.text,@"volume":cell.title.text,@"col":col,@"section":@"0"}];
    }
    else if (indexPath.section == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YZUpdateMenuTitleNote" object:self userInfo:@{@"title":cell.title.text,@"version":cell.title.text,@"col":col,@"section":@"1"}];
    }
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
