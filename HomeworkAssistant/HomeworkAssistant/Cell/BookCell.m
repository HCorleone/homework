//
//  RecommendStaticCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "BookCell.h"
#import "UIImageView+WebCache.h"

@interface BookCell()

@property (nonatomic, strong) UIImageView *bookCover;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subject;
@property (nonatomic, strong) UILabel *bookVersion;
@property (nonatomic, strong) UILabel *uploaderName;
@property (nonatomic, strong) UILabel *grade;

@property (nonatomic, strong) NSString *bookID;


@end

@implementation BookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        
        self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveBtn.layer.borderWidth = 0.5;
        self.saveBtn.layer.cornerRadius = 3;
        self.saveBtn.layer.borderColor = [UIColor colorWithHexString:@"#FA8919"].CGColor;
        self.saveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        [self.saveBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.contentView addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-20);
            make.bottom.mas_equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 17));
        }];
        [self.saveBtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        self.bookCover = [[UIImageView alloc]init];
        self.bookCover.layer.masksToBounds = YES;
        self.bookCover.layer.cornerRadius = 4;
        self.bookCover.contentMode = UIViewContentModeScaleAspectFit;
        self.bookCover.frame = CGRectMake(20, 8, 84, 112);
        [self.contentView addSubview:self.bookCover];
        
//        [self.bookCover mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self);
//            make.left.mas_equalTo(self).offset(20);
//            make.size.mas_equalTo(CGSizeMake(84, 112));
//        }];
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.title.numberOfLines = 2;
//        self.title.lineBreakMode = UILineBreakModeWordWrap;
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.mas_equalTo(self.bookCover.mas_right).with.offset(15);
            make.right.mas_equalTo(self).offset(-25);
//            make.height.mas_equalTo(34);
        }];
        
        self.subject = [[UILabel alloc]init];
        self.subject.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.subject.textColor = [UIColor colorWithHexString:@"#909499"];
        [self.contentView addSubview:self.subject];
        [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).with.offset(10);
//            make.top.mas_equalTo(self).offset(30);
            make.left.mas_equalTo(self.bookCover.mas_right).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 16.5));
        }];
        
        self.bookVersion = [[UILabel alloc]init];
        self.bookVersion.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.bookVersion.textColor = [UIColor colorWithHexString:@"#909499"];
        [self.contentView addSubview:self.bookVersion];
        [self.bookVersion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.subject);
            make.left.mas_equalTo(self.subject.mas_right).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 16.5));
        }];
        
        self.grade = [[UILabel alloc]init];
        self.grade.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.grade.textColor = [UIColor colorWithHexString:@"#909499"];
        [self.contentView addSubview:self.grade];
        [self.grade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.subject);
            make.left.mas_equalTo(self.bookVersion.mas_right).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 16.5));
        }];
        
        self.uploaderName = [[UILabel alloc]init];
        self.uploaderName.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        self.uploaderName.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
        [self.contentView addSubview:self.uploaderName];
        [self.uploaderName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-20);
            make.left.mas_equalTo(self.bookCover.mas_right).with.offset(15);
        }];
    }
    
    return self;
    
}


- (void)setModel:(Book *)model {
    _model = model;
    
    [self.bookCover sd_setImageWithURL:[NSURL URLWithString:model.coverURL]];
    self.title.text = model.title;
    self.subject.text = model.subject;
    self.bookVersion.text = model.bookVersion;
    self.grade.text = model.grade;
    self.uploaderName.text = model.uploaderName;
    self.bookID = model.answerID;
    
}

- (void)test:(UIButton *)btn {
    if (btn.isSelected) {
        [self userDisLike];
        self.saveBtn.layer.borderColor = [UIColor colorWithHexString:@"#FA8919"].CGColor;
        [self.saveBtn setTitleColor:[UIColor colorWithHexString:@"#FA8919"] forState:UIControlStateNormal];
        btn.selected = !btn.isSelected;
    }
    else {
        if ([TTUserManager sharedInstance].isLogin) {
            [self userLike];
            self.saveBtn.layer.borderColor = [UIColor colorWithHexString:@"#C4C8CC"].CGColor;
            [self.saveBtn setTitleColor:[UIColor colorWithHexString:@"#C4C8CC"] forState:UIControlStateNormal];
            btn.selected = !btn.isSelected;
        }
        else {
            [XWHUDManager showTipHUD:@"请先登录"];
        }
    }
}

//用户取消收藏
- (void)userDisLike {
    
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"answerIDs":self.bookID,
                           @"sourceType":@"rec"
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForDelUserLike] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            
            NSLog(@"取消收藏");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userLikeOrNot" object:nil];
        }
        
    } failure:nil];
    [dataTask resume];

}

//用户点击收藏按钮
- (void)userLike {
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSDictionary *dict = @{
                           @"openID":openId,
                           @"answerID":self.bookID,
                           @"sourceType":@"rec",
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForUserLike] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            [XWHUDManager showSuccessTipHUDInView:@"收藏成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userLikeOrNot" object:nil];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
}

@end
