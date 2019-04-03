//
//  HeartRate+CoreDataProperties.h
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "HeartRate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HeartRate (CoreDataProperties)

+ (NSFetchRequest<HeartRate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *dataDate;
@property (nullable, nonatomic, retain) NSData *heartData;
@property (nullable, nonatomic, copy) NSString *userCount;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nullable, nonatomic, copy) NSString *deviceType;
@property (nullable, nonatomic, copy) NSString *isUp;

@end

NS_ASSUME_NONNULL_END
