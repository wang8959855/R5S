//
//  FirstScanDeviceViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//
#define backColorAll  kColor(230,241,254)

#import "FirstScanDeviceViewController.h"
#import "PerModel.h"
#import "PZBlueToothManager.h"

@interface FirstScanDeviceViewController ()<PZBlueToothManagerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSArray *deviceArray;
@property (strong, nonatomic) UITableView *deviceTableView;
@property (nonatomic,strong) UIAlertView * alert;
@end


@implementation FirstScanDeviceViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
- (void)setupView {
    
    [self header];
    [self downView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self searchView];
}
- (void)header {
    CGFloat headImageViewX = 0;
    CGFloat headImageViewY = StatusBarHeight;
    CGFloat headImageViewW = CurrentDeviceWidth;
    CGFloat headImageViewH = 44;
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headImageViewX, headImageViewY, headImageViewW, headImageViewH)];
    
    [self.view addSubview:headImageView];
    headImageView.backgroundColor = [UIColor whiteColor];
    headImageView.userInteractionEnabled = YES;
    headImageView.image = [UIImage imageNamed:@"导航条阴影"];
    
    
    UIButton *buttonBack = [[UIButton alloc]init];
    [headImageView addSubview:buttonBack];
    
    CGFloat buttonBackX = 0;
    CGFloat buttonBackY = 0;
    CGFloat buttonBackW = 44;
    CGFloat buttonBackH = buttonBackW;
    buttonBack.frame = CGRectMake(buttonBackX, buttonBackY, buttonBackW, buttonBackH);
    [buttonBack setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backgroundFirst) forControlEvents:UIControlEventTouchUpInside];
    
    //head  title
    UILabel *headLabel = [[UILabel alloc]init];
    [headImageView addSubview:headLabel];
    CGFloat headLabelW = 200;
    CGFloat headLabelH = 30;
    CGFloat headLabelX = (CurrentDeviceWidth - headLabelW)/2;
    CGFloat headLabelY = (44 - headLabelH)/2;
    headLabel.frame = CGRectMake(headLabelX, headLabelY, headLabelW, headLabelH);
    headLabel.textAlignment = NSTextAlignmentCenter;
    //    headLabel.text = NSLocalizedString(@"设备列表", nil);
    headLabel.text = NSLocalizedString(@"绑定设备", nil);
}
-(void)downView
{     CGFloat TableViewX = 0;
    CGFloat TableViewY = SafeAreaTopHeight;
    CGFloat TableViewW = CurrentDeviceWidth;
    CGFloat TableViewH = 0.76 * CurrentDeviceHeight;
    self.deviceTableView =[[UITableView alloc]initWithFrame:CGRectMake(TableViewX, TableViewY, TableViewW, TableViewH) style:UITableViewStylePlain];
    self.deviceTableView.delegate = self;
    self.deviceTableView.dataSource = self;
    [self.view addSubview:self.deviceTableView];
    self.deviceTableView.backgroundColor = backColorAll;
    self.deviceTableView.tableFooterView = [[UIView alloc]init];
    [self  setupBounds];
    
    
    //    WeakSelf;
    __weak FirstScanDeviceViewController *weakSelf = self;
    [self.deviceTableView addHeaderWithCallback:^{
        weakSelf.deviceArray = nil;
        [[CositeaBlueTooth sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
            NSArray *devices = [array copy];
            
            if ([ADASaveDefaluts getDeviceTypeInt] == 2) {
                weakSelf.deviceArray = [AllTool checkWatch:devices];
            }
            else
            {
                //                weakSelf.deviceArray = [NSMutableArray arrayWithArray:devices];
                weakSelf.deviceArray = [AllTool checkBracelet:devices];
            }
            //            weakSelf.deviceArray = [NSMutableArray arrayWithArray:devices];
            [weakSelf.deviceTableView reloadData];
        }];
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:2.0f];
    }];
    
    
    [PZBlueToothManager sharedInstance].delegate = self;
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        [self removeActityIndicatorFromView:self.view];
        if (number)
        {
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
            
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
            
        }
        else
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
        }
    }];
    
    //    if (_showType)
    //    {
    //        NSString *typeName = [NSString string];
    //        if([ADASaveDefaluts getDeviceTypeInt] > 1)
    //        {
    //            typeName = NSLocalizedString(@"设备类型为手表", nil);
    //        }
    //        else
    //        {
    //            typeName = NSLocalizedString(@"设备类型为手环", nil);
    //        }
    ////        self.alert = [[UIAlertView alloc] initWithTitle:nil message:typeName delegate:nil
    ////                                      cancelButtonTitle:nil otherButtonTitles:nil];
    ////        [self.alert show];
    ////        [self performSelector:@selector(dimissAlert:) withObject:self.alert afterDelay:1.5];
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:typeName preferredStyle:UIAlertControllerStyleActionSheet];
    //        [self presentViewController:alert animated:NO completion:nil];
    //        [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.0];
    //
    //    }
}

