//
//  AnswerDetailCollectionViewCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerDetailCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface AnswerDetailCollectionViewCell()

@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UILabel *botLabel;
@property (nonatomic, strong) NSString *idx;//当前页数

@end

@implementation AnswerDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 120)];
        [self addSubview:self.topImage];
        
        self.botLabel = [[UILabel alloc]init];
        [self addSubview:self.botLabel];
//        self.botLabel.text = [self.idx stringByAppendingString:@"/"];
        self.botLabel.textColor = [UIColor colorWithHexString:@"#353B3C"];
        self.botLabel.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:12];
        [self.botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.topImage.mas_bottom).with.offset(6);
            make.height.mas_equalTo(15);
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
