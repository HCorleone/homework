//
//  FillOthersView.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/10.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "FillOthersView.h"

@implementation FillOthersView

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        _titleLabel = [UILabel labelWithContent:@"选择年级" SuperView:self TextColor:[UIColor colorWithHexString:@"#FFA033"] Font:[UIFont systemFontOfSize:14.0] TextAlignment:NSTextAlignmentCenter NumberOfLines:1];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(12);
        }];
        
        _titleLabel = [UILabel labelWithContent:@"选择地区" SuperView:self TextColor:[UIColor colorWithHexString:@"#FFA033"] Font:[UIFont systemFontOfSize:14.0] TextAlignment:NSTextAlignmentCenter NumberOfLines:1];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(440);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(12);
        }];
    
        //地区按钮
        _areaBtn = [UIButton buttonWithText:@"请选择地区" TextColor:UIColorFromRGB(0x8F9394) TextSize:16 SuperView:self Tag:1001 Target:self Action:@selector(clickBtn:)];
        _areaBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1/1.0];
        [_areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(500);
            make.right.mas_equalTo(-31.5);
            make.height.mas_equalTo(37);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.693);
        }];
        
        //地区
        _areaLabel = [UILabel labelWithContent:@"地区:" SuperView:self TextColor:UIColorFromRGB(0x353B3C) Font:[UIFont systemFontOfSize:14.0] TextAlignment:NSTextAlignmentLeft NumberOfLines:1];
        [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.areaBtn.mas_centerY);
            make.right.mas_equalTo(self.areaBtn.mas_left).offset(-20);
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(14);
        }];
        
        
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_okBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _okBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _okBtn.backgroundColor = [UIColor colorWithHexString:@"#FFA033"];
        _okBtn.layer.masksToBounds = YES;
        _okBtn.layer.cornerRadius = 15;
        _okBtn.tag = 1002;
        [_okBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okBtn];
        [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.areaBtn.mas_bottom).offset(70);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(239);
            make.height.mas_equalTo(38);
        }];
        
    }
    return self;
}

-(void)clickBtn:(UIButton *)btn {
    
    if (_block) {
        _block(btn);
    }
}

@end
