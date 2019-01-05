//
//  InputBarCodeViewController.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/5.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, From) {
    FromUploadAnswer,
    FromFeedBackAnswer,
    FromDefault = FromUploadAnswer
};


@interface InputBarCodeViewController : BaseViewController

@property (nonatomic, assign) From from;

@end

NS_ASSUME_NONNULL_END
