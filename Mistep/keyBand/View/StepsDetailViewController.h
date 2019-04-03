//
//  StepsDetailViewController.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/29.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "TabBarBaseViewController.h"
#import "StepsUivew.h"
#import "PZChart.h"
#import "PZPilaoView.h"
#import "PZPilaoChart.h"
@interface StepsDetailViewController : TabBarBaseViewController

@property (strong, nonatomic) UIButton *stepsButton;

@property (strong, nonatomic) UIButton *costsButton;

@property (strong, nonatomic) UIButton *heartRateButton;

@property (strong, nonatomic) UIButton *HRVButton;

@property (strong, nonatomic) StepsUivew *stepsView;
@property (strong, nonatomic) StepsUivew *colsView;

@property (strong, nonatomic) UILabel *activeTimeLabel;

@property (strong, nonatomic) UILabel *activeCostLabel;

@property (strong, nonatomic) UILabel *camlTimeLabel;

@property (strong, nonatomic) UILabel *camlCostLabel;

@property (strong, nonatomic) UILabel *maxHeartLabel;

@property (strong, nonatomic) UILabel *avgHeartLabel;

@property (strong, nonatomic) UIScrollView *backScrollView;

@property (strong, nonatomic) NSArray *stepsArray;

@property (strong, nonatomic) NSArray *costsArray;

@property (strong, nonatomic) NSMutableArray *heartsArray;

@property (strong, nonatomic) NSArray *HRVArray;

@property (strong, nonatomic) NSDictionary *totalDic;

@property (strong, nonatomic) PZChart *heartChart;

@property (strong, nonatomic) UIScrollView *heartScrollView;

//@property (strong, nonatomic) UILabel *SDNNLabel;

@property (strong, nonatomic) PZPilaoView *pilaoView;

//@property (copy, nonatomic) NSArray *pilaoArray;

@end
