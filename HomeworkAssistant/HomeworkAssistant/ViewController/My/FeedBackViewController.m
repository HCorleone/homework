//
//  FeedBackViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/3.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "FeedBackViewController.h"
#import "HHDropDownList.h"

@interface FeedBackViewController ()<HHDropDownListDelegate, HHDropDownListDataSource, HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UITextField *titleField;

@property (nonatomic, strong) UIButton *addCoverBtn;
@property (nonatomic, strong) UIImageView *bookCover;

//需要上传的内容
@property (nonatomic, strong) NSString *uploadTitle;
@property (nonatomic, strong) NSString *uploadGrade;
@property (nonatomic, strong) NSString *uploadSubject;
@property (nonatomic, strong) NSString *uploadVersion;

//下拉列表
@property (nonatomic, strong) HHDropDownList *dropDownList_1;
@property (nonatomic, strong) HHDropDownList *dropDownList_2;
@property (nonatomic, strong) HHDropDownList *dropDownList_3;

//照片选取相关
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    
    //默认上传参数
    self.uploadGrade = @"学前";
    self.uploadSubject = @"语文";
    self.uploadVersion = @"人教版";
    
    [self.dropDownList_1 reloadListData];
    [self.dropDownList_2 reloadListData];
    [self.dropDownList_3 reloadListData];
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
    title.text = @"填写书籍信息";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont systemFontOfSize:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
}

- (void)setupView {

    //输入书名的textfiled
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(0.223 * SCREEN_WIDTH, 0.245 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.14)];
    [self.view addSubview:titleField];
    titleField.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.03];
    titleField.placeholder = @"请输入书籍名称";
    [titleField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [titleField setValue:[UIColor colorWithHexString:@"#8F9394"] forKeyPath:@"_placeholderLabel.textColor"];
    titleField.font = [UIFont systemFontOfSize:14];
    titleField.textColor = [UIColor colorWithHexString:@"#8F9394"];
    titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField = titleField;
    
    //书名label
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"书名:";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor colorWithHexString:@"#353B3C"];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0.084 * SCREEN_WIDTH);
        make.centerY.mas_equalTo(titleField);
    }];
    
    //年级下拉菜单
    self.dropDownList_1 = [[HHDropDownList alloc] initWithFrame:CGRectMake(0.223 * SCREEN_WIDTH, 0.381 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.14)];
    [self.view addSubview:self.dropDownList_1];
    [self.dropDownList_1 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.03]];
    [self.dropDownList_1 setHighlightColor:maincolor];
    [self.dropDownList_1 setDelegate:self];
    [self.dropDownList_1 setDataSource:self];
    [self.dropDownList_1 setIsExclusive:YES];
    self.dropDownList_1.from = FromGrade;
//    [self.dropDownList_1 setHaveBorderLine:NO];
    
    //年级label
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"年级:";
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor colorWithHexString:@"#353B3C"];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0.084 * SCREEN_WIDTH);
        make.centerY.mas_equalTo(self.dropDownList_1);
    }];
    
    //学科下拉菜单
    self.dropDownList_2 = [[HHDropDownList alloc] initWithFrame:CGRectMake(0.223 * SCREEN_WIDTH, 0.517 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.14)];
    [self.view addSubview:self.dropDownList_2];
    [self.dropDownList_2 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.03]];
    [self.dropDownList_2 setHighlightColor:maincolor];
    [self.dropDownList_2 setDelegate:self];
    [self.dropDownList_2 setDataSource:self];
    [self.dropDownList_2 setIsExclusive:YES];
    self.dropDownList_2.from = FromSubject;
//    [self.dropDownList_2 setHaveBorderLine:NO];
    
    //学科label
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"学科:";
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = [UIColor colorWithHexString:@"#353B3C"];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0.084 * SCREEN_WIDTH);
        make.centerY.mas_equalTo(self.dropDownList_2);
    }];
    
    //版本下拉菜单
    self.dropDownList_3 = [[HHDropDownList alloc] initWithFrame:CGRectMake(0.223 * SCREEN_WIDTH, 0.653 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.14)];
    [self.view addSubview:self.dropDownList_3];
    [self.dropDownList_3 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.03]];
    [self.dropDownList_3 setHighlightColor:maincolor];
    [self.dropDownList_3 setDelegate:self];
    [self.dropDownList_3 setDataSource:self];
    [self.dropDownList_3 setIsExclusive:YES];
    self.dropDownList_3.from = FromVersion;
