//
//  EditorNameView.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/7.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "EditorNameView.h"

@implementation EditorNameView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self showEditorView];
    }
    return self;
}

- (void)showEditorView {
    //白色框
    UIView *whiteView = [[UIView alloc]init];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 5;
    whiteView.backgroundColor = whitecolor;
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(screenHeight * 0.185);
        make.size.mas_equalTo(CGSizeMake(screenWidth * 0.797, 257));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    //信息名
    NSArray *nameArr = @[@"昵称:", @"年级:", @"地区:"];
    for (int i = 0 ; i < 3; i++) {
        _nameLabel = [UILabel labelWithContent:nameArr[i] SuperView:self TextColor:UIColorFromRGB(0x8F9394) Font:[UIFont systemFontOfSize:16.0] TextAlignment:NSTextAlignmentLeft NumberOfLines:1];
        _nameLabel.frame = CGRectMake(screenWidth * 0.18, screenHeight * 0.256 + screenHeight * 0.093 * i, screenWidth * 0.128, 16);
    }
    
    //输入昵称
    _nameField = [UITextField textFieldWithSuperView:self Placehold:@"" PlaceholdColor:UIColorFromRGB(0x353B3C)];
    _nameField.textAlignment = NSTextAlignmentCenter;
    _nameField.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1/1.0];
    _nameField.font = [UIFont systemFontOfSize:16.0];
    _nameField.frame = CGRectMake(screenWidth * 0.308, screenHeight * 0.245, screenWidth * 0.513, 30);
    
    //年级
    _downBtn = [UIButton buttonWithText:@"请选择年级" TextColor:UIColorFromRGB(0x8F9394) TextSize:16 SuperView:self Tag:1001 Target:self Action:@selector(clickBtn:)];
    _downBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _downBtn.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
    _downBtn.frame = CGRectMake(screenWidth * 0.308, screenHeight * 0.339, screenWidth * 0.513, 30);
    
    //地区
    _cityBtn = [UIButton buttonWithText:@"请选择城市" TextColor:UIColorFromRGB(0x8F9394) TextSize:16 SuperView:self Tag:1002 Target:self Action:@selector(clickBtn:)];
    _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _cityBtn.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02999999932944775/1.0];
    _cityBtn.frame = CGRectMake(screenWidth * 0.308, screenHeight * 0.433, screenWidth * 0.513, 30);
    
    //确认
    _okBtn = [UIButton buttonWithText:@"确认" TextColor:UIColorFromRGB(0x0BA7D4) TextSize:16 SuperView:whiteView Tag:1003 Target:self Action:@selector(clickBtn:)];
    _okBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-9);
        make.right.mas_equalTo(-29);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(16);
    }];
    //取消
    _noBtn = [UIButton buttonWithText:@"取消" TextColor:UIColorFromRGB(0x8F9394) TextSize:16 SuperView:whiteView Tag:1004 Target:self Action:@selector(clickBtn:)];
    _noBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-9);
        make.right.mas_equalTo(-120);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(16);
    }];
    

}

-(void)clickBtn:(UIButton *)btn
{
    if (_clickBlock) {
        _clickBlock(btn);
    }
}

@end
