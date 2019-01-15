//
//  DownloadedAnswerDetailViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/8.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "DownloadedAnswerDetailViewController.h"
#import "AnswerDetailCell.h"
#import <UShareUI/UShareUI.h>
#import "AnswerDetail.h"
#import "UIImageView+WebCache.h"

@interface DownloadedAnswerDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *page;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation DownloadedAnswerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = whitecolor;
    
    [self setupBrowser];
    [self setupNav];
    [self setupBot];
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
        make.height.mas_equalTo(72);
    }];
    self.navView = navView;
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).offset(20);
        make.bottom.mas_equalTo(self.navView).offset(-10);
    }];
    //标题
    UILabel *title = [[UILabel alloc]init];
    [title setTextColor: [UIColor whiteColor]];
    title.text = [[self.idx stringByAppendingString:@"/"] stringByAppendingString:self.answerCount];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navView).offset(-20);
        make.centerY.mas_equalTo(backBtn);
    }];
    self.page = title;
}

- (void)setupBot {
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = whitecolor;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(48 + BOT_OFFSET);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteView addSubview:shareBtn];
    [shareBtn setBackgroundColor:whitecolor];
    [shareBtn setTitle:@"分享给同学" forState:UIControlStateNormal];
    [shareBtn setTitleColor:maincolor forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView);
        make.top.mas_equalTo(whiteView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 48));
    }];
    self.shareBtn = shareBtn;
    [self.shareBtn addTarget:self action:@selector(toShare) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteView addSubview:collectBtn];
    if (!self.isSelected) {
        [collectBtn setBackgroundColor:maincolor];
        [collectBtn setTitle:@"收藏到书单" forState:UIControlStateNormal];
        [collectBtn setTitleColor:whitecolor forState:UIControlStateNormal];
    }
    else {
        [collectBtn setBackgroundColor:whitecolor];
        [collectBtn setTitle:@"已收藏至书单" forState:UIControlStateNormal];
        [collectBtn setTitleColor:[UIColor colorWithHexString:@"#D5D5D5"] forState:UIControlStateNormal];
    }
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView).offset(-0.064 * SCREEN_WIDTH);
        //        make.bottom.mas_equalTo(self.view).offset(-BOT_OFFSET);
        make.centerY.mas_equalTo(shareBtn);
        make.size.mas_equalTo(CGSizeMake(0.368 * SCREEN_WIDTH, 0.044 * SCREEN_HEIGHT));
    }];
    collectBtn.layer.cornerRadius = 0.044 * SCREEN_HEIGHT/2;
    [collectBtn addTarget:self action:@selector(userLikeOrNot) forControlEvents:UIControlEventTouchUpInside];
    self.collectBtn = collectBtn;
    
}

- (void)userLikeOrNot {
    
    
    if (self.isSelected) {
        [self userDisLike];
        if (self.reloadBlock) {
            self.reloadBlock(!self.isSelected);
        }
    }
    else {
        if ([TTUserManager sharedInstance].isLogin) {
            [self userLike];
            if (self.reloadBlock) {
                self.reloadBlock(!self.isSelected);
            }
        }
        else {
            [XWHUDManager showTipHUD:@"请先登录"];
        }
    }
    
}

//用户点击收藏按钮
- (void)userLike {
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"answerID":self.answerID,
                           @"sourceType":@"rec"
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForUserLike] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            self.isSelected = YES;
            [self.collectBtn setBackgroundColor:whitecolor];
            [self.collectBtn setTitle:@"已收藏至书单" forState:UIControlStateNormal];
            [self.collectBtn setTitleColor:[UIColor colorWithHexString:@"#D5D5D5"] forState:UIControlStateNormal];
            [XWHUDManager showSuccessTipHUDInView:@"收藏成功"];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

//用户取消收藏
- (void)userDisLike {
    
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"answerIDs":self.answerID,
                           @"sourceType":@"rec"
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForDelUserLike] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            self.isSelected = NO;
            [self.collectBtn setBackgroundColor:maincolor];
            [self.collectBtn setTitle:@"收藏到书单" forState:UIControlStateNormal];
            [self.collectBtn setTitleColor:whitecolor forState:UIControlStateNormal];
            NSLog(@"取消收藏");
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"cellTest" object:nil];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)toShare {
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    });
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UIImage *logoImg = self.bookImg;
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.bookTitle descr:[NSString stringWithFormat:@"我找到%@的答案啦，快来查看",self.bookTitle] thumImage:logoImg];
        //设置网页地址
//        shareObject.webpageUrl = @"http://abc.tatatimes.com/downloadhomework.html";
        shareObject.webpageUrl = [self getShareURL];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }];
}

//获取分享的链接
- (NSString *)getShareURL {
    
    NSDictionary *dict = @{
                           @"answerID":self.answerID
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
    NSString *testStr = [CommonToolClass getURLFromDic:dict];
    NSString *resURL = [[[URLBuilder getURLForShareBook] stringByAppendingString:@"&"] stringByAppendingString:testStr];
    NSLog(@"%@",resURL);
    resURL = [resURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return resURL;
}

- (void)setupBrowser {
    //获得数据
    self.dataList = [NSMutableArray arrayWithArray:[DBManager selectDetailImgWithAnswerID:self.answerID]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    [self.view addSubview:collectionView];

    collectionView.maximumZoomScale = 2.0;
    collectionView.minimumZoomScale = 0.5;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = whitecolor;
    [collectionView registerClass:[AnswerDetailCell class] forCellWithReuseIdentifier:@"AC"];
    self.collectionView = collectionView;
    
    NSInteger flag = [self.idx integerValue];
    self.collectionView.contentOffset = CGPointMake((flag - 1) * SCREEN_WIDTH, 0);
    
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
    
    AnswerDetailCell *cell = (AnswerDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AC" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataList[indexPath.row];
    NSString *detailPath = dic[@"detailPath"];
    cell.detailPath = detailPath;
//    [cell.imgScrollView.imgView sd_setImageWithURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:detailPath]]];
//    cell.imgScrollView.imgView.frame = [cell getSmallFrameWith:cell.imgScrollView.imgView.image.size];
    return cell;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = self.collectionView.contentOffset.x/SCREEN_WIDTH;
    page = page + 1;
    NSString *temp = [[NSNumber numberWithInteger:page]stringValue];
    self.page.text = [[temp stringByAppendingString:@"/"] stringByAppendingString:self.answerCount];
    
}


@end
