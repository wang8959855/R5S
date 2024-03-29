//
//  CositeaBlueTooth.m
//  Mistep
//
//  Created by 迈诺科技 on 16/9/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "CositeaBlueTooth.h"
#import "CositeaBlueToothHeader.h"


@interface CositeaBlueTooth()

@property (strong, nonatomic) CositeaBlueToothManager *cositeaBlueToothManager;
 
@end

@implementation CositeaBlueTooth

+ (CositeaBlueTooth *)sharedInstance
{
    static CositeaBlueTooth * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark -- 扫描方法
- (void)scanDevicesWithBlock:(arrayBlock)deviceArrayBlock
{
    [self.cositeaBlueToothManager scanDevicesWithBlock:deviceArrayBlock];
}

/*
 *停止扫描设备
 **/
- (void)stopScanDevice
{
    [self.cositeaBlueToothManager stopScanDevice];
}
#pragma mark -- 蓝牙状态改变

//变化后通知上层
- (void)connectedStateChangedWithBlock:(intBlock)stateChanged
{
    self.connectState = stateChanged;
}

// 下层变化监测
- (void)connectStateChangedWithBlock:(connectStateChanged)connectStateBlock
{
    [self.cositeaBlueToothManager connectStateChangedWithBlock:connectStateBlock];
}


#pragma mark -- 连接方法
- (void)connectWithUUID:(NSString *)UUID
{
    [self.cositeaBlueToothManager connectWithUUID:UUID];
}
#pragma mark -- 蓝牙发送数据方法

- (void)synsCurTime
{
    [self.cositeaBlueToothManager synsCurTime];
}

- (void)setLanguage
{
    [self.cositeaBlueToothManager setLanguage];
}
- (void)sendBraMMDDformat
{
    [self.cositeaBlueToothManager sendBraMMDDformat];
}

- (void)checkInformation
{
    [self.cositeaBlueToothManager checkInformation];
}

- (void)setUnitStateWithState:(BOOL)state
{
    [self.cositeaBlueToothManager setUnitStateWithState:state];
}

- (void)setBindDateStateWithState:(BOOL)state
{
    [self.cositeaBlueToothManager setBindDateStateWithState:state];
}

- (void)checkBandPowerWithPowerBlock:(intBlock)PowerBlock
{
    [self.cositeaBlueToothManager checkBandPowerWithPowerBlock:PowerBlock];
}

- (void)chekCurDayAllDataWithBlock:(allDayModelBlock)dayTotalDataBlock
{
    [self.cositeaBlueToothManager chekCurDayAllDataWithBlock:dayTotalDataBlock];
}

- (void)openActualHeartRateWithBolock:(intBlock)heartRateBlock
{
    [self.cositeaBlueToothManager openActualHeartRateWithBolock:heartRateBlock];
}

- (void)closeActualHeartRate
{
    [self.cositeaBlueToothManager closeActualHeartRate];
}

- (void)checkHourStepsAndCostsWithBlock:(doubleArrayBlock)dayHourDataBlock
{
    [self.cositeaBlueToothManager checkHourStepsAndCostsWithBlock:dayHourDataBlock];
}

- (void)checkTodaySleepStateWithBlock:(sleepModelBlock)sleepStateArrayBlock;
{
    [self.cositeaBlueToothManager checkTodaySleepStateWithBlock:sleepStateArrayBlock];
}

- (void)checkTodayHeartRateWithBlock:(doubleIntArrayBlock)heartRateArrayBlock
{
    [self.cositeaBlueToothManager checkTodayHeartRateWithBlock:heartRateArrayBlock];
}

- (void)checkHRVWithHRVBlock:(intArrayBlock)HRVDataBlock
{
    [self.cositeaBlueToothManager checkHRVWithHRVBlock:HRVDataBlock];
}

- (void)openFindBindWithBlock:(intBlock)openFindBindBlock
{
    [self.cositeaBlueToothManager openFindBindWithBlock:openFindBindBlock];
}

- (void)CloseFindBindWithBlock:(intBlock)closeFindBindBlock
{
    [self.cositeaBlueToothManager CloseFindBindWithBlock:closeFindBindBlock];
}

- (void)resetBindWithBlock:(intBlock)resetBindBlock
{
    [self.cositeaBlueToothManager resetBindWithBlock:resetBindBlock];
}

- (void)checkVerSionWithBlock:(versionBlock)versionBlock
{
    [self.cositeaBlueToothManager checkVerSionWithBlock:versionBlock];
}

- (void)setAlarmWithAlarmModel:(CustomAlarmModel *)model
{
    [self.cositeaBlueToothManager setAlarmWithAlarmModel:model];
}

- (void)checkAlarmWithBlock:(alarmModelBlock)alarmModelBlock
{
    [self.cositeaBlueToothManager checkAlarmWithBlock:alarmModelBlock];
    //[self.cositeaBlueToothManager chekAlarmWithBlock:alarmModelBlock];
}

- (void)deleteAlarmWithAlarmIndex:(int)index
{
    [self.cositeaBlueToothManager deleteAlarmWithAlarmIndex:index];
}

- (void)checkSystemAlarmWithType:(SystemAlarmType_Enum)type StateBlock:(doubleInt)systemAlarmBlock
{
    [self.cositeaBlueToothManager checkSystemAlarmWithType:type StateBlock:systemAlarmBlock];
}

- (void)setSystemAlarmWithType:(SystemAlarmType_Enum)type State:(int)state
{
    [self.cositeaBlueToothManager setSystemAlarmWithType:type State:state];
}

- (void)checkPhoneDealayWithBlock:(intBlock)phoneDealayBlock
{
    [self.cositeaBlueToothManager checkPhoneDealayWithBlock:phoneDealayBlock];
}

- (void)setPhoneDelayWithDelaySeconds:(int)Seconds
{
    [self.cositeaBlueToothManager setPhoneDelayWithDelaySeconds:Seconds];
}

- (void)checkSedentaryWithSedentaryBlock:(arrayBlock)sedentaryArrayBlock
{
    [self.cositeaBlueToothManager checkSedentaryWithSedentaryBlock:sedentaryArrayBlock];
}

- (void)setSedentaryWithSedentaryModel:(SedentaryModel *)sedentaryMode
{
    [self.cositeaBlueToothManager setSedentaryWithSedentaryModel:sedentaryMode];
}

- (void)deleteSedentaryAlarmWithIndex:(int)index
{
    [self.cositeaBlueToothManager deleteSedentaryAlarmWithIndex:index];
}

- (void)checkHeartTateMonitorwithBlock:(doubleInt)heartRateMonitorBlock
{
    [self.cositeaBlueToothManager checkHeartTateMonitorwithBlock:heartRateMonitorBlock];
}

- (void)changeHeartRateMonitorStateWithState:(BOOL)state
{
    [self.cositeaBlueToothManager changeHeartRateMonitorStateWithState:state];
}

- (void)setHeartRateMonitorDurantionWithTime:(int)Minutes
{
    [self.cositeaBlueToothManager setHeartRateMonitorDurantionWithTime:Minutes];
}

- (void)updateBindROMWithRomUrl:(NSString *)romURL progressBlock:(floatBlock)progressBlock successBlock:(intBlock)success failureBlock:(intBlock)failure
{
    [self.cositeaBlueToothManager updateBindROMWithRomUrl:romURL progressBlock:progressBlock successBlock:success failureBlock:failure];
}

- (void)changeTakePhotoState:(BOOL)state
{
    [self.cositeaBlueToothManager changeTakePhotoState:state];
}

- (void)sendUserInfoToBindWithHeight:(int)height weight:(int)weight male:(BOOL)male age:(int)age
{
    [self.cositeaBlueToothManager sendUserInfoToBindWithHeight:height weight:weight male:male age:age];
}
- (void)checkAction
{
    [self.cositeaBlueToothManager checkAction];
}

- (void)checkParameter
{
    [self.cositeaBlueToothManager checkParameter];
}

#pragma mark -- ada开始写蓝牙方法
//打开心率的命令
-(void)openHeartRate:(startSportBlock)startSportBlock
{
    [self.cositeaBlueToothManager  openHeartRate:startSportBlock];
}
//定时获取心率以及运动数据
-(void)timerGetHeartRateData:(timerGetHeartRate)timerGetHeartRate
{
    [self.cositeaBlueToothManager  timerGetHeartRateData:timerGetHeartRate];
}
//close   心率的命令
-(void)closeHeartRate:(intBlock)closeSportBlock
{
    [self.cositeaBlueToothManager  closeHeartRate:closeSportBlock];
    
}
-(void)getBloodPressure:(bloodPressure)bloodPressure
{
    [self.cositeaBlueToothManager  getBloodPressure:bloodPressure];
}
//检查是否提示了
- (void)checkConnectTimeAlert:(intBlock)TimeAlert
{
    [self.cositeaBlueToothManager  checkConnectTimeAlert:TimeAlert];
}
//检查蓝牙开关
- (void)checkCBCentralManagerState:(BlueToothState)BlueToothState
{
    [self.cositeaBlueToothManager  checkCBCentralManagerState:BlueToothState];
}
//页面管理
- (void)checkPageManager:(uintBlock)pageManager
{
    [self.cositeaBlueToothManager  checkPageManager:pageManager];
}
//页面管理 -- 支持那些页面
- (void)supportPageManager:(uintBlock)page
{
    [self.cositeaBlueToothManager  supportPageManager:page];
    
}

//  set  页面管理
- (void)setupPageManager:(uint)pageString
{
    [self.cositeaBlueToothManager  setupPageManager:pageString];
}
-(void)sendWeather:(PZWeatherModel *)weather//发送天气
{
    [self.cositeaBlueToothManager  sendWeather:weather];
}
-(void)sendWeatherArray:(NSMutableArray *)weatherArr day:(int)day number:(int)number//发送未来几天天气
{
    [self.cositeaBlueToothManager  sendWeatherArray:weatherArr day:day number:number];
}
-(void)sendOneDayWeather:(PZWeatherModel *)weather//发送某天天气   今天
{
    [self.cositeaBlueToothManager  sendOneDayWeather:weather];
}
-(void)sendOneDayWeatherTwo:(WeatherDay *)weather//发送某天天气   某天   < 6
{
    [self.cositeaBlueToothManager  sendOneDayWeatherTwo:weather];
}
//  告诉设备，是否准备接收数据
-(void)readyReceive:(int)number
{
    [self.cositeaBlueToothManager  readyReceive:number];
}
//  设置设备， 校正值   APP设置血压测量配置参数
-(void)setupCorrectNumber
{
    [self.cositeaBlueToothManager  setupCorrectNumber];
}
/**
 发送运动目标和睡眠目标
 */
- (void)activeCompletionDegree
{
    [self.cositeaBlueToothManager activeCompletionDegree];
}

#pragma mark -- 蓝牙接收数据方法

- (void)recieveOffLineDataWithBlock:(offLineDataModel)offLineDataBlock
{
    [self.cositeaBlueToothManager recieveOffLineDataWithBlock:offLineDataBlock];
}

- (void)recieveHistoryAllDayDataWithBlock:(allDayModelBlock)historyAllDayDataBlock
{
    [self.cositeaBlueToothManager recieveHistoryAllDayDataWithBlock:historyAllDayDataBlock];
}

- (void)recieveHistoryHourDataWithBlock:(doubleArrayBlock)historyHourDataBlock
{
    [self.cositeaBlueToothManager recieveHistoryHourDataWithBlock:historyHourDataBlock];
}

- (void)recieveHistorySleepDataWithBlock:(sleepModelBlock)historySleepDataBlock
{
    [self.cositeaBlueToothManager recieveHistorySleepDataWithBlock:historySleepDataBlock];
}

- (void)recieveHistoryHeartRateWithBlock:(doubleIntArrayBlock)historyHeartRateBlock
{
    [self.cositeaBlueToothManager recieveHistoryHeartRateWithBlock:historyHeartRateBlock];
}

- (void)recieveHistoryHRVDataWithBlock:(intArrayBlock)historyHRVDataBlock
{
    [self.cositeaBlueToothManager recieveHistoryHRVDataWithBlock:historyHRVDataBlock];
}

- (void)checkHeartRateAlarmWithHeartRateAlarmBlock:(heartRateAlarmBlock)heartRateAlarmBlock
{
    [self.cositeaBlueToothManager checkHeartRateAlarmWithHeartRateAlarmBlock:heartRateAlarmBlock];
}

- (void)setHeartRateAlarmWithState:(BOOL)state MaxHeartRate:(int)max MinHeartRate:(int)min
{
    [self.cositeaBlueToothManager setHeartRateAlarmWithState:state MaxHeartRate:max MinHeartRate:min];
}

- (void)recieveTakePhotoMessage:(intBlock)takePhotoBlock
{
    [self.cositeaBlueToothManager recieveTakePhotoMessage:takePhotoBlock];
}
#pragma mark   - - 连接蓝牙刷新 的方法
-(void)coreBlueRefresh
{
    [self.cositeaBlueToothManager coreBlueRefresh];
}
#pragma mark -- 断开方法
- (void)disConnectedWithUUID:(NSString *)UUID
{
    [self.cositeaBlueToothManager disConnectedWithUUID:UUID];
}

- (CositeaBlueToothManager*)cositeaBlueToothManager
{
    if (!_cositeaBlueToothManager)
    {
        _cositeaBlueToothManager = [[CositeaBlueToothManager alloc] init];
        [self setBlocks];
    }
    
    return _cositeaBlueToothManager;
}

- (void)setBlocks
{
    WeakSelf;
    [self connectStateChangedWithBlock:^(BOOL isConnect, CBPeripheral *peripheral) {
        
        if (isConnect)
        {
            weakSelf.deviceName = peripheral.name;
            weakSelf.connectUUID = peripheral.identifier.UUIDString;
            [ADASaveDefaluts setObject:weakSelf.deviceName forKey:kLastDeviceNAME];
            [ADASaveDefaluts setObject:weakSelf.connectUUID forKey:kLastDeviceUUID];
        }
        else
        {
            weakSelf.deviceName = nil;
            weakSelf.connectUUID = nil;
        }
        weakSelf.isConnected = isConnect;
        if (self.connectState) {
            self.connectState(isConnect);
        }
    }];
}

/**
 *
 * 心电图测量完成后返回数据
 *
 */
- (void)getECGData:(ecgData)ecg{
    self.cositeaBlueToothManager.ecgData = ecg;
}

@end
