//
//  SignViewController.m
//  Wukong
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "SignViewController.h"
#import "HeartRateView.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"
#import "SheBeiViewController.h"
#import "VersionAlertView.h"

@interface SignViewController ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) ConnectStateView *SLEconStateView;//提示连接的view
@property (nonatomic,strong) UIButton *SLEconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong) NSString *SLEconnectString;//连接字符串。
@property (nonatomic,strong) DoneCustomView *SLEdoneView;
@property (nonatomic,strong) NSString *SLEdoneString;
@property (nonatomic,strong) UILabel *SLEchangLabel;//传递颜色

//心率的view
@property (nonatomic, strong) HeartRateView *rateView;

@property (strong,nonatomic) CLLocationManager* locationManager;


@end

@implementation SignViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BOOL isalert = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAlertTest"] boolValue];
//    if (!isalert) {
//        [AlertMainView alertMainViewWithType:AlertMainViewTypeTest];
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    [self initPro];
    [self connectLastDevice];
    [self setBlocks];
    [self SLErefreshAlertView];
    self.tabBarController.tabBar.hidden = NO;
    [self.datePickBtn setTitle:NSLocalizedString(@"体征", nil) forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //是否进入设备连接界面
    NSString *isDevice = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginOpenDevice"];
    if ([isDevice isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLoginOpenDevice"];
        SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
        shebei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shebei animated:NO];
    }
    
    [self uoloadVersion];
    
    [self setupView];
    [HCHCommonManager getAvgHeartRate];
    [LoctionUpdateTool sharedInstance];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:messageButton];
    messageButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 32, StatusBarHeight + 4, 32, 36);
    [messageButton setImage:[UIImage imageNamed:@"yujing"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(yujingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 32 - 30, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//预警
- (void)yujingAction{
    NSString *url = [NSString stringWithFormat:@"%@/%@",GETWARNING,TOKEN];
    NSDictionary *para = @{@"UserID":USERID,@"apptime":[[TimeCallManager getInstance] getCurrentAreaTime]};
    
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:para Block:^(id responseObject, NSError *error) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            NSInteger warnNum = [responseObject[@"data"][@"warnNum"] integerValue];
            if (warnNum > 0) {
                H5ViewController *h5 = [H5ViewController new];
                h5.titleStr = NSLocalizedString(@"预警记录", nil);
                h5.url = [NSString stringWithFormat:@"https://www02.lantianfangzhou.com/report/heartrate/b7s/%@/%@/0?page=curent",USERID,TOKEN];
                h5.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:h5 animated:YES];
            }else{
                [self.view makeToast:NSLocalizedString(@"暂无预警记录", nil) duration:1.5 position:CSToastPositionCenter];
            }
        }else{
        }
    }];
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"tizheng1",@"tizheng2",@"tizheng3",@"tizheng4",@"tizheng5",@"tizheng6",@"tizheng7",@"tizheng8"];
    guide.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guide animated:YES];
}

-(void)setupView{
    [self SLEremindView];
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    SQLdataManger *manager = [SQLdataManger getInstance];
}

#pragma mark -- 内部方法
- (void)connectLastDevice
{
    NSString *blueToothUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kLastDeviceUUID];
    if (![CositeaBlueTooth sharedInstance].isConnected) {
        if (blueToothUUID && ![blueToothUUID isEqualToString:@""]){
            [[CositeaBlueTooth sharedInstance] connectWithUUID:blueToothUUID];
        }
    }
}
-(void)initPro
{
    [PZBlueToothManager sharedInstance].delegate = self;
}

- (void)setBlocks{
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
            [self uoloadDeviceModel:[CositeaBlueTooth sharedInstance].deviceName];
            
            //查看是否开启通知
            [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_QQ StateBlock:^(int index, int state) {
                if (state) {
                    [weakSelf.view makeToast:NSLocalizedString(@"QQ消息提醒已打开", nil) duration:1.5 position:CSToastPositionBottom];
                }
            }];
            
            [[CositeaBlueTooth sharedInstance] checkSystemAlarmWithType:SystemAlarmType_WeChat StateBlock:^(int index, int state) {
                if (state) {
                    [weakSelf.view makeToast:NSLocalizedString(@"微信消息提醒已打开", nil) duration:1.5 position:CSToastPositionBottom];
                }
            }];
            
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
    
    [BlueToothManager getInstance].delegate = self;
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 - sleep == %d",number);
        if (number) {
            [weakSelf SLErefreshAlertView];
        }
    }];
    
}

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
    
    CGFloat backScrollViewY = SafeAreaTopHeight;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - SafeAreaTopHeight - SafeAreaBottomHeight;
    
    _rateView = [[HeartRateView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _rateView.controller = self;
    [self.view addSubview:_rateView];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SLEconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(SLErefreshAlertView) name:@"didDisconnectDevice" object:nil];
}

//初始化提醒的view  的 刷新
-(void)SLErefreshAlertView
{
    self.SLEconnectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1)) {
            self.rateView.frame = CGRectMake(0,SafeAreaTopHeight,self.rateView.frame.size.width, self.rateView.frame.size.height);
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
    if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1)){
        self.rateView.frame = CGRectMake(0,SafeAreaTopHeight,self.rateView.frame.size.width, self.rateView.frame.size.height);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight+12 - self.SLEconStateView.height-20;
    if(![SLEconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)]){
        self.rateView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEconStateView.height,self.rateView.frame.size.width, height1);
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
        self.rateView.frame = CGRectMake(0,SafeAreaTopHeight,self.rateView.frame.size.width, self.rateView.frame.size.height);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight+12 - self.SLEconStateView.height-20;
    self.rateView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEdoneView.height,self.rateView.frame.size.width, height1);
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

//定位信息
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:{//未定位
        }break;
        default:{//已定位
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadLocation" object:nil];
        }break;
    }
}

//上传设备型号
- (void)uoloadDeviceModel:(NSString *)model{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",UOLOADDEVICEMODEL,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"watch":model} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self.view makeCenterToast:NSLocalizedString(@"网络连接错误", nil)];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                
            } else {
                [self.view makeCenterToast:message];
            }
        }
    }];
}

//上传version
- (void)uoloadVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //获取版本
    NSString *version = [NSString stringWithFormat:@"%@.%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",VERSION,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"version":version} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self.view makeCenterToast:NSLocalizedString(@"网络连接错误", nil)];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                
                NSString *store = responseObject[@"data"][@"version"];
                NSArray *content = responseObject[@"data"][@"content"];
                BOOL result = [version compare:store] == NSOrderedAscending;
                if (result) {
                    [VersionAlertView versionAlertViewWithTitle:message content:content];
                }
            } else {
            }
        }
    }];
}


@end
