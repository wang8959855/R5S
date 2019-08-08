//
//  RegulationViewController.m
//  Wukong
//
//  Created by apple on 2018/6/23.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "RegulationViewController.h"

@interface RegulationViewController ()<UIWebViewDelegate>

    @property (weak, nonatomic) IBOutlet UILabel *pageTitle;
    
    
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusheight;

@end

@implementation RegulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rulong.lantianfangzhou.com/test04Adjust/healthadjust.html?userID=%@&token=%@",USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.statusheight.constant = StatusBarHeight;
    self.pageTitle.text = kLOCAL(@"健康调控");
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
