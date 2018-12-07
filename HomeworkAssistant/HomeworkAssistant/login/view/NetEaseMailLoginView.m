//
//  NetEaseMailLoginView.m
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "NetEaseMailLoginView.h"

@implementation NetEaseMailLoginView

- (instancetype)init {
    if (self = [super init]) {
        //边框
        self.layer.cornerRadius = 24;
        self.layer.borderColor = [[XUtil hexToRGB:@"E6E6E6"] CGColor ];
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        
        //添加图标
        UIImageView *iconImgView = [UIImageView new];
        [self addSubview:iconImgView];
        self.iconImgView = iconImgView;
        
        //添加输入框
        UITextField *inputView = [UITextField new];
        [inputView setTextColor: [XUtil hexToRGB:@"808080"]];
        inputView.textAlignment = NSTextAlignmentLeft;
        inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:inputView];
        self.inputView = inputView;
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(self).with.offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).with.offset(8);
        make.right.equalTo(self).with.offset(-8);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [super updateConstraints];
}

@end
