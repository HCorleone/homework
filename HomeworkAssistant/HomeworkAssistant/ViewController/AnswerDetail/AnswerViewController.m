//
//  AnswerViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerDetail.h"
#import "AnswerDetailCollectionView.h"

@interface AnswerViewController ()

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

- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
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
    title.text = @"全部作业";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
        
    }];
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData {
    
    NSString *secretKey = @"&&*%$dkeunk0*!@^*&%nnc<scvqw";
    NSString *tTime = [self currentTimeStr];
    NSString *temp = [[[[self.bookModel.answerID stringByAppendingString:@":"]stringByAppendingString:secretKey]stringByAppendingString:@":"]stringByAppendingString:tTime];
    NSString *kMD5 = [NSString md5:temp];
    
    NSDictionary *dict = @{
                           @"h":@"ZYAnswerDetailHandler",
                           @"openID":@"123",
                           @"answerID":self.bookModel.answerID,
                           @"sourceType":@"rec",
                           @"pkn":@"com.enjoytime.palmhomework",
                           @"t":tTime,
                           @"k":kMD5,
                           @"av":@"_debug_"
                           };

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    NSURLSessionDataTask *dataTask = [manager GET:zuoyeURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
        [self setupViewWithList:self.answerList];


    } failure:nil];
    [dataTask resume];
    
}

- (void) setupViewWithList:(NSMutableArray *)array {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, 160);
    AnswerDetailCollectionView *adCV = [[AnswerDetailCollectionView alloc]initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH, SCREEN_HEIGHT - 66) collectionViewLayout:layout withArray:array];
    adCV.isSelected = self.isSelected;
    adCV.answerID = self.bookModel.answerID;
    [self.view addSubview:adCV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

@end
