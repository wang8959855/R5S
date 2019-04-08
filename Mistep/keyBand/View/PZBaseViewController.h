//
//  PZBaseViewController.h
//  keyband
//
//  Created by 迈诺科技 on 15/10/27.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//#import "YRSideViewController.h"


@interface PZBaseViewController : UIViewController

//@property (strong, nonatomic)YRSideViewController *sideVC;

@property (weak, nonatomic) IBOutlet UIImageView *topNavView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavHeight;

@property (weak, nonatomic) IBOutlet UIView *topNavView2;


@property (weak, nonatomic) IBOutlet UILabel *hour1;

@property (weak, nonatomic) IBOutlet UILabel *minites1;

@property (weak, nonatomic) IBOutlet UILabel *hour2;

@property (weak, nonatomic) IBOutlet UILabel *minites2;

@property (weak, nonatomic) IBOutlet UILabel *hour3;

@property (weak, nonatomic) IBOutlet UILabel *minites3;

@property (weak, nonatomic) IBOutlet UILabel *hour4;

@property (weak, nonatomic) IBOutlet UILabel *minites4;

@property (weak, nonatomic) IBOutlet UILabel *colories1;

@property (weak, nonatomic) IBOutlet UILabel *colories2;

@property (nonatomic, strong) MainTabBarController *tabBarCon;


- (void)setRootViewController:(UIViewController *)viewController animationType:(NSString *)animationType;

- (void)popToViewController:(UIViewController *)viewController animationType:(NSString *)animationType;

- (UIResponder *)checkNextResponderIsKindOfViewController : (Class)viewClass;

- (BOOL) isUserName:(NSString *)userName;

- (BOOL) isPassWord:(NSString *)passWord;

- (BOOL) isEmail:(NSString *)string;

- (BOOL) checkUserName:(NSString *)userName;

- (BOOL) checkPassWord:(NSString *)passWord;

- (BOOL) checkEmail:(NSString *)string;


- (void)loginHome;


- (NSMutableAttributedString *)makeAttributedStringWithString:(NSString *)string andLength:(int)length;


- (void)showAlertView:(NSString *)string;

- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times;

- (void)addActityIndicatorInView :(UIView *)view labelText : (NSString *)labelString detailLabel : (NSString *)detailString;

- (void)removeActityIndicatorFromView : (UIView *)view;

- (void)backToHome;


- (void)shareVC;

- (void)setButtonWithButton:(UIButton *)button andTitle:(NSString *)string;

- (void)loginStateTimeOutWithBlock:(void(^)(BOOL state))block;

- (BOOL)stringNotNull:(NSString *)string;

- (UIImage *)imageWithColor:(UIColor *)color;

//在后台登录
- (void)backstageuseThirdCacheLogin:(NSDictionary *)param;
//在后台登录
- (void)backstageUseCacheLogin:(NSDictionary *)loginDic;
/**
 *
 *更改界面切换的逻辑
 */
//- (void)addCurrentPageScreenshot;
//- (void)settingDrawerWhenPop;
//- (void)settingDrawerWhenPush;

- (void)loginTimeOut;

- (void)getUserInfo;

@end
