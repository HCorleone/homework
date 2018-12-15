//
//  FillBookInformationViewController.m
//  HomeworkAssistant
//
//  Created by 卢华 on 2018/12/5.
//  Copyright © 2018年 无敌帅枫. All rights reserved.
//

#import "FillBookInformationViewController.h"
#import "NIDropDown.h"
#import "UpAnswerViewController.h"

@interface FillBookInformationViewController ()<NIDropDownDelegate>
/** 导航栏 */
@property (nonatomic, strong) UIView *navView;
/** 下拉菜单 */
@property (nonatomic, strong) NIDropDown *dropDown;

@end

@implementation FillBookInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getView];
    [self setupNav];
}

//返回上一个界面
- (void)backToVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    //导航栏
    UIView *navView = [[UIView alloc]init];
    [self.view addSubview:navView];
    navView.backgroundColor = maincolor;
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(72 + TOP_OFFSET);
    }];
    self.navView = navView;
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.navView).with.offset(20);
        make.bottom.mas_equalTo(self.navView).with.offset(-15);
    }];
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.text = @"填写书籍信息";
    [title setTextColor: [UIColor whiteColor]];
    title.font = [UIFont fontWithName:@"NotoSansHans-Regular" size:16];
    [self.navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView);
        make.centerY.mas_equalTo(backBtn);
        
    }];
}


