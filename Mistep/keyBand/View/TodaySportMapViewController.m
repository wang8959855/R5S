//
//  TodaySportMapViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/19.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import "TodaySportMapViewController.h"
#import "SportModelMap.h"
#import "SportMapTableViewCell.h"
#import "MapSportTypeViewController.h"
#import "SportDetailMapTwoViewController.h"
#import "MapSportTypeSelectViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SheBeiViewController.h"
#import "ConnectStateView.h"
//#import "DoneCustomView.h"


@interface TodaySportMapViewController ()<BlutToothManagerDelegate,MapSportTypeSelectViewControllerDelegate,SportMapTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *sportTabelView;  //下半部的运动数组展示
@property (nonatomic,strong)NSMutableArray *sportArray;  //下半部数据
@property (nonatomic,strong)UIAlertView *alert;//不支持这个设备
@property (nonatomic,strong)UIButton *startButton;//开始按钮


@property (nonatomic,strong)ConnectStateView *SPOconStateView;//提示连接的view
@property (nonatomic,strong)UIButton *SPOconnectButton;//显示连接中。。。的button 点击跳转设备管理
@property (nonatomic,strong)NSString *SPOconnectString;//连接字符串。
//@property (nonatomic,strong)DoneCustomView *SPOdoneView;
@property (nonatomic,strong)NSString *SPOdoneString;
@property (nonatomic,strong)UILabel *SPOchangLabel;//传递颜色的label

@property (nonatomic,strong)UIView *backALLView; //背后的所有视图

@end

@implementation TodaySportMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self setupView];
    [self SPOremindView];
    //        [self testView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self childrenTimeSecondChanged];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PSDrawerManager instance] beginDragResponse];
    [BlueToothManager getInstance].delegate = self;
    //    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setSportBlocks];
    [self SPOrefreshAlertView];    //连接的 提示界面
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.tabBarController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)childrenTimeSecondChanged
{
    [self reloadDataALL];//换日期，就刷新界面
}
-(void)setupView
{
    [self initView];
    // 一、背景图
    CGFloat backImageX = 0;
    CGFloat backImageY = 64;
    CGFloat backImageW = CurrentDeviceWidth;
    CGFloat backImageH = CurrentDeviceHeight - 64;
    UIImageView *backImageView = [[UIImageView alloc]init];
    [self.view addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"Layer_one_map"];
    backImageView.frame = CGRectMake(backImageX, backImageY, backImageW, backImageH);
    
    _backALLView = [[UIView alloc]init];
    [self.view addSubview:_backALLView];
    _backALLView.frame = CGRectMake(backImageX, backImageY, backImageW, backImageH);
    
    //上层视图
    UIView *UpView = [[UIView alloc]init];
    [_backALLView addSubview:UpView];
    //        UpView.backgroundColor = allColorRed;
    CGFloat UpViewX = 0;
    CGFloat UpViewY = 0;
    CGFloat UpViewW = CurrentDeviceWidth;
    CGFloat UpViewH = 275*HeightProportion;
    UpView.frame = CGRectMake(UpViewX, UpViewY, UpViewW, UpViewH);
    
    // 二、开始按钮   图   +   按钮
    
    CGFloat startImageViewX = 0;
    CGFloat startImageViewY = 34.5*HeightProportion;
    CGFloat startImageViewW = 125*WidthProportion;
    CGFloat startImageViewH = startImageViewW;
    UIImageView *startImageView = [[UIImageView alloc]init];
    [UpView addSubview:startImageView];
    startImageView.userInteractionEnabled = YES;
    startImageView.image = [UIImage imageNamed:@"Start_icon_map"];
    startImageView.frame = CGRectMake(startImageViewX, startImageViewY, startImageViewW, startImageViewH);
    startImageView.center = UpView.center;
    //     startImageView.centerX = UpView.centerX;
    
    CGFloat startButtonX = 0;
    CGFloat startButtonY = 0;
    CGFloat startButtonW = startImageViewW;
    CGFloat startButtonH = startButtonW;
    UIButton *startButton = [[UIButton alloc]init];
    [startImageView addSubview:startButton];
    startButton.frame = CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH);
    startButton.backgroundColor = [UIColor clearColor];//allColorRed;
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _startButton = startButton;
    
    
    
    // 三、下层view   tableview  - -显示
    CGFloat  downViewX = 8*WidthProportion;
    CGFloat  downViewY = UpViewH;//(startImageViewY + startImageViewH + startImageViewY);
    CGFloat  downViewW = CurrentDeviceWidth - 2*downViewX;
    CGFloat  downViewH = CurrentDeviceHeight - 64 - 49 - UpViewH;//279*HeightProportion;
    UIView *downView = [[UIView alloc]init];
    [_backALLView addSubview:downView];
    downView.frame = CGRectMake(downViewX, downViewY, downViewW, downViewH);
    downView.backgroundColor = allColorWhite;//[UIColor clearColor];
    downView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
    //    downView.alpha = 0.1;
    
    CGFloat sportTabelViewX = 0;
    CGFloat sportTabelViewY = 12.5*HeightProportion;
    CGFloat sportTabelViewW = downViewW;
    CGFloat sportTabelViewH = downViewH - sportTabelViewY;
    
    _sportTabelView = [[UITableView alloc]init];
    _sportTabelView.tableFooterView = [[UIView alloc]init];
    [downView addSubview:_sportTabelView];
    _sportTabelView.backgroundColor = [UIColor clearColor];
    _sportTabelView.delegate = self;
    _sportTabelView.dataSource = self;
    _sportTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sportTabelView.frame = CGRectMake(sportTabelViewX, sportTabelViewY, sportTabelViewW, sportTabelViewH);
}
//开始按钮的开始事件
-(void)startButtonAction
{
    _startButton.userInteractionEnabled = NO;
    
    
    MapSportTypeViewController *sportTypeVC = [[MapSportTypeViewController alloc]init];
    [sportTypeVC setHidesBottomBarWhenPushed:YES];
    sportTypeVC.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:sportTypeVC animated:YES];
    
    _startButton.userInteractionEnabled = YES;
}

