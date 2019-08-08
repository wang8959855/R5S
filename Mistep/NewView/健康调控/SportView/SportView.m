//
//  SportView.m
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "SportView.h"
#import "TargetViewController.h"
#import "StepsDetailViewController.h"

@interface SportView ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate>

@property (nonatomic,assign)NSInteger connectViewX;     // View 的 frame
@property (nonatomic,assign)NSInteger connectViewY;
@property (nonatomic,assign)NSInteger connectViewW;
@property (nonatomic,assign)NSInteger connectViewH;

@property (nonatomic,strong)NSTimer *refreshConnectTimer;//定时器  刷新界面
@property (nonatomic,strong)UIAlertView *alertView1;//系统异常  的提示

@end

@implementation SportView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = allColorWhite;
        [[PSDrawerManager instance] beginDragResponse];
        [PZBlueToothManager sharedInstance].delegate = self;
        //    [self connectLastDevice];
        [self childrenTimeSecondChanged];
        [self setBlocks];
        [self getHomeData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDataUIWithDic) name:@"updateStepAndSleep" object:nil];
    }
    return self;
}

- (void)setupView
{
    [self setbackGround];
    [self remindView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNowHeartRate:) name:GetNowHeartRateNotification object:nil];
    //获取平均心率
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvgHeartRate:) name:GetAvgHeartRateNotification object:nil];
}
//平均心率
- (void)getAvgHeartRate:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    self.activeTimeLabel.attributedText = [self makeAttributedStringWithnumBer:dic[@"avg"] Unit:kLOCAL(@"次/分") WithFont:18];
}

- (void)getNowHeartRate:(NSNotification *)noti{
    NSString *heart = noti.object;
    self.heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:heart Unit:kLOCAL(@"次/分") WithFont:18];
}

