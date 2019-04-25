//
//  SheBeiViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/3.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "SheBeiViewController.h"
#import "TodayViewController.h"
#import "PerModel.h"
#import "DeviceTypeViewController.h"
#import "TodayStepsViewController.h"

@interface SheBeiViewController ()<DeviceTypeViewControllerDelegate,PZBlueToothManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>//BlueToothScanDelegate,

@property (nonatomic,assign) BOOL isChange;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


@end

static NSString *cellReuse = @"Cell";
static NSString *conectReuse = @"connectedCell";


@implementation SheBeiViewController
+ (SheBeiViewController *)sharedInstance
{
    static SheBeiViewController * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
- (void)dealloc
{
    //    [BlueToothData getInstance].shebeiDelegate = nil;
    //    _bluetoothScan.myDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    [self setupView];
    //    [self setupConstraint];
    self.topHeight.constant = SafeAreaTopHeight;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[self initPro];
    [self refreshConnectView];      //刷新状态
    [self refreshHead];             //刷新title
}

- (void)initPro
{
    _isChange = NO;
    //    WeakSelf;
    //    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
    //        [weakSelf refreshConnectView];
    //
    //    }];
}
-(void)refreshConnectView
{
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        //        _stateLabel.text = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
        [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
        
        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
        _deviceName.text = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
        
    }
    else
    {
        _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
        [_searchBtn setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
        _deviceName.text = NSLocalizedString(@"未绑定",nil);
    }
    //    if ([HCHCommonManager getInstance].BlueToothState!=CBManagerStatePoweredOn)
    //    {
    //        _deviceName.text = NSLocalizedString(@"蓝牙已关闭",nil);}
}
- (void)setupView
{
    self.stateLabel.hidden = YES;
    [self setupTopNav];
    //    if ([CositeaBlueTooth sharedInstance].isConnected)
    //    {
    //        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
    //        _deviceName.text = NSLocalizedString(@"已连接",nil);
    //        [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
    //    }
    //    else
    //    {
    //        _deviceName.text = NSLocalizedString(@"未连接",nil);
    //        [_searchBtn setTitle:NSLocalizedString(@"绑定设备",nil) forState:UIControlStateNormal];
    //    }
    //    _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
    __weak SheBeiViewController *weakSelf = self;
    [self.deviceTableView addHeaderWithCallback:^{
        weakSelf.deviceArray = nil;
        [[CositeaBlueTooth sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
            NSArray *devices = [array copy];
            if ([ADASaveDefaluts getDeviceTypeInt] == 2) {
                weakSelf.deviceArray = [AllTool checkWatch:devices];
            }
            else
            {
                weakSelf.deviceArray = [AllTool checkBracelet:devices];//[NSMutableArray arrayWithArray:devices];
            }
            [weakSelf.deviceTableView reloadData];
        }];
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:3.0f];
    }];
    
    [PZBlueToothManager sharedInstance].delegate = self;
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        [self removeActityIndicatorFromView:self.view];
        if (number)
        {
            [self hidenSearchView:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
            
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
            
            _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
            [[CositeaBlueTooth sharedInstance] setupCorrectNumber];
            //            _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
            //            _deviceName.text = NSLocalizedString(@"已连接",nil);
            [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
            
            [self uoloadDeviceModel:[CositeaBlueTooth sharedInstance].deviceName];
            
        }
        else
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
            
            _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
            //            _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
            //            _deviceName.text = NSLocalizedString(@"连接中...",nil);
            //            _stateLabel.text = NSLocalizedString(@"设备未连接", nil);
        }
    }];
    
    _searchViewTopView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [_searchViewTopView addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);
    _searchViewTopView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _searchViewTopView.layer.shadowOffset = CGSizeMake(0, 1);
    _searchViewTopView.layer.shadowOpacity = 0.6;
    _searchViewTopView.layer.shadowRadius = 4;
    //
    ////
    //    UIButton *helpButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*WidthProportion, 50*WidthProportion)];
    //    [self.view addSubview:helpButton];
    //    [helpButton addTarget:self action:@selector(toHelp) forControlEvents:UIControlEventTouchUpInside];
    //    helpButton.center = _helpImageView.center;
    //    helpButton.backgroundColor =  allColorRed;
}

