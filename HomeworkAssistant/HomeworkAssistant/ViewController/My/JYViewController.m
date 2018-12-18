//
//  JYViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/12.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "JYViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "LTTextView.h"

@interface JYViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, weak) LTTextView *contentTextView;
@property (nonatomic, weak) UITextField *lianxiField;
@property(nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, strong) UIView *loginView;

@end

@implementation JYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    
    [self setupNav];
    
    
    //建议框背景
    self.loginView = [[UIView alloc]init];
    [self.view addSubview:self.loginView];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.layer.cornerRadius = 4;
    self.loginView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 3);
    self.loginView.layer.shadowOpacity = 0.7;
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(0.05 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.86 * SCREEN_WIDTH, 0.7 * 0.86 * SCREEN_WIDTH));
    }];
    //建议文本
    LTTextView  *textView = [[LTTextView alloc] init];
    textView.placeholderTextView.text = @"输入您的建议，我们将为您不断改进";
    [self.view addSubview:textView];
    self.contentTextView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(0.05 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.86 * SCREEN_WIDTH, 0.7 * 0.86 * SCREEN_WIDTH));
    }];
    
    //联系方式框背景
    self.loginView = [[UIView alloc]init];
    [self.view addSubview:self.loginView];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.layer.cornerRadius = 4;
    self.loginView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 3);
    self.loginView.layer.shadowOpacity = 0.7;
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).with.offset(0.03 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.86 * SCREEN_WIDTH, 0.86 * SCREEN_WIDTH * 0.14));
    }];
    //联系方式文本
    UITextField *lianxiField = [[UITextField alloc]init];
    lianxiField.placeholder = @"请留下您的联系方式";
    [lianxiField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [lianxiField setValue:[UIColor colorWithHexString:@"#8F9394"] forKeyPath:@"_placeholderLabel.textColor"];
    lianxiField.delegate = self;
    [self.view addSubview:lianxiField];
    self.lianxiField = lianxiField;
    [lianxiField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.loginView).offset(0.04 * SCREEN_WIDTH);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).with.offset(0.03 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.86 * SCREEN_WIDTH, 0.86 * SCREEN_WIDTH * 0.14));
    }];
    
    
    //提交按钮
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0.83 * SCREEN_WIDTH, 0.83 * SCREEN_WIDTH * 0.12);
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[UIColor colorWithHexString:@"#3DE5FF"].CGColor,
                              (id)[UIColor colorWithHexString:@"#3FBCF4"].CGColor,
                              nil
                              ]];
    
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    
    UIButton *summitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    summitBtn.layer.cornerRadius = 0.83 * SCREEN_WIDTH * 0.12/2;
    summitBtn.layer.masksToBounds = YES;
    [summitBtn.layer addSublayer:gradientLayer];
    [self.view addSubview:summitBtn];
    [summitBtn addTarget:self action:@selector(toSend:) forControlEvents:UIControlEventTouchUpInside];
    [summitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lianxiField.mas_bottom).with.offset(0.1 * SCREEN_WIDTH);
        make.size.mas_equalTo(CGSizeMake(0.83 * SCREEN_WIDTH, 0.83 * SCREEN_WIDTH * 0.12));
    }];
    summitBtn.titleLabel.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [summitBtn setTitle:@"提交建议" forState:UIControlStateNormal];
    [summitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}

//发送反馈信息
- (void)toSend:(id)sender {
    
    
    
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
    title.text = @"提供建议";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
    }];
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

