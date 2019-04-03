//
//  BlueToothData.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/6.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "BlueToothData.h"
#import "CoreDataManage.h"
#import "JiuzuoModel.h"

#define intToString(x) [NSString stringWithFormat:@"%d",x]

static BlueToothData *instance;
@implementation BlueToothData

- (void)dealloc
{
    instance = nil;
//    [BlueToothManager getInstance].myDelegate = nil;
}


- (instancetype )init
{
    if (self = [super init])
    {
        [self connectLastDevice];
    }
    return self;
}

- (void)connectLastDevice
{
    NSString *blueToothUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kLastDeviceUUID];
    if (![BlueToothManager getInstance].isConnected) {
        if (blueToothUUID && ![blueToothUUID isEqualToString:@""])
        {
            [[BlueToothManager getInstance] ConnectWithUUID:blueToothUUID];
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(BlueToothIsConnected:)])
            {
                [_delegate BlueToothIsConnected:NO];
            }
        }
    }
}

#pragma mark - BlutToothManagerDelegate

- (void)blueToothManagerIsConnected:(BOOL)isConnected
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(BlueToothIsConnected:)])
    {
        [_delegate BlueToothIsConnected:isConnected];
    }
    if (_shebeiDelegate && [_shebeiDelegate respondsToSelector:@selector(BlueToothIsConnected:)])
    {
        [_shebeiDelegate BlueToothIsConnected:isConnected];
    }
}

- (void)blueToothManagerReceiveNotifyData:(NSData *)Dat
{
    Byte *transDat = (Byte *)[Dat bytes];
    
    switch (transDat[1] & 0x7f) {
        case CheckPower_Enum:
            [self receivePowerDataWith:transDat];
            break;
        case GetActualData_Enum:
            //            [self reviceActualDataWith:Dat];
            break;
        case CheckVersion_Enum:
            [self receiveVersionDataWith:transDat];
            break;
        case CustomAlarm_Enum:
        {
            int totalData = [self combineDataWithAddr:transDat + 2 andLength:2];
            if(!totalData) return;
            if (_alrmDelegate && [_alrmDelegate respondsToSelector:@selector(blueToothRecieveAlarmData:)])
            {
                [_alrmDelegate blueToothRecieveAlarmData:Dat];
            }
        }
            break;
        case TimeSync_Enum:
//                [[BlueToothManager getInstance] synsCurTime];
            break;
        case UpdateTotalData_Enum:
            [self receiveTotalDataWith:Dat];
       
            break;
        case UpdateOffLine_Enum:
                [self receiveOffLineDataWith:Dat];
                int len = 0;
                if(transDat[12] == 0x01) {
                    len = 9;
                }else {
                    len = 11;
                }
                [[BlueToothManager getInstance]revDataAckWith:UpdateOffLine_Enum andDat:[Dat subdataWithRange:NSMakeRange(4, len)]];
            break;
        case UpdateSleepData_Enum:
            
            break;
        case OpenAntiLoss_Enum:
            
            [self recieveAntiLossData:Dat];
            break;
        case TiredCheck_Enum:
            break;
        case UpdateTiredData_Enum:

            [self receivePilaoData:Dat];
            break;
        case CustomAlarm_Enum_None:
            if (_alrmDelegate && [_alrmDelegate respondsToSelector:@selector(blueToothRecieveAlarmData:)])
            {
                [_alrmDelegate blueToothRecieveAlarmData:Dat];
            }
            break;
        case UpdateHardWare_Enum:
        {
            [self receiveUpdateResponse:Dat];
        }
            break;
        case PhoneDelay_Enum:
        {
            [self blueToothReceivePhoneDelay:Dat];
        }
            break;
        case ResetDevice_Enum:
        {
            if (_shebeiDelegate && [_shebeiDelegate respondsToSelector:@selector(resetDeviceOK)])
            {
                [_shebeiDelegate resetDeviceOK];
            }
        }
            break;
        case HeartRateAlarm_Enum:
        {
            if (transDat[4] == 2)
            {
                int state = transDat[5];
                int max = transDat[6];
                int min = transDat[7];
                NSArray *heartAlarmArray = @[[NSNumber numberWithInt:min],[NSNumber numberWithInt:max]];
                [[NSUserDefaults standardUserDefaults] setObject:heartAlarmArray forKey:kHeartRateAlarm];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (self.heartAlarmBlock)
                {
                    self.heartAlarmBlock (state,max,min);
                }
            }

        }
            break;
        case JiuzuoAlarm_Enum:
        {
            [self recieveJiuzuoAlarmData:Dat];
        }
            break;
        case UnitSet_Enum:
        {
            [self receiveHeartAndTired:Dat];
        }
            break;
        case TakePhoto_Enum:
        {
            [self receiveTakePhoto:Dat];
        }
            break;
        case ExceptioncodeData_Enum:
        {
            [self receiveExceptionData:Dat];
        }
        default:
            break;
    }
}

