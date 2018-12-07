//
//  EditorNameView.h
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/7.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditorNameView : UIView

/** 背景 */
@property (nonatomic, strong) UIView *bgView;
/** 信息 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 昵称 */
@property (nonatomic, strong) UITextField *nameField;
/** 年级 */
@property (nonatomic, strong) UIButton *downBtn;
/** 城市 */
@property (nonatomic, strong) UIButton *cityBtn;
/** 确认 */
@property (nonatomic, strong) UIButton *okBtn;
/** 取消 */
@property (nonatomic, strong) UIButton *noBtn;

typedef void(^clickBlock)(UIButton *btn);
@property (nonatomic, copy) clickBlock clickBlock;

- (void)showEditorView;

@end

NS_ASSUME_NONNULL_END
