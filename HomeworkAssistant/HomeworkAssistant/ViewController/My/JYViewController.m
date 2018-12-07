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
    self.loginView.layer.cornerRadius = 5;
    self.loginView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 2);
    self.loginView.layer.shadowOpacity = 0.5;
    self.loginView.layer.shadowRadius = 3;
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(322, 225));
    }];
    //建议文本
    LTTextView  *textView = [[LTTextView alloc] init];
    textView.placeholderTextView.text = @"输入您的建议，我们将为您不断改进";
    [self.view addSubview:textView];
    self.contentTextView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(298, 220));
    }];
    
    //联系方式框背景
    self.loginView = [[UIView alloc]init];
    [self.view addSubview:self.loginView];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.layer.cornerRadius = 5;
    self.loginView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 2);
    self.loginView.layer.shadowOpacity = 0.5;
    self.loginView.layer.shadowRadius = 3;
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(322, 46));
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
        make.left.mas_equalTo(self.loginView.mas_left).offset(16);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(306, 46));
    }];
    
    
    //提交按钮
    UIButton *summitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    summitBtn.layer.cornerRadius = 10;
    summitBtn.layer.shadowOffset =  CGSizeMake(0, 1);
    summitBtn.layer.shadowOpacity = 1;
    summitBtn.layer.shadowColor =  [UIColor colorWithHexString:@"#2983C8"].CGColor;
    summitBtn.backgroundColor = [UIColor colorWithHexString:@"#6FDDFF"];
    [self.view addSubview:summitBtn];
    [summitBtn addTarget:self action:@selector(toSend:) forControlEvents:UIControlEventTouchUpInside];
    [summitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lianxiField.mas_bottom).with.offset(36);
        make.size.mas_equalTo(CGSizeMake(312, 36));
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

