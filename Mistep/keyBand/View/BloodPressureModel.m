//
//  BloodPressureModel.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/11/7.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "BloodPressureModel.h"

@implementation BloodPressureModel
+(BloodPressureModel *)setValueWithDictionary:(NSDictionary *)dictionary
{
    BloodPressureModel *model = [[BloodPressureModel alloc]init];
    model.BloodPressureID = [dictionary objectForKey:@"BloodPressureID"];
    model.BloodPressureDate = [dictionary objectForKey:@"BloodPressureDate"];
    model.StartTime = [dictionary objectForKey:@"StartTime"];
    model.systolicPressure = [dictionary objectForKey:@"systolicPressure"];
    model.diastolicPressure = [dictionary objectForKey:@"diastolicPressure"];
    model.heartRate = [dictionary objectForKey:@"heartRate"];
    model.SPO2 = [dictionary objectForKey:@"SPO2"];
    model.HRV = [dictionary objectForKey:@"HRV"];
    
    model.isUp = dictionary[ISUP];
    model.deviceId = dictionary[DEVICEID];
    model.deviceType = dictionary[DEVICETYPE];
    adaLog(@"---%@",model);
    return model;
}

/**
 *
 *
 *数组转化为字典
 *
 **/
+(NSMutableDictionary *)arrayToDictionary:(NSArray*)array
{
    
    NSDictionary *lastDic = [array lastObject];
    NSDictionary *returnDic = @{@"time":lastDic[@"StartTime"],
                                @"Systolic":lastDic[@"systolicPressure"],
                                @"Diastolic":lastDic[@"diastolicPressure"],
                                @"HeartRate":lastDic[@"heartRateNumber"],
                                @"SPO2":lastDic[@"SPO2"],
                                @"HRV":lastDic[@"HRV"]
                                };
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:returnDic];
    return mutDic;

//    for (NSDictionary *dd in array)
//    {
//        NSMutableDictionary *TotalDict =[NSMutableDictionary dictionary];
//        NSMutableDictionary *tempDict =[NSMutableDictionary dictionary];
//        [tempDict setValue:dd[@"systolicPressure"] forKey:@"Systolic"];
//        [tempDict setValue:dd[@"diastolicPressure"] forKey:@"Diastolic"];
//        [tempDict setValue:dd[@"heartRateNumber"] forKey:@"HeartRate"];
//        [tempDict setValue:dd[@"SPO2"] forKey:@"SPO2"];
//        [tempDict setValue:dd[@"HRV"] forKey:@"HRV"];
//        
//        [TotalDict setValue:tempDict forKey:dd[@"StartTime"]];
//        
//        [dict addEntriesFromDictionary:TotalDict];
//    }
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"BloodPressureID = %@,BloodPressureDate = %@,StartTime = %@,systolicPressure = %@,diastolicPressure = %@,heartRate = %@,SPO2 = %@,HRV = %@ ",_BloodPressureID,_BloodPressureDate,_StartTime,_systolicPressure,_diastolicPressure,_heartRate,_SPO2,_HRV];
}

/**
 把对象转化为可以storage  的字典
 */
+(NSDictionary *)modelToStorageDict:(NSDictionary *)dict
{
    NSMutableDictionary *dictionary =[[NSMutableDictionary alloc]initWithDictionary:dict];
        [dictionary setValue:@"1" forKey:ISUP];
    
    //    [dictionary setValue:self.BloodPressureID forKey:BloodPressureID_def];
    //    [dictionary setValue:self.BloodPressureDate forKey:BloodPressureDate_def];
    //    [dictionary setValue:self.StartTime forKey:StartTime_def];
    //    [dictionary setValue:self.systolicPressure forKey:systolicPressure_def];
    //    [dictionary setValue:self.diastolicPressure forKey:diastolicPressure_def];
    //    [dictionary setValue:self.heartRate forKey:heartRateNumber_def];
    //    [dictionary setValue:self.SPO2 forKey:SPO2_def];
    //    [dictionary setValue:self.HRV forKey:HRV_def];
    //
    //    [dictionary setValue:self.deviceId forKey:DEVICEID];
    //    [dictionary setValue:self.deviceType forKey:DEVICETYPE];
    
    //    [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
    return dictionary;
    
}

/**
 把下载的数据转化为对象
 */
//"2016-12-09 10:08:22":  //时间
//{"Systolic":"",			 //收缩压
//    "Diastolic":"",    	 //舒张压
//    "HeartRate":"",		 //心率
//    "SPO2":"",		 	 //SPO2
//    "HRV":""		 		 //HRV
//},
+(NSDictionary *)modelWithDictionary:(NSDictionary *)dictonary  key:(NSString *)key;
{
    //    BloodPressureModel *model = [[BloodPressureModel alloc]init];
    //    model.StartTime = key;
    //    model.BloodPressureDate = [key substringToIndex:10];
    //    model.systolicPressure = dictonary[@"Systolic"];
    //    model.diastolicPressure = dictonary[@"Diastolic"];
    //    model.heartRate = dictonary[@"HeartRate"];
    //    model.SPO2 = dictonary[@"SPO2"];
    //    model.HRV = dictonary[@"HRV"];
    //    return model;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          key,StartTime_def,
                          [key substringToIndex:10],BloodPressureDate_def,
                          dictonary[@"Systolic"],systolicPressure_def,
                          dictonary[@"Diastolic"],diastolicPressure_def,
                          dictonary[@"HeartRate"],heartRateNumber_def,
                          dictonary[@"SPO2"],SPO2_def,
                          dictonary[@"HRV"],HRV_def,
                          nil];
    
    return dict;
}
//@property (nonatomic,strong)NSString * BloodPressureID;    //唯一的id   用于。存  删
//@property (nonatomic,strong)NSString * BloodPressureDate;  // 血压日期
//@property (nonatomic,strong)NSString * StartTime;          // 血压记录时间
//@property (nonatomic,strong)NSString * systolicPressure;   // 收缩压
//@property (nonatomic,strong)NSString * diastolicPressure;  // 舒张压
//@property (nonatomic,strong)NSString * heartRate;          //  心率   1   heartRate
//@property (nonatomic,strong)NSString * SPO2;                //血氧
//@property (nonatomic,strong)NSString * HRV;                // 疲劳度
//@property (nonatomic,strong)NSString * deviceId;
//@property (nonatomic,strong)NSString * deviceType;
//@property (nonatomic,strong)NSString * isUp;
@end
