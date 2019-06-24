//
//  CositeaBlueTooth.m
//  Mistep
//
//  Created by 迈诺科技 on 16/9/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "CositeaBlueToothManager.h"
#import "CositeaBlueToothHeader.h"
#import "PZCityTool.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"

#define intToString(x) [NSString stringWithFormat:@"%d",x]
#define ArraySize(ARR) ( (sizeof(ARR)) / ( sizeof(ARR[0])) )


@interface CositeaBlueToothManager()<BlutToothManagerDelegate,BlueToothScanDelegate>

{
    int _packNumber;
    //倒计时 心电图
    int countDown;
    NSTimer *timer;
}

@property (nonatomic, strong) NSMutableArray *ecgArr;

@end

@implementation CositeaBlueToothManager


- (void)dealloc
{
    self.blueToothScan.delegate = nil;
    self.blueToothManager.delegate = nil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.blueToothManager.delegate = self;
        self.blueToothScan.delegate = self;
        [self.blueToothManager  weatherRefresh];
    }
    return self;
}

#pragma mark -- 扫描方法

- (void)scanDevicesWithBlock:(arrayBlock)deviceArrayBlock
{
    [self.blueToothScan startScan];
    // [self.blueToothManager startScanDevice];
    if (deviceArrayBlock)
    {
        self.deviceArrayBlock = deviceArrayBlock;
    }
    [self performSelector:@selector(stopScanDevice) withObject:nil afterDelay:5.f];
}
/*
 *停止扫描设备
 **/
- (void)stopScanDevice
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScanDevice) object:nil];
    [self.blueToothScan stopScan];
    //[self.blueToothManager stopScanDevice];
}

#pragma mark -- BlueToothScanDelegate

- (void)blueToothScanDiscoverPeripheral:(NSMutableArray *)deviceArray
{ 
    if (self.deviceArrayBlock)
    {
        self.deviceArrayBlock(deviceArray);
    }
}

#pragma mark -- 连接蓝牙

- (void)connectWithUUID:(NSString *)UUID;
{
    [self.blueToothManager ConnectWithUUID:UUID];
}

#pragma mark -- 蓝牙状态改变

- (void)connectStateChangedWithBlock:(connectStateChanged)connectStateBlock
{
    if (connectStateBlock)
    {
        self.connectStateBlock = connectStateBlock;
    }
}

#pragma mark -- 断开蓝牙
- (void)disConnectedWithUUID:(NSString *)UUID
{
    [self.blueToothManager disConnectPeripheralWithUuid:UUID];
}

#pragma mark -- 发送蓝牙数据


- (void)synsCurTime
{
    [self.blueToothManager synsCurTime];
}
-(void)setLanguage
{
   [self.blueToothManager setLanguage];
}
- (void)setUnitStateWithState:(BOOL)state
{
    [self.blueToothManager setUnitStateWithState:state];
}

- (void)setBindDateStateWithState:(BOOL)state
{
    [self.blueToothManager setBindDateStateWithState:state];
}

- (void)sendUserInfoToBindWithHeight:(int)height weight:(int)weight male:(BOOL)male age:(int)age
{
    [self.blueToothManager setStepPramWithHeight:height andWeight:weight andSexIndex:male andAge:age];
}

//查询电量
- (void)checkBandPowerWithPowerBlock:(intBlock)PowerBlock;
{
    [self.blueToothManager checkPower];
    if (PowerBlock) {
        self.PowerBlock = PowerBlock;
    }
}

//查询当天数据概览
- (void)chekCurDayAllDataWithBlock:(allDayModelBlock)dayTotalDataBlock;
{
    [self.blueToothManager getCurDayTotalData];
    if (dayTotalDataBlock)
    {
        self.dayTotalDataBlock = dayTotalDataBlock;
    }
}

//开启实时心率查询
- (void)openActualHeartRateWithBolock:(intBlock)heartRateBlock
{
    [self.blueToothManager heartRateNotifyEnable:YES];
    if (heartRateBlock)
    {
        self.heartRateBlock = heartRateBlock;
    }
}

//关闭实时心率查询
- (void)closeActualHeartRate
{
    [self.blueToothManager heartRateNotifyEnable:NO];
}


- (void)checkHourStepsAndCostsWithBlock:(doubleArrayBlock)dayHourDataBlock;
{
    [self.blueToothManager getCurDayTotalDataWithType:@1];
    if (dayHourDataBlock)
    {
        self.dayHourDataBlock = dayHourDataBlock;
    }
}

//查询当天心率
- (void)checkTodayHeartRateWithBlock:(doubleIntArrayBlock)heartRateArrayBlock
{
    if(kHCH.queryHearRateSeconed != 0)
    {
        [self.blueToothManager getNewestCurDayTotalHeartData];
    }
    else
    {
        [self.blueToothManager getCurDayTotalHeartData];
    }
    if (heartRateArrayBlock)
    {
        self.heartRateArrayBlock = heartRateArrayBlock;
    }
}

//查询睡眠数据
- (void)checkTodaySleepStateWithBlock:(sleepModelBlock)sleepStateArrayBlock;
{
    [self.blueToothManager getCurDayTotalDataWithType:@2];
    if (sleepStateArrayBlock)
    {
        self.sleepStateArrayBlock = sleepStateArrayBlock;
    }
}

//查询HRV
- (void)checkHRVWithHRVBlock:(intArrayBlock)HRVDataBlock
{
    [self.blueToothManager getPilaoData];
    if (HRVDataBlock)
    {
        self.HRVDataBlock = HRVDataBlock;
    }
}

//开启找手环功能
- (void)openFindBindWithBlock:(intBlock)openFindBindBlock
{
    [self.blueToothManager findBindState:1];
    if (openFindBindBlock)
    {
        self.openFindBindBlock = openFindBindBlock;
    }
}

//关闭找手环功能
- (void)CloseFindBindWithBlock:(intBlock)closeFindBindBlock
{
    if (closeFindBindBlock)
    {
        self.closeFindBindBlock = closeFindBindBlock;
    }
    [self.blueToothManager findBindState:0];
}

//清除手环数据
- (void)resetBindWithBlock:(intBlock)resetBindBlock
{
    if (resetBindBlock)
    {
        self.resetBindBlock = resetBindBlock;
    }
    [self.blueToothManager resetDevice];
}

//检查手环版本
- (void)checkVerSionWithBlock:(versionBlock)versionBlock
{
    if (versionBlock)
    {
        self.versionBlock = versionBlock;
    }
    [self.blueToothManager checkVersion];
}
//检查是否提示了
- (void)checkConnectTimeAlert:(intBlock)TimeAlert
{
    if (TimeAlert)
    {
        self.TimeAlert = TimeAlert;
    }
    
}
//检查蓝牙开关
- (void)checkCBCentralManagerState:(BlueToothState)BlueToothState
{
    if (BlueToothState)
    {
        self.BlueToothState = BlueToothState;
    }
}
//页面管理
- (void)checkPageManager:(uintBlock)pageManager
{
    if (pageManager)
    {
        self.pageManager = pageManager;
    }
    [self.blueToothManager checkPageManager];
}
//页面管理 -- 支持那些页面
- (void)supportPageManager:(uintBlock)page
{
    if (page)
    {
        self.supportPage = page;
    }
    [self.blueToothManager supportPageManager];
    
}
//  set  页面管理
- (void)setupPageManager:(uint)pageString
{
    [self.blueToothManager setupPageManager:pageString];
}
-(void)sendWeather:(PZWeatherModel *)weather//发送天气
{
    [self.blueToothManager sendWeather:weather];
    
}
-(void)sendWeatherArray:(NSMutableArray *)weatherArr day:(int)day number:(int)number//发送未来几天天气
{
    [self.blueToothManager sendWeatherArray:weatherArr day:day number:number];
}
-(void)sendOneDayWeather:(PZWeatherModel *)weather//发送某天天气   今天
{
    [self.blueToothManager sendOneDayWeather:weather];
}
-(void)sendOneDayWeatherTwo:(WeatherDay *)weather//发送某天天气   某天   < 6
{
    [self.blueToothManager sendOneDayWeatherTwo:weather];
}

- (void)setAlarmWithAlarmModel:(CustomAlarmModel *)model
{
    [self.blueToothManager setCustomAlarmWithStatus:1 alarmIndex:model.index alarmType:model.type alarmCount:(int)model.timeArray.count alarmtimeArray:model.timeArray repeat:[self getRepeatStatusWithArray:model.repeatArray] noticeString:model.noticeString];
}