- (void)setbackGround
{
    
    //    CGFloat backGroudImageViewX = 0 ;
    //    CGFloat backGroudImageViewY = 0 ;
    CGFloat backGroudImageViewW = CurrentDeviceWidth;
    CGFloat backGroudImageViewH = CurrentDeviceHeight - 48;
    UIImageView *backGroudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backGroudImageViewW, backGroudImageViewH)];
    backGroudImageView.backgroundColor = allColorWhite;
    [self addSubview:backGroudImageView];
    
    
    CGFloat backScrollViewX = 0 ;
    CGFloat backScrollViewY = 64;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.height;
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(backScrollViewX,backScrollViewY, backScrollViewW,backScrollViewH);
    [self addSubview:self.backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    //    self.backScrollView.bounces = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    bgView.backgroundColor = kMainColor;
    [self.backScrollView addSubview:bgView];
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        //        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
        //        {
        [weakSelf refreshing];
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
        [weakSelf dropDownReloadBlueToothData];
        [weakSelf performSelector:@selector(updataCurrentDay) withObject:nil afterDelay:2.f];
        [weakSelf getHomeData];
    }];
    
    //    设置下方4个view
    NSArray *array = @[kLOCAL(@"里程"),kLOCAL(@"卡路里"),kLOCAL(@"实时心率"),kLOCAL(@"平均心率")];
    NSArray *leftImageArr = @[@"licheng--",@"kaluli--",@"shishi",@"pingjun--"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((8 + i % 2 * 181) *kX-5,
                                self.backScrollView.height - (29 * kDY)- (100 + 3)*kDY * (i/2 + 1)-30,
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
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertAtion:)];
//        [view addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        //label.backgroundColor = [UIColor redColor];
        label.text = array[i];
        label.font = Font_Normal_String(13);
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, (view.height-30)/2-15, view.width, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        NSMutableAttributedString *string;
        switch (i) {
            case 0:
            {
                string = [self makeAttributedStringWithnumBer:@"0" Unit:@"km" WithFont:18];
                _distanceLabel = [[UILabel alloc] init];
                _distanceLabel.textColor = kMainColor;
                _distanceLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _distanceLabel.textAlignment = NSTextAlignmentCenter;
                _distanceLabel.attributedText = string;
                _distanceLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_distanceLabel];
            }
                break;
            case 1:
            {
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
                _caloriesLabel = [[UILabel alloc] init];
                _caloriesLabel.textColor = kMainColor;
                _caloriesLabel.textAlignment = NSTextAlignmentCenter;
                _caloriesLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _caloriesLabel.attributedText = string;
                _caloriesLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_caloriesLabel];
                
            }
                break;
            case 2:
            {
                string = [self makeAttributedStringWithnumBer:@"0" Unit:kLOCAL(@"次/分") WithFont:18];
                _heartRateLabel = [[UILabel alloc] init];
                _heartRateLabel.textColor = kMainColor;
                _heartRateLabel.textAlignment = NSTextAlignmentCenter;
                _heartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _heartRateLabel.attributedText = string;
                _heartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_heartRateLabel];
            }
                break;
            case 3:
            {
                string = [self makeAttributedStringWithnumBer:@"0" Unit:kLOCAL(@"次/分") WithFont:18];
                _activeTimeLabel = [[UILabel alloc] init];
                _activeTimeLabel.textAlignment = NSTextAlignmentCenter;
                _activeTimeLabel.textColor = kMainColor;
                _activeTimeLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _activeTimeLabel.attributedText = string;
                _activeTimeLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_activeTimeLabel];
            }
                break;
            default:
                break;
        }
        
    }
    
    self.circle = [[LMGaugeView alloc] init];
    [self.backScrollView addSubview:self.circle];
    self.circle.frame = CGRectMake(0, 0, MIN(203 * kX, 203 * kDY), MIN(203 * kX, 203 * kDY));
    self.circle.center = CGPointMake(CurrentDeviceWidth / 2, 20 * kDY + self.circle.height/2.);
    self.circle.backgroundColor = [UIColor clearColor];
    
    self.circle.minValue = 0;
    self.circle.maxValue = 10000;
    self.circle.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circle.endAngle = 3./2 * M_PI;
    self.circle.ringBackgroundColor = [UIColor whiteColor];
    self.circle.valueTextColor = [UIColor whiteColor];
    self.circle.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circle.value = 0;
    self.circle.valueFont  = Font_Normal_String(38);
    [self.circle setNeedsDisplay];
    
    //    设置目标按钮
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(150*kX, 30*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.circle.bottom+40*kDY);
    [self.backScrollView addSubview:self.targetBtn];
    //    self.targetBtn.layer.borderColor = kMainColor.CGColor;
    //    self.targetBtn.layer.borderWidth = 1;
    //    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:@"10000" Unit:[NSString stringWithFormat:@"(%@)",kLOCAL(@"目标步数")] WithFont:18] forState:UIControlStateNormal];
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textColor = allColorWhite;
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
        _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:kLOCAL(@"次/分") WithFont:18];
        _targetBtn.userInteractionEnabled = NO;
    }
    else
    {
        [self.backScrollView setHeaderHidden:NO];
        //        [self enableHeart];
        _targetBtn.userInteractionEnabled = YES;
    }
    [self upDataUIWithDic];//刷新数据
    [self reloadBlueToothData];
    
}

- (void)targetBtnAction:(UIButton *)button
{
    TargetViewController *tagetVC = [TargetViewController new];
    [tagetVC setHidesBottomBarWhenPushed:YES];
    [self.controller.navigationController pushViewController:tagetVC animated:YES];
}

- (void)detailButtonClick
{
    StepsDetailViewController *stepsDetailVC = [[StepsDetailViewController alloc] init];
    stepsDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.controller.navigationController pushViewController:stepsDetailVC animated:YES];
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
}

- (void)setBlocks
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        if (number)
        {
            [[PZBlueToothManager sharedInstance] changeHeartStateWithState:YES Block:^(int number) {
                if (number == 0)
                {
                    self.heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:kLOCAL(@"次/分") WithFont:18];
                    return;
                }
                self.heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number] Unit:kLOCAL(@"次/分") WithFont:18];
            }];
        }
        else
        {
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
    [self reloadBlueToothData];
}

