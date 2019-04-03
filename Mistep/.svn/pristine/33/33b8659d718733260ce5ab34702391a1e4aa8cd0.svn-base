//
//  HeartRate+CoreDataProperties.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/12/24.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "HeartRate+CoreDataProperties.h"

@implementation HeartRate (CoreDataProperties)

+ (NSFetchRequest<HeartRate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HeartRate"];
}

@dynamic dataDate;
@dynamic heartData;
@dynamic userCount;
@dynamic deviceID;
@dynamic deviceType;
@dynamic isUp;

-(NSString *)description
{
    return [NSString stringWithFormat:@"isUp=%@,deviceType=%@,deviceID=%@",self.isUp,self.deviceType,self.deviceID];
}

@end
