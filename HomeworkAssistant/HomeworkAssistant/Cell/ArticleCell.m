//
//  ArticleCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ArticleCell.h"

@interface ArticleCell()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subContent;
@property (nonatomic, strong) UILabel *grade;
@property (nonatomic, strong) UILabel *articleType;
@property (nonatomic, strong) UILabel *wordsNum;

@end

@implementation ArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:@"ArticleCell"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        //作文标题
        self.title = [[UILabel alloc] init];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.top.mas_equalTo(self).offset(16);
        }];
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.textColor = [UIColor colorWithHexString:@"#2E3033"];
        
        //作文内容简要
        self.subContent = [[UILabel alloc] init];
        [self addSubview:self.subContent];
        [self.subContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(self).offset(46);
        }];
        self.subContent.font = [UIFont systemFontOfSize:14];
        self.subContent.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
        self.subContent.numberOfLines = 3;
        
        //年级
        self.grade = [[UILabel alloc] init];
        [self addSubview:self.grade];
        self.grade.font = [UIFont systemFontOfSize:9];
        self.grade.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
        self.grade.layer.cornerRadius = 2;
        self.grade.layer.borderWidth = 0.5;
        self.grade.layer.borderColor = [UIColor colorWithHexString:@"#C6C7CC"].CGColor;
        [self.grade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.bottom.mas_equalTo(self).offset(-16);
        }];
        //作文类型
        self.articleType = [[UILabel alloc] init];
        [self addSubview:self.articleType];
        self.articleType.font = [UIFont systemFontOfSize:9];
        self.articleType.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
        self.articleType.layer.cornerRadius = 2;
        self.articleType.layer.borderWidth = 0.5;
        self.articleType.layer.borderColor = [UIColor colorWithHexString:@"#C6C7CC"].CGColor;
        [self.articleType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.grade.mas_right).offset(10);
            make.bottom.mas_equalTo(self).offset(-16);
        }];
        //字数
        self.wordsNum = [[UILabel alloc] init];
        [self addSubview:self.wordsNum];
        self.wordsNum.font = [UIFont systemFontOfSize:9];
        self.wordsNum.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
        self.wordsNum.layer.cornerRadius = 2;
        self.wordsNum.layer.borderWidth = 0.5;
        self.wordsNum.layer.borderColor = [UIColor colorWithHexString:@"#C6C7CC"].CGColor;
        [self.wordsNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.articleType.mas_right).offset(10);
            make.bottom.mas_equalTo(self).offset(-16);
        }];
    }
    return self;
    
}

- (void)setModel:(Article *)model {
    _model = model;
    
    self.title.text = model.title;
    self.subContent.text = model.subContent;
    self.grade.text = model.grade;
    self.articleType.text = model.articleType;
    self.wordsNum.text = model.wordsNum;
    
}

@end
