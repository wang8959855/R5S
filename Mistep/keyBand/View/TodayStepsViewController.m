#import "TodayStepsViewController.h"
#import "TargetViewController.h"
#import "DayDetailViewController.h"
#import "StepsDetailViewController.h"
#import "SheBeiViewController.h"
#import "TimingUploadData.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"

@interface TodayStepsViewController ()<BlutToothManagerDelegate,LMGaugeViewDelegate,PZBlueToothManagerDelegate>
@property (nonatomic,strong)UIView *maskView;// 挡板
@property (nonatomic,strong)UIButton *mask;
@property (nonatomic,strong)ConnectStateView *conStateView;//提示连接的view
//@property (nonatomic,strong)UIView *connectView;//提示连接的view
//@property (nonatomic,strong)UILabel *connectLabel;//显示连接中。。。的label
//@property (nonatomic,assign)NSInteger connectStringHight;//连接字符串。要求调整高度

@property (nonatomic,strong)UIButton *connectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong)NSString *connectString;//连接字符串。
@property (nonatomic,strong)DoneCustomView *doneView;
@property (nonatomic,strong)NSString *doneString;
@property (nonatomic,strong)UILabel *changLabel;//传递颜色的label

@property (nonatomic,assign)NSInteger connectViewX;     // View 的 frame
@property (nonatomic,assign)NSInteger connectViewY;
@property (nonatomic,assign)NSInteger connectViewW;
@property (nonatomic,assign)NSInteger connectViewH;

@property (nonatomic,strong)NSTimer *refreshConnectTimer;//定时器  刷新界面
@property (nonatomic,strong)UIAlertView *alertView1;//系统异常  的提示
//@property (nonatomic,assign)NSInteger firstRefresh;//第一次进入，只能刷新
@end

@implementation TodayStepsViewController