- (IBAction)toHelp:(id)sender
{
    //    HelpBandingViewController *help = [[HelpBandingViewController alloc]init];
    //    [self.navigationController pushViewController:help animated:YES];
}

- (void)setupTopNav
{
    
    CGFloat buttonY = StatusBarHeight;
    CGFloat buttonW = 50;
    CGFloat buttonH = 44;
    CGFloat buttonX = CurrentDeviceWidth - buttonW - 3;
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.topNavView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"deviceTypeA.png"];
   
    CGFloat imageViewW = 22*WidthProportion;
    CGFloat imageViewH = 22*WidthProportion;
    CGFloat imageViewY = StatusBarHeight+10;
    CGFloat imageViewX = CurrentDeviceWidth - imageViewW - 15*WidthProportion;
    
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW,imageViewH);
    
    UIButton *button = [[UIButton alloc]init];
    [self.topNavView addSubview:button];
    //    [button setTitle:NSLocalizedString(@"设备类型", nil) forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"deviceType"] forState:UIControlStateNormal];
    //    button.backgroundColor = allColorRed;
    
    //    button.titleLabel.font = [UIFont systemFontOfSize:14];
    //button.backgroundColor = allColorRed;
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deviceType:) forControlEvents:UIControlEventTouchUpInside];
    //    buttonW = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}].width;
    //    buttonX = CurrentDeviceWidth - buttonW;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    //    WithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)
}
- (void)deviceType:(UIButton *)button
{
    DeviceTypeViewController *deveceType = [[DeviceTypeViewController alloc]init];
    deveceType.navigationController.navigationBar.hidden = YES;
    deveceType.delegate = self;
    [self.navigationController pushViewController:deveceType animated:YES];
}
-(void)refreshHead
{
    if ([[ADASaveDefaluts getDeviceTypeForKey] integerValue] == 2) {
        _titleLabel.text = NSLocalizedString(@"手表", nil);
    } else {
        _titleLabel.text = NSLocalizedString(@"云环", nil);
    }
}
- (void)setXibLabel
{
    
    [self setButtonWithButton:_searchBtn andTitle:kLOCAL(@"搜索设备")];
    _zhaoshouhuanLabel.text = NSLocalizedString(@"找云环", nil);
    _zhaoshouhuanDetailLabel.text = NSLocalizedString(@"", nil);
    _resetLabel.text = NSLocalizedString(@"emptyDeviceData", nil);
    
    _resetDetailLabel.text = NSLocalizedString(@"", nil);
    _clearCacheLabel.text = NSLocalizedString(@"emptyAppData", nil);
    _clearCacheDetalLabel.text = NSLocalizedString(@"", nil);
    _sousuoTitle.text = NSLocalizedString(@"绑定设备", nil);
}


- (void)reloadOutTime
{
    [self.deviceTableView headerEndRefreshing];
    if (_deviceArray.count == 0 && ![BlueToothManager getInstance].isConnected) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"未发现设备", nil) deleyTime:1.5f];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    }
}
#pragma  mark  --- XIB  -- target
- (IBAction)hidenSearchView:(id)sender
{
    self.deviceArray = nil;
    [UIView animateWithDuration:0.23 animations:^{
        _searchView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
    } completion:^(BOOL finished) {
        [_searchView removeFromSuperview];
    }];
    [self refreshConnectView];
    [[CositeaBlueTooth sharedInstance] stopScanDevice];
}

