//
//  SubmitCollectionViewCell.m
//  党建
//
//  Created by 邱敏 on 2018/11/4.
//  Copyright © 2018年 wx. All rights reserved.
//

#import "SubmitCollectionViewCell.h"

@implementation SubmitCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _imgView = [UIImageView imageViewWithName:@"" SuperView:self];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

@end
