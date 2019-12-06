//
//  RegulationView.m
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "RegulationView.h"

@interface RegulationView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *failView;

@end

@implementation RegulationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [self createView];
    }
    return self;
}

- (void)createView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-49-50)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://rulong.lantianfangzhou.com//wechat2/healthadjust.html?UserID=%@&token=%@",USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self addSubview:self.webView];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(0, 0, 50, 45);
    [self.webView.scrollView addSubview:self.backButton];
    if ([self.webView canGoBack]) {
        self.backButton.hidden = NO;
    }else{
        self.backButton.hidden = YES;
    }
    [self.backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)goBackAction{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.failView.hidden = YES;
    if ([self.webView canGoBack]) {
        self.backButton.hidden = NO;
    }else{
        self.backButton.hidden = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self failView];
    self.failView.hidden = NO;
}

- (UIView *)failView{
    if (!_failView) {
        _failView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight-SafeAreaTopHeight)];
        _failView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_failView];
        
        //图片
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-217/2, 100, 217, 220)];
        imageV.image = [UIImage imageNamed:@"shibai-h5"];
        [_failView addSubview:imageV];
        
        //文字
        UILabel *failL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, imageV.bottom+20, 200, 25)];
        failL.textAlignment = NSTextAlignmentCenter;
        failL.text = @"加载失败";
        failL.textColor = [UIColor grayColor];
        [_failView addSubview:failL];
        
        //刷新
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failView addSubview:refreshBtn];
        [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        refreshBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        refreshBtn.backgroundColor = kColor(60, 130, 244);
        refreshBtn.frame = CGRectMake(ScreenWidth/2-80, failL.bottom+50, 160, 36);
        refreshBtn.layer.cornerRadius = 18;
        refreshBtn.layer.masksToBounds = YES;
        [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
        
        //返回
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failView addSubview:backBtn];
        [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        backBtn.backgroundColor = kColor(60, 130, 244);
        backBtn.frame = CGRectMake(ScreenWidth/2-80, refreshBtn.bottom+15, 160, 36);
        backBtn.layer.cornerRadius = 18;
        backBtn.layer.masksToBounds = YES;
        [backBtn addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failView;
}

- (void)refreshAction{
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://rulong.lantianfangzhou.com//wechat2/healthadjust.html?UserID=%@&token=%@",USERID,TOKEN]];
       NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)goBackVC{
    [self.controller.navigationController popViewControllerAnimated:YES];
}

@end
