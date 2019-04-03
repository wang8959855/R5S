//
//  HealtPoliceViewController.m
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "HealtPoliceViewController.h"
#import "SheBeiViewController.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"
#import "SOSView.h"
#import "AlertMainView.h"
#import "PoliceAlertView.h"
#import "SMTabbedSplitViewController.h"
#import "SMTabBarItem.h"
#import "HeartHomeAlarmViewController.h"

@interface HealtPoliceViewController ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;

@property (nonatomic,strong)UIView *maskView;// 挡板
@property (nonatomic,strong)UIButton *mask;
@property (nonatomic,strong) ConnectStateView *SLEconStateView;//提示连接的view
@property (nonatomic,strong) UIButton *SLEconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong) NSString *SLEconnectString;//连接字符串。
@property (nonatomic,strong) DoneCustomView *SLEdoneView;
@property (nonatomic,strong) NSString *SLEdoneString;
@property (nonatomic,strong)UILabel *changLabel;//传递颜色的label
@property (nonatomic,strong)UIAlertView *alertView1;//系统异常  的提示

@property (nonatomic, strong) SMTabbedSplitViewController *split;

//当前选择的模式
@property (nonatomic, assign) NSInteger currentState;

@property (strong,nonatomic) CLLocationManager* locationManager;

@property (nonatomic, strong) UIButton *locationButton;

//时间
@property (nonatomic, strong) UILabel *title1;

@end

@implementation HealtPoliceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datePickBtn setTitle:@"健康预警" forState:UIControlStateNormal];
    [self getUserClick];
    BOOL isalert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAlertPolice"] boolValue];
    if (!isalert) {
        [AlertMainView alertMainViewWithType:AlertMainViewTypePolice];        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    [self childrenTimeSecondChanged];
    
    [self reloadBlueToothData];
    [self setBlocks];
    [self remindView];
    [self refreshAlertView];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)setupView{
    [self remindView];
    [HCHCommonManager getAvgHeartRate];
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    [self setSleepbackGround];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNowHeartRate:) name:GetNowHeartRateNotification object:nil];
    //获取平均心率
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvgHeartRate:) name:GetAvgHeartRateNotification object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
}
//平均心率
- (void)getAvgHeartRate:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    self.averageHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:dic[@"avg"] Unit:@"次/分" WithFont:18];
    self.maxHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:dic[@"max"] Unit:@"次/分" WithFont:18];
    self.minHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:dic[@"min"] Unit:@"次/分" WithFont:18];
}

- (void)getNowHeartRate:(NSNotification *)noti{
    NSString *heart = noti.object;
    self.nowHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:heart Unit:@"次/分" WithFont:18];
}

