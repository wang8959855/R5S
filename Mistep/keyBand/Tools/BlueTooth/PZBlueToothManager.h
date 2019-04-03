//
//  PZBlueToothManager.h
//  Mistep
//
//  Created by 迈诺科技 on 16/9/8.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SportModel.h"
#import "SportModelMap.h"

typedef void(^connectStateBlock)(int isconnect);
typedef void(^dictionnaryBlock)(NSDictionary *dic);

@protocol PZBlueToothManagerDelegate <NSObject>
/**
 *蓝牙连接成功的回调数据
 */
- (void)BlueToothIsConnected:(BOOL)isconnected;
@end


@interface PZBlueToothManager : NSObject
@property (weak, nonatomic) id<PZBlueToothManagerDelegate> delegate;

@property (copy, nonatomic)dictionnaryBlock offLineDataBlock;

@property (copy, nonatomic)connectStateBlock connectStateBlock;

@property (copy, nonatomic) intBlock heartRateBlock;

@property (strong, nonatomic) NSMutableArray *actualHeartArray;

+ (PZBlueToothManager *)sharedInstance;

- (void)setBlocks;

- (void)checkBandPowerWithPowerBlock:(intBlock)PowerBlock;

- (void)chekCurDayAllDataWithBlock:(void(^)(NSDictionary *dic))dayTotalDataBlock;

- (void)recieveOffLineDataWithBlock:(void(^)(SportModelMap *dic))offLineDataBlock;

- (void)checkHourStepsAndCostsWithBlock:(void(^)(NSArray *steps,NSArray *costs))dayHourDataBlock;

- (void)checkTodaySleepStateWithBlock:(void(^)(int timeSeconds,NSArray *sleepArray))sleepStateArrayBlock;

- (void)checkTodayHeartRateWithBlock:(void(^)(int timeSeconds,int index,NSArray *heartArray))heartRateArrayBlock;

- (void)checkHRVDataWithHRVBlock:(void(^)(int number,NSArray *array))HRVDataBlock;

- (void)checkVerSionWithBlock:(void(^)(int firstHardVersion,int secondHardVersion,int softVersion,int blueToothVersion ))versionBlock;

- (void)connectedStateChangedWithBlock:(intBlock)stateChanged;

- (void)setBindDatepz;

- (void)sendUserInfoToBind;

- (void)checkHeartRateAlarmWithHeartRateAlarmBlock:(heartRateAlarmBlock)heartRateAlarmBlock;

- (void)changeHeartStateWithState:(BOOL)isON Block:(intBlock)block;


            //      获取血压的数据
- (void)checkBloodPressure:(void(^)(BloodPressureModel  *bloodPre))bloodPressure;
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
@end