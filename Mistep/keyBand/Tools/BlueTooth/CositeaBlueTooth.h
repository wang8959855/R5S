//
//  CositeaBlueTooth.h
//  Mistep
//
//  Created by 迈诺科技 on 16/9/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//  请保持CositeaBlueTooth 与 CositeaBlueToothManager 一样的注释

#import <Foundation/Foundation.h>
#import "CositeaBlueToothManager.h"
#import "PZWeatherModel.h"
#import "WeatherDay.h"

@interface CositeaBlueTooth : NSObject


#pragma mark -- 属性
/**
 *  蓝牙连接状态，YES为已连接，NO为未连接
 */
@property (unsafe_unretained, nonatomic) BOOL isConnected;

/**
 *  蓝牙连接状态，YES为已连接，NO为未连接   intBlock   block
 */
@property (copy, nonatomic) intBlock connectState;

/**
 *  状态为已连接时，值为已连接设备的UUID，此UUID可用于连接设备和断开设备
 状态为未连接时，值为nil
 */
@property (strong, nonatomic) NSString *connectUUID;

/**
 *  状态为已连接时，值为已连接设备的设备名称
 状态为未连接时，值为nil
 */
@property (strong, nonatomic) NSString *deviceName;

#pragma mark   --    蓝牙模块(发送蓝牙指令)
#pragma mark -- 获取对象方法
/**
 *  获取蓝牙管理对象
 *
 *  @return 蓝牙管理的对象
 */
+ (CositeaBlueTooth *)sharedInstance;

#pragma mark -- 扫描设备方法
/**
 *  蓝牙扫描设备的方法，block返回的为扫描到的设备的数组，数组里的内容为PerModel,此block会多次执行，每次返回的数组都会更新
 *
 *  @param deviceArrayBlock 返回设备列表数组
 */
- (void)scanDevicesWithBlock:(arrayBlock)deviceArrayBlock;

/*
 *停止扫描设备
 **/
- (void)stopScanDevice;
#pragma mark -- 连接蓝牙方法

/**
 *  根据UUID连接设备
 *
 *  @param UUID 要连接设备的UUID，NSString格式，此方法不提供连接是否成功的判断，请用下方监测蓝牙连接状态方法来监测连接成功或设备断开
 
 */
- (void)connectWithUUID:(NSString *)UUID;

#pragma mark -- 监测蓝牙状态变化方法
/**
 *  实现此方法可以监测蓝牙连接状态变化
 *
 *  @param stateChanged block传递为一个int值，1为设备已连接，0为设备已断开
 */
- (void)connectedStateChangedWithBlock:(intBlock)stateChanged;

#pragma mark -- 断开蓝牙方法
/**
 *  断开蓝牙方法
 *
 *  @param UUID 当前连接设备的UUID
 */
- (void)disConnectedWithUUID:(NSString *)UUID;

//#pragma mark -- 蓝牙发送数据方法
#pragma mark   --   设置模块(发送命令指令，例如同步时间)


/**
 *
 * app与手环的时间同步
 *
 */
- (void)synsCurTime;
/**
 *
 * 同步语言。支持中，英，泰。不是这三种语言。就是英文
 *
 */
-(void)setLanguage;

/**
 *
 * 发送手环的显示日期的格式 日月
 *
 */
- (void)sendBraMMDDformat;
/**
 *
 * 读取信息提醒的支持
 *
 */
- (void)checkInformation;
/**
 *
 * app设置手环的公制/英制    NO:公制     YES:英制
 *
 */
- (void)setUnitStateWithState:(BOOL)state;

/**
 *
 * app设置手环的时间是12小时制或24小时制
 *  NO:12小时制    YES:24小时制
 */

- (void)setBindDateStateWithState:(BOOL)state;

/**
 *  检查手环电量
 *
 *  @param PowerBlock block返回一个int参数，值为当前电量值 电池电量：0-100
 */
- (void)checkBandPowerWithPowerBlock:(intBlock)PowerBlock;

/**
 *
 * 拍照功能  - 开关
 * YES - 打开拍照  NO - 关闭拍照
 */
- (void)changeTakePhotoState:(BOOL)state;
//接受到拍照指令
- (void)recieveTakePhotoMessage:(intBlock)takePhotoBlock;

/**
 开启找手环功能
 
 @param openFindBindBlock 返回为int值，为1则为成功
 */
- (void)openFindBindWithBlock:(intBlock)openFindBindBlock;


/**
 关闭找手环功能
 
 @param closeFindBindBlock 返回为int值，为1则为成功
 */
- (void)CloseFindBindWithBlock:(intBlock)closeFindBindBlock;

/**
 *
 *清除手环数据
 *
 */
- (void)resetBindWithBlock:(intBlock)resetBindBlock;

/**
 *
 *检查手环版本
 *
 */
- (void)checkVerSionWithBlock:(versionBlock)versionBlock;


/**
 *  开启实时心率
 *
 *  @param heartRateBlock block传递一个int值为心率值，开启实时心率后，block会每秒执行一次，返回当前心率值
 */
