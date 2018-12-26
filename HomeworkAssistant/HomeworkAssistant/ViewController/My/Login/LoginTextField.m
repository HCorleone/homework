//
//  LoginTextField.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/15.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

- (instancetype)init:(NSString *)placeholder {
    self = [super init];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
    self.textColor = whitecolor;
    self.font = [UIFont systemFontOfSize:14];
    self.placeholder = placeholder;
    [self setValue:whitecolor forKeyPath:@"_placeholderLabel.textColor"];
    
    return self;
}

//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y, bounds.size.width -15, bounds.size.height);
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y, bounds.size.width -15, bounds.size.height);
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +15, bounds.origin.y, bounds.size.width -15, bounds.size.height);
    return inset;
}

@end
