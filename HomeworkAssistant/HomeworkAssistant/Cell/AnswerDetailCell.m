//
//  AnswerCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/27.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "AnswerDetailCell.h"
#import "UIImageView+WebCache.h"

@interface AnswerDetailCell()


@end

@implementation AnswerDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.topImage = [[UIImageView alloc]init];
//        [self addSubview:self.topImage];
//        [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.and.top.and.bottom.mas_equalTo(self);
//        }];
//        _imgScrollView = [[ImgScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, H) andImageViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, H)];
        _imgScrollView = [[ImgScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andImageViewFrame:CGRectZero];
        [self addSubview:_imgScrollView];
    }
    return self;
}

- (void)setModel:(AnswerDetail *)model {
    _model = model;
    __weak typeof(self) weakSelf = self;
    [_imgScrollView.imgView sd_setImageWithURL:[NSURL URLWithString:model.detailAnswerURL] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
        
        weakSelf.imgScrollView.imgView.frame = [weakSelf getSmallFrameWith:image.size];
    }];
}

- (void)setDetailPath:(NSString *)detailPath {
    _detailPath = detailPath;
    __weak typeof(self) weakSelf = self;
    [_imgScrollView.imgView sd_setImageWithURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:detailPath]] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
        
        weakSelf.imgScrollView.imgView.frame = [weakSelf getSmallFrameWith:image.size];
    }];
}

//得到处理过的imageSize
- (CGRect)getSmallFrameWith:(CGSize)imgSize {
    CGFloat width = SCREEN_WIDTH / imgSize.width;
    CGFloat height = SCREEN_HEIGHT / imgSize.height;
    CGFloat x = 0;
    CGFloat y = 0;
    //按照宽度算
    if (width < height) {
        imgSize.height = SCREEN_WIDTH / imgSize.width * imgSize.height;
        imgSize.width = SCREEN_WIDTH;
        x = 0;
        y = (SCREEN_HEIGHT - imgSize.height) / 2;
    }else{
        imgSize.width = SCREEN_HEIGHT / imgSize.height * imgSize.width;
        imgSize.height = SCREEN_HEIGHT;
        x = (SCREEN_WIDTH - imgSize.width) / 2;
        y = 0;
    }
    CGRect smallFrame = CGRectMake(x, y, imgSize.width, imgSize.height);
    return smallFrame;
}

@end