#pragma mark -- recieveData

- (void)receiveExceptionData:(NSData *)data
{
    [[BlueToothManager getInstance] responseExceptionData];
    NSLog(@"%@",[data description]);
    Byte *transData = (Byte *)[data bytes];
    uint len = [self combineDataWithAddr:transData+2 andLength:2];
    
    NSMutableString *mac = [[NSMutableString alloc] init];
    for ( int i = 0 ; i < 6; i ++)
    {
        NSString *string = [[data subdataWithRange:NSMakeRange(10-i, 1)] description];
        string = [string substringWithRange:NSMakeRange(1, 2)];
        [mac appendString:[NSString stringWithFormat:@":%@",string]];

    }

    NSString *exceptionString = [[data subdataWithRange:NSMakeRange(11, len - 7)] description];
//    NSLog(@"%@",exceptionData);

    NSDate *date = [NSDate new];
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    dt.timeZone = [NSTimeZone systemTimeZone];
    dt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeString = [dt stringFromDate:date];
    NSLog(@"%@",timeString);
//   [TimeCallManager getInstance]
    
    NSString *dataString = [NSString stringWithFormat:@"异常时间:%@ MAC地址%@ 设备名称:%@ 异常数据:%@\r\n", timeString,mac,[BlueToothManager getInstance].deviceName,exceptionString];
    
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileName = @"exceptionData.txt";
    NSString *filePath = [rootPath stringByAppendingPathComponent:fileName];
    
    NSData *histotyData = [NSData dataWithContentsOfFile:filePath];
    NSMutableString *cacheString = [[NSMutableString alloc] init];
    if (histotyData && histotyData.length != 0)
    {
        NSString *historyString = [[NSString alloc] initWithData:histotyData encoding:NSUTF8StringEncoding];
        if(historyString.length > 20000)
        {
            historyString = [historyString substringFromIndex:dataString.length];
        }
        [cacheString appendString:historyString];
        [cacheString appendString:dataString];
    }
    else
    {
        [cacheString appendString:dataString];
    }
    
    [cacheString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)receiveTakePhoto:(NSData *)data
{
    if (_takePhoto)
    {
        _takePhoto(1);
    }
    [[BlueToothManager getInstance] answerTakePhoto];
}

- (void)receiveHeartAndTired:(NSData*)data
{
    Byte *transData = (Byte *)[data bytes];
    if (transData[4] == 0)
    {
        int heartDuration = transData[6];
        int tiredState = transData[8];
        if (self.heartAndTiredBlock)
        {
            _heartAndTiredBlock(heartDuration,tiredState);
        }
    }
}

- (void)recieveJiuzuoAlarmData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    if (transDat[4] == 0)
    {
        int length = [self combineDataWithAddr:transDat+2 andLength:2];
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < length/7; i ++)
        {
            int index = 5 + i * 7;
            int tag = transDat[index];
            BOOL isOpen = transDat[index +1];
            int beginMin = transDat[index +2];
            int beginHour = transDat[index + 3];
            int endMin = transDat[index + 4];
            int endHour = transDat[index + 5];
            int duration = transDat[index + 6];
            JiuzuoModel *model = [[JiuzuoModel alloc] init];
            model.tag = tag;
            model.isOpen = isOpen;
            model.beginMin = beginMin;
            model.beginHour = beginHour;
            model.endMin = endMin;
            model.endHour = endHour;
            model.duration = duration;
            [mutaArray addObject:model];
        }
        if (self.jiuzuoBlock)
        {
            self.jiuzuoBlock(mutaArray);
        }
    }
}

- (void)recieveAntiLossData:(NSData *)data
{
    Byte *transDat = (Byte *)[data bytes];
    if ((transDat[1] & 0x7f) == OpenAntiLoss_Enum && transDat[4] == 1) {
        NSInteger tagIndex = transDat[5];
        int state = transDat[6];
        if (self.smsOpen)
        {
            self.smsOpen(tagIndex,state);
        }
        if (state == 1 && transDat[5] != 1)
        {
            [[BlueToothManager getInstance] phoneAlarmNotify];
        }
        if (tagIndex == 3)
        {
            if (state == 1)
            {
                _isPhone = YES;
                if (self.phoneOpen)
                {
                    self.phoneOpen(1);
                }
            }
            else
            {
                _isPhone = NO;
                if (self.phoneOpen)
                {
                    self.phoneOpen(0);
                }
            }
        }
        if (tagIndex == 2)
        {
            if (state == 1)
            {
                _isSMS = YES;
            }
            else {
                _isSMS = NO;
            }
        }
        if (tagIndex == 1) {
            if (self.antilossBlock)
            {
                self.antilossBlock(state);
            }
        }
    }
}

