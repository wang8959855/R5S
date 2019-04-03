////
////  SportModel.m
////  Mistep
////
////  Created by 迈诺科技 on 2016/10/31.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//
//#import "SportModel.h"
//
//@implementation SportModel
//
//+(SportModel *)setValueWithDictionary:(NSDictionary *)dictionary
//{
//    
//    SportModel *model = [[SportModel alloc]init];
//    model.sportID = [dictionary objectForKey:@"sportID"];
//    if (!((NSNull *)dictionary[@"sportType"] == [NSNull null]))
//        model.sportType = [dictionary objectForKey:@"sportType"];
//    if (!((NSNull *)dictionary[@"sportDate"] == [NSNull null]))
//        model.sportDate = [dictionary objectForKey:@"sportDate"];
//    if (!((NSNull *)dictionary[@"fromTime"] == [NSNull null]))
//        model.fromTime = [dictionary objectForKey:@"fromTime"];
//    if (!((NSNull *)dictionary[@"toTime"] == [NSNull null]))
//        model.toTime = [dictionary objectForKey:@"toTime"];
//    if (!((NSNull *)dictionary[@"heartRate"] == [NSNull null]))
//        model.heartRateArray = [NSKeyedUnarchiver unarchiveObjectWithData:dictionary[@"heartRate"]];
//    ////adaLog(@"model.heartRateArray  -- %@",model.heartRateArray);
//    if (!((NSNull *)dictionary[@"stepNumber"] == [NSNull null]))
//        model.stepNumber = [dictionary objectForKey:@"stepNumber"];
//    if (!((NSNull *)dictionary[@"mileageNumber"] == [NSNull null]))
//        model.mileageNumber = [dictionary objectForKey:@"mileageNumber"];
//    if (!((NSNull *)dictionary[@"kcalNumber"] == [NSNull null]))
//        model.kcalNumber = [dictionary objectForKey:@"kcalNumber"];
//    if (!((NSNull *)dictionary[@"stepSpeed"] == [NSNull null]))
//        model.stepSpeed = [dictionary objectForKey:@"stepSpeed"];
//    if (!((NSNull *)dictionary[@"sportName"] == [NSNull null]))
//        model.sportName = [dictionary objectForKey:@"sportName"];
//    model.userName = dictionary[CurrentUserName_HCH];
//    model.isUp = dictionary[ISUP];
//    model.deviceId = dictionary[DEVICEID];
//    model.deviceType = dictionary[DEVICETYPE];
//    
//    model.haveTrail = dictionary[HAVETRAIL];
//     if (!((NSNull *)dictionary[TRAILARRAY] == [NSNull null]))
//    model.trailArray = dictionary[TRAILARRAY];
//    model.moveTarget = dictionary[MOVETARGET];
//    model.mileageM = dictionary[MILEAGEM];
//    model.mileageM_map = dictionary[MILEAGEM_MAP];
//    model.sportPace = dictionary[SPORTPACE];
//    model.whenLong = dictionary[WHENLONG];
//    
//    
//    
//    
//    //adaLog(@"sportModel---%@",model);
//    return model;
//}
//-(NSDictionary *)modelToUpdataDictionary
//{
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
//    NSMutableDictionary * subDictionary = [NSMutableDictionary dictionary];
//    int start=[[TimeCallManager getInstance] getSecondsWithTimeString:self.fromTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    int end=[[TimeCallManager getInstance] getSecondsWithTimeString:self.toTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *key =[NSString stringWithFormat:@"%d-%d",start,end];
//    if (self.heartRateArray) {
//        NSString *string = [AllTool  arrayToString:self.heartRateArray];
//        [subDictionary setValue:string forKey:@"heart"];
//    }
//    else
//    {
//        [subDictionary setValue:@"0" forKey:@"heart"];
//    }
//    if (self.kcalNumber) {
//        [subDictionary setValue:self.kcalNumber  forKey:@"calorie"];
//    }else
//    {
//        [subDictionary setValue:@"0"  forKey:@"calorie"];
//    }
//    if (self.stepNumber) {
//        [subDictionary setValue:self.stepNumber forKey:@"step"];
//    }else {
//        [subDictionary setValue:@"0" forKey:@"step"];
//    }
//    if (self.sportType) {
//        [subDictionary setValue:intToString([self.sportType intValue]-100) forKey:@"movementType"];
//        //        [subDictionary setValue:self.sportType forKey:@"movementType"];
//    } else {
//        [subDictionary setValue:@"0" forKey:@"movementType"];
//    }
//    //    NSString *str = [AllTool dictionaryToJson:subDictionary];
//    [dictionary setValue:subDictionary forKey:key];
//    return dictionary;
//}
///**
// 把对象转化为可以storage  的字典
// */
//-(NSDictionary *)modelToStorageDictionary
//{
//    NSMutableDictionary *dictionary =[NSMutableDictionary dictionary];
//    [dictionary setValue:self.sportID forKey:@"sportID"];
//    [dictionary setValue:self.sportType forKey:@"sportType"];
//    [dictionary setValue:self.sportDate forKey:@"sportDate"];
//    [dictionary setValue:self.fromTime forKey:@"fromTime"];
//    [dictionary setValue:self.toTime forKey:@"toTime"];
//    NSData *data =[NSData data];
//    if (self.heartRateArray)
//    {
//        data=[NSKeyedArchiver archivedDataWithRootObject:self.heartRateArray];
//    }
//    else
//    {
//    }
//    [dictionary setValue:data forKey:@"heartRate"];
//    [dictionary setValue:self.stepNumber forKey:@"stepNumber"];
//    [dictionary setValue:self.mileageNumber forKey:@"mileageNumber"];
//    [dictionary setValue:self.kcalNumber forKey:@"kcalNumber"];
//    [dictionary setValue:self.stepSpeed forKey:@"stepSpeed"];
//    [dictionary setValue:self.sportName forKey:@"sportName"];
//    
//    [dictionary setValue:self.deviceId forKey:DEVICEID];
//    [dictionary setValue:self.deviceType forKey:DEVICETYPE];
//    [dictionary setValue:@"1" forKey:ISUP];
//    [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
//    return dictionary;
//}
///**
// 把下载的数据转化为对象
// */
////"54156421-5532131":  //离线事件时间段 开始时间-结束时间，从1970年计算秒数
////{
////    "heart":"",			 //心率
////    "calorie":"12",    	 //事件内消耗热量（卡路里）
////    "step":"22",		  	 //	事件内的总步数
////    “movementType”：“” // 运动类型， 用户可自定义字段
//
//
//+(SportModel *)modelWithDictionary:(NSDictionary *)dictonary  key:(NSString *)key;
//{
//    SportModel *model = [[SportModel alloc]init];
//    NSArray *Arr = [key componentsSeparatedByString:@"-"];
//    int startTime = [Arr[0] intValue];
//    NSString *startTimeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:startTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *sportDateStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:startTime andFormat:@"yyyy-MM-dd"];
//    int stopTime = [Arr[1] intValue];
//    NSString *stopTimeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:stopTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
//    model.sportDate = sportDateStr;
//    model.fromTime = startTimeStr;
//    model.toTime = stopTimeStr;
//    model.sportType = dictonary[@"movementType"];
//    if (!(dictonary[@"step"] == [NSNull null]))
//        model.stepNumber = dictonary[@"step"];
//    if (!(dictonary[@"calorie"] == [NSNull null]))
//        model.kcalNumber = dictonary[@"calorie"];
//    model.heartRateArray =  [(NSString *)dictonary[@"heart"] componentsSeparatedByString:@","];
//    
//    //    if (!(dictionary[@"mileageNumber"] == [NSNull null]))
//    //        model.mileageNumber = [dictionary objectForKey:@"mileageNumber"];
//    //    if (!(dictionary[@"stepSpeed"] == [NSNull null]))
//    //        model.stepSpeed = [dictionary objectForKey:@"stepSpeed"];
//    //    if (!(dictionary[@"sportName"] == [NSNull null]))
//    //        model.sportName = [dictionary objectForKey:@"sportName"];
//    //    model.isUp = dictionary[ISUP];
//    //    model.deviceId = dictionary[DEVICEID];
//    //    model.deviceType = dictionary[DEVICETYPE];
//    
//    return model;
//}
// 
//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"sportID = %@,sportType = %@,sportDate = %@,fromTime = %@,toTime = %@,heartRate = %@,stepNumber = %@,mileageNumber = %@,kcalNumber = %@,stepSpeed = %@,sportName = %@,deviceId = %@,deviceType = %@,isUp = %@,_haveTrail = %@,_trailArray = %@,_moveTarget = %@,_mileageM = %@,_mileageM_map = %@,_sportPace = %@,_whenLong = %@",_sportID,_sportType,_sportDate,_fromTime,_toTime,_heartRate,_stepNumber,_mileageNumber,_kcalNumber,_stepSpeed,_sportName,_deviceId,_deviceType,_isUp, _haveTrail,_trailArray,_moveTarget,_mileageM,_mileageM_map,_sportPace,_whenLong];
//}
//@end