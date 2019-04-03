//
//  HeartRateView.m
//  Wukong
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "HeartRateView.h"
#import "HeartRateDetailViewController.h"
#import "SleepTool.h"

#import "SetBloodOxygenView.h"

@interface HeartRateView ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,HeartRateCircleViewDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;

@property (nonatomic, strong) NSTimer *timer;
//当前心率
@property (nonatomic, assign) NSInteger nowHeartRate;

@end

@implementation HeartRateView

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
//    [self pilaoQushi];
    [self requestGETWarning];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [self setupView];
        [[PSDrawerManager instance] beginDragResponse];
        [BlueToothManager getInstance].delegate = self;
        [PZBlueToothManager sharedInstance].delegate = self;
        [self childrenTimeSecondChanged];
        [self setBlocks];
        [self getHomeData];
    }
    return self;
}

-(void)setupView
{
    [self initPro];
    [self setSleepbackGround];
    [self SLEremindView];
    //实时心率
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNowHeartRate:) name:GetNowHeartRateNotification object:nil];
    //血压疲劳/血氧
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSPOPressure:) name:GetPressureSPO2HRV object:nil];
    //获取平均心率
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvgHeartRate:) name:GetAvgHeartRateNotification object:nil];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(calcBloodPressure) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

//平均心率
- (void)getAvgHeartRate:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    self.nowHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:dic[@"avg"] Unit:@"次/分" WithFont:18];
}
//实时心率
- (void)getNowHeartRate:(NSNotification *)noti{
    NSString *heart = noti.object;
//    self.nowHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:heart Unit:@"bpm" WithFont:18];
    self.circleView.value = heart.floatValue;
    self.nowHeartRate = heart.integerValue;
    
    NSString *tep = @"";
    if ([heart isEqualToString:@"--"]) {
        tep = @"--";
    }else if (heart.integerValue > 80){
        tep = [NSString stringWithFormat:@"%.2f",36.7+(heart.integerValue-80)/40.0];
    }else{
        tep = [NSString stringWithFormat:@"%.2f",36.5+(heart.integerValue-70)/50.0];
    }
//    self.averageHeartRateLabel.text = [NSString stringWithFormat:@"%@°C",tep];
}
//血压疲劳/血氧
- (void)getSPOPressure:(NSNotification *)noti{
//    BloodPressureModel *bloodPre = noti.object;
//    NSAttributedString *sting = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%@/%@",bloodPre.systolicPressure,bloodPre.diastolicPressure] Unit:@"mmhg" WithFont:18];
//    self.bloodPressureLabel.attributedText = sting;
    BloodPressureModel *bloodPre = noti.object;
    self.fatigueLabel.text = [NSString stringWithFormat:@"%@%%",bloodPre.SPO2];
}

//计算血压/心肺功能算法/呼吸率算法 每三分钟计算一次
- (void)calcBloodPressure{
    
    NSInteger sec = [[TimeCallManager getInstance] getNowSecond];
    NSInteger hour = [[[TimeCallManager getInstance] getHourWithSecond:sec] integerValue];
    
    //计算血压
    NSInteger s = 0;
    NSInteger d = 0;
    
    //不同时段男女基础数据不同
    NSInteger jichu = 0;
    if ((hour >= 6 && hour < 10) || (hour >= 16 && hour < 18)) {
        if ([[[HCHCommonManager getInstance] UserGender] isEqualToString:@"1"]){
            //男
            jichu = 60;
        }else{
            //女
            jichu = 65;
        }
    }else{
        if ([[[HCHCommonManager getInstance] UserGender] isEqualToString:@"1"]){
            //男
            jichu = 70;
        }else{
            //女
            jichu = 75;
        }
    }
    
    s = jichu/self.nowHeartRate*(self.nowHeartRate-70)+ [[[HCHCommonManager getInstance] UserSystolicP] integerValue];
    d = jichu/self.nowHeartRate*0.6*(self.nowHeartRate-70) + [[[HCHCommonManager getInstance] UserDiastolicP] integerValue];
    
    NSAttributedString *sting;
    if (s == 0) {
        self.bloodPressureLabel.text = @"--/--";
    }else{
        sting = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld/%ld",s,d] Unit:@"mmHg" WithFont:18];
        self.bloodPressureLabel.attributedText = sting;
    }
    
    //心肺功能算法
//    NSInteger xf = (s+d)*self.nowHeartRate;
//    if (xf == 0){
//        self.nowHeartRateLabel.text = @"--";
//    }else if (xf >= 13000 && xf <= 20000) {
//        //良好
//        self.nowHeartRateLabel.text = @"良好";
//    }else{
//        //异常或风险
//        self.nowHeartRateLabel.text = @"风险";
//    }
    
    
    //呼吸率算法
//    NSInteger hxl = self.nowHeartRate/4;
//    if (hxl == 0){
//        self.averageHeartRateLabel.text = @"--";
//    }else if (hxl >= 12 && hxl <= 20) {
//        //正常
//        self.averageHeartRateLabel.text = @"正常";
//    }else{
//        //异常
//        self.averageHeartRateLabel.text = @"异常";
//    }
}

