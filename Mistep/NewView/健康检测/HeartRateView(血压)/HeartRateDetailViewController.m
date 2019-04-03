//
//  HeartRateDetailViewController.m
//  Wukong
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "HeartRateDetailViewController.h"

@interface HeartRateDetailViewController ()

@property (strong, nonatomic) UILabel *day220;//day220  多出来的部分

@property (strong, nonatomic) PZPilaoChart *chart;//疲劳视图上成图标

@end

@implementation HeartRateDetailViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.datePickBtn setTitle:@"实时心率" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBlocks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backNavView];
    [self setHeartRate];
    [self reloadBlueToothData];
}

- (void)setBlocks
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        if (number)
        {
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [HCHCommonManager getInstance].isEquipmentConnect = YES;
        }
        else
        {
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
            [HCHCommonManager getInstance].isEquipmentConnect = NO;
        }
    }];
}

- (void)setHeartRate{
    _backScrollView = [[UIScrollView alloc] init];
    _backScrollView.frame = CGRectMake(0, 64, CurrentDeviceWidth, CurrentDeviceHeight - 64 );
    [self.view addSubview:_backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height + 0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    WeakSelf;
    [self.backScrollView addHeaderWithCallback:^{
        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
        {
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf reloadBlueToothData];
        }
        else
        {
            if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
            {
                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            }
            else
            {
                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
            }
            [weakSelf.backScrollView headerEndRefreshing];
        }
    }];
    
    
    self.view.backgroundColor = kColor(233, 243, 250);
    UIView *heartBackView = [[UIView alloc] init];
    heartBackView.backgroundColor = [UIColor whiteColor];
    heartBackView.frame = CGRectMake(10,10, CurrentDeviceWidth - 20 * kX, (_backScrollView.height-30)/2);
    [_backScrollView addSubview:heartBackView];
    
    UILabel *HRButtonView = [[UILabel alloc] init];
    [heartBackView addSubview:HRButtonView];
    HRButtonView.frame = CGRectMake(13 * kX, 10 * kSY, 75 * kX , 25*kSY);
    HRButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    HRButtonView.layer.cornerRadius = HRButtonView.height/2.0;
    HRButtonView.clipsToBounds = YES;
    HRButtonView.backgroundColor = kMainColor;
    HRButtonView.text = @"心率";
    HRButtonView.textAlignment = NSTextAlignmentCenter;
    HRButtonView.textColor = [UIColor whiteColor];
    
    [heartBackView addSubview:self.maxHeartLabel];
    self.maxHeartLabel.text = [NSString stringWithFormat:@"%@ %d",kLOCAL(@"最高心率"),0];
    [self.maxHeartLabel sizeToFit];
    
    [heartBackView addSubview:self.avgHeartLabel];
    self.avgHeartLabel.text = [NSString stringWithFormat:@"%@ %d",kLOCAL(@"平均心率"),0];
    [self.avgHeartLabel sizeToFit];
    
    int heartLabelWidth = MAX(self.maxHeartLabel.width + 20, self.avgHeartLabel.width + 20);
    self.maxHeartLabel.frame = CGRectMake(HRButtonView.right+10, 8 * kSY, heartLabelWidth, 14*kSY);
    self.avgHeartLabel.frame = CGRectMake(HRButtonView.right+10, 26 * kSY, heartLabelWidth, 14*kSY);
    
    
    UIView *heartView = [[UIView alloc] init];
    [heartBackView addSubview:heartView];
    heartView.frame = CGRectMake(0, HRButtonView.bottom + 11, heartBackView.width, heartBackView.height - HRButtonView.bottom - 11);
    [self addHeartLabelTo:heartView];
    
    self.heartScrollView = [[UIScrollView alloc] init];
    self.heartScrollView.frame = CGRectMake(0, 0, heartView.width, heartView.height);
    self.heartScrollView.showsHorizontalScrollIndicator = NO;
    [heartView addSubview:self.heartScrollView];
    
    self.heartChart = [[PZChart alloc] initWithFrame:CGRectMake(0, 0, 0, self.heartScrollView.frame.size.height)];
    [self.heartScrollView addSubview:self.heartChart];
    
    self.pilaoBackView = [[UIView alloc] init];
    self.pilaoBackView.backgroundColor = [UIColor whiteColor];
    self.pilaoBackView.frame = CGRectMake(10,heartBackView.bottom+10, heartBackView.width, heartBackView.height);
    [_backScrollView addSubview:self.pilaoBackView];
    
    [self pilaoView];
    
}

