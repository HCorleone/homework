//
//  CommonAlterView.h
//  拍照
//
//  Created by 邱敏 on 2018/8/14.
//  Copyright © 2018年 ytq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAlterView : UIView

//iOS 8-
+ (void)showAlertView:(NSString *)alertMessage;

//iOS 8+
+ (void)showMessage:(NSString *)m andVC:(UIViewController *)uivc;

//执行具体操作
+ (void)showMessages:(NSString *)m andVC:(UIViewController *)uivc handler:(void(^)(UIAlertAction *action))actions;
@end
