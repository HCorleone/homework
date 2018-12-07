//
//  UPLoadViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/5.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//  上传答案

#import "UPLoadViewController.h"
#import "InputBarCodeViewController.h"

@interface UPLoadViewController ()

@end

@implementation UPLoadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.view).with.offset(20);
        make.top.mas_equalTo(self.view).with.offset(35);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[[InputBarCodeViewController alloc] init] animated:YES];
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