- (void)checkAlarmWithBlock:(alarmModelBlock)alarmModelBlock
{
    if (alarmModelBlock)
    {
        self.alarmModelBlock = alarmModelBlock;
    }
    [self.blueToothManager queryCustomAlarm];
}

- (void)checkSystemAlarmWithType:(SystemAlarmType_Enum)type StateBlock:(doubleInt)systemAlarmBlock
{
    if (systemAlarmBlock)
    {
        self.systemAlarmBlock = systemAlarmBlock;
    }
    [self.blueToothManager querySystemAlarmWithIndex:type];
}

- (void)setSystemAlarmWithType:(SystemAlarmType_Enum)type State:(int)state
{
    [self.blueToothManager setSystemAlarmWithIndex:type status:state];
}

- (void)deleteAlarmWithAlarmIndex:(int)index
{
    [self.blueToothManager closeCustomAlarmWith:index];
}

- (void)checkPhoneDealayWithBlock:(intBlock)phoneDealayBlock
{
    if (phoneDealayBlock)
    {
        self.phoneDelayBlock = phoneDealayBlock;
    }
    [self.blueToothManager queryPhoneDelay];
}

- (void)setPhoneDelayWithDelaySeconds:(int)Seconds
{
    [self.blueToothManager setPhoneDelay:Seconds];
}

- (void)checkSedentaryWithSedentaryBlock:(arrayBlock)sedentaryArrayBlock
{
    if (sedentaryArrayBlock)
    {
        self.sedentaryArrayBlock = sedentaryArrayBlock;
    }
    [self.blueToothManager queryJiuzuoAlarm];
}

- (void)setSedentaryWithSedentaryModel:(SedentaryModel *)sedentaryModel
{
    [self.blueToothManager setJiuzuoAlarmWithTag:sedentaryModel.index isOpen:1 BeginHour:sedentaryModel.beginHour Minite:sedentaryModel.beginMin EndHour:sedentaryModel.endHour Minite:sedentaryModel.endMin Duration:sedentaryModel.duration];
}

- (void)deleteSedentaryAlarmWithIndex:(int)index
{
    [self.blueToothManager deleteJiuzuoAlarmWithTag:index];
}

- (void)checkHeartTateMonitorwithBlock:(doubleInt)heartRateMonitorBlock
{
    if (heartRateMonitorBlock)
    {
        self.heartRateMonitorBlock = heartRateMonitorBlock;
    }
    [self.blueToothManager queryHeartAndtired];
}

- (void)changeHeartRateMonitorStateWithState:(BOOL)state
{
    [self.blueToothManager setHeartHZState:state];
}

- (void)setHeartRateMonitorDurantionWithTime:(int)Minutes
{
    [self.blueToothManager setHeartDuration:Minutes];
}

- (void)checkHeartRateAlarmWithHeartRateAlarmBlock:(heartRateAlarmBlock)heartRateAlarmBlock
{
    if (heartRateAlarmBlock)
    {
        self.heartRateAlarmBlock = heartRateAlarmBlock;
    }
    [self.blueToothManager queryHeartAlarm];
}

- (void)setHeartRateAlarmWithState:(BOOL)state MaxHeartRate:(int)max MinHeartRate:(int)min
{
    [self.blueToothManager setHeartAlarmWithMin:min andMax:max andState:state];
}

- (void)updateBindROMWithRomUrl:(NSString *)romURL progressBlock:(floatBlock)progressBlock successBlock:(intBlock)success failureBlock:(intBlock)failure
{
    [self.blueToothManager startUpdateHardWithURL:romURL];
    if (progressBlock)
    {
        self.progressBlock = progressBlock;
    }
    if (success) {
        self.updateSuccessBlock = success;
    }
    if (failure) {
        self.updateFailureBlock = failure;
    }
}

- (void)changeTakePhotoState:(BOOL)state
{
    [self.blueToothManager setPhotoWithState:state];
}
#pragma mark -- ada
- (void)openHeartRate:(startSportBlock)startSportBlock
{
    [self.blueToothManager openHeartRate];
    if (startSportBlock) {
        self.startSportBlock = startSportBlock;
    }
    
}
- (void)timerGetHeartRateData:(timerGetHeartRate)timerGetHeartRate
{
    [self.blueToothManager timerGetHeartRateData];
    if (timerGetHeartRate) {
        self.timerGetHeartRate = timerGetHeartRate;
    }
    
}
- (void)closeHeartRate:(intBlock)clockSportBlock
{
    
    [self.blueToothManager closeHeartRate];
    if (clockSportBlock) {
        self.clockSportBlock = clockSportBlock;
    }
}
- (void)getBloodPressure:(bloodPressure)bloodPressure
{
    if (bloodPressure) {
        self.bloodPressure = bloodPressure;
    }
}
-(void)activeCompletionDegree
{
    [self.blueToothManager activeCompletionDegree];
}
//  告诉设备，是否准备接收数据
-(void)readyReceive:(int)number
{
    [self.blueToothManager readyReceive:number];
}
//  设置设备， 校正值   APP设置血压测量配置参数
-(void)setupCorrectNumber
{
    [self.blueToothManager setupCorrectNumber];
}
-(void)checkInformation
{
    [self.blueToothManager checkInformation];
}
- (void)sendBraMMDDformat
{
    [self.blueToothManager sendBraMMDDformat];
}
- (void)checkAction
{
    [self.blueToothManager checkAction];
}
- (void)checkParameter
{
    [self.blueToothManager checkParameter];
}

#pragma mark -- 接收蓝牙数据



#pragma mark -- BlutToothManagerDelegate

- (void)blueToothManagerIsConnected:(BOOL)isConnected connectPeripheral:(CBPeripheral *)peripheral
{
    if (self.connectStateBlock)
    {
        self.connectStateBlock(isConnected,peripheral);
    }
}

#pragma mark   -- -  常用    -- -  常用   -- -  常用   -- -  常用   -- -  常用

//  代理回调了数据，在这里分发  - - -
- (void)blueToothManagerReceiveNotifyData:(NSData *)Dat
{
    
    Byte *transDat = (Byte *)[Dat bytes];
    BOOL flag =[self CheckData:Dat];
    if (!flag) {
        return;
    }
    //    //adaLog(@"recieveData = %@",Dat);
    //    //adaLog(@"transDat = %s",transDat);   a9  29   aa  2a
    switch (transDat[1] & 0x7f) {
        case UnitSet_Enum:  //语言设置  以及各种基本设置
        {
            [self receiveHeartAndTired:Dat];
        }
            break;
        case CheckPower_Enum:  //检测电量
            [self receivePowerDataWith:transDat];
            break;
        case UpdateTotalData_Enum:  //全天数据
            [self receiveTotalDataWith:Dat];
            break;
        case SetStepPram_Enum:
            [self receiveSetStep:Dat];
            break;
        case UpdateOffLine_Enum:  //上传离线数据
            [self receiveOffLineDataWith:Dat];
            int len = 0;
            //Byte *transDat = (Byte *)[Dat bytes];
            uint numberLength = [self combineDataWithAddr:transDat + 2 andLength:2];
            if (numberLength > 17)
            {
                if (transDat[12] == 0x04)
                {           len = 9;
                }
                else
                { len = 11;
                }
                [self.blueToothManager revDataAckWith:UpdateOffLine_Enum andDat:[Dat subdataWithRange:NSMakeRange(4, len)]];
            }
            else
            {
                if(transDat[12] == 0x01) {
                    len = 9;
                }else {
                    len = 11;
                }
                [self.blueToothManager revDataAckWith:UpdateOffLine_Enum andDat:[Dat subdataWithRange:NSMakeRange(4, len)]];
            }
            break;
        case UpdateTiredData_Enum:
            
            [self receivePilaoData:Dat];
            break;
        case FindBand_Enum:
            [self receiveFindBandData:Dat];
            break;
        case ResetDevice_Enum:
        {
            [self receiveResetDeviceData:Dat];
        }
            break;
        case CheckVersion_Enum:
            [self receiveVersionDataWith:transDat];
            break;
        case CustomAlarm_Enum:
        {
            [self recieveCustomAlarmDataWithData:Dat];
        }
            break;
        case OpenAntiLoss_Enum:
            [self recieveAntiLossData:Dat];
            break;
        case PhoneDelay_Enum:
            [self blueToothReceivePhoneDelay:Dat];
            break;
        case JiuzuoAlarm_Enum:
        {
            [self recieveJiuzuoAlarmData:Dat];
        }
            break;
        case HeartRateAlarm_Enum:
        {
            [self recieveHeartRateAlarmWithData:Dat];
        }
            break;
            
        case UpdateHardWare_Enum:   //升级固件
        {
            [self receiveUpdateResponse:Dat];
        }
            break;
        case TakePhoto_Enum:
        {
            [self receiveTakePhoto:Dat];
        }
            break;
        case GetActualData_Enum://打开心率测试   获取实时数据
            // //adaLog(@"transDat   ==  %s",transDat);
            [self receiveopenHeartRate:Dat];
            break;
        case BloodPressure_Enum:  //0x2a    血压   a9  29   aa  2a
            ////adaLog(@"transDat   ==  %s",transDat);
        {
            [self receiveBloodPressure:Dat];
        }
            break;
        case pilaoData_Enum:    //疲劳值不支持  0x65
            [HCHCommonManager getInstance].pilaoValue = NO;
            break;
        case PageManager_None:    //界面管理页面
        {
            ////adaLog(@"transDat   ==  %s",transDat);
            [self receivePageManager:Dat];
        }
            break;
            
        case sendWeatherSuc_Enum:     //天气发送成功
        {
            adaLog(@"------ 天气发送成功");
        }
            break;
        case queryWeather_Enum:     //天气请求数据
        {
            //adaLog(@"天气请求数据");
            [self receiveQueryWeather:Dat];
        }
            break;
            
        case completionDegree_Enum:     //完成度
        {
            ////adaLog(@"完成度");
            [self receiveCompletionDegree:Dat];
        }
            break;
            
        case checkAction_Enum:     //查询设备是否支持某功能
        {
            //            //adaLog(@"是否支持某功能");
            [self receiveCheckAction:Dat];
        }
            break;
            
        case checkNewLength_Enum:     //查询设备是否支持某功能 //查询设备支持 长度
        {
            //            //adaLog(@"支持  长度");
            [self receiveCheckNewLength:Dat];
        }
            break;
//        case 0x28:     //仅测试使用的异常接口
//        {
//            [self receiveTestData:Dat];
//            [self.blueToothManager returnDataWithFlag:transDat[4] andDat:[Dat subdataWithRange:NSMakeRange(Dat.length-4, 2)]];
//        }
//            break;
        default:
            break;
    }
}