+ (TodayStepsViewController *)sharedInstance
{
    static TodayStepsViewController * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
- (void)setupView
{
    [self setbackGround];
    [self remindView];
    self.haveTabBar = YES;
//    self.firstRefresh = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [_timer invalidate];
    //    _timer = nil;
//    [self unableHeart];
    //    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [PZBlueToothManager sharedInstance].delegate = self;
    [self connectLastDevice];
    [self childrenTimeSecondChanged];
    //    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setBlocks];
    [self refreshAlertView];    //连接的 提示界面
    self.tabBarController.tabBar.hidden = NO;
//    int qian = [[TimeCallManager getInstance]  getSecondsOfCurDay];
//    int qianT = [[TimeCallManager getInstance] getNowSecond];
//    adaLog(@"qian=%d , qianT=%d",qian,qianT);
//    NSString *str1 = [[TimeCallManager getInstance] getTimeStringWithSeconds:qian andFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *str2 = [[TimeCallManager getInstance] getTimeStringWithSeconds:qianT andFormat:@"yyyy-MM-dd HH:mm:ss"];
//    adaLog(@"str1=%@ , str2=%@",str1,str2);
    
    //    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    //    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //    NSLog(@"dateString:%@",dateString);
}

- (void)setbackGround
{
    
    //    CGFloat backGroudImageViewX = 0 ;
    //    CGFloat backGroudImageViewY = 0 ;
    CGFloat backGroudImageViewW = CurrentDeviceWidth;
    CGFloat backGroudImageViewH = CurrentDeviceHeight - 48;
    UIImageView *backGroudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backGroudImageViewW, backGroudImageViewH)];
    backGroudImageView.image = [UIImage imageNamed:@"HD_background"];
    [self.view addSubview:backGroudImageView];
    [self.view addSubview:self.alphaNavView];
    
    
    CGFloat backScrollViewX = 0 ;
    CGFloat backScrollViewY = 64;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - 64- 48;
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(backScrollViewX,backScrollViewY, backScrollViewW,backScrollViewH);
    [self.view addSubview:self.backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    //    self.backScrollView.bounces = NO;
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        //        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
        //        {
        [weakSelf refreshing];
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
        //            [weakSelf reloadBlueToothData];
        [weakSelf dropDownReloadBlueToothData];
        [weakSelf performSelector:@selector(updataCurrentDay) withObject:nil afterDelay:2.f];
        //        }
        //        else
        //        {
        //            [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
        //            [weakSelf.backScrollView headerEndRefreshing];
        //
        //        }
        //回到今天
        kHCH.selectTimeSeconds = kHCH.todayTimeSeconds;
        [weakSelf timeSecondsChanged];
    }];
    
    // 设置文字
    //    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    //    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    //    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    
    //    设置下方4个view
    NSArray *array = @[@"distance",@"HD_clock",@"HD_HeartRate",@"CaloriesSport"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.58];
        view.frame = CGRectMake((8 + i % 2 * 181) *kX,
                                self.backScrollView.height - (29 * kDY)- (84 + 3)*kDY * (i/2 + 1),
                                178 * kX,
                                84*kDY);
        [self.backScrollView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (view.height-29)/2, 37,29)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:array[i]];
        [view addSubview:imageView];
        
        NSMutableAttributedString *string;
        switch (i) {
            case 0:
            {
                string = [self makeAttributedStringWithnumBer:@"0" Unit:@"km" WithFont:18];
                _distanceLabel = [[UILabel alloc] init];
                _distanceLabel.frame = CGRectMake(imageView.right + 3, imageView.top, view.width - imageView.right-3, 30);
                _distanceLabel.attributedText = string;
                _distanceLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_distanceLabel];
            }
                break;
            case 1:
            {
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:18];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:18]];
                _activeTimeLabel = [[UILabel alloc] init];
                _activeTimeLabel.frame = CGRectMake(imageView.right + 3, imageView.top, view.width - imageView.right-3, 30);
                _activeTimeLabel.attributedText = string;
                _activeTimeLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_activeTimeLabel];
                
            }
                break;
            case 2:
            {
                string = [self makeAttributedStringWithnumBer:@"0" Unit:@"bpm" WithFont:18];
                _heartRateLabel = [[UILabel alloc] init];
                _heartRateLabel.frame = CGRectMake(imageView.right + 3, imageView.top, view.width - imageView.right-3, 30);
                _heartRateLabel.attributedText = string;
                _heartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_heartRateLabel];
            }
                break;
            case 3:
            {
                string = [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
                _caloriesLabel = [[UILabel alloc] init];
                _caloriesLabel.frame = CGRectMake(imageView.right + 3, imageView.top, view.width - imageView.right-3, 30);
                _caloriesLabel.attributedText = string;
                _caloriesLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_caloriesLabel];
            }
                break;
            default:
                break;
        }
        
    }
    
    //    设置目标按钮
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(95*kX, 30*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.backScrollView.height - 256*kDY);
    [self.backScrollView addSubview:self.targetBtn];
    self.targetBtn.layer.borderColor = kColor(31, 31, 31).CGColor;
    self.targetBtn.layer.borderWidth = 1;
    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setImage:[UIImage imageNamed:@"aims"] forState:UIControlStateNormal];
    [self.targetBtn setTitle:@"10000" forState:UIControlStateNormal];
    [self.targetBtn setTitleColor:kColor(31, 31, 31) forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.circle = [[LMGaugeView alloc] init];
    [self.backScrollView addSubview:self.circle];
    self.circle.frame = CGRectMake(0, 0, MIN(223 * kX, 223 * kDY), MIN(223 * kX, 223 * kDY));
    self.circle.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circle.height/2.);
    self.circle.backgroundColor = [UIColor clearColor];
    
    self.circle.minValue = 0;
    self.circle.maxValue = 10000;
    self.circle.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circle.endAngle = 3./2 * M_PI;
    self.circle.ringBackgroundColor = kColor(47, 56, 93);
    self.circle.valueTextColor = [UIColor whiteColor];
    self.circle.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circle.delegate = self;
    self.circle.value = 0;
    self.circle.valueFont  = Font_Normal_String(38);
    [self.circle setNeedsDisplay];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = self.circle.frame;
    [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:detailButton];
    
    
}

