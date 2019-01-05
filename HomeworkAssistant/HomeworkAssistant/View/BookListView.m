//
//  BookListView.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/11.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "BookListView.h"

@implementation BookListView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _lingView = [[UIImageView alloc] init];
        _lingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self addSubview:_lingView];
        [_lingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCREEN_WIDTH * 0.106);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.725);
            make.height.mas_equalTo(1);
        }];
        
        _lingView = [[UIImageView alloc] init];
        _lingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self addSubview:_lingView];
        [_lingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-SCREEN_WIDTH * 0.194);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.725);
            make.height.mas_equalTo(1);
        }];
        
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 0.379 * SCREEN_WIDTH, 0.379 * 0.218 * SCREEN_WIDTH);
        [gradientLayer setColors:[NSArray arrayWithObjects:
                                  (id)[UIColor colorWithHexString:@"#FFC94C"].CGColor,
                                  (id)[UIColor colorWithHexString:@"#FF8800"].CGColor,
                                  nil
                                  ]];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = @[@0,@1];
        
        _insertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_insertBtn.layer addSublayer:gradientLayer];
        [_insertBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_insertBtn setTitle:@"导入书单" forState:UIControlStateNormal];
        _insertBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _insertBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _insertBtn.layer.masksToBounds = YES;
        _insertBtn.layer.cornerRadius = 15;
        _insertBtn.tag = 1004;
        [_insertBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_insertBtn];
        [_insertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-30);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(0.379 * SCREEN_WIDTH);
            make.height.mas_equalTo(0.379 * 0.218 * SCREEN_WIDTH);
        }];
        
        
        
    }
    return self;
}

-(void)clickBtn:(UIButton *)btn {
    
    if (_clickBlock) {
        _clickBlock(btn);
    }
}

@end