- (void)setBlocks
{
    WeakSelf;
    if ([HCHCommonManager getInstance].isEquipmentConnect) {
        [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
    }
    
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        if (number)
        {
            [HCHCommonManager getInstance].isEquipmentConnect = YES;
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
        }
        else
        {
            [HCHCommonManager getInstance].isEquipmentConnect = NO;
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

-(void)setSleepbackGround
{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@""];
    backImageView.backgroundColor = allColorWhite;
    [self.view addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 48);
    
    //CGFloat backScrollViewX = 0;
    CGFloat backScrollViewY = 64;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - 64 - 49;
    
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    [self.view addSubview:self.backScrollView];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+40.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.backgroundColor  = [UIColor clearColor];
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:3.0f];
        [weakSelf remindRedownData];
//        [weakSelf timeSecondsChanged];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackgroundView];
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    
}

- (void)setBackgroundView
{
    NSArray *array = @[@"最高心率",@"最低心率",@"实时心率",@"平均心率"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kMainColor;
        view.frame = CGRectMake((8 + i % 2 * 181) *kX,
                                self.backScrollView.height- (29 * kDY)- (84 + 3)*kDY * (i/2 + 1)+40,
                                178 * kX,
                                84*kDY);
        view.layer.borderColor = kColor(240, 240, 240).CGColor;
        view.layer.borderWidth = 0.5;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.tag = 30+i;
        view.userInteractionEnabled = YES;
        [self.backScrollView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertAtion:)];
        [view addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        //label.backgroundColor = [UIColor redColor];
        label.text = array[i];
        label.font = Font_Normal_String(13);
        label.textColor = allColorWhite;
        label.frame = CGRectMake(0, (view.height-30)/2-15, view.width, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        NSAttributedString *string = [self makeAttributedStringWithnumBer:@"--" Unit:@"次/分" WithFont:18];
        switch (i) {
            case 0:
            {
                _maxHeartRateLabel = [[UILabel alloc] init];
                _maxHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _maxHeartRateLabel.attributedText = string;
                _maxHeartRateLabel.textColor = allColorWhite;
                _maxHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_maxHeartRateLabel];
                //  _awakeLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 1:
            {
                _minHeartRateLabel = [[UILabel alloc] init];
                _minHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _minHeartRateLabel.textColor = allColorWhite;
                _minHeartRateLabel.attributedText = string;
                _minHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_minHeartRateLabel];
            }
                break;
            case 2:
            {
                _nowHeartRateLabel = [[UILabel alloc] init];
                _nowHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _nowHeartRateLabel.attributedText = string;
                _nowHeartRateLabel.textColor = allColorWhite;
                _nowHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_nowHeartRateLabel];
                //_deepLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 3:
            {
                _averageHeartRateLabel = [[UILabel alloc] init];
                _averageHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _averageHeartRateLabel.attributedText = string;
                _averageHeartRateLabel.textColor = allColorWhite;
                _averageHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_averageHeartRateLabel];
                //                _lightLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            default:
                break;
        }
    }
    
    UIButton *tongzhiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tongzhiButton.frame = CGRectMake(10, 5, ScreenWidth/2-15, 35);
    tongzhiButton.layer.cornerRadius = 17.5;
    tongzhiButton.layer.masksToBounds = YES;
    tongzhiButton.layer.borderColor = kMainColor.CGColor;
    tongzhiButton.layer.borderWidth = 1;
    [tongzhiButton setImage:[UIImage imageNamed:@"dingzhi-icon"] forState:UIControlStateNormal];
    [tongzhiButton setTitle:@"免费定制预警通知" forState:UIControlStateNormal];
    [tongzhiButton setTitleColor:kMainColor forState:UIControlStateNormal];
    tongzhiButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tongzhiButton addTarget:self action:@selector(freeCustomNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:tongzhiButton];
    
    UIButton *yujingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yujingButton.frame = CGRectMake(ScreenWidth/2 + 10, 5, ScreenWidth/2-15, 35);
    yujingButton.layer.cornerRadius = 17.5;
    yujingButton.layer.masksToBounds = YES;
    yujingButton.layer.borderColor = kMainColor.CGColor;
    [yujingButton setImage:[UIImage imageNamed:@"zidingyi-icon"] forState:UIControlStateNormal];
    [yujingButton addTarget:self action:@selector(zdyNoti) forControlEvents:UIControlEventTouchUpInside];
    [yujingButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [yujingButton setTitle:@"自定义预警提醒" forState:UIControlStateNormal];
    yujingButton.layer.borderWidth = 1;
    yujingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.backScrollView addSubview:yujingButton];
    
    self.title1 = [[UILabel alloc] init];
    self.title1.frame = CGRectMake(0, yujingButton.bottom+5, ScreenWidth, 20);
    self.title1.text = [self getDate:@"您目前正处于自动检测模式"];
    [self.backScrollView addSubview:self.title1];
    self.title1.textColor = kMainColor;
    self.title1.font = [UIFont systemFontOfSize:15];
    self.title1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *title2 = [[UILabel alloc] init];
    title2.frame = CGRectMake(0, self.title1.bottom, ScreenWidth, 16);
    title2.text = @"点击下方检测模式，选择定制监测";
    [self.backScrollView addSubview:title2];
    title2.textColor = kMainColor;
    title2.font = [UIFont systemFontOfSize:13];
    title2.textAlignment = NSTextAlignmentCenter;
    
    self.circleImage = [[UIImageView alloc] init];
    [self.backScrollView addSubview:self.circleImage];
    self.circleImage.frame = CGRectMake(0, 0, MIN(203 * kX, 203 * kDY), MIN(203 * kX, 203 * kDY));
    self.circleImage.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circleImage.height/2.+60);
    self.circleImage.image = [UIImage imageNamed:@"weidianji"];
    self.circleImage.backgroundColor = [UIColor clearColor];
    
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(110*kX, 35*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2.-(self.targetBtn.size.width/2+20), self.circleImage.bottom+35*kDY);
    [self.backScrollView addSubview:self.targetBtn];
    self.targetBtn.layer.borderColor = kMainColor.CGColor;
    self.targetBtn.layer.borderWidth = 1;
    self.targetBtn.layer.cornerRadius = self.targetBtn.height/2.;
    [self.targetBtn setImage:[UIImage imageNamed:@"sos"] forState:UIControlStateNormal];
    [self.targetBtn setTitle:@"SOS呼叫" forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //定位的按钮
    self.locationButton = [[UIButton alloc] init];
    self.locationButton.size = CGSizeMake(110*kX, 35*kDY);
    self.locationButton.center = CGPointMake(CurrentDeviceWidth/2.+(self.locationButton.size.width/2+20), self.circleImage.bottom+35*kDY);
    [self.backScrollView addSubview:self.locationButton];
    [self.locationButton setTitle:@"定位关闭" forState:UIControlStateNormal];
    [self.locationButton setTitle:@"定位开启" forState:UIControlStateSelected];
    [self.locationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.locationButton setTitleColor:kMainColor forState:UIControlStateSelected];
    self.locationButton.layer.borderWidth = 1;
    self.locationButton.layer.cornerRadius = self.targetBtn.height/2.;
    self.locationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.locationButton addTarget:self action:@selector(locationSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton setImage:[UIImage imageNamed:@"dingwei-guan"] forState:UIControlStateNormal];
    [self.locationButton setImage:[UIImage imageNamed:@"dingwei-kai"] forState:UIControlStateSelected];
    self.locationButton.selected = NO;
    
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.backScrollView addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    detailButton.tag = 101;
    CGFloat detailButtonX = self.circleImage.frame.origin.x;
    CGFloat detailButtonY = self.circleImage.frame.origin.y;
    CGFloat detailButtonW = MIN(223 * kX, 223 * kDY) * WidthProportion;
    CGFloat detailButtonH = self.circleImage.height/2-20;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
    //
    UIButton *detailButton1 = [[UIButton alloc]init];
    [self.backScrollView addSubview:detailButton1];
    detailButton1.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton1 addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    detailButton1.tag = 102;
    CGFloat detail1ButtonX = self.circleImage.frame.origin.x;
    CGFloat detail1ButtonY = detailButton.bottom;
    CGFloat detail1ButtonW = self.circleImage.width/2;
    CGFloat detail1ButtonH = self.circleImage.height/2+20;
    detailButton1.frame = CGRectMake(detail1ButtonX, detail1ButtonY, detail1ButtonW, detail1ButtonH);
    
    //
    UIButton *detail2Button = [[UIButton alloc]init];
    [self.backScrollView addSubview:detail2Button];
    detail2Button.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detail2Button addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    detail2Button.tag = 103;
    CGFloat detail2ButtonX = detailButton1.right;
    CGFloat detail2ButtonY = detailButton.bottom;
    CGFloat detail2ButtonW = self.circleImage.width/2;
    CGFloat detail2ButtonH = self.circleImage.height/2+20;
    detail2Button.frame = CGRectMake(detail2ButtonX, detail2ButtonY, detail2ButtonW, detail2ButtonH);
    
}

#pragma mark -- button方法
//定位开关
- (void)locationSwitch:(UIButton *)button{
    NSString *title = @"";
    if (button.selected) {
        title = @"关闭轨迹定位将让监护人无法获取您的位置信息，是否关闭";
    }else{
        title = @"轨迹定位将让监护人获取您的位置信息，是否开启";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:title preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)childrenTimeSecondChanged
{
    if (kHCH.selectTimeSeconds != kHCH.todayTimeSeconds)
    {
        //        [self unableHeart];
        _nowHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:@"次/分" WithFont:18];
    }
    else
    {
        [self.backScrollView setHeaderHidden:NO];
    }
    [self upDataUIWithDic];//刷新数据
    [self reloadBlueToothData];
    
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
    }
    
}

