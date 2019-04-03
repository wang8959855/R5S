//
//  UserProtocolVC.m
//  Wukong
//
//  Created by apple on 2019/3/16.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "UserProtocolVC.h"

@interface UserProtocolVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UserProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
