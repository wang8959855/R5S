//
//  TodaySleepViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "TodaySleepViewController.h"
#import "TargetViewController.h"
#import "SleepTool.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"
#import "SheBeiViewController.h"
#import "AlertMainView.h"

#import <WebKit/WebKit.h>


@interface TodaySleepViewController ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,NightCircleViewDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;
//@property (nonatomic,strong)UIView *connectView;//提示连接的view

@property (nonatomic,strong) ConnectStateView *SLEconStateView;//提示连接的view
@property (nonatomic,strong) UIButton *SLEconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong) NSString *SLEconnectString;//连接字符串。
@property (nonatomic,strong) DoneCustomView *SLEdoneView;
@property (nonatomic,strong) NSString *SLEdoneString;
@property (nonatomic,strong) UILabel *SLEchangLabel;//传递颜色的label

//@property (nonatomic,strong)UIView *backALLView; //背后的所有视图

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *sxiao;

@end

@implementation TodaySleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:refreshButton];
    refreshButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 25, 32, 20, 20);
    [refreshButton setImage:[UIImage imageNamed:@"shuaxin-icon"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 60, 32, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"report1",@"report2",@"report3",@"report4"];
    guide.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guide animated:YES];
}

- (void)reloadWebView{
    //测试
    NSString *root = @"http://test03.lantianfangzhou.com/report/current";
    //生产
//        NSString *root = @"https://rulong.lantianfangzhou.com/report/current";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/r5s/%@/%@/0",root,USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)setupView
{
    [self initPro];
    [self setSleepbackGround];
    [self SLEremindView];
}

-(void)setSleepbackGround{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@""];
    backImageView.backgroundColor = allColorWhite;
    [self.view addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 48);
    
    //CGFloat backScrollViewX = 0;
    CGFloat backScrollViewY = SafeAreaTopHeight;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - SafeAreaTopHeight - SafeAreaBottomHeight;
    
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    [self.view addSubview:self.backScrollView];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.backgroundColor  = [UIColor clearColor];
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        //        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
        //        {
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
        //            [weakSelf childrenTimeSecondChanged];
        [weakSelf SLEdropDownReload];
        //        }
        //        else
        //        {
        //            [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
        //            [weakSelf.backScrollView headerEndRefreshing];
        //        }
//        [weakSelf timeSecondsChanged];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setBackgroundView];
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    
    //测试
    NSString *root = @"http://test03.lantianfangzhou.com/report/current";
    //生产
//    NSString *root = @"https://rulong.lantianfangzhou.com/report/current";
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, backScrollViewW, backScrollViewH)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/r5s/%@/%@/0",root,USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.backScrollView addSubview:self.webView];
    
}
//-(void)testAction
//{
//    // [[CositeaBlueTooth sharedInstance] sendWeather:nil];
//    //    [AllTool startUpData];
//    [[TodayStepsViewController sharedInstance] remindRedownData];
//}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    [self childrenTimeSecondChanged];
    
//    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [self reloadBlueToothDataSleep];
    [self setBlocks];
    [self SLErefreshAlertView];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datePickBtn setTitle:@"报告" forState:UIControlStateNormal];
//    BOOL isalert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAlertRegulation"] boolValue];
//    if (!isalert) {
//        [AlertMainView alertMainViewWithType:AlertMainViewTypeRegulation];
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
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
    }];
    
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            [self SLEConnected];
            [weakSelf performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance] checkConnectTimeAlert:^(int number) {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            [weakSelf SLEconnectionFailedAction:number];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
        [weakSelf SLErefreshAlertView];
    }];
    
    
    [BlueToothManager getInstance].delegate = self;
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 - sleep == %d",number);
        if (number) {
            //[weakSelf submitIsConnect];
            [weakSelf SLErefreshAlertView];
        }
    }];
    
}
//下拉刷新
-(void)SLEdropDownReload
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
        //        [weakSelf reloadData];
        [weakSelf successCallbackSleepData];
    }];
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
-(void)reloadBlueToothDataSleep
{
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
        [self.targetBtn setTitle:[NSString stringWithFormat:@"%d h",sleepPlan/60] forState:UIControlStateNormal];
        self.circle.maxValue = sleepPlan;
    }
    
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
    [self reloadPlan]; // 天总数据
}
-(void)reloadPlan
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadPlan) object:nil];
    // 天总数据中 - - -- - 目标的下载
    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    if (dic)
    {
        int sleepPlan = [dic[@"sleepPlan"] intValue];
        [self.targetBtn setTitle:[NSString stringWithFormat:@"%d h",sleepPlan/60] forState:UIControlStateNormal];
        self.circle.maxValue = sleepPlan;
    }
}
/**
 *
 查询了今天的睡眠和昨天的睡眠组成一个睡眠数据
 */
