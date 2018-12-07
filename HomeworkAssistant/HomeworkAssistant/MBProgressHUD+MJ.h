//
//  MBProgressHUD+MJ.h
//  MBProgressHUD
//
//  Created by 无敌帅枫 on 2018/11/16.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

//bylilu
+ (void)showCustomMessage:(NSString *)message
                   toView:(UIView *)view;

@end


NS_ASSUME_NONNULL_END
