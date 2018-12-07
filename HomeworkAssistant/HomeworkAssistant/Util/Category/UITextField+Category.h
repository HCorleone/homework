//
//  UITextField+Category.h
//  党建
//
//  Created by Mac on 2018/10/30.
//  Copyright © 2018年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Category)
//快速创建textField
+ (UITextField *)textFieldWithSuperView:(UIView *)superView Placehold:(NSString *)placehold PlaceholdColor:(UIColor *)placeholdColor;
//快速创建textField, 加上tag值
+ (UITextField *)textFieldWithSuperView:(UIView *)superView Placehold:(NSString *)placehold PlaceholdColor:(UIColor *)placeholdColor Tag:(NSInteger)tag TextAlignment:(NSTextAlignment)textAlignment;
//快速创建textField,没有占位符
+ (UITextField *)textFieldWithSuperView:(UIView *)superView Content:(NSString *)content TextColor:(UIColor *)textColor Tag:(NSInteger)tag TextAlignment:(NSTextAlignment)textAlignment;
@end

NS_ASSUME_NONNULL_END
