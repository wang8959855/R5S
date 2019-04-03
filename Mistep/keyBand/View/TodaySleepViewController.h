//
//  TodaySleepViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "TabBarBaseViewController.h"
#import "NightCircleView.h"
#import "TodaySleepDetailViewController.h"

@interface TodaySleepViewController : TabBarBaseViewController

@property (strong, nonatomic) UILabel *deepLabel;

@property (strong, nonatomic) UILabel *lightLabel;

@property (strong, nonatomic) UILabel *awakeLabel;

@property (strong, nonatomic) UILabel *sleepStateLabel;

@property (strong, nonatomic) UIButton *targetBtn;

@property (strong, nonatomic) NightCircleView *circle;

@end
