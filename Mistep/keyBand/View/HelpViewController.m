//
//  HelpViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/17.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIView *failView;

@end

@implementation HelpViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    _titleLabel.text = NSLocalizedString(@"帮助", nil);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://rulong.lantianfangzhou.com//wechat2/assistance.html"]];
    [_helpWebView loadRequest:request];
    self.helpWebView.delegate = self;
    
}

- (IBAction)goBackAction:(id)sender
{
//    [self backToHome];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.failView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self failView];
    self.failView.hidden = NO;
}

- (UIView *)failView{
    if (!_failView) {
        _failView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight-SafeAreaTopHeight)];
        _failView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_failView];
        
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://rulong.lantianfangzhou.com//wechat2/assistance.html"]];
    [self.helpWebView loadRequest:request];
}

- (void)goBackVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
