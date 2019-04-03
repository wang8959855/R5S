//
//  WeatherDay.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/20.
//  Copyright © 2016年 huichenghe. All rights reserved.
//  未来的   天气模型

#import <Foundation/Foundation.h>

@interface WeatherDay : NSObject

@property (strong, nonatomic) NSString *fl_num;
@property (strong, nonatomic) NSString *fx_num;
@property (strong, nonatomic) NSString *weatherType;                //天气类型
@property (strong, nonatomic) NSString *weatherContent;           //天气内容
@property (strong, nonatomic) NSString *weatherCode;           //天气内容
@property (strong, nonatomic) NSString *temp_num_Max;             //温度范围 max
@property (strong, nonatomic) NSString *temp_num_Min;             //温度范围 min

@end
