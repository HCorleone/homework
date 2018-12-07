//
//  UILabel+Category.h
//  党建
//
//  Created by Mac on 2018/10/27.
//  Copyright © 2018年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Category)

//快速创建UILabel, lebal一行
+ (UILabel *)labelWithContent:(NSString *)content SuperView:(UIView *)superView TextColor:(UIColor *)textColor Font:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment AdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth;

//快速创建UILabel, lebal行数自定义
+ (UILabel *)labelWithContent:(NSString *)content SuperView:(UIView *)superView TextColor:(UIColor *)textColor Font:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment NumberOfLines:(NSInteger)numberOfLines;

//设置字体样式，一行
+ (UILabel *)labelWithContent:(NSString *)content SuperView:(UIView *)superView TextColor:(UIColor *)textColor FontName:(NSString *)name Font:(NSInteger)font TextAlignment:(NSTextAlignment)textAlignment AdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth;

//文字自适应
+ (UILabel *)labelWithAttributedTextContent:(NSString *)content SuperView:(UIView *)superView TextColor:(UIColor *)textColor Font:(UIFont *)font LineSpacing:(NSInteger)line Broadsize:(NSInteger)widthSize mask_makeConstraints:(void (^)(MASConstraintMaker *make))makes;
//快速创建UILabel,label能否交互
+ (UILabel *)labelWithSuperView:(UIView *)superView Text:(NSString *)text TextColor:(UIColor *)textColor Font:(float)font TextAlignment:(NSTextAlignment)textAlignment UserInteractionEnabled:(BOOL)userInteractionEnabled Tag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