//验证数据是合法的
- (BOOL)CheckData:(NSData *)data
{
    Byte *transData = (Byte*)[data bytes];
    uint checkNum = 0;
    for (int i = 0; i < data.length - 2; i ++)
    {
        checkNum += transData[i];
    }
    //自己算出的   校验码CS
    checkNum = checkNum%256;
    //读取校验码
    //    //adaLog(@"读取校验码   ==  %x  %x",transData[data.length - 2],checkNum);
    BOOL flag = YES;
    if (transData[data.length - 2] != checkNum) {
        flag = NO;
    }
    return flag;
}


- (void)recieveAntiLossData:(NSData *)data
{
    //adaLog(@"recieveAntiLossData  - %@",data);
    Byte *transDat = (Byte *)[data bytes];
    if ((transDat[1] & 0x7f) == OpenAntiLoss_Enum && transDat[4] == 1) {
        int tagIndex = transDat[5];
        int state = transDat[6];
        
        if (self.systemAlarmBlock)
        {
            self.systemAlarmBlock(tagIndex,state);
        }
        if (state == 1 && transDat[5] != 1)
        {
            [self.blueToothManager phoneAlarmNotify];
        }
    }
    else if (transDat[4] == 2)
    {
        if(transDat[5] == 16 && transDat[6] == 137)
        {
            [ADASaveDefaluts setObject:@"2" forKey:SUPPORTINFORMATION];//支持Line信息提醒
        }
        
    }
}


- (void)blueToothManagerReceiveHeartRateNotify:(NSData *)Dat
{
    if ([Dat length] < 2) {
        return;
    }
    Byte *transDat = (Byte *)[Dat bytes];
    int heartRate = transDat[1];
    if (self.heartRateBlock)
    {
        self.heartRateBlock(heartRate);
    }
}
-(void)callbackConnectTimeAlert:(int)TimeAlert
{
    
    if (self.TimeAlert)
    {
        self.TimeAlert(TimeAlert);
    }
    //    self.blueToothManager.connectTimeAlert = 2;
}
-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    if (self.BlueToothState)
    {
        self.BlueToothState(state);
    }
    
}
#pragma mark -- 接收到蓝牙数据后处理方法

/**
 *  收到电量处理方法
 *
 *  @param data 收到的数据
 */
- (void)receivePowerDataWith:(Byte *)data
{
    int power = data[4];
    if (self.PowerBlock)
    {
        self.PowerBlock(power);
    }
}
-(void)receiveSetStep:(NSData *)data
{
//    adaLog(@"设置计步参数 bra answer %@",data);
}
/**
 *  收到全天数据，分概览，计步，睡眠，心率4个类型，还需要判断收到历史数据和当天数据
 *
 *
 *  @return
 */
- (void)receiveTotalDataWith:(NSData *)data {
    //    interfaceLog(@"全天总数据%@",data);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        Byte *transDat = (Byte *)[data bytes];
        
        if (data.length  < 8)
        {
            return;
        }
        int curDate = [[TimeCallManager getInstance] getSecondsOfCurDay];
        int dataDate =  [[TimeCallManager getInstance] getYYYYMMDDSecondsWith:[data subdataWithRange:NSMakeRange(4, 3)]];
        
        if (transDat[7] == 0x00)
        {
            uint timeSeconds = dataDate;
            uint stepCount = [self combineDataWithAddr:transDat + 8 andLength:4];
            uint meterCount = [self combineDataWithAddr:transDat + 16 andLength:4];
            uint costCount = [self combineDataWithAddr:transDat + 12 andLength:4];
            uint activity = [self combineDataWithAddr:transDat + 20 andLength:4];
            
            uint activityCosts = [self combineDataWithAddr:transDat + 24 andLength:4];
            uint calmtime = [self combineDataWithAddr:transDat+28 andLength:4];
            uint calmtimeCosts = [self combineDataWithAddr:transDat + 32 andLength:4];
 
            if(stepCount == -1){
                stepCount = 0;
            };
            if(meterCount == -1){ meterCount = 0; };
            if(costCount == -1){ costCount = 0; };
            if(activity == -1){ activity = 0; };
            
            if(activityCosts == -1){ activityCosts = 0; };
            if(calmtime == -1){ calmtime = 0; };
            if(calmtimeCosts == -1){ calmtimeCosts = 0; };
            
            DayOverViewDataModel *daydataModel = [[DayOverViewDataModel alloc] init];
            daydataModel.timeSeconds = timeSeconds;
            daydataModel.steps = stepCount;
            daydataModel.meters = meterCount;
            daydataModel.costs = costCount;
            daydataModel.activityTime = activity;
            daydataModel.calmTime = calmtime;
            daydataModel.activityCosts = activityCosts;
            daydataModel.calmCosts = calmtimeCosts;
            if (curDate != dataDate)
            {
                if (self.historyAlldayModelBlock)
                {
                    self.historyAlldayModelBlock(daydataModel);
                    [self.blueToothManager revDataAckWith:UpdateTotalData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 4)]];
                }
            }
            else
            {
                if (self.dayTotalDataBlock)
                {
                    self.dayTotalDataBlock(daydataModel);
                }
            }
        }
        else if (transDat[7] == 0x01)
        {
            int timeSeconds = dataDate;
            NSMutableArray *stepsArray = [[NSMutableArray alloc] init];
            NSMutableArray *costsArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 24; i ++)
            {
                uint stepsValue = [self combineDataWithAddr:transDat + (8 + 4*i) andLength:4];
                uint costsValue = [self combineDataWithAddr:transDat +(104 + 4*i) andLength:4];
                if (stepsValue == -1)
                {
//                    NSAssert(stepsValue != -1,@"处理-1");
//                    NSAssert(stepsValue != 0xff,@"处理-1");
                    stepsValue = 0;
                }
                if (costsValue == -1)
                {
//                    NSAssert(costsValue != -1,@"处理-1");
//                    NSAssert(costsValue != 0xff,@"处理-1");
                    costsValue = 0;
                }
                [stepsArray addObject:[NSNumber numberWithInt:stepsValue]];
                [costsArray addObject:[NSNumber numberWithInt:costsValue]];
            }
            
            if (curDate == dataDate)
            {
                if (self.dayHourDataBlock)
                {
                    self.dayHourDataBlock(stepsArray,costsArray,timeSeconds);
                }
            }
            else
            {
                if(self.historyHourDataBlock)
                {
                    self.historyHourDataBlock(stepsArray,costsArray,timeSeconds);
                    [self.blueToothManager revDataAckWith:UpdateTotalData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 4)]];
                }
            }
        }
        else if (transDat[7] == 0x02)
        {
            int deepSleep = 0;
            int lightSleep = 0;
            int awakeSleep = 0;
            NSMutableArray *sleepStates = [[NSMutableArray alloc]init];
            for (int i = 0; i < 36; i ++)
            {
                int sleepState = transDat[8+i];
                for (int index = 0; index < 4; index ++)
                {
                    int state = sleepState >> (2 * index) & 0x03;
                    if (state == 0)
                    {
                        awakeSleep ++;
                    }
                    if (state == 1)
                    {
                        lightSleep ++;
                    }
                    if (state == 2)
                    {
                        deepSleep ++;
                    }
                    [sleepStates addObject:[NSNumber numberWithInt:state]];
                }
            }
            SleepModel *sleepModel = [[SleepModel alloc] init];
            sleepModel.timeSeconds = dataDate;
            sleepModel.lightSleepTime = lightSleep * 10;
            sleepModel.deepSleepTime = deepSleep * 10;
            sleepModel.awakeSleepTime = awakeSleep * 10;
            sleepModel.sleepArary = sleepStates;
            if (curDate != dataDate)
            {
                if (self.historySleepStateArrayBlock)
                {
                    self.historySleepStateArrayBlock(sleepModel);
                    [self.blueToothManager revDataAckWith:UpdateTotalData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 4)]];
                }
            }
            else
            {
                if (self.sleepStateArrayBlock)
                {
                    self.sleepStateArrayBlock(sleepModel);
                }
            }
        }
        else if (transDat[7] == 0x03)//全天心率
        {
            NSMutableArray *heartRateArray = [[NSMutableArray alloc]init];
            int packIndex = transDat[9];
            for (int i = 0 ; i < 180 ; i ++)
            {
                int heartRate = transDat[10 + i];
                if (heartRate == 0xff)
                {
                    heartRate = 0;
                }
                [heartRateArray addObject:[NSNumber numberWithInt:heartRate]];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataDate == [[TimeCallManager getInstance] getSecondsOfCurDay])
                {
                    kHCH.queryHearRateSeconed = [[TimeCallManager getInstance] getNowSecond];
                    if (self.heartRateArrayBlock)
                    {
                        self.heartRateArrayBlock(dataDate,packIndex,heartRateArray);
                    }
                }
                else
                {
                    if (self.historyHeartRateArrayBlock)
                    {
                        self.historyHeartRateArrayBlock(dataDate,packIndex,heartRateArray);
                        [_blueToothManager revDataAckWith:UpdateTotalData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 6)]];
                    }
                }
            });
        }
        //            if (curDate != dataDate && transDat[7] != 0x03)
        //            {
        //                [self uploadDataWithTimeSeconds:dataDate];
        //            }
        //            else if (curDate != dataDate && transDat[7] == 0x03)
        //            {
        //                [self uploadDataWithTimeSeconds:dataDate];
        //            }
    });
}