-(void)initView
{
    // _stepNumberPlus =0;
    //    _kcalNumberPlus =0;
    //    _heartRateNumberPlus =0;
    //    _pauseFlag = NO;
    //    _heartArray = [NSMutableArray array];
    //    [PZBlueToothManager sharedInstance].delegate = self;
    self.haveTabBar = YES;
    WeakSelf
    [[PZBlueToothManager sharedInstance] recieveOffLineDataWithBlock:^(SportModelMap *model) {
        [weakSelf reloadDataALL];
    }];
    
}
- (void)setSportBlocks
{
    WeakSelf;
    
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        if ([CositeaBlueTooth sharedInstance].isConnected)
        {
            [self SPOConnected];
            [weakSelf performSelector:@selector(SPOsubmitIsConnect) withObject:nil afterDelay:2.0f];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance] checkConnectTimeAlert:^(int number) {
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            [weakSelf SPOconnectionFailedAction:number];
        }
    }];
    
    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
        [weakSelf SPOrefreshAlertView];
    }];
    
    [BlueToothManager getInstance].delegate = self;
    
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 == sport == %d",number);
        if (number) {
            //[weakSelf SPOsubmitIsConnect];
            [weakSelf SPOrefreshAlertView];
        }
    }];
    
}
- (void)reloadDataALL;
{
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.selectTimeSeconds andFormat:@"yyyy-MM-dd"];
    NSArray * array = [[SQLdataManger getInstance] queryHeartRateDataWithDate:timeStr];
    
    _sportArray = [NSMutableArray arrayWithArray:array];
    _sportArray = [self sortSport:_sportArray];
    [self.sportTabelView reloadData];
    
    //        if ([CositeaBlueTooth sharedInstance].isConnected)
    //        {
    //
    //            if(array.count>0)
    //            {
    //                _sportArray = [NSMutableArray arrayWithArray:array];
    //                _sportArray = [self sortSport:_sportArray];
    //                [self.sportTabelView reloadData];
    //            }
    //            else
    //            {
    //                [self performSelector:@selector(reloadTableViewData) withObject:nil afterDelay:0.5f];
    //                //蓝牙没有连接就查询服务器
    //                if(![CositeaBlueTooth sharedInstance].isConnected)
    //                {
    //                    [TimingUploadData downDayOnlinesport:^(NSArray *array) {
    //                        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableViewData) object:nil];
    //                        _sportArray = [NSMutableArray arrayWithArray:array];
    //                        _sportArray = [self sortSport:_sportArray];
    //                        [self.sportTabelView reloadData];
    //                    } date:kHCH.selectTimeSeconds];
    //                }
    //            }
    //        }
    //        else
    //        {
    //            [self performSelector:@selector(reloadTableViewData) withObject:nil afterDelay:0.5f];
    //            [TimingUploadData downDayOnlinesport:^(NSArray *array) {
    //                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableViewData) object:nil];
    //                _sportArray = [NSMutableArray arrayWithArray:array];
    //                _sportArray = [self sortSport:_sportArray];
    //                [self.sportTabelView reloadData];
    //            } date:kHCH.selectTimeSeconds];
    //
    //        }
}
#pragma mark    ---  私有方法
-(void)openHeartRateFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"运动开启失败", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    //alert.tag = 103;
    [alert show];
    
}
-(void)dimissAlert:(UIAlertView *)alert {
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


//#pragma mark  --  tableView -- delegate
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_sportArray.count <=0){
        [self  addTwoFalseData];//添加假数据
        //return _sportArray.count;
    }
    return _sportArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SportMapTableViewCell *cell = [SportMapTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    if (_sportArray.count > 0)
    {
        SportModelMap *model = _sportArray[indexPath.row];
        cell.sport = model;     //模型
        cell.arrayIndex = (NSInteger)indexPath.row; //数组的下标
    }
    cell.backBlock = ^(int aa)
    {
        [self selectCell:aa];
    };
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)selectCell:(int)row
{
    //adaLog(@"row == %d",row);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self tableView:self.sportTabelView didSelectRowAtIndexPath:indexPath];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118*HeightProportion;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    SportModelMap * sportM = _sportArray[indexPath.row];
    if([sportM.sportType integerValue] < 1000)
    {
        SportDetailMapTwoViewController *detailView = [[SportDetailMapTwoViewController alloc]init];
        [detailView setHidesBottomBarWhenPushed:YES];
        detailView.navigationController.navigationBar.hidden = YES;
        detailView.mapSport = (SportModelMap*)sportM;
        [self.navigationController pushViewController:detailView animated:YES];
        
        
    }
    else
    {
        MapSportTypeSelectViewController *sportTypeVC = [[MapSportTypeSelectViewController alloc]init];
        sportTypeVC.sport = sportM;
        sportTypeVC.delegate = self;
        [sportTypeVC setHidesBottomBarWhenPushed:YES];
        sportTypeVC.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:sportTypeVC animated:YES];
        
    }
}
#pragma mark   - - - 排序 各个运动
-(NSMutableArray *)sortSport:(NSMutableArray *)array
{
    
    for (NSInteger i = 0; i<array.count; i++) {
        for (NSInteger j= i+1; j<array.count ; j++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [formatter dateFromString:[(SportModelMap *)array[i] toTime]];
            NSDate *date2 = [formatter dateFromString:[(SportModelMap *)array[j] toTime]];
            NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
            if (aTimer > 0) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}
#pragma mark ---   alertView   delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{  if (alertView.tag == 66)
{
    if([CLLocationManager locationServicesEnabled]){
        //adaLog(@"请允许位置服务");
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL: url];
        }
    }
}
}

