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
    if ([self.webView canGoBack]) {
        self.backButton.hidden = NO;
    }else{
        self.backButton.hidden = YES;
    }
}

@end
