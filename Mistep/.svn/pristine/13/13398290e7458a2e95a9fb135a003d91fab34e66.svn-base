//
//  SportModelMap.h
//  Mistep
//
//  Created by 迈诺科技 on 2017/1/19.
//  Copyright © 2017年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    WarmUp_sportS = 0,
    Aerobic_sportS,
    Anaerobic_sportS,
    FatBurning_sportS,
    Limit_sportS,
}sportStrength_Enum;

//typedef enum {
//    NSAFRequest_GET   = 0,
//    NSAFRequest_POST,
//}NSAFRequestType_Enum;
@interface SportModelMap : NSObject

@property (nonatomic,strong)NSString * sportID;   //唯一的id   用于。存  删
@property (nonatomic,strong)NSString * sportType;
@property (nonatomic,strong)NSString * sportDate;
@property (nonatomic,strong)NSString * sportName;
@property (nonatomic,strong)NSString * fromTime;

@property (nonatomic,strong)NSString * toTime;
//  心率   1   heartRate
@property (nonatomic,strong)NSString * heartRate;
@property (nonatomic,strong)NSArray  * heartRateArray;//用于存储   每分钟的心率。一分钟一个心率。
//当前步数  4  stepNumber
@property (nonatomic,strong)NSString * stepNumber;
//当前里程  4  mileageNumber
@property (nonatomic,strong)NSString * mileageNumber;

//当前消耗热量    4  kcalNumber
@property (nonatomic,strong)NSString * kcalNumber;
//当前步速  1   stepSpeed
@property (nonatomic,strong)NSString * stepSpeed;

// CurrentUserName_HCH
@property (nonatomic,strong)NSString * userName;
@property (nonatomic,strong)NSString * deviceId;
@property (nonatomic,strong)NSString * deviceType;

@property (nonatomic,strong)NSString * isUp;
/**
 *  数据日期,格式为秒数 [NSDate dateWithTimeIntervalSince1970:seconds]可转化为date
 */
@property (assign, nonatomic) int timeSeconds;//用于存离线数据的时间。以后截取离线运动的心率事件
@property (assign, nonatomic) int startTimeSeconds;
@property (assign, nonatomic) int stopTimeSeconds;
@property (assign, nonatomic) sportStrength_Enum  sportStrength;

@property (nonatomic,strong) NSString * haveTrail;
@property (nonatomic,strong) NSArray * trailArray;
@property (nonatomic,strong) NSString * moveTarget;
//@property (nonatomic,strong) NSString * mileageM;
@property (nonatomic,strong) NSString * mileageM_map;

@property (nonatomic,strong) NSString * sportPace;  //配速
@property (nonatomic,strong) NSString * whenLong; //时长
@property (nonatomic,strong) NSString * falseData; //时长

+(SportModelMap *)setValueWithDictionary:(NSDictionary *)dictionary;

/**
 把对象转化为可以上传数据的字典
 */
-(NSDictionary *)modelToUpdataDictionary;

/**
 把对象转化为可以storage  的字典
 */
-(NSDictionary *)modelToStorageDictionary;

/**
 把下载的数据转化为对象
 */
+(SportModelMap *)modelWithDictionary:(NSDictionary *)dictonary  key:(NSString *)key;

@end