- (void)targetBtnAction:(UIButton *)button{
    SOSView *sos = [SOSView initSOSView];
    [sos show];
    WeakSelf;
    sos.sosOKBlock = ^{
        if (!weakSelf.locationButton.selected) {
            [weakSelf showAlertView:@"请先打开定位"];
            return;
        }
        [weakSelf startLocation];
    };
}

//免费定制
- (void)freeCustomNoti{
    PoliceAlertView *al = [PoliceAlertView policeAlertView];
    [al show];
}

//自定义
- (void)zdyNoti{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        if (![CositeaBlueTooth sharedInstance].isConnected)
        {
            [self addActityTextInView:window text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            return;
        }
    }
    else
    {
        [self addActityTextInView:window text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
        return;
    }
    
    SMTabbedSplitViewController *split = [[SMTabbedSplitViewController alloc] initTabbedSplit];
    _split = split;
    
    HeartHomeAlarmViewController *heartVC = [[HeartHomeAlarmViewController alloc] init];
    SMTabBarItem *alarmTab5 = [[SMTabBarItem alloc] initWithVC:heartVC image:[UIImage imageNamed:@"心率监测"]  selectedImage:[UIImage imageNamed:@"心率监测选中状态"] andTitle:@""];
    
    split.background = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 64)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:button];
    
    imageView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [imageView addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);
    imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    imageView.layer.shadowOpacity = 0.6;
    imageView.layer.shadowRadius = 4;
    
    button.sd_layout.leftSpaceToView(imageView,15)
    .topSpaceToView (imageView,28)
    .widthIs(24)
    .heightIs(24);
    [button setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:bigBtn];
    bigBtn.sd_layout.leftSpaceToView(imageView,0)
    .topSpaceToView(imageView,10)
    .widthIs(60)
    .bottomEqualToView(imageView);
    [bigBtn addTarget:split action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    imageView.userInteractionEnabled = YES;
    [split.view addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    [imageView addSubview:label];
    label.text = NSLocalizedString(@"心率监测", nil);
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor blackColor];
    label.sd_layout.centerXEqualToView(imageView)
    .widthIs(label.width)
    .topSpaceToView(imageView,31)
    .heightIs(21);
    //    [self addCurrentPageScreenshot];
    //    [self settingDrawerWhenPush];
    
    
    split.navigationController.navigationBar.hidden = YES;
    
    split.tabsViewControllers = @[alarmTab5];

    _split.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_split animated:YES];
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
            
        }
        else
        {
            
            
        }
        
        NSMutableAttributedString *activeString = [[NSMutableAttributedString alloc] init];
        activeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",[activeTime intValue]/60] Unit:@"h" WithFont:18];
        [activeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",[activeTime intValue]%60] Unit:@"min" WithFont:18]];
        int stepPlan = [dic[@"stepsPlan"] intValue];
    }
    else
    {
        
    }
}

