//
//  RecommendStaticCell.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "RecommendStaticCell.h"
#import "UIImageView+WebCache.h"

@interface RecommendStaticCell()

@property (nonatomic, strong) UIImageView *bookCover;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subject;
@property (nonatomic, strong) UILabel *bookVersion;
@property (nonatomic, strong) UILabel *uploaderName;
@property (nonatomic, strong) UILabel *grade;

@property (nonatomic, strong) NSString *bookID;


@end

@implementation RecommendStaticCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:@"RecommendStaticCell"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        
        self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveBtn.layer.borderWidth = 0.5;
        self.saveBtn.layer.cornerRadius = 2;
        self.saveBtn.layer.borderColor = maincolor.CGColor;
        self.saveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        [self.saveBtn setTitle:@"收藏" forState:UIControlStateNormal];
        
        
        [self addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-20);
            make.bottom.mas_equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 17));
        }];
        [self.saveBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
        self.isSelected = NO;
        
        self.bookCover = [[UIImageView alloc]init];
        self.bookCover.layer.masksToBounds = YES;
        self.bookCover.layer.cornerRadius = 4;
        self.bookCover.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.bookCover];
        [self.bookCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(84, 112));
        }];
        
        self.title = [[UILabel alloc]init];
        self.title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.title.numberOfLines = 2;
//        self.title.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.left.mas_equalTo(self.bookCover.mas_right).with.offset(15);
            make.right.mas_equalTo(self).offset(-25);
//            make.height.mas_equalTo(34);
        }];
        
        self.subject = [[UILabel alloc]init];
        self.subject.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.subject.textColor = [UIColor colorWithHexString:@"#909499"];
        [self addSubview:self.subject];
        [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).with.offset(10);
//            make.top.mas_equalTo(self).offset(30);
            make.left.mas_equalTo(self.bookCover.mas_right).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 16.5));
        }];
        
        self.bookVersion = [[UILabel alloc]init];
        self.bookVersion.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.bookVersion.textColor = [UIColor colorWithHexString:@"#909499"];
        [self addSubview:self.bookVersion];
        [self.bookVersion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.subject);
            make.left.mas_equalTo(self.subject.mas_right).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 16.5));
        }];
        
        self.grade = [[UILabel alloc]init];
        self.grade.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.grade.textColor = [UIColor colorWithHexString:@"#909499"];
        [self addSubview:self.grade];
        [self.grade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.subject);
            make.left.mas_equalTo(self.bookVersion.mas_right).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 16.5));
        }];
        
        self.uploaderName = [[UILabel alloc]init];
        self.uploaderName.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        self.uploaderName.textColor = [UIColor colorWithHexString:@"#C4C8CC"];
        [self addSubview:self.uploaderName];
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



- (void)test {
    if (self.isSelected) {
        [self userDisLike];
        [self.saveBtn setBackgroundColor:whitecolor];
        [self.saveBtn setTitleColor:maincolor forState:UIControlStateNormal];
        self.isSelected = NO;
        
    }
    else {
        if ([TTUserManager sharedInstance].isLogin) {
            [self userLike];
            [self.saveBtn setBackgroundColor:maincolor];
            [self.saveBtn setTitleColor:whitecolor forState:UIControlStateNormal];
            self.isSelected = YES;
            
        }
        else {
//            NSLog(@"请先登录");
            [CommonAlterView showAlertView:@"请先登录"];
        }
    }
}

//用户取消收藏
- (void)userDisLike {
    
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    
    NSString *URL = zuoyeURL;
    NSDictionary *dict = @{
                           @"h":@"ZYDelUserLikeHandler",
                           @"openID":openId,
                           @"answerIDs":self.bookID,
                           @"pkn":@"com.enjoytime.palmhomework",
                           @"sourceType":@"rec",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
                           @"h":@"ZYUserLikeHandler",
                           @"openID":openId,
                           @"answerID":self.bookID,
                           @"pkn":@"com.enjoytime.palmhomework",
                           @"sourceType":@"rec",
                           @"av":@"_debug_"
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSURLSessionDataTask *dataTask = [manager GET:zuoyeURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]integerValue] == 200) {
            
            NSLog(@"收藏成功");
            [CommonAlterView showAlertView:@"收藏成功"];
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

    // Configure the view for the selected state
}

@end