-(void)addTwoFalseData
{
    SportModelMap *sport1 = [[SportModelMap alloc]init];
    NSString *currentDateStr = [[[NSDate alloc]init] GetCurrentDateStr];
    
    sport1.sportID = @"0";
    sport1.sportType = @"100";
    sport1.sportDate = currentDateStr;
    sport1.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport1.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport1.stepNumber = @"0";
    sport1.kcalNumber = @"0";
    sport1.sportName = NSLocalizedString(@"徒步",nil);
    sport1.falseData = @"1";
    
    SportModelMap *sport2 = [[SportModelMap alloc]init];
    sport2.sportID = @"1";
    sport2.sportType = @"102";
    sport2.sportDate = currentDateStr;
    sport2.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport2.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    sport2.stepNumber = @"0";
    sport2.kcalNumber = @"0";
    sport2.sportName = NSLocalizedString(@"登山",nil);
    sport2.falseData = @"1";
    //    SportModelMap *sport3 = [[SportModelMap alloc]init];
    //    sport3.sportID = @"1";
    //    sport3.sportType = @"102";
    //    sport3.sportDate = currentDateStr;
    //    sport3.fromTime = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    //    sport3.toTime =  [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    //    sport3.stepNumber = @"0";
    //    sport3.kcalNumber = @"0";
    [_sportArray addObject:sport1];
    [_sportArray addObject:sport2];
    //    [_sportArray addObject:sport3];
}

