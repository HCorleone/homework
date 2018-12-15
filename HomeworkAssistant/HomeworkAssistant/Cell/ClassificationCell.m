//
//  ClassificationCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ClassificationCell.h"

@implementation ClassificationCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColorFromRGB(0xD5D5D5).CGColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        
        _title = [[UILabel alloc]init];
        [self addSubview:_title];
        _title.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:14];
        _title.textColor = UIColorFromRGB(0x353B3C);
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}


@end
