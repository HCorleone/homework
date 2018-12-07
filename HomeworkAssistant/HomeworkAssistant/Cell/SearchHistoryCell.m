//
//  SearchHistoryCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/4.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell()

@end


@implementation SearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:@"SearchHistoryCell"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        self.historyWords = [[UILabel alloc]init];
        self.historyWords.textColor = [UIColor colorWithHexString:@"#909499"];
        self.historyWords.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self addSubview:self.historyWords];
        [self.historyWords mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 22.5));
        }];
    }
    return  self;
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
