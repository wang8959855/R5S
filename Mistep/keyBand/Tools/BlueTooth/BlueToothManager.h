//
//  BlueToothManager.h
//  TestBlueToothVector
//
//  Created by zhangtan on 14-9-24.
//  Copyright (c) 2014年 zhangtan. All rights reserved.


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "PZWeatherModel.h"
#import "WeatherDay.h"
#import <UIKit/UIKit.h>

#define kState [[[NSUserDefaults standardUserDefaults] objectForKey:kUnitStateKye] intValue]

typedef enum {
    UnitStateNone = 1,
    UnitStateBritishSystem,
    UnitStateMetric,
}UnitState;

@protocol BlutToothManagerDelegate <NSObject>

@optional
//蓝牙是否连接，YES表示连接,NO表示断开
- (void)blueToothManagerIsConnected:(BOOL)isConnected connectPeripheral:(CBPeripheral *)peripheral;
- (void)blueToothManagerReceiveNotifyData:(NSData *)Dat;
- (void)blueToothManagerReceiveHeartRateNotify:(NSData *)Dat;
- (void)callbackConnectTimeAlert:(int)TimeAlert;
- (void)callbackCBCentralManagerState:(CBCentralManagerState)state;


@end

@interface BlueToothManager : NSObject

//1为未提示，2为已提示
@property (nonatomic, assign) int isSeek;//是否找到外设  1 没有找到  2 找到了
@property (nonatomic, weak) id<BlutToothManagerDelegate>delegate;
@property (nonatomic, retain) NSString *connectUUID;
@property (nonatomic, assign) BOOL isConnected;  //连接与否
@property (nonatomic, retain) NSString *deviceName;


@property (nonatomic, retain) NSMutableArray *dataArray;
@property (strong, nonatomic) NSData *sendingData;
@property (nonatomic, assign) int resendCount;
@property (nonatomic, assign) BOOL canPaired;
@property (strong, nonatomic) NSString *romURL;

#pragma mark   --    蓝牙模块(发送蓝牙指令)
/**
 *
 *开始扫描
 *
 */
- (void)startScan;
/**
 *
 *停止扫描设备
 *
 */
- (void)stopScanDevice;
/**
 *
 *获得对象
 *未使用
 */
+ (BlueToothManager *)getInstance;
/**
 *
 *清理对象
 *未使用
 */
+ (void)clearInstance;
/**
 *  根据UUID连接设备
 *
 *  @param UUID 要连接设备的UUID，NSString格式，此方法不提供连接是否成功的判断，请用下方监测蓝牙连接状态方法来监测连接成功或设备断开
 *
 */
- (void)ConnectWithUUID:(NSString *)connectUUID;
/**
 *
 * 连接外设
 *
 */
- (void)ConnectPeripheral:(CBPeripheral *)peripheral;
/**
 *  断开蓝牙方法
 *
 *  @param UUID 当前连接设备的UUID
 *
 */
- (void)disConnectPeripheralWithUuid:(NSString *)uuid;



/**
 *  获取设备是否已连接
 *
 *  @param device 设备对象
 *
 *  @return YES 已连接  NO 未连接
 */
-(BOOL)readDeviceIsConnect:(CBPeripheral *)device;

#pragma mark   --   设置模块(发送命令指令，例如同步时间)
/**
 *
 *app与手环的时间同步
 *
 */
- (void)synsCurTime;
/**
 *
 *同步语言。支持中，英，泰。不是这三种语言。就是英文
 *
 */
-(void)setLanguage;

/**
 *
 *发送手环的显示日期的格式 日月
 *
 */
- (void)sendBraMMDDformat;
/**
 *
 *读取信息提醒的支持
 *
 */
- (void)checkInformation;
/**
 *
 *app设置手环的公制/英制    NO:公制     YES:英制
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
 *
 *检查手环电量
 *
 */
- (void)checkPower;
/**
 *
 * 拍照功能  - 开关
 * YES - 打开拍照  NO - 关闭拍照
 */
- (void)setPhotoWithState:(BOOL)state;
/**
 *
 *找手环功能
 *
 */
- (void)findBindState:(BOOL)state;
/**
 *
 *清除手环数据
 *
 */
- (void)resetDevice;

/**
 *
 *检查手环版本
 *
 */
- (void)checkVersion;
/**
 *
 *开启实时心率
 *
 */
- (void)heartRateNotifyEnable:(BOOL)isEnable;
/**
 *
 *设置自定义闹铃
 *
 */
- (void)setCustomAlarmWithStatus:(int)status alarmIndex:(int)alarmIndex alarmType:(int)alarmType alarmCount:(int)alarmCount alarmtimeArray:(NSArray *)alarmtimeArray repeat:(int)repeat noticeString:(NSString *)noticeString;
/**
 *
 *查询自定义闹铃
 *
 */
- (void)queryCustomAlarm;

/**
 *
 *删除自定义闹铃
 *
 */
- (void)closeCustomAlarmWith:(int)index;
/**
 *
 *心率监控间隔 - 心率自动监控开关 -查询
 *
 */
- (void)queryHeartAndtired;

/**
 *
 * 心率自动监控开关
 * NO：关闭    YES：开启
 */
- (void) setHeartHZState:(int)state;

/**
 *
 * 心率监控间隔 -- 设置 -- 常常设置30分钟或60分钟
 *
 */
- (void)setHeartDuration:(int)state;

/**
 *
 * 心率预警 - 读取
 *
 */
- (void)queryHeartAlarm;


/**
 *
 * 心率预警 - 设置
 *
 */
