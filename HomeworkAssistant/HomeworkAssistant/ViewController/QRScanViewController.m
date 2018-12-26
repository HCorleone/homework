//
//  QRScanViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/27.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "MainViewController.h"
#import "SearchResultViewController.h"
#import "QRScanViewController.h"
#import "SGQRCode.h"
#import "MyViewController.h"
#import "InputBarCodeViewController.h"
#import "FillBookInformationViewController.h"
#import "QRCodeView.h"

@interface QRScanViewController ()<SGQRCodeScanManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager *scanManager;
@property (nonatomic, strong) SGQRCodeScanningView *scanView;

@end

@implementation QRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SGQRCodeScanManager *scanManager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    [scanManager setupSessionPreset:@"AVCaptureSessionPresetHigh" metadataObjectTypes:arr currentController:self];
    scanManager.delegate = self;
    self.scanManager = scanManager;
    [self.scanManager startRunning];
    
    SGQRCodeScanningView *scanView = [[SGQRCodeScanningView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scanView.cornerColor = whitecolor;
    scanView.backgroundAlpha = 0.4;
    [self.view addSubview:scanView];
    self.scanView = scanView;
    
    UILabel *scanTitle = [[UILabel alloc]init];
    scanTitle.font = [UIFont systemFontOfSize:15];
    [scanTitle setBackgroundColor:[UIColor clearColor]];
    scanTitle.textColor = whitecolor;
    scanTitle.text = @"扫描同学的二维码即可同步书单";
    [self.view addSubview:scanTitle];
    [scanTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0.35 * SCREEN_WIDTH);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(35 + TOP_OFFSET);
    }];

    if (self.scanType == ScanTypeUploadAnswer ||
        self.scanType == ScanTypeFeedBack) {
        scanTitle.text = @"将图书背面的条码放到扫描框内";

        UIButton *manualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [manualBtn setTitle:@"手动输入条码" forState:UIControlStateNormal];
        [manualBtn setTitleColor:whitecolor forState:UIControlStateNormal];
        [manualBtn setBackgroundColor:[UIColor clearColor]];
        manualBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:manualBtn];
        [manualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(backBtn);
            make.right.mas_equalTo(self.view).offset(-20);
        }];
        [manualBtn addTarget:self action:@selector(toManual) forControlEvents:UIControlEventTouchUpInside];
    }
    //手电筒控制按钮
    UIButton *flashLight = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashLight setBackgroundImage:[UIImage imageNamed:@"手电筒v2"] forState:UIControlStateNormal];
//    [flashLight setBackgroundImage:[UIImage imageNamed:@"手电筒v2"] forState:UIControlStateSelected];
    [self.view addSubview:flashLight];
    [flashLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.bottom.mas_equalTo(self.view).offset(-0.4 * SCREEN_WIDTH);
    }];
    [flashLight addTarget:self action:@selector(controlFlashLight:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)controlFlashLight:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = !btn.selected;
        [SGQRCodeHelperTool SG_CloseFlashlight];
    }
    else {
        btn.selected = !btn.selected;
        [SGQRCodeHelperTool SG_openFlashlight];
    }
}

//点击按钮
- (void)toManual {
    //手动输入条形码
    [self.scanView removeTimer];
    [self.scanManager stopRunning];
    
    [self.navigationController pushViewController:[[InputBarCodeViewController alloc] init] animated:YES];
}

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    AVMetadataMachineReadableCodeObject * tempMetadataObject = [metadataObjects objectAtIndex : 0 ];
    NSString *result = tempMetadataObject.stringValue;
    
    if (self.scanType == ScanTypeDefault) {
        if (result.length >= 7) {
            if ([[result substringToIndex:7] isEqualToString: @"openId:"]) {
                [self.scanView removeTimer];
                [self.scanManager stopRunning];
//                NSLog(@"%@",[result substringFromIndex:7]);
                NSString *code = [result substringFromIndex:7];
                [self returnShareCode:code];
            }
            else {
                [self.scanView removeTimer];
                [self.scanManager stopRunning];
                SearchResultViewController *searchResultVC = [[SearchResultViewController alloc]init];
                searchResultVC.searchContent = result;
                [self.navigationController pushViewController:searchResultVC animated:YES];
            }
        }
        else {
            [self.scanView removeTimer];
            [self.scanManager stopRunning];
            SearchResultViewController *searchResultVC = [[SearchResultViewController alloc]init];
            searchResultVC.searchContent = result;
            [self.navigationController pushViewController:searchResultVC animated:YES];
        }
    }
    else if (self.scanType == ScanTypeUploadAnswer){
        
        [self.scanView removeTimer];
        [self.scanManager stopRunning];
        //扫码结果
        FillBookInformationViewController *fill = [[FillBookInformationViewController alloc] init];
        userDefaults(result, @"InputBarCode");
        [self.navigationController pushViewController:fill animated:YES];
    }
    else if (self.scanType == ScanTypeFeedBack) {
        [self.scanView removeTimer];
        [self.scanManager stopRunning];
        
        NSLog(@"前往反馈界面");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)returnShareCode:(NSString *)code {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.shareCodeBlock) {
        self.shareCodeBlock(code);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
    if (self.scanManager) {
        [self.scanManager startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scanManager stopRunning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

@end
