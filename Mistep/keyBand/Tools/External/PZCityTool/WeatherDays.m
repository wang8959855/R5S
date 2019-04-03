//
//  WeatherDays.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/20.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "WeatherDays.h"

@implementation WeatherDays

-(NSString *)description
{
    return [NSString stringWithFormat:@"weatherDateArray:%ld,weatherType:%@,weatherMax:%@,_weatherMin:%@",_weatherDateArray.count,_weatherType,_weatherMax,_weatherMin];
}

//@property (strong, nonatomic) NSArray *weatherDateArray;            //日期
//@property (strong, nonatomic) NSString *weatherType;                //天气类型
//@property (strong, nonatomic) NSString *weatherMax;             //温度范围
//@property (strong, nonatomic) NSString *weatherMin;             //温度范围
@end