- (void)blueToothReceivePhoneDelay:(NSData *)Dat
{
    Byte *transDat = (Byte *)[Dat bytes];
    int type = transDat[4];
    if (type == 1)
    {
//        if (self.phoneOkBloack)
//        {
//            self.phoneOkBloack (1);
//        }
    }
    else
    {
        int delayTime = transDat[5];
      
        if (self.phoneBlock && self.phoneBlock != nil)
        {
            self.phoneBlock(delayTime);
        }
    }
}

- (void)blueToothManagerReceiveHeartRateNotify:(NSData *)Dat
{
    if ([Dat length] < 2) {
        return;
    }
    Byte *transDat = (Byte *)[Dat bytes];
    if (_delegate &&[_delegate respondsToSelector:@selector(recieveHeartRate:)]&&_delegate != nil)
    {
        [_delegate recieveHeartRate:transDat[1]];
    }
}

- (void)upDateFaile
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reSendUpdataData) object:nil];
    if (_aboutDelegate && _aboutDelegate!= nil && [_aboutDelegate respondsToSelector:@selector(upDateFailDelegate)])
    {
        [_aboutDelegate upDateFailDelegate];
    }
}

- (void)receiveUpdateResponse:(NSData *)data
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reSendUpdataData) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(upDateFaile) object:nil];
    Byte *transDat = (Byte *)[data bytes];
    if (transDat[4] == 0x00)
    {
        [self performSelector:@selector(reSendUpdataData) withObject:nil afterDelay:2];
        [self performSelector:@selector(upDateFaile) withObject:nil afterDelay:6];
        [[BlueToothManager getInstance] updateHardWaerWithPackIndex:1];
        _packNumber = 1;
        
    }
    else if (transDat[4] == 0x01)
    {
        int totalPack = [self combineDataWithAddr:transDat + 5 andLength:2];
        int pack = [self combineDataWithAddr:transDat + 7 andLength:2];
        
        if (_aboutDelegate && _aboutDelegate != nil && [_aboutDelegate respondsToSelector:@selector(updateProgress:)])
        {
            float progress = 0;
            float fPack = (float)pack;
            progress = fPack/totalPack;
            [_aboutDelegate updateProgress:progress];
        }
        if (pack < totalPack)
        {
            [[BlueToothManager getInstance] updateHardWaerWithPackIndex:pack +1];
            _packNumber = pack +1;
            [self performSelector:@selector(reSendUpdataData) withObject:nil afterDelay:2];
            [self performSelector:@selector(upDateFaile) withObject:nil afterDelay:6];
        }
        else
        {
            [[BlueToothManager getInstance] updatehardwaerComplete];
        }
    }
    else if (transDat[4] == 0x02)
    {
        return;
    }
}

- (void)reSendUpdataData
{
    [[BlueToothManager getInstance] updateHardWaerWithPackIndex:_packNumber];
    [self performSelector:@selector(reSendUpdataData) withObject:nil afterDelay:2];

}

- (void)receivePowerDataWith:(Byte *)data
{
    int power = data[4];
    [HCHCommonManager getInstance].curPower = power;
    if (_delegate && _delegate != nil && [_delegate respondsToSelector:@selector(bluetoothRecievePowerInformation:)])
    {
        [_delegate bluetoothRecievePowerInformation:power];
    }
}

