//
//  BookListViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/11.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "BookListViewController.h"
#import "BookListView.h"
#import "SubmitCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface BookListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) BookListView *bookView;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *idArray;
/** 需要传入的id列表 */
@property (nonatomic, strong) NSMutableString *addStr;

@end

@implementation BookListViewController

#define IMAGEX [UIScreen mainScreen].bounds.size.width * 0.176
#define IMAGEY IMAGEX * 1.33

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle =UIModalPresentationCustom;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    
    [self getManager];
    [self getBookView];
    
}

-(void)getCollectionView {
    //列表显示
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    //隐藏背景色
    _collectionView.backgroundColor = [UIColor clearColor];
    //隐藏滚动条
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[SubmitCollectionViewCell class] forCellWithReuseIdentifier:@"itemCell"];
    [self.bookView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_WIDTH * 0.106 + 1);
        make.centerX.mas_equalTo(self.bookView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.697);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.648);
    }];
}

-(NSMutableArray *)imgArray
{
    if(!_imgArray)
    {
        _imgArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _imgArray;
}

- (void)getBookView {
    
    //此按钮事方式点击显示界面 视图消失。
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT * 0.211);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.827);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.535);
    }];
    
    //界面显示
    _bookView = [[BookListView alloc] init];
    _bookView.backgroundColor = whitecolor;
    _bookView.layer.masksToBounds = YES;
    _bookView.layer.cornerRadius = 5;
    __weak typeof(self) weakSelf = self;
    _bookView.clickBlock = ^(UIButton * _Nonnull btn) {
        
        NSLog(@"%@", weakSelf.idArray);
        weakSelf.addStr = [NSMutableString string];
        
        //拼接id字符串
        for (NSString *str in weakSelf.idArray) {
            [weakSelf.addStr appendString:str];
            [weakSelf.addStr appendString:@","];
        }
        [weakSelf.addStr deleteCharactersInRange:NSMakeRange([weakSelf.addStr length]-1, 1)];
        
        NSLog(@"%@", weakSelf.addStr);
        
        //添加到本地仓库
        if (userValue(@"openId")) {
            [weakSelf addBookList];
        }
        else {
//            [CommonAlterView showMessages:@"请先登录" andVC:weakSelf handler:^(UIAlertAction *action) {
//                [weakSelf dismissViewControllerAnimated:NO completion:nil];
//            }];
            [XWHUDManager showTipHUD:@"请先登录"];
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
            
        }
        
    };
    [self.view addSubview:_bookView];
    [_bookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT * 0.211);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.827);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.827 / 310 * 357);
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"+++++++++++++++");
    [self dismissViewControllerAnimated:NO completion:nil];
}

//获取他人表单
- (void)getManager {
    
    NSDictionary *dic = @{
                          @"openID":self.idStr,
                          };
    dic = [HMACSHA1 encryptDicForRequest:dic];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    [manager GET:[URLBuilder getURLForMyCollections] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@------------------------------", responseObject);
        
        self.imgArray = [responseObject[@"datas"] valueForKey:@"coverURL"];
        self.idArray = [responseObject[@"datas"] valueForKey:@"id"];
        
        [self getCollectionView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}

-(void)addBookList {
    
    NSDictionary *dic = @{
                          @"openID":userValue(@"openId"),
                          @"answerIDs":self.addStr,
                          };
    dic = [HMACSHA1 encryptDicForRequest:dic];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    //设置请求方式
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    //接收数据是json形式给出
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
        __weak typeof(self) weakSelf = self;
    [manager GET:[URLBuilder getURLForCopyUserLike] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@------------------------------", responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLikeOrNot" object:nil];
        
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(IMAGEX, IMAGEY);
}

//定义每个UICollectionViewCell 横向的间距(上下)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return SCREEN_WIDTH * 0.085;
}


//定义每个UICollectionViewCell 纵向的间距(左右)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imgArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubmitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    [cell.imgView sd_setImageWithURL:self.imgArray[indexPath.item]];
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了第%ld个item", indexPath.row);
    if (indexPath.row != self.imgArray.count - 1)
    {
        return;
    }
   
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
