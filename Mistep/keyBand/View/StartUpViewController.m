//
//  StartUpViewController.m
//  Wukong
//
//  Created by apple on 2019/3/19.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "StartUpViewController.h"
#import "RgistViewController.h"
#import "LoginViewController.h"

@interface StartUpViewController ()

@end

@implementation StartUpViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (IBAction)loginAction:(UIButton *)sender {
    LoginViewController *loginVC = [LoginViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)registerAction:(UIButton *)sender {
    RgistViewController *rigistVC = [RgistViewController new];
    [self.navigationController pushViewController:rigistVC animated:YES];
}

@end
