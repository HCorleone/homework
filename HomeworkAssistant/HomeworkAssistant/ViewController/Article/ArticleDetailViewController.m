//
//  ArticleDetailViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *mainContentView;

@property (nonatomic, strong) UILabel *articleTitle;
@property (nonatomic, strong) UILabel *articleDetail;
@property (nonatomic, strong) UILabel *grade;
@property (nonatomic, strong) UILabel *articleType;
@property (nonatomic, strong) UILabel *wordsNum;



@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self setupNav];
    [self setupView];
    [self downloadData];
}

- (void)downloadData {
    
    NSString *openId = @"123";
    if ([TTUserManager sharedInstance].isLogin) {
        openId = [TTUserManager sharedInstance].currentUser.openId;
    }
    
    NSString *secretKey = MD5_KEY;
    NSString *tTime = [CommonToolClass currentTimeStr];
    NSString *temp = [[[[self.model.id stringByAppendingString:@":"]stringByAppendingString:secretKey]stringByAppendingString:@":"]stringByAppendingString:tTime];
    NSString *kMD5 = [NSString md5:temp];
    
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"articleID":self.model.id,
                           @"t":tTime,
                           @"k":kMD5,
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForArticleDetail] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSDictionary *jsonDataDic = responseObject[@"datas"];
            //作文详情
            self.articleDetail = [[UILabel alloc] init];
            self.articleDetail.text = jsonDataDic[@"content"];
            self.articleDetail.numberOfLines = 0;
            self.articleDetail.lineBreakMode = NSLineBreakByWordWrapping;
            self.articleDetail.font = [UIFont systemFontOfSize:16];
            self.articleDetail.textColor = [UIColor colorWithHexString:@"#2E3033"];
            [self.mainContentView addSubview:self.articleDetail];
            [self.articleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.grade.mas_bottom);
                make.left.mas_equalTo(self.mainContentView).offset(20);
                make.right.mas_equalTo(self.mainContentView).offset(-20);
            }];
            [self.articleDetail layoutIfNeeded];
            CGFloat height = self.articleDetail.frame.size.height;
            CGFloat y = self.grade.y + self.grade.height;
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height + y + 20 + BOT_OFFSET);
        }
        
        
    } failure:nil];
    [dataTask resume];
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
    title.text = @"作文";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
}

- (void)setupView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    self.scrollView.backgroundColor = whitecolor;
    self.scrollView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.scrollView];
    
    self.mainContentView = [[UIView alloc] init];
    self.mainContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.scrollView addSubview:self.mainContentView];
    
    //作文标题
    self.articleTitle = [[UILabel alloc] init];
    self.articleTitle.numberOfLines = 1;
    self.articleTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.articleTitle.text = self.model.title;
    self.articleTitle.font = [UIFont systemFontOfSize:18];
    self.articleTitle.textColor = [UIColor colorWithHexString:@"#2E3033"];
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 40, 100);
    CGSize realSize = [self.articleTitle sizeThatFits:maxSize];
    self.articleTitle.frame = CGRectMake(20, 16, SCREEN_WIDTH - 40, realSize.height);
    [self.mainContentView addSubview:self.articleTitle];
    
    //年级
    self.grade = [[UILabel alloc] init];
    [self.mainContentView addSubview:self.grade];
    self.grade.text = self.model.grade;
    self.grade.font = [UIFont systemFontOfSize:14];
    self.grade.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
    [self.grade mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainContentView).offset(20);
        make.top.mas_equalTo(self.articleTitle.mas_bottom).offset(5);
    }];
    
    
    //作文类型
    self.articleType = [[UILabel alloc] init];
    [self.mainContentView addSubview:self.articleType];
    self.articleType.text = self.model.articleType;
    self.articleType.font = [UIFont systemFontOfSize:14];
    self.articleType.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
    [self.articleType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.grade.mas_right).offset(10);
        make.centerY.mas_equalTo(self.grade);
    }];
    //字数
    self.wordsNum = [[UILabel alloc] init];
    [self.mainContentView addSubview:self.wordsNum];
    self.wordsNum.text = self.model.wordsNum;
    self.wordsNum.font = [UIFont systemFontOfSize:14];
    self.wordsNum.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
    [self.wordsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.articleType.mas_right).offset(10);
        make.centerY.mas_equalTo(self.grade);
    }];
    
}

@end