- (void)receivePilaoData:(NSData *)data
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        int curDate = [[TimeCallManager getInstance] getSecondsOfCurDay];
        int dataDate = [[TimeCallManager getInstance] getYYYYMMDDSecondsWith:[data subdataWithRange:NSMakeRange(4, 3)]];
        if (curDate != dataDate)
        {
            [[BlueToothManager getInstance] revDataAckWith:UpdateTiredData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 3)]];
        }
        Byte *transDat = (Byte *)[data bytes];
        NSMutableArray *pilaoArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 24; i ++)
        {
            int pilaoValue = transDat[7+i];
            if (pilaoValue == -1 || pilaoValue == 0xff)
            {
                pilaoValue = 0xff;
            }
            [pilaoArray addObject:[NSNumber numberWithInt:pilaoValue]];
        }
        NSData *pilaoData = [NSKeyedArchiver archivedDataWithRootObject:pilaoArray];
        NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:curDate];
        if (dic)
        {
            NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
            [mutDic setValue:pilaoData forKey:kPilaoData];
            [[CoreDataManage shareInstance] updataDayDetailTableWithDic:mutDic];
        }
        else
        {
            NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                                         [NSNumber numberWithInt:curDate],DataTime_HCH,
                                          pilaoData,kPilaoData,
                                         nil];
            [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (curDate == dataDate)
            {
                if (_dayDetailDelegate && [_dayDetailDelegate respondsToSelector:@selector(bluetoothrecieveDayDetailData)] && _dayDetailDelegate != nil)
                {
                    [_dayDetailDelegate bluetoothrecieveDayDetailData];
                }

            }
        });
    });
}

