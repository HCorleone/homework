//
//  UITextView+UITextView_Placeholder.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/14.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "UITextView+UITextView_Placeholder.h"

@implementation UITextView (UITextView_Placeholder)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeholdStr;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = placeholdColor;
    placeHolderLabel.font = self.font;
    [placeHolderLabel sizeToFit];
    
    /*
     [self setValue:(nullable id) forKey:(nonnull NSString *)]
     ps: KVC键值编码，对UITextView的私有属性进行修改
     */
    if (HKVersion >= 8.3) {
        UILabel *placeholder = [self valueForKey:@"_placeholderLabel"];
        //防止重复
        if (placeholder) {
            return;
        }
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}

@end
