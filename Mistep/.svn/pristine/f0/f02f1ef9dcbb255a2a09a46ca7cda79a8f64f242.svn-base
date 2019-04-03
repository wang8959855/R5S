//
//  BlueToothData.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/6.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BlueToothDataDelegate <NSObject>

@optional

- (void)BlueToothIsConnected:(BOOL)isconnected;

- (void)blueToothRecieveTotalDayData:(NSDictionary *)dic;

- (void)blueToothRecieveOffLineData;

- (void)blueToothRecieveVisionData;

- (void)blueToothRecieveAlarmData:(NSData*)dat;

- (void)bluetoothrecieveDayDetailData;

- (void)bluetoothRecieveHeartRateData;

- (void)bluetoothRecievePowerInformation:(int)power;

- (void)updateProgress:(float )progress;

- (void)recieveHeartRate:(int)heartRate;


- (void)setPhoneDelayOK;

- (void)resetDeviceOK;

- (void)bluetoothRecieveHeartAlarmData:(NSData *)data;

- (void)alarmUnpairBlueTooth;

- (void)upDateFailDelegate;

@end

@interface BlueToothData : NSObject


typedef void (^returnIntBlock)(int dBlueToothDataDelegatetypedef void (^returnArrayBlock)(NSArray *array);

//拍照Block
@property (copy, nonatomic) returnIntBlock takePhoto;

//心率监测和疲劳设置Block
@property (copy, nonatomic) doubleIntBlock heartAndTiredBlock;

// 来电提醒页面各个block
@property (copy, nonatomic) returnIntBlock phoneBlock;

@property (copy, nonatomic) returnIntBlock phoneOpen;

@property (copy, nonatomic) doubleIntBlock smsOpen;

// 久坐提醒block

@property (copy, nonatomic) returnArrayBlock jiuzuoBlock;

// 心率预警block

@property (copy, nonatomic) threeIntBlock heartAlarmBlock;

//防丢block

@property (copy, nonatomic) returnIntBlock antilossBlock;

@property (assign, nonatomic)id<BlueToothDataDelegate> delegate;

@property (assign, nonatomic)id<BlueToothDataDelegate> aboutDelegate;

@property (assign, nonatomic)id<BlueToothDataDelegate> alrmDelegate;

@property (assign, nonatomic)id<BlueToothDataDelegate> shebeiDelegate;

@property (assign, nonatomic)id<BlueToothDataDelegate> dayDetailDelegate;

@property (assign, nonatomic)id<BlueToothDataDelegate> homeDelegate;

@property BOOL isPhone;

@property (assign, nonatomic) int packNumber;

@property BOOL isSMS;

- (instancetype )init;


- (void)receiveTotalDataWith:(NSData *)data ;

- (void)updateHardWare;

@end