#pragma mark -- button方法

- (void)childrenTimeSecondChanged
{
    if (kHCH.selectTimeSeconds != kHCH.todayTimeSeconds)
    {
//        [self unableHeart];
        _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
        _targetBtn.userInteractionEnabled = NO;
    }
    else
    {
        [self.backScrollView setHeaderHidden:NO];
//        [self enableHeart];
        _targetBtn.userInteractionEnabled = YES;
    }
    [self upDataUIWithDic];//刷新数据
    //   用户 上传下行，，查看数据
    //    if([AllTool isDirectUse])
    //    {
    //        //        NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    //        //        if(dic)
    //        //        {
    //        [self upDataUIWithDic];
    //        //        }
    //    }
    //    else
    //    {
    //        //蓝牙没有连接就查询服务器
    //        if ([CositeaBlueTooth sharedInstance].isConnected)
    //        {
    //            [self performSelector:@selector(upDataUIWithDic) withObject:nil afterDelay:1];
    //            NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    //            if(dic)
    //            {
    //                [self upDataUIWithDic];
    //            }
    //            else
    //            {
    //                WeakSelf;
    //                [TimingUploadData  downDayTotalData:^(NSDictionary *dict) {
    //                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDataUIWithDic) object:nil];
    //                    [weakSelf upDataUIWithDic];
    //                } date:kHCH.selectTimeSeconds];
    //            }
    //        }
    //        else
    //        {
    //            [self performSelector:@selector(upDataUIWithDic) withObject:nil afterDelay:1];
    //            WeakSelf;
    //            [TimingUploadData  downDayTotalData:^(NSDictionary *dict) {
    //                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDataUIWithDic) object:nil];
    //                [weakSelf upDataUIWithDic];
    //            } date:kHCH.selectTimeSeconds];
    //        }
    //    }
    
    //WeakSelf;
//    if(self.firstRefresh==0)
//    {
//        [self performSelector:@selector(reloadBlueToothDataFirst) withObject:nil afterDelay:1.0f];
//    }
//    else
//    {
        [self reloadBlueToothData];
//    }
    
    if([self isToday])
    {

        
        int stepsPlan = [HCHCommonManager getInstance].stepsPlan;
        int sleepPlan = [HCHCommonManager getInstance].sleepPlan;
        if (stepsPlan == 0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:10000]  forKey:Steps_PlanTo_HCH];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[HCHCommonManager getInstance] initData];
            stepsPlan = [HCHCommonManager getInstance].stepsPlan;
        }
        if (sleepPlan == 0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:480] forKey:Sleep_PlanTo_HCH];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[HCHCommonManager getInstance] initData];
        }
        
        [self.targetBtn setTitle:[NSString stringWithFormat:@"%d",stepsPlan] forState:UIControlStateNormal];
        self.circle.maxValue = stepsPlan;
    }
    
}

- (void)targetBtnAction:(UIButton *)button
{
    TargetViewController *tagetVC = [TargetViewController new];
    [tagetVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:tagetVC animated:YES];
}

- (void)detailButtonClick
{
    StepsDetailViewController *stepsDetailVC = [[StepsDetailViewController alloc] init];
    stepsDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:stepsDetailVC animated:YES];
}

#pragma mark -- 内部方法

- (void)connectLastDevice
{
    NSString *blueToothUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kLastDeviceUUID];
    if (![CositeaBlueTooth sharedInstance].isConnected) {
        if (blueToothUUID && ![blueToothUUID isEqualToString:@""])
        {
            [[CositeaBlueTooth sharedInstance] connectWithUUID:blueToothUUID];
        }
    }
}

- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self refreshFail];
    //    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}

- (void)setBlocks
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        if (number)
        {
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
            
            [[PZBlueToothManager sharedInstance] changeHeartStateWithState:YES Block:^(int number) {
                if (number == 0)
                {
                    _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
                    return;
                }
                _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number] Unit:@"bpm" WithFont:18];
            }];
        }
        else
        {
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
        }
    }];
    

    
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            [self Connected];
            [weakSelf performSelector:@selector(submitIsConnect) withObject:nil afterDelay:2.0f];
        }
    }];
    
    /* [[CositeaBlueTooth sharedInstance] connectedStateChangedWithBlock:^(int number) {
     //adaLog(@"number = %d",number);
     }];
     [[CositeaBlueTooth sharedInstance]  connectedStateChangedWithBlock:^(int number) {
     
     }];
     */
    //    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkConnectTimeAlert:^(int number) {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID]){
            
            [weakSelf connectionFailedAction:number];
            //要改了
            //[weakSelf timeAlertView];
            
        }
    }];
    
    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
        [weakSelf refreshAlertView];
    }];
    [BlueToothManager getInstance].delegate = self;
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 == %d",number);
        if (number) {
            //[weakSelf submitIsConnect];
            [weakSelf refreshAlertView];
        }
    }];
    [self reloadBlueToothData];
}


- (void)enableHeart
{
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        [[CositeaBlueTooth sharedInstance] openActualHeartRateWithBolock:^(int number) {
//            if (number == 0)
//            {
//                _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
//                return;
//            }
//            _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number] Unit:@"bpm" WithFont:18];
//        }];
//    }
}

- (void)unableHeart
{
//    [[CositeaBlueTooth sharedInstance] closeActualHeartRate];
}

- (void)upDataUIWithDic
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDataUIWithDic) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    //adaLog(@"kHCH.selectTimeSeconds = %d",kHCH.selectTimeSeconds);
    //adaLog(@"todayTimeSeconds = %d",kHCH.todayTimeSeconds);
    //adaLog(@"dic = %@",dic);
    if (dic.allKeys.count != 0)
    {
        [self.backScrollView headerEndRefreshing];
        //[self refreshSucc];
        NSNumber *activeTime = dic[@"TotalDataActivityTime_DayData"];
        NSNumber *costs = dic[@"TotalCosts_DayData"];
        NSNumber *distance = dic[@"TotalMeters_DayData"];
        NSNumber *steps = dic[@"TotalSteps_DayData"];
        NSString *distansUnit;
        if (kState == UnitStateBritishSystem)
        {
            distansUnit = @"mile";
            int intDistance = [distance intValue];
            _distanceLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%.3f",intDistance/1609.344] Unit:distansUnit WithFont:18];
        }
        else
        {
            distansUnit = @"km";
            _distanceLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%.3f",[distance intValue]/1000.] Unit:distansUnit WithFont:18];
            
        }
        self.caloriesLabel.attributedText = [self makeAttributedStringWithnumBer:[costs description] Unit:@"kcal" WithFont:18];
        NSMutableAttributedString *activeString = [[NSMutableAttributedString alloc] init];
        activeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",[activeTime intValue]/60] Unit:@"h" WithFont:18];
        [activeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",[activeTime intValue]%60] Unit:@"min" WithFont:18]];
        self.activeTimeLabel.attributedText = activeString;
        int stepPlan = [dic[@"stepsPlan"] intValue];
        
        [self.targetBtn setTitle:[NSString stringWithFormat:@"%d",stepPlan] forState:UIControlStateNormal];
        self.circle.maxValue = stepPlan;
        self.circle.value = [steps intValue];
        
    }
    else
    {
        NSString *distansUnit;
        if (kState == UnitStateBritishSystem)
        {
            distansUnit = @"mile";
        }
        else
        {
            distansUnit = @"km";
        }
        _distanceLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:distansUnit WithFont:18];
        self.circle.value = 0;
        self.caloriesLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
        
        NSMutableAttributedString *activeString = [[NSMutableAttributedString alloc] init];
        activeString = [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:18];
        [activeString appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:18] ];
        self.activeTimeLabel.attributedText = activeString;
        _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
    }
}

