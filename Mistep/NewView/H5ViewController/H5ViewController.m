//
//  H5ViewController.m
//  Wukong
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "H5ViewController.h"

@interface H5ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;


@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    [self.webView loadRequest:request];
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

@end
