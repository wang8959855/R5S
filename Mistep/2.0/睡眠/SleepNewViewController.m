//
//  SleepNewViewController.m
//  Wukong
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "SleepNewViewController.h"
#import "SleepView.h"
#import "SheBeiViewController.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"
#import "HelpSleepViewController.h"

@interface SleepNewViewController ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate>

//睡眠的View
@property (nonatomic, strong) SleepView *sleepView;

@property (nonatomic,strong) ConnectStateView *SLEconStateView;//提示连接的view
@property (nonatomic,strong) UIButton *SLEconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong) NSString *SLEconnectString;//连接字符串。
@property (nonatomic,strong) DoneCustomView *SLEdoneView;
@property (nonatomic,strong) NSString *SLEdoneString;
@property (nonatomic,strong) UILabel *SLEchangLabel;//传递颜色的label

//选择显示类型的view
@property (nonatomic, strong) UIView *selectShowTypeView;

//睡觉
@property (nonatomic, strong) UIButton *sleepButton;
//助眠
@property (nonatomic, strong) UIButton *helpSleepButton;

@end

@implementation SleepNewViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    [self initPro];
    [self connectLastDevice];
    [self setBlocks];
    [self SLErefreshAlertView];
    self.tabBarController.tabBar.hidden = NO;
    [self.datePickBtn setTitle:@"睡眠" forState:UIControlStateNormal];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"sleep1",@"sleep2",@"sleep3"];
    guide.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guide animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 30, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupView{
    [self SLEremindView];
    [self.view addSubview:self.navView];
    self.haveTabBar = YES;
    [HCHCommonManager getAvgHeartRate];
    self.view.backgroundColor = kColor(37 ,124 ,255);
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
    
    //    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
    //        [weakSelf SLErefreshAlertView];
    //    }];
    
    
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
    
    CGFloat backScrollViewY = SafeAreaTopHeight+42+20;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - SafeAreaTopHeight - StatusBarHeight;
    
    //selectShowTypeView
    _selectShowTypeView = [[UIView alloc] init];
    _selectShowTypeView.frame = CGRectMake(ScreenWidth/2-100, SafeAreaTopHeight+12+10, 200, 40);
    _selectShowTypeView.backgroundColor = kColor(214, 241, 251);
    [self.view addSubview:_selectShowTypeView];
    //    _selectShowTypeView.layer.borderWidth = 1;
    //    _selectShowTypeView.layer.borderColor = kColor(210, 210, 210).CGColor;
    _selectShowTypeView.layer.cornerRadius = 20.f;
    _selectShowTypeView.layer.masksToBounds = YES;
    
    //selectShowTypeView上的button
    _sleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sleepButton.frame = CGRectMake(0, 0, 110, 40);
    [_sleepButton setTitle:@"睡眠" forState:UIControlStateNormal];
    [_sleepButton setBackgroundColor:kColor(40, 82, 251)];
    _sleepButton.layer.cornerRadius = 20.f;
    _sleepButton.layer.masksToBounds = YES;
    [_sleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_sleepButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_sleepButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    _sleepButton.selected = YES;
    [_selectShowTypeView addSubview:_sleepButton];
    
    _helpSleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _helpSleepButton.frame = CGRectMake(90, 0, 110, 40);
    [_helpSleepButton setTitle:@"助眠" forState:UIControlStateNormal];
    _helpSleepButton.layer.cornerRadius = 20.f;
    _helpSleepButton.layer.masksToBounds = YES;
    [_helpSleepButton setBackgroundColor:[UIColor clearColor]];
    [_helpSleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_helpSleepButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_helpSleepButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    [_selectShowTypeView addSubview:_helpSleepButton];
    
    WeakSelf
    _sleepView = [[SleepView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _sleepView.controller = self;
    _sleepView.sleepReloadViewBlock = ^(NSString *title) {
        weakSelf.SLEdoneString = title;
    };
    [self.view addSubview:_sleepView];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SLEconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(SLErefreshAlertView) name:@"didDisconnectDevice" object:nil];
}

//切换视图
- (void)changeShowView:(UIButton *)button{
    if (button == _helpSleepButton) {
        HelpSleepViewController *sleep = [HelpSleepViewController new];
        sleep.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sleep animated:YES];
    }
}

//初始化提醒的view  的 刷新
-(void)SLErefreshAlertView
{
    self.SLEconnectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        
        if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1))
        {
            CGFloat height1 = self.view.height-42-SafeAreaTopHeight-48 + self.SLEconStateView.height-20;
            self.selectShowTypeView.frame = CGRectMake(self.selectShowTypeView.frame.origin.x, SafeAreaTopHeight+12, self.selectShowTypeView.frame.size.width, self.selectShowTypeView.frame.size.height);
            self.sleepView.frame = CGRectMake(0,SafeAreaTopHeight+42+20,self.sleepView.frame.size.width, self.sleepView.frame.size.height);
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
    CGFloat height1 = self.view.height-42-SafeAreaTopHeight-48 + self.SLEconStateView.height-20;
    if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1))
    {
        self.selectShowTypeView.frame = CGRectMake(self.selectShowTypeView.frame.origin.x, SafeAreaTopHeight+12, self.selectShowTypeView.frame.size.width, self.selectShowTypeView.frame.size.height);
        self.sleepView.frame = CGRectMake(0,SafeAreaTopHeight+42+20,self.sleepView.frame.size.width, height1);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight-48-42 - self.SLEconStateView.height;
    if(![SLEconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
    {
        self.selectShowTypeView.frame = CGRectMake(self.selectShowTypeView.frame.origin.x, SafeAreaTopHeight+12+self.SLEconStateView.height, self.selectShowTypeView.frame.size.width, self.selectShowTypeView.frame.size.height);
        self.sleepView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEconStateView.height+42+20,self.sleepView.frame.size.width, height1);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight-48-42 + self.SLEconStateView.height-20;
    [UIView animateWithDuration:1.f animations:^{
        self.selectShowTypeView.frame = CGRectMake(self.selectShowTypeView.frame.origin.x, SafeAreaTopHeight+12, self.selectShowTypeView.frame.size.width, self.selectShowTypeView.frame.size.height);
        self.sleepView.frame = CGRectMake(0,SafeAreaTopHeight+42+20,self.sleepView.frame.size.width, height1);
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
    CGFloat height1 = ScreenHeight - SafeAreaTopHeight-48-42 - self.SLEconStateView.height;
    self.selectShowTypeView.frame = CGRectMake(self.selectShowTypeView.frame.origin.x, SafeAreaTopHeight+12+self.SLEconStateView.height, self.selectShowTypeView.frame.size.width, self.selectShowTypeView.frame.size.height);
    self.sleepView.frame = CGRectMake(0,SafeAreaTopHeight+self.SLEdoneView.height+42+20,self.sleepView.frame.size.width, height1);
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