- (void)receivePilaoData:(NSData *)data
{
    WeakSelf;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        int curDate = [[TimeCallManager getInstance] getSecondsOfCurDay];
        int dataDate = [[TimeCallManager getInstance] getYYYYMMDDSecondsWith:[data subdataWithRange:NSMakeRange(4, 3)]];
        
        Byte *transDat = (Byte *)[data bytes];
        NSMutableArray *pilaoArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 24; i ++)
        {
            int pilaoValue = transDat[7+i];
            if (pilaoValue == -1 || pilaoValue == 0xff)
            {
//                NSAssert(pilaoValue != -1,@"处理-1");
//                NSAssert(pilaoValue != 0xff,@"处理-1");
                pilaoValue = 0xff;
            }
            [pilaoArray addObject:[NSNumber numberWithInt:pilaoValue]];
        }
        
        if (curDate == dataDate)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.HRVDataBlock)
                {
                    weakSelf.HRVDataBlock(dataDate,pilaoArray);
                }
            });
        }
        else
        {
            if (weakSelf.historyHRVDataBlock)
            {
                weakSelf.historyHRVDataBlock(dataDate,pilaoArray);
                [_blueToothManager revDataAckWith:UpdateTiredData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 3)]];
            }
        }
    });
}

-(void)receiveFindBandData:(NSData *)data
{
    Byte *transData = (Byte *)[data bytes];
    int state = transData[4];
    if (state ){
        if (self.closeFindBindBlock)
        {
            self.closeFindBindBlock(1);
        }
    }else
    {
        if (self.openFindBindBlock)
        {
            self.openFindBindBlock(1);
        }
    }
}

- (void)receiveResetDeviceData:(NSData *)data
{
    Byte *transData = (Byte *)[data bytes];
    int state = transData[5];
    if (self.resetBindBlock)
    {
        self.resetBindBlock(!state);
    }
}

- (void)receiveVersionDataWith:(Byte *)data {
    
    uint length = [self combineDataWithAddr:data + 2 andLength:2];
    if (length == 3)
    {
        int hardVersion = data[4];
        int softVersion = data[6];
        int blueVersion = data[5];
        if (self.versionBlock)
        {
            self.versionBlock(hardVersion,161616,softVersion,blueVersion);
        }
    }
    else if (length == 4)
    {
        int firstHardVersion = data[4];
        int secondHardVersion = data[5];
        int blueVersion = data[6];
        int softVersion = data[7];
        if (self.versionBlock)
        {
            self.versionBlock(firstHardVersion,secondHardVersion,softVersion,blueVersion);
        }
    }
}

- (void)recieveCustomAlarmDataWithData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    uint totalData = [self combineDataWithAddr:transDat + 2 andLength:2];
    if (totalData == 0)
    {
        return;
    }
    else
    {
        if (totalData > 3)
        {
            NSMutableArray *timeArray = [[NSMutableArray alloc] init];
            int timeCount = transDat[7];
            for ( int i = 0 ; i < timeCount*2; i += 2)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%02d:%02d",transDat[i + 8], transDat[i + 1 + 8]];
                [timeArray addObject:tempStr];
            }
            
            NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
            int subIndex = timeCount * 2 + 8;
            int intRepeat = transDat[subIndex];
            for (int i = 0; i < 7; i ++)
            {
                if ((intRepeat >> i) & 0x01)
                {
                    [repeatArray addObject:@1];
                }else
                {
                    [repeatArray addObject:@0];
                }
            }
            NSString *noticeString = nil;
            if (transDat[6] == 6)
            {
                subIndex += 1 ;
                NSData *ldata = [data subdataWithRange:NSMakeRange(subIndex, [data length] - subIndex - 2)];
                NSString *tempString = [ldata description];
                tempString = [tempString substringWithRange:NSMakeRange(1, tempString.length-2)];
                tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
                noticeString = [self transToUnicodStringWithString:tempString];
                noticeString = [self replaceUnicode:noticeString];
            }
            
            CustomAlarmModel *model = [[CustomAlarmModel alloc] init];
            model.index = transDat[5];
            model.type = transDat[6];
            model.timeArray = timeArray;
            model.repeatArray = repeatArray;
            model.noticeString = noticeString;
            if (self.alarmModelBlock)
            {
                self.alarmModelBlock(model);
            }
        }
    }
}

- (void)blueToothReceivePhoneDelay:(NSData *)Dat
{
    Byte *transDat = (Byte *)[Dat bytes];
    int type = transDat[4];
    if (type == 1)
    {
        
    }
    else
    {
        int delayTime = transDat[5];
        
        if (self.phoneDelayBlock)
        {
            self.phoneDelayBlock(delayTime);
        }
    }
}

