//
//  FillOthersViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/10.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//  填写其他信息

#import "FillOthersViewController.h"
#import "SHPlacePickerView.h"
#import "ClassificationCell.h"
#import "CollectionHeaderView.h"
#import "FillOthersView.h"

@interface FillOthersViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 地区选择器 */
@property (nonatomic, strong) SHPlacePickerView *shplacePicker;
/** 年级 */
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UICollectionView *collectView;
/** 旧cell */
@property (nonatomic, strong) NSIndexPath *oldIndexPath;
/** 界面视图 */
@property (nonatomic, strong) FillOthersView *otherView;
@property (nonatomic, strong) ClassificationCell *cell;

@end

@implementation FillOthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titles = @[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",@"七年级",@"八年级",@"九年级",@"高一",@"高二",@"高三"];
    
    [self getView];
    [self setupView];
    
}

-(void)getView {
    
    _otherView = [[FillOthersView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    _otherView.block = ^(UIButton * _Nonnull btn) {
        switch (btn.tag) {
            case 1001:
            {
                NSLog(@"选择地区");
                [weakSelf selectCity];
            }
                break;
            case 1002:
            {
                NSLog(@"下一步");
                if (!self.cell.title.text && !self.otherView.areaBtn.titleLabel.text) {
                    [CommonAlterView showAlertView:@"请选择年级和地区"];
                }
                else {
                    //请求接口
                    [weakSelf getManager];
                }
            }
                break;
        }
        
    };
    [self.view addSubview:_otherView];
    
}

//选择年级
- (void)setupView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth/3, 30);
    layout.minimumLineSpacing = 29.5;
    layout.headerReferenceSize = CGSizeMake(screenWidth, 20);
    
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 320) collectionViewLayout:layout];
    [self.view addSubview:_collectView];
    _collectView.dataSource = self;
    _collectView.delegate = self;
    _collectView.backgroundColor = whitecolor;
    [_collectView registerClass:[ClassificationCell class] forCellWithReuseIdentifier:@"grade"];
    [_collectView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerview"];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
    
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
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
            cell.title.text = self.titles[indexPath.row + 6];
            break;
        case 2:
            cell.title.text = self.titles[indexPath.row + 9];
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
            headerView.headerTitle.text = @"小学";
            break;
        case 1:
            headerView.headerTitle.text = @"初中";
            break;
        case 2:
            headerView.headerTitle.text = @"高中";
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
    _cell = (ClassificationCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%@",_cell.title.text);
}

//设置点击高亮和非高亮效果！
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [_cell setBackgroundColor:ClickColor];
    _cell.layer.borderColor = ClickColor.CGColor;
    _cell.title.textColor = whitecolor;
    
    if (_oldIndexPath != indexPath) {
        //改变旧的cell恢复颜色
        ClassificationCell *oldCell = (ClassificationCell *)[collectionView cellForItemAtIndexPath:_oldIndexPath];
        oldCell.backgroundColor  = [UIColor whiteColor];
        oldCell.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
        oldCell.title.textColor = UIColorFromRGB(0x353B3C);
    }
    _oldIndexPath = indexPath;
}

//初始化Cell
- (NSIndexPath *)oldIndexPath {
    if (!_oldIndexPath) {
        _oldIndexPath = [[NSIndexPath alloc] init];
    }
    return _oldIndexPath;
}

//选择城市
-(void)selectCity {
    
    __weak __typeof(self)weakSelf = self;
    self.shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
        
        NSLog(@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]);
        [weakSelf.otherView.areaBtn setTitle:[NSString stringWithFormat:@"%@", placeArray[1]] forState:UIControlStateNormal];
        
    }];
    self.shplacePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shplacePicker];
}

#pragma mark - 请求网络
-(void)getManager
{
    NSDictionary *dic = @{@"h":@"ZYUpsertUserExtHander",
                          @"openID":userValue(@"openId"),
                          @"grade":self.cell.title.text,
                          @"city":self.otherView.areaBtn.titleLabel.text,
                          @"schoolID":@"3",
                          @"schoolName":@"4",
                          @"longitude":@"1.000000",
                          @"latitude":@"2.000000",
                          @"av":@"_debug_"};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OnLineIP]];
    //设置请求方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //接收数据是json形式给出
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak typeof(self) weakSelf = self;
    [manager GET:getURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@------------------------------", responseObject);
        
        //返回成功
        if ([responseObject[@"code"] intValue] == 200) {
            
            [TTUserManager sharedInstance].currentUser.city = responseObject[@"city"];
            [TTUserManager sharedInstance].currentUser.grade = responseObject[@"grade"];
            [TTUserManager sharedInstance].currentUser.schoolID = responseObject[@"schoolID"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}

@end