- (void)detailButtonAction:(UIButton *)button{
    NSString *ti = @"";
    NSString *image = @"";
    if (button.tag == 101) {
        ti = @"饮酒检测";
        image = @"yinjiu";
    }else if (button.tag == 102){
        ti = @"加班检测";
        image = @"jiaban";
    }else{
        ti = @"运动检测";
        image = @"sports";
    }
    if (self.currentState == 0) {
        //没有选择检测
//        self.circleImage.image = [UIImage imageNamed:image];
        [self setUserClick:[NSString stringWithFormat:@"%ld",button.tag-100] image:image];
        return;
    }
    if (button.tag == self.currentState) {
        [self setUserClick:@"0" image:@"weidianji"];
        self.circleImage.image = [UIImage imageNamed:@"weidianji"];
    }else{
        //选择了检测
        if (self.currentState == 101) {
            [self addActityTextInView:self.view text:[NSString stringWithFormat:@"请先终止饮酒检测，在进行%@",ti] deleyTime:1.5f];
        }else if (self.currentState == 102){
            [self addActityTextInView:self.view text:[NSString stringWithFormat:@"请先终止加班检测，在进行%@",ti] deleyTime:1.5f];
        }else{
            [self addActityTextInView:self.view text:[NSString stringWithFormat:@"请先终止运动检测，在进行%@",ti] deleyTime:1.5f];
        }
    }
}