//    [self.dropDownList_3 setHaveBorderLine:NO];
    
    //版本label
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"版本:";
    label4.font = [UIFont systemFontOfSize:14];
    label4.textColor = [UIColor colorWithHexString:@"#353B3C"];
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0.084 * SCREEN_WIDTH);
        make.centerY.mas_equalTo(self.dropDownList_3);
    }];
    
    //显示条码的textfiled
    UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(0.223 * SCREEN_WIDTH, 0.789 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH, 0.69 * SCREEN_WIDTH * 0.14)];
    [self.view addSubview:codeField];
    codeField.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.03];
    codeField.text = self.uploadCode;
    codeField.font = [UIFont systemFontOfSize:14];
    codeField.textColor = [UIColor colorWithHexString:@"#8F9394"];
    codeField.textAlignment = NSTextAlignmentCenter;
    codeField.userInteractionEnabled = NO;
    
    //条码label
    UILabel *label5 = [[UILabel alloc] init];
    label5.text = @"条码:";
    label5.font = [UIFont systemFontOfSize:14];
    label5.textColor = [UIColor colorWithHexString:@"#353B3C"];
    [self.view addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0.084 * SCREEN_WIDTH);
        make.centerY.mas_equalTo(codeField);
    }];
    
    //添加封面按钮
    UIButton *addCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCoverBtn setBackgroundImage:[UIImage imageNamed:@"添加书籍"] forState:UIControlStateNormal];
    [self.view addSubview:addCoverBtn];
    [addCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(0.224 * SCREEN_WIDTH, 0.224 * SCREEN_WIDTH * 1.3));
        make.top.mas_equalTo(codeField.mas_bottom).with.offset(0.08 * SCREEN_WIDTH);
    }];
    [addCoverBtn addTarget:self action:@selector(selectBookCover:) forControlEvents:UIControlEventTouchUpInside];
    self.addCoverBtn = addCoverBtn;
    
    //封面展示view
    UIImageView *bookCover = [[UIImageView alloc] init];
    [self.view addSubview:bookCover];
    [bookCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(0.224 * SCREEN_WIDTH, 0.224 * SCREEN_WIDTH * 1.3));
        make.top.mas_equalTo(codeField.mas_bottom).with.offset(0.08 * SCREEN_WIDTH);
    }];
    self.bookCover = bookCover;
    self.bookCover.hidden = YES;
    
    //上传封面label
    UILabel *label6 = [[UILabel alloc] init];
    label6.text = @"请上传封面:";
    label6.font = [UIFont systemFontOfSize:14];
    label6.textColor = [UIColor colorWithHexString:@"#353B3C"];
    [self.view addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0.084 * SCREEN_WIDTH);
        make.centerY.mas_equalTo(addCoverBtn);
    }];
    //提交反馈按钮
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
    [uploadBtn addTarget:self action:@selector(uploadFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SCREEN_HEIGHT * 0.157);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(0.40 * SCREEN_WIDTH, 0.40 * SCREEN_WIDTH * 0.24));
    }];
    [uploadBtn setTitleColor:whitecolor forState:UIControlStateNormal];
    [uploadBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    uploadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)uploadFeedBack:(UIButton *)btn {
    
    self.uploadTitle = self.titleField.text;
    
    if ([self.uploadTitle isEqualToString:@""]) {
        [XWHUDManager showTipHUDInView:@"请输入书籍名称"];
        return;
    }
    else if (!self.bookCover.image) {
        [XWHUDManager showTipHUDInView:@"请添加书籍封面图片"];
        return;
    }
    else {
        [self uploadfeedBack];
    }
    
}

- (void)uploadfeedBack {
    NSArray *contentArr = @[self.uploadTitle, self.uploadGrade, self.uploadSubject, self.uploadVersion];
    NSString *content = [contentArr componentsJoinedByString:@"_"];
    NSLog(@"%@",content);
    
//    NSDictionary *dict = @{
//                           @"code":self.uploadCode,
//                           @"type":@"-1",
//                           @"content":content,
//                           @"appType":@"zuoyezhushou",
////                           @"fileList":self.bookCover.image
//                           };
//    dict = [HMACSHA1 encryptDicForRequest:dict];
//
//    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
//    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForUploadFeedBack] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        if ([responseObject[@"code"]integerValue] == 200) {
//            [XWHUDManager showSuccessTipHUDInView:@"我们已收到您的反馈"];
//        }
//
//    } failure:nil];
//    [dataTask resume];
//

}

- (void)selectBookCover:(UIButton *)btn {
    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
    vc.delegate = self;
    vc.manager = self.manager;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - HHDropDownListDataSource
- (NSArray *)listDataForDropDownList:(HHDropDownList *)dropDownList {
    NSArray *titleArr = [NSArray array];
    if (dropDownList.from == FromGrade) {
        titleArr = @[@"学前", @"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"七年级", @"八年级", @"九年级", @"高一", @"高二", @"高三"];
    }
    else if (dropDownList.from == FromSubject) {
        titleArr = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"科学"];
    }
    else if (dropDownList.from == FromVersion) {
        titleArr = @[@"人教版", @"北师大版", @"苏教版", @"冀教版", @"外研版", @"沪科版", @"湘教版", @"青岛版", @"鲁教版", @"浙教版", @"教科版", @"华师大版", @"译林版", @"苏科版", @"语文版", @"西师大版", @"牛津版", @"沪粤版", @"北京课改版", @"鲁科版", @"河大版", @"长春版", @"语文S版", @"冀少版", @"商务星球版", @"济南版", @"鄂教版", @"江苏版", @"中华书局版", @"中科版", @"科粤版", @"川教版", @"陕旅版", @"语文A版", @"仁爱版", @"苏人版", @"其他"];
    }
    else {
        
    }
    return titleArr;
}

#pragma mark - HHDropDownListDelegate
- (void)dropDownList:(HHDropDownList *)dropDownList didSelectItemName:(NSString *)itemName atIndex:(NSInteger)index {
    if (dropDownList.from == FromGrade) {
        self.uploadGrade = itemName;
    }
    else if (dropDownList.from == FromSubject) {
        self.uploadSubject = itemName;
    }
    else if (dropDownList.from == FromVersion) {
        self.uploadVersion = itemName;
    }
    else {
        
    }
    
}

#pragma mark - 照片选取相关
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.singleSelected = YES;
        _manager.configuration.albumListTableView = ^(UITableView *tableView) {
            //            NSSLog(@"%@",tableView);
        };
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _manager;
}

//选择完毕之后的回调
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllImage:(NSArray<UIImage *> *)imageList {
    self.bookCover.hidden = NO;
    self.bookCover.image = imageList[0];
}

#pragma mark - other
//收起键盘和菜单
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.dropDownList_1 pullBack];
    [self.dropDownList_2 pullBack];
    [self.dropDownList_3 pullBack];
}

@end