- (void)setHeartAlarmWithMin:(int)minHeart andMax:(int)maxHeart andState:(int)state;
/**
 *
 *固件升级
 *
 */
- (void)startUpdateHardWithURL:(NSString *)romURL;

/**
 *
 *设置计步参数
 *
 */
- (void)setStepPramWithHeight:(int)height andWeight:(int)weight andSexIndex:(int)sexIndex andAge:(int)age;



/**
 *
 *查询设备是否支持某功能
 *
 */
-(void)checkAction;

/**
 *
 *APP查询设备能支持的参数
 *
 */
-(void)checkParameter;

#pragma mark   --   功能模块(发送数据指令）
/**
 *
 *读取对应的提醒状态
 *
 */
- (void)querySystemAlarmWithIndex:(int)index;

/**
 *
 *设置对应的提醒状态
 *
 */
- (void)setSystemAlarmWithIndex:(int)index status:(int)status;

/**
 *
 *电话提醒延时功能
 *
 */
- (void)queryPhoneDelay;


/**
 *
 *电话提醒延时功能 - 设置
 *
 */
- (void)setPhoneDelay:(int)seconds;

/**
 *
 *运动目标 。睡眠目标  睡眠时间 - 主动发送
 *
 */
- (void)activeCompletionDegree;

#pragma mark   --   获取手环数据模块(例如步数)
/**
 *
 * 获取当天全天数据概览
 *
 */
- (void)getCurDayTotalData;

/**
 *
 *查询每小时步数及卡路里消耗
 *
 */
- (void)getCurDayTotalDataWithType:(NSNumber *)type;

/**
 *
 *请求最新的两个心率包
 *
 */
-(void)getNewestCurDayTotalHeartData;

/**
 *
 *查看当天心率数据
 *
 */
- (void)getCurDayTotalHeartData;

/**
 *
 *查询HRV值
 *
 */
- (void)getPilaoData;


/**
 *
 *久坐提醒功能 - 查询
 *
 */
- (void)queryJiuzuoAlarm;
/**
 *
 *久坐提醒功能 - 设置
 *
 */
- (void)setJiuzuoAlarmWithTag:(int)tag isOpen:(BOOL)isOpen BeginHour:(int)beginHour Minite:(int)beginMinite EndHour:(int)endHour Minite:(int)endMinite Duration:(int)duration;
/**
 *
 *久坐提醒功能 - 删除
 *
 */
- (void)deleteJiuzuoAlarmWithTag:(int)tag;

#pragma mark -- ada 写



/**
 *
 *打开心率的命令
 *
 */
-(void)openHeartRate;

/**
 *
 *定时获取数据  用于在线运动
 *
 */
-(void)timerGetHeartRateData;

/**
 *
 *关闭心率的命令
 *
 */
-(void)closeHeartRate;
/**
 *
 *回复血压
 *
 */
-(void)answerBloodPressure;

/**
 *
 *  告诉设备，是否准备接收数据
 *
 */
-(void)readyReceive:(int)number;

/**
 *
 *  回答设备，是否准备接收数据
 *
 */
-(void)answerReadyReceive:(int)number;

/**
 *
 *  回答设备， 校正值
 *
 */
-(void)answerCorrectNumber;

/**
 *
 * 回答设备手环设置APP参数
 *
 */
-(void)answerBraceletSetParam:(int)code;

/**
 *
 *  设置设备， 校正值   APP设置血压测量配置参数
 *
 */
-(void)setupCorrectNumber;

/**
 *
 *  set  页面管理
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
-(void)sendWeatherArray:(NSMutableArray *)weatherArr  day:(int)day number:(int)number;
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
 使用unicode编码，最大44个字节长度，相当于可有22个ascii或中文；如果提醒类型是1~5，则不用传递提醒语
 
 *   把内容为16进制的字符串转换为数组
 **/
+(NSData *)utf8ToUnicode:(NSString *)string;



/**
 *
 *
 *
 */
- (void)getActualData;


/**
 *
 *读取页面管理
 *
 */
- (void)checkPageManager;

/**
 *
 *页面管理 -- 支持那些页面
 *
 */
- (void)supportPageManager;
/**
 *
 *
 *
 */
- (void)openAntiLoss;
/**
 *
 *
 *
 */
- (void)closeAntiLoss;

#pragma mark -- 回复数据

/**
 *
 *回复数据
 *
 */
- (void)revDataAckWith:(int)dataFunctionNum;
/**
 *
 *回复数据
 *
 */
- (void)revDataAckWith:(int) dataFunctionNum andDat:(NSData *)data;
/**
 *
 *回复数据  -- 仅测试使用
 *
 */
//- (void)returnDataWithFlag:(int)flag andDat:(NSData *)data;


/**
 *
 * 更新  固件 数据
 *
 */
- (void)updateHardWaerWithPackIndex:(int)index;
/**
 *
 * 更新  固件 完成
 *
 */
- (void)updatehardwaerComplete;







/**
 *
 * 回复手环
 *
 */
- (void)phoneAlarmNotify;





/**
 *
 *运动目标 。睡眠目标  睡眠时间
 *
 */
- (void)returnCompletionDegree;


/**
 *
 *回复手环
 *
 */
- (void)answerTakePhoto;
/**
 *
 *回复手环
 *
 */
- (void)responseExceptionData;





/**
 *
 *
 *开启定时器，定时请求天气
 */
-(void)weatherRefresh;
#pragma mark   - - 连接蓝牙刷新 的方法
-(void)coreBlueRefresh;




@end
