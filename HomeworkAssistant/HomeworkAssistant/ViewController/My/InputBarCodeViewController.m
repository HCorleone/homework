//
//  InputBarCodeViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/5.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//  手动输入条码

#import "InputBarCodeViewController.h"
#import "MyViewController.h"
#import "FillBookInformationViewController.h"

@interface InputBarCodeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView *navView;

@end

@implementation InputBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self getView];
}

//返回上一个界面
- (void)backToVc {
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)getView {
    //请输入书籍条形码
    _inputField = [[UITextField alloc] init];
    _inputField.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
    _inputField.textAlignment = NSTextAlignmentCenter;
    _inputField.textColor = UIColorFromRGB(0x8F9394);
    _inputField.text = @"请输入书籍条形码";
    _inputField.font = [UIFont systemFontOfSize:14.0];
    //    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.delegate = self;
    [self.view addSubview:_inputField];
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(223);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(314);
        make.height.mas_equalTo(37);
    }];
    
    //下一步按钮
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0.40 * SCREEN_WIDTH, 0.40 * SCREEN_WIDTH * 0.24);
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[UIColor colorWithHexString:@"#3DE5FF"].CGColor,
                              (id)[UIColor colorWithHexString:@"#3FBCF4"].CGColor,
                              nil
                              ]];
    
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn.layer addSublayer:gradientLayer];
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 0.40 * SCREEN_WIDTH * 0.24/2;
    [_nextBtn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputField.mas_bottom).offset(107);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(0.40 * SCREEN_WIDTH, 0.40 * SCREEN_WIDTH * 0.24));
    }];
    [_nextBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

//点击下一步
-(void)pressBtn{
    
    FillBookInformationViewController *fill = [[FillBookInformationViewController alloc] init];
    //    fill.fillView = [[FillBookInformationView alloc] init];
    //    fill.fillView.codeLabel.text = self.inputField.text;
    userDefaults(self.inputField.text, @"InputBarCode");
    [self.navigationController pushViewController:fill animated:YES];
}

#pragma mark - UITextFieldDelegate代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"请输入书籍条形码"]) {
        textField.text = nil;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"请输入书籍条形码";
    }
    return YES;
}

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    title.text = @"手动输入条码";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
        
    }];
}

@end
