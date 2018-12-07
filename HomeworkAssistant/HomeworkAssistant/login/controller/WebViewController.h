//
//  WebViewController.h
//  sw-reader
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "ViewController.h"

@interface WebViewController : ViewController
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *webViewTitle;
@property (nonatomic, strong) NSURL *url;
@end