//计算疲劳趋势
- (void)pilaoQushi{
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay] andFormat:@"yyyy-MM-dd"];
    NSArray *dayArr = [[SQLdataManger getInstance] getHistoryHeartRateWithDate:timeStr];
    
    //今天的心率
    NSInteger v = [self getSleepEndTime:[[TimeCallManager getInstance] getSecondsOfCurDay]];
    //昨天的心率
    NSInteger v1 = [self getSleepEndTime:[[TimeCallManager getInstance] getSecondsOfCurDay]-KONEDAYSECONDS];
    //前天的心率
    NSInteger v2 = [self getSleepEndTime:[[TimeCallManager getInstance] getSecondsOfCurDay]-KONEDAYSECONDS*2];
//    if (v1-v > 5 && v2-v1 >5) {
//        self.fatigueLabel.text = @"疲劳";
//    }else if ((v1-v>5 && v2-v1<5) || (v2-v1>5 && v1-v<3)){
//        self.fatigueLabel.text = @"正常";
//    }else if (v1==v && v==v2){
//        self.fatigueLabel.text = @"正常";
//    }else{
//        self.fatigueLabel.text = @"风险";
//    }
}

-(void)setSleepbackGround
{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@""];
    backImageView.backgroundColor = allColorWhite;
    [self addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 48);
    
    //CGFloat backScrollViewX = 0;
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    [self addSubview:self.backScrollView];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.backgroundColor  = [UIColor clearColor];
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
        [weakSelf SLEdropDownReload];
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    bgView.backgroundColor = kColor(37 ,124 ,255);
    [self.backScrollView addSubview:bgView];
    
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundView];
    
}

#pragma mark   -------- -- 连接状态的提示
-(void)SLEremindView
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SLEconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(SLErefreshAlertView) name:@"didDisconnectDevice" object:nil];
}

//初始化提醒的view  的 刷新
-(void)SLErefreshAlertView{
    
}

-(void)SLEconnectionFailedAction:(int)isSeek
{
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] == 2)//可用
        {
            if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 1)    //没有找到
            {
                
            }
            else if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 2)   //找到了
            {
            }
        }
        
    }
    else
    {
    }
    
}

#pragma mark -- 内部方法
-(void)initPro
{
    [PZBlueToothManager sharedInstance].delegate = self;
}

- (void)setBlocks
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
        [weakSelf reloadData];
//        [self calcBloodPressure];
    }];
    [BlueToothManager getInstance].delegate = self;
    //解除绑定要回调事件
    
}
//下拉刷新
-(void)SLEdropDownReload
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
        //        [weakSelf reloadData];
        [weakSelf successCallbackSleepData];
    }];
    [self getHomeData];
    [self childrenTimeSecondChanged];
}

