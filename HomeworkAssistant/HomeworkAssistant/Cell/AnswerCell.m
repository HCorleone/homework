//
//  AnswerCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/27.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerCell.h"
#import "UIImageView+WebCache.h"

@interface AnswerCell()

@property (nonatomic, strong) UIImageView *topImage;

@end

#define H screenHeight - 48 - 72 - BOT_OFFSET

@implementation AnswerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.topImage = [[UIImageView alloc]init];
//        [self addSubview:self.topImage];
//        [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.and.top.and.bottom.mas_equalTo(self);
//        }];
        _imgScrollView = [[ImgScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, H) andImageViewFrame:CGRectMake(0, 0, screenWidth, H)];
        _imgScrollView.imgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imgScrollView];
    }
    return self;
}

- (void)setModel:(AnswerDetail *)model {
    _model = model;
    [_imgScrollView.imgView sd_setImageWithURL:[NSURL URLWithString:model.detailAnswerURL]];
}


@end