-(void)sleepDrawWithDictionary
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sleepDrawWithDictionary) object:nil];
    NSDictionary *todayDic =  [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    NSDictionary *lastDayDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS];
    
    NSMutableArray *sleepArray = [[NSMutableArray alloc] init];
    
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:todayDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    
    sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
    
    int lightSleep = 0;
    int awakeSleep = 0;
    int deepSleep = 0;
    BOOL isBegin = NO;
    int nightBeginTime = 0;
    int nightEndTime = 0;
    
    for (int i = 0 ; i < sleepArray.count; i ++)
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
            for (int i = nightBeginTime ; i <= nightEndTime; i ++)
            {
                int state = [sleepArray[i] intValue];
                if (state == 2 )    {  deepSleep ++; }
                else if (state == 1){   lightSleep ++; }
                else if (state == 0 || state == 3) {  awakeSleep ++;}
            }
        }
    }
    
    
    int totalCount = awakeSleep + lightSleep + deepSleep;
    _awakeLabel.attributedText = [self getHandMinAttributeStringWithNumber:awakeSleep * 10];
    _lightLabel.attributedText = [self getHandMinAttributeStringWithNumber:lightSleep * 10];
    _deepLabel.attributedText = [self getHandMinAttributeStringWithNumber:deepSleep * 10];
    [_deepLabel adjustsFontSizeToFitWidth];
    self.circle.value = totalCount * 10;
    
    if (totalCount < 36)
    {
        _sleepStateLabel.text = NSLocalizedString(@"偏少", nil);
    }else if (totalCount < 54)
    {
        _sleepStateLabel.text = NSLocalizedString(@"正常", nil);
    }else
    {
        _sleepStateLabel.text = NSLocalizedString(@"充裕", nil);
    }
}

- (NSMutableAttributedString *)getHandMinAttributeStringWithNumber:(int)number
{
    NSMutableAttributedString *attributeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number / 60] Unit:@"h" WithFont:25];
    [attributeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number%60] Unit:@"min" WithFont:25]];
    return attributeString;
}

- (void)setBackgroundView
{
    NSArray *array = @[@"清醒",@"睡眠质量",@"安静睡眠",@"浅睡"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kMainColor;
        view.frame = CGRectMake((8 + i % 2 * 181) *kX,
                                self.backScrollView.height- (29 * kDY)- (84 + 3)*kDY * (i/2 + 1),
                                178 * kX,
                                84*kDY);
        view.layer.borderColor = kColor(240, 240, 240).CGColor;
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.backScrollView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.height-25)/2, 25,25)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:array[i]];
        [view addSubview:imageView];
        //imageView.backgroundColor = [UIColor orangeColor];
        
        UILabel *label = [[UILabel alloc] init];
        //label.backgroundColor = [UIColor redColor];
        label.text = array[i];
        label.font = Font_Normal_String(13);
        label.textColor = allColorWhite;
        label.frame = CGRectMake(imageView.right + 3, imageView.top + imageView.height/2., view.width - imageView.right-3, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        NSMutableAttributedString *string;
        switch (i) {
            case 0:
            {
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:25];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:25]];
                _awakeLabel = [[UILabel alloc] init];
                _awakeLabel.frame = CGRectMake(imageView.right + 3, imageView.top - imageView.height/2, view.width - imageView.right-3, 30);
                _awakeLabel.textAlignment = NSTextAlignmentCenter;
                _awakeLabel.attributedText = string;
                _awakeLabel.textColor = allColorWhite;
                [view addSubview:_awakeLabel];
                //  _awakeLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 1:
            {
                
                _sleepStateLabel = [[UILabel alloc] init];
                _sleepStateLabel.frame = CGRectMake(imageView.right + 3, imageView.top - imageView.height/2, view.width - imageView.right-3, 30);
                _sleepStateLabel.textAlignment = NSTextAlignmentCenter;
                _sleepStateLabel.text = NSLocalizedString(@"偏少", nil);
                _sleepStateLabel.textColor = allColorWhite;
                _sleepStateLabel.font = [UIFont systemFontOfSize:23];
                [view addSubview:_sleepStateLabel];
                
                //  _sleepStateLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 2:
            {
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:25];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:25]];
                _deepLabel = [[UILabel alloc] init];
                _deepLabel.frame = CGRectMake(imageView.right + 3, imageView.top - imageView.height/2, view.width - imageView.right-3, 30);
                _deepLabel.attributedText = string;
                _deepLabel.textAlignment = NSTextAlignmentCenter;
                _deepLabel.textColor = allColorWhite;
                [view addSubview:_deepLabel];
                //_deepLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 3:
            {
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:25];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:25]];
                _lightLabel = [[UILabel alloc] init];
                _lightLabel.frame = CGRectMake(imageView.right + 3, imageView.top - imageView.height/2, view.width - imageView.right-3, 30);
                _lightLabel.attributedText = string;
                _lightLabel.textAlignment = NSTextAlignmentCenter;
                _lightLabel.textColor = allColorWhite;
                [view addSubview:_lightLabel];
                //                _lightLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            default:
                break;
        }
    }
    
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(95*kX, 30*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.view.height - 256*kDY  - 48 - SafeAreaTopHeight);
    [self.backScrollView addSubview:self.targetBtn];
    self.targetBtn.layer.borderColor = kMainColor.CGColor;
    self.targetBtn.layer.borderWidth = 1;
    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    [self.targetBtn setTitle:[NSString stringWithFormat:@"%d h",[HCHCommonManager getInstance].sleepPlan / 60] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.circle = [[NightCircleView alloc] init];
    [self.backScrollView addSubview:self.circle];
    self.circle.frame = CGRectMake(0, 0, MIN(223 * kX, 223 * kDY), MIN(223 * kX, 223 * kDY));
    self.circle.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circle.height/2.);
    self.circle.backgroundColor = [UIColor clearColor];
    
    self.circle.minValue = 0;
    self.circle.maxValue = kHCH.sleepPlan;
    self.circle.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circle.endAngle = 3./2 * M_PI;
    self.circle.ringBackgroundColor = kColor(234, 237, 242);
    self.circle.valueTextColor = kMainColor;
    self.circle.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circle.delegate = self;
    self.circle.value = 0;
    [self.circle setNeedsDisplay];
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.circle addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat detailButtonX = 0;
    CGFloat detailButtonY = 0;
    CGFloat detailButtonW = MIN(223 * kX, 223 * kDY) * WidthProportion;
    CGFloat detailButtonH = MIN(223 * kX, 223 * kDY) * HeightProportion;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
}