-(void)setupBounds {
    CGFloat boundsViewX  = 0;
    CGFloat boundsViewY  = CGRectGetMaxY(self.deviceTableView.frame);
    CGFloat boundsViewW  = CurrentDeviceWidth;
    CGFloat boundsViewH  = CurrentDeviceHeight - CGRectGetMaxY(self.deviceTableView.frame);
    UIView *boundsView = [[UIView alloc]initWithFrame:CGRectMake(boundsViewX, boundsViewY, boundsViewW, boundsViewH)];
    [self.view addSubview:boundsView];
    boundsView.backgroundColor = backColorAll;
    
    CGFloat sousuoButtonX  = 25 * WidthProportion;
    CGFloat sousuoButtonW  = CurrentDeviceWidth - 2*sousuoButtonX;
    CGFloat sousuoButtonH  = 35 * HeightProportion;
    CGFloat sousuoButtonY  = (boundsView.height - sousuoButtonH)/2;
    UIButton *sousuoButton = [[UIButton alloc]initWithFrame:CGRectMake(sousuoButtonX, sousuoButtonY, sousuoButtonW, sousuoButtonH)];
    [boundsView addSubview:sousuoButton];
    sousuoButton.backgroundColor = [UIColor blueColor];
    [sousuoButton setTitle:NSLocalizedString(@"搜索设备", nil) forState:UIControlStateNormal];
    [sousuoButton addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchUpInside];
    sousuoButton.layer.cornerRadius = 5;
    
}
-(void)searchView
{
    if ([HCHCommonManager getInstance].BlueToothState != CBManagerStatePoweredOn)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"请打开蓝牙", nil) deleyTime:2.];
        return;
    }
    
    [self performSelector:@selector(searchDeviceTimeOut) withObject:nil afterDelay:3.f];
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
        NSArray *devices = [array copy];
        if ([ADASaveDefaluts getDeviceTypeInt] == 2) {
            weakSelf.deviceArray = [AllTool checkWatch:devices];
        }
        else
        {
            //            weakSelf.deviceArray = [NSMutableArray arrayWithArray:devices];
            weakSelf.deviceArray = [AllTool checkBracelet:devices];
        }
        //        weakSelf.deviceArray = [NSMutableArray arrayWithArray:devices];
        [weakSelf.deviceTableView reloadData];
    }];
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"搜索设备", nil) detailLabel:NSLocalizedString(@"搜索设备", nil)];
    
}
- (void)searchDeviceTimeOut {
    [self removeActityIndicatorFromView:self.view];
    
    if (_deviceArray.count == 0 && ![BlueToothManager getInstance].isConnected)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"未发现设备", nil) deleyTime:1.5f];
    }
}
- (void)reloadOutTime
{
    [self.deviceTableView headerEndRefreshing];
    //    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = backColorAll;
    }
    if (_deviceArray && _deviceArray.count != 0)
    {
        PerModel *model =  _deviceArray[indexPath.row];
        CBPeripheral *peripheral = model.per;
        cell.textLabel.text = peripheral.name;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在连接...", nil)  detailLabel:@""];
        [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:3.f];
        [[CositeaBlueTooth sharedInstance] connectWithUUID:llString];
        [AllTool  savePeripheral:model];
        [self setHeart];
        //[[CositeaBlueTooth sharedInstance] stopScanDevice];
    }
    else
    {
        //adaLog(@"没有这个外设");
    }
}

//循环设置
- (void)setHeart{
    if ([CositeaBlueTooth sharedInstance].isConnected) {
        //默认打开心率预警和心率检测
        [[CositeaBlueTooth sharedInstance] setHeartRateMonitorDurantionWithTime:62];
        [[CositeaBlueTooth sharedInstance] changeHeartRateMonitorStateWithState:YES];
        
        int maxHeart,maxHeartTwo;
        maxHeart = 220 - [[HCHCommonManager getInstance]getAge];
        maxHeartTwo = maxHeart * 80 /100;
        [[CositeaBlueTooth sharedInstance] setHeartRateAlarmWithState:YES MaxHeartRate:maxHeartTwo MinHeartRate:40];
        
        //默认关闭微信、QQ消息
//        [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:10 State:NO];
//        [[CositeaBlueTooth sharedInstance] setSystemAlarmWithType:9 State:NO];
        
        //运动检测默认关闭
        [[CositeaBlueTooth sharedInstance] setupPageManager:4];
        
    }else{
        [self performSelector:@selector(setHeart) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - bluTooth Connect

- (void)connectTimeOut {
    [self removeActityIndicatorFromView:self.view];
    if (![CositeaBlueTooth sharedInstance].isConnected) {
        
        [self addActityTextInView:self.view text:NSLocalizedString(@"连接超时", nil) deleyTime:1.0f];
        //        [self hidenSearchView:nil];
        //        [BlueToothManager getInstance].connectUUID = @"";
        //        if (_bluetoothScan) {
        //            [_bluetoothScan clearDeviceList];
        //        }
    }
}

#pragma mark - BlueToothDataDelegate

- (void)BlueToothIsConnected:(BOOL)isconnected;
{
    [self removeActityIndicatorFromView:self.view];
    if (isconnected)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
        [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
        [self loginHome];
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
        
    }
}
-(void)backgroundFirst
{
    [self loginHome];
}
-(void) dimissAlert:(UIAlertView *)alert {
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
-(void)dimissAlertController:(UIAlertController *)alert {
    if(alert)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {   [super didReceiveMemoryWarning];  }

@end