#pragma mark -   SportTableViewCellDelegate   delete   cell
-(void)deleteSportWithID:(NSString *)sportID
{
    [[SQLdataManger getInstance]deleteDataWithColumns:@{@"sportID":sportID,CurrentUserName_HCH:[[HCHCommonManager getInstance]UserAcount]} fromTableName:@"ONLINESPORT"];
    
    [self childrenTimeSecondChanged];
}
#pragma mark    -- SportModelTableViewControllerDelegate       代理

-(void)callbackSelected:(int)sportType  andSportModel:(SportModelMap *)sport  andSportName:(NSString *)SportName
{
    
    SportDetailMapTwoViewController *detail = [[SportDetailMapTwoViewController alloc]init];
    
    [detail setHidesBottomBarWhenPushed:YES];
    detail.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:detail animated:YES];
    detail.mapSport = sport;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark    ----- 连接状态的提示
-(void)SPOremindView
{
    _SPOchangLabel = [[UILabel alloc]init];
    
    //    [self.view addSubview:self.SPOdoneView];
    //    self.SPOdoneView.alpha = 0;
    
    _SPOconStateView = [[ConnectStateView alloc]init];
    [self.view addSubview:_SPOconStateView];
    CGFloat conStateViewX = 0;
    CGFloat conStateViewY = 64;
    CGFloat conStateViewW = CurrentDeviceWidth;
    CGFloat conStateViewH = 60*HeightProportion;
    _SPOconStateView.frame = CGRectMake(conStateViewX,conStateViewY,conStateViewW,conStateViewH);
    
    
    
    _SPOconnectButton = [[UIButton alloc]init];
    //    _connectButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [_SPOconStateView addSubview:_SPOconnectButton];
    _SPOconnectButton.frame = CGRectMake(0, 0, conStateViewW, conStateViewH);
    [_SPOconnectButton addTarget:self action:@selector(SPOconnectButtonToshebei) forControlEvents:UIControlEventTouchUpInside];
    _SPOconnectButton.sd_layout
    .leftSpaceToView(_SPOconStateView,0)
    .topSpaceToView(_SPOconStateView,0)
    .rightSpaceToView(_SPOconStateView,0)
    .bottomSpaceToView(_SPOconStateView,0);
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SPOconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(SPOrefreshAlertView) name:@"didDisconnectDevice" object:nil];
    
}