- (void)childrenTimeSecondChanged
{
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
        [self.backScrollView headerEndRefreshing];
    }
    if (kHCH.selectTimeSeconds != kHCH.todayTimeSeconds)
    {
        _targetBtn.userInteractionEnabled = NO;
    }
    else
    {
        _targetBtn.userInteractionEnabled = YES;
    }
    
    [self reloadData];
}

-(void)successCallbackSleepData
{
    [self SLErefreshSucc];
    [self reloadData];
}
- (void)reloadData;
{
    [self.backScrollView headerEndRefreshing];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    [self sleepDrawWithDictionary];// 睡眠数据
    [HCHCommonManager getAvgHeartRate];
    [self reloadPlan]; // 天总数据
//    [self pilaoQushi];
}
-(void)reloadPlan
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadPlan) object:nil];
    // 天总数据中 - - -- - 目标的下载
    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    if (dic)
    {
        self.circleView.maxValue = 220;
    }
}

#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        //        [self performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}

- (void)setBackgroundView
{
    NSArray *array = @[@"血压",@"血氧",@"平均心率",@"体温"];
    NSArray *leftImageArr = @[@"xueya",@"xueyang",@"shishi",@"tiwen"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((8 + i % 2 * 181) *kX-5,
                                self.backScrollView.height- (29 * kDY)- (100 + 3)*kDY * (i/2 + 1)-30,
                                178 * kX+10,
                                100*kDY);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.tag = 30+i;
        view.userInteractionEnabled = YES;
        [self.backScrollView addSubview:view];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        imageV.image = [UIImage imageNamed:@"xiaokuang"];
        [view addSubview:imageV];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        leftImage.image = [UIImage imageNamed:leftImageArr[i]];
        [view addSubview:leftImage];
        
        UILabel *label = [[UILabel alloc] init];
        //label.backgroundColor = [UIColor redColor];
        label.text = array[i];
        label.font = Font_Normal_String(11);
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, (view.height-30)/2-15, view.width, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertAtion:)];
//        [view addGestureRecognizer:tap];
        
        NSAttributedString *string;
        switch (i) {
            case 0:
            {
                _bloodPressureLabel = [[UILabel alloc] init];
                _bloodPressureLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _bloodPressureLabel.textAlignment = NSTextAlignmentCenter;
                _bloodPressureLabel.text = @"--/--";
                _bloodPressureLabel.textColor = kMainColor;
                [view addSubview:_bloodPressureLabel];
            }
                break;
            case 1:
            {
                _fatigueLabel = [[UILabel alloc] init];
                _fatigueLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _fatigueLabel.textAlignment = NSTextAlignmentCenter;
                _fatigueLabel.textColor = kMainColor;
                _fatigueLabel.text = @"--";
                [view addSubview:_fatigueLabel];
            }
                break;
            case 2:
            {
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"次/分" WithFont:18];
                _nowHeartRateLabel = [[UILabel alloc] init];
                _nowHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _nowHeartRateLabel.attributedText = string;
                _nowHeartRateLabel.textColor = kMainColor;
                _nowHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_nowHeartRateLabel];
            }
                break;
            case 3:
            {
//                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
                _averageHeartRateLabel = [[UILabel alloc] init];
                _averageHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _averageHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                _averageHeartRateLabel.text = @"--";
                _averageHeartRateLabel.textColor = kMainColor;
                [view addSubview:_averageHeartRateLabel];
            }
                break;
            default:
                break;
        }
    }
    
    self.circleView = [[HeartRateCircleView alloc] init];
    self.circleView.frame = CGRectMake(0, 0, MIN(180 * kX, 180 * kDY), MIN(180 * kX, 180 * kDY));
    self.circleView.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circleView.height/2.);
    self.circleView.backgroundColor = [UIColor clearColor];
    
    self.circleView.minValue = 0;
    self.circleView.maxValue = 220;
    self.circleView.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circleView.endAngle = 3./2 * M_PI;
    self.circleView.valueTextColor = [UIColor redColor];
    self.circleView.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circleView.delegate = self;
    self.circleView.value = 0;
    [self.circleView setNeedsDisplay];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.circleView.frame];
    bgView.backgroundColor = allColorWhite;
    bgView.layer.cornerRadius = bgView.width/2.0;
    bgView.layer.masksToBounds = YES;
    [self.backScrollView addSubview:bgView];
    [self.backScrollView addSubview:self.circleView];
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.circleView addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat detailButtonX = 0;
    CGFloat detailButtonY = 0;
    CGFloat detailButtonW = MIN(180 * kX, 180 * kDY) * WidthProportion;
    CGFloat detailButtonH = MIN(180 * kX, 180 * kDY) * HeightProportion;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(200*kX, 30*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.height - 286*kDY);
    [self.backScrollView addSubview:self.targetBtn];
    [self.targetBtn setTitle:[NSString stringWithFormat:@"血压/血糖校准设置"] forState:UIControlStateNormal];
    [self.targetBtn setImage:[UIImage imageNamed:@"jiaozhun"] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *
 查询当前血压
 */
-(void)sleepDrawWithDictionary{
}

-(void)refreshing
{
    if (self.rateReloadViewBlock) {
        self.rateReloadViewBlock(NSLocalizedString(@"DataSyn", nil));
    }
}
-(void)SLErefreshSucc
{
    if (self.rateReloadViewBlock) {
        self.rateReloadViewBlock(NSLocalizedString(@"syncFinish", nil));
    }
}
-(void)SLErefreshFail
{
    if (self.rateReloadViewBlock) {
        self.rateReloadViewBlock(NSLocalizedString(@"synchronizationFailure", nil));
    }
}

#pragma mark -- button方法
- (void)targetBtnAction:(UIButton *)button{
    [SetBloodOxygenView bloodOxygenView];
}

- (void)detailButtonAction:(UIButton *)button{
    HeartRateDetailViewController *heartDetailVC = [[HeartRateDetailViewController alloc] init];
    heartDetailVC.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:heartDetailVC animated:YES];
}
- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self SLErefreshFail];
}

