//
//  QRCodeView.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/6.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeView : UIView

- (void)showQRCode;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *whiteView;

@end

NS_ASSUME_NONNULL_END