//从手环请求今天的总数据
- (void)reloadBlueToothData
{
    [HCHCommonManager getAvgHeartRate];
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
    
    _SLEconStateView = [[ConnectStateView alloc]init];
    [self.view addSubview:_SLEconStateView];
    CGFloat conStateViewX = 0;
    CGFloat conStateViewY = 64;
    CGFloat conStateViewW = CurrentDeviceWidth;
    CGFloat conStateViewH = 60*HeightProportion;
    _SLEconStateView.alpha = 0;
    _SLEconStateView.frame = CGRectMake(conStateViewX,conStateViewY,conStateViewW,conStateViewH);
    
    
    
    _SLEconnectButton = [[UIButton alloc]init];
    //    _connectButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [_SLEconStateView addSubview:_SLEconnectButton];
    _SLEconnectButton.frame = CGRectMake(0, 0, conStateViewW, conStateViewH);
    [_SLEconnectButton addTarget:self action:@selector(connectButtonToshebei) forControlEvents:UIControlEventTouchUpInside];
    _SLEconnectButton.sd_layout
    .leftSpaceToView(_SLEconStateView,0)
    .topSpaceToView(_SLEconStateView,0)
    .rightSpaceToView(_SLEconStateView,0)
    .bottomSpaceToView(_SLEconStateView,0);
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(connectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(refreshAlertView) name:@"didDisconnectDevice" object:nil];
    
}
//初始化提醒的view  的 刷新
-(void)refreshAlertView{
    self.SLEconnectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        if(!([self.doneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.doneView.alpha == 1))
        {
            self.backScrollView.frame = CGRectMake(0,64,self.backScrollView.width, self.backScrollView.height);
        }
        self.SLEconStateView.alpha = 0;
    }
    else
    {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            if(kHCH.BlueToothState == CBManagerStatePoweredOn)
            {
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
            //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
            self.SLEconnectString = NSLocalizedString(@"未绑定", nil);
            self.SLEconnectButton.userInteractionEnabled = YES;
            self.SLEconStateView.labeltextColor = [UIColor blueColor];
        }
        self.SLEconStateView.alpha = 1;
    }
    
}

- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self refreshFail];
    //    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
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
    self.SLEconnectString = NSLocalizedString(@"connectSuccessfully", nil);
    [self performSelector:@selector(reloadBlueToothData) withObject:nil afterDelay:2.f];
}
-(void)submitIsConnect
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(submitIsConnect) object:nil];
    self.SLEconStateView.alpha = 0;
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


