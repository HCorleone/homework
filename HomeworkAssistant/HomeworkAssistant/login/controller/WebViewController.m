//
//  WebViewController.m
//  sw-reader
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leftBackLabel;
@end

@implementation WebViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WebViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WebViewController"];
}

- (void)dealloc {
    YDLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //提示用户正在加载
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//webView加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //webView缩放
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.leftBackLabel.hidden = !self.webView.canGoBack;
    [self getTitle];
}

//加载失败之后也要移除
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//用来拦截webView请求
//当webView需要加载一个请求的时候，就会调用这个方法，询问下是否请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    return YES;
}
#pragma mark - functions
- (void)setUpViews {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:kNeteaseMailREGISTER_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //加载请求
    [self.webView loadRequest:request];
}

- (void)setUpNavBar{
    // Do any additional setup after loading the view.
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    CGSize barSize = CGSizeMake(25,25);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width * 82 /640, kTopBarHeight)];
    UIImageView *leftPicView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kTopBarHeight - barSize.height - 9, barSize.width, barSize.height)];
    [leftPicView setImage:[UIImage imageNamed:@"back"]];
    [leftView addSubview:leftPicView];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backIndex)];
    [leftView addGestureRecognizer:leftTap];
    leftView.width = leftPicView.width;
    
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.userInteractionEnabled = YES;
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.font = font14;
    backLabel.textColor = [UIColor blackColor];
    backLabel.text = @"关闭";
    CGSize titleStrSize = [XUtil sizeWithString:backLabel.text font:backLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    backLabel.frame = CGRectMake(0,- Main_Screen_Height,titleStrSize.width,leftView.height);
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [backLabel addGestureRecognizer:backTap];
    
    UIBarButtonItem *leftOne = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    UIBarButtonItem *leftTwo = [[UIBarButtonItem alloc] initWithCustomView:backLabel];
    backLabel.hidden = YES;
    self.leftBackLabel = backLabel;
    self.navigationItem.leftBarButtonItems = @[leftOne, leftTwo];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backIndex{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self back];
    }
}

// 获取当前页面Title
- (void)getTitle {
    NSString * title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title length] == 0 && [self.webViewTitle length] > 0) {
        title = self.webViewTitle;
    }
    self.webViewTitle = title;
    
    if (!self.titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = font16;
        titleLabel.textColor = [UIColor blackColor];
        self.titleLabel  = titleLabel;
    }
    
    CGSize titleStrSize = [XUtil sizeWithString:title font:font16 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.titleLabel.size = titleStrSize;
    self.titleLabel.text = title;
    //如果y值不设置为屏幕之外的话，会有一个闪现
    self.titleLabel.frame = CGRectMake(0,- Main_Screen_Height,titleStrSize.width,titleStrSize.height);
    self.navigationItem.titleView = self.titleLabel;
    YDLog(@"%@", NSStringFromCGRect(self.navigationItem.titleView.frame));
}
@end