#pragma mark -- button方法
- (void)targetBtnAction:(UIButton *)button
{
    TargetViewController *tagetVC = [TargetViewController new];
    tagetVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tagetVC animated:YES];
}
- (void)detailButtonAction:(UIButton *)button
{
    TodaySleepDetailViewController *detail = [[TodaySleepDetailViewController alloc]init];
    detail.hidesBottomBarWhenPushed = YES;
    self.haveTabBar = NO;
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (UIColor *)gaugeView:(NightCircleView *)gaugeView ringStokeColorForValue:(CGFloat)value
{
    return [UIColor clearColor];
}
- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self SLErefreshFail];
    //    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}




- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

#pragma mark   -------- -- 连接状态的提示

-(void)SLEremindView
{
    _SLEchangLabel = [[UILabel alloc]init];
    
    [self.view addSubview:self.SLEdoneView];
    //    self.SLEdoneView.alpha = 0;
    
    _SLEconStateView = [[ConnectStateView alloc]init];
    [self.view addSubview:_SLEconStateView];
    _SLEconStateView.alpha = 0;
    CGFloat conStateViewX = 0;
    CGFloat conStateViewY = SafeAreaTopHeight;
    CGFloat conStateViewW = CurrentDeviceWidth;
    CGFloat conStateViewH = 60*HeightProportion;
    _SLEconStateView.frame = CGRectMake(conStateViewX,conStateViewY,conStateViewW,conStateViewH);
    
    
    
    _SLEconnectButton = [[UIButton alloc]init];
    //    _connectButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [_SLEconStateView addSubview:_SLEconnectButton];
    _SLEconnectButton.frame = CGRectMake(0, 0, conStateViewW, conStateViewH);
    [_SLEconnectButton addTarget:self action:@selector(SLEconnectButtonToshebei) forControlEvents:UIControlEventTouchUpInside];
    _SLEconnectButton.sd_layout
    .leftSpaceToView(_SLEconStateView,0)
    .topSpaceToView(_SLEconStateView,0)
    .rightSpaceToView(_SLEconStateView,0)
    .bottomSpaceToView(_SLEconStateView,0);
    
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SLEconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
     [center addObserver:self selector:@selector(SLErefreshAlertView) name:@"didDisconnectDevice" object:nil];
}