- (void)enableHeart
{
}

- (void)unableHeart
{
    //    [[CositeaBlueTooth sharedInstance] closeActualHeartRate];
}

- (void)upDataUIWithDic
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDataUIWithDic) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:[[TimeCallManager getInstance] getSecondsOfCurDay]];
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
        [activeString appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:kLOCAL(@"次/分") WithFont:18]];
//        self.activeTimeLabel.attributedText = activeString;
        int stepPlan = [dic[@"stepsPlan"] intValue];
        
        [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",stepPlan] Unit:[NSString stringWithFormat:@"(%@)",kLOCAL(@"目标步数")] WithFont:18] forState:UIControlStateNormal];
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
        activeString = [self makeAttributedStringWithnumBer:@"--" Unit:kLOCAL(@"次/分") WithFont:18];
        self.activeTimeLabel.attributedText = activeString;
        _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:kLOCAL(@"次/分") WithFont:18];
    }
}

//从手环请求今天的总数据
- (void)reloadBlueToothData
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadBlueToothData) object:nil];
    adaLog(@" - - - - -- 刷新数据");
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {
        
        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endHeadRefresh) object:nil];
            [weakSelf upDataUIWithDic];
            
        }];
    }
    
}
//从手环请求今天的总数据    - - --下拉刷新数据
- (void)dropDownReloadBlueToothData
{
    [HCHCommonManager getAvgHeartRate];
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
        [self.backScrollView headerEndRefreshing];
    }
        WeakSelf;
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
    
            [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endHeadRefresh) object:nil];
                [weakSelf upDataUIWithDic];
                [weakSelf updataCurrentDay];
            }];
        }
    
}

//上传所有当天数据
-(void)updataCurrentDay
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updataCurrentDay) object:nil];
    [self endHeadRefresh];
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

-(void)mainSubmitClick
{
    
}

//connectStringHight
//初始化提醒的view
-(void)remindView
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(connectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(refreshAlertView) name:@"didDisconnectDevice" object:nil];
    
}
//初始化提醒的view  的 刷新
-(void)refreshAlertView{
}

-(void)connectionFailedAction:(int)isSeek
{
    
}

-(void)connectButtonToshebei
{
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark -- 给客户的友情提示
/**
 提示重新刷新   --再下一次数据
 */
-(void)remindRedownData
{
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
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [self addActityTextInView:window text:NSLocalizedString(@"当前无网络连接", nil) deleyTime:1.0f];
}


-(void)setConnectString:(NSString *)connectString
{
}

-(void)refreshing
{

}

-(void)refreshSucc
{
    
}
-(void)refreshFail
{
    
}
-(void)hiddenDoneView
{
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

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"从监测起始至目前的步行里程总数。"];
            break;
            
        case 31:
            arr = @[@"从监测起始至目前的卡路里消耗总数。"];
            break;
            
        case 32:
            arr = @[@"以秒为单位的实时心率数值。"];
            break;
            
        case 33:
            arr = @[@"从监测起始至目前的心率平均数值。"];
            break;
    }
    [AlertMainView alertMainViewWithArray:arr];
}

- (void)getHomeData{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",GETHOMEDATA,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:uploadUrl ParametersDictionary:@{@"userId":USERID,@"apptime":[[TimeCallManager getInstance] getCurrentAreaTime]} Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
     {
         
         //                 adaLog(@"  - - - - -开始登录返回");
         
         [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
         
         if (error)
         {
             [self makeCenterToast:kLOCAL(@"网络连接错误")];
         }
         else
         {
             int code = [[responseObject objectForKey:@"code"] intValue];
             NSString *message = [responseObject objectForKey:@"message"];
             if (code == 0) {
                 //成功
                 self.activeTimeLabel.text = responseObject[@"data"][@"rate"];
             }else{
                 [self makeCenterToast:message];
             }
         }
     }];
}

@end

