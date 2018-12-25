//
//  BaseViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/24.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
}

- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
