//
//  AppDelegate.h
//  keyBand
//
//  Created by 迈诺科技 on 15/10/30.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
//#import "MobClick.h"
//#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTabBarController *mainTabBarController;//主视图TabBarVC
@property (strong, nonatomic) UIButton *coverBtn;//覆盖按钮  用于侧滑的覆盖右侧

@end
