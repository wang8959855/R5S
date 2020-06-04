//
//  HCHCommonManager.h
//  HuiChengHe
//
//  Created by zhangtan on 14-12-7.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AFNetworking.h"
#import "TodayStepsViewController.h"
#import "Reachability.h"

typedef void(^networkStatusBlock)(NetworkStatus network);
@interface HCHCommonManager : NSObject

@property (nonatomic, assign) BOOL isFirstLogin;
@property (nonatomic, assign) int stepsPlan;
@property (nonatomic, assign) int sleepPlan;
@property (nonatomic, assign) BOOL antilossIsOn;
@property (nonatomic, assign) int curTestMode;
@property (nonatomic, assign) int curHardVersion;
@property (nonatomic, assign) int curHardVersionTwo;//兼容第二个版本

@property (nonatomic, assign) float curBlueToothVersion;
@property (nonatomic, assign) float curSoftVersion;
@property (nonatomic, assign) int curPower;//手环电量
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int blueVersion;
@property (nonatomic, assign) int softVersion;
@property (nonatomic, retain) NSMutableDictionary *userInfoDictionAry;
@property (nonatomic, assign) int currentMode;
@property (nonatomic, strong) NSDictionary * curSportDic;
@property (nonatomic, assign) int eventCount;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int LanuguageIndex_SRK;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL isThirdPartLogin;
@property (nonatomic, assign) BOOL firstThirdPartLogin;//第一次第三方登录
@property (nonatomic, assign) int selectTimeSeconds;
@property (nonatomic, assign) int todayTimeSeconds;
@property (nonatomic, assign) CBManagerState BlueToothState;
@property (nonatomic, assign) int requestIndex;//全天心率数据请求包第几个。等待到这个包就开始存储离线数据
@property (nonatomic, assign) int queryHearRateSeconed; //请求心率的 时间 的秒数  .记录发送命令时间
@property (nonatomic, strong) NSMutableArray *queryWeatherArray;//请求天气的数组，数组中有值就按数组的规范来，没有数组就默认的走

@property (nonatomic, assign) int pilaoWarning;
/*
    #define QUERYWEATHERID @"queryWeatherID"
    #define QUERYWEATHERRI @"queryWeatherRi"
    #define QUERYWEATHERDAYNUMBER @"queryWeatherDayNumber"
 */

//@property (nonatomic, assign) int queryWeatherID;//请求天气的type   0x01 请求一天  0x02 请求几天
//@property (nonatomic, assign) int queryWeatherSeconds;//请求天气的秒数  请求几天  多天
//@property (nonatomic, assign) int queryWeatherDayNumber;//请求天气的天数    请求几天  多天
//@property (nonatomic, assign) int queryWeatherRi;//请求天气的日期    请求日期

//@property (nonatomic, assign) AFNetworkReachabilityStatus  networkStatus;//网络状态
@property (nonatomic,strong) Reachability *internetReachability;
@property (nonatomic, assign) NetworkStatus iphoneNetworkStatus;//网络状态 apple demo
//ada配置
@property (nonatomic, assign) BOOL pilaoValue;
//#define WEATHERLOCATION @"WEATHERLOCATION" //WEATHERLOCATION  天气的位置。天气的 1 是国内 2 是国外
@property (nonatomic, assign) NSInteger weatherLocation;//天气的位置。天气的 1 是国内 2 是国外


@property (nonatomic, assign) BOOL conState;    //  蓝牙 连接状态的监测

@property (nonatomic, assign) int LanguageNum;    //  语言状态。用于发给手表。用于请求天气发给手表

//实时返回网络状态
@property (nonatomic, copy) networkStatusBlock networkStatusBlock;

//获取平均心率
+ (void)getAvgHeartRate;





/**
 *得到实例
 */
+ (HCHCommonManager *)getInstance;
+ (void)clearInstance;
/**
 *得到存放文件的文件夹
 */
- (NSString *)getFileStoreFolder;
//将图片存储
- (NSString *)storeHeadImageWithImage:(UIImage *)locImage;
//讲图片从缓存改为存储
- (NSString *)saveImageFromCache;

//根据fileName获取图片
- (UIImage *)getHeadImageWithFile:(NSString *)fileName;
//- (void)sendUserInfoToBlueTooth;

//- (void)sendCurrentUserInfoToBlueTooth;

- (int)getPersonAge;

//生成长度为10的随机字符串
- (NSString *)createRandomString;

- (void)setUserEmailWith:(NSString *)email;
- (void)setUserBirthdateWith:(NSString *)birthdate;
- (void)setUserHeaderWith:(NSString *)header;
- (void)setUserHeightWith:(NSString *)height;
- (void)setUserWeightWith:(NSString *)weight;
- (void)setUserNickWith:(NSString *)nick;
- (void)setUserGenderWith:(NSString *)gender;
- (void)setUserAcountName:(NSString *)userName;
- (void)setUserAddressWith:(NSString *)address;
- (void)setUserIsCHDWith:(NSString *)isCHD;
- (void)setUserIsHypertensionWith:(NSString *)isHypertension;
- (void)setUserRafTel1With:(NSString *)rafTel1;
- (void)setUserRafTel2With:(NSString *)rafTel2;
- (void)setUserRafTel3With:(NSString *)rafTel3;
/** 基准低压 */
- (void)setUserDiastolicPWith:(NSString *)diastolicP;
/** 基准高压 */
- (void)setUserSystolicPWith:(NSString *)systolicP;
- (void)setUserVipTimeWith:(NSString *)VipTime;
- (void)setUserIDCardNoWith:(NSString *)IDCardNo;
- (void)setUserPointWith:(NSString *)Point;
- (void)setUserTelWith:(NSString *)Tel;
- (void)setUserGluWith:(NSString *)Glu;
- (void)setUserIsGlu:(NSString *)isGlu;


- (id)UserEmail;
- (id)userBirthdate;
- (id)UserHeader;
- (id)UserHeight;
- (id)UserWeight;
- (id)UserNick;
- (id)UserGender;
- (id)UserAcount;
- (id)UserAddress;
- (id)UserIsCHD;
- (id)UserIsHypertension;
- (id)UserRafTel1;
- (id)UserRafTel2;
- (id)UserRafTel3;
/** 基准低压 */
- (id)UserDiastolicP;
/** 基准高压 */
- (id)UserSystolicP;
- (id)UserVipTime;
- (id)UserIDCardNo;
/** 用户积分 */
- (id)UserPoint;
- (id)UserTel;
- (id)UserGlu;
- (id)UserIsGlu;

- (void)initData;
- (int)getAge;//几岁了。

//是否连接设备
@property (nonatomic, assign) BOOL isEquipmentConnect;

@end
