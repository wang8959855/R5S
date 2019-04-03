//
//  FriendDetailViewController.m
//  Wukong
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "FriendDetailViewController.h"

@interface FriendDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *u = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:u];
    [self.webView loadRequest:request];
}

//返回
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
