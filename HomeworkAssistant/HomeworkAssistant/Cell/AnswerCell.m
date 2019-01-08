//
//  AnswerDetailCollectionViewCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerCell.h"
#import "UIImageView+WebCache.h"

@interface AnswerCell()

@end

@implementation AnswerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.24 * SCREEN_WIDTH, 0.24 * SCREEN_WIDTH * 1.3)];
        [self addSubview:self.topImage];
        
        self.botLabel = [[UILabel alloc]init];
        [self addSubview:self.botLabel];
//        self.botLabel.text = [self.idx stringByAppendingString:@"/"];
        self.botLabel.textColor = [UIColor colorWithHexString:@"#353B3C"];
        self.botLabel.font = [UIFont systemFontOfSize:12];
        [self.botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.topImage.mas_bottom).with.offset(6);
        }];
        
    }
    return self;
}

- (void)setModel:(AnswerDetail *)model {
    _model = model;
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.thumbsAnswerURL]];
    self.botLabel.text = [[model.idx1 stringByAppendingString:@"/"] stringByAppendingString:model.answerCount];
}

@end