//从手环请求今天的总数据 -- 第一次
//- (void)reloadBlueToothDataFirst
//{
//    WeakSelf;
//    [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
//        if (![weakSelf isToday])
//        {
//            return;
//        }
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endHeadRefresh) object:nil];
//        
//        [weakSelf upDataUIWithDic];
//    }];
//    self.firstRefresh++;
//}

//从手环请求今天的总数据
- (void)reloadBlueToothData
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadBlueToothData) object:nil];
    adaLog(@" - - - - -- 刷新数据");
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {
        
        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
            if (![weakSelf isToday])
            {
                return;
            }
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endHeadRefresh) object:nil];
            [weakSelf upDataUIWithDic];
            
        }];
    }
    
}
//从手环请求今天的总数据    - - --下拉刷新数据
- (void)dropDownReloadBlueToothData
{
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
        [self.backScrollView headerEndRefreshing];
    }
//    WeakSelf;
//    if ([CositeaBlueTooth sharedInstance].isConnected)
//    {
//        
//        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
//            if (![weakSelf isToday])
//            {
//                return;
//            }
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endHeadRefresh) object:nil];
//            [weakSelf upDataUIWithDic];
//            [weakSelf updataCurrentDay];
//        }];
//    }
    
}

//上传所有当天数据
-(void)updataCurrentDay
{
    //[[PZBlueToothManager sharedInstance]setBlocks];
    //[[CositeaBlueTooth sharedInstance]coreBlueRefresh];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updataCurrentDay) object:nil];
    [self endHeadRefresh];
    //    [self performSelector:@selector(endHeadRefresh) withObject:nil afterDelay:1.0f]; //1秒就可以了
    [self performSelector:@selector(updataCur) withObject:nil afterDelay:3.0f]; //1秒就可以了
}


