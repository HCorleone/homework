//
//  UploadAnswerViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/9.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "UploadAnswerViewController.h"
#import "HXPhotoSubViewCell.h"

@interface UploadAnswerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,HXPhotoSubViewCellDelegate, HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, strong) HXCollectionView *collectionView;
@property (nonatomic, strong) HXPhotoModel *addModel;
@property (nonatomic, strong) NSMutableArray *answerImgModelArr;
//@property (nonatomic, strong) NSMutableArray *answerImgArr;

@property (nonatomic, strong) UIButton *addCoverBtn;
@property (nonatomic, strong) UIImageView *bookCover;

@end

@implementation UploadAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    NSLog(@"%@",self.answerID);
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
        make.height.mas_equalTo(72 + TOP_OFFSET);
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
        make.bottom.mas_equalTo(self.navView).with.offset(-15);
    }];
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"上传答案图片";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
}

- (void)setupView {
    
    //添加封面label
    UILabel *addCover = [[UILabel alloc] init];
    addCover.text = @"添加封面页";
    addCover.textColor = [UIColor colorWithHexString:@"#353B3C"];
    addCover.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:addCover];
    [addCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(0.245 * SCREEN_WIDTH);
    }];
    //添加封面按钮
    UIButton *addCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCoverBtn setBackgroundImage:[UIImage imageNamed:@"添加书籍"] forState:UIControlStateNormal];
    [self.view addSubview:addCoverBtn];
    [addCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0.325 * SCREEN_WIDTH);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(0.224 * SCREEN_WIDTH, 0.224 * SCREEN_WIDTH * 1.33));
    }];
    [addCoverBtn addTarget:self action:@selector(selectBookCover) forControlEvents:UIControlEventTouchUpInside];
    self.addCoverBtn = addCoverBtn;
    
    //封面展示view
    UIImageView *bookCover = [[UIImageView alloc] init];
    [self.view addSubview:bookCover];
    [bookCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0.325 * SCREEN_WIDTH);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(0.224 * SCREEN_WIDTH, 0.224 * SCREEN_WIDTH * 1.33));
    }];
    self.bookCover = bookCover;
    self.bookCover.hidden = YES;
    
    //添加答案页label
    UILabel *addAnswer = [[UILabel alloc] init];
    addAnswer.text = @"添加答案页";
    addAnswer.textColor = [UIColor colorWithHexString:@"#353B3C"];
    addAnswer.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:addAnswer];
    [addAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(0.74 * SCREEN_WIDTH);
    }];
    
    //添加答案的collectionView
    self.answerImgModelArr = [NSMutableArray array];
//    self.answerImgArr = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(0.224 * SCREEN_WIDTH, 0.224 * SCREEN_WIDTH * 1.33);
    HXCollectionView *collectionView = [[HXCollectionView alloc] initWithFrame:CGRectMake(0, 0.82 * SCREEN_WIDTH, SCREEN_WIDTH, 112) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO;
    collectionView.editEnabled = NO;
    collectionView.backgroundColor = whitecolor;
    [collectionView registerClass:[HXPhotoSubViewCell class] forCellWithReuseIdentifier:@"HXPhotoSubViewCellId"];
    [collectionView registerClass:[HXPhotoSubViewCell class] forCellWithReuseIdentifier:@"addCell"];
    self.collectionView = collectionView;
    
    //上传答案按钮
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0.40 * SCREEN_WIDTH, 0.40 * SCREEN_WIDTH * 0.24);
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[UIColor colorWithHexString:@"#FFC94C"].CGColor,
                              (id)[UIColor colorWithHexString:@"#FF8800"].CGColor,
                              nil
                              ]];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn.layer addSublayer:gradientLayer];
    uploadBtn.layer.masksToBounds = YES;
    uploadBtn.layer.cornerRadius = 0.40 * SCREEN_WIDTH * 0.24/2;
    [uploadBtn addTarget:self action:@selector(confirmUploadAnswerImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SCREEN_HEIGHT * 0.157);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(0.40 * SCREEN_WIDTH, 0.40 * SCREEN_WIDTH * 0.24));
    }];
    [uploadBtn setTitleColor:whitecolor forState:UIControlStateNormal];
    [uploadBtn setTitle:@"确认上传" forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    uploadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

//确认上传
- (void)confirmUploadAnswerImg {
    if (self.answerImgModelArr.count == 0) {
        [XWHUDManager showTipHUDInView:@"请添加答案页图片"];
        return;
    }
    else if (!self.bookCover.image) {
        [XWHUDManager showTipHUDInView:@"请添加书籍封面图片"];
        return;
    }
    else {
        [self uploadAnswerPics];
    }
}

- (void)uploadAnswerPics {
    
    HXPhotoModel *tempModel = self.answerImgModelArr[0];
    
    self.bookCover.image = tempModel.previewPhoto;
    
//    UIImage *bookCover = self.bookCover.image;
    
//    NSOperationQueue *testQueue = [[NSOperationQueue alloc] init];
//    testQueue.maxConcurrentOperationCount = 3;

//    NSDictionary *dict = @{
//                           @"id":self.answerID,
////                           @"fileList":self.bookCover.image
//                           };
//
//    dict = [HMACSHA1 encryptDicForRequest:dict];
//
//    NSString *testStr = [CommonToolClass getURLFromDic:dict];
//    NSString *resURL = [[[URLBuilder getURLForUploadAnswerPic] stringByAppendingString:@"&"] stringByAppendingString:testStr];
//    NSLog(@"%@",resURL);
//    resURL = [resURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
//    [manager.requestSerializer setValue:@"multipart/form-data; boundary=----WebKitFormBoundary6TAB8KxvuJTZYfUn" forHTTPHeaderField:@"Content-Type"];
//    NSURLSessionDataTask *dataTask = [manager POST:resURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        for (int i = 0; i < self.answerImgModelArr.count + 1; i++) {
//            NSBlockOperation *testBlockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
//            NSData *imgData = [[NSData alloc] init];
//
//            if (i == 0) {
////                imgData = [self imageData:bookCover];
//                imgData = UIImagePNGRepresentation(self.bookCover.image);
//            }
//            else {
//                if ([self.answerImgModelArr[i - 1] isKindOfClass:[HXPhotoModel class]]) {
//                    HXPhotoModel *tempModel = self.answerImgModelArr[i - 1];
//                    if (tempModel.thumbPhoto == nil) {
//                        return ;
//                    }
//                    imgData = UIImagePNGRepresentation(tempModel.thumbPhoto);
//                    tempModel = nil;
//                }
//            }
//
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//            NSString *str = [dateFormatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//
//            [formData appendPartWithFileData:imgData name:@"fileList" fileName:fileName mimeType:@"image/png"];
//                imgData = nil;
//            }];
//
//            [testQueue addOperation:testBlockOperation1];
//        }
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //        NSLog(@"test+++++%@",responseObject);
//        [XWHUDManager showSuccessTipHUDInView:@"感谢您的反馈"];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //        NSLog(@"test-----%@",error);
//        [XWHUDManager showWarningTipHUDInView:@"反馈失败"];
//    }];
//    [dataTask resume];

}

#pragma mark - 选取封面页相关
- (void)selectBookCover {
    self.manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    self.manager.configuration.singleSelected = YES;
    self.manager.configuration.singleJumpEdit = YES;
    self.manager.configuration.movableCropBox = YES;
    self.manager.configuration.movableCropBoxEditSize = YES;
    self.manager.configuration.requestImageAfterFinishingSelection = YES;
    
    [self hx_presentAlbumListViewControllerWithManager:self.manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        HXPhotoModel *tempModel = (HXPhotoModel *)photoList[0];
        self.bookCover.hidden = NO;
        self.bookCover.image = tempModel.previewPhoto;
    } cancel:nil];
    
}

