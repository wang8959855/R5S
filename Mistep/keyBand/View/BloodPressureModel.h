//
//  BloodPressureModel.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodPressureModel : NSObject
@property (nonatomic,strong)NSString * BloodPressureID;    //唯一的id   用于。存  删
@property (nonatomic,strong)NSString * BloodPressureDate;  // 血压日期
@property (nonatomic,strong)NSString * StartTime;          // 血压记录时间
@property (nonatomic,strong)NSString * systolicPressure;   // 收缩压
@property (nonatomic,strong)NSString * diastolicPressure;  // 舒张压
@property (nonatomic,strong)NSString * heartRate;          //  心率   1   heartRate
@property (nonatomic,strong)NSString * SPO2;                //血氧
@property (nonatomic,strong)NSString * HRV;                // 疲劳度
@property (nonatomic,strong)NSString * deviceId;
@property (nonatomic,strong)NSString * deviceType;
@property (nonatomic,strong)NSString * isUp;
// CurrentUserName_HCH
@property (nonatomic,strong)NSString * userName;

+(BloodPressureModel *)setValueWithDictionary:(NSDictionary *)dictionary;
/**
 *
 *
 *数组转化为字典
 *
 **/
+(NSMutableDictionary *)arrayToDictionary:(NSArray*)array;
/**
 把对象转化为可以storage  的字典
 */
+(NSDictionary *)modelToStorageDict:(NSDictionary *)dict;
/**
 把下载的数据转化为对象
 */ 
+(NSDictionary *)modelWithDictionary:(NSDictionary *)dictonary  key:(NSString *)key;
@end
