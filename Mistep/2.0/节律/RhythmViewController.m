//
//  RhythmViewController.m
//  Wukong
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "RhythmViewController.h"
#import "DirtyView.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"
#import "SheBeiViewController.h"

@interface RhythmViewController ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate>

@property (nonatomic,strong) ConnectStateView *SLEconStateView;//提示连接的view
@property (nonatomic,strong) UIButton *SLEconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong) NSString *SLEconnectString;//连接字符串。
@property (nonatomic,strong) DoneCustomView *SLEdoneView;
@property (nonatomic,strong) NSString *SLEdoneString;
@property (nonatomic,strong) UILabel *SLEchangLabel;//传递颜色

//脏腑的view
@property (nonatomic, strong) DirtyView *dirtyView;

@end

@implementation RhythmViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    [self initPro];
    [self connectLastDevice];
    [self setBlocks];
    [self SLErefreshAlertView];
    self.tabBarController.tabBar.hidden = NO;
    [self.datePickBtn setTitle:@"节律" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [HCHCommonManager getAvgHeartRate];
    [LoctionUpdateTool sharedInstance];
    [self.backNavView addSubview:self.datePickBtn];
    
    UIButton *shareBtn = [self.view viewWithTag:1002];
    [shareBtn setImage:[UIImage imageNamed:@"share_itb"] forState:UIControlStateNormal];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 30, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy-black"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"jielv1",@"jielv2",@"jielv3"];
    [self.navigationController pushViewController:guide animated:YES];
}

-(void)setupView{
    [self SLEremindView];
    [self.view addSubview:self.backNavView];
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
    
    _dirtyView = [[DirtyView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _dirtyView.controller = self;
    [self.view addSubview:_dirtyView];
    
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
            self.dirtyView.frame = CGRectMake(0,SafeAreaTopHeight,self.dirtyView.frame.size.width, self.dirtyView.frame.size.height);
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
        self.dirtyView.frame = CGRectMake(0,SafeAreaTopHeight,self.dirtyView.frame.size.width, self.dirtyView.frame.size.height);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight+12 - self.SLEconStateView.height-StatusBarHeight;
    if(![SLEconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)]){
        self.dirtyView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEconStateView.height,self.dirtyView.frame.size.width, height1);
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
        self.dirtyView.frame = CGRectMake(0,SafeAreaTopHeight,self.dirtyView.frame.size.width, self.dirtyView.frame.size.height);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight+12 - self.SLEconStateView.height-StatusBarHeight;
    self.dirtyView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEdoneView.height,self.dirtyView.frame.size.width, height1);
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