//初始化提醒的view  的 刷新
-(void)SPOrefreshAlertView
{
    self.SPOconnectButton.userInteractionEnabled = NO;
    if([CositeaBlueTooth sharedInstance].isConnected)
    {
        self.backALLView.frame = CGRectMake(0,64,self.backALLView.frame.size.width, self.backALLView.frame.size.height);
        self.SPOconStateView.alpha = 0;
    }
    else
    {
        self.SPOconStateView.alpha = 1;
        if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
        {
            if(kHCH.BlueToothState == CBManagerStatePoweredOn)
            {
                //self.connectLabel.text = NSLocalizedString(@"连接中...", nil);
                if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] != 2)//可用
                {
                    self.SPOconnectString = NSLocalizedString(@"连接中...", nil);
                }
                //                else
                //                {
                //                    [self  SPOconnectionFailedAction:10];
                //                }
            }
            else
            {
                self.SPOconnectString  = NSLocalizedString(@"bluetoothNotOpen", nil);
                
            }
        }
        else
        {
            self.SPOconnectString = NSLocalizedString(@"未绑定", nil);
            self.SPOconnectButton.userInteractionEnabled = YES;
            self.SPOconStateView.labeltextColor = [UIColor blueColor];
        }
    }
    
}

-(void)SPOconnectionFailedAction:(int)isSeek
{
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        
        if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] == 2)//可用
        {
            if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 1)    //没有找到
            {
                //                    self.connectStringHight = 2;
                self.SPOconnectString = NSLocalizedString(@"pleaseWakeupDeviceNotfound", nil);
                
            }
            else if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 2)   //找到了
            {
                //                    self.connectStringHight = 2;
                self.SPOconnectString = NSLocalizedString(@"bluetoothConnectionFailed", nil);
            }
        }
    }
    else
    {
        //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
        self.SPOconnectString = NSLocalizedString(@"未绑定", nil);
        self.SPOconnectButton.userInteractionEnabled = YES;
        self.SPOconStateView.labeltextColor = [UIColor blueColor];
    }
    
}

-(void)SPOconnectButtonToshebei
{
    SheBeiViewController *shebeiVC = [SheBeiViewController sharedInstance];
    shebeiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shebeiVC animated:YES];
}
-(void)refreshConnect
{
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {   [self SPOConnected];
        [weakSelf performSelector:@selector(SPOsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        [self SPOConnected];
        [self performSelector:@selector(SPOsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)SPOConnected
{
    self.SPOconnectString = NSLocalizedString(@"connectSuccessfully", nil);
}
-(void)SPOsubmitIsConnect
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(SPOsubmitIsConnect) object:nil];
    
    //    [UIView animateWithDuration:1.5f animations:^{
    //        _connectView.hidden = YES;
    self.SPOconStateView.alpha = 0;
    self.backALLView.frame = CGRectMake(0,64,self.backALLView.frame.size.width, self.backALLView.frame.size.height);
    //    }];
}
-(void)setSPOconnectString:(NSString *)SPOconnectString
{
    _SPOconnectString = SPOconnectString;
    //adaLog(@"--- sport -- connectString - %@",SPOconnectString);
    self.SPOconStateView.stateString = SPOconnectString;
    self.SPOconStateView.labeltextColor = _SPOchangLabel.textColor;
    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize sizeDown3 = [SPOconnectString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
    NSInteger height = sizeDown3.height;
    
    if(height>self.SPOconStateView.height)
    {
        self.SPOconStateView.height =  height;
    }
    if(![SPOconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
    {
        //adaLog(@"连接成功  --- 不进来");
        self.backALLView.frame = CGRectMake(0,64+self.SPOconStateView.height,self.backALLView.frame.size.width, self.backALLView.frame.size.height);
    }
    
    
}

#pragma mark   - -- 蓝牙状态的回调   --- delegate

-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    [self performSelector:@selector(SPOrefreshAlertView) withObject:nil afterDelay:1.f];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
