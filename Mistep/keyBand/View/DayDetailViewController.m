////
////  DayDetailViewController.m
////  keyBand
////
////  Created by 迈诺科技 on 15/11/5.
////  Copyright © 2015年 huichenghe. All rights reserved.
////
//
//#import "DayDetailViewController.h"
//#import "TrendViewController.h"
//#import "TargetViewController.h"
//#import "shijianViewController.h"
//#import "PZChart.h"
//#import "PZPilaoChart.h"
//#import "PZNightHeartChart.h"
//
//#define KONEDAYSECONDS 86400
//
//@interface DayDetailViewController ()<UIScrollViewDelegate>
//{
//    int _beginTime;
//    int _endTime;
//    float _scrollViewHeight;
//    float _dayHeartViewHeight;
//
//}
//@end
//
//@implementation DayDetailViewController
//
//- (void)dealloc
//{
////    [BlueToothData getInstance].dayDetailDelegate = nil;
//    [_mainScrollView removeFromSuperview];_mainScrollView = nil;
//    [_scrollView removeFromSuperview];_scrollView = nil;
//}
//
//- (void)setXibLabel
//{
//    _dateLabel.text = [[TimeCallManager getInstance] changeDateTommddeWithSeconds:_second];
//    _dayStepsLabel.text = NSLocalizedString(@"步数", nil);
//    _dayColoriesLabel.text = NSLocalizedString(@"热量", nil);
//    _dayStateLabel.text = NSLocalizedString(@"运动状态", nil);
//    //    _dayWarningLabel1.text = NSLocalizedString(@"         极限", nil);
//    //    _dayNormalLabel.text = NSLocalizedString(@"         正常", nil);
//    //    _dayWarningLabel2.text = NSLocalizedString(@"         极限", nil);
//    _nightComletionLabel.text = NSLocalizedString(@"完成:", nil);
//    _nightStateLabel.text = NSLocalizedString(@"睡眠质量", nil);
//    _deepLabel.text = NSLocalizedString(@"深睡", nil);
//    _lightLabel.text = NSLocalizedString(@"浅睡", nil);
//    _nightMaxHeartRate.text = NSLocalizedString(@"最大心率:--", nil);
//    _nightAveHeartRate.text = NSLocalizedString(@"平均心率:--", nil);
//    _kNightHeartLabel.text = NSLocalizedString(@"夜间心率", nil);
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self setXibLabel];
//    
//    self.view.frame = CurrentDeviceBounds;
//    _dayStepView.height = 250.0/568*CurrentDeviceHeight;
//    _dayHeartViewHeight = CurrentDeviceHeight - 250.0/568*CurrentDeviceHeight - 80 - 35;
//    _heartArray = [[NSMutableArray alloc]init];
////    [BlueToothData getInstance].dayDetailDelegate = self;
//    self.isStep = YES;
//    _mainScrollView = [[UIScrollView alloc]initWithFrame:CurrentDeviceBounds];
//    _mainScrollView.contentSize = CGSizeMake(2*CurrentDeviceWidth, CurrentDeviceHeight-20);
//    _mainScrollView.bounces = NO;
//    _mainScrollView.showsHorizontalScrollIndicator = NO;
//    _mainScrollView.pagingEnabled = YES;
//    [self.view addSubview:_mainScrollView];
//    _dayScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, CurrentDeviceWidth, CurrentDeviceHeight - 44)];
//    [_mainScrollView addSubview:_dayScrollView];
//    _dayScrollView.contentSize = CGSizeMake(CurrentDeviceWidth, CurrentDeviceHeight-43.5);
//    _dayView.frame = CGRectMake(0, -64, CurrentDeviceWidth, CurrentDeviceHeight);
//    [_dayScrollView addSubview:_dayView];
//    __weak DayDetailViewController * blockSelf = self;
//    [_dayScrollView addHeaderWithCallback:^{
//        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
//        {
//            [blockSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
//            [blockSelf reloadBlueToothData];
//        }
//        else
//        {
//            [blockSelf addActityTextInView:blockSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
//            [blockSelf.dayScrollView headerEndRefreshing];
//        }
//
//    }];
//    _nightView.frame = CGRectMake(CurrentDeviceWidth, -20, CurrentDeviceWidth, CurrentDeviceHeight);
//    [_mainScrollView addSubview:_nightView];
//    [self.view bringSubviewToFront:_navView];
//    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, _dayStepView.bounds.size.height-84)];
//    _scrollView.delegate = self;
//    _scrollView.bounces = YES;
//    
//    _dayHeartScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, CurrentDeviceWidth, _dayHeartViewHeight)];
//    _dayHeartScrollView.delegate = self;
//    _dayHeartScrollView.showsHorizontalScrollIndicator = NO;
//    _dayHeartScrollView.bounces = NO;
//    [self.dayHeartView addSubview:_dayHeartScrollView];
//    
//    _heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_heartBtn setBackgroundImage:[UIImage imageNamed:@"XQ_HeartSelected"] forState:UIControlStateSelected];
//    [_heartBtn setBackgroundImage:[UIImage imageNamed:@"XQ_HeartUnselected"] forState:UIControlStateNormal];
//    [_heartBtn setTitle:NSLocalizedString(@"心率", nil) forState:UIControlStateNormal];
//    _heartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [_heartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_heartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    _heartBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    [_heartBtn addTarget:self action:@selector(heartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_dayHeartView addSubview:_heartBtn];
//    _heartBtn.frame = CGRectMake(0, 10, 60, 27);
//    
//    _pilaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_pilaoBtn setBackgroundImage:[UIImage imageNamed:@"XQ_HeartSelected"] forState:UIControlStateSelected];
//    [_pilaoBtn setBackgroundImage:[UIImage imageNamed:@"XQ_HeartUnselected"] forState:UIControlStateNormal];
//    [_pilaoBtn setTitle:NSLocalizedString(@"HRV", nil) forState:UIControlStateNormal];
//    [_pilaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_pilaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    _pilaoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    _pilaoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    [_pilaoBtn addTarget:self action:@selector(pilaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_dayHeartView addSubview:_pilaoBtn];
//    _pilaoBtn.frame = CGRectMake(60, 10, 60, 27);
//    
//    _heartBtn.selected = YES;
//    
//    _sleepView.sd_layout.heightIs(CurrentDeviceHeight * 250/568);
//    _nightHeartVIew.sd_layout.widthIs(CurrentDeviceWidth)
//    .heightIs(CurrentDeviceHeight - CurrentDeviceHeight * 250/568 -80);
//    
//    _nightHeartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, CurrentDeviceWidth, _nightHeartVIew.height - 35)];
//    _nightHeartScrollView.showsHorizontalScrollIndicator = NO;
//    [_nightHeartVIew addSubview:_nightHeartScrollView];
//    
//    [self addHeartLabelTo:_dayHeartView];
//    [self addHeartLabelTo:_nightHeartVIew];
//    
//    [_dayHeartView bringSubviewToFront:_dayHeartScrollView];
//    [_nightHeartVIew bringSubviewToFront:_nightHeartScrollView];
//    
//    _sleepArray = [[NSMutableArray alloc]init];
//    _nightHeartArray = [[NSMutableArray alloc]init];
//    
//    [self reloadData];
//}
//
//- (void)addHeartLabelTo:(UIView *)view
//{
//    NSArray *HRAlarmArray = [[NSUserDefaults standardUserDefaults] objectForKey:kHeartRateAlarm];
//    int maxHR = 160;
//    int minHR = 40;
//    if (HRAlarmArray)
//    {
//        maxHR = [HRAlarmArray[1] intValue];
//        minHR = [HRAlarmArray[0] intValue];
//    }
//    
//    UILabel *dayWarningLabel1 = [[UILabel alloc] init];
//    dayWarningLabel1.text = NSLocalizedString(@"         预警", nil);
//    dayWarningLabel1.font = [UIFont systemFontOfSize:12];
//    //    dayWarningLabel1.textColor = kColor(254, 40, 42);
//    dayWarningLabel1.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
//    [view addSubview:dayWarningLabel1];
//    dayWarningLabel1.sd_layout.topSpaceToView(view,35)
//    .leftEqualToView(view)
//    .rightEqualToView(view)
//    .heightIs(_dayHeartViewHeight/220 * (220 - maxHR));
//    
//    
//    UILabel *day220 = [[UILabel alloc] init];
//    day220.textColor = [UIColor grayColor];
//    day220.text = @"220";
//    [day220 sizeToFit];
//    day220.font = [UIFont systemFontOfSize:12];
//    [view addSubview:day220];
//    day220.sd_layout.leftEqualToView(dayWarningLabel1)
//    .topEqualToView(dayWarningLabel1);
//    
//    UIImageView *lineImageView1 = [[UIImageView alloc] init];
//    [dayWarningLabel1 addSubview:lineImageView1];
//    lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
//    lineImageView1.contentMode = UIViewContentModeLeft;
//    lineImageView1.sd_layout.topSpaceToView(dayWarningLabel1,5)
//    .leftSpaceToView(dayWarningLabel1,25)
//    .rightEqualToView(dayWarningLabel1);
//    
//    UILabel *dayNormalLabel = [[UILabel alloc] init];
//    dayNormalLabel.text = NSLocalizedString(@"         正常", nil);
//    dayNormalLabel.textColor = [UIColor grayColor];
//    dayNormalLabel.font = [UIFont systemFontOfSize:12];
//    [view addSubview:dayNormalLabel];
//    dayNormalLabel.sd_layout.topSpaceToView(dayWarningLabel1,0)
//    .leftEqualToView(view)
//    .rightEqualToView(view)
//    .heightIs(_dayHeartViewHeight/220 * (maxHR - minHR));
//    
//    UILabel *dayMax = [[UILabel alloc] init];
//    dayMax.textColor = [UIColor grayColor];
//    
//    dayMax.text = [NSString stringWithFormat:@"%.d",maxHR];
//    [dayMax sizeToFit];
//    dayMax.font = [UIFont systemFontOfSize:12];
//    [view addSubview:dayMax];
//    dayMax.sd_layout.leftEqualToView(view)
//    .topSpaceToView(dayWarningLabel1,-5)
//    .heightIs(10);
//    
//    UIImageView *lineImageView2 = [[UIImageView alloc] init];
//    [dayNormalLabel addSubview:lineImageView2];
//    lineImageView2.image = [UIImage imageNamed:@"XQ_pointLine"];
//    lineImageView2.contentMode = UIViewContentModeLeft;
//    lineImageView2.sd_layout.topSpaceToView(dayNormalLabel,0)
//    .leftSpaceToView(dayNormalLabel,25)
//    .rightEqualToView(dayNormalLabel);
//    
//    UILabel *dayWarningLabel2 = [[UILabel alloc] init];
//    dayWarningLabel2.text = NSLocalizedString(@"         预警", nil);
//    dayWarningLabel2.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
//    dayWarningLabel2.font = [UIFont systemFontOfSize:12];
//    [view addSubview:dayWarningLabel2];
//    dayWarningLabel2.sd_layout.topSpaceToView(dayNormalLabel,0)
//    .leftEqualToView(view)
//    .rightEqualToView(view)
//    .bottomEqualToView(_dayHeartScrollView);
//    
//    UILabel *day50 = [[UILabel alloc] init];
//    day50.textColor = [UIColor grayColor];
//    day50.text = [NSString stringWithFormat:@"%d",minHR];
//    [day50 sizeToFit];
//    day50.font = [UIFont systemFontOfSize:12];
//    [view addSubview:day50];
//    day50.sd_layout.leftEqualToView(view)
//    .bottomSpaceToView(dayWarningLabel2,-5)
//    .heightIs(10);
//    
//    UIImageView *lineImageView3 = [[UIImageView alloc] init];
//    [dayWarningLabel2 addSubview:lineImageView3];
//    lineImageView3.image = [UIImage imageNamed:@"XQ_pointLine"];
//    lineImageView3.contentMode = UIViewContentModeLeft;
//    lineImageView3.sd_layout.topSpaceToView(dayWarningLabel2,0)
//    .leftSpaceToView(dayWarningLabel2,25)
//    .rightEqualToView(dayWarningLabel2);
//    
//    //    UILabel *day0 = [[UILabel alloc] init];
//    //    day0.textColor = [UIColor grayColor];
//    //    day0.text = @"0";
//    //    [day0 sizeToFit];
//    //    day0.font = [UIFont systemFontOfSize:12];
//    //    [view addSubview:day0];
//    //    day0.sd_layout.bottomEqualToView(view)
//    //    .leftEqualToView(view)
//    //    .heightIs(10);
//}
//
//+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
//{
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:lineView.bounds];
//    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
//    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
//    
//    //  设置虚线颜色为blackColor
//    [shapeLayer setStrokeColor:lineColor.CGColor];
//    
//    //  设置虚线宽度
//    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    
//    //  设置线宽，线间距
//    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
//    
//    //  设置路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 0, 0);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
//    
//    [shapeLayer setPath:path];
//    CGPathRelease(path);
//    
//    //  把绘制好的虚线添加上来
//    [lineView.layer addSublayer:shapeLayer];
//}
//
//
//-(void)viewDidLayoutSubviews
//{
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self reloadBlueToothData];
//
//}
//
//- (void)reloadBlueToothData
//{
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        WeakSelf;
//        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
//            _totalDic = dic;
//        }];
//        
//        [[PZBlueToothManager sharedInstance] checkHourStepsAndCostsWithBlock:^(NSArray *steps, NSArray *costs) {
//            [weakSelf reloadOK];
//            [weakSelf reloadData];
//
//        }];
//        [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
//            [weakSelf reloadData];
//        }];
//        [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
//            [weakSelf reloadData];
//        }];
//        [[PZBlueToothManager sharedInstance] checkHRVDataWithHRVBlock:^(int number, NSArray *array) {
//            [weakSelf reloadData];
//        }];
//    }
//}
//
//- (void)querDetailData
//{
////    [[BlueToothManager getInstance] getCurDayTotalHeartData];
//}
//
//- (void)reloadOutTime
//{
//    [self.dayScrollView headerEndRefreshing];
//    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
//}
//
//#pragma mark - UIScrollViewDelegate
//
//
//#pragma mark - BlueToothDataDelegate
//
//- (void)bluetoothrecieveDayDetailData
//{
//
//}
//
//- (void)reloadOK
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
//    [self.dayScrollView headerEndRefreshing];
//}
//
//
//
//
//
//#pragma mark -- buttonAction
//
//- (void)heartBtnAction:(UIButton *)button
//{
//    if (button.selected)
//    {
//        return;
//    }
//    _heartBtn.selected = YES;
//    _pilaoBtn.selected = NO;
//    [_pilaoView removeFromSuperview];
//    _maxHeartLabel.hidden = NO;
//    _aveHeartLabel.hidden = NO;
//    self.SDNNLabel.hidden = YES;
//    _pilaoView = nil;
//}
//
//- (void)pilaoBtnAction:(UIButton *)button
//{
//    if (button.selected)
//    {
//        return;
//    }
//    
////    if (![HCHCommonManager getInstance].pilaoValue) {
////        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"当前手环版本不支持此功能", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
////        [alertView show];
////        return;
////    }
//    
//    _pilaoBtn.selected = YES;
//    _heartBtn.selected = NO;
//    self.SDNNLabel.hidden = NO;
//    _maxHeartLabel.hidden = YES;
//    _aveHeartLabel.hidden = YES;
//    [_dayHeartView addSubview:self.pilaoView];
//}
//
//- (UILabel *)SDNNLabel
//{
//    if (!_SDNNLabel)
//    {
//        _SDNNLabel = [[UILabel alloc] init];
//        _SDNNLabel.text = @"SDNN";
//        [_dayHeartView addSubview:_SDNNLabel];
//        _SDNNLabel.frame = CGRectMake(CurrentDeviceWidth - 58, 15, 50, 15);
//        _SDNNLabel.font = [UIFont systemFontOfSize:13];
//        _SDNNLabel.textColor = [UIColor grayColor];
//        _SDNNLabel.textAlignment = NSTextAlignmentRight;
//    }
//    return _SDNNLabel;
//}
//
//- (UIView *)pilaoView
//{
//    if (!_pilaoView)
//    {
//        _pilaoView = [[PZPilaoView alloc] initWithFrame:CGRectMake(0, 35, CurrentDeviceWidth, _dayHeartView.height - 35)];
//        [_dayHeartView addSubview:_pilaoView];
//        PZPilaoChart *chart = [[PZPilaoChart alloc] initWithFrame:CGRectMake(_pilaoView.frame.origin.x, 5, _pilaoView.frame.size.width, _pilaoView.frame.size.height - 23)];
//        //        chart.backgroundColor = [UIColor greenColor];
//        chart.pilaoArray = _pilaoArray;
//        [_pilaoView addSubview:chart];
//        
//    }
//    return _pilaoView;
//}
//
//- (IBAction)costAction:(id)sender
//{
//    if (_isStep)
//    {
//        for (UIView *view in _scrollView.subviews)
//        {
//            [view removeFromSuperview];
//        }
//        _isStep = NO;
//        _costImageView.image = [UIImage imageNamed:@"XQ_xiaohaoSelected"];
//        _stepImageView.image = [UIImage imageNamed:@"XQ_unselected"];
//        _stepBGImageView.image = [UIImage imageNamed:@"XQ_xiaohaoBG"];
//        [self drawCostsView];
//    }
//}
//
//- (IBAction)stepsAction:(id)sender
//{
//    if (! _isStep)
//    {
//        for (UIView *view in _scrollView.subviews)
//        {
//            [view removeFromSuperview];
//        }
//        _isStep = YES;
//        _stepImageView.image = [UIImage imageNamed:@"XQ_stepSelected"];
//        _costImageView.image = [UIImage imageNamed:@"XQ_unselected"];
//        _stepBGImageView.image = [UIImage imageNamed:@"XQ_stepBg"];
//        [self drawStepView];
//        
//    }
//}
//
//
//
//- (void)reloadData
//{
//    _totalDic =  [[SQLdataManger getInstance] getTotalDataWith:_second];
//    _detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:_second];
//    [_sleepArray removeAllObjects];
//    self.stepsArray = nil;
//    self.costsArray = nil;
//    self.pilaoArray = nil;
//    
//    if (_detailDic != nil)
//    {
//        self.stepsArray = [NSKeyedUnarchiver unarchiveObjectWithData:_detailDic[kDayStepsData]];
//        self.costsArray = [NSKeyedUnarchiver unarchiveObjectWithData:_detailDic[kDayCostsData]];
//        self.pilaoArray = [NSKeyedUnarchiver unarchiveObjectWithData:_detailDic[kPilaoData]];
//        NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:_second - KONEDAYSECONDS];
//        NSArray *lastDaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:lastDayDic[DataValue_SleepData_HCH]];
//        if (lastDaySleepArray && lastDaySleepArray.count != 0)
//        {
//            for (int i = 126; i < 144; i ++)
//            {
//                [_sleepArray addObject:lastDaySleepArray[i]];
//            }
//        }
//        else {
//            for (int i = 0 ; i < 18; i ++)
//            {
//                [_sleepArray addObject:@0];
//            }
//        }
//        NSArray *todaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:_detailDic[DataValue_SleepData_HCH]];
//        if (todaySleepArray && todaySleepArray.count != 0)
//        {
//            for (int i = 0; i < 72; i ++)
//            {
//                [_sleepArray addObject:todaySleepArray[i]];
//            }
//        }
//    }
//    [self updateView];
//    _dateLabel.text = [[TimeCallManager getInstance] changeDateTommddeWithSeconds:_second];
//}
//
//- (void)updateLabels
//{
////    int activeTime = [_totalDic[TotalDataActivityTime_DayData_HCH] intValue];
////    int calmdownTime = [_totalDic[TotalDataCalmTime_DayData_HCH] intValue];
////    _activeTimeLabel.text = [NSString stringWithFormat:@"%dh%dmin",activeTime/60,activeTime %60];
////    _calmLabel.text = [NSString stringWithFormat:@"%dh%dmin",calmdownTime/60,calmdownTime %60];
////    _activityCostLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d千卡", nil),[_totalDic[kTotalDayActivityCost] intValue]];
////    _calmCostLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d千卡", nil),[_totalDic[kTotalDayCalmCost] intValue]];
////    int sleepPlan = [HCHCommonManager getInstance].sleepPlan;
////    _sleepTagLabel.text = [NSString stringWithFormat:NSLocalizedString(@"目标:%dh", nil),sleepPlan/60];
//}
//
//- (void)drawSleepView
//{
//    for(UIView *view in _sleepView.subviews)
//    {
//        if (view.tag == 100)
//        {
//            [view removeFromSuperview];
//        }
//    }
//    int nightBeginTime = 0;
//    int nightEndTime = 0;
//    BOOL isBegin = NO;
//    
//    int lightSleep = 0;
//    int deepSleep = 0;
//    for (int i = 0; i < _sleepArray.count; i ++)
//    {
//        int sleepState = [_sleepArray[i] intValue];
//        
//        if (sleepState != 0 && sleepState != 3)
//        {
//            if (isBegin == NO)
//            {
//                isBegin = YES;
//                nightBeginTime = i;
//            }
//            nightEndTime = i;
//        }
//    }
//    if (_sleepArray && _sleepArray.count != 0)
//    {
//        if (nightEndTime > nightBeginTime)
//        {
//            for (int i = nightBeginTime ; i <= nightEndTime; i ++)
//            {
//                int state = [_sleepArray[i] intValue];
//                UIView *view = [[UIView alloc]initWithFrame:CGRectMake((i-nightBeginTime)*(float)CurrentDeviceWidth/(nightEndTime - nightBeginTime+1), 80, (float)CurrentDeviceWidth/(nightEndTime - nightBeginTime+1), 80)];
//                view.tag = 100;
//                [_sleepView addSubview:view];
//                if (state == 2 )
//                {
//                    view.backgroundColor = kColor(122, 82, 160);
//                    view.sd_layout.bottomSpaceToView(_sleepView,40)
//                    .heightIs(_sleepView.height-40-64);
//                    deepSleep ++;
//                    
//                }else if (state == 1)
//                {
//                    view.backgroundColor = kColor(212, 170, 254);
//                    view.sd_layout.bottomSpaceToView(_sleepView,40)
//                    .heightIs(_sleepView.height-40-64 -25);
//                    lightSleep ++;
//                }
//                if (state == 0 || state == 3)
//                {
//                    view.backgroundColor = kColor(242, 217, 254);
//                    view.sd_layout.bottomSpaceToView(_sleepView,40)
//                    .heightIs(_sleepView.height-40-64-50);
//                }
//                
//            }
//            NSArray *timeArray = nil;
//            nightEndTime += 1;
//            if (nightEndTime - nightBeginTime >= 3)
//            {
//                int firstTime = nightBeginTime + (nightEndTime - nightBeginTime)/3;
//                int secondTime = nightBeginTime + (nightEndTime - nightBeginTime)/3*2;
//                timeArray = @[[NSNumber numberWithInt:nightBeginTime],[NSNumber numberWithInt:firstTime],[NSNumber numberWithInt:secondTime],[NSNumber numberWithInt:nightEndTime]];
//                
//                for (int i = 0; i < timeArray.count; i ++)
//                {
//                    UILabel *label = [[UILabel alloc] init];
//                    label.font = [UIFont systemFontOfSize:12];
//                    label.textColor = [UIColor blackColor];
//                    label.tag = 100;
//                    int index = [timeArray[i] intValue];
//                    int time = 0;
//                    if (index < 18)
//                    {
//                        time = 21+index/6;
//                    }
//                    else
//                    {
//                        time = (index - 18)/6;
//                    }
//                    
//                    int min = index%6*10;
//                    label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
//                    [_sleepView addSubview:label];
//                    label.textAlignment = NSTextAlignmentCenter;
//                    label.sd_layout.leftSpaceToView(_sleepView,(CurrentDeviceWidth - 35)/3*i)
//                    .bottomSpaceToView(_sleepView,23)
//                    .widthIs(35)
//                    .heightIs(15);
//                }
//            }
//            else
//            {
//                timeArray = @[[NSNumber numberWithInt:nightBeginTime],[NSNumber numberWithInt:nightEndTime]];
//                for (int i = 0; i < timeArray.count; i ++)
//                {
//                    UILabel *label = [[UILabel alloc] init];
//                    label.font = [UIFont systemFontOfSize:12];
//                    label.textColor = [UIColor blackColor];
//                    label.tag = 100;
//                    int index = [timeArray[i] intValue];
//                    int time = 0;
//                    if (index < 18)
//                    {
//                        time = 21+index/6;
//                    }
//                    else
//                    {
//                        time = (index - 18)/6;
//                    }
//                    int min = index%6*10;
//                    label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
//                    label.textAlignment = NSTextAlignmentCenter;
//                    [_sleepView addSubview:label];
//                    label.sd_layout.leftSpaceToView(_sleepView,(CurrentDeviceWidth - 35)*i)
//                    .bottomSpaceToView(_sleepView,23)
//                    .widthIs(35)
//                    .heightIs(15);
//                }
//                
//            }
//        }
//    }
//    int totalSleep = deepSleep + lightSleep;
//    if (totalSleep < 36)
//    {
//        _sleepState.text = NSLocalizedString(@"偏少", nil);
//    }else if (totalSleep < 54)
//    {
//        _sleepState.text = NSLocalizedString(@"正常", nil);
//    }else
//    {
//        _sleepState.text = NSLocalizedString(@"充裕", nil);
//    }
//    _hourLabel.text = [NSString stringWithFormat:@"%d",totalSleep/6];
//    _minLabel.text = [NSString stringWithFormat:@"%d",totalSleep*10%60];
//    _deepSleepHour.text = [NSString stringWithFormat:@"%d",deepSleep/6];
//    _deepSleepMin.text = [NSString stringWithFormat:@"%d",deepSleep*10%60];
//    _lightSleepHour.text = [NSString stringWithFormat:@"%d",lightSleep/6];
//    _lightSleepMin.text = [NSString stringWithFormat:@"%d",lightSleep*10%60];
//    
//    int sleepPlan = [HCHCommonManager getInstance].sleepPlan;
//    _comSleepLabel.text = [NSString stringWithFormat:@"%.0f%%",totalSleep*1000.0/sleepPlan];
//    
//    [self drawNightHeartViewWithBeginTime:nightBeginTime EndTime:nightEndTime];
//    
//}
//
//- (void)drawCostsView
//{
//    int costBeginTime = 0;
//    int costEndTime = 0;
//    BOOL isBegin = NO;
//    for (int i = 0 ; i < _costsArray.count ; i ++)
//    {
//        int cost = [_costsArray[i] intValue];
//        if (cost != 0)
//        {
//            if (isBegin == NO)
//            {
//                costBeginTime = i;
//                isBegin = YES;
//            }
//            costEndTime = i;
//        }
//    }
//    
//    _scrollView.contentOffset = CGPointMake(0, 0);
//    _scrollView.contentSize = CGSizeMake(CurrentDeviceWidth/10. * (costEndTime - costBeginTime + 1) + 10, _scrollView.height);
//    
//    
//    if (costBeginTime <= costEndTime && costEndTime > 0)
//    {
//        int maxCost = 0;
//        for (int i = costBeginTime; i < costEndTime + 1; i ++)
//        {
//            int costs = [_costsArray[i] intValue];
//            if (maxCost < costs)
//            {
//                maxCost = costs;
//            }
//            
//        }
//        for (int i = costBeginTime; i < costEndTime + 1; i ++)
//        {
//            int costs = [_costsArray[i] intValue];
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake((i - costBeginTime) * (CurrentDeviceWidth / 18.), 5, 10, _dayStepView.frame.size.height - 20)];
//            view.backgroundColor = [UIColor colorWithRed:234/255.0 green:85/255.0 blue:19/255.0 alpha:1];
//            [_scrollView addSubview:view];
//            
//            view.sd_layout.leftSpaceToView(_scrollView,(i - costBeginTime) * (CurrentDeviceWidth / 10.)+10)
//            .widthIs(CurrentDeviceWidth/18)
//            .heightIs(costs * (_scrollView.height - 40.0) /maxCost)
//            .bottomSpaceToView(_scrollView,20);
//            
//            if (costs > 0)
//            {
//                UILabel *label = [UILabel new];
//                [_scrollView addSubview:label];
//                label.sd_layout
//                .centerXEqualToView(view)
//                .bottomSpaceToView(view,1)
//                .widthIs(150)
//                .heightIs(15);
//                label.text = [NSString stringWithFormat:@"%d",costs];
//                label.textAlignment = NSTextAlignmentCenter;
//                label.font = [UIFont systemFontOfSize:11];
//                label.textColor = [UIColor whiteColor];
//            }
//            
//            if (i%2 == costBeginTime%2)
//            {
//                UILabel *timeLabel = [UILabel new];
//                timeLabel.text = [NSString stringWithFormat:@"%d:00",i];
//                [_scrollView addSubview:timeLabel];
//                timeLabel.sd_layout.centerXEqualToView(view)
//                .bottomSpaceToView(_scrollView,4)
//                .widthIs(35)
//                .heightIs(10);
//                timeLabel.textColor = [UIColor blackColor];
//                timeLabel.font = [UIFont systemFontOfSize:12];
//                timeLabel.textAlignment = NSTextAlignmentCenter;
//            }
//        }
//    }
//}
//
//- (void)drawStepView
//{
//    _totalSteps = 0;
//    _beginTime = 0;
//    _endTime = 0;
//    _maxStep =0;
//    BOOL isBegin = NO;
//    for (int i = 0 ; i < _stepsArray.count ; i ++)
//    {
//        int steps = [_stepsArray[i] intValue];
//        if (steps != 0)
//        {
//            if (isBegin == NO)
//            {
//                _beginTime = i;
//                isBegin = YES;
//            }
//            _endTime = i;
//            if (_maxStep < steps)
//            {
//                _maxStep = steps;
//            }
//            _totalSteps += steps;
//        }
//    }
//    
//    
//    if (_totalSteps < 4000)
//    {
//        _stateLabel.text = NSLocalizedString(@"偏低", nil);
//    }
//    else if (_totalSteps < 8000)
//    {
//        _stateLabel.text = NSLocalizedString(@"正常", nil);
//    }else if (_totalSteps < 12000)
//    {
//        _stateLabel.text = NSLocalizedString(@"活跃", nil);
//    }else
//    {
//        _stateLabel.text = NSLocalizedString(@"达人", nil);
//    }
//    
//    [_dayStepView addSubview:_scrollView];
//    [_dayStepView sendSubviewToBack:_scrollView];
//    [_dayStepView sendSubviewToBack:_stepBGImageView];
//    _scrollView.sd_layout.leftEqualToView(_dayStepView)
//    .rightEqualToView(_dayStepView)
//    .bottomSpaceToView(_dayStepView,20)
//    .topSpaceToView(_dayStepView,64);
//    
//    
//    
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    
//    _scrollView.contentOffset = CGPointMake(0, 0);
//    _scrollView.contentSize = CGSizeMake(CurrentDeviceWidth/10. * (_endTime - _beginTime + 1) + 10, _scrollView.height);
//    
//    if (_endTime >= _beginTime && _endTime > 0)
//    {
//        for (int i = _beginTime; i < _endTime + 1; i ++)
//        {
//            int steps = [_stepsArray[i] intValue];
//            
//            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor colorWithRed:33/255.0 green:109/255.0 blue:182/255.0 alpha:1];
//            [_scrollView addSubview:view];
//            
//            float leftdis = (i - _beginTime) * (CurrentDeviceWidth / 10.)+10;
//            view.sd_layout.leftSpaceToView(_scrollView,leftdis)
//            .widthIs(CurrentDeviceWidth/18)
//            .heightIs(steps * (_scrollView.height - 40.0) /_maxStep)
//            .bottomSpaceToView(_scrollView,20);
//            
//            if (steps > 0)
//            {
//                UILabel *label = [UILabel new];
//                [_scrollView addSubview:label];
//                label.sd_layout
//                .centerXEqualToView(view)
//                .bottomSpaceToView(view,1)
//                .widthIs(150)
//                .heightIs(15);
//                label.text = [NSString stringWithFormat:@"%d",steps];
//                label.textAlignment = NSTextAlignmentCenter;
//                label.font = [UIFont systemFontOfSize:11];
//                label.textColor = [UIColor whiteColor];
//            }
//            
//            if (i%2 == _beginTime%2)
//            {
//                UILabel *timeLabel = [UILabel new];
//                timeLabel.text = [NSString stringWithFormat:@"%d:00",i];
//                [_scrollView addSubview:timeLabel];
//                timeLabel.sd_layout.centerXEqualToView(view)
//                .bottomSpaceToView(_scrollView,4)
//                .widthIs(35)
//                .heightIs(10);
//                timeLabel.textColor = [UIColor blackColor];
//                timeLabel.font = [UIFont systemFontOfSize:12];
//                timeLabel.textAlignment = NSTextAlignmentCenter;
//            }
//            
//            
//        }
//    }
//}
//
//- (void)drawNightHeartViewWithBeginTime:(int)beginTime EndTime:(int)endTime
//{
//    [_nightHeartArray removeAllObjects];
//    for (UIView *view in _nightHeartScrollView.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    if (beginTime == endTime)
//    {
//        return;
//    }
//    beginTime = beginTime*10;
//    endTime = endTime *10;
//    NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:_second - KONEDAYSECONDS + 8 ];
//    
//    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
//    NSMutableArray *tempArray = [NSMutableArray new];
//    if (array && array.count != 0)
//    {
//        [tempArray addObjectsFromArray:array];
//    }
//    else
//    {
//        for (int i = 0 ; i < 180; i ++)
//        {
//            [tempArray addObject:[NSNumber numberWithInt:0]];
//        }
//    }
//    for (int i = 1 ; i < 5; i ++)
//    {
//        NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:_second+i];
//        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
//        if (array && array.count != 0)
//        {
//            [tempArray addObjectsFromArray:array];
//        }
//        else
//        {
//            for (int i = 0 ; i < 180; i ++)
//            {
//                [tempArray addObject:[NSNumber numberWithInt:0]];
//            }
//        }
//    }
//    
//    
//    for (int i = beginTime; i < endTime; i ++)
//    {
//        [_nightHeartArray addObject:tempArray[i]];
//    }
//    
//    int maxNightHeart = 0;
//    int totalNightHeart = 0;
//    int nightHeartCount = 0;
//    for (int i = 0 ; i < _nightHeartArray.count ; i ++)
//    {
//        int nightHeart = [_nightHeartArray[i] intValue];
//        if (maxNightHeart < nightHeart)
//        {
//            maxNightHeart = nightHeart;
//        }
//        totalNightHeart += nightHeart;
//        if (nightHeart > 0)
//        {
//            nightHeartCount ++;
//        }
//    }
//    if (nightHeartCount != 0)
//    {
//        _nightMaxHeartRate.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"最大心率:", nil), maxNightHeart];
//        _nightAveHeartRate.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"平均心率:", nil),totalNightHeart/nightHeartCount];
//    }
//    
//    _nightHeartScrollView.contentSize = CGSizeMake(CurrentDeviceWidth, 0);
//    PZNightHeartChart *nightChart = [PZNightHeartChart new];
//    [_nightHeartScrollView addSubview:nightChart];
//    nightChart.sd_layout.bottomEqualToView(_nightHeartScrollView)
//    .leftEqualToView(_nightHeartScrollView)
//    .topEqualToView(_nightHeartScrollView)
//    .widthIs(CurrentDeviceWidth);
//    nightChart.heartArray = _nightHeartArray;
//    
//    
//    beginTime = beginTime/10;
//    endTime = endTime /10;
//    NSArray * timeArray;
//    if (endTime - beginTime >= 3)
//    {
//        int firstTime = beginTime + (endTime - beginTime)/3;
//        int secondTime = beginTime + (endTime - beginTime)/3*2;
//        timeArray = @[[NSNumber numberWithInt:beginTime],[NSNumber numberWithInt:firstTime],[NSNumber numberWithInt:secondTime],[NSNumber numberWithInt:endTime]];
//        
//        for (int i = 0; i < timeArray.count; i ++)
//        {
//            UILabel *label = [[UILabel alloc] init];
//            label.font = [UIFont systemFontOfSize:12];
//            label.textColor = [UIColor grayColor];
//            label.tag = 100;
//            int index = [timeArray[i] intValue];
//            int time = 0;
//            if (index < 18)
//            {
//                time = 21+index/6;
//            }
//            else
//            {
//                time = (index - 18)/6;
//            }
//            int min = index%6*10;
//            label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
//            [nightChart addSubview:label];
//            label.textAlignment = NSTextAlignmentRight;
//            label.sd_layout.leftSpaceToView(nightChart,(CurrentDeviceWidth - 45)/3*i)
//            .bottomSpaceToView(nightChart,0)
//            .widthIs(35)
//            .heightIs(15);
//        }
//    }
//    else
//    {
//        timeArray = @[[NSNumber numberWithInt:beginTime],[NSNumber numberWithInt:endTime]];
//        for (int i = 0; i < timeArray.count; i ++)
//        {
//            UILabel *label = [[UILabel alloc] init];
//            label.font = [UIFont systemFontOfSize:12];
//            label.textColor = [UIColor grayColor];
//            label.tag = 100;
//            int index = [timeArray[i] intValue];
//            int time = 0;
//            if (index < 18)
//            {
//                time = 21+index/6;
//            }
//            else
//            {
//                time = (index - 18)/6;
//            }
//            int min = index%6*10;
//            label.text = [NSString stringWithFormat:@"%d:%02d",time,min];
//            label.textAlignment = NSTextAlignmentCenter;
//            [nightChart addSubview:label];
//            
//            label.sd_layout.leftSpaceToView(nightChart,(CurrentDeviceWidth - 35)*i)
//            .bottomSpaceToView(nightChart,0)
//            .widthIs(35)
//            .heightIs(15);
//        }
//    }
//}
//
//- (void)drawHeartView
//{
//    //    int heartBegin = _beginTime/3 + 1;
//    //    NSDate *date = [NSDate date];
//    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    //    [formatter setDateFormat:@"HH"];
//    //    NSString *dateString = [formatter stringFromDate:date];
//    
//    int heartBegin = _beginTime/3+1;
//    int heartEnd = 0;
//    if (_second == [[TimeCallManager getInstance] getSecondsOfCurDay])
//    {
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"HH"];
//        NSString *hourString = [formatter stringFromDate:date];
//        heartEnd = [hourString intValue]/3+1;
//    }
//    else
//    {
//        heartEnd = 8;
//    }
//    _maxHeartLabel.text = NSLocalizedString(@"最大心率:--", nil);
//    _aveHeartLabel.text = NSLocalizedString(@"平均心率:--", nil);
//    
//    [_heartArray removeAllObjects];
//    for (UIView *view in _dayHeartScrollView.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    for (int i = heartBegin; i < heartEnd + 1; i ++)
//    {
//        NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:_second+i];
//        NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
//        if (array)
//        {
//            [_heartArray addObjectsFromArray:array];
//            
//        }
//    }
//    if (_heartArray.count != 0)
//    {
//        //        心率label
//        int beginIndex = _beginTime%3;
//        [_heartArray removeObjectsInRange:NSMakeRange(0, beginIndex * 60)];
//        int maxheart = 0;
//        int heartCount = 0;
//        int totalHeart = 0;
//        for (int i = 0 ;  i < _heartArray.count; i ++)
//        {
//            int heart = [_heartArray[i] intValue];
//            if (maxheart < heart)
//            {
//                maxheart = heart;
//            }
//            if (heart != 0 )
//            {
//                totalHeart += heart;
//                heartCount += 1;
//            }
//        }
//        if (heartCount != 0)
//        {
//            int aveHeart = totalHeart/heartCount;
//            _maxHeartLabel.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"最大心率:", nil) ,maxheart];
//            _aveHeartLabel.text = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"平均心率:", nil) ,aveHeart];
//        }
//        
//        int showBegin = 0;
//        int showEnd = 0;
//        BOOL isBegin = NO;
//        NSMutableArray *showHearArray = [[NSMutableArray alloc]init];
//        
//        for (int i = 0 ; i < _heartArray.count; i ++)
//        {
//            int heart = [_heartArray[i] intValue];
//            if (heart != 0)
//            {
//                showEnd = i;
//                if (isBegin == NO)
//                {
//                    isBegin = YES;
//                    showBegin = i;
//                }
//            }
//            if (isBegin )
//            {
//                [showHearArray addObject:[NSNumber numberWithInt:heart]];
//            }
//        }
//        
//        //        心率图
//        _dayHeartScrollView .contentSize= CGSizeMake(showEnd - showBegin + 20, _dayHeartScrollView.frame.size.height);
//        
//        PZChart *chart = [[PZChart alloc] initWithFrame:CGRectMake(0, 0, showHearArray.count  + 20, _dayHeartScrollView.frame.size.height)];
//        chart.heartArray = showHearArray;
//        [_dayHeartScrollView addSubview:chart];
//        chart.sd_layout.leftEqualToView(_dayHeartScrollView)
//        .topEqualToView(_dayHeartScrollView)
//        .bottomEqualToView(_dayHeartScrollView)
//        .widthIs(showHearArray.count + 20);
//        
//        for (int i = showBegin ; i < showEnd; i ++)
//        {
//            if (i % 60 ==0)
//            {
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + 60 * (i - showBegin) , _dayHeartScrollView.frame.size.height - 15 , 43 , 15)];
//                label.text = [NSString stringWithFormat:@"%d:00",_beginTime + i/60];
//                label.font = [UIFont systemFontOfSize:12];
//                label.textColor = [UIColor grayColor];
//                [_dayHeartScrollView addSubview:label];
//                label.sd_layout.leftSpaceToView(_dayHeartScrollView,10+(i - showBegin))
//                .bottomEqualToView(_dayHeartScrollView)
//                .widthIs(43)
//                .heightIs(15);
//            }
//        }
//    }
//}
//
//- (IBAction)shareAction:(id)sender
//{
//    [self shareVC];
//}
//- (IBAction)qushiAction:(id)sender
//{
//    TrendViewController *trendVC = [[TrendViewController alloc]init];
//    [self.navigationController pushViewController:trendVC animated:YES];
//}
//
//
//
//- (IBAction)lastDayAction:(id)sender
//{
//    _second -= KONEDAYSECONDS;
//    [self reloadData];
//}
//
//
//
//- (IBAction)nextDayAction:(id)sender
//{
//    if (_second < [[TimeCallManager getInstance] getSecondsOfCurDay])
//    {
//        _second += KONEDAYSECONDS;
//        [self reloadData];
//    }
//    
//}
//
//- (IBAction)datePickerAction:(id)sender
//{
//    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
//    _backView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_backView];
//    
//    
//    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
//    [_backView addSubview:_animationView];
//    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
//    NSString* string = @"19000101";
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyyMMdd"];
//    NSDate* minDate = [formatter dateFromString:string];
//    _datePicker.datePickerMode = UIDatePickerModeDate;
//    _datePicker.backgroundColor = [UIColor whiteColor];
//    NSDate *maxDate = [NSDate date];
//    _datePicker.maximumDate = maxDate;
//    _datePicker.minimumDate = minDate;
//    [_animationView addSubview:_datePicker];
//    
//    UIView *buttonView = [[UIView alloc] init];
//    buttonView.backgroundColor = [UIColor whiteColor];
//    [_animationView addSubview:buttonView];
//    buttonView.sd_layout.leftEqualToView(_backView)
//    .rightEqualToView(_backView)
//    .heightIs(30)
//    .bottomSpaceToView(_datePicker,0);
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonView addSubview:button];
//    button.frame = CGRectMake(CurrentDeviceWidth-80, 0, 80, 40);
//    [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    btnImageView.image = [UIImage imageNamed:@"勾"];
//    btnImageView.center = button.center;
//    [buttonView addSubview:btnImageView];
//    
//    [UIView animateWithDuration:0.23 animations:^{
//        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246,CurrentDeviceWidth, 246);
//    }];
//    
//    
//}
//
//
//- (IBAction)goBackAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)updateView
//{
//    for (UIView *view in _scrollView.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    
//    [self stepsAction:nil];
//    [self drawStepView];
//    [self drawSleepView];
//    [self drawHeartView];
//    [self updateLabels];
//    if (_pilaoView != nil)
//    {
//        [_pilaoView removeFromSuperview];
//        _pilaoView = nil;
//        [_dayHeartView addSubview:self.pilaoView];
//    }
//}
//
//
//- (void)dateCancleButtonClick
//{
//    
//    [self hiddenDateBackView];
//}
//
//- (void)dateSureClick
//{
//    
//    
//    NSDate *pickDate = _datePicker.date;
//    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
//    [formates setDateFormat:@"yyyy/MM/dd"];
//    NSString *dayString = [formates stringFromDate:pickDate];
//    _second = [[TimeCallManager getInstance] getSecondsWithTimeString:dayString andFormat:@"yyyy/MM/dd"];
//    [self reloadData];
//    [self hiddenDateBackView];
//}
//
//- (void)hiddenDateBackView
//{
//    [UIView animateWithDuration:0.23 animations:^{
//        _animationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
//    } completion:^(BOOL finished) {
//        
//        [_backView removeFromSuperview];
//        _backView = nil;
//        [_datePicker removeFromSuperview];
//        _datePicker = nil;
//    }];
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self hiddenDateBackView];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//@end
