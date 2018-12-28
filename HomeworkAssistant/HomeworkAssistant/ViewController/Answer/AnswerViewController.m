//
//  AnswerViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerDetail.h"
#import "AnswerCell.h"
#import "AnswerDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface AnswerViewController ()<UICollectionViewDelegate,  UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) UIView *navView;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = whitecolor;
    
    [self setupNav];
    [self downloadData];
    
}

- (void)setupNav {
    //导航栏
    UIView *navView = [[UIView alloc]init];
    [self.view addSubview:navView];
    navView.backgroundColor = whitecolor;
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(72 + 128);
    }];
    self.navView = navView;
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回_黑色v2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).offset(20);
        make.bottom.mas_equalTo(self.navView).offset(- 10 - 128);
    }];
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"全部作业";
    [title setTextColor: [UIColor colorWithHexString:@"#353B3C"]];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
    
    //封面
    UIImageView *bookCover = [[UIImageView alloc]init];
    bookCover.layer.masksToBounds = YES;
    bookCover.layer.cornerRadius = 4;
    bookCover.contentMode = UIViewContentModeScaleAspectFit;
    [bookCover sd_setImageWithURL:[NSURL URLWithString:self.bookModel.coverURL]];
    [navView addSubview:bookCover];
    [bookCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(navView).offset(NAVBAR_HEIGHT/2);
        make.left.mas_equalTo(navView).offset(30);
        make.size.mas_equalTo(CGSizeMake(84, 112));
    }];
    
    //书名
    UILabel *bookTitle = [[UILabel alloc]init];
    bookTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    bookTitle.numberOfLines = 2;
    bookTitle.text = self.bookModel.title;
    [navView addSubview:bookTitle];
    [bookTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView).offset(10 + NAVBAR_HEIGHT);
        make.left.mas_equalTo(bookCover.mas_right).with.offset(15);
        make.right.mas_equalTo(navView).offset(-25);
    }];
    
    //科目
    UILabel *subject = [[UILabel alloc]init];
    subject.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    subject.textColor = [UIColor colorWithHexString:@"#909499"];
    subject.text = self.bookModel.subject;
    [navView addSubview:subject];
    [subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookTitle.mas_bottom).with.offset(10);
        make.left.mas_equalTo(bookCover.mas_right).with.offset(15);
    }];
    
    UILabel *bookVersion = [[UILabel alloc]init];
    bookVersion.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    bookVersion.textColor = [UIColor colorWithHexString:@"#909499"];
    bookVersion.text = self.bookModel.bookVersion;
    [navView addSubview:bookVersion];
    [bookVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(subject);
        make.left.mas_equalTo(subject.mas_right).with.offset(20);
    }];
    
    UILabel *grade = [[UILabel alloc]init];
    grade.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    grade.textColor = [UIColor colorWithHexString:@"#909499"];
    grade.text = self.bookModel.grade;
    [navView addSubview:grade];
    [grade mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(subject);
        make.left.mas_equalTo(bookVersion.mas_right).with.offset(20);
    }];
    
    UILabel *uploaderName = [[UILabel alloc]init];
    uploaderName.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
    uploaderName.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
    uploaderName.text = self.bookModel.uploaderName;
    [navView addSubview:uploaderName];
    [uploaderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(navView).offset(-20);
        make.left.mas_equalTo(bookCover.mas_right).with.offset(15);
    }];
    
    //灰线
    UIView *grayline = [[UIView alloc] init];
    grayline.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.12];
    [navView addSubview:grayline];
    [grayline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(navView);
        make.centerX.mas_equalTo(navView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
}

- (void)downloadData {
    
    NSString *secretKey = MD5_KEY;
    NSString *tTime = [CommonToolClass currentTimeStr];
    NSString *temp = [[[[self.bookModel.answerID stringByAppendingString:@":"]stringByAppendingString:secretKey]stringByAppendingString:@":"]stringByAppendingString:tTime];
    NSString *kMD5 = [NSString md5:temp];
    
    NSDictionary *dict = @{
                           @"openID":@"123",
                           @"answerID":self.bookModel.answerID,
                           @"sourceType":@"rec",
                           @"t":tTime,
                           @"k":kMD5
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForAnswerDetail] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {

            NSDictionary *jsonDataDic = responseObject[@"datas"];
            NSArray *thumbsArr = jsonDataDic[@"thumbs"];
            NSArray *detailArr = jsonDataDic[@"details"];
            self.answerList = [NSMutableArray array];
            //建立模型数组
            for (int i =0; i < thumbsArr.count; i++) {
                NSDictionary *aDic = thumbsArr[i];
                NSDictionary *bDic = detailArr[i];
                AnswerDetail *aModel = [AnswerDetail initWithDic1:aDic Dic2:bDic];
                aModel.answerCount = [[NSNumber numberWithUnsignedInteger:thumbsArr.count]stringValue];
                [self.answerList addObject:aModel];
            }
        }
        [self setupView];


    } failure:nil];
    [dataTask resume];
    
}

- (void)setupView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(90, 160);
    UICollectionView *adCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 72 + 128, SCREEN_WIDTH, SCREEN_HEIGHT - 66 - 128) collectionViewLayout:layout];
    adCV.delegate = self;
    adCV.dataSource = self;
    adCV.backgroundColor = whitecolor;
    [adCV registerClass:[AnswerCell class] forCellWithReuseIdentifier:@"ADCVC"];
    [self.view addSubview:adCV];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.answerList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerCell *cell = (AnswerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ADCVC" forIndexPath:indexPath];
    cell.model = self.answerList[indexPath.row];
    return cell;
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(0.24 * SCREEN_WIDTH, 0.42 * SCREEN_WIDTH);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.08 * SCREEN_WIDTH;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerDetailViewController *answerDetailVC = [[AnswerDetailViewController alloc]init];
    answerDetailVC.answerModel = self.answerList[indexPath.row];
    answerDetailVC.dataList = self.answerList;
    answerDetailVC.isSelected = self.isSelected;
    answerDetailVC.answerID = self.bookModel.answerID;
    answerDetailVC.reloadBlock = ^(BOOL IsSelected) {
        if (self.reloadBlock) {
            self.reloadBlock(IsSelected);
        }
    };
    
    
    [self.navigationController pushViewController:answerDetailVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

@end