- (void)recieveJiuzuoAlarmData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    if (transDat[4] == 0)
    {
        uint length = [self combineDataWithAddr:transDat+2 andLength:2];
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < length/7; i ++)
        {
            int index = 5 + i * 7;
            int tag = transDat[index];
            int beginMin = transDat[index +2];
            int beginHour = transDat[index + 3];
            int endMin = transDat[index + 4];
            int endHour = transDat[index + 5];
            int duration = transDat[index + 6];
            SedentaryModel *model = [[SedentaryModel alloc] init];
            model.index = tag;
            model.beginMin = beginMin;
            model.beginHour = beginHour;
            model.endMin = endMin;
            model.endHour = endHour;
            model.duration = duration;
            [mutaArray addObject:model];
        }
        if (self.sedentaryArrayBlock)
        {
            self.sedentaryArrayBlock(mutaArray);
        }
    }
}
- (void)receiveHeartAndTired:(NSData*)data
{
    Byte *transData = (Byte *)[data bytes];
    //    //adaLog(@"语言设置：%@",data);
    if (transData[4] == 0)   //0 是读取
    {
        //        interfaceLog(@"Language 1111 = read = %@",data);
        //        //adaLog(@"语言设置：%@",data);
        int heartDuration = transData[6];
        if (heartDuration == 60) {   heartDuration = 30;  }
        int tiredState = transData[8];
        if (self.heartRateMonitorBlock)
        {
            self.heartRateMonitorBlock(heartDuration,tiredState);
        }
    }
    else if (transData[4] == 1) //1 是设置
    {
        //        interfaceLog(@"Language 1111 = Answer = %@",data);
        //             interfaceLog(@"连续心率监测 bra answer %@",data);
    }
    
}

- (void)recieveHeartRateAlarmWithData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    if (transDat[4] == 2)
    {
        int state = !transDat[5];
        int max = transDat[6];
        int min = transDat[7];
        if (self.heartRateAlarmBlock)
        {
            self.heartRateAlarmBlock (state,max,min);
        }
    }
}

- (void)receiveUpdateResponse:(NSData *)data
{
    //adaLog(@"UpdateHard == %@",data);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reSendUpdataData) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDateFaile) object:nil];
    Byte *transDat = (Byte *)[data bytes];
    if (transDat[4] == 0x00)
    {
        [self performSelector:@selector(reSendUpdataData) withObject:nil afterDelay:2];
        [self performSelector:@selector(upDateFaile) withObject:nil afterDelay:6];
        [self.blueToothManager updateHardWaerWithPackIndex:1];
        _packNumber = 1;
        
    }
    else if (transDat[4] == 0x01)
    {
        uint totalPack = [self combineDataWithAddr:transDat + 5 andLength:2];
        uint pack = [self combineDataWithAddr:transDat + 7 andLength:2];
        
        if (self.progressBlock)
        {
            float progress = 0;
            float fPack = (float)pack;
            progress = fPack/totalPack;
            self.progressBlock(progress);
        }
        
        if (pack < totalPack)
        {
            [self.blueToothManager updateHardWaerWithPackIndex:pack +1];
            _packNumber = pack +1;
            [self performSelector:@selector(reSendUpdataData) withObject:nil afterDelay:2];
            [self performSelector:@selector(upDateFaile) withObject:nil afterDelay:6];
        }
        else
        {
            [self.blueToothManager updatehardwaerComplete];
        }
    }
    else if (transDat[4] == 0x02)
    {
        if(self.updateSuccessBlock)
        {
            self.updateSuccessBlock(1);
        }
        return;
    }
}

