//
//  MineTopView.h
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewLinkmanTouch.h"
@interface MineTopView : UIViewLinkmanTouch
@property (nonatomic, weak) UIImageView *iconImgView; //用户头像
@property (nonatomic, weak) UILabel *userNameLabel; //用户名称
@property (nonatomic, weak) UIView *setView; //设置按钮
@property (nonatomic, weak) UIImageView *setPicView; //设置图片
@end
