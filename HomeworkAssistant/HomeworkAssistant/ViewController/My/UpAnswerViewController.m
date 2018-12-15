//
//  UpAnswerViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/6.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "UpAnswerViewController.h"
#import "CommonAlterView.h"
#import "SubmitCollectionViewCell.h"

@interface UpAnswerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 导航栏 */
@property (nonatomic, strong) UIView *navView;
/** 封面 */
@property (nonatomic, strong) UIImageView *imgView;
/** 答案页 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 存储数组 */
@property (nonatomic, strong) NSMutableArray *imgArray;
/** 图片URL数组 */
@property (nonatomic, strong) NSMutableArray *fileList;
/** 添加封面还是答案 */
@property (nonatomic, assign) BOOL isAnswer;

@end

@implementation UpAnswerViewController

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    [self getView];
    [self getPictureImage];
    [self getAnswer];
}

//返回上一个界面
- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    //导航栏
    UIView *navView = [[UIView alloc]init];
    [self.view addSubview:navView];
    navView.backgroundColor = maincolor;
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(66);
    }];
    self.navView = navView;
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).with.offset(20);
        make.bottom.mas_equalTo(self.navView).with.offset(-10);
    }];
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"填写书籍信息";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
        
    }];
}

-(NSMutableArray *)imgArray
{
    if(!_imgArray)
    {
        _imgArray = [[NSMutableArray alloc] initWithCapacity:1];
        UIImage *img = [UIImage imageNamed:@"添加书籍"];
        [_imgArray addObject:img];
        
        
    }
    return _imgArray;
}

-(NSMutableArray *)fileList
{
    if(!_fileList)
    {
        _fileList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _fileList;
}

#pragma mark - 添加Label和Btn
-(void)getView {
    UILabel *titleLabel = [UILabel labelWithContent:@"添加封面" SuperView:self.view TextColor:UIColorFromRGB(0x353B3C) Font:[UIFont systemFontOfSize:14.0] TextAlignment:NSTextAlignmentLeft NumberOfLines:1];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(14);
    }];
    
    UILabel *titleLabels = [UILabel labelWithContent:@"添加答案页" SuperView:self.view TextColor:UIColorFromRGB(0x353B3C) Font:[UIFont systemFontOfSize:14.0] TextAlignment:NSTextAlignmentLeft NumberOfLines:1];
    [titleLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(205);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(14);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [nextBtn setTitle:@"确认上传" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextBtn.backgroundColor = UIColorFromRGB(0x3FBCF4);
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 15;
    nextBtn.tag = 1004;
    [nextBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-screenHeight * 0.157);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(152);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - 添加封面
-(void)getPictureImage {
    
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"添加书籍"];
    _imgView.userInteractionEnabled = YES;
    [self.view addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(122);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(112);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [_imgView addGestureRecognizer:tap];
    
}

#pragma mark - 添加答案
-(void)getAnswer {
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 307, SCREENWIDTH, 112) collectionViewLayout:flowLayout];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 10;
    // 设置此属性为yes 不满一屏幕 也能滚动
//    _collectionView.alwaysBounceHorizontal = YES;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //隐藏滚动条
    _collectionView.showsHorizontalScrollIndicator = NO;
    //隐藏背景色
    _collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[SubmitCollectionViewCell class] forCellWithReuseIdentifier:@"itemCell"];
    [self.view addSubview:_collectionView];
    
}

#pragma mark - 点击封面
//点击封面
-(void)clickTap {
    NSLog(@"添加封面");
    self.isAnswer = NO;
    [self getCamera];
    
}

#pragma mark - 点击上传
-(void)clickBtn{
    //添加加载动画效果
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSDictionary *dic = @{@"h":@"ZYUploadAnswerPicHandler",
                          @"id":userValue(@"GetUpAnswerID"),
                          @"fileList":self.fileList,
                          @"av":@"_debug_"
                          
                          };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OnLineIP]];
    //设置请求方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //接收数据是json形式给出
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [manager POST:UpLoadAnswer parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----------------%@---------------", responseObject);
        
        if ([responseObject[@"code"] intValue] == 200) {
            //取消加载动画效果
            [hud hideAnimated:YES];
            
            //上传成功后回到主界面
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
        }
        else {
            [CommonAlterView showAlertView:@"上传失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}

#pragma mark - UICollectionView----DelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(84, 112);
}

//定义每个UICollectionViewCell 横向的间距(上下)
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}

//定义每个UICollectionViewCell 纵向的间距(左右)
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}


#pragma mark - UICollectionView------DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imgArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubmitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    //    cell.imgView.image = [UIImage imageNamed:self.imgArray[indexPath.item]];
    cell.imgView.image = self.imgArray[indexPath.item];
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 3;
    return cell;
}

#pragma mark --UICollectionView-------Delegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.isAnswer = YES;
    NSLog(@"添加答案页,选择了第%ld个item", indexPath.row);
    
    if (indexPath.row == self.imgArray.count - 1)
    {
        [self getCamera];
    }
    else {
        //删除选中项
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否删除此张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.imgArray removeObjectAtIndex:indexPath.row];
            [self.collectionView reloadData];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@", info);
    
    if (_isAnswer) {
        UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        NSString *strURL = [info objectForKey:@"UIImagePickerControllerImageURL"];
        //插入图片数组中
        [self.imgArray insertObject:img atIndex:_imgArray.count - 1];
        //插入列表中
        [self.fileList addObject:img];
        [self.collectionView reloadData];
        //保存图片到本地内存
//        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    else
    {
        //获取编辑后的图片
        _imgView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self.fileList insertObject:_imgView.image atIndex:0];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//调用相机
-(void)getCamera {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.delegate = self;
            imgPicker.allowsEditing = YES;
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
        else
        {
            //警告
            [CommonAlterView showAlertView:@"相机不能用"];
        }
    }];
    //打开相册
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    //取消
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

