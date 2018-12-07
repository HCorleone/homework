//
//  UIButton+Category.h
//  党建
//
//  Created by Mac on 2018/10/27.
//  Copyright © 2018年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Category)
//快速创建button, 传图片
+ (UIButton *)buttonWithName:(NSString *)name SuperView:(UIView *)superView Tag:(NSInteger)tag Target:(id)target Action:(SEL)action;
//快速创建button, 不传图片名
+ (UIButton *)buttonWithSuperView:(UIView *)superView Tag:(NSInteger)tag Target:(id)target Action:(SEL)action;
//快速创建button, 添加字体,设置字体大小（设置居左显示）
+ (UIButton *)buttonWithSuperView:(UIView *)superView TitleFont:(float)Titlefont Tag:(NSInteger)tag Target:(id)target Action:(SEL)action;
//快速创建button, 设置背景图片,添加文字
+ (UIButton *)buttonWithName:(NSString *)name SuperView:(UIView *)superView Title:(NSString *)title Target:(id)target Action:(SEL)action;
//快速创建button, 不传图片, 设置字体
+ (UIButton *)buttonWithText:(NSString *)text TextColor:(UIColor *)color TextSize:(NSInteger)size SuperView:(UIView *)superView Tag:(NSInteger)tag Target:(id)target Action:(SEL)action;
//快速创建button, 设置字体, 导航栏button
+ (UIButton *)buttonWithText:(NSString *)text TextColor:(UIColor *)color Target:(id)target Action:(SEL)action;
//快速创建button, 设置正常图片和点击后图片
+ (UIButton *)buttonWithSuperView:(UIView *)superView Name:(NSString *)name SelectName:(NSString *)selectName Target:(id)target Action:(SEL)action Tag:(NSInteger)tag;
@end

NS_ASSUME_NONNULL_END