- (void)receiveTakePhoto:(NSData *)data
{
    if (self.takePhotoBlock)
    {
        self.takePhotoBlock(1);
        [self.blueToothManager answerTakePhoto];
    }
}
-(void)receiveopenHeartRate:(NSData *)data
{
    //adaLog(@"receiveopenHeartRate  ==  %@",data);
    
    Byte * byteout = (Byte*)[data bytes];
    //心率开关
    if(byteout[4] == 1)
    {
        if (self.startSportBlock)
            self.startSportBlock(byteout[4]);
        return;
    }
    //心率  - -关
    else if(byteout[4] == 2)
    {
        if (self.clockSportBlock)
            self.clockSportBlock(byteout[4]);
        return;
    }
    else
    {
        //心率数据
        //  心率   1   heartRate
        //当前步数  4  stepNumber
        //当前里程  4  mileageNumber
        //当前消耗热量    4  kcalNumber
        //当前步速  1   stepSpeed
        uint  heartRate = [self combineDataWithAddr:byteout + 5 andLength:1];
        uint  stepNumber = [self combineDataWithAddr:byteout + 6 andLength:4];
        uint  mileageNumber = [self combineDataWithAddr:byteout + 10 andLength:4];
        uint  kcalNumber = [self combineDataWithAddr:byteout + 14 andLength:4];
        uint  stepSpeed = [self combineDataWithAddr:byteout + 18 andLength:1];
        //adaLog(@"heartRate率 =  %d -stepSpeed = %d ",heartRate,stepSpeed);
        SportModelMap *sport = [[SportModelMap alloc]init];
        sport.heartRate = [NSString stringWithFormat:@"%d",heartRate];
        sport.stepNumber = [NSString stringWithFormat:@"%d",stepNumber];;
        sport.mileageNumber = [NSString stringWithFormat:@"%d",mileageNumber];
        sport.kcalNumber = [NSString stringWithFormat:@"%d",kcalNumber];
        sport.stepSpeed = [NSString stringWithFormat:@"%d",stepSpeed];
        if (self.timerGetHeartRate)  self.timerGetHeartRate(sport);
    }
    
    //很重要的转字符串的代码
    //    NSMutableString * string = [[NSMutableString alloc] init];
    //    for (int i = 0; i < data.length; i++) {
    //        NSString * tempString = [NSString stringWithFormat:@"%x",byteout[i]];
    //        if (tempString.length == 1) {
    //            tempString = [NSString stringWithFormat:@"0%@",tempString];
    //        }
    //        [string appendString:tempString];
    //    }
    //    NSLog(@"string  = = %@",string);
    
}
-(void)receiveBloodPressure:(NSData *)data
{
    //adaLog(@"receiveBloodPressure  ==  %@",data);
    
    Byte * byteout = (Byte*)[data bytes];
    if(byteout[4] == 0)//接收血压数据
    {
        
        //4	时间（UTC）
        //1	收缩压
        //1	舒张压
        //1	心率
        //1	SPO2
        //1	HRV
        uint  dataNum  = [self combineDataWithAddr:byteout + 2 andLength:2];
        int  dataNumber = (dataNum - 1) / 9;
        NSArray * bloodArr = [[SQLdataManger getInstance]queryBloodPressureWithDay:[[[NSDate alloc]init] GetCurrentDateStr]];
        if (dataNumber > 1)
        {
            int systemTimeOffset = 0;
            uint  time = 0;
            NSString *testTime = [NSString string];
            for (int i = 0; i< dataNumber; i++)
            {
                systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
                time = [self combineDataWithAddr:byteout + 5 + 9 * i andLength:4] - systemTimeOffset;
                testTime = [[TimeCallManager getInstance] getTimeStringWithSeconds:time andFormat:@"yyyy-MM-dd HH:mm:ss"];
                BOOL isHave = NO;
                if (bloodArr) {
                    for (NSDictionary *dictionary in bloodArr) {
                        if ([dictionary[@"StartTime"] isEqualToString:testTime])  isHave = YES;
                    }
                }
                
                if (!isHave) {
                    uint  shrink = [self combineDataWithAddr:byteout + 9 + 9 * i andLength:1];
                    uint  Diastole = [self combineDataWithAddr:byteout + 10 + 9 * i andLength:1];
                    uint  heartRate = [self combineDataWithAddr:byteout + 11 + 9 * i andLength:1];
                    uint  spo2 = [self combineDataWithAddr:byteout + 12 + 9 * i andLength:1];
                    uint  hrv = [self combineDataWithAddr:byteout + 13 + 9 * i andLength:1];
                    
                    //adaLog(@"time = %d,shrink = %d,Diastole = %d,heartRate = %d,spo2 = %d, hrv= %d,",time,shrink,Diastole,heartRate,spo2,hrv);
                    BloodPressureModel *bloodPre = [[BloodPressureModel alloc]init];
                    bloodPre.BloodPressureID = [NSString stringWithFormat:@"%ld",[[SQLdataManger  getInstance] queryBloodPressureALL]];
                    bloodPre.BloodPressureDate = [[TimeCallManager getInstance] getTimeStringWithSeconds:time andFormat:@"yyyy-MM-dd"];
                    bloodPre.StartTime = testTime;
                    bloodPre.systolicPressure = [NSString stringWithFormat:@"%d",shrink];
                    bloodPre.diastolicPressure = [NSString stringWithFormat:@"%d",Diastole];
                    bloodPre.heartRate = [NSString stringWithFormat:@"%d",heartRate];
                    bloodPre.SPO2 = [NSString stringWithFormat:@"%d",spo2];
                    bloodPre.HRV = [NSString stringWithFormat:@"%d",hrv];
                    if (dataNumber == i+1) {
                        if (self.bloodPressure)   self.bloodPressure(bloodPre);
                    }
                }
            }
        }
        
        if (timer != nil) {
            //测量成功
            [timer invalidate];
            timer = nil;
            
            //数据格式转换
            NSMutableString *ecg = [NSMutableString string];
            for (NSString *dataStr in self.ecgArr) {
                for (int i = 0; i < 10; i++) {
                    NSString *numStr = [dataStr substringWithRange:NSMakeRange(i*2, 2)];
                    NSInteger index = [AllTool hexStringTranslateToDoInteger:numStr];
                    [ecg appendString:[NSString stringWithFormat:@"%ld,",index]];
                }
            }
            
            //血氧
            NSString *spo2 = [NSString stringWithFormat:@"%d",[self combineDataWithAddr:byteout + 12 andLength:1]];
            
            //房颤
            NSString *AF = @"60";
            
            //心率
            NSString *heartRate = [NSString stringWithFormat:@"%d",[self combineDataWithAddr:byteout + 11 andLength:1]];
            
            //心电图上传
            if (self.ecgData) {
                self.ecgData(ecg,spo2,AF,heartRate);
            }
            self.ecgArr = nil;
        }
        
        else if(dataNumber == 1)
        {
            int systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
            uint  time = [self combineDataWithAddr:byteout + 5 andLength:4] - systemTimeOffset;
            NSString *testTime = [[TimeCallManager getInstance] getTimeStringWithSeconds:time andFormat:@"yyyy-MM-dd HH:mm:ss"];
            BOOL isHave = NO;
            for (NSDictionary *dictionary in bloodArr) {
                if ([dictionary[@"StartTime"] isEqualToString:testTime])
                    isHave = YES;
                
            }
            if (!isHave) {
                //收缩压
                uint  shrink = [self combineDataWithAddr:byteout + 9 andLength:1];
                //舒张压
                uint  Diastole = [self combineDataWithAddr:byteout + 10 andLength:1];
                uint  heartRate = [self combineDataWithAddr:byteout + 11 andLength:1];
                uint  spo2 = [self combineDataWithAddr:byteout + 12 andLength:1];
                uint  hrv = [self combineDataWithAddr:byteout + 13 andLength:1];
                
                //adaLog(@"time = %d,shrink = %d,Diastole = %d,heartRate = %d,spo2 = %d, hrv= %d,",time,shrink,Diastole,heartRate,spo2,hrv);
                BloodPressureModel *bloodPre = [[BloodPressureModel alloc]init];
                bloodPre.BloodPressureID = [NSString stringWithFormat:@"%ld",[[SQLdataManger  getInstance] queryBloodPressureALL]];
                bloodPre.BloodPressureDate = [[TimeCallManager getInstance] getTimeStringWithSeconds:time andFormat:@"yyyy-MM-dd"];
                bloodPre.StartTime = testTime;
                bloodPre.systolicPressure = [NSString stringWithFormat:@"%d",shrink];
                bloodPre.diastolicPressure = [NSString stringWithFormat:@"%d",Diastole];
                bloodPre.heartRate = [NSString stringWithFormat:@"%d",heartRate];
                bloodPre.SPO2 = [NSString stringWithFormat:@"%d",spo2];
                bloodPre.HRV = [NSString stringWithFormat:@"%d",hrv];
                
                if (self.bloodPressure)
                {
                    self.bloodPressure(bloodPre);
                }
            }
        }
        
        [self.blueToothManager answerBloodPressure];
    }
    else if(byteout[4] == 1)//接收血压数据  设备应答
    {
        adaLog(@"准备接收血压数据的设备应答 -- %d",byteout[4]);
    }
    else if(byteout[4] == 2)//应答设备是否在血压界面
    {
        //        interfaceLog(@"准备好接收血压原始数据  bra ask %@",data);
        //直接回复。没有准备好
        
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        UIViewController *vc = window.rootViewController;
        //        if(vc)
        //        {
        //            //#warning   mm_drawerController   tabbar  index
        //            //            MMDrawerController * drawerController =(MMDrawerController *)vc;
        //            //            MainTabBarController *tabBar = (MainTabBarController *) drawerController.centerViewController;
        //            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //            MainTabBarController *tabBar =tempAppDelegate.mainTabBarController;
        //            if (tabBar.selectedIndex == 3)
        //            {
        //                [self.blueToothManager answerReadyReceive:1];
        //            }
        //            else
        //            {
        [self.blueToothManager answerReadyReceive:1];
        adaLog(@"应答设备是否在血压界面 -- %d",byteout[4]);
        //            }
        //        }
    }
    else if(byteout[4] == 3)    //接收原始数据
    {
        int ppgLength = byteout[5];
        int ecgWeizhi = ppgLength+6;
        int ecgLength = byteout[ecgWeizhi];
        
//        [self.blueToothManager :[data subdataWithRange:NSMakeRange(ecgLength+ecgWeizhi, 2)]];
        
        NSData *ecgData = [data subdataWithRange:NSMakeRange(27, 20)];
        NSString *ecgStr = [NSString stringWithFormat:@"%@",ecgData];
        ecgStr = [ecgStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        ecgStr = [ecgStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
        ecgStr = [ecgStr stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSLog(@"%@",ecgData);
        [self.ecgArr addObject:ecgStr];
        
        countDown = 5;
        if (timer == nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ecgCountDown) userInfo:nil repeats:YES];
        }
        
        adaLog(@"--    ----接收原始数据");
//        if (byteout[5] == 1)
//        {
//            adaLog(@"--  成功  ----接收原始数据");
//        }
//        else
//        {
//            adaLog(@"--  失败  ----接收原始数据");
//        }
    }
    else if(byteout[4] == 4)    //设备获取血压测量配置参数
    {
        adaLog(@"----获取血压测量配置参数");
        [self.blueToothManager answerCorrectNumber];
    }
    else if(byteout[4] == 5)    //设备应答   设置血压测量配置参数
    {
        if (byteout[5] == 1)
        {
            adaLog(@"--  成功  --设置血压测量配置参数");
        }
        else
        {
            adaLog(@"--  失败  --设置血压测量配置参数");
        }
        
        //        [self.blueToothManager answerCorrectNumber];
    }
}
-(void)receivePageManager:(NSData *)data
{
    //    //adaLog(@"receivePageManager  ==  %@",data);
    
    Byte *byteout = (Byte*)[data bytes];
    
    if(byteout[4] == 2)//APP读取设备页面配置
    {
        //           interfaceLog(@"page 读取设备页面的配置 bra answer %@",data);
        
        uint  numberTwo = [self combineDataWithAddr:byteout + 5 andLength:4];
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%u",numberTwo] forKey:SHOWPAGEMANAGER];
        if (self.pageManager) {
            self.pageManager(numberTwo);
        }
    }
    else if(byteout[4] == 3)//APP读取设备支持的页面配置：
    {
        //         interfaceLog(@"page  APP读取设备支持的页面配置 answer %@",data);
        uint number = [self combineDataWithAddr:byteout + 5 andLength:4];
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%u",number] forKey:SUPPORTPAGEMANAGER];
        if (self.supportPage) {
            self.supportPage(number);
        }
    }
    else if(byteout[4] == 1)
    {
        //        interfaceLog(@"page 333 bra answer %@",data);
        //        //adaLog(@"设备应答：");
        //int  number = [self combineDataWithAddr:byteout + 5 andLength:4];
        //self.supportPage(number);
    }
}
/**
 *
 *      查询天气
 *
 **/
-(void)receiveQueryWeather:(NSData *)data
{
    Byte *byteout = (Byte*)[data bytes];
    int weatherID = byteout[4];
//    adaLog(@"请求未来的天气。。  == %@",data);
    if(byteout[4] == 1)//未来某天的天气
    {
        uint ri = [self combineDataWithAddr:byteout + 6 andLength:1];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:intToString(weatherID),QUERYWEATHERID,intToString(ri),QUERYWEATHERRI, nil];
        [kHCH.queryWeatherArray addObject:dict];
        
    }
    else if (byteout[4] == 2)//未来某几天的天气  最多也就是三天
    {
        int systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
        uint nums = [self combineDataWithAddr:byteout + 5 andLength:3]  - systemTimeOffset;
        uint dayNumber = [self combineDataWithAddr:byteout + 8 andLength:1];
        if (dayNumber > 7)
        {
            dayNumber = 1;
        }
        int timeSeconds = [[TimeCallManager getInstance]getYYYYMMDDSecondsSince1970With:nums];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:intToString(weatherID),QUERYWEATHERID,intToString(timeSeconds),QUERYWEATHERRI,intToString(dayNumber),QUERYWEATHERDAYNUMBER, nil];
        [kHCH.queryWeatherArray addObject:dic];
    }
    [[PZCityTool sharedInstance] refresh];
}

