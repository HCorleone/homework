//
//  CollectionHeaderView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = whitecolor;
        _headerTitle = [[UILabel alloc] init];
        [_headerTitle setTextColor:[UIColor colorWithHexString:@"#C4C8CC"]];
        _headerTitle.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:14];
        [self addSubview:_headerTitle];
        [_headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}

@end