- (IBAction)findBind:(id)sender
{
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {
        [[CositeaBlueTooth sharedInstance] openFindBindWithBlock:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"云环正在振动，点击停止可关闭振动", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"停止",nil) otherButtonTitles:nil, nil];
        alert.tag = 103;
        [alert show];
    }else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"云环未连接", nil) deleyTime:2.];
    }
}

- (IBAction)clearLocalData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"当前操作将清除本应用所有历史数据，是否继续？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.tag = 102;
    [alert show];
    
}

- (IBAction)resetAction
{
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"当前操作将清除云环内所有数据，是否继续？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 101;
        [alert show];
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"云环未连接", nil) deleyTime:2.];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [[CositeaBlueTooth sharedInstance] resetBindWithBlock:nil];
        }
    }else if (alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"BindingDeviceUuid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts remobeObjectForKey:kLastDeviceNAME];
            [ADASaveDefaluts remobeObjectForKey:SUPPORTPAGEMANAGER];
            
            [self showSearchView];
        }
    }else if (alertView.tag == 102)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [self clearLocalTabel];
        }
    }else if (alertView.tag == 103)
    {
        if (buttonIndex == 0)
        {
            [[CositeaBlueTooth sharedInstance] CloseFindBindWithBlock:nil];
            return;
        }
    }
    else if (alertView.tag == 200)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"BindingDeviceUuid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts remobeObjectForKey:kLastDeviceNAME];
            [ADASaveDefaluts remobeObjectForKey:SUPPORTPAGEMANAGER];

            [self refreshConnectView];
            //            [self showSearchView];
            [self performSelector:@selector(callbackUNbinding) withObject:nil afterDelay:1.f];
        }
    }
    
    
}
- (void)callbackUNbinding
{
    if (self.removeBindingBlock)
    {
        self.removeBindingBlock(200);
        //adaLog(@"调用  --- removeBindingBlock");
    }
    
}
- (void)clearLocalTabel
{
    
    [[SQLdataManger getInstance] deleteTabel];
    [[SQLdataManger getInstance] createTable];
    [[SQLdataManger getInstance] createTableTwo];
    [[CoreDataManage shareInstance] deleteData];
    kHCH.queryHearRateSeconed = 0;  //数据全部清除了。要重新请求全天心率
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sousuoAction:(UIButton *)sender
{
    if ([HCHCommonManager getInstance].BlueToothState != CBManagerStatePoweredOn)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"请打开蓝牙", nil) deleyTime:2.];
        
    }
    else
    {
        if ([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"是否解除绑定？",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            alert.tag = 200;
            [alert show];
            return;
        }
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString( @"此操作将删除当前设备连接，并开始搜索新设备，是否继续？",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            alert.tag = 100;
            [alert show];
        }
        else
        {
            [self showSearchView];
        }
        
    }
}



- (void)showSearchView
{
    [AllTool clearDeviceBangding];
    //    [self refreshConnectView];
    [self performSelector:@selector(searchDeviceTimeOut) withObject:nil afterDelay:3.f];
    self.deviceArray = nil;
    
    __weak SheBeiViewController *weakSelf = self;
    [[CositeaBlueTooth sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
        NSArray *devices = [array copy];
        if ([ADASaveDefaluts getDeviceTypeInt] == 2) {
            weakSelf.deviceArray = [AllTool checkWatch:devices];
        }
        else
        {
            weakSelf.deviceArray = [AllTool checkBracelet:devices];//[NSMutableArray arrayWithArray:devices];
        }
        [weakSelf.deviceTableView reloadData];
    }];
    self.deviceTableView.tableFooterView = [[UIView alloc] init];
    //    _bluetoothScan.myDelegate = self;
    _searchView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
    [self.view addSubview:_searchView];
    [UIView animateWithDuration:0.23 animations:^{
        _searchView.frame = CurrentDeviceBounds;
    }];
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"搜索设备", nil) detailLabel:NSLocalizedString(@"搜索设备", nil)];
    
}

