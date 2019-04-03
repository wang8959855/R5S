//
//  DayDetail+CoreDataProperties.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "DayDetail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DayDetail (CoreDataProperties)

+ (NSFetchRequest<DayDetail *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *dataDate;
@property (nullable, nonatomic, copy) NSString *userCount;

@property (nullable, nonatomic, retain) NSData *costsData;
@property (nullable, nonatomic, retain) NSData *pilaoData;
@property (nullable, nonatomic, retain) NSData *sleepData;
@property (nullable, nonatomic, retain) NSData *stepData;

@property (nullable, nonatomic, copy) NSNumber *awakeSleep;
@property (nullable, nonatomic, copy) NSNumber *deepSleep;
@property (nullable, nonatomic, copy) NSNumber *lightSleep;


@property (nullable, nonatomic, copy) NSString *isUp;
@property (nullable, nonatomic, copy) NSString *deviceType;
@property (nullable, nonatomic, copy) NSString *deviceID;

@end

NS_ASSUME_NONNULL_END
