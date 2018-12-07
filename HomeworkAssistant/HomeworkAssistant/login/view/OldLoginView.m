//
//  LoginView.m
//  sw-reader
//
//  Created by mac on 16/7/14.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "OldLoginView.h"
#import "XUtil.h"
#define TYPELABELFONT [UIFont systemFontOfSize:15.0]

@implementation OldLoginView
- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundImage:[XUtil createImageWithColor:[XUtil hexToRGB:@"E6E6E6"]] forState:UIControlStateHighlighted];
        //边框
//        self.layer.cornerRadius = 24;
        self.layer.borderColor = [[XUtil hexToRGB:@"E6E6E6"] CGColor ];
//        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        
        //添加图标

        UIImageView *iconImgView = [UIImageView new];
        [self addSubview:iconImgView];
        self.iconImgView = iconImgView;
        
        //添加文字
        UILabel *typeLabel = [UILabel new];
        [typeLabel setTextColor: [XUtil hexToRGB:@"666666"]];
        typeLabel.font = TYPELABELFONT;
        typeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:typeLabel];
        self.typeLabel = typeLabel;
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    CGSize textSize = [XUtil sizeWithString:@"QQ登录" font:TYPELABELFONT maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Height * 48 / 1136, Main_Screen_Height * 48 / 1136));
        make.left.equalTo(self).with.offset(Main_Screen_Width/2 - Main_Screen_Width * 24 / 640 - textSize.width/2);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).with.offset(Main_Screen_Width * 16 / 640);
        make.right.equalTo(self).with.offset(-10);
        make.height.equalTo(@(textSize.height));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [super updateConstraints];
}

@end