//视图
-(void)getView{
    
    _fillView = [[FillBookInformationView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    __weak typeof(self) weakSelf = self;
    _fillView.clickBlock = ^(UIButton * _Nonnull btn) {
        
        NSLog(@"%ld", btn.tag);
        NSArray * arr = [[NSArray alloc] init];
        switch (btn.tag) {
            case 1001:
            {
                arr = [NSArray arrayWithObjects:@"学前", @"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"七年级", @"八年级", @"九年级", @"高一", @"高二", @"高三", nil];
                if(weakSelf.dropDown == nil) {
                    CGFloat f = screenHeight * 0.6;
                    weakSelf.dropDown = [[NIDropDown alloc]showDropDown:weakSelf.fillView.chooseBtn1 theHeight:&f theArr:arr theImgArr:nil theDirection:@"down" withViewController:weakSelf];
                    [weakSelf.dropDown setCellHeigth:37];
                    [weakSelf.dropDown setDropDownSelectionColor:[UIColor whiteColor]];
                    weakSelf.dropDown.delegate = weakSelf;
                }
                else {
                    [weakSelf.dropDown hideDropDown:weakSelf.fillView.chooseBtn1];
                }
            }

                break;
            case 1002:
            {
                arr = [NSArray arrayWithObjects:@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"科学", nil];
                if(weakSelf.dropDown == nil) {
                    CGFloat f = screenHeight * 0.5;
                    weakSelf.dropDown = [[NIDropDown alloc]showDropDown:weakSelf.fillView.chooseBtn2 theHeight:&f theArr:arr theImgArr:nil theDirection:@"down" withViewController:weakSelf];
                    [weakSelf.dropDown setCellHeigth:37];
                    [weakSelf.dropDown setDropDownSelectionColor:[UIColor whiteColor]];
                    weakSelf.dropDown.delegate = weakSelf;
                }
                else {
                    [weakSelf.dropDown hideDropDown:weakSelf.fillView.chooseBtn2];
                }
            }

                break;
            case 1003:
            {
                arr = [NSArray arrayWithObjects:@"人教版", @"北师大版", @"苏教版", @"冀教版", @"外研版", @"沪科版", @"湘教版", @"青岛版", @"鲁教版", @"浙教版", @"教科版", @"华师大版", @"译林版", @"苏科版", @"语文版", @"西师大版", @"牛津版", @"沪粤版", @"北京课改版", @"鲁科版", @"河大版", @"长春版", @"语文S版", @"冀少版", @"商务星球版", @"济南版", @"鄂教版", @"江苏版", @"中华书局版", @"中科版", @"科粤版", @"川教版", @"陕旅版", @"语文A版", @"仁爱版", @"苏人版", @"其他", nil];
                if(weakSelf.dropDown == nil) {
                    CGFloat f = screenHeight * 0.3;
                    weakSelf.dropDown = [[NIDropDown alloc]showDropDown:weakSelf.fillView.chooseBtn3 theHeight:&f theArr:arr theImgArr:nil theDirection:@"down" withViewController:weakSelf];
                    [weakSelf.dropDown setCellHeigth:37];
                    [weakSelf.dropDown setDropDownSelectionColor:[UIColor whiteColor]];
                    weakSelf.dropDown.delegate = weakSelf;
                }
                else {
                    [weakSelf.dropDown hideDropDown:weakSelf.fillView.chooseBtn3];
                }
            }

                break;
                
            case 1004:
            {
//                [weakSelf.navigationController pushViewController:[[UpAnswerViewController alloc] init] animated:YES];
                
                if ([weakSelf.fillView.chooseBtn1.titleLabel.text isEqualToString:@"请选择年级"] || [weakSelf.fillView.chooseBtn2.titleLabel.text isEqualToString:@"请选择学科"] ||[weakSelf.fillView.chooseBtn3.titleLabel.text isEqualToString:@"请选择版本"]) {
                    NSLog(@"信息不全");
                    [CommonAlterView showAlertView:@"信息不完整"];
                }
                else{

                    if ([weakSelf.fillView.inputField.text isEqualToString:@""] || [weakSelf.fillView.codeLabel.text isEqualToString:@""]) {
                        NSLog(@"信息不全");
                        [CommonAlterView showAlertView:@"未输入条码"];
                    }
                    else{
                        
                        //请求接口
                        [weakSelf getManager];
                    }
                }
                
            }
                
                break;
        }

        
    };
    [self.view addSubview:_fillView];
    
}

#pragma mark - 请求接口
-(void)getManager {
    
    NSDictionary *dic = @{@"h":@"ZYUploadAnswerBaseInfoHandler",
                          @"openID":userValue(@"openId"),
                          @"userName":userValue(@"name"),
                          @"title":self.fillView.inputField.text,
                          @"grade":self.fillView.chooseBtn1.titleLabel.text,
                          @"subject":self.fillView.chooseBtn2.titleLabel.text,
                          @"bookVersion":self.fillView.chooseBtn3.titleLabel.text,
                          @"code":userValue(@"InputBarCode"),
                          @"av":@"_debug_"
                          
                          };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OnLineIP]];
    //设置请求方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //接收数据是json形式给出
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
        __weak typeof(self) weakSelf = self;
    [manager GET:GetUpAnswerID parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------------%@------------------------------", responseObject);
        //返回成功
        if ([responseObject[@"code"] intValue] == 200) {
            //保存id
            NSString *str = [responseObject[@"datas"] valueForKey:@"id"];
            userDefaults(str, @"GetUpAnswerID");
            
            [weakSelf.navigationController pushViewController:[[UpAnswerViewController alloc] init] animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
    }];
}

#pragma mark - NIDropDownDelegate 下拉代理
- (void) niDropDownDelegateMethod:(UIView *)sender withTitle:(NSString *)title {

    if (sender == self.fillView.chooseBtn1){
        NSLog(@"%@", self.fillView.chooseBtn1.titleLabel.text);
        [self.fillView.chooseBtn1 setTitle:title forState:UIControlStateNormal];
    }
    else if (sender == self.fillView.chooseBtn2){
        NSLog(@"%@", self.fillView.chooseBtn2.titleLabel.text);
        [self.fillView.chooseBtn2 setTitle:title forState:UIControlStateNormal];
    }
    else{
        NSLog(@"%@", self.fillView.chooseBtn3.titleLabel.text);
        [self.fillView.chooseBtn3 setTitle:title forState:UIControlStateNormal];
    }

}

- (void)niDropDownHidden{
    _dropDown = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self.dropDown hideDropDown:self.fillView.chooseBtn1];
    [self.dropDown hideDropDown:self.fillView.chooseBtn2];
    [self.dropDown hideDropDown:self.fillView.chooseBtn3];
}

@end
