//
//  SleepTool.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "SleepTool.h"

@implementation SleepTool

//昨天的睡眠数据，转到数组中
+(NSMutableArray *)lastDaySleepDataWithDictionary:(NSDictionary *)dictionary
{
    
    NSMutableArray *sleepArraylastDay = [[NSMutableArray alloc]init];
    if(dictionary == nil)
    {
        for (int inum = 0 ; inum < 12; inum ++)
        {
            [sleepArraylastDay addObject:@0];
        }
    }
    else
    {
        
        NSArray *lastDaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:dictionary[DataValue_SleepData_HCH]];
        
        if (lastDaySleepArray && lastDaySleepArray.count != 0)
        {
            for (int i = (int)lastDaySleepArray.count-12 ; i < lastDaySleepArray.count; i ++)
            {
                [sleepArraylastDay addObject:lastDaySleepArray[i]];
            }
        }
        else
        {
            for (int ik = 0 ; ik < 12; ik ++)
            {
                [sleepArraylastDay addObject:@0];
            }
        }
    }
    //    NSAssert(dictionary!=nil, @"字典不能空");
    return sleepArraylastDay;
}

// Array  昨天的睡眠数据，转到数组中
+(NSMutableArray *)lastDaySleepDataWithArray:(NSArray *)Array
{
    NSMutableArray *sleepArraylastDay = [[NSMutableArray alloc]init];
    NSArray *lastDaySleepArray = Array;
    
    if (lastDaySleepArray && lastDaySleepArray.count != 0)
    {
        for (int i = (int)lastDaySleepArray.count-12 ; i < lastDaySleepArray.count; i ++)
        {
            [sleepArraylastDay addObject:lastDaySleepArray[i]];
        }
    }
    else
    {
        for (int i = 0 ; i < 12; i ++)
        {
            [sleepArraylastDay addObject:@0];
        }
    }
    return sleepArraylastDay;
}