- (IBAction)goBackAction:(id)sender
{
    [self backToHome];

//    if ([[ADASaveDefaluts objectForKey:AllDEVICETYPECHANGE] integerValue])
//    {
//        [self backToHome];
//        [ADASaveDefaluts setObject:@NO forKey:AllDEVICETYPECHANGE];
//    }
//    else
//    {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [[TodayStepsViewController sharedInstance] refreshSELF];
}
- (void)setupConstraint
{
    CGFloat stateImageViewX = 30 * WidthProportion;
    CGFloat stateImageViewW = 105 * WidthProportion;
    CGFloat stateImageViewH = stateImageViewW;
    CGFloat stateImageViewY = (self.UpviewBackgroup.height - stateImageViewH) / 2;
    self.stateImageView.frame = CGRectMake(stateImageViewX, stateImageViewY, stateImageViewW, stateImageViewH);
    //    [self.UpviewBackgroup addSubview:self.stateImageView];
    self.stateImageView.sd_layout
    .leftSpaceToView(self.UpviewBackgroup,stateImageViewX)
    .centerYEqualToView(self.UpviewBackgroup)
    .widthIs(stateImageViewW)
    .heightIs(stateImageViewH);
    
    //    CGFloat stateLabelX = CGRectGetMaxX(_stateImageView.frame) + 20 * HeightProportion;
    //    CGFloat stateLabelW = 200 * WidthProportion;
    //    CGFloat stateLabelH = 30 * HeightProportion;
    //    CGFloat stateLabelY = stateImageViewH / 2 + stateImageViewY - stateLabelH;
    //    self.stateLabel.frame = CGRectMake(stateLabelX, stateLabelY, stateLabelW, stateLabelH);
}

- (void)searchDeviceTimeOut {
    [self removeActityIndicatorFromView:self.view];
    
    //    if (_deviceArray.count == 0 && ![BlueToothManager getInstance].isConnected) {
    //        [self addActityTextInView:self.view text:NSLocalizedString(@"未发现设备", nil) deleyTime:1.5f];
    //    }
}
#pragma mark - 解绑传值出去
-(void)changRemoveBinding:(removeBindingBlock)removeBindingBlock
{
    if (removeBindingBlock)
    {
        self.removeBindingBlock = removeBindingBlock;
        //adaLog(@"removeBindingBlock      - - -赋值");
    }
}
#pragma mark - BlueToothDataDelegate

