//
//  adaWeatherModel.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/3/11.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface adaWeatherModel : NSObject


@property (strong, nonatomic) NSString *weatherDate;            //日期
@property (strong, nonatomic) NSString *realtimeShi;            //时间
@property (strong, nonatomic) NSString *weather_city;           //地点
@property (strong, nonatomic) NSString *weatherType;                //天气类型
@property (strong, nonatomic) NSString *weatherContent;           //天气内容

@property (strong, nonatomic) NSString *weatherMax;             //温度范围
@property (strong, nonatomic) NSString *weatherMin;             //温度范围
@property (strong, nonatomic) NSString *weather_currentTemp;    //当前温度
@property (strong, nonatomic) NSString *weather_uv;             //紫外线
@property (strong, nonatomic) NSString *weather_fl;            //风力

@property (strong, nonatomic) NSString *weather_fx;            //风向
@property (strong, nonatomic) NSString *weather_aqi;            //空气质量
@property (strong, nonatomic) NSMutableArray *tempArray;            // 温度array
@property (strong, nonatomic) NSString *city_id;                    //城市id


@end