- (void)addHeartLabelTo:(UIView *)view
{
    NSArray *HRAlarmArray = [[NSUserDefaults standardUserDefaults] objectForKey:kHeartRateAlarm];
    int maxHR = 100;
    int minHR = 45;
    if (HRAlarmArray)
    {
        maxHR = [HRAlarmArray[1] intValue];
        minHR = [HRAlarmArray[0] intValue];
    }
    
    UILabel *dayWarningLabel1 = [[UILabel alloc] init];
    dayWarningLabel1.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel1.font = [UIFont systemFontOfSize:12];
    dayWarningLabel1.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    [view addSubview:dayWarningLabel1];
    dayWarningLabel1.frame = CGRectMake(0, 0, view.width, view.height/220 * (220 - maxHR));
    
    
    UILabel *day220 = [[UILabel alloc] init];
    _day220 = day220;
    day220.textColor = [UIColor grayColor];
    day220.text = @"220";
    [day220 sizeToFit];
    day220.font = [UIFont systemFontOfSize:12];
    [view addSubview:day220];
    
    day220.frame = CGRectMake(8, 0 - day220.height/2., day220.width, day220.height);
    
    
    
    UIImageView *lineImageView1 = [[UIImageView alloc] init];
    [view addSubview:lineImageView1];
    lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView1.contentMode = UIViewContentModeScaleToFill;
    lineImageView1.frame = CGRectMake(32, 0, view.width - 32, 1);
    
    UILabel *dayNormalLabel = [[UILabel alloc] init];
    dayNormalLabel.text = NSLocalizedString(@"         正常", nil);
    dayNormalLabel.textColor = [UIColor grayColor];
    dayNormalLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayNormalLabel];
    dayNormalLabel.frame = CGRectMake(0, dayWarningLabel1.bottom, view.width, view.height/220. * (maxHR - minHR));
    
    UILabel *dayMax = [[UILabel alloc] init];
    dayMax.textColor = [UIColor grayColor];
    
    dayMax.text = [NSString stringWithFormat:@"%.d",maxHR];
    [dayMax sizeToFit];
    dayMax.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayMax];
    dayMax.frame = CGRectMake(8, dayWarningLabel1.bottom - 5, dayMax.width, 10);
    
    
    UIImageView *lineImageView2 = [[UIImageView alloc] init];
    [view addSubview:lineImageView2];
    lineImageView2.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView2.contentMode = UIViewContentModeScaleToFill;
    lineImageView2.frame = CGRectMake(32, dayWarningLabel1.bottom, view.width - 32, 1);
    
    
    UILabel *dayWarningLabel2 = [[UILabel alloc] init];
    dayWarningLabel2.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel2.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    dayWarningLabel2.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayWarningLabel2];
    dayWarningLabel2.frame = CGRectMake(0, dayNormalLabel.bottom, view.width, view.height - dayNormalLabel.bottom);
    
    
    UILabel *day50 = [[UILabel alloc] init];
    day50.textColor = [UIColor grayColor];
    day50.text = [NSString stringWithFormat:@"%d",minHR];
    [day50 sizeToFit];
    day50.font = [UIFont systemFontOfSize:12];
    [view addSubview:day50];
    day50.frame = CGRectMake(8, dayNormalLabel.bottom - 5, day50.width, 10);
    
    
    UIImageView *lineImageView3 = [[UIImageView alloc] init];
    [view addSubview:lineImageView3];
    lineImageView3.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView3.contentMode = UIViewContentModeScaleToFill;
    lineImageView3.frame = CGRectMake(32, dayNormalLabel.bottom, view.width - 32, 1);
}

