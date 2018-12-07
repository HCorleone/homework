//
//  MineTopView.m
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "MineTopView.h"
#import "YDUserManager.h"

#define kMineViewUserNameFont font14
#define kLoginBtnFont font12

@interface MineTopView ()
@end

@implementation MineTopView
- (instancetype)init {
    if (self = [super init]) {
        //设置view
        UIView *setView = [[UIView alloc] init];
        [self addSubview:setView];
        self.setView = setView;
        
        //设置图片
        UIImageView *setPicView = [[UIImageView alloc] init];
        [setPicView setImage:[UIImage imageNamed:@"moreicon"]];
        [self addSubview:setPicView];
        self.setPicView = setPicView;
        
        //头像
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.layer.cornerRadius = 44*Main_Screen_Width/640;
        iconImgView.clipsToBounds = YES;
//        iconImgView.layer.borderWidth = 2.0;
//        iconImgView.layer.borderColor = [[XUtil hexToRGB:@"EBEBEB"] CGColor];
        iconImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:iconImgView];
        self.iconImgView = iconImgView;
        
        
        UILabel *userNameLabel = [UILabel new];
        userNameLabel.textColor = [XUtil hexToRGB:@"333333"];
        userNameLabel.numberOfLines = 1;
        
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.font = kMineViewUserNameFont;
        [self addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
//    //设置view布局
//    [self.setView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kTopBarHeight, kTopBarHeight));
//        make.right.equalTo(self).with.offset(-10*Main_Screen_Width/640);
//        make.centerY.mas_equalTo(self.setView.mas_centerY);
//    }];
    
    //头像布局
    CGFloat iconImgViewW = 88*Main_Screen_Width/640;
    CGFloat iconImgViewH = 88*Main_Screen_Width/640;
    CGFloat iconImgMarginY = 64 * Main_Screen_Height / 1136;
    CGFloat iconImgMarginx = Main_Screen_Width * 30 / 640;
    
//    if (isiPhone4) {
//        iconImgMarginY = 44 * Main_Screen_Height / 1136;
//    }
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(iconImgMarginx);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(iconImgViewW, iconImgViewH));
    }];
    
    //设置图片布局
    [self.setPicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36*Main_Screen_Width/640, 36*Main_Screen_Width/640));
        make.right.equalTo(self).offset(-iconImgMarginx);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    
    //用户名和登录按钮布局
    
    NSString *titleName = @"你还未登陆呢";
    CGSize titleNameSize = [XUtil sizeWithString:titleName font:kMineViewUserNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat marginY = 18 * Main_Screen_Height / 1136;
    if (isiPhone4) {
        marginY = 12 * Main_Screen_Height / 1136;
    }
    [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleNameSize.height);
        make.left.equalTo(self.iconImgView.mas_right).with.offset(Main_Screen_Width * 22 / 640);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [super updateConstraints];
}

@end
