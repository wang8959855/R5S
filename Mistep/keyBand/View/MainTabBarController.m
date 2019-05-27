//
//  MainTabBarController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "MainTabBarController.h"
//#import "PSDrawerManager.h"
//#import "TodayStepsViewController.h"
//#import "TodaySportMapViewController.h"
//#import "TodaySleepViewController.h"
//#import "XueyaViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>
//<UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = allColorWhite;
    [self.view addSubview:self.coverBtn];//覆盖按钮
    AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.coverBtn = self.coverBtn;
//    self.tabBar.barTintColor = kColor(20, 67, 131);
    [[UITabBar appearance] setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pressChange:(UIButton *)sender {
    sender.selected=!sender.selected;
}

#pragma mark -
#pragma mark - UITabBarController protocol methods
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2) {
        tabBarController.selectedIndex = self.lastIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMoreView" object:nil];
    }else{
        self.lastIndex = tabBarController.selectedIndex;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jieLvBackHome" object:nil];
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if ([viewController isKindOfClass:[UINavigationController class]]) {
//
//        UINavigationController *navigationController = (UINavigationController *)viewController;
//        UIViewController *viewController = navigationController.viewControllers.firstObject;
//
//        // 如果选中消息页，响应拖拽手势，可以显示侧边栏
//        // 否则取消手势响应，不能显示侧边栏
//        if ([viewController isKindOfClass:[TodayStepsViewController class]]||[viewController isKindOfClass:[TodaySportMapViewController class]]||[viewController isKindOfClass:[TodaySleepViewController class]]||[viewController isKindOfClass:[XueyaViewController class]])
//
//        {
//            [[PSDrawerManager instance] beginDragResponse];
//        }
//        else
//        {
//            [[PSDrawerManager instance] cancelDragResponse];
//        }
//
//        //adaLog(@"--------------------------------------拦截---------------------------------------------");
//    }
//}
//#import "TodayStepsViewController.h"
//#import "TodaySportMapViewController.h"
//#import "TodaySleepViewController.h"
//#import "XueyaViewController.h"

-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc]init];
        _coverBtn.backgroundColor = [UIColor grayColor];
        _coverBtn.alpha = 0.3;
        _coverBtn.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight);
        _coverBtn.hidden = YES;
        [_coverBtn addTarget:self action:@selector(coverBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}
-(void)coverBtnAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.3f animations:^{
        
        AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.mainTabBarController.view.transform = CGAffineTransformIdentity;
        app.coverBtn.hidden = YES;
    }];
    
    //adaLog(@"----    - - - - 点击的关闭侧滑！！");
}


@end
