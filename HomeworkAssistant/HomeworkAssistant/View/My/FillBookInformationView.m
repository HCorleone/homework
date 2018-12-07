//
//  FillBookInformationView.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/5.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "FillBookInformationView.h"
#import "NIDropDown.h"

@implementation FillBookInformationView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *nameArr = @[@"书名 :", @"年级 :", @"学科 :", @"版本 :", @"条码 :"];
        for (int i = 0; i < 5; i ++) {
            _nameLabel = [UILabel labelWithContent:nameArr[i] SuperView:self TextColor:UIColorFromRGB(0x353B3C) Font:[UIFont systemFontOfSize:14] TextAlignment:NSTextAlignmentLeft NumberOfLines:1];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(31.5 + 51 * i);
                make.left.mas_equalTo(50);
                make.width.mas_equalTo(42);
                make.height.mas_equalTo(14);
            }];
        }
        
        //背景图
        UIView *bgc = [[UIView alloc] init];
        bgc.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [self addSubview:bgc];
        [bgc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-31.5);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(37);
        }];
        
        //输入书籍
        _inputField = [UITextField textFieldWithSuperView:self Placehold:@"请输入书籍名称" PlaceholdColor:UIColorFromRGB(0x8F9394)];
        _inputField.font = [UIFont systemFontOfSize:14];
        [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-31.5);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(37);
        }];
        
        /*
        NSArray *btnArr = @[@"请选择年级", @"请选择学科", @"请选择版本"];

        for (int i = 0; i < 3; i++) {

            UIButton *chooseBtn = [UIButton buttonWithText:btnArr[i] TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1001 + i Target:self Action:@selector(clickBtn:)];
            chooseBtn.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
            [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(71 + 51 * i);
                make.right.mas_equalTo(-31.5);
                make.width.mas_equalTo(260);
                make.height.mas_equalTo(37);
            }];
            _chooseBtn = chooseBtn;
        }
       */
        
                    /*----------三个按钮--- start-----------*/
        _chooseBtn1 = [UIButton buttonWithText:@"请选择年级" TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1001 Target:self Action:@selector(clickBtn:)];
        _chooseBtn1.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [_chooseBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(71 + 51 * 0);
            make.right.mas_equalTo(-31.5);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(37);
        }];
        
        _chooseBtn2 = [UIButton buttonWithText:@"请选择学科" TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1002 Target:self Action:@selector(clickBtn:)];
        _chooseBtn2.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [_chooseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(71 + 51 * 1);
            make.right.mas_equalTo(-31.5);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(37);
        }];
        
        _chooseBtn3 = [UIButton buttonWithText:@"请选择版本" TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1003 Target:self Action:@selector(clickBtn:)];
        _chooseBtn3.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [_chooseBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(71 + 51 * 2);
            make.right.mas_equalTo(-31.5);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(37);
        }];
        /*----------三个按钮--- end-----------*/
        
        //条码背景
        UIView *bgc2 = [[UIView alloc] init];
        bgc2.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [self addSubview:bgc2];
        [bgc2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(71 + 51 * 3);
            make.right.mas_equalTo(-31.5);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(37);
        }];
        //条码
        if ([userValue(@"InputBarCode") isEqualToString:@"请输入书籍条形码"]) {
            userDefaults(@"", @"InputBarCode");
        }
        _codeLabel = [UILabel labelWithContent:userValue(@"InputBarCode") SuperView:bgc2 TextColor:UIColorFromRGB(0x8F9394) Font:[UIFont systemFontOfSize:14] TextAlignment:NSTextAlignmentLeft NumberOfLines:1];
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgc2.mas_centerY);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(14);
        }];
        
        //下一步按钮
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _nextBtn.backgroundColor = UIColorFromRGB(0x3FBCF4);
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 15;
        _nextBtn.tag = 1004;
        [_nextBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-200);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(152);
            make.height.mas_equalTo(35);
        }];
    }
    return self;
}

-(void)clickBtn:(UIButton *)btn{
  
    if (_clickBlock) {
        _clickBlock(btn);
    }
}



@end
