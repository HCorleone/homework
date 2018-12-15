//
//  ButtonLinks.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/15.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonLinks : UIButton
{
    UIColor *lineColor;
}

-(void)setLinkColor:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
