//
//  CustomAlarmModel.h
//  Mistep
//
//  Created by 迈诺科技 on 16/9/21.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AlarmType_Movement = 1,  //   运动
    AlarmType_Date,          //   约会
    AlarmType_Drink,         //   喝水
    AlarmType_TakeMedicion,  //   吃药
    AlarmType_Sleep,         //   睡觉
    AlarmType_Custom,        //   自定义
}AlarmType_Enum;

@interface CustomAlarmModel : NSObject

@property(unsafe_unretained, nonatomic) int index;

@property(unsafe_unretained, nonatomic) AlarmType_Enum type;

@property(copy, nonatomic) NSArray *timeArray;

@property(copy, nonatomic) NSArray *repeatArray;

@property(copy, nonatomic) NSString *noticeString;

@end
