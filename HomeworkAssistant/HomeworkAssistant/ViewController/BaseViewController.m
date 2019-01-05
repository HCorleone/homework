//
//  BaseViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/24.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

/*
           ____________________________________________________
          /                                                    \
         |   ________________________________________________   |
         |  |                                                |  |
         |  | #import <Foundation/Foundation.h>              |  |
         |  |                                                |  |
         |  | int main(int argc, char *argv[]) {             |  |
         |  |                                                |  |
         |  |     @autoreleasepool {                         |  |
         |  |         NSLog(@"陈南枫牛逼!");                   |  |
         |  |     }                                          |  |
         |  |                                                |  |
         |  |     return 0;                                  |  |
         |  | }                                              |  |
         |  |                                                |  |
         |  |                                                |  |
         |  |________________________________________________|  |
         |                     MacBook Pro                      |
          \_____________________________________________________/
          _______\_______________________________________/________
       _-'.-.-. .---.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.--.  .-.-.-. `-_
     _-'.-.-.-. .---.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-`__`. .-.-.-.-.`-_
   _-'.-.-.-.-. .-----.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-----. .-.-.-.-. `-_
 _-'.-.-.-.-.-. .---.-. .-----------------------------. .-.---. .---.-.-.-.`-_
:-----------------------------------------------------------------------------:
`---._.-----------------------------------------------------------------._.---'

*/

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
