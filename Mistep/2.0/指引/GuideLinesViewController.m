//
//  GuideLinesViewController.m
//  Bracelet
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 com.czjk.www. All rights reserved.
//

#import "GuideLinesViewController.h"
#import "SheBeiViewController.h"
#import "RhythmViewController.h"
#import "SMTabbedSplitViewController.h"

@interface GuideLinesViewController ()

@end

@implementation GuideLinesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[PSDrawerManager instance] cancelDragResponse];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[PSDrawerManager instance] beginDragResponse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubViews];
}

- (void)setSubViews{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWidth, ScreenHeight-StatusBarHeight)];
    imageV.image = [UIImage imageNamed:self.imageArr[self.index]];
    [self.view addSubview:imageV];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 10;
    nextBtn.layer.borderWidth = 2;
    nextBtn.frame = CGRectMake(ScreenWidth/2-50, ScreenHeight-120, 100, 40);
    [nextBtn addTarget:self action:@selector(nextController) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:nextBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitle:@"结束引导" forState:UIControlStateNormal];
    stopBtn.frame = CGRectMake(ScreenWidth/2-50, ScreenHeight-60, 100, 40);
    stopBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [stopBtn addTarget:self action:@selector(endGuide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}

- (void)nextController{
    if (self.index == self.imageArr.count-1) {
        NSArray *arr = self.navigationController.viewControllers;
        for (UIViewController *con in arr) {
            if ([con isKindOfClass:[SheBeiViewController class]]) {
                [self.navigationController popToViewController:con animated:YES];
                return;
            }
            if ([con isKindOfClass:[RhythmViewController class]]) {
                [self.navigationController popToViewController:con animated:YES];
                return;
            }
            if ([con isKindOfClass:[SMTabbedSplitViewController class]]) {
                [self.navigationController popToViewController:con animated:YES];
                return;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.imageArr = self.imageArr;
    guide.index = ++self.index;
    [self.navigationController pushViewController:guide animated:YES];
}

- (void)endGuide{
    NSArray *arr = self.navigationController.viewControllers;
    for (UIViewController *con in arr) {
        if ([con isKindOfClass:[SheBeiViewController class]]) {
            [self.navigationController popToViewController:con animated:YES];
            return;
        }
        if ([con isKindOfClass:[RhythmViewController class]]) {
            [self.navigationController popToViewController:con animated:YES];
            return;
        }
        if ([con isKindOfClass:[SMTabbedSplitViewController class]]) {
            [self.navigationController popToViewController:con animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
