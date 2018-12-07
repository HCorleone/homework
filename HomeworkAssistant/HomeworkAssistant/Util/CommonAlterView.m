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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}
@end