- (void)openActualHeartRateWithBolock:(intBlock)heartRateBlock;

/**
 *  关闭实时心率
 */
- (void)closeActualHeartRate;

/**
 *
 *设置自定义闹铃
 *
 */
- (void)setAlarmWithAlarmModel:(CustomAlarmModel *)model;

/**
 *
 *查询自定义闹铃
 *
 */
- (void)checkAlarmWithBlock:(alarmModelBlock)alarmModelBlock;

/**
 *
 * 删除自定义闹铃
 * index = 固定编号，提醒个数最大为8
 */
- (void)deleteAlarmWithAlarmIndex:(int)index;


/**
 *
 * 心率监控间隔 - 心率自动监控开关 -查询
 *
 */
- (void)checkHeartTateMonitorwithBlock:(doubleInt)heartRateMonitorBlock;


/**
 *
 * 心率自动监控开关 -  设置
 NO：关闭    YES：开启
 *
 */
- (void)changeHeartRateMonitorStateWithState:(BOOL)state;

/**
 *
 * 心率监控间隔 -- 设置 -- 常常设置30分钟或60分钟
 *单位分钟：最小值5分钟，最大值60分钟； 若为0X01, 表示连续心率监测(注：目前大部分设备不支持连续心率监测）
 */
- (void)setHeartRateMonitorDurantionWithTime:(int)Minutes;
/**
 *
 *  心率预警 - 读取
 *
 */
- (void)checkHeartRateAlarmWithHeartRateAlarmBlock:(heartRateAlarmBlock)heartRateAlarmBlock;
/**
 *
 * 心率预警 - 设置
 * NO：启动 YES：关闭
 */
- (void)setHeartRateAlarmWithState:(BOOL)state MaxHeartRate:(int)max MinHeartRate:(int)min;
/**
 *
 * 固件升级
 *
 */
- (void)updateBindROMWithRomUrl:(NSString *)romURL progressBlock:(floatBlock)progressBlock successBlock:(intBlock)success failureBlock:(intBlock)failure;

/**
 *
 * 设置计步参数
 * @param height:身高 weight:体重 male:性别 age:年龄
 * 身高	1	单位厘米
 * 体重	1	单位千克
 * 性别	1	NO：男性，YES：女性
 * 年龄	1	单位周岁
 */
- (void)sendUserInfoToBindWithHeight:(int)height weight:(int)weight male:(BOOL)male age:(int)age;


/**
 *
 * 查询设备是否支持某功能
 *
 */
-(void)checkAction;
/**
 *
 * APP查询设备能支持的参数
 *
 */
-(void)checkParameter;

#pragma mark   --   功能模块(发送数据指令）

/**
 *
 *读取对应的提醒状态
 *
 */
- (void)checkSystemAlarmWithType:(SystemAlarmType_Enum)type StateBlock:(doubleInt)systemAlarmBlock;

/**
 *
 *  设置对应的提醒状态
 *  state =  NO：关 YES：开
 */
- (void)setSystemAlarmWithType:(SystemAlarmType_Enum)type State:(int)state;

/**
 *
 * 电话提醒延时功能 - 查询
 *
 */
- (void)checkPhoneDealayWithBlock:(intBlock)phoneDealayBlock;
/**
 *
 * 电话提醒延时功能 - 设置
 * 延时时间：秒为单位 Seconds --- 常常设置为 立即，5秒，10秒
 */
- (void)setPhoneDelayWithDelaySeconds:(int)Seconds;



/**
 发送运动目标和睡眠目标
 */
- (void)activeCompletionDegree;

#pragma mark   --   获取手环数据模块(例如步数)

/**
 *  获取当天全天数据概览
 *
 *  @param dayTotalDataBlock block内返回当天数据的DayOverViewDataModel,详情请进入model查看。
 */
- (void)chekCurDayAllDataWithBlock:(allDayModelBlock)dayTotalDataBlock;



/**
 *  查询每小时步数及卡路里消耗
 *
 *  @param dayHourDataBlock 返回步数数组，共24小时每小时步数 卡路里消耗数组，24小时每小时消耗，timeSeconds 当天时间秒数
 */
- (void)checkHourStepsAndCostsWithBlock:(doubleArrayBlock)dayHourDataBlock;

/**
 查看今天睡眠数据
 
 @param sleepStateArrayBlock 返回sleepModel,此接口只返回今天0点以后数据，需要截取前天历史睡眠数据进行拼接成完整睡眠数据
 */
- (void)checkTodaySleepStateWithBlock:(sleepModelBlock)sleepStateArrayBlock;

/**
 查看当天心率数据
 
 @param heartRateArrayBlock 心率数据返回三个值，1、今天的时间，已秒数格式返回，2、心率包序号（1-8），3、心率数组。心率数据每分钟一个值，没有值为0，全天心率1440分钟，分为8个包，每个包为3个小时数据，用包序号区分。查询当天心率会查询从0点到当前时间的心率值，此block最多会执行8次，每次返回的数组为180个值，用包序号来确定具体时间。
 */
