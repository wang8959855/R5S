//
//  SleepTool.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepTool : NSObject
//昨天的睡眠数据，转到数组中
+(NSMutableArray *)lastDaySleepDataWithDictionary:(NSDictionary *)dictionary;
// Array  昨天的睡眠数据，转到数组中
+(NSMutableArray *)lastDaySleepDataWithArray:(NSArray *)Array;
 //今天的睡眠数据，转到数组中
+(NSMutableArray *)todayDaySleepDataWithDictionary:(NSDictionary *)dictionary;
// Array  今天的睡眠数据，转到数组中
+(NSMutableArray *)todayDaySleepDataWithArray:(NSArray *)Array;
//睡觉数组。经过判断转字典
+(NSDictionary *)sleepDataArrayTodictionary:(NSArray *)sleepArray;

//睡觉数组。计算睡眠开始的时间点
+(NSMutableDictionary *)sleepTimeSeek;
//睡觉数组。计算睡眠的时长
+(int)sleepLengthSeek;
@end
