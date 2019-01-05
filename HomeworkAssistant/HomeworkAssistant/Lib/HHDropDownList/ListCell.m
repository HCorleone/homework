//
//  ListCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/4.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.centerLabel = [[UILabel alloc] init];
        self.centerLabel.textColor = [UIColor colorWithHexString:@"#8F9394"];
        self.centerLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.centerLabel];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
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
