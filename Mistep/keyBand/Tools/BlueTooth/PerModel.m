//
//  PerModel.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/5.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PerModel.h"

@implementation PerModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"macAddress-%@,per-%@,RSSI-%d,deviceId-%@,UUIDString-%@,deviceName-%@",_macAddress,_per,_RSSI,_deviceId,_UUIDString,_deviceName];
}

@end
