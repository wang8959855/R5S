//
//  SportView.h
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMGaugeView.h"

@interface SportView : UIView

@property (nonatomic, strong) UIViewController *controller;

@property (strong, nonatomic) UILabel *heartRateLabel;

@property (strong, nonatomic) UILabel *caloriesLabel;

@property (strong, nonatomic) UILabel *distanceLabel;

//平均心率
@property (strong, nonatomic) UILabel *activeTimeLabel;

@property (strong, nonatomic) LMGaugeView *circle;

@property (strong, nonatomic) UIScrollView *backScrollView;  //大部分内容在这个上面

//@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIButton *targetBtn;

//+ (TodayStepsViewController *)sharedInstance;
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
