//
//  EditInfoView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/14.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import "EditInfoView.h"
#import "HHDropDownList.h"
#import "AreaSelectViewController.h"

@interface EditInfoView()<HHDropDownListDelegate, HHDropDownListDataSource, HXAlbumListViewControllerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) NSString *name;//用户名
@property (nonatomic, strong) NSString *grade;//年级
@property (nonatomic, strong) NSString *city;//城市

@property (nonatomic, strong) UIButton *cityBtn;
//下拉列表
@property (nonatomic, strong) HHDropDownList *dropDownList_1;

@end

@implementation EditInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.name = [TTUserManager sharedInstance].currentUser.name;
        self.grade = [TTUserManager sharedInstance].currentUser.grade;
        self.city = [TTUserManager sharedInstance].currentUser.city;
        
        // 大背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:bgView];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.bgView = bgView;
        
        //白色框
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0.1 * SCREEN_WIDTH, 0.33 * SCREEN_WIDTH, 0.8 * SCREEN_WIDTH, 0.8 * SCREEN_WIDTH * 0.86)];
        whiteView.backgroundColor = whitecolor;
        whiteView.layer.cornerRadius = 4;
        [self addSubview:whiteView];
        self.whiteView = whiteView;
        
        //用户名Field
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(0.21 * SCREEN_WIDTH, 0.11 * SCREEN_WIDTH, 0.51 * SCREEN_WIDTH, 0.51 * SCREEN_WIDTH * 0.16)];
        [whiteView addSubview:nameField];
        nameField.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        nameField.font = [UIFont systemFontOfSize:14];
        nameField.textColor = [UIColor colorWithHexString:@"#8F9394"];
        nameField.textAlignment = NSTextAlignmentCenter;
        nameField.text = [TTUserManager sharedInstance].currentUser.name;
        nameField.userInteractionEnabled = NO;
//        self.titleField = titleField;
        
        //昵称label
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"昵称:";
        label1.font = [UIFont systemFontOfSize:16];
        label1.textColor = [UIColor colorWithHexString:@"#8F9394"];
        [whiteView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(whiteView).offset(0.079 * SCREEN_WIDTH);
            make.centerY.mas_equalTo(nameField);
        }];
        
        //年级下拉菜单
        self.dropDownList_1 = [[HHDropDownList alloc] initWithFrame:CGRectMake(0.308 * SCREEN_WIDTH, 0.6 * SCREEN_WIDTH, 0.51 * SCREEN_WIDTH, 0.51 * SCREEN_WIDTH * 0.16)];
        [self addSubview:self.dropDownList_1];
        [self.dropDownList_1 setBackgroundColor:[UIColor colorWithHexString:@"#F4F4F4"]];
        [self.dropDownList_1 setHighlightColor:maincolor];
        [self.dropDownList_1 setDelegate:self];
        [self.dropDownList_1 setDataSource:self];
        [self.dropDownList_1 setIsExclusive:YES];
        self.dropDownList_1.from = FromGrade;
        [self.dropDownList_1 reloadListData];
        
        //年级label
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"年级:";
        label2.font = [UIFont systemFontOfSize:16];
        label2.textColor = [UIColor colorWithHexString:@"#8F9394"];
        [whiteView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(whiteView).offset(0.079 * SCREEN_WIDTH);
            make.centerY.mas_equalTo(self.dropDownList_1);
        }];
        
        //地区选择按钮
        UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cityBtn.frame = CGRectMake(0.21 * SCREEN_WIDTH, 0.43 * SCREEN_WIDTH, 0.51 * SCREEN_WIDTH, 0.51 * SCREEN_WIDTH * 0.16);
        [whiteView addSubview:cityBtn];
        cityBtn.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cityBtn setTitle:[TTUserManager sharedInstance].currentUser.city forState:UIControlStateNormal];
        [cityBtn setTitleColor:[UIColor colorWithHexString:@"#8F9394"] forState:UIControlStateNormal];
        [cityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        self.cityBtn = cityBtn;
        
        //地区label
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = @"地区:";
        label3.font = [UIFont systemFontOfSize:16];
        label3.textColor = [UIColor colorWithHexString:@"#8F9394"];
        [whiteView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(whiteView).offset(0.079 * SCREEN_WIDTH);
            make.centerY.mas_equalTo(cityBtn);
        }];
        
        //确认btn
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [whiteView addSubview:confirmBtn];
        [confirmBtn setBackgroundColor:[UIColor clearColor]];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:maincolor forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(whiteView).offset(-30);
            make.bottom.mas_equalTo(whiteView).offset(-20);
        }];
        [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        //取消btn
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [whiteView addSubview:cancelBtn];
        [cancelBtn setBackgroundColor:[UIColor clearColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#8F9394"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(confirmBtn);
            make.right.mas_equalTo(whiteView).offset(-120);
        }];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}

//选择城市
- (void)selectCity {
    
    AreaSelectViewController *ctrl = [[AreaSelectViewController alloc] init];
    [self.currentVC.navigationController pushViewController:ctrl animated:YES];
    
    __weak AreaSelectViewController *_ctrl = ctrl;
    [ctrl setSelectedCityBlock:^(AreaModel * info) {
        [self.cityBtn setTitle:info.areaName forState:UIControlStateNormal];
        self.city = info.areaName;
        [_ctrl.navigationController popViewControllerAnimated:YES];
    }];
    
}

//确认修改
- (void)confirm {
    
    NSDictionary *dict = @{
                           @"openID":[TTUserManager sharedInstance].currentUser.openId,
                           @"grade":self.grade,
                           @"city":self.city
                           };
    dict = [HMACSHA1 encryptDicForRequest:dict];
    
    AFHTTPSessionManager *manager = [HttpTool initializeHttpManager];
    NSURLSessionDataTask *dataTask = [manager GET:[URLBuilder getURLForUpsertUserExt] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [XWHUDManager showSuccessTipHUD:@"修改成功"];
            [TTUserManager sharedInstance].currentUser.grade = self.grade;
            [TTUserManager sharedInstance].currentUser.city = self.city;
            [[TTUserManager sharedInstance] saveCurrentUserInfo];
            if (self.reloadInfo) {
                self.reloadInfo(dict);
            }
            [self cancel];
        }
        
    } failure:nil];
    [dataTask resume];
    
}

//取消
- (void)cancel {
    self.isShow = NO;
    self.hidden = YES;
    [self removeFromSuperview];
    [[self.currentVC rdv_tabBarController] setTabBarHidden:NO animated:NO];
}

#pragma mark - HHDropDownListDataSource
- (NSArray *)listDataForDropDownList:(HHDropDownList *)dropDownList {
    NSMutableArray *titleArr = [NSMutableArray arrayWithArray:@[@"学前", @"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"七年级", @"八年级", @"九年级", @"高一", @"高二", @"高三"]];
    NSInteger index = [titleArr indexOfObject:[TTUserManager sharedInstance].currentUser.grade];
    [titleArr removeObjectAtIndex:index];
    [titleArr insertObject:[TTUserManager sharedInstance].currentUser.grade atIndex:0];
    return titleArr;
}

#pragma mark - HHDropDownListDelegate
- (void)dropDownList:(HHDropDownList *)dropDownList didSelectItemName:(NSString *)itemName atIndex:(NSInteger)index {
    self.grade = itemName;
}

//收起键盘和菜单
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