/**
 *
 *      查询完成度
 *
 **/
-(void)receiveCompletionDegree:(NSData *)data
{
    Byte *byteout = (Byte*)[data bytes];
    uint code = [self combineDataWithAddr:byteout + 4 andLength:1];
    if(code==1)
    {
        //        interfaceLog(@"CompletionDegree  222   == DEV - inquiry %@",data);
        
        //        adaLog(@"target == bra ask  %@",data);
        [self.blueToothManager returnCompletionDegree];
        [ADASaveDefaluts setObject:@"1" forKey:COMPLETIONDEGREESUPPORT];
    }
    else if(code==2)
    {
        adaLog(@"target == app set 目标发送成功 %@",data);
        //        interfaceLog(@"CompletionDegree  222   == DEV - ansSet %@",data);
        
    }
}

/**
 *
 *   1 查询设备是否支持某功能
 *   2 APP查询设备能支持的参数
 **/
-(void)receiveCheckAction:(NSData *)data
{
    Byte *byteout = (Byte*)[data bytes];
    uint code = [self combineDataWithAddr:byteout + 4 andLength:1];
    if(code == 1)
    {
        //        adaLog(@" APP查询功能支持码    answer%@",data);
        uint heartContinuity = [self combineDataWithAddr:byteout + 5 andLength:1];
        uint supportCode = [self combineDataWithAddr:byteout + 6 andLength:1];
        [self  supportQuery:heartContinuity support:supportCode];
        
        uint newAlarm = [self combineDataWithAddr:byteout + 7 andLength:1];
        uint supportCodeAlarm = [self combineDataWithAddr:byteout + 8 andLength:1];
        [self  supportQuery:newAlarm support:supportCodeAlarm];
        
        uint weatherID = [self combineDataWithAddr:byteout + 9 andLength:1];
        uint weatherCode = [self combineDataWithAddr:byteout + 10 andLength:1];
        [self  supportQuery:weatherID support:weatherCode];
    }
    else if(code == 2)
    {
        //         interfaceLog(@"  APP查询设备能支持的参数 answer%@",data);
        
        uint remindLength = [self combineDataWithAddr:byteout + 5 andLength:1];
        if (remindLength == 1)//查询设备支持的消息提醒最大长度
        {
            uint remind = [self combineDataWithAddr:byteout + 6 andLength:1];
            [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",remind] forKey:REMINDLENGTH];
        }
        else if (remindLength == 2)//查询设备支持的自定义提醒的最大长度
        {
            uint remind = [self combineDataWithAddr:byteout + 6 andLength:1];
            [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",remind] forKey:CUSTOMREMINDLENGTH];
        }
        
        uint customRemindLength = [self combineDataWithAddr:byteout + 7 andLength:1];
        if (customRemindLength == 1)
        {
            uint customRemind = [self combineDataWithAddr:byteout + 8 andLength:1];
            [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",customRemind] forKey:REMINDLENGTH];
        }
        else if (customRemindLength == 2)
        {
            uint customRemind = [self combineDataWithAddr:byteout + 8 andLength:1];
            [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",customRemind] forKey:CUSTOMREMINDLENGTH];
        }
    }
    
}
-(void)supportQuery:(int)code support:(int)supportNum
{
    if (code == 4)
    {
        //        int supportCode = [self combineDataWithAddr:byteout + 6 andLength:1];
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",supportNum] forKey:HEARTCONTINUITY];
    }
    else if (code == 5)
    {
        //        int supportCode = [self combineDataWithAddr:byteout + 6 andLength:1];
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",supportNum] forKey:NEWALARM];
    }
    else if(code == 3)
    {
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",supportNum] forKey:WEATHERSUPPORT];
        [self.blueToothManager  weatherRefresh];
    }
    
}
/**
 *
 *   FLAG: 0X01 重设消息提醒内容(UTF-8编码）的最大长度（包括电话提醒和其他消息如QQ，微信等的提醒）；  安卓的。ios不用做
 
 0X02 重设自定义提醒的最大长度（unicode编码）
 
 底层要求回复 YES  不然总是询问
 *
 **/
-(void)receiveCheckNewLength:(NSData *)data
{
    //     interfaceLog(@"手环设置APP参数 bra ask %@",data);
    Byte *byteout = (Byte*)[data bytes];
    uint code = [self combineDataWithAddr:byteout + 4 andLength:1];
    uint remind = [self combineDataWithAddr:byteout + 5 andLength:1];
    if(code == 1)
    {
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",remind] forKey:REMINDLENGTH];//查询设备支持的消息提醒最大长度
        [self.blueToothManager answerBraceletSetParam:code];
    }
    else  if(code == 2)
    {
        [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",remind] forKey:CUSTOMREMINDLENGTH];//查询设备支持的自定义提醒的最大长度
        [self.blueToothManager answerBraceletSetParam:code];
    }
}
//接收测试数据
//- (void)receiveTestData:(NSData *)data
//{
//
//}
#pragma mark -- 收到离线数据历史数据等

- (void)recieveOffLineDataWithBlock:(offLineDataModel)offLineDataBlock
{
    if (offLineDataBlock)
    {
        self.offLineDataModelBlock = offLineDataBlock;
    }
}
/**
 *  收到离线数据
 *
 *  @param data data description
 */
- (void) receiveOffLineDataWith:(NSData *)data
{
    
    Byte *transDat = (Byte *)[data bytes];
    int systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
    uint numberLength = [self combineDataWithAddr:transDat + 2 andLength:2];
    if (numberLength > 17)
    {
        if (transDat[12] == 0x04)
        {
            uint nums = [self combineDataWithAddr:transDat + 4 andLength:4]  - systemTimeOffset;  //秒数
            int timeSeconds = [[TimeCallManager getInstance]getYYYYMMDDSecondsSince1970With:nums]; //日期
            int start_Seconds = nums;
            int startTimeSeconds = nums;
            
            nums = [self combineDataWithAddr:transDat + 8 andLength:4] - systemTimeOffset;
            int stopSeconds = nums;
            int stopTimeSeconds = nums;
            
            uint sportType = [self combineDataWithAddr:transDat + 13 andLength:1];//手表已经有运动类型
            uint costs = [self combineDataWithAddr:transDat + 14 andLength:4];
            uint steps = [self combineDataWithAddr:transDat + 18 andLength:4];
            
            
            SportModelMap *sport = [[SportModelMap alloc]init];
            //            sport.sportID = [NSString stringWithFormat:@"%ld",[[SQLdataManger getInstance] queryHeartRateDataWithAll]];
            sport.sportID = [AllTool getSportIDMax:[[SQLdataManger getInstance] queryMaxSportID]];
            sport.timeSeconds = timeSeconds;
            sport.startTimeSeconds = startTimeSeconds;
            sport.stopTimeSeconds = stopTimeSeconds;
            sport.sportType = [NSString stringWithFormat:@"%d",sportType];
            sport.sportDate = [[TimeCallManager getInstance] getTimeStringWithSeconds:timeSeconds andFormat:@"yyyy-MM-dd"];
            sport.fromTime = [[TimeCallManager getInstance] getTimeStringWithSeconds:start_Seconds andFormat:@"yyyy-MM-dd HH:mm:ss"];
            sport.toTime = [[TimeCallManager getInstance] getTimeStringWithSeconds:stopSeconds andFormat:@"yyyy-MM-dd HH:mm:ss"];
            sport.stepNumber = [NSString stringWithFormat:@"%d",steps];
            sport.kcalNumber = [NSString stringWithFormat:@"%d",costs];
            
            int interval = [[TimeCallManager getInstance] getIntervalOneMinWith:[[TimeCallManager getInstance] getNowSecond] andEndTime:kHCH.queryHearRateSeconed];
            if(interval > 2)
            {
                [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
                    if ([HCHCommonManager getInstance].requestIndex!= -1 &&[HCHCommonManager getInstance].requestIndex ==index)
                    {
                        if (self.offLineDataModelBlock) { self.offLineDataModelBlock(sport); }
                        //回调数据数据
                        [HCHCommonManager getInstance].requestIndex = -1;
                    }
                    //adaLog(@"离线数据包 index -- %d",index);
                }];
                
                
            }
            else
            {
                if (self.offLineDataModelBlock) { self.offLineDataModelBlock(sport);}
            }
        }
    }
    else
    {
        if (transDat[12] == 0x01)
        {
            //            int systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
            //            Byte *transDat = (Byte *)[data bytes];
            //        if (transDat[12] == 0x01)
            //        {
            //        OffLineDataModel *model = [[OffLineDataModel alloc] init];
            //        model.timeSeconds = timeSeconds;
            //        model.startSeconds = start_Seconds;
            //        model.stopSeconds = stopSeconds;
            //        model.steps = steps;
            //        model.costs = costs;
            uint nums = [self combineDataWithAddr:transDat + 4 andLength:4]  - systemTimeOffset;
            uint timeSeconds = [[TimeCallManager getInstance]getYYYYMMDDSecondsSince1970With:nums];
            uint start_Seconds = nums;
            uint startTimeSeconds = nums;
            nums = [self combineDataWithAddr:transDat + 8 andLength:4] - systemTimeOffset;
            uint stopSeconds = nums;
            uint stopTimeSeconds = nums;
            uint steps = [self combineDataWithAddr:transDat + 17 andLength:4];
            uint costs = [self combineDataWithAddr:transDat + 13 andLength:4];
            
            SportModelMap *sport = [[SportModelMap alloc]init];
            sport.sportID = [AllTool getSportIDMax:[[SQLdataManger getInstance] queryMaxSportID]];
            
            sport.timeSeconds = timeSeconds;
            sport.startTimeSeconds = startTimeSeconds;
            sport.stopTimeSeconds = stopTimeSeconds;
            sport.sportType = @"1000";
            sport.timeSeconds = timeSeconds;
            sport.sportDate = [[TimeCallManager getInstance] getTimeStringWithSeconds:timeSeconds andFormat:@"yyyy-MM-dd"];
            sport.fromTime = [[TimeCallManager getInstance] getTimeStringWithSeconds:start_Seconds andFormat:@"yyyy-MM-dd HH:mm:ss"];
            sport.toTime = [[TimeCallManager getInstance] getTimeStringWithSeconds:stopSeconds andFormat:@"yyyy-MM-dd HH:mm:ss"];
            sport.stepNumber = [NSString stringWithFormat:@"%d",steps];
            sport.kcalNumber = [NSString stringWithFormat:@"%d",costs];
            
            int interval = [[TimeCallManager getInstance] getIntervalOneMinWith:[[TimeCallManager getInstance] getNowSecond] andEndTime:kHCH.queryHearRateSeconed];
            if(interval > 2)
            {
                [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
                    if ([HCHCommonManager getInstance].requestIndex!= -1 &&[HCHCommonManager getInstance].requestIndex ==index)
                    {
                        if (self.offLineDataModelBlock) { self.offLineDataModelBlock(sport); }
                        //回调数据数据
                        [HCHCommonManager getInstance].requestIndex = -1;
                    }
                    //adaLog(@"离线数据包 index -- %d",index);
                }];
            }
            else
            {
                if (self.offLineDataModelBlock) { self.offLineDataModelBlock(sport);}
            }
            
        }
    }
    
}


//收到全天历史数据
- (void)recieveHistoryAllDayDataWithBlock:(allDayModelBlock)historyAllDayDataBlock
{
    if (historyAllDayDataBlock)
    {
        self.historyAlldayModelBlock = historyAllDayDataBlock;
    }
}

//收到每小时步数全天数据
- (void)recieveHistoryHourDataWithBlock:(doubleArrayBlock)historyHourDataBlock
{
    if (historyHourDataBlock)
    {
        self.historyHourDataBlock = historyHourDataBlock;
    }
}

//收到历史睡眠数据
- (void)recieveHistorySleepDataWithBlock:(sleepModelBlock)historySleepDataBlock
{
    if (historySleepDataBlock)
    {
        self.historySleepStateArrayBlock = historySleepDataBlock;
    }
}

//收到历史心率数据
- (void)recieveHistoryHeartRateWithBlock:(doubleIntArrayBlock)historyHeartRateBlock
{
    if (historyHeartRateBlock)
    {
        self.historyHeartRateArrayBlock = historyHeartRateBlock;
    }
}

//收到疲劳数据
- (void)recieveHistoryHRVDataWithBlock:(intArrayBlock)historyHRVDataBlock
{
    if (historyHRVDataBlock)
    {
        self.historyHRVDataBlock = historyHRVDataBlock;
    }
}

/**
 *
 * 心电图测量完成后返回数据
 *
 */
- (void)getECGData:(ecgData)ecg{
    if (ecg) {
        self.ecgData = ecg;        
    }
}

//接受到拍照指令
- (void)recieveTakePhotoMessage:(intBlock)takePhotoBlock
{
    if(takePhotoBlock)
    {
        self.takePhotoBlock = takePhotoBlock;
    }
}

#pragma mark -- 处理数据工具方法
- (uint)combineDataWithAddr:(Byte *)addr andLength:(uint)len {
    uint result = 0;
    for (uint index = 0; index < len; index ++) {
        result = result | ((*(addr + index)) << (8 *index));
        
    }
    //    if (result < 0)
    //    {
    //        result = 0;
    //    }
    return result;
}
/**
 public static byte[] int2Byte_LH(int a) {
 byte[] b = new byte[4];
 b[3] = (byte) (a >> 24);
 b[2] = (byte) (a >> 16);
 b[1] = (byte) (a >> 8);
 b[0] = (byte) (a);
 return b;
 }
 
 public static int byte2Int(byte[] b, int offset) {
 return ((b[offset++] & 0xff)) | ((b[offset++] & 0xff) << 8)
 | ((b[offset++] & 0xff) << 16) | ((b[offset++] & 0xff) << 24);
 }
 
 **/

- (int)getRepeatStatusWithArray:(NSArray*)repeatArray
{
    int status = 0;
    for (int i = 0; i < 7; i ++)
    {
        if ([repeatArray[i] intValue] == YES)
        {
            status = status| (0x01 << (i));
        }
    }
    return status;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


- (NSString *)transToUnicodStringWithString:(NSString *)string
{
    NSMutableString *resultStr = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i < string.length/4; i++)
    {
        NSMutableString *mutString = [[NSMutableString alloc] initWithCapacity:0];
        NSRange range = NSMakeRange(4*i, 4);
        NSString *cString = [string substringWithRange:range];
        [mutString appendString:[cString substringWithRange:NSMakeRange(2, 2)]];
        [mutString appendString:[cString substringWithRange:NSMakeRange(0, 2)]];
        [resultStr appendString:@"\\u"];
        [resultStr appendString:mutString];
    }
    return resultStr;
}


#pragma mark -- 内部调用方法

- (void)reSendUpdataData
{
    [self.blueToothManager updateHardWaerWithPackIndex:_packNumber];
    [self performSelector:@selector(reSendUpdataData) withObject:nil afterDelay:2];
}

- (void)upDateFaile
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reSendUpdataData) object:nil];
    
    if (self.updateFailureBlock)
    {
        self.updateFailureBlock(1);
    }
}
#pragma mark   - - 连接蓝牙刷新 的方法
-(void)coreBlueRefresh
{
    [self.blueToothManager coreBlueRefresh];
}
#pragma mark -- 全局变量get方法

- (BlueToothScan *)blueToothScan
{
    if (!_blueToothScan)
    {
        _blueToothScan = [[BlueToothScan alloc] init];
    }
    return _blueToothScan;
}

- (BlueToothManager *)blueToothManager
{
    if (!_blueToothManager)
    {
        _blueToothManager = [[BlueToothManager alloc] init];// [BlueToothManager getInstance];
    }
    return _blueToothManager;
}

- (NSMutableArray *)ecgArr{
    if (!_ecgArr) {
        _ecgArr = [NSMutableArray array];
    }
    return _ecgArr;
}

//心电图测量失败
- (void)ecgCountDown{
    countDown--;
    if (countDown == 0) {
        self.ecgArr = nil;
        [timer invalidate];
        timer = nil;
    }
}

@end