//初始化提醒的view  的 刷新
-(void)SLErefreshAlertView{
    self.SLEconnectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1))
        {
            self.backScrollView.frame = CGRectMake(0,SafeAreaTopHeight,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
            self.webView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
        }
        self.SLEconStateView.alpha = 0;
    }
    else
    {
        
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            if(kHCH.BlueToothState == CBManagerStatePoweredOn)
            {
                //self.connectLabel.text = NSLocalizedString(@"连接中...", nil);
                if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] != 2)//可用
                {
                    self.SLEconnectString = NSLocalizedString(@"连接中...", nil);
                }
                
            }
            else
            {
                self.SLEconnectString  = NSLocalizedString(@"bluetoothNotOpen", nil);
                
            }
        }
        else
        {
            self.SLEconnectString = NSLocalizedString(@"未绑定", nil);
            self.SLEconnectButton.userInteractionEnabled = YES;
            self.SLEconStateView.labeltextColor = [UIColor blueColor];
        }
        self.SLEconStateView.alpha = 1;
    }
    
}

-(void)SLEconnectionFailedAction:(int)isSeek
{
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] == 2)//可用
        {
            if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 1)    //没有找到
            {
                //                    self.connectStringHight = 2;
                self.SLEconnectString = NSLocalizedString(@"pleaseWakeupDeviceNotfound", nil);
                
            }
            else if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 2)   //找到了
            {
                //                    self.connectStringHight = 2;
                self.SLEconnectString = NSLocalizedString(@"bluetoothConnectionFailed", nil);
            }
        }
        
    }
    else
    {
        //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
        self.SLEconnectString = NSLocalizedString(@"未绑定", nil);
        self.SLEconnectButton.userInteractionEnabled = YES;
        self.SLEconStateView.labeltextColor = [UIColor blueColor];
    }
    
}

-(void)SLEconnectButtonToshebei
{
    SheBeiViewController *shebeiVC = [SheBeiViewController sharedInstance];
    shebeiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shebeiVC animated:YES];
}
-(void)SLErefreshConnect
{
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {   [self SLEConnected];
        [weakSelf performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        [self SLEConnected];
        [self performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)SLEConnected
{
    self.SLEconnectString = NSLocalizedString(@"connectSuccessfully", nil);
}
-(void)SLEsubmitIsConnect
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(SLEsubmitIsConnect) object:nil];
    
    self.SLEconStateView.alpha = 0;
    if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1))
    {
        self.backScrollView.frame = CGRectMake(0,SafeAreaTopHeight,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
        self.webView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    }
}
-(void)setSLEconnectString:(NSString *)SLEconnectString
{
    _SLEconnectString = SLEconnectString;
    //adaLog(@"--- SLErt -- connectString - %@",SLEconnectString);
    self.SLEconStateView.stateString = SLEconnectString;
    self.SLEconStateView.labeltextColor = _SLEchangLabel.textColor;
    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown3 = [SLEconnectString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
    NSInteger height = sizeDown3.height;
    
    if(height>self.SLEconStateView.height)
    {
        self.SLEconStateView.height =  height;
    }
    if(![SLEconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
    {
        self.backScrollView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEconStateView.height,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
        self.webView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    }
}

-(void)refreshing
{
    self.SLEdoneString = NSLocalizedString(@"DataSyn", nil);
}
-(void)SLErefreshSucc
{
    self.SLEdoneString = NSLocalizedString(@"syncFinish", nil);
}
-(void)SLErefreshFail
{
    self.SLEdoneString = NSLocalizedString(@"synchronizationFailure", nil);
}
-(void)SLEhiddenDoneView
{
    self.SLEdoneView.alpha = 0;
    [UIView animateWithDuration:1.f animations:^{
        self.backScrollView.frame = CGRectMake(0,SafeAreaTopHeight,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
        self.webView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    }];
}
-(DoneCustomView *)SLEdoneView
{
    if (!_SLEdoneView)
    {
        _SLEdoneView = [[DoneCustomView alloc]init];
        _SLEdoneView.frame = CGRectMake(0,SafeAreaTopHeight, CurrentDeviceWidth, 60*HeightProportion);
        _SLEdoneView.alpha = 0;
    }
    return _SLEdoneView;
}
-(void)setSLEdoneString:(NSString *)SLEdoneString
{
    _SLEdoneString = SLEdoneString;
    self.SLEdoneView.titleString = SLEdoneString;
    
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size2 = [SLEdoneString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    
    NSInteger height = size2.height;
    if(height>self.SLEdoneView.height)
    {
        self.SLEdoneView.height =  height;
    }
    self.backScrollView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEdoneView.height,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    self.webView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    if (![SLEdoneString isEqualToString:NSLocalizedString(@"DataSyn", nil)])
    {
        [self performSelector:@selector(SLEhiddenDoneView) withObject:nil afterDelay:2.f];
    }
    self.SLEdoneView.alpha = 1;
}
#pragma mark   - -- 蓝牙状态的回调   --- delegate

-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    [self performSelector:@selector(SLErefreshAlertView) withObject:nil afterDelay:1.f];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