//停止头部的刷新
-(void)endHeadRefresh
{
    [self.backScrollView headerEndRefreshing];
    [self refreshSucc];
    
    //    [self upDataUIWithDic];
}
-(void)updataCur
{
    [[TimingUploadData sharedInstance] CurrentDayUpData];
}
//-(void)timeAlertView
//{
//    //最底下View
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight)];
//    self.maskView = maskView;
//    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
//    //蒙板
//    UIButton *mask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight)];
//    mask.center = maskView.center;
//    self.mask = mask;
//    [mask addTarget:self action:@selector(mainSubmitClick) forControlEvents:UIControlEventTouchUpInside];
//    mask.backgroundColor = [UIColor blackColor];  mask.alpha = 0.3;
//    [maskView addSubview:mask];
//
//
//    CGFloat alertViewW = CurrentDeviceWidth - 40*WidthProportion;
//    CGFloat alertViewH = 200*HeightProportion;
//    CGFloat alertViewY = - alertViewH;
//    CGFloat alertViewX = (CurrentDeviceWidth - alertViewW)/2;
//    UIView *alertView = [[UIView alloc]init];
//    alertView.backgroundColor = [UIColor whiteColor];
//    [maskView addSubview:alertView];
//    alertView.layer.cornerRadius = 10;
//
//
//
//    CGFloat titleLabelX = 20*WidthProportion;
//    CGFloat titleLabelH = 30*HeightProportion;
//    CGFloat titleLabelY = 20*HeightProportion;
//    CGFloat titleLabelW = alertViewW - titleLabelX;
//    UILabel *titleLabel = [[UILabel alloc]init];
//    [alertView addSubview:titleLabel];
//    titleLabel.text = NSLocalizedString(@"连接超时！请确认：", nil) ;
//    titleLabel.font = [UIFont systemFontOfSize:16];
//    titleLabel.numberOfLines = 0;
//    NSDictionary *dicTitleLabel = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
//    CGSize sizeTitleLabel = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicTitleLabel context:nil].size;
//    titleLabelH = sizeTitleLabel.height;
//    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
//
//
//    CGFloat oneLabelX = 40*WidthProportion;
//    CGFloat oneLabelH = 20*HeightProportion;
//    CGFloat oneLabelY = CGRectGetMaxY(titleLabel.frame)+10*HeightProportion;
//    CGFloat oneLabelW = alertViewW - oneLabelX;
//    UILabel *oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(oneLabelX, oneLabelY, oneLabelW, oneLabelH)];
//    [alertView addSubview:oneLabel];
//    oneLabel.text = NSLocalizedString(@"1、设备已开机",nil);
//
//    CGFloat twoLabelX = oneLabelX;
//    CGFloat twoLabelH = oneLabelH;
//    CGFloat twoLabelY = CGRectGetMaxY(oneLabel.frame);
//    CGFloat twoLabelW = alertViewW - twoLabelX;
//    UILabel *twoLabel = [[UILabel alloc]init];
//    [alertView addSubview:twoLabel];
//    twoLabel.text = NSLocalizedString(@"2、设备未被连接",nil);
//    twoLabel.numberOfLines = 0;
//    NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
//    CGSize size1 = [twoLabel.text boundingRectWithSize:CGSizeMake(twoLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
//    twoLabelH = size1.height;
//    twoLabel.frame = CGRectMake(twoLabelX, twoLabelY, twoLabelW, twoLabelH);
//
//    //
//    UILabel *qunrenLabel = [[UILabel alloc] init];
//    [alertView addSubview:qunrenLabel];
//    qunrenLabel.text = NSLocalizedString(@"3、设备在可连接范围内（10米以内）", nil);
//    qunrenLabel.numberOfLines = 0;
//    CGFloat qunrenLabelX = twoLabelX;
//    CGFloat qunrenLabelY = CGRectGetMaxY(twoLabel.frame);
//    CGFloat qunrenLabelW = alertViewW - qunrenLabelX;
//    CGFloat qunrenLabelH = twoLabelH;
//    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
//    CGSize size2 = [qunrenLabel.text boundingRectWithSize:CGSizeMake(qunrenLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
//    qunrenLabelH = size2.height;
//    qunrenLabel.frame = CGRectMake(qunrenLabelX, qunrenLabelY, qunrenLabelW, qunrenLabelH);
//    //    qunrenLabel.backgroundColor = [UIColor redColor];
//
//    alertViewH = CGRectGetMaxY(qunrenLabel.frame)+50*HeightProportion;
//    alertView.frame = CGRectMake(alertViewX, alertViewY, alertViewW, alertViewH);
//
//    CGFloat submitBtnH = 40*HeightProportion;
//    CGFloat submitBtnY = alertViewH - submitBtnH;// - 10*HeightProportion;
//    CGFloat submitBtnW = alertViewW;//100*WidthProportion;
//    CGFloat submitBtnX = 0;//(alertViewW - submitBtnW)/2;
//    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [alertView addSubview:submitBtn];
//    submitBtn.frame = CGRectMake(submitBtnX,submitBtnY,submitBtnW,submitBtnH);
//    [submitBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
//    [submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    submitBtn.layer.borderWidth = 0.5;
//    submitBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [submitBtn addTarget:self action:@selector(mainSubmitClick) forControlEvents:UIControlEventTouchUpInside];
//    //    [maskView bringSubviewToFront:alertView];
//    [UIView animateWithDuration:0.6f animations:^{
//        alertView.center = maskView.center;
//    }];
//
//}
-(void)mainSubmitClick
{
    //adaLog(@"确定");
    [UIView animateWithDuration:0.6 animations:^{
        self.maskView.frame = CGRectMake(0, -CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
        self.mask.frame = CGRectMake(0, -CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
        
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.mask removeFromSuperview];
        self.maskView = nil;
        self.mask = nil;
    }];
    
}

//connectStringHight
//初始化提醒的view
-(void)remindView
{
    _changLabel = [[UILabel alloc]init];
    
    [self.view addSubview:self.doneView];
    self.doneView.alpha = 0;
    
    _conStateView = [[ConnectStateView alloc]init];
    [self.view addSubview:_conStateView];
    CGFloat conStateViewX = 0;
    CGFloat conStateViewY = 64;
    CGFloat conStateViewW = CurrentDeviceWidth;
    CGFloat conStateViewH = 60*HeightProportion;
    _conStateView.alpha = 0;
    _conStateView.frame = CGRectMake(conStateViewX,conStateViewY,conStateViewW,conStateViewH);
    
    
    
    _connectButton = [[UIButton alloc]init];
    //    _connectButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [_conStateView addSubview:_connectButton];
    _connectButton.frame = CGRectMake(0, 0, conStateViewW, conStateViewH);
    [_connectButton addTarget:self action:@selector(connectButtonToshebei) forControlEvents:UIControlEventTouchUpInside];
    _connectButton.sd_layout
    .leftSpaceToView(_conStateView,0)
    .topSpaceToView(_conStateView,0)
    .rightSpaceToView(_conStateView,0)
    .bottomSpaceToView(_conStateView,0);
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(connectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(refreshAlertView) name:@"didDisconnectDevice" object:nil];
    
}
//初始化提醒的view  的 刷新
-(void)refreshAlertView{
    self.connectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        if(!([self.doneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.doneView.alpha == 1))
        {
            self.backScrollView.frame = CGRectMake(0,64,self.backScrollView.width, self.backScrollView.height);
        }
        self.conStateView.alpha = 0;
    }
    else
    {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            if(kHCH.BlueToothState == CBManagerStatePoweredOn)
            {
                if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] != 2)//可用
                {
                    self.connectString = NSLocalizedString(@"连接中...", nil);
                }
            }
            else
            {
                self.connectString  = NSLocalizedString(@"bluetoothNotOpen", nil);
            }
        }
        else
        {
            //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
            self.connectString = NSLocalizedString(@"未绑定", nil);
            self.connectButton.userInteractionEnabled = YES;
            self.conStateView.labeltextColor = [UIColor blueColor];
        }
        self.conStateView.alpha = 1;
    }
    
}