#pragma mark - 添加答案页相关
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.answerImgModelArr.count + 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(0.224 * SCREEN_WIDTH, 0.224 * SCREEN_WIDTH * 1.33);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //添加图片的Cell
    if (indexPath.item == self.answerImgModelArr.count) {
        HXPhotoSubViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        self.addModel = [[HXPhotoModel alloc] init];
        self.addModel.type = HXPhotoModelMediaTypeCamera;
        self.addModel.thumbPhoto = [UIImage imageNamed:@"添加书籍"];
        addCell.model = self.addModel;
        return addCell;
    }
    HXPhotoSubViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXPhotoSubViewCellId" forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.answerImgModelArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.answerImgModelArr.count) {
        [self goPhotoViewController];
    }
}

//选取答案页照片
- (void)goPhotoViewController {
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    manager.configuration.requestImageAfterFinishingSelection = YES;
    manager.configuration.movableCropBox = YES;
    manager.configuration.movableCropBoxEditSize = YES;
    
    [self hx_presentAlbumListViewControllerWithManager:manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        [self.answerImgModelArr addObjectsFromArray:photoList];
        [self.collectionView reloadData];
        
        HXPhotoModel *tempModel = (HXPhotoModel *)photoList[0];
        [HXPhotoTools getImageWithModel:tempModel completion:^(UIImage *image, HXPhotoModel *model) {
            self.bookCover.hidden = NO;
            self.bookCover.image = image;
        }];

        
    } cancel:nil];
    
//    HXAlbumListViewController *selectImgVC = [[HXAlbumListViewController alloc] init];
//    selectImgVC.delegate = self;
//    selectImgVC.manager = self.manager;
//    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:selectImgVC];
//
//    [self presentViewController:nav animated:YES completion:nil];
    
}

////选着照片之后的回调
//- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllImage:(NSArray<UIImage *> *)imageList {
//    [self.answerImgArr addObjectsFromArray:imageList];
//}
//
//- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
//    [self.answerImgModelArr addObjectsFromArray:photoList];
//    [self.collectionView reloadData];
//}

/**
 cell删除按钮的代理
 
 @param cell 被删的cell
 */
- (void)cellDidDeleteClcik:(UICollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    UIView *mirrorView = [cell snapshotViewAfterScreenUpdates:NO];
    mirrorView.frame = cell.frame;
    [self.collectionView insertSubview:mirrorView atIndex:0];
    cell.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        mirrorView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        HXPhotoSubViewCell *myCell = (HXPhotoSubViewCell *)cell;
        myCell.imageView.image = nil;
        [mirrorView removeFromSuperview];
    }];
    [self.answerImgModelArr removeObjectAtIndex:indexPath.item];
//    [self.answerImgArr removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
    
}

@end