- (void)receiveTotalDataWith:(NSData *)data {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        Byte *transDat = (Byte *)[data bytes];

        if (data.length  < 8)
        {
            return;
        }
        int curDate = [[TimeCallManager getInstance] getSecondsOfCurDay];
        int dataDate =  [[TimeCallManager getInstance] getYYYYMMDDSecondsWith:[data subdataWithRange:NSMakeRange(4, 3)]];
        if (curDate != dataDate && transDat[7] != 0x03)
        {
            [[BlueToothManager getInstance]revDataAckWith:UpdateTotalData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 4)]];
        }
        else if (curDate != dataDate && transDat[7] == 0x03)
        {
            [[BlueToothManager getInstance]revDataAckWith:UpdateTotalData_Enum andDat:[data subdataWithRange:NSMakeRange(4, 6)]];
        }
        
        if (transDat[7] == 0x00)
        {
            int timeSeconds = dataDate;
            //    int timeSeconds = [self combineDataWithAddr:transDat + 4 andLength:3] - systemTimeOffset;
          
            int stepCount = [self combineDataWithAddr:transDat + 8 andLength:4];
            int meterCount = [self combineDataWithAddr:transDat + 16 andLength:4];
            int costCount = [self combineDataWithAddr:transDat + 12 andLength:4];
            int activity = [self combineDataWithAddr:transDat + 20 andLength:4];
            int activityCosts = [self combineDataWithAddr:transDat + 24 andLength:4];
            int calmtime = [self combineDataWithAddr:transDat+28 andLength:4];
            int calmtimeCosts = [self combineDataWithAddr:transDat + 32 andLength:4];
         
            NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];

            if (dic)
            {
                [dic setValue:intToString(stepCount) forKey:TotalSteps_DayData_HCH];
                [dic setValue:intToString(meterCount) forKey:TotalMeters_DayData_HCH];
                [dic setValue:intToString(costCount) forKey:TotalCosts_DayData_HCH];
                [dic setValue:intToString([HCHCommonManager getInstance].sleepPlan)  forKey:Sleep_PlanTo_HCH];
                [dic setValue:intToString([HCHCommonManager getInstance].stepsPlan) forKey:Steps_PlanTo_HCH];
                [dic setValue:intToString(activity) forKey:TotalDataActivityTime_DayData_HCH];
                [dic setValue:intToString(calmtime) forKey:TotalDataCalmTime_DayData_HCH];
                [dic setValue:intToString(activityCosts) forKey:kTotalDayActivityCost];
                [dic setValue:intToString(calmtimeCosts) forKey:kTotalDayCalmCost];
            }else
            {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                       intToString(timeSeconds),  DataTime_HCH,
                       intToString(stepCount), TotalSteps_DayData_HCH,
                       intToString(meterCount), TotalMeters_DayData_HCH,
                       intToString(costCount), TotalCosts_DayData_HCH,
                       intToString([HCHCommonManager getInstance].sleepPlan) , Sleep_PlanTo_HCH,
                       intToString([HCHCommonManager getInstance].stepsPlan), Steps_PlanTo_HCH,
                       intToString(activity),TotalDataActivityTime_DayData_HCH,
                       intToString(calmtime),TotalDataCalmTime_DayData_HCH,
                       intToString(activityCosts),kTotalDayActivityCost,
                       intToString(calmtimeCosts),kTotalDayCalmCost,
                       nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SQLdataManger getInstance] insertSignalDataToTable:DayTotalData_Table withData:dic];
                if (timeSeconds == [[TimeCallManager getInstance] getSecondsOfCurDay])
                {
                    if (_delegate && [_delegate respondsToSelector:@selector(blueToothRecieveTotalDayData:)])
                    {
                        [_delegate blueToothRecieveTotalDayData:dic];
                        [HCHCommonManager getInstance].curSportDic = dic;
                    }
                    if (_dayDetailDelegate && [_dayDetailDelegate respondsToSelector:@selector(blueToothRecieveTotalDayData:)] && _dayDetailDelegate != nil)
                    {
                        [_dayDetailDelegate blueToothRecieveTotalDayData:dic];
                    }
                }
               
            });
        }else if (transDat[7] == 0x01)
        {
            
                int timeSeconds = dataDate;
                NSMutableArray *stepsArray = [[NSMutableArray alloc] init];
                NSMutableArray *costsArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < 24; i ++)
                {
                    int stepsValue = [self combineDataWithAddr:transDat + (8 + 4*i) andLength:4];
                    int costsValue = [self combineDataWithAddr:transDat +(104 + 4*i) andLength:4];
                    if (stepsValue == -1)
                    {
                        stepsValue = 0;
                    }
                    if (costsValue == -1)
                    {
                        costsValue = 0;
                    }
                    [stepsArray addObject:[NSNumber numberWithInt:stepsValue]];
                    [costsArray addObject:[NSNumber numberWithInt:costsValue]];
                }
                NSData *stepData = [NSKeyedArchiver archivedDataWithRootObject:stepsArray];
                NSData *costsData = [NSKeyedArchiver archivedDataWithRootObject:costsArray];
            
            
                NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:timeSeconds];
                if (dic)
                {
                    NSMutableDictionary *dictionnaray = [[NSMutableDictionary alloc]initWithDictionary:dic];
                    [dictionnaray setValue:stepData forKey:kDayStepsData];
                    [dictionnaray setValue:costsData forKey:kDayCostsData];
                    [[CoreDataManage shareInstance] updataDayDetailTableWithDic:dictionnaray];

                }
                else
                {
                    NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                                                 [NSNumber numberWithInt:timeSeconds],DataTime_HCH,
                                                 stepData,kDayStepsData,
                                                 costsData,kDayCostsData,
                                                 nil];
                    [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];

                }
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (timeSeconds == [[TimeCallManager getInstance] getSecondsOfCurDay])
                    {
                        if (_dayDetailDelegate && [_dayDetailDelegate respondsToSelector:@selector(bluetoothrecieveDayDetailData)] && _dayDetailDelegate != nil)
                        {
                            [_dayDetailDelegate bluetoothrecieveDayDetailData];
                        }
                    }
                });
            

           }else if (transDat[7] == 0x02)
            {
                int deepSleep = 0;
                int lightSleep = 0;
                int awakeSleep = 0;
                NSMutableArray *sleepStates = [[NSMutableArray alloc]init];
                for (int i = 0; i < 36; i ++)
                {
                    int sleepState = transDat[8+i];
                    for (int index = 0; index < 4; index ++)
                    {
                        int state = sleepState >> (2 * index) & 0x03;
                        if (state == 0)
                        {
                            awakeSleep ++;
                        }
                        if (state == 1)
                        {
                            lightSleep ++;
                        }
                        if (state == 2)
                        {
                            deepSleep ++;
                        }
                        [sleepStates addObject:[NSNumber numberWithInt:state]];
                    }
                }
                NSData *sleepData = [NSKeyedArchiver archivedDataWithRootObject:sleepStates];
                NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:dataDate];
                if (dic)
                {
                    NSMutableDictionary * multDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                    [multDic setValue:sleepData forKey:DataValue_SleepData_HCH];
                    [multDic setValue:[NSNumber numberWithInt:lightSleep] forKey:kLightSleep];
                    [multDic setValue:[NSNumber numberWithInt:deepSleep] forKey:kDeepSleep];
                    [multDic setValue:[NSNumber numberWithInt:awakeSleep] forKey:kAwakeSleep];
                    [[CoreDataManage shareInstance] updataDayDetailTableWithDic:multDic];
                }
                else
                {
                    dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                           sleepData,DataValue_SleepData_HCH,
                           [NSNumber numberWithInt:dataDate],DataTime_HCH,
                           [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                           [NSNumber numberWithInt:lightSleep],kLightSleep,
                           [NSNumber numberWithInt:deepSleep],kDeepSleep,
                           [NSNumber numberWithInt:awakeSleep],kAwakeSleep,nil];
                    [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dic];
                }
             }else if (transDat[7] == 0x03)
             {
                 NSMutableArray *heartRateArray = [[NSMutableArray alloc]init];
                 int packIndex = transDat[9];
                
                 for (int i = 0 ; i < 180 ; i ++)
                 {
                     int heartRate = transDat[10 + i];
                     if (heartRate == 0xff)
                     {
                         heartRate = 0;
                     }
                     [heartRateArray addObject:[NSNumber numberWithInt:heartRate]];
                 }

                 
                 NSData *heartData = [NSKeyedArchiver archivedDataWithRootObject:heartRateArray];
                 int heartDateIndex = dataDate + packIndex;
                 
                 NSDictionary *dic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:heartDateIndex];

                 if (dic)
                 {
                     NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                     [mutDic setObject:heartData forKey:HeartRate_ActualData_HCH];
                     [[CoreDataManage shareInstance] updataHeartRateWithDic:mutDic];
                 }
                 else
                 {
                     dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                     [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                     [NSNumber numberWithInt:heartDateIndex],DataTime_HCH,
                                                  heartData,HeartRate_ActualData_HCH, nil];
                     [[CoreDataManage shareInstance] CreatHeartRateWithDic:dic];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (dataDate == [[TimeCallManager getInstance] getSecondsOfCurDay])
                     {
                         if (_dayDetailDelegate && [_dayDetailDelegate respondsToSelector:@selector(bluetoothRecieveHeartRateData)])
                         {
                             [_dayDetailDelegate bluetoothRecieveHeartRateData];
                         }
                     }
                 });
             }
        if (curDate != dataDate && transDat[7] != 0x03)
        {
            [self uploadDataWithTimeSeconds:dataDate];
        }
        else if (curDate != dataDate && transDat[7] == 0x03)
        {
            [self uploadDataWithTimeSeconds:dataDate];
        }
    });
}



