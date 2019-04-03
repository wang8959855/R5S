//
//  TimingUploadData.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

typedef void(^intBlock)(int aa);
typedef void(^dictionaryBlock)(NSDictionary *dict);
typedef void(^arrayBlock)(NSArray *array);
typedef void(^sleepDictionaryBlock)(NSDictionary *dict,NSDictionary *dictionary);
//typedef void(^bloodPressureArrayBlock)(NSArray *array);

#import <Foundation/Foundation.h>
#import "TodayStepsViewController.h"

@interface TimingUploadData : NSObject
+ (TimingUploadData *)sharedInstance;
#pragma mark     - - - 删除运动事件

//-(void)deleteSportDataWithDictionary:(NSMutableDictionary *)dict;
//+(void)
/**
 *
 *上传当前天的数据
 *
 **/
-(void)CurrentDayUpData;

//预警上传

- (void)updataHeartRateWarning;

- (void)updataPilaoWarning;
/**
 *
 *      下载   数据 +DayTotalData
 *
 **/
//+(void)downDayTotalData:(dictionaryBlock)dictionaryBlock  date:(int)seconed;
/**
 *
 *      下载   数据 + DayOnlinesport
 *
 **/
//+(void)downDayOnlinesport:(arrayBlock)arrayBlock  date:(int)seconed;
/**
 *
 *      下载   数据 +  sleepDictionaryBlock + 2天
 *
 **/
//+(void)downSleepData:(sleepDictionaryBlock)sleepDictionaryBlock  date:(int)seconed;

/**
 *
 *      下载   数据 +  sleepDictionaryBlock + 1天
 *
 **/
//+(void)downSleepDataADay:(sleepDictionaryBlock)sleepDictionaryBlock  date:(int)seconed;

/**
 *
 *      下载   数据 + BloodPressure
 *
 **/
//+(void)downBloodPressure:(arrayBlock)bloodPressureArrayBlock  date:(int)seconed;
/**
 *
 *      下载   数据 +  每小时计步: type = stepDay
 *
 **/
//+(void)downDayDetailSteps:(arrayBlock)DayDetailStepsBlock  date:(int)seconed;
/**
 *
 *      下载   数据 +  每小时卡路里消耗: type = calorieDay
 *
 **/
//+(void)downDayDetailCosts:(arrayBlock)DayDetailCostsBlock  date:(int)seconed;
/**
 *
 *      下载   数据 +  Hrv: type = hrv
 *
 **/
//+(void)downDayDetailHRV:(arrayBlock)DayDetailHRVBlock  date:(int)seconed;
/**
 *
 *      下载   数据 +  每分钟心率: type = heartRate
 *
 **/
//+(void)downDayHeartRate:(arrayBlock)DayHeartRateBlock  date:(int)seconed;

/**
 *
 *      下载   数据 + 步数月趋势 	type=stepTrend
 *
 **/
//+(void)downYueStepTrend:(dictionaryBlock)dictionaryBlock  date:(int)seconed;

/**
 *
 *      下载   数据 + 睡眠月趋势 	type=sleepTrend
 *
 **/
//+(void)downYueSleepTrend:(dictionaryBlock)dictionaryBlock  date:(int)seconed;

@end
