//
//  NSDate+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MJ)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  返回一个只有年月日的时间
 */
- (NSString *)dateWithYMDHMS;
/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

/**
 *  获取当前日期
 */
- (NSString *)GetCurrentDateStr;

/**
 *  获取两个的时间差
 */
-(NSString *)intervalWithDate:(NSString *)dateOne date2:(NSString *)dateTwo;
/**
 *  获取两个的时间差,返回分钟
 */
-(int)timeDifferenceWithDate:(NSString *)dateOne date2:(NSString *)dateTwo;

@end
