//
//  SleepView.h
//  Wukong
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NightCircleView.h"
#import "TodaySleepDetailViewController.h"

typedef void(^sleepReloadViewBlock)(NSString *title);

@interface SleepView : UIView

@property (strong, nonatomic) UILabel *deepLabel;

@property (strong, nonatomic) UILabel *lightLabel;

@property (strong, nonatomic) UILabel *awakeLabel;

@property (strong, nonatomic) UILabel *sleepStateLabel;

@property (strong, nonatomic) UIButton *targetBtn;

@property (strong, nonatomic) NightCircleView *circle;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, copy) sleepReloadViewBlock sleepReloadViewBlock;

@end