-(void)setSLEconnectString:(NSString *)SLEconnectString
{
    _SLEdoneString = SLEconnectString;
    //adaLog(@"-----today -  connectString - %@",connectString);
    self.SLEconStateView.stateString = SLEconnectString;
    self.SLEconStateView.labeltextColor = _changLabel.textColor;
    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown3 = [SLEconnectString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
    NSInteger height = sizeDown3.height;
    if(height>self.SLEconStateView.height)
    {
        self.SLEconStateView.height =  height;
    }
    if(![SLEconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
    {
        self.backScrollView.frame = CGRectMake(0,64+self.SLEconStateView.height,self.backScrollView.width, self.backScrollView.height);
    }
}

-(void)refreshing
{
    self.SLEdoneString = NSLocalizedString(@"DataSyn", nil);
}

-(void)refreshSucc
{
    self.SLEdoneString = NSLocalizedString(@"syncFinish", nil);
}
-(void)refreshFail
{
    self.SLEdoneString = NSLocalizedString(@"synchronizationFailure", nil);
}
-(void)hiddenDoneView
{
    self.SLEdoneView.alpha = 0;
    [UIView animateWithDuration:1.f animations:^{
        //        self.doneView.hidden = YES;
        self.backScrollView.frame = CGRectMake(0,64,self.backScrollView.width, self.backScrollView.height);
    }];
}
-(DoneCustomView *)doneView
{
    if (!_SLEdoneView)
    {
        _SLEdoneView = [[DoneCustomView alloc]init];
        _SLEdoneView.frame = CGRectMake(0,64, CurrentDeviceWidth,60*HeightProportion);
    }
    return _SLEdoneView;
}
-(void)setSLEdoneString:(NSString *)SLEdoneString
{
    _SLEdoneString = SLEdoneString;
    self.SLEdoneView.titleString = SLEdoneString;
    
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    if (![SLEdoneString isEqual:[NSString class]]) {
        return;
    }
    CGSize size2 = [SLEdoneString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    
    NSInteger height = size2.height;
    if(height>self.SLEdoneView.height)
    {
        self.SLEdoneView.height =  height;
    }
    self.backScrollView.frame = CGRectMake(0,64+self.SLEdoneView.height,self.backScrollView.width, self.backScrollView.height);
    if (![SLEdoneString isEqualToString:NSLocalizedString(@"DataSyn", nil)])
    {
        [self performSelector:@selector(hiddenDoneView) withObject:nil afterDelay:2.f];
    }
    self.SLEdoneView.alpha = 1;
}

//开始定位
- (void)startLocation{
    
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在请求", nil) detailLabel:NSLocalizedString(@"正在请求", nil)];
    
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        _locationManager.allowsBackgroundLocationUpdates =YES;
        
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:{
            self.locationButton.selected = NO;
            self.locationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }break;
        default:{
            self.locationButton.selected = YES;
            self.locationButton.layer.borderColor = kMainColor.CGColor;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadLocation" object:nil];
        }break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks.firstObject;
        NSLog(@"name,%@",place.name);                      // 位置名
        NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
        NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
        NSLog(@"locality,%@",place.locality);              // 市
        NSLog(@"subLocality,%@",place.subLocality);        // 区
        NSLog(@"country,%@",place.country);                // 国家
        if (!place.locality || place.locality.length == 0) {
            //定位失败
            [self removeActityIndicatorFromView:self.view];
            [self addActityTextInView:self.view text:@"定位失败"  deleyTime:1.5f];
            return;
        }
        [self requestSOSAddress:[NSString stringWithFormat:@"%@%@%@%@",place.country,place.locality,place.subLocality,place.name] lng:oldCoordinate.longitude lat:oldCoordinate.latitude environment:place.name];
    }];
}

//点击sos
- (void)requestSOSAddress:(NSString *)address lng:(float)lng lat:(float)lat environment:(NSString *)environment{
    NSString *url = [NSString stringWithFormat:@"%@/%@",CLICKSOS,TOKEN];
    NSDictionary *para = @{@"UserID":USERID,@"address":address,@"lng":@(lng),@"lat":@(lat),@"environment":environment};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self removeActityIndicatorFromView:self.view];
        int code = [responseObject[@"code"] intValue];
        NSString *message = responseObject[@"message"];
        if (code == 0) {
            [self addActityTextInView:self.view text:@"呼叫成功"  deleyTime:1.5f];
        }else{
            [self addActityTextInView:self.view text:@"呼叫失败" deleyTime:1.5f];
            [self addActityTextInView:self.view text:message deleyTime:1.5f];
        }
    }];
}