//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

//获取最后一个心率值
- (NSInteger)getSleepEndTime:(NSInteger)time{
    NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:time - KONEDAYSECONDS];
    NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    NSMutableArray *sleepArray = [NSMutableArray array];
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:detailDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    
    sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
    int nightBeginTime = 0;
    int nightEndTime = 0;
    BOOL isBegin = NO;
    for (int i = 0; i < sleepArray.count; i ++)
    {
        int sleepState = [sleepArray[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            nightEndTime += 1;
        }
    }
    
    return [self drawNightHeartViewWithBeginTime:nightBeginTime EndTime:nightEndTime];
}

- (NSInteger)drawNightHeartViewWithBeginTime:(int)beginTime EndTime:(int)endTime
{
    NSMutableArray *_nightHeartArray = [NSMutableArray array];
    [_nightHeartArray removeAllObjects];
    if (beginTime == endTime)
    {
        return 60;
    }
    beginTime = beginTime*10;
    endTime = endTime *10;
    NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS + 8];
    
    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
    //只是去后面两个小时
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSRange range = NSMakeRange(0, mutableArray.count/3);
    [mutableArray removeObjectsInRange:range];
    
    NSMutableArray *tempArray = [NSMutableArray new];
    if (array && array.count != 0)
    {
        [tempArray addObjectsFromArray:mutableArray];
    }
    else
    {
        for (int i = 0 ; i < 120; i ++) //晚上九点到十二点
        {
            [tempArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    for (int i = 1 ; i < 5; i ++)
    {
        if( i == 4 )
        {   //只是取前十个小时
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            NSMutableArray *mutableArray1 = [NSMutableArray arrayWithArray:array1];
            NSRange range1 = NSMakeRange(mutableArray1.count/ 3, mutableArray1.count/3 *2);
            [mutableArray1 removeObjectsInRange:range1];
            if (array && array.count != 0)
            {
                [tempArray addObjectsFromArray:mutableArray1];
            }
            else
            {
                for (int i = 0 ; i < 60; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
            
        }
        else
        {
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            if (array && array.count != 0&&(!((array.count==1)&&([array[0]isEqualToString:@""]))))
            {
                [tempArray addObjectsFromArray:array];
            }
            else
            {
                for (int i = 0 ; i < 180; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
        }
    }
    
    
    for (int i = beginTime; i < endTime; i ++)
    {
        if(tempArray[i])
        {
            [_nightHeartArray addObject:tempArray[i]];
        }
        else
        {
        }
    }
    return [_nightHeartArray.lastObject integerValue];
}

- (void)requestGETWarning{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETWARNING,TOKEN];
    NSDictionary *para = @{@"UserID":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            NSInteger warnNum = [responseObject[@"data"][@"warnNum"] integerValue];
//            [self.targetBtn setTitle:[NSString stringWithFormat:@"警报次数%ld次",warnNum] forState:UIControlStateNormal];
        }else{
        }
    }];
}

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"本项功能提供了无仪器监测现场的实时动态血压监测手段，能够有效反映全天血压变化规律。",@"系统初始血压基准值默认为成年人各年龄段正常值，由于个体差异及服药控制等原因出现数值不准确者，请点击侧边栏图标-点击头像图标，进入个人资料编辑页面，在“基准高压值、基准低压值”中，将数值修改为经医生或血压计测量校准的数值。",@"对于轻度和临界高血压患者，有利于提高检出率；对于高血压患者，有利于进行情绪、运动、饮酒等日常管理，以及指导用药剂量和时间；对判断高血压病人有无靶器官，预防脑卒中以及心、脑、肾高血压继发性疾病有重要意义。",@"本项监测为实时动态监测，每3分钟一次。周期性血压趋势状态请在“健康报告”中查看。"];
            break;
            
        case 31:
            arr = @[@"本项功能连续跟踪采集、分析三天的晨起静息心率数据，提示用户处于何种状态，指导用户进行合理的生活作息节律安排，避免工作劳累、运动过度等，防止连续疲劳造成身体伤害，甚至过劳死的发生。",@"本项监测为连续跟踪监测，每天一次，要求连续佩戴云环三天以上，如系统未采集到连续数据，参数值则显示为“- -”。周期性疲劳趋势状态请在“健康报告”中查看。"];
            break;
            
        case 32:
            arr = @[@"心肺功能最能反映一个人的健康情况，心肺功能检查是心血管和呼吸系统疾病的必要检查之一，尤其对于长期吸烟、慢性咳嗽和咯痰、呼吸困难、在特殊环境中工作、呼吸道疾病等人群具有重要意义。",@"本项监测为实时动态监测，每3分钟一次。周期性心肺功能状态请在“健康报告”中查看。"];
            break;
            
        case 33:
            arr = @[@"呼吸减慢常见于代谢率降低、麻醉过量、休克以及明显颅内压增高等；呼吸增快主要见于肺炎、肺栓塞、胸膜炎、支气管哮喘、充血性心力衰竭、代谢亢进以及神经精神障碍等。",@"本项监测为实时动态监测，每3分钟一次。周期性呼吸频率状态请在“健康报告”中查看。"];
            break;
    }
    [AlertMainView alertMainViewWithArray:arr];
}


- (void)getHomeData{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",GETHOMEDATA,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:uploadUrl ParametersDictionary:@{@"userId":USERID} Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
     {
         
         //                 adaLog(@"  - - - - -开始登录返回");
         
         [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
         
         if (error)
         {
             [self makeCenterToast:@"网络连接错误"];
         }
         else
         {
             int code = [[responseObject objectForKey:@"code"] intValue];
             NSString *message = [responseObject objectForKey:@"message"];
             if (code == 0) {
                 //成功
                 self.nowHeartRateLabel.text = responseObject[@"data"][@"rate"];
                 self.bloodPressureLabel.text = responseObject[@"data"][@"xueya"];
                 self.fatigueLabel.text = responseObject[@"data"][@"xueyang"];
                 self.averageHeartRateLabel.text = responseObject[@"data"][@"tiwen"];
                 
             }else{
                 [self makeCenterToast:message];
             }
         }
     }];
}


@end
