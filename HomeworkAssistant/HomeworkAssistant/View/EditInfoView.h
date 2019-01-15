//
//  EditInfoView.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/14.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^reloadInfo)(NSDictionary *dict);

@interface EditInfoView : UIView

@property (nonatomic, strong) UIViewController *currentVC;//当前控制器
@property (nonatomic, assign) BOOL isShow;//用于判断是否显示

@property (nonatomic, copy) reloadInfo reloadInfo;

@end

NS_ASSUME_NONNULL_END
