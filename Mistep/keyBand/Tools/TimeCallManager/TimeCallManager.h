//
//  TimeCallManager.h
//  HuiChengHe
//
//  Created by zhangtan on 14-12-11.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeCallManager : NSObject

+ (TimeCallManager *)getInstance;
+ (void)clearInstance;

- (NSString *)changeDateTommddeWithSeconds:(int)seconds;

- (NSString *)changeCurDateToItailYYYYMMDDString;
- (NSString *)changeDateToItailYYYYMMDDStringWithAssignDate:(NSDate *)assignDate;
- (NSDate *)changeItailYYYYMMDDStringToDateWithString:(NSString *)itailString;

- (NSString *)getForwordYYYYMMDDDateStringWithAssignString:(NSString *)assignString;
- (NSString *)getBackYYYYMMDDDateStringWithAssignString:(NSString *)assignString;

- (NSTimeInterval)getYYYYMMDDSecondsSince1970With:(NSTimeInterval)seconds;
- (NSTimeInterval)getHHmmSecondsSinceCurDayWith:(NSTimeInterval)seconds;

- (NSTimeInterval)getYYYYMMDDSecondsWith:(NSData *)data;

- (NSTimeInterval)getYYYYMMDDHHmmSecondsWith:(NSString *)datastr;
- (NSString *)getMinutueWithSecond:(NSTimeInterval)seconds;
- (NSString *)getHourWithSecond:(NSTimeInterval)seconds;

//获取一个时间和另一个时间点间隔了几个5分钟
- (int)getIntervalFiveMinWith:(int)oritime andEndTime:(int)endTime;
//获取一个时间和另一个时间点间隔了几个1分钟
- (int)getIntervalOneMinWith:(int)oritime andEndTime:(int)endTime;
    //两个时间间隔一天 YES 否则为NO
- (BOOL)adayWith:(int)oritime andEndTime:(int)endTime;
//获取一个时间和另一个时间点间隔了几个5秒钟
- (int)getIntervalFiveSecondWith:(int)oritime andEndTime:(int)endTime;

//获取一个时间和另一个时间点间隔了多少秒
- (int)getIntervalSecondWith:(int)oritime andEndTime:(int)endTime;

//获取时间是当年的第几周
- (int)getWeekIndexInYearWith:(int)senconds;

//根据格式和时间字符串获取秒数
- (NSTimeInterval)getSecondsWithTimeString:(NSString *)timeStr andFormat:(NSString *) format;
//根据秒数和格式获取时间字符串
- (NSString *)timeAdditionWithTimeString:(NSString *)timeStr andSeconed:(NSInteger)seconed;

//根据秒数和格式获取时间字符串 ++ 这个可以对的时间
- (NSString *)getTimeStringWithSeconds:(int)seconds andFormat:(NSString *)format;

- (NSString *)getHourMinuteWithSecond:(NSTimeInterval)seconds;


//获取当前天时间的秒数
- (NSTimeInterval)getSecondsOfCurDay;

- (NSString *)getYearWithSecond:(NSTimeInterval)seconds;
//获取当前 的秒数
- (NSTimeInterval)getNowSecond;
//获取当前分钟的秒数
- (NSTimeInterval)getNowMinute;
@end
