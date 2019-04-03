//
//  RegulationViewController.m
//  Wukong
//
//  Created by apple on 2018/6/23.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "RegulationViewController.h"

@interface RegulationViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation RegulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://rulong.lantianfangzhou.com//wechat2/healthadjust.html?UserID=%@&token=%@",USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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


@end
