//
//  DayDetail+CoreDataProperties.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "DayDetail+CoreDataProperties.h"

@implementation DayDetail (CoreDataProperties)

+ (NSFetchRequest<DayDetail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DayDetail"];
}

@dynamic awakeSleep;
@dynamic costsData;
@dynamic dataDate;
@dynamic deepSleep;
@dynamic lightSleep;
@dynamic pilaoData;
@dynamic sleepData;
@dynamic stepData;
@dynamic userCount;
@dynamic isUp;
@dynamic deviceType;
@dynamic deviceID;

-(NSString *)description
{
    return [NSString stringWithFormat:@"isUp=%@,deviceType=%@,deviceID=%@",self.isUp,self.deviceType,self.deviceID];
}
@end
