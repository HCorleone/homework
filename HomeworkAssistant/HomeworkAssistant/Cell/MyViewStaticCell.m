//
//  MyViewStaticCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/12.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MyViewStaticCell.h"

@implementation MyViewStaticCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    //1.从缓存中取
    MyViewStaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyViewStaticCell"];
    //2.创建
    if (cell == nil) {
        cell = [[MyViewStaticCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyViewStaticCell"];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor whiteColor];
        bgColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgColorView;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图标
        self.icon = [[UIImageView alloc]init];
        [self addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(5);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        //标题
        self.title = [[UILabel alloc]init];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).with.offset(20);
            make.centerY.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        self.title.font = [UIFont systemFontOfSize:16];
    }
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
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
