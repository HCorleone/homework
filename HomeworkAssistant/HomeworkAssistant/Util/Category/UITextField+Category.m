//
//  UITextField+Category.m
//  党建
//
//  Created by Mac on 2018/10/30.
//  Copyright © 2018年 wx. All rights reserved.
//

#import "UITextField+Category.h"

@implementation UITextField (Category)

+ (UITextField *)textFieldWithSuperView:(UIView *)superView Placehold:(NSString *)placehold PlaceholdColor:(UIColor *)placeholdColor
{
    UITextField *textField = [[UITextField alloc] init];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placehold attributes:[NSDictionary dictionaryWithObjectsAndKeys:placeholdColor, NSForegroundColorAttributeName,nil]];
    [superView addSubview:textField];
    return textField;
}

+ (UITextField *)textFieldWithSuperView:(UIView *)superView Placehold:(NSString *)placehold PlaceholdColor:(UIColor *)placeholdColor Tag:(NSInteger)tag TextAlignment:(NSTextAlignment)textAlignment
{
    UITextField *textField = [[UITextField alloc] init];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placehold attributes:[NSDictionary dictionaryWithObjectsAndKeys:placeholdColor, NSForegroundColorAttributeName,nil]];
    textField.tag = tag;
    textField.textAlignment = textAlignment;
    [superView addSubview:textField];
    return textField;
}

+ (UITextField *)textFieldWithSuperView:(UIView *)superView Content:(NSString *)content TextColor:(UIColor *)textColor Tag:(NSInteger)tag TextAlignment:(NSTextAlignment)textAlignment
{
    UITextField *textField = [[UITextField alloc] init];
    textField.text = content;
    textField.textColor = textColor;
    textField.tag = tag;
    textField.textAlignment = textAlignment;
    [superView addSubview:textField];
    return textField;
}

@end
