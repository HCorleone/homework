//
//  CollectionHeaderView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/7.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SearchMenuHeaderView.h"

@implementation SearchMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = whitecolor;
        _headerTitle = [[UILabel alloc] init];
        [_headerTitle setTextColor:[UIColor colorWithHexString:@"#2E3033"]];
        _headerTitle.font = [UIFont systemFontOfSize:14];
        [self addSubview:_headerTitle];
        [_headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.bottom.mas_equalTo(self).offset(-1);
        }];
    }
    return self;
}

@end
