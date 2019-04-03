//
//  HeartRateDetailViewController.h
//  Wukong
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "TabBarBaseViewController.h"
#import "PZPilaoView.h"
#import "PZChart.h"
#import "PZPilaoChart.h"

@interface HeartRateDetailViewController : TabBarBaseViewController

@property (strong, nonatomic) UILabel *maxHeartLabel;

@property (strong, nonatomic) UILabel *avgHeartLabel;

@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIScrollView *heartScrollView;
@property (strong, nonatomic) UIView *pilaoBackView;

@property (strong, nonatomic) NSMutableArray *heartsArray;

@property (strong, nonatomic) NSArray *HRVArray;

@property (strong, nonatomic) NSArray *stepsArray;

@property (strong, nonatomic) NSArray *costsArray;

@property (strong, nonatomic) NSDictionary *totalDic;

@property (strong, nonatomic) PZChart *heartChart;
@property (strong, nonatomic) PZPilaoView *pilaoView;

@end
