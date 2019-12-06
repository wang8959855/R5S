//
//  H5ViewController.m
//  Wukong
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "H5ViewController.h"

@interface H5ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;

@property (nonatomic, strong) UIView *failView;

@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    self.statusHeight.constant = StatusBarHeight;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
    [self performSelector:@selector(setTitleStr) withObject:nil afterDelay:0.1];
}

- (void)setTitleStr{
    self.titleLabel.text = self.titleStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回
- (IBAction)goBackAction:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    [self.webView loadRequest:request];
}

- (void)goBackVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
