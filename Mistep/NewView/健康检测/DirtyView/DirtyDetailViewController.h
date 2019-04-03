//
//  DirtyDetailViewController.h
//  Wukong
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "TabBarBaseViewController.h"
#import "PZOxygenView.h"
#import "OxygenChart.h"
#import "BodyTChart.h"

@interface DirtyDetailViewController : TabBarBaseViewController

@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIScrollView *bodyTScrollView;
@property (strong, nonatomic) UIScrollView *OxygenScrollView;

@property (nonatomic, strong) PZOxygenView *oxygenView;

@property (nonatomic, strong) OxygenChart *oxygenChart;
@property (nonatomic, strong) BodyTChart *bodyTChart;

@property (nonatomic, strong) NSArray *oxygenArray;
@property (nonatomic, strong) NSMutableArray *bodyTArray;

@property (strong, nonatomic) UIView *oxygenBackView;

@property (nonatomic, strong) NSMutableArray *heartsArray;

@end
