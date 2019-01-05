//
//  QRCodeView.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/6.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "QRCodeView.h"
#import "SGQRCode.h"

@interface QRCodeView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation QRCodeView

- (void)showQRCode {
    
    // 大背景
    UIView *bgView = [[UIView alloc]init];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.bgView = bgView;
    
    //白色框
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = whitecolor;
    whiteView.layer.cornerRadius = 4;
    [bgView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 235));
        make.center.mas_equalTo(bgView);
    }];
    self.whiteView = whiteView;
    
    //二维码
    NSString *temp = @"openId:";
    NSString *openId = [TTUserManager sharedInstance].currentUser.openId;
    UIImage *code = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[temp stringByAppendingString:openId] imageViewWidth:125];
    UIImageView *codeView = [[UIImageView alloc]initWithImage:code];
    [whiteView addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 125));
        make.centerX.mas_equalTo(whiteView);
        make.top.mas_equalTo(whiteView).offset(25);
    }];
    
    //标题文字
    UILabel *title = [[UILabel alloc] init];
    title.text = @"使用作业答案助手扫二维码就可以轻松同步书单啦";
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 0;
    title.lineBreakMode = NSLineBreakByCharWrapping;
    [whiteView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView);
        make.top.mas_equalTo(codeView.mas_bottom).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(224, 60));
    }];
    
    UITapGestureRecognizer *cancelGesture = [[UITapGestureRecognizer alloc] init];
    [cancelGesture addTarget:self action:@selector(remove)];
    [bgView addGestureRecognizer:cancelGesture];
    cancelGesture.delegate = self;

}

- (void)remove {
    self.bgView.hidden = YES;
    [self.bgView removeFromSuperview];
}

//使用代理让用户只有点击周围黑背景的时候才消失
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.whiteView]) {
        return NO;
    }
    return YES;
}

@end
