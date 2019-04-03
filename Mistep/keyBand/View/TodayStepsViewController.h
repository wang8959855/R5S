//
//  TodayStepsViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
//第一个界面

#import "TabBarBaseViewController.h"
#import "LMGaugeView.h"

@interface TodayStepsViewController : TabBarBaseViewController

@property (strong, nonatomic) UILabel *heartRateLabel;

@property (strong, nonatomic) UILabel *caloriesLabel;

@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) UILabel *activeTimeLabel;

@property (strong, nonatomic) LMGaugeView *circle;

@property (strong, nonatomic) UIScrollView *backScrollView;  //大部分内容在这个上面

//@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIButton *targetBtn;

+ (TodayStepsViewController *)sharedInstance;
-(void)refreshSELF;

#pragma mark -- 给客户的友情提示
/**
 提示重新刷新   --再下一次数据
 */
-(void)remindRedownData;
/**
 提示没有网络
 */
-(void)remindNotReachable;
@end
