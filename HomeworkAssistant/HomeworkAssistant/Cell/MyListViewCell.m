//
//  MyListViewCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/30.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MyListViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyListViewCell()



@end

@implementation MyListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topImage = [[UIImageView alloc]init];
        [self addSubview:self.topImage];
        [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(self);
            make.height.mas_equalTo(112);
        }];
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.title.textColor = [UIColor colorWithHexString:@"#909499"];
        self.title.numberOfLines = 0;
        self.title.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topImage.mas_bottom).with.offset(0);
            make.left.and.right.and.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setModel:(Book *)model {
    _model = model;
    
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.coverURL]];
    self.title.text = model.title;
    
}

@end