-(void)connectionFailedAction:(int)isSeek
{
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        
        if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] == 2)//可用
        {
            if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 1)    //没有找到
            {
                //                    self.connectStringHight = 2;
                self.connectString = NSLocalizedString(@"pleaseWakeupDeviceNotfound", nil);
                
            }
            else if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 2)   //找到了
            {
                //                    self.connectStringHight = 2;
                self.connectString = NSLocalizedString(@"bluetoothConnectionFailed", nil);
            }
        }
    }
    else
    {
        //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
        self.connectString = NSLocalizedString(@"未绑定", nil);
        self.connectButton.userInteractionEnabled = YES;
        self.conStateView.labeltextColor = [UIColor blueColor];
    }
    
}

-(void)connectButtonToshebei
{
    SheBeiViewController *shebeiVC = [SheBeiViewController sharedInstance];
    shebeiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shebeiVC animated:YES];
}
-(void)refreshConnect
{
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {   [self Connected];
        [weakSelf performSelector:@selector(submitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)refreshSELF
{
    [self refreshConnect];
}

#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        [self Connected];
        [self performSelector:@selector(submitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)Connected
{
    self.connectString = NSLocalizedString(@"connectSuccessfully", nil);
    [self performSelector:@selector(reloadBlueToothData) withObject:nil afterDelay:2.f];
}
-(void)submitIsConnect
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(submitIsConnect) object:nil];
    self.conStateView.alpha = 0;
    if(!([self.doneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.doneView.alpha == 1))
    {
        self.backScrollView.frame = CGRectMake(0,64,self.backScrollView.width, self.backScrollView.height);
    }
    
}

-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    [self performSelector:@selector(refreshAlertView) withObject:nil afterDelay:1.f];
    
}
- (void)blueToothManagerIsConnected:(BOOL)isConnected connectPeripheral:(CBPeripheral *)peripheral
{
    //adaLog(@"isConnected  - -- %d",isConnected);
    
    if (isConnected)
    {
        [self Connected];
        [self performSelector:@selector(submitIsConnect) withObject:nil afterDelay:3.0f];
    }
    else
    {
        [self refreshAlertView];
    }
    
}
#pragma mark -- 圆环代理

- (UIColor *)gaugeView:(LMGaugeView *)gaugeView ringStokeColorForValue:(CGFloat)value
{
    return kColor(89, 253, 214);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 给客户的友情提示
/**
 提示重新刷新   --再下一次数据
 */
-(void)remindRedownData
{
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    [self addActityTextInView:window text:NSLocalizedString(@"服务器异常", nil) deleyTime:1.0f];
    
    
    //    UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"服务器异常", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    //    _alertView1 = alertView1;
    //    [alertView1 show];
    //    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.0f];
}
-(void)dismiss:(UIAlertView *)al
{
    if (_alertView1) {
        [_alertView1 dismissWithClickedButtonIndex:[al cancelButtonIndex] animated:YES];
    }
}
/**
 提示没有网络
 */
-(void)remindNotReachable
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self addActityTextInView:window text:NSLocalizedString(@"当前无网络连接", nil) deleyTime:1.0f];
}


-(void)setConnectString:(NSString *)connectString
{
    _connectString = connectString;
    //adaLog(@"-----today -  connectString - %@",connectString);
    self.conStateView.stateString = connectString;
    self.conStateView.labeltextColor = _changLabel.textColor;
    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown3 = [connectString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
    NSInteger height = sizeDown3.height;
    if(height>self.conStateView.height)
    {
        self.conStateView.height =  height;
    }
    if(![connectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
    {
        self.backScrollView.frame = CGRectMake(0,64+self.conStateView.height,self.backScrollView.width, self.backScrollView.height);
    }
}

-(void)refreshing
{
    self.doneString = NSLocalizedString(@"DataSyn", nil);
}

-(void)refreshSucc
{
    self.doneString = NSLocalizedString(@"syncFinish", nil);
}
-(void)refreshFail
{
    self.doneString = NSLocalizedString(@"synchronizationFailure", nil);
}
-(void)hiddenDoneView
{
    self.doneView.alpha = 0;
    [UIView animateWithDuration:1.f animations:^{
        //        self.doneView.hidden = YES;
        self.backScrollView.frame = CGRectMake(0,64,self.backScrollView.width, self.backScrollView.height);
    }];
}
-(DoneCustomView *)doneView
{
    if (!_doneView)
    {
        _doneView = [[DoneCustomView alloc]init];
        _doneView.frame = CGRectMake(0,64, CurrentDeviceWidth,60*HeightProportion);
    }
    return _doneView;
}
-(void)setDoneString:(NSString *)doneString
{
    _doneString = doneString;
    self.doneView.titleString = doneString;
    
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    if (![doneString isEqual:[NSString class]]) {
        return;
    }
    CGSize size2 = [doneString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    
    NSInteger height = size2.height;
    if(height>self.doneView.height)
    {
        self.doneView.height =  height;
    }
    self.backScrollView.frame = CGRectMake(0,64+self.doneView.height,self.backScrollView.width, self.backScrollView.height);
    if (![doneString isEqualToString:NSLocalizedString(@"DataSyn", nil)])
    {
        [self performSelector:@selector(hiddenDoneView) withObject:nil afterDelay:2.f];
    }
    self.doneView.alpha = 1;
}


@end
