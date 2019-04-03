//
//  SleepModel.h
//  Mistep
//
//  Created by 迈诺科技 on 16/9/19.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepModel : NSObject


/**
 数据时间，格式为秒数
 */
@property (unsafe_unretained, nonatomic) int timeSeconds;


/**
 浅睡时间
 */
@property (unsafe_unretained, nonatomic) int lightSleepTime;


/**
 深睡时间
 */
@property (unsafe_unretained, nonatomic) int deepSleepTime;


/**
 睡眠中清醒时间
 */
@property (unsafe_unretained, nonatomic) int awakeSleepTime;


/**
 睡眠具体情况数组
 */
@property (copy, nonatomic) NSArray *sleepArary;

@end
