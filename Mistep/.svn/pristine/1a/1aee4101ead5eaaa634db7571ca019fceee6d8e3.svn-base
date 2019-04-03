////
////  TodayViewController.m
////  keyBand
////
////  Created by 迈诺科技 on 15/10/30.
////  Copyright © 2015年 huichenghe. All rights reserved.
////
//
//#import <objc/runtime.h>
//#import "TodayViewController.h"
////#import "YRSideViewController.h"
//#import "HuoDongXiangQingCell.h"
//#import "SharedViewController.h"
//#import "DayDetailViewController.h"
//#import "TrendViewController.h"
//#import "TargetViewController.h"
//#import "DayOffLineViewController.h"
//#import "UIViewController+MMDrawerController.h"
//#import "HomeViewController.h"
//#import "SelectSportTypeViewController.h"
//#define kState [[[NSUserDefaults standardUserDefaults] objectForKey:kUnitStateKye] intValue]
//#define KONEDAYSECONDS 86400
//
//
//@interface TodayViewController ()<UITableViewDelegate,UITableViewDataSource,UUChartDataSource>
//
////typedef enum {
////    UnitStateNone = 1,
////    UnitStateBritishSystem,
////    UnitStateMetric,
////}UnitState;
//
//@end
//
//static NSString *reuseID = @"cell";
//@implementation TodayViewController
//
//- (void)dealloc
//{
//    [_timer invalidate];
//    _timer = nil;
//    self.detailArray = nil;
//}
//
//- (void)setXibLabel
//{
//    _xueyaBottomBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    _kKuozhangyaLabel.text = NSLocalizedString(@"扩张压:mmHg", nil);
//    _kShousuoyaLabel.text = NSLocalizedString(@"收缩压:mmHg", nil);
//    _kxueyaHRLabel.text = NSLocalizedString(@"心率:次/分钟", nil);
//    _HRVLabel.text = NSLocalizedString(@"正常", nil);
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//    [self setXibLabel];
//    
//
//    
//    _seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
//    self.dateSeconds = _seconds;
//    
//    _informationView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    self.navigationController.navigationBarHidden = YES;
//    _nowStepLabel.attributedText = [self makeAttributedStringWithString:NSLocalizedString(@"0步", nil) andLength:1];
//    
//    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 64) style:UITableViewStyleGrouped];
//    _detailTableView.delegate = self;
//    _detailTableView.dataSource = self;
//    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _detailTableView.showsVerticalScrollIndicator = NO;
//    _detailTableView.bounces = YES;
//    
//    [_mainScrollView addSubview:_detailTableView];
//    _detailTableView.sd_layout.leftEqualToView(_mainScrollView)
//    .topEqualToView(_mainScrollView)
//    .bottomEqualToView(_mainScrollView)
//    .widthIs(CurrentDeviceWidth);
//    
//    _mainScrollView.contentSize = CGSizeMake(CurrentDeviceWidth * 2, CurrentDeviceHeight-64);
//    _mainScrollView.showsHorizontalScrollIndicator = NO;
//    _mainScrollView.pagingEnabled = YES;
//    _mainScrollView.bounces = NO;
//    _mainScrollView.scrollEnabled = YES;
//    
//    
//    [_mainScrollView addSubview:_xueyaView];
//    _xueyaView.frame = CGRectMake(CurrentDeviceWidth, 0, CurrentDeviceWidth, CurrentDeviceHeight - 64);
//    
//    [_detailTableView registerNib:[UINib nibWithNibName:@"HuoDongXiangQingCell" bundle:nil] forCellReuseIdentifier:reuseID];
//    _detailTableView.sectionFooterHeight = 0.1;
//    
//    TodayViewController *blockSelf = self;
//    [_detailTableView addHeaderWithCallback:^{
//       if ([CositeaBlueTooth sharedInstance].isConnected == YES)
//        {
//            [blockSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
//            [blockSelf reloadBlueToothData];
//        }
//        else
//        {
//            [blockSelf addActityTextInView:blockSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
//            [blockSelf.detailTableView headerEndRefreshing];
//        }
//    }];
//    
//    
//    UUChart *chartView = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(0, 10, CurrentDeviceWidth, (CurrentDeviceHeight - 64)/2 -10) withSource:self withStyle:UUChartLineStyle];
//    chartView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
//    [chartView showInView:_uuchartBgView];
//    chartView.sd_layout.leftEqualToView(_uuchartBgView)
//    .rightEqualToView(_uuchartBgView)
//    .topSpaceToView(_uuchartBgView,10)
//    .heightIs((CurrentDeviceHeight - 64)/2 - 10);
//    
//    [self connectLastDevice];
//}
//
//- (void)setBlocks
//{
//    WeakSelf;
//    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
//        if (number)
//        {
//            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
//            [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
//            [weakSelf performSelector:@selector(enableHeart) withObject:nil afterDelay:2.];
//        }
//        else
//        {
//            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
//        }
//    }];
//    
////    [[PZBlueToothManager sharedInstance] recieveOffLineDataWithBlock:^(NSDictionary *dic) {
////        if (![weakSelf isToday])
////        {
////            return;
////        }
////        weakSelf.detailArray = [[SQLdataManger getInstance]queryActualTimeListWithDay:_seconds];
////        [weakSelf.detailTableView reloadData];
////    }];
//}
//
//- (void)reloadOutTime
//{
//    [self.detailTableView headerEndRefreshing];
////    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
//}
//
//- (void)connectLastDevice
//{
//    NSString *blueToothUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kLastDeviceUUID];
//    if (![CositeaBlueTooth sharedInstance].isConnected) {
//        if (blueToothUUID && ![blueToothUUID isEqualToString:@""])
//        {
//            [[CositeaBlueTooth sharedInstance] connectWithUUID:blueToothUUID];
//        }
//    }
//}
//
//#pragma mark - UITableViewDataSource
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    _seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
//
//    
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    
//    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:_dateSeconds];
//    if (dic)
//    {
//        [self upDataUIWithDic:dic];
//    }
//    if([self isToday])
//    {
//        if ([CositeaBlueTooth sharedInstance].isConnected)
//        {
//            if (_timer == nil)
//            {
//                _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadBlueToothData) userInfo:nil repeats:YES];
//            }
//            [self enableHeart];
//        }
//        
//        int stepsPlan = [HCHCommonManager getInstance].stepsPlan;
//        int sleepPlan = [HCHCommonManager getInstance].sleepPlan;
//        if (stepsPlan == 0)
//        {
//            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:10000]  forKey:Steps_PlanTo_HCH];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[HCHCommonManager getInstance] initData];
//            stepsPlan = [HCHCommonManager getInstance].stepsPlan;
//        }
//        if (sleepPlan == 0)
//        {
//            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:480] forKey:Sleep_PlanTo_HCH];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[HCHCommonManager getInstance] initData];
//        }
//        _targetValue.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"目标:", nil),stepsPlan,NSLocalizedString(@"步", nil)];
//        _detailArray = [[NSMutableArray alloc]initWithArray:[[SQLdataManger getInstance]queryActualTimeListWithDay:_dateSeconds]];
//        [_detailTableView reloadData];
//    }
//    [self setBlocks];
//}
//
//
//
//- (void)reloadBlueToothData
//{
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        WeakSelf;
//        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
//            if (![weakSelf isToday])
//            {
//                return;
//            }
//            [weakSelf upDataUIWithDic:dic];
//        }];
//    }
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self reloadBlueToothData];
//    
//}
//
//- (void)reloadTotalDayData
//{
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        WeakSelf;
//        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
//            if (![weakSelf isToday])
//            {
//                return;
//            }
//            [weakSelf upDataUIWithDic:dic];
//        }];
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _detailArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HuoDongXiangQingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//    cell.contentDic = _detailArray[indexPath.row];
//    return cell;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (_detailArray.count != 0)
//    {
//        return nil;
//    }
//    UIView *view = [[UIView alloc] init];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [view addSubview:imageView];
//    view.backgroundColor = [UIColor whiteColor];
//    view.clipsToBounds = YES;
//    if(IsIphone4_Device)
//    {
//        imageView.image = [UIImage imageNamed:@"JR_Botom1.jpg"];
//    }else if (IsIphone5_Device)
//    {
//        imageView.image = [UIImage imageNamed:@"JR_Botom2.jpg"];
//    }else if (IsIphone6_Device)
//    {
//        imageView.image = [UIImage imageNamed:@"JR_Botom3.jpg"];
//    }else
//    {
//        imageView.image = [UIImage imageNamed:@"JR_Botom4.jpg"];
//    }
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    imageView.sd_layout.leftSpaceToView (view,0)
//    .rightSpaceToView(view,0)
//    .topSpaceToView(view,0)
//    .bottomSpaceToView(view,0);
//    return view;
//}
//
//
//#pragma mark - UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    HuoDongXiangQingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:cell.contentDic];
//    int type = [dic[SportType_ActualData_HCH] intValue];
//    if (type == -1)
//    {
//        SelectSportTypeViewController *typeVC = [[SelectSportTypeViewController alloc] init];
//        typeVC.eventDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//        typeVC.cell = cell;
//        [self.navigationController pushViewController:typeVC animated:YES];
//    }
//    else
//    {
//        DayOffLineViewController *OffLineVC = [[DayOffLineViewController alloc]init];
//        OffLineVC.indexPath = indexPath;
//        OffLineVC.contentDic = cell.contentDic;
//        OffLineVC.heartRateArray = cell.heartArray;
//        [self.navigationController pushViewController:OffLineVC animated:YES];
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return 236;
//    }
//    else
//    {
//        return 0.1;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (_detailArray.count != 0)
//    {
//        return 1.1;
//    }
//    else
//    {
//        
//        return CurrentDeviceHeight - 300;
//    }
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    _headerView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 236);
//    return _headerView;
//}
//
//- (void)enableHeart
//{
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        [[CositeaBlueTooth sharedInstance] openActualHeartRateWithBolock:^(int number) {
//            if (number == 0)
//            {
//                _heartRateLabel.text = @"-- bpm";
//                return;
//            }
//            _heartRateLabel.text = [NSString stringWithFormat:@"%d bpm",number];
//        }];
//    }
//}
//
//- (void)unableHeart
//{
//    [[CositeaBlueTooth sharedInstance] closeActualHeartRate];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [_timer invalidate];
//    _timer = nil;
//    [self unableHeart];
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}
//
//
//- (BOOL)isToday
//{
//    return _seconds == _dateSeconds;
//}
//
//
//- (void)upDataUIWithDic:(NSDictionary *)dic
//{
//    if (dic.allKeys.count != 0)
//    {
//        [self.detailTableView headerEndRefreshing];
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
//        NSNumber *activeTime = dic[@"TotalDataActivityTime_DayData"];
//        NSNumber *costs = dic[@"TotalCosts_DayData"];
//        NSNumber *distance = dic[@"TotalMeters_DayData"];
//        NSNumber *steps = dic[@"TotalSteps_DayData"];
//        NSString *distansUnit;
//        if (kState == UnitStateBritishSystem)
//        {
//            distansUnit = @"mile";
//            int intDistance = [distance intValue];
//            _distanceLabel.text = [NSString stringWithFormat:@"%.2f%@",intDistance/1609.344,distansUnit];
//        }
//        else
//        {
//            distansUnit = @"km";
//            _distanceLabel.text = [NSString stringWithFormat:@"%.2f%@",[distance intValue]/1000.,distansUnit];
//        }
//        _nowStepLabel.attributedText = [self makeAttributedStringWithString:[NSString stringWithFormat:@"%@%@",steps.description,NSLocalizedString(@"步", nil)] andLength:steps.description.length];
//        _costLabel.text = [NSString stringWithFormat:@"%@ kcal",costs];
//        _activTime.text = [NSString stringWithFormat:@"%dh%dmin",[activeTime intValue]/60,[activeTime intValue]%60];
//        float stepPlan = [dic[@"stepsPlan"] floatValue];
//        int intStep = [steps intValue];
//        _completLabel.text = [NSString stringWithFormat:@"%.f%%",intStep/stepPlan*100];
//        _targetValue.text = [NSString stringWithFormat:@"%@%.0f%@",NSLocalizedString(@"目标:", nil),stepPlan,NSLocalizedString(@"步", nil)];
//    }
//    else
//    {
//        NSString *distansUnit;
//        if (kState == UnitStateBritishSystem)
//        {
//
//            distansUnit = @"mile";
//        }
//        else
//        {
//            distansUnit = @"km";
//        }
//        _distanceLabel.text = [NSString stringWithFormat:@"0.00%@",distansUnit];
//        _nowStepLabel.attributedText = [self makeAttributedStringWithString:[NSString stringWithFormat:@"%d%@",0,NSLocalizedString(@"步", nil)] andLength:1];
//        _costLabel.text = [NSString stringWithFormat:@"%d kcal",0];
//        _activTime.text = [NSString stringWithFormat:@"%dh%dmin",0,0];
//        _completLabel.text = [NSString stringWithFormat:@"%.f%%",0.0];
//    }
//}
//
///**
// *  需要修改！！！
// */
//
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
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self hiddenDateBackView];
//
//}
//
//#pragma mark - 按钮事件
//
//
//- (IBAction)setTaget:(id)sender
//{
//    TargetViewController *tagetVC = [TargetViewController new];
//    [self.navigationController pushViewController:tagetVC animated:YES];
//}
//
//
//
//- (IBAction)detailAction:(UIButton *)sender
//{
//    DayDetailViewController *dayDetailVC = [[DayDetailViewController alloc]init];
//    dayDetailVC.second = self.dateSeconds;
//    [self.navigationController pushViewController:dayDetailVC animated:YES];
//}
//
//- (IBAction)showLeftVC:(id)sender
//{
////    YRSideViewController *sideVC = [self getSideVC];
////    [sideVC showLeftViewController:YES];
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//
//}
//
//- (IBAction)trendAction:(id)sender
//{
//    TrendViewController *trendVC = [TrendViewController new];
//    [self.navigationController pushViewController:trendVC animated:YES];
//}
//
//
//- (IBAction)shareAction:(id)sender
//{
//    [self shareVC];
//}
//
//- (IBAction)leftAction:(id)sender
//{
//    self.dateSeconds -= KONEDAYSECONDS;
//}
//
//- (IBAction)rightAction:(id)sender
//{
//    if (_dateSeconds == _seconds)
//    {
//        return;
//    }
//    self.dateSeconds += KONEDAYSECONDS;
//}
//- (IBAction)datePickAction:(id)sender
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
//        NSDate* minDate = [formatter dateFromString:string];
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
//}
//
//- (void)dateSureClick
//{
//    NSDate *pickDate = _datePicker.date;
//    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
//    [formates setDateFormat:@"yyyy/MM/dd"];
//    NSString *dayString = [formates stringFromDate:pickDate];
//    self.dateSeconds = [[TimeCallManager getInstance] getSecondsWithTimeString:dayString andFormat:@"yyyy/MM/dd"];
//    [self hiddenDateBackView];
//}
//
//- (void)setDateSeconds:(int)dateSeconds
//{
//    if (_dateSeconds != dateSeconds)
//    {
//        if (_seconds != dateSeconds)
//        {
//            [self.detailTableView setHeaderHidden:YES];
//            if (_timer)
//            {
//                [_timer invalidate];
//                _timer = nil;
//            }
//            [self unableHeart];
//            _heartRateLabel.text = @"-- bpm";
//            _targetBtn.hidden = YES;
//            _targetTip.hidden = YES;
//        }
//        else
//        {
//            [self.detailTableView setHeaderHidden:NO];
//            if (_timer == nil)
//            {
//                _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(reloadBlueToothData) userInfo:nil repeats:YES];
//            }
//
//            [self enableHeart];
//            _targetBtn.hidden = NO;
//            _targetTip.hidden = NO;
//        }
//       
//        _dateSeconds = dateSeconds > _seconds?_seconds:dateSeconds;
//    
//        _dateLabel.text = [self changeDateTommddeWithSeconds:_dateSeconds];
//
//        _detailArray = [[NSMutableArray alloc]initWithArray:[[SQLdataManger getInstance]queryActualTimeListWithDay:self.dateSeconds]];
//        
//        NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:self.dateSeconds];
//        [self upDataUIWithDic:dic];
//        _detailTableView.contentOffset = CGPointMake(0, 0);
//        [_detailTableView reloadData];
//
//    }
//}
//
//- (NSString *)changeDateTommddeWithSeconds:(int)seconds
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    
//    if ([self isToday])
//    {
//        [dateFormatter setDateFormat:@"MM.dd  "];
//        NSString *dateString = [dateFormatter stringFromDate:date];
//        return [NSString stringWithFormat:@"%@%@",dateString,NSLocalizedString(@"今天", nil)];
//    }
//    [dateFormatter setDateFormat:@"MM.dd  E"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    return [NSString stringWithFormat:@"%@",dateString];
//}
//
//#pragma mark -- 血压血氧页面
//- (NSArray *)UUChart_xLableArray:(UUChart *)chart
//{
//    return [NSArray arrayWithObjects:@"",@"",@"",@"",@"",nil];
//}
//
////数值多重数组
//- (NSArray *)UUChart_yValueArray:(UUChart *)chart
//{
//    return @[[NSArray arrayWithObjects:@"125.00",@"130.00",@"113.00"@"128.00",@"125.00",@"125.00",@"130.00",@"113.00"@"128.00",@"125.00",@"125.00",@"130.00",@"113.00"@"128.00",@"125.00",nil],[NSArray arrayWithObjects:@"90.00",@"80.00",@"75.00",@"78.00",@"88.00",@"125.00",@"130.00",@"113.00"@"128.00",@"125.00",@"125.00",@"130.00",@"113.00"@"128.00",@"125.00",nil]];
//}
//
//- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
//{
//    return YES;
//}
//
////显示范围
//- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
//{
//    return CGRangeMake(170, 50);
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
