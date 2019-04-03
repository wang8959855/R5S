//
//  TimeCallManager.m
//  HuiChengHe
//
//  Created by zhangtan on 14-12-11.
//  Copyright (c) 2014年 zhangtan. All rights reserved.

//yyyy-MM-dd HH:mm:ss

#import "TimeCallManager.h"

static TimeCallManager * instance=nil;

@implementation TimeCallManager

+ (TimeCallManager *)getInstance{
    if( instance == nil ){
        //        static dispatch_once_t onceToken;
        @synchronized(self) {
            instance =  [[TimeCallManager alloc] init];
        }
    }
    
    return instance;
}

+ (void)clearInstance{
    instance = nil ;
}

- (NSString *)changeCurDateToItailYYYYMMDDString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    return [formates stringFromDate:[NSDate date]];
}

- (NSString *)changeDateToItailYYYYMMDDStringWithAssignDate:(NSDate *)assignDate{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    return [formates stringFromDate:assignDate];
}

- (NSDate *)changeItailYYYYMMDDStringToDateWithString:(NSString *)itailString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    return [formates dateFromString:itailString];
}

- (NSString *)getForwordYYYYMMDDDateStringWithAssignString:(NSString *)assignString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSDate *assignDate = [formates dateFromString:assignString];
    
    NSTimeInterval aTimeInterval = [assignDate timeIntervalSinceReferenceDate];
    aTimeInterval -= 24*60*60;
    NSDate *cureDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return [formates stringFromDate:cureDate];
}

- (NSString *)getBackYYYYMMDDDateStringWithAssignString:(NSString *)assignString{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSDate *assignDate = [formates dateFromString:assignString];
    
    NSTimeInterval aTimeInterval = [assignDate timeIntervalSinceReferenceDate];
    aTimeInterval += 24*60*60;
    NSDate *cureDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
    return [formates stringFromDate:cureDate];
}

- (NSTimeInterval)getYYYYMMDDSecondsSince1970With:(NSTimeInterval)seconds {
    NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [formates stringFromDate:cDate];
    
    NSDate *resultDate = [formates dateFromString:dateStr];
    return [resultDate timeIntervalSince1970];
}

- (NSTimeInterval)getHHmmSecondsSinceCurDayWith:(NSTimeInterval)seconds {
    NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [formates stringFromDate:cDate];
    
    NSDate *resultDate = [formates dateFromString:dateStr];
    
    return [resultDate timeIntervalSinceDate:cDate];
}

- (NSTimeInterval)getYYYYMMDDSecondsWith:(NSData *)data {
    if([data length] != 3)  return 0;
    
    Byte *transdata = (Byte *)[data bytes];
    NSString *timeStr = [NSString stringWithFormat:@"20%02d/%02d/%02d", transdata[2],transdata[1],transdata[0]];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSDate *resultDate = [formates dateFromString:timeStr];
    return [resultDate timeIntervalSince1970];
}

- (NSTimeInterval)getYYYYMMDDHHmmSecondsWith:(NSString *)datastr {
    
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy-MM-dd HH:mm"]; //yyyy-MM-dd HH:mm:ss
    NSDate *resultDate = [formates dateFromString:datastr];
    return [resultDate timeIntervalSince1970];
}

- (NSString *)getMinutueWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

- (NSString *)getYearWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

- (NSString *)getHourWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"HH"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

- (NSString *)getHourMinuteWithSecond:(NSTimeInterval)seconds {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}

//获取一个时间和另一个时间点间隔了几个5分钟
- (int)getIntervalFiveMinWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    
    if (i%300 >= 200) {
        index = i/300 +1;
    }else {
        index = i/300 + 1;
    }
    
    return index;
}
//获取一个时间和另一个时间点间隔了几个1分钟
- (int)getIntervalOneMinWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    
    if (i%60 >= 50) {
        index = i/60 +1;
    }else {
        index = i/60;
    }
    
    return index;
}

//两个时间间隔一天 YES 否则为NO
- (BOOL)adayWith:(int)oritime andEndTime:(int)endTime
{
    BOOL ret = NO;
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    index = i /1440;
    if (index > 0)
    {
        ret = YES;
    }
    return ret;
}

//获取一个时间和另一个时间点间隔了几个5秒钟
- (int)getIntervalFiveSecondWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    int index = 0;
    
    index = i/5;
    return index;
}

- (int)getIntervalSecondWith:(int)oritime andEndTime:(int)endTime {
    NSDate *origDate  = [NSDate dateWithTimeIntervalSince1970:oritime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    int i = [endDate timeIntervalSinceDate:origDate];
    return i;
}

//根据秒数获取是当年的第几周
- (int)getWeekIndexInYearWith:(int)senconds {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:senconds];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSWeekOfYearCalendarUnit) fromDate:date];
    int weekIndex = (int)[comps weekOfYear];
    
    return weekIndex;
}

//根据yyyy/MM/dd字符串获得秒数
- (NSTimeInterval)getSecondsWithTimeString:(NSString *)timeStr andFormat:(NSString *) format
{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:format];
    NSDate *resultDate = [formates dateFromString:timeStr];
    return [resultDate timeIntervalSince1970];
}
//根据秒数和格式获取时间字符串
- (NSString *)timeAdditionWithTimeString:(NSString *)timeStr andSeconed:(NSInteger)seconed
{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    NSDate *resultDate = [formates dateFromString:timeStr];
    NSTimeInterval  time= [resultDate timeIntervalSinceNow];
    time +=seconed;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:time];
    return [formates stringFromDate:date];
}
//根据秒数和格式获取时间字符串
- (NSString *)getTimeStringWithSeconds:(int)seconds andFormat:(NSString *)format {
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [formates stringFromDate:date];
}


//获得当前天的秒数
- (NSTimeInterval)getSecondsOfCurDay {
    NSDate *eDate = [NSDate date];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy/MM/dd"];
    NSString *string = [formates stringFromDate:eDate];
    return  [self getSecondsWithTimeString:string andFormat:@"yyyy/MM/dd"];
}

- (NSString *)changeDateTommddeWithSeconds:(int)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM.dd  E"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@",dateString];
}
//获取当前 的秒数
- (NSTimeInterval)getNowSecond
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSDate *resultDate = [dateFormatter dateFromString:dateString];
    NSTimeInterval timeOne = [resultDate timeIntervalSince1970];
    return timeOne;
}

//获取当前分钟的秒数
- (NSTimeInterval)getNowMinute
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSDate *resultDate = [dateFormatter dateFromString:dateString];
    NSTimeInterval timeOne = [resultDate timeIntervalSince1970];
    return timeOne;
}

@end