- (void)checkTodayHeartRateWithBlock:(doubleIntArrayBlock)heartRateArrayBlock;

/**
 查询HRV值
 
 @param HRVDataBlock 返回内容有两个，1、今天时间 2、HRV值数组，共24个值，为每小时HRV，没有值则为0 HRV取值范围为0-100，表示当前用户疲劳状态。值越低表示越疲劳，100则表示充满活力
 */
- (void)checkHRVWithHRVBlock:(intArrayBlock)HRVDataBlock;

/**
 *
 * 久坐提醒功能 - 查询
 *
 */
- (void)checkSedentaryWithSedentaryBlock:(arrayBlock)sedentaryArrayBlock;

/**
 *
 * 久坐提醒功能 - 设置
 *
 */
- (void)setSedentaryWithSedentaryModel:(SedentaryModel *)sedentaryModel;

/**
 *
 * 久坐提醒功能 - 删除
 *   index久坐提醒的编号
 */
- (void)deleteSedentaryAlarmWithIndex:(int)index;


#pragma mark -- ada 写 

/**
 *打开心率的命令
 *
 */
-(void)openHeartRate:(startSportBlock)startSportBlock;

/**
 *
 *定时获取心率以及运动数据
 *
 */
-(void)timerGetHeartRateData:(timerGetHeartRate)timerGetHeartRate;

/**
 *
 *close   心率的命令
 *
 */
-(void)closeHeartRate:(intBlock)closeSportBlock;

/**
 *
 *    获取血压的数据
 *
 */
-(void)getBloodPressure:(bloodPressure)bloodPressure;

/**
 *
 * 检查是否提示了
 *
 */
- (void)checkConnectTimeAlert:(intBlock)TimeAlert;

/**
 *
 * 检查蓝牙开关
 *
 */
- (void)checkCBCentralManagerState:(BlueToothState)BlueToothState;

/**
 *
 * 读取页面管理
 *
 */
- (void)checkPageManager:(uintBlock)pageManager;

/**
 *
 *页面管理 -- 支持那些页面
 *
 */
- (void)supportPageManager:(uintBlock)page;

/**
 *
 *   set  页面管理
 *
 */
- (void)setupPageManager:(uint)pageString;
/**
 *
 *发送天气
 *
 */
-(void)sendWeather:(PZWeatherModel *)weather;
/**
 *
 *发送未来几天天气
 *
 */
-(void)sendWeatherArray:(NSMutableArray *)weatherArr day:(int)day number:(int)number;
/**
 *
 *发送某天天气   今天
 *
 */
-(void)sendOneDayWeather:(PZWeatherModel *)weather;
/**
 *
 *发送某天天气   某天   < 6
 *
 */
-(void)sendOneDayWeatherTwo:(WeatherDay *)weather;

/**
 *
 * 告诉设备，是否准备接收数据
 *
 */
-(void)readyReceive:(int)number;

/**
 *
 * 设置设备， 校正值   APP设置血压测量配置参数
 *
 */
-(void)setupCorrectNumber;


/**
 *
 * 心电图测量完成后返回数据
 *
 */
- (void)getECGData:(ecgData)ecg;


#pragma mark -- 手环端上传离线数据，历史数据

#pragma mark -- 此处方法必须实现用来接收数据，手环端主动上传的数据如历史数据，离线运动数据等，只有实现下列方法才能接收，手环端只上传一次，所以需要在入口类或者全局存在的单例类实现下列方法，对手环上传的数据进行处理保存。

/**
 *  接收离线数据
 *
 *  @param offLineDataBlock block传递参数为OffLineDataModel
 */
- (void)recieveOffLineDataWithBlock:(offLineDataModel)offLineDataBlock;

/**
 *  收到全天概览历史数据，可以接收后保存或上传服务器
 *
 *  @param historyAllDayDataBlock 返回DayOverViewDataModel
 */
- (void)recieveHistoryAllDayDataWithBlock:(allDayModelBlock)historyAllDayDataBlock;


/**
 接收历史每小时计步和消耗
 
 @param historyHourDataBlock 同查询当天计步和消耗
 */
- (void)recieveHistoryHourDataWithBlock:(doubleArrayBlock)historyHourDataBlock;


/**
 接收历史睡眠数据
 
 @param historySleepDataBlock 同查询当天睡眠数据
 */
- (void)recieveHistorySleepDataWithBlock:(sleepModelBlock)historySleepDataBlock;


/**
 接收历史心率
 
 @param historyHeartRateBlock 格式同查询当天心率
 */
- (void)recieveHistoryHeartRateWithBlock:(doubleIntArrayBlock)historyHeartRateBlock;


/**
 接收历史HRV数据
 
 @param historyHRVDataBlock 格式同查询当天历史数据
 */
- (void)recieveHistoryHRVDataWithBlock:(intArrayBlock)historyHRVDataBlock;



#pragma mark   - - 连接蓝牙刷新 的方法
-(void)coreBlueRefresh;

@end
