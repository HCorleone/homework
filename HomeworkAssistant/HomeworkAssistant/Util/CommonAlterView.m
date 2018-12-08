//
//  CommonAlterView.m
//  拍照
//
//  Created by 邱敏 on 2018/8/14.
//  Copyright © 2018年 ytq. All rights reserved.
//

#import "CommonAlterView.h"

@implementation CommonAlterView

+(void)showAlertView:(NSString *)alertMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertMessage message:nil                                                                                                                                                                                                                                                                                                                                                                                                                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+ (void)initMessage:(NSString *)m andVC:(UIViewController *)uivc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:m preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [uivc presentViewController:alert animated:YES completion:nil];
}

+ (void)initMessage:(NSString *)m andVC:(UIViewController *)uivc handler:(void(^)(UIAlertAction *action))actions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:m preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actions(action);
    }];
    [alert addAction:action];
    [uivc presentViewController:alert animated:YES completion:nil];
}
@end
