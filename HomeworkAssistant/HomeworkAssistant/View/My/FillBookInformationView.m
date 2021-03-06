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
            _nameLabel.frame = CGRectMake(screenWidth * 0.084, screenHeight * 0.155 + screenHeight * 0.077 * i, 50, 14);
        }
        
        //背景图
        UIView *bgc = [[UIView alloc] init];
        bgc.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [self addSubview:bgc];
        [bgc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight * 0.138);
            make.right.mas_equalTo(-screenWidth * 0.084);
            make.width.mas_equalTo(screenWidth * 0.693);
            make.height.mas_equalTo(37);
        }];
        
        //输入书籍
        _inputField = [UITextField textFieldWithSuperView:self Placehold:@"请输入书籍名称" PlaceholdColor:UIColorFromRGB(0x8F9394)];
        _inputField.font = [UIFont systemFontOfSize:14];
        [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight * 0.138);
            make.right.mas_equalTo(-screenWidth * 0.084);
            make.width.mas_equalTo(screenWidth * 0.666);
            make.height.mas_equalTo(37);
        }];
        
                    /*----------三个按钮--- start-----------*/
        _chooseBtn1 = [UIButton buttonWithText:@"请选择年级" TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1001 Target:self Action:@selector(clickBtn:)];
        _chooseBtn1.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [_chooseBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight * 0.214);
            make.right.mas_equalTo(-screenWidth * 0.084);
            make.width.mas_equalTo(screenWidth * 0.693);
            make.height.mas_equalTo(37);
        }];
        
        _chooseBtn2 = [UIButton buttonWithText:@"请选择学科" TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1002 Target:self Action:@selector(clickBtn:)];
        _chooseBtn2.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [_chooseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight * 0.291);
            make.right.mas_equalTo(-screenWidth * 0.084);
            make.width.mas_equalTo(screenWidth * 0.693);
            make.height.mas_equalTo(37);
        }];
        
        _chooseBtn3 = [UIButton buttonWithText:@"请选择版本" TextColor:UIColorFromRGB(0x8F9394) TextSize:14 SuperView:self Tag:1003 Target:self Action:@selector(clickBtn:)];
        _chooseBtn3.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [_chooseBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight * 0.367);
            make.right.mas_equalTo(-screenWidth * 0.084);
            make.width.mas_equalTo(screenWidth * 0.693);
            make.height.mas_equalTo(37);
        }];
        /*----------三个按钮--- end-----------*/
        
        _downImgView = [UIImageView imageViewWithName:@"下拉" SuperView:self.chooseBtn1];
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.chooseBtn1.mas_centerY);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        _downImgView = [UIImageView imageViewWithName:@"下拉" SuperView:self.chooseBtn2];
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.chooseBtn2.mas_centerY);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        _downImgView = [UIImageView imageViewWithName:@"下拉" SuperView:self.chooseBtn3];
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.chooseBtn3.mas_centerY);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        
        //条码背景
        UIView *bgc2 = [[UIView alloc] init];
        bgc2.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
        [self addSubview:bgc2];
        [bgc2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(screenHeight * 0.443);
            make.right.mas_equalTo(-screenWidth * 0.084);
            make.width.mas_equalTo(screenWidth * 0.693);
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
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 0.40 * screenWidth, 0.40 * screenWidth * 0.24);
        [gradientLayer setColors:[NSArray arrayWithObjects:
                                  (id)[UIColor colorWithHexString:@"#3DE5FF"].CGColor,
                                  (id)[UIColor colorWithHexString:@"#3FBCF4"].CGColor,
                                  nil
                                  ]];
        
        
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = @[@0,@1];
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn.layer addSublayer:gradientLayer];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 0.40 * screenWidth * 0.24/2;
        _nextBtn.tag = 1004;
        [_nextBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-screenHeight * 0.157);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(0.40 * screenWidth, 0.40 * screenWidth * 0.24));
        }];
        [_nextBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)clickBtn:(UIButton *)btn{
  
    if (_clickBlock) {
        _clickBlock(btn);
    }
}



@end