- (void)getUserClick{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETSERVER,TOKEN];
    NSDictionary *para = @{@"UserID":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self removeActityIndicatorFromView:self.view];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            NSInteger type = [responseObject[@"data"][@"monitorType"] integerValue];
            NSString *image = @"weidianji";
            NSString *t = @"您目前正处于自动监测模式";
            if (type == 1) {
                image = @"yinjiu";
                t = @"您目前正处于饮酒监测模式";
            }else if (type == 2){
                image = @"jiaban";
                t = @"您目前正处于加班监测模式";
            }else if (type == 3){
                image = @"sports";
                t = @"您目前正处于运动监测模式";
            }
            self.title1.text = [self getDate:t];
            self.circleImage.image = [UIImage imageNamed:image];
        }else{
            [self addActityTextInView:self.view text:@"获取失败"  deleyTime:1.5f];
        }
    }];
}

- (void)setUserClick:(NSString *)type image:(NSString *)image{
    NSString *url = [NSString stringWithFormat:@"%@/%@",SETSERVER,TOKEN];
    NSDictionary *para = @{@"UserID":USERID,@"monitorType":type};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self removeActityIndicatorFromView:self.view];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            self.circleImage.image = [UIImage imageNamed:image];
            self.currentState = type.integerValue + 100;
            if ([type isEqualToString:@"0"]) {
                self.currentState = 0;
                self.title1.text = [self getDate:@"您目前正处于自动检测模式"];
            }else{
                NSString *t = @"";
                if ([type isEqualToString:@"1"]) {
                    t = @"您目前正处于饮酒监测模式";
                }else if ([type isEqualToString:@"2"]){
                    t = @"您目前正处于加班监测模式";
                }else{
                    t = @"您目前正处于运动监测模式";
                }
                self.title1.text = [self getDate:t];
            }
        }else{
            [self addActityTextInView:self.view text:@"设置失败"  deleyTime:1.5f];
        }
    }];
}

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"从监测起始至目前的最高心率数值。"];
            break;
            
        case 31:
            arr = @[@"从监测起始至目前的最低心率数值。"];
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

- (NSString *)getDate:(NSString *)state{
    NSString *con = @"";
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    int nowSec = hour*3600+minute*60+second;
    if (nowSec > 3600 && nowSec <= 10800) {
        //丑时
        con = @"(01:00-03:00)";
    }else if (nowSec > 10800 && nowSec <= 18000){
        //寅时
        con = @"(03:00-05:00)";
    }else if (nowSec > 18000 && nowSec <= 25200){
        //卯时
        con = @"(05:00-07:00)";
    }else if (nowSec > 25200 && nowSec <= 32400){
        //辰时
        con = @"(07:00-09:00)";
    }else if (nowSec > 32400 && nowSec <= 39600){
        //巳时
        con = @"(09:00-11:00)";
    }else if (nowSec > 39600 && nowSec <= 46800){
        //午时
        con = @"(11:00-13:00)";
    }else if (nowSec > 46800 && nowSec <= 54000){
        //未时
        con = @"(13:00-15:00)";
    }else if (nowSec > 54000 && nowSec <= 61200){
        //申时
        con = @"(15:00-17:00)";
    }else if (nowSec > 61200 && nowSec <= 68400){
        //酉时
        con = @"(17:00-19:00)";
    }else if (nowSec > 68400 && nowSec <= 75600){
        //戌时
        con = @"(19:00-21:00)";
    }else if (nowSec > 75600 && nowSec <= 82800){
        //亥时
        con = @"(21:00-23:00)";
    }else if (nowSec > 82800 || nowSec <= 3600){
        //子时
        con = @"(23:00-01:00)";
    }
    
    return [NSString stringWithFormat:@"%@%@",state,con];
}

@end
