//
//  HelpViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/17.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end