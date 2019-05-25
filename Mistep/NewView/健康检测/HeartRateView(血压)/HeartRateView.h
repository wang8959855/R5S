//
//  HeartRateView.h
//  Wukong
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartRateCircleView.h"

typedef void(^rateReloadViewBlock)(NSString *title);
@interface HeartRateView : UIView

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) HeartRateCircleView *circleView;

@property (nonatomic, strong) UILabel *nowHeartRateLabel;
@property (nonatomic, strong) UILabel *averageHeartRateLabel;
/** 血压趋势 */
@property (nonatomic, strong) UILabel *bloodPressureLabel;
/** 疲劳趋势 */
@property (nonatomic, strong) UILabel *fatigueLabel;

@property (strong, nonatomic) UIButton *targetBtn;

//血氧箭头
@property (nonatomic, strong) UIImageView *spo2Image;

@property (nonatomic, copy) rateReloadViewBlock rateReloadViewBlock;

//获取最后一个心率值
- (NSInteger)getSleepEndTime:(NSInteger)time;

@end