//今天的睡眠数据，转到数组中
+(NSMutableArray *)todayDaySleepDataWithDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *sleepArraytodayDay = [[NSMutableArray alloc]init];
    
    if (dictionary == nil)
    {
        for (int inum = 0 ; inum < 60; inum ++)
        {
            [sleepArraytodayDay addObject:@0];
        }
    }
    else
    {
        
        
        NSArray *todaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:dictionary[DataValue_SleepData_HCH]];
        if (todaySleepArray && todaySleepArray.count  > 1)
        {
            NSString * oneStr = [NSString stringWithFormat:@"%d",[todaySleepArray[0] intValue]];
            if(!([oneStr isEqualToString:@""]))
            {
                for (int i = 0 ; i < 60 ; i ++)
                {
                    [sleepArraytodayDay addObject:todaySleepArray[i]];
                }
            }
            else
            {
                for (int il = 0 ; il < 60; il ++)
                {
                    [sleepArraytodayDay addObject:@0];
                }
            }
        }
        else
        {
            for (int ik = 0 ; ik < 60; ik ++)
            {
                [sleepArraytodayDay addObject:@0];
            }
        }
    }
    //    NSAssert(dictionary!=nil, @"字典不能空");
    return sleepArraytodayDay;
}
// Array  今天的睡眠数据，转到数组中
+(NSMutableArray *)todayDaySleepDataWithArray:(NSArray *)Array
{
    NSMutableArray *sleepArraytodayDay = [[NSMutableArray alloc]init];
    NSArray *todaySleepArray = Array;//[NSKeyedUnarchiver unarchiveObjectWithData:dictionary[DataValue_SleepData_HCH]];
    if (todaySleepArray && todaySleepArray.count > 1)
    {
        NSString * oneStr = [NSString stringWithFormat:@"%d",[todaySleepArray[0] intValue]];
        if(!([oneStr isEqualToString:@""]))
        {
            for (int i = 0 ; i < 60 ; i ++)
            {
                [sleepArraytodayDay addObject:todaySleepArray[i]];
            }
        }
        else
        {
            for (int i = 0 ; i < 60; i ++)
            {
                [sleepArraytodayDay addObject:@0];
            }
        }
    }
    else
    {
        for (int i = 0 ; i < 60; i ++)
        {
            [sleepArraytodayDay addObject:@0];
        }
    }
    
    return sleepArraytodayDay;
}
//睡觉数组。经过判断转字典
+(NSDictionary *)sleepDataArrayTodictionary:(NSArray *)sleepArray
{
    int nightBeginTime = 0;
    int nightEndTime = 0;
    BOOL isBegin = NO;
    int deepSleep = 0;
    int lightSleep = 0;
    int awake = 0;
    //    int nightEndTime = 0;
    for (int i = 0; i < sleepArray.count; i++)
    {
        int sleepState = [sleepArray[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            
            for (int i = nightBeginTime ; i <= nightEndTime; i ++)
            {
                int state = [sleepArray[i] intValue];
                
                if (state == 2 )
                {   deepSleep ++;
                }else if (state == 1)
                {  lightSleep ++;                 }
                else if (state == 0 || state == 3)
                {
                    awake ++;
                }
            }
        }
    }
    NSDictionary *dict = @{@"deepSleep":[NSNumber numberWithInt:deepSleep],@"lightSleep":[NSNumber numberWithInt:lightSleep],@"awake":[NSNumber numberWithInt:awake]};
    
    return dict;
}

//睡觉数组。计算睡眠开始的时间点
+(NSMutableDictionary *)sleepTimeSeek
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *sleepArray = [NSMutableArray array];
    NSDictionary * detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay]];
    [sleepArray removeAllObjects];
    if (detailDic != nil)
    {
        NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay] - KONEDAYSECONDS];
        
        NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
        [sleepArray addObjectsFromArray:lastDaySleepArray];
        NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:detailDic];
        [sleepArray addObjectsFromArray:todaySleepArray];
    }
    if (!sleepArray) {
        [dict setObject:@"22" forKey:@"time"];
        [dict setObject:@"0" forKey:@"min"];
        
        return dict;
    }
    BOOL isBegin = NO;
    int nightBeginTime = 0;
    int nightEndTime = 0;
    for (int i = 0; i < sleepArray.count; i ++)
    {
        int sleepState = [sleepArray[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    
    int index = nightBeginTime;
    int time = 0;
    if (index < 12)
    {
        time = 22+index/6;
    }
    else
    {
        time = (index - 12)/6;
    }
    int min = index%6*10;
    
    [dict setObject:[NSString stringWithFormat:@"%d",time] forKey:@"time"];
    [dict setObject:[NSString stringWithFormat:@"%d",min] forKey:@"min"];
    return dict;
}
//睡觉数组。计算睡眠的时长
+(int)sleepLengthSeek
{
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *sleepArray = [NSMutableArray array];
    NSDictionary * detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay]];
    [sleepArray removeAllObjects];
    //    if (detailDic != nil)
    //    {
    NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay] - KONEDAYSECONDS];
    
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:detailDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    //    }
    //    else
    //    {
    //        NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.todayTimeSeconds - KONEDAYSECONDS];
    //
    //        NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    //        [sleepArray addObjectsFromArray:lastDaySleepArray];
    //
    //
    //    }
    if (sleepArray.count<=0) {
        return 0;
        //        [dict setObject:@"22" forKey:@"time"];
        //        [dict setObject:@"0" forKey:@"min"];//
        //        return dict;
    }
    int lightSleep = 0;
    int awakeSleep = 0;
    int deepSleep = 0;
    BOOL isBegin = NO;
    int nightBeginTime = 0;
    int nightEndTime = 0;
    for (int i = 0; i < sleepArray.count; i ++)
    {
        int sleepState = [sleepArray[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            for (int i = nightBeginTime ; i <= nightEndTime; i ++)
            {
                int state = [sleepArray[i] intValue];
                if (state == 2 )    {  deepSleep ++; }
                else if (state == 1){   lightSleep ++; }
                else if (state == 0 || state == 3) {  awakeSleep ++;}
            }
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
    int totalCount = (awakeSleep + lightSleep + deepSleep) * 10;
    //    int index = nightBeginTime;
    //    int time = 0;
    //    if (index < 12)
    //    {
    //        time = 22+index/6;
    //    }
    //    else
    //    {
    //        time = (index - 12)/6;
    //    }
    //    int min = index%6*10;
    //
    //    [dict setObject:[NSString stringWithFormat:@"%d",time] forKey:@"time"];
    //    [dict setObject:[NSString stringWithFormat:@"%d",min] forKey:@"min"];
    return totalCount;
    
    
}

@end