- (void)reloadBlueToothData
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkHourStepsAndCostsWithBlock:^(NSArray *steps, NSArray *costs) {
        [self reloadStepsData];
        [weakSelf.backScrollView headerEndRefreshing];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    }];
    [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
        [self updateLabels];
    }];
    
    [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
        [weakSelf reloadHeartData];
    }];
    [[PZBlueToothManager sharedInstance] checkHRVDataWithHRVBlock:^(int number, NSArray *array)
     {
         if(array)
         {
             [weakSelf reloadStepsData];
         }
     }];
}

- (void)reloadHeartData
{
    int beginTime = 0;//1～8 8个包，一个包3小时
    BOOL stepIsBegin = NO;
    for (int i = 0; i < self.stepsArray.count; i ++)
    {
        int step =[self.stepsArray[i] intValue];
        if (step != 0 && stepIsBegin == NO)
        {
            beginTime = i;
            stepIsBegin = YES;
        }
    }
    int heartBegin = beginTime/3+1;
    int heartEnd = 0;
    if (kHCH.selectTimeSeconds == [[TimeCallManager getInstance] getSecondsOfCurDay])
    {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH"];
        NSString *hourString = [formatter stringFromDate:date];
        heartEnd = [hourString intValue]/3+1;
    }
    else
    {
        heartEnd = 8;
    }
    if (!self.heartsArray)
    {
        self.heartsArray  = [[NSMutableArray alloc] init];
    }
    [self.heartsArray removeAllObjects];
    for (int i = heartBegin; i < heartEnd + 1; i ++)
    {
        NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
        NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
        //        //adaLog(@"array - %@",array);
        if (array)
        {
            [self.heartsArray addObjectsFromArray:array];
        }
    }
    if (self.heartsArray.count != 0)//删除前面无效的心率
    {
        int beginIndex = beginTime%3;
        [self.heartsArray removeObjectsInRange:NSMakeRange(0, beginIndex * 60)];
    }
    
    int maxheart = 0;
    int heartCount = 0;
    int totalHeart = 0;
    
    for (int i = 0 ;  i < self.heartsArray.count; i ++)
    {
        int heart = [self.heartsArray[i] intValue];
        if (maxheart < heart)
        {
            maxheart = heart;
        }
        if (heart != 0 )
        {
            totalHeart += heart;
            heartCount += 1;
        }
    }
    if (heartCount != 0)
    {
        int aveHeart = totalHeart/heartCount;
        _maxHeartLabel.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"最高心率:", nil) ,maxheart];
        _avgHeartLabel.text = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"平均心率:", nil) ,aveHeart];
    }
    else
    {
        _maxHeartLabel.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"最高心率:", nil) ,0];
        _avgHeartLabel.text = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"平均心率:", nil) ,0];
    }
    
    int showBegin = 0;
    int showEnd = 0;
    BOOL isBegin = NO;
    NSMutableArray *showHearArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < self.heartsArray.count; i ++)
    {
        int heart = [self.heartsArray[i] intValue];
        if (heart != 0)
        {
            showEnd = i;
            if (isBegin == NO)
            {
                isBegin = YES;
                showBegin = i;
            }
        }
        if (isBegin)
        {
            [showHearArray addObject:[NSNumber numberWithInt:heart]];
        }
    }
    
    self.heartScrollView.contentSize= CGSizeMake(showEnd - showBegin + 20, self.heartScrollView.frame.size.height);
    for (UILabel *label in self.heartScrollView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            label.hidden = YES;
            [label removeFromSuperview];
        }
    }
    
    for (int i = showBegin ; i < showEnd; i ++)
    {
        if (i % 60 ==0)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (i - showBegin) , self.heartScrollView.frame.size.height - 15 , 43 , 15)];
            label.text = [NSString stringWithFormat:@"%d:00",beginTime + i/60];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            if (_pilaoView) {
                [self.heartScrollView insertSubview:label belowSubview:_pilaoView];
            }
            else
            {
                [self.heartScrollView addSubview:label];
            }
        }
    }
    self.heartChart.heartArray = showHearArray;