- (void) receiveOffLineDataWith:(NSData *)data {
    int systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
    
    Byte *transDat = (Byte *)[data bytes];
    int nums = [self combineDataWithAddr:transDat + 4 andLength:4]  - systemTimeOffset;
    int timeSeconds = [[TimeCallManager getInstance]getYYYYMMDDSecondsSince1970With:nums];
    
    int start_Seconds = nums;
    nums = [self combineDataWithAddr:transDat + 8 andLength:4] - systemTimeOffset;
    int stopSeconds = nums;
    
    if (transDat[12] == 0x01) {
        NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
        if (dic) {
            testEventCount = [[dic objectForKey:TotalDayEventCount_DayData_HCH] intValue] + 1;
            [dic setValue:[NSNumber numberWithInt:testEventCount] forKey:TotalDayEventCount_DayData_HCH];
            [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
        }else {
            testEventCount = 1;
            dic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                   [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                   [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
                   [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
                   [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
                   [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
                   [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan ], Steps_PlanTo_HCH,
                   [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
                   [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
                   [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
                   nil];
            [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
        }
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                                 [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                                 [NSNumber numberWithInt:start_Seconds], StartTime_ActualData_HCH,
                                 [NSNumber numberWithInt:stopSeconds], StopTime_ActualData_HCH,
                                 [NSNumber numberWithInt:testEventCount],SportEventIndex_HCH,
                                 [NSNumber numberWithInt:-1], SportType_ActualData_HCH,
                                 [NSNumber numberWithInt:[self combineDataWithAddr:transDat + 17 andLength:4]],StepCount_ActualData_HCH,
                                 [NSNumber numberWithInt:[self combineDataWithAddr:transDat + 13 andLength:4]],CostCount_ActualData_HCH,
                                 nil];
        [[SQLdataManger getInstance] insertSignalDataToTable:ACtualTimeData_Table withData:dataDic];
        
    }else if (transDat[12] == 0x02) {
        int totalData = [self combineDataWithAddr:transDat + 2 andLength:2];
        int dataIndex = [[TimeCallManager getInstance] getIntervalFiveSecondWith:timeSeconds andEndTime:start_Seconds];
        int packegIndex = transDat[14] - 1;
        NSMutableArray *mutArray = [[NSMutableArray alloc]init];
        for (int index = 0; index < totalData - 11; index++) {
            int value = transDat[index + 15];
            if (value == 0xff) {
                value = 0;
            }
            NSMutableDictionary *heartRateDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                                                 [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                                                 [NSNumber numberWithInt:start_Seconds], StartTime_ActualData_HCH,
                                                 [NSNumber numberWithInt:stopSeconds], StopTime_ActualData_HCH,
                                                 [NSNumber numberWithInt:dataIndex +  packegIndex*180 + index], ActualData_Index_HCH,
                                                 [NSNumber numberWithInt:value],HeartRate_ActualData_HCH,
                                                 nil];
            [mutArray addObject:heartRateDic];
        }
        [[SQLdataManger getInstance]insertMoreDataToTable:ActualHeartRateData_Table withData:mutArray];
    }else if (transDat[12] == 0x03) {
        int totalData = [self combineDataWithAddr:transDat + 2 andLength:2];
        int dataIndex = [[TimeCallManager getInstance] getIntervalFiveSecondWith:timeSeconds andEndTime:start_Seconds];
        int packegIndex = transDat[14] - 1;
        NSMutableArray *mutArray = [[NSMutableArray alloc]init];
        for (int index = 0; index < totalData - 11; index++) {
            int value = transDat[index + 15];
            if (value == 0xff) {
                value = 0;
            }
            NSMutableDictionary *heartRateDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                                                 [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                                                 [NSNumber numberWithInt:start_Seconds], StartTime_ActualData_HCH,
                                                 [NSNumber numberWithInt:stopSeconds], StopTime_ActualData_HCH,
                                                 [NSNumber numberWithInt:dataIndex +  packegIndex*180 + index], ActualData_Index_HCH,
                                                 [NSNumber numberWithInt:value],Speed_ActualData_HCH,
                                                 nil];
            [mutArray addObject:heartRateDic];
        }
        [[SQLdataManger getInstance]insertMoreDataToTable:ActualSpeedData_Table withData:mutArray];
     
    }
    if (_delegate && [_delegate respondsToSelector:@selector(blueToothRecieveOffLineData)])
    {
        [_delegate blueToothRecieveOffLineData];
    }
}

- (void)receiveVersionDataWith:(Byte *)data {
    int bigVersion = (data[5] >> 4) & 0x0f;
    int smallVersion = data[5] & 0x0f;
    
    
    NSString *versionStr = [NSString stringWithFormat:@"%d.%02d",bigVersion, smallVersion];
    
    bigVersion = (data[6] >> 4) & 0x0f;
    smallVersion = data[6] & 0x0f;
    NSString *softStr = [NSString stringWithFormat:@"%d.%02d",bigVersion, smallVersion];
    
    [HCHCommonManager getInstance].curBlueToothVersion = [versionStr floatValue];
    [HCHCommonManager getInstance].curHardVersion = data[4];
    [HCHCommonManager getInstance].curSoftVersion = [softStr floatValue];
    [HCHCommonManager getInstance].softVersion = data[6];
    [HCHCommonManager getInstance].blueVersion = data[5];
    
    if (_aboutDelegate && [_aboutDelegate respondsToSelector:@selector(blueToothRecieveVisionData)])
    {
        [_aboutDelegate blueToothRecieveVisionData];
    }
    //    NSLog(@"hardversion = %d",data[4]);
    //    NSLog(@"curSoftVersion = %d", data[6]);
    //    NSLog(@"version = %@",versionStr);
}

- (int)combineDataWithAddr:(Byte *)addr andLength:(int)len {
    int result = 0;
    for (int index = 0; index < len; index ++) {
        result = result | ((*(addr + index)) << (8 *index));
        
    }
    if (result < 0)
    {
        result = 0;
    }
    return result;
}

- (void)updateHardWare
{
    [[BlueToothManager getInstance] startUpdateHard];
}

- (void)uploadDataWithTimeSeconds:(int)timeSeconds
{
    if ([HCHCommonManager getInstance].isLogin)
    {
        NSDictionary *todayDic = [[SQLdataManger getInstance] getTotalDataWith:timeSeconds];
        NSInteger step = 0;
        NSInteger light = 0;
        NSInteger awake = 0;
        NSInteger deep = 0;
        NSInteger stepPlan = 0;
        int completion = 2;
        
        step = [[todayDic objectForKey:TotalSteps_DayData_HCH]integerValue];
        stepPlan = [[todayDic objectForKey:Steps_PlanTo_HCH] integerValue];
        
        NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:timeSeconds];
        
        NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:timeSeconds - 86400];
        NSMutableArray *sleepArray = [[NSMutableArray alloc] init];
        NSArray *lastDaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:lastDayDic[DataValue_SleepData_HCH]];
        if (lastDaySleepArray && lastDaySleepArray.count != 0)
        {
            for (int i = 126; i < 144; i ++)
            {
                [sleepArray addObject:lastDaySleepArray[i]];
            }
        }
        else {
            for (int i = 0 ; i < 18; i ++)
            {
                [sleepArray addObject:@3];
            }
        }
        
        NSArray *todaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[DataValue_SleepData_HCH]];
        if (todaySleepArray && todaySleepArray.count != 0)
        {
            for (int i = 0; i < 72; i ++)
            {
                [sleepArray addObject:todaySleepArray[i]];
            }
        }
        int nightBeginTime = 0;
        int nightEndTime = 0;
        BOOL isBegin = NO;
        
        if (sleepArray && sleepArray.count != 0)
        {
            for (int i = 0 ; i < sleepArray.count; i ++)
            {
                
                int sleepState = [sleepArray[i] intValue];
                if (sleepState != 0 && sleepState != 3)
                {
                    if (isBegin == NO)
                    {
                        isBegin = YES;
                        nightBeginTime = i;
                    }
                    nightEndTime = i;
                }
                
                
            }
        }
        
        if (sleepArray && sleepArray.count != 0)
        {
            if (nightEndTime > nightBeginTime)
            {
                for (int i = nightBeginTime ; i <= nightEndTime; i ++)
                {
                    int state = [sleepArray[i] intValue];
                    if (state == 2) {
                        deep ++;
                    }
                    if (state == 1){
                        light ++;
                    }
                    if (state == 0 || state == 3)
                    {
                        awake ++;
                    }
                }
            }
        }
        
        if (step >= stepPlan)
        {
            completion = 1;
        }
        NSInteger totalSleep = light + deep;
        NSString *SleepState;
        totalSleep = totalSleep*10;
        if (totalSleep < 480)
        {
            SleepState = @"C";
        }else if (totalSleep < 600)
        {
            SleepState = @"B";
        }else
        {
            SleepState = @"A";
        }
        
        NSArray *pilaoArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kPilaoData]];
        int pilao = 0;
        for (int i = 0; i < pilaoArray.count; i ++)
        {
            int pilaoValue = [pilaoArray[i] intValue];
            if (pilaoValue != 0 && pilaoValue != 255)
            {
                pilao = pilaoValue;
            }
        }
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:timeSeconds andFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *tiredDic = @{TiredCheck_Time_HCH:timeStr,TiredCheck_Data_HCH:[NSNumber numberWithInt:pilao]};
        
        NSString *date = [[TimeCallManager getInstance] changeCurDateToItailYYYYMMDDString];
        NSString *formateDate = [date stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSDictionary *dataDic = @{@"activity.day":formateDate,@"activity.step":[NSNumber numberWithInt:step],@"activity.sleepDept":[NSNumber numberWithInt:deep * 10],@"activity.sleepLight":[NSNumber numberWithInt:light * 10],@"activity.sleepAweek":[NSNumber numberWithInt:awake * 10],@"activity.sleepStatus":SleepState,@"activity.finishStatus":[NSNumber  numberWithInt:completion]};
        
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_dayActivity" ParametersDictionary:dataDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
            if (error)
            {
                
            }
            else
            {
                
                int code = [responseObject[@"code"] intValue];
                if (code == 9001)
                {
                    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
                    if (dic)
                    {
                        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_login" ParametersDictionary:dic Block:^(id responseObject, NSError *error,NSURLSessionTask *task) {
                            if (error)
                            {
                                
                            }else
                            {
                                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_dayActivity" ParametersDictionary:dataDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task)
                                 {
                                     if (error)
                                     {
                                         
                                     }
                                     else
                                     {
                                         [[AFAppDotNetAPIClient sharedClient]globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_index" ParametersDictionary:tiredDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
                                             if (error){
                                                 
                                             }else
                                             {
                                                 NSLog(@"%@",responseObject[@"msg"]);
                                             }
                                         }];
                                     }
                                 }];
                            }
                        }];
                    }
                    else{
                        NSDictionary *thirdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kThirdPartLoginKey];
                        if (thirdDic)
                        {
                            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_thirdPartyLogin" ParametersDictionary:thirdDic Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
                                if (error)
                                {
                                    
                                }else
                                {
                                    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_dayActivity" ParametersDictionary:dataDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task)
                                     {
                                         if (error)
                                         {
                                             
                                         }
                                         else
                                         {
                                             [[AFAppDotNetAPIClient sharedClient]globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_index" ParametersDictionary:tiredDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
                                                 if (error){
                                                     
                                                 }else
                                                 {
                                                     NSLog(@"%@",responseObject[@"msg"]);
                                                 }
                                             }];
                                         }
                                     }];
                                }
                                
                            }];
                        }
                    }
                }
                else if (code == 9003)
                {
                    
                    [[AFAppDotNetAPIClient sharedClient]globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_index" ParametersDictionary:tiredDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
                        if (error){
                            
                        }else
                        {
                            NSLog(@"%@",responseObject[@"msg"]);
                        }
                    }];
                    
                }
            }
        }];
    }
}


@end