- (void)BlueToothIsConnected:(BOOL)isconnected;
{
    [self removeActityIndicatorFromView:self.view];
    if (isconnected)
    {
        [self hidenSearchView:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
        [HCHCommonManager getInstance].isEquipmentConnect = YES;
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
        
        //        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
        //        _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
        //        _deviceName.text = NSLocalizedString(@"已连接",nil);
        //        [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
        //        [[NSUserDefaults standardUserDefaults] setObject:[BlueToothManager getInstance].connectUUID forKey:kLastDeviceUUID];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //        _stateImageView.image = [UIImage imageNamed:@"SB_yilianjie"];
        //        _stateLabel.text = [BlueToothManager getInstance].deviceName;
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
        [HCHCommonManager getInstance].isEquipmentConnect = NO;
        
        //        _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
        //        _stateLabel.text = NSLocalizedString(@"设备未连接", nil);
        //        _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
        //        _deviceName.text = NSLocalizedString(@"连接中...",nil);
        [_searchBtn setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
    }
}

- (void)resetDeviceOK
{
    [self addActityTextInView:self.view text:NSLocalizedString(@"操作成功", nil) deleyTime:1.5];
}
#pragma mark - delegate

-(void)deviceisChange:(BOOL)change
{
    //adaLog(@"change = %d",change);
    
    self.isChange = change;
    BOOL ischange = [[ADASaveDefaluts objectForKey:AllDEVICETYPECHANGE] boolValue];
    if (ischange == YES) {
        [self refreshHead];
        [self changeDeviceAction];
        NSString *typeName = [NSString string];
        if([ADASaveDefaluts getDeviceTypeInt] == 2)
        {  typeName = NSLocalizedString(@"设备类型已切换为手表", nil);
        }
        else
        {  typeName = NSLocalizedString(@"设备类型已切换为云环", nil);
        }
        //adaLog(@"typeName = %@",typeName);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:typeName preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
    }
    else if (change == NO)
    {
        NSString *typeName = [NSString string];
        if([ADASaveDefaluts getDeviceTypeInt] == 2)
        {
            typeName = NSLocalizedString(@"设备类型已经是手表,无需切换", nil);
        }
        else
        {
            typeName = NSLocalizedString(@"设备类型已经是云环,无需切换", nil);
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:typeName preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alert animated:NO completion:nil];
        [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:0.8];
    }
}
-(void)changeDeviceAction
{
    //    [ADASaveDefaluts remobeObjectForKey:AllDEVICETYPE];
    [ADASaveDefaluts remobeObjectForKey:kLastDeviceUUID];
    [ADASaveDefaluts remobeObjectForKey:kLastDeviceNAME];
    if([CositeaBlueTooth sharedInstance].connectUUID)
    {
        [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
    }
    _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
    //    _stateLabel.text = NSLocalizedString(@"设备未连接", nil);
    //    _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
    //    _deviceName.text = NSLocalizedString(@"连接中...",nil);
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_deviceArray && _deviceArray.count != 0)
    {
        PerModel *model =  _deviceArray[indexPath.row];
        CBPeripheral *peripheral = model.per;
        cell.textLabel.text = peripheral.name;
        //adaLog(@"PerModel - %@",model);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PerModel *model = [_deviceArray objectAtIndex:indexPath.row];
    
    CBPeripheral *dev = model.per;
    if (dev)
    {
        NSString * llString = dev.identifier.UUIDString;
        if (!model.macAddress)
        {
            [AllTool setMacaddress:llString];
        }
        else
        {
            [ADASaveDefaluts setObject:model.macAddress forKey:kLastDeviceMACADDRESS];
        }
        if (model.type)
        {
            [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",model.type] forKey:dev.name];
        }
        
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在连接...", nil)  detailLabel:@""];
        [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:5.f];
        [[CositeaBlueTooth sharedInstance] connectWithUUID:llString];
        [AllTool  savePeripheral:model];
        //[[CositeaBlueTooth sharedInstance] stopScanDevice];
    }
}


-(void)dimissAlertController:(UIAlertController *)alert {
    if(alert)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - bluTooth Connect

- (void)connectTimeOut {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
    [self removeActityIndicatorFromView:self.view];
    if ([CositeaBlueTooth sharedInstance].isConnected) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
        //        _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
        //        _deviceName.text = NSLocalizedString(@"已连接",nil);
        [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
        
        //默认打开心率预警和j心率检测
        [[CositeaBlueTooth sharedInstance] setHeartRateMonitorDurantionWithTime:62];
        [[CositeaBlueTooth sharedInstance] changeHeartRateMonitorStateWithState:YES];
        [[CositeaBlueTooth sharedInstance] setHeartRateAlarmWithState:YES MaxHeartRate:[[[HCHCommonManager getInstance] UserSystolicP] intValue] MinHeartRate:[[[HCHCommonManager getInstance] UserDiastolicP] intValue]];
        //默认关闭微信、QQ消息
        [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:10 State:NO];
        [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:9 State:NO];
        
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"连接超时", nil) deleyTime:1.0f];
        //        [BlueToothManager getInstance].connectUUID = @"";
        //        if (_bluetoothScan) {
        //            [_bluetoothScan clearDeviceList];
        //        }
    }
    [self hidenSearchView:nil];
}

//上传设备型号
- (void)uoloadDeviceModel:(NSString *)model{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",UOLOADDEVICEMODEL,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"watch":model} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self.view makeCenterToast:@"网络连接错误"];
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

@end
