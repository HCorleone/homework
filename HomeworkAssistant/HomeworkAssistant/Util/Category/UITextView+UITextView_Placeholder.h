//
//  UITextView+UITextView_Placeholder.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/14.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define HKVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface UITextView (UITextView_Placeholder)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;

@end

NS_ASSUME_NONNULL_END
