//
//  SQLdataManger.h
//  ShanHeShui
//
//  Created by Showsoft_002 on 13-12-9.
//  Copyright (c) 2013年 Showsoft_002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define UserInfoTable_SQL  @"UserInfoTable"
#define ShowInfoTable_SQL  @"ShowInfoTable"
#define StoreContentTypeKey  @"StoreContentTypeKey"
#define SQL_ContentKey     @"content"
#define HistoryHeartRateTable_SQL  @"HistoryHeartRateTable_SQL"

typedef enum {
    //SQLTalbeName_Start = 0 ,
    //Language_English_Table,//语言表
    //SleepData_Table,//睡眠数据
    //SleepHeartRate_Table,//睡眠心率数据
    //ActualSpeedData_Table,//实时运动强度数据
    //SleepTimeData_Table,//睡眠数据起始时间开始时间表
    //ACtualTimeData_Table,//实时数据起始时间开始时间表
    
    PersonInfo_Table = 1,//个人信息
    DayTotalData_Table,//天数据总览
    BloodPressure_Table,//血压数据表
    Peripheral_Table,//外设的表  。。那些外设连接进来了。就保存数据库
    HistoryHeartRateData_Table,//历史心率数据
    Weather_Table//天气表  存储天气的内容  ..自定义建表
}SQLTalbeNameEnum;

@interface SQLdataManger : NSObject

//创建每分钟获取步数
+ (SQLdataManger *)getInstanceWithStepMinut;

+ (SQLdataManger*)getInstance;
+ (void)clearInstance;
- (void)createTable;
- (void)deleteTabel;
- (void)updateSqlite;
//在指定表中插入批量数据
- (BOOL)insertMoreDataToTable:(SQLTalbeNameEnum)tableName withData:(NSArray *)transArray;
//在指定表中插入一条数据
- (BOOL)insertSignalDataToTable:(SQLTalbeNameEnum)tableName withData:(NSDictionary *)transDic;
//删除指定表的内容
- (void)deleteTableInfoWithTableName:(SQLTalbeNameEnum)talbeName;

//- (NSString *)queryEnglishLanguageWithChinese:(NSString *)chinese;

//获取当前用户信息
- (NSDictionary *)getCurPersonInf;
//根据日期获取天总数据
- (NSDictionary *)getTotalDataWith:(int)date;
/*
 *根据系统的uuid的唯一标记符。取得macAddress
 *
 *
 */
- (NSDictionary *)getPeripheralWith:(NSString *)uuid;
/**
 
 上传数据查询 , ,获取天总数据
 日期 ，上传标记
 */
- (NSDictionary *)getTotalDataWithToUp:(int)date  isUp:(NSString *)isUp;
- (NSArray *)queryDayTotalDataWith:(NSInteger)year weekIndex:(NSInteger)week ;
//通过日期查询血压数据
- (NSArray *)queryBloodPressureWithDay:(NSString *) time;
/**
 *
 *上传数据查询
 *日期 ，上传标记
 *通过日期查询血压数据
 */
- (NSArray *)queryBloodPressureWithDayToUp:(NSString *)time isUp:(NSString *)isUp;
// 查询血压数据 总数／／
- (NSInteger)queryBloodPressureALL;
// 查询外设数据 总数／／
- (NSInteger)queryPeripheralALL;
//在线运动 -- 总数据
- (NSInteger)queryHeartRateDataWithAll;
//在线运动  求最大的id
- (NSMutableArray *)queryMaxSportID;
// 查询开始时间。是否有这个运动了
- (NSArray *)queryHeartRateDataWithFromtime:(NSString *)fromTime;
/**
 
 查询表内所有数据
 */
- (NSArray*)queryALLDataWithTable:(SQLTalbeNameEnum)talbeName;
#pragma mark   --- 建表
/**创建表单*/
- (void)createTableTwo;
/**建表*/
- (void)createTableName:(NSString *)name primaryKey:(NSString *)key type:(NSString *)type otherColumn:(NSDictionary *)dict;
/**插入数据*/
- (void)insertDataWithColumns:(NSDictionary*)dic toTableName:(NSString*)tableName;
/**插入于覆盖记录*/
- (void)replaceDataWithColumns:(NSDictionary *)dic toTableName:(NSString *)tableName;
//在线运动
- (NSArray *)queryHeartRateDataWithDate:(NSString *)Date;

- (void)deleteDataWithTableName:(NSString *)tableName;
//在线运动 -- 总数据
//- (BOOL)deleteHeartRateDataWithSportID:(NSString *)sportIDNumber;
/**删除数据*/
- (void)deleteDataWithColumns:(NSDictionary *)dic fromTableName:(NSString *)tableName;
/**
 
 上传数据查询
 日期 ，上传标记
 */
- (NSArray *)queryHeartRateDataWithDateToUp:(NSString *)Date isUp:(NSString *)isUp;
/**
 插入一个运动数组
 */
-(void)insertMostSport:(NSArray *)array;
/**
 插入一个血压数组
 */
-(void)insertMostBlood:(NSArray *)array;

- (NSArray *)getAllTotalData;
//今天天气
- (NSDictionary *)queryWeather;

/** 插入一条心率数据 */
- (void)addHistoryHeartRate:(NSArray *)array date:(NSString *)date;

/** 查询历史心率 */
- (NSArray *)getHistoryHeartRateWithDate:(NSString *)date;

/** 插入一条每分钟步数数据 */
- (void)addMinuteStepWith:(NSString *)step time:(NSString *)time;

/** 查询每分钟步数数据 */
- (NSArray *)getMinuteStepWithTime:(NSString *)time;

/**
 
 上传 成功   更新数据
 日期 ，上传标记
 */
//- (void)updataTotalDataTableWithDic:(NSDictionary *)dic;

//根据开始时间和结束时间获取心率数据
//- (NSArray *)querySleepHeartWithStartTime:(int)startTime andEndTime :(int)endTime;
//根据开始时间和结束时间获取实时数据心率数据
//- (NSArray *)queryHeartRateWithStartTime:(int)startTime andEndTime :(int)endTime;
//根据开始时间和结束时间获取实时运动强度数据
//- (NSArray *)querySpeedWithStartTime:(int)startTime andEndTime :(int)endTime;
//根据开始时间获取睡眠数据
//- (NSArray *)querySleepDataWithStartTime:(int)date;

//- (NSArray *)querySleepDataWithDayTime:(int)date;

//- (NSArray *)querySleepTimeList;

//- (NSArray *)queryActualTimeListWithType:(int)type;

//- (NSArray *)queryAllActualSpeedDataWithDay:(int) time;

//- (NSArray *)queryActualTimeListWithDay:(int) time;

//- (NSArray *)querySleepTimeListWithDay:(int)dayTime;

//- (NSArray *)queryAllSleepHeart;



@end