#warning  警告  ---   以后这里要改的
}

- (void)reloadStepsData
{
    //    [GCDDelay gcdCancel:self.task];
    NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    NSArray *stepsArray;
    if (!((NSNull *)detailDic[kDayStepsData] == [NSNull null]))
        stepsArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kDayStepsData]];
    if (stepsArray)
    {
        //#warning mark  测试修改
        //        stepsArray = @[@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400"];
        self.stepsArray = stepsArray;
    }
    else
    {
        //           stepsArray = @[@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400"];
        self.stepsArray = nil;
    }
    NSArray *costsArray;
    if (!((NSNull *)detailDic[kDayCostsData] == [NSNull null]))
        costsArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kDayCostsData]];
    if (costsArray)
    {
        self.costsArray = costsArray;//stepsArray;
    }
    else
    {
        self.costsArray = nil;
    }
    NSArray *HRVArray;
    if (!((NSNull *)detailDic[kPilaoData] == [NSNull null]))
        HRVArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kPilaoData]];
    if (HRVArray)
    {
        self.HRVArray = HRVArray;
    }
    else
    {
        self.HRVArray = nil;
    }
}

- (void)updateLabels
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLabels) object:nil];
    self.totalDic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}

- (void)setHRVArray:(NSArray *)HRVArray
{
    if (_HRVArray != HRVArray){
        _HRVArray = HRVArray;
        _chart.pilaoArray = HRVArray;
    }
}

#pragma mark - 懒加载
- (UILabel *)maxHeartLabel
{
    if (!_maxHeartLabel)
    {
        _maxHeartLabel = [[UILabel alloc] init];
        _maxHeartLabel.textColor = [UIColor grayColor];
        _maxHeartLabel.font = Font_Normal_String(11);
    }
    return _maxHeartLabel;
}

- (UILabel *)avgHeartLabel
{
    if (!_avgHeartLabel)
    {
        _avgHeartLabel = [[UILabel alloc] init];
        _avgHeartLabel.textColor = [UIColor grayColor];
        _avgHeartLabel.font = Font_Normal_String(11);
    }
    return _avgHeartLabel;
}

- (UIView *)pilaoView
{
    if (!_pilaoView)
    {
        
        UILabel *HRButtonView = [[UILabel alloc] init];
        [self.pilaoBackView addSubview:HRButtonView];
        HRButtonView.frame = CGRectMake(13 * kX, 10 * kSY, 75 * kX , 25*kSY);
        HRButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        HRButtonView.layer.cornerRadius = HRButtonView.height/2.0;
        HRButtonView.clipsToBounds = YES;
        HRButtonView.backgroundColor = kMainColor;
        HRButtonView.text = @"HRV";
        HRButtonView.textAlignment = NSTextAlignmentCenter;
        HRButtonView.textColor = [UIColor whiteColor];
        
        _pilaoView = [[PZPilaoView alloc] initWithFrame:CGRectMake(0, HRButtonView.bottom+11, self.pilaoBackView.width, self.pilaoBackView.height-HRButtonView.height-22)];
        [self.pilaoBackView addSubview:_pilaoView];
        PZPilaoChart *chart = [[PZPilaoChart alloc] initWithFrame:CGRectMake(_pilaoView.frame.origin.x, 5, _pilaoView.frame.size.width, _pilaoView.frame.size.height - 23)];
        _chart = chart;
        //        chart.backgroundColor = [UIColor greenColor];
        chart.pilaoArray = self.HRVArray;
        [_pilaoView addSubview:chart];
        self.pilaoBackView.layer.masksToBounds = YES;
    }
    return _pilaoView;
}

@end
