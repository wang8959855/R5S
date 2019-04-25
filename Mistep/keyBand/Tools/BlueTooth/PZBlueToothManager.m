//
//  PZBlueToothManager.m
//  Mistep
//
//  Created by 迈诺科技 on 16/9/8.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "PZBlueToothManager.h"
#import "TimingUploadData.h"

@interface PZBlueToothManager()

@property (nonatomic,assign) int isSetBlocks;

@end
@implementation PZBlueToothManager

+ (PZBlueToothManager *)sharedInstance
{
    static PZBlueToothManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)checkBandPowerWithPowerBlock:(intBlock)PowerBlock
{
    [[CositeaBlueTooth sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        [HCHCommonManager getInstance].curPower = number;
        PowerBlock(number);
    }];
}

- (void)chekCurDayAllDataWithBlock:(void(^)(NSDictionary *dic))dayTotalDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] chekCurDayAllDataWithBlock:^(DayOverViewDataModel *model)
     {
         
         NSDictionary *dic = [weakSelf saveAllDayDataWithModel:model];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if (model.timeSeconds == [[TimeCallManager getInstance] getSecondsOfCurDay])
             {
                 if (dayTotalDataBlock)
                 {
                     dayTotalDataBlock(dic);
                     [HCHCommonManager getInstance].curSportDic = dic;
                 }
             }
         });
     }];
}

- (void)checkHourStepsAndCostsWithBlock:(void(^)( NSArray *steps,NSArray *costs))dayHourDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkHourStepsAndCostsWithBlock:^(NSArray *steps, NSArray *costs,int timeSeconds) {
        [weakSelf saveHourDataWithTimeSeconds:timeSeconds Steps:steps Costs:costs];
        if (dayHourDataBlock)
        {
            dayHourDataBlock(steps,costs);
        }
    }];
}

- (void)checkTodaySleepStateWithBlock:(void(^)(int timeSeconds, NSArray *sleepArray))sleepStateArrayBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkTodaySleepStateWithBlock:^(SleepModel *model) {
        [weakSelf saveSleepDataWithSleepModel:model];
        if (sleepStateArrayBlock)
        {
            sleepStateArrayBlock(model.timeSeconds,model.sleepArary);
        }
    }];
}

- (void)checkTodayHeartRateWithBlock:(void(^)(int timeSeconds,int index,NSArray *heartArray))heartRateArrayBlock
{
    WeakSelf
    [[CositeaBlueTooth sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *array)
     {
         int heartDateIndex = timeSeconds + index;       //8个包
         [weakSelf saveHeartRateArrayWithTiemIndex:heartDateIndex HeartRateArray:array];
         if (heartRateArrayBlock) {
             heartRateArrayBlock(timeSeconds,index,array);
         }
     }];
}

- (void)checkVerSionWithBlock:(void(^)(int firstHardVersion,int secondHardVersion,int softVersion,int blueToothVersion ))versionBlock
{
    [[CositeaBlueTooth sharedInstance] checkVerSionWithBlock:^(int firstHardVersion, int secondHardVersion, int softVersion, int blueToothVersion) {
        
        int bigVersion = (blueToothVersion >> 4) & 0x0f;
        int smallVersion = blueToothVersion & 0x0f;
        NSString *versionStr = [NSString stringWithFormat:@"%d.%02d",bigVersion, smallVersion];
        
        bigVersion = (softVersion >> 4) & 0x0f;
        smallVersion = softVersion & 0x0f;
        NSString *softStr = [NSString stringWithFormat:@"%d.%02d",bigVersion, smallVersion];
        
        [HCHCommonManager getInstance].curBlueToothVersion = [versionStr floatValue];
        [HCHCommonManager getInstance].curSoftVersion = [softStr floatValue];
        //        [NSString stringWithFormat:@"%02x",secondHardVersion];
        if (secondHardVersion == 161616) {
            [HCHCommonManager getInstance].curHardVersion = firstHardVersion;
        }
        else
        {
            [HCHCommonManager getInstance].curHardVersion = firstHardVersion;
            [HCHCommonManager getInstance].curHardVersionTwo = secondHardVersion;
        }
        [HCHCommonManager getInstance].softVersion = softVersion;
        [HCHCommonManager getInstance].blueVersion = blueToothVersion;
        if (versionBlock)
        {
            versionBlock(firstHardVersion,secondHardVersion,softVersion,blueToothVersion);
        }
    }];
}

- (void)checkHRVDataWithHRVBlock:(void(^)(int nimber,NSArray *array))HRVDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] checkHRVWithHRVBlock:^(int number, NSArray *array) {
        [weakSelf saveHRVDataWithTimeSeconds:number HRVDataArray:array];
//        [[TimingUploadData sharedInstance] updataPilaoWarning];

        HRVDataBlock(number,array);

        for (int i = 0; i < array.count; i ++)
        {
            int pilaoValue = [array[i] intValue];
            if (pilaoValue < kHCH.pilaoWarning && i < array.count-3)
            {
                int secondValue = [array[i + 1] intValue];
                if (secondValue < kHCH.pilaoWarning)
                {
                    int thirdValue = [array[i + 2] intValue];
                    if (thirdValue < kHCH.pilaoWarning)
                    {
                        int timeSeconds = [[ADASaveDefaluts objectForKey:@"pilaoWarningTime"] intValue];
                        if (timeSeconds != kHCH.todayTimeSeconds)
                        {
                            [[TimingUploadData sharedInstance] updataPilaoWarning];
                        }
                        return;
                    }
                }
            }
        }
    }];
}

- (void)connectedStateChangedWithBlock:(intBlock)stateChanged
{
    if (!_isSetBlocks) {
        [self setBlocks];
        _isSetBlocks =66;
    }
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] connectedStateChangedWithBlock:^(int number) {
        //adaLog(@"进来了");
        if (number)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[CositeaBlueTooth sharedInstance].connectUUID forKey:kLastDeviceUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ADASaveDefaluts setObject:[CositeaBlueTooth sharedInstance].deviceName forKey:kLastDeviceNAME];
            [weakSelf performSelector:@selector(openActuralHeart) withObject:nil afterDelay:2.0];
            

        }
        if (stateChanged)
        {
            self.connectStateBlock = stateChanged;
        }
        if (number)
        {
            [self.delegate BlueToothIsConnected:number];
        }
        if (self.connectStateBlock)
        {
            self.connectStateBlock(number);
        }
    }];
}


- (void)openActuralHeart
{
    [self changeHeartStateWithState:YES Block:nil];
}

#pragma mark -- 收到离线数据
- (void)recieveOffLineDataWithBlock:(void(^)(SportModelMap *dic))offLineDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] recieveOffLineDataWithBlock:^(SportModelMap *model) {
        [weakSelf saveOffLineDataWithModel:model];
        if (offLineDataBlock) {
            offLineDataBlock(model);
        }
    }];
}

- (void)setBlocks
{
    //    WeakSelf;
    [[PZBlueToothManager sharedInstance] recieveOffLineDataWithBlock:^(SportModelMap *dic) {
        //        [weakSelf saveOffLineDataWithModel:dic];
    }];
    [[PZBlueToothManager sharedInstance] checkHeartRateAlarmWithHeartRateAlarmBlock:^(int state, int max, int min) {
    }];//查询心率预警区间
    [[PZBlueToothManager sharedInstance] checkHRVDataWithHRVBlock:^(int number, NSArray *array) {
    }];//疲劳
    [[PZBlueToothManager sharedInstance] checkBloodPressure:^(BloodPressureModel *bloodPre) {
    }];
    [[PZBlueToothManager sharedInstance] checkVerSionWithBlock:^(int firstHardVersion, int secondHardVersion, int softVersion, int blueToothVersion) {
    }];
    [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
    }];//当天心率总数。8个包
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
    }];//查询睡眠数据 144 ，每个值表示十分钟
    [[PZBlueToothManager sharedInstance] checkHourStepsAndCostsWithBlock:^(NSArray *steps, NSArray *costs) {
    }];//查询每小时数据
    [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
    }];
    [[PZBlueToothManager sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
    }];//检查电量
    [[PZBlueToothManager sharedInstance] recieveHistoryAllDayDataWithBlock:^(DayOverViewDataModel *model) {
    }];
    [[PZBlueToothManager sharedInstance] recieveHistoryHourDataWithBlock:^(NSArray *steps, NSArray *costs, int timeSeconds) {
    }];
    [[PZBlueToothManager sharedInstance] recieveHistorySleepDataWithBlock:^(SleepModel *model) {
    }];
    [[PZBlueToothManager sharedInstance] recieveHistoryHeartRateWithBlock:^(int timeSeconds, int index, NSArray *array) {
        
    }];
    [[PZBlueToothManager sharedInstance] recieveHistoryHRVDataWithBlock:^(int number, NSArray *array) {
    }];
    //页面配置的接收值
    //    [[CositeaBlueTooth sharedInstance] supportPageManager:^(uint number) {
    //        //adaLog(@"number  === %u",number);
    //    }];
    //    [[PZBlueToothManager sharedInstance] setBindDate];
    //    [[CositeaBlueTooth sharedInstance] recieveOffLineDataWithBlock:^(SportModel *model) {
    //        [weakSelf saveOffLineDataWithModel:model];
    //    }];
    //    [[CositeaBlueTooth sharedInstance] recieveHistoryAllDayDataWithBlock:^(DayOverViewDataModel *model) {
    //        [weakSelf saveAllDayDataWithModel:model];
    //    }];
    //    [[CositeaBlueTooth sharedInstance] recieveHistoryHourDataWithBlock:^(NSArray *steps, NSArray *costs, int timeSeconds) {
    //        [weakSelf saveHourDataWithTimeSeconds:timeSeconds Steps:steps Costs:costs];
    //    }];
    //    [[CositeaBlueTooth sharedInstance] recieveHistorySleepDataWithBlock:^(SleepModel *model) {
    //        [weakSelf saveSleepDataWithSleepModel:model];
    //    }];
    //    [[CositeaBlueTooth sharedInstance] recieveHistoryHeartRateWithBlock:^(int timeSeconds, int index, NSArray *array) {
    //        [weakSelf saveHeartRateArrayWithTiemIndex:timeSeconds + index HeartRateArray:array];
    //    }];
    //    [[CositeaBlueTooth sharedInstance] recieveHistoryHRVDataWithBlock:^(int number, NSArray *array) {
    //        [weakSelf saveHRVDataWithTimeSeconds:number HRVDataArray:array];
    //    }];
    
}

/**
 *  收到全天概览历史数据，可以接收后保存或上传服务器
 *
 *  @param historyAllDayDataBlock 返回DayOverViewDataModel
 */
- (void)recieveHistoryAllDayDataWithBlock:(allDayModelBlock)historyAllDayDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] recieveHistoryAllDayDataWithBlock:^(DayOverViewDataModel *model) {
        [weakSelf saveAllDayDataWithModel:model];
        //adaLog(@"historyAllDayDataBlock - %@",historyAllDayDataBlock);
        if (historyAllDayDataBlock)
        {
            historyAllDayDataBlock(model);
        }
    }];
}
/**
 接收历史每小时计步和消耗
 
 @param historyHourDataBlock 同查询当天计步和消耗
 */
- (void)recieveHistoryHourDataWithBlock:(doubleArrayBlock)historyHourDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] recieveHistoryHourDataWithBlock:^(NSArray *steps, NSArray *costs, int timeSeconds) {
        [weakSelf saveHourDataWithTimeSeconds:timeSeconds Steps:steps Costs:costs];
        if (historyHourDataBlock)
        {
            historyHourDataBlock(steps,costs,timeSeconds);
        }
    }];
    
}
/**
 接收历史睡眠数据
 
 @param historySleepDataBlock 同查询当天睡眠数据
 */
- (void)recieveHistorySleepDataWithBlock:(sleepModelBlock)historySleepDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] recieveHistorySleepDataWithBlock:^(SleepModel *model) {
        [weakSelf saveSleepDataWithSleepModel:model];
        if (historySleepDataBlock)
        {
            historySleepDataBlock(model);
        }
    }];
    
}
/**
 接收历史心率
 
 @param historyHeartRateBlock 格式同查询当天心率
 */
- (void)recieveHistoryHeartRateWithBlock:(doubleIntArrayBlock)historyHeartRateBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] recieveHistoryHeartRateWithBlock:^(int timeSeconds, int index, NSArray *array) {
        [weakSelf saveHeartRateArrayWithTiemIndex:timeSeconds + index HeartRateArray:array];
        if (historyHeartRateBlock) {
            historyHeartRateBlock(timeSeconds,index,array);
        }
    }];
    
}
/**
 接收历史HRV数据
 
 @param historyHRVDataBlock 格式同查询当天历史数据
 */
- (void)recieveHistoryHRVDataWithBlock:(intArrayBlock)historyHRVDataBlock
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] recieveHistoryHRVDataWithBlock:^(int number, NSArray *array) {
        [weakSelf saveHRVDataWithTimeSeconds:number HRVDataArray:array];
        if (historyHRVDataBlock) {
            historyHRVDataBlock(number,array);
        }
    }];
}
#pragma mark -- 内部方法


- (void)sendUserInfoToBind{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
//    adaLog(@"pz 身高体重 = %@",dic);
    if (dic) {
        int height = [[dic objectForKey:@"height"]intValue];
        int weight = [[dic objectForKey:@"weight"]intValue];
        int male = [[dic objectForKey:@"gender"] intValue];
        int age = 25;
        NSDateFormatter *formates = [[NSDateFormatter alloc] init];
        [formates setDateFormat:@"yyyy-MM-dd"];
        NSDate *assignDate = [formates dateFromString:[dic objectForKey:@"birthdate"]];
        int time = fabs([assignDate timeIntervalSinceNow]);
        age = trunc(time/(60*60*24))/365;
        
        [[CositeaBlueTooth sharedInstance] sendUserInfoToBindWithHeight:height weight:weight male:male - 1 age:age];
    }
}

- (void)setBindDatepz
{
    int unitState = kState;
    [[CositeaBlueTooth sharedInstance] setUnitStateWithState:unitState == 2];
    
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    [[CositeaBlueTooth sharedInstance] setBindDateStateWithState:!hasAMPM];
    
    //    [[CositeaBlueTooth sharedInstance] checkHeartRateAlarmWithHeartRateAlarmBlock:^(int state, int max, int min) {
    //        NSArray *heartAlarmArray = @[[NSNumber numberWithInt:min],[NSNumber numberWithInt:max]];
    //        [[NSUserDefaults standardUserDefaults] setObject:heartAlarmArray forKey:kHeartRateAlarm];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }];
    
    //    [[CositeaBlueTooth sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
    //        [HCHCommonManager getInstance].curPower = number;
    //    }];
    
    [self sendUserInfoToBind];
}

- (NSMutableArray *)actualHeartArray
{
    if (!_actualHeartArray)
    {
        _actualHeartArray = [[NSMutableArray alloc] init];
    }
    return _actualHeartArray;
}

- (void)changeHeartStateWithState:(BOOL)isON Block:(intBlock)block
{
    if (block)
    {
        self.heartRateBlock = block;
    }
    if (isON)
    {
        [[CositeaBlueTooth sharedInstance] openActualHeartRateWithBolock:^(int number) {
            if (_heartRateBlock) {
                _heartRateBlock(number);
            }
            if (self.actualHeartArray.count < 60)
            {
                [self.actualHeartArray addObject:intToString(number)];
            }else if (self.actualHeartArray.count == 60)
            {
                [self.actualHeartArray removeObjectAtIndex:0];
                [self.actualHeartArray addObject:intToString(number)];
                float count = 0;
                float totalHeart = 0;
                for (int i = 0; i < self.actualHeartArray.count; i ++)
                {
                    int timeSeconds = [[ADASaveDefaluts objectForKey:@"heartWarningTime"] intValue];
                    NSDate *date = [NSDate date];
                    NSTimeInterval nowTime = date.timeIntervalSince1970;
                    if (nowTime - timeSeconds < 1800)
                    {
                        return ;
                    }
                    
                    NSString *string = self.actualHeartArray[i];
                    int heart = [string intValue];
                    if (heart != 0)
                    {
                        count += 1;
                        totalHeart += heart;
                    }if (count == 0)
                    {
                        [self.actualHeartArray removeAllObjects];
                    }else
                    {
                        float avgHeart = totalHeart/count;
                        if (avgHeart < 40 || avgHeart > 180) {
                            [[TimingUploadData sharedInstance] updataHeartRateWarning];
                        }
                    }
                }
            }else
            {
                [self.actualHeartArray removeAllObjects];
            }
        }];
    }else
    {
        [[CositeaBlueTooth sharedInstance] closeActualHeartRate];
    }
}

- (void)checkHeartRateAlarmWithHeartRateAlarmBlock:(heartRateAlarmBlock)heartRateAlarmBlock
{
    [[CositeaBlueTooth sharedInstance] checkHeartRateAlarmWithHeartRateAlarmBlock:^(int state, int max, int min) {
        NSArray *heartAlarmArray = @[[NSNumber numberWithInt:min],[NSNumber numberWithInt:max]];
        [[NSUserDefaults standardUserDefaults] setObject:heartAlarmArray forKey:kHeartRateAlarm];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (heartRateAlarmBlock)
        {
            heartRateAlarmBlock(state,max,min);
        }
    }];
}
//      获取血压的数据
- (void)checkBloodPressure:(void(^)(BloodPressureModel  *bloodPre))bloodPressure
{
    WeakSelf;
    [[CositeaBlueTooth sharedInstance] getBloodPressure:^(BloodPressureModel *bloodPre) {
        
        [weakSelf saveBloodPressureWithModel:bloodPre];
        if (bloodPressure) {
            bloodPressure(bloodPre);
        }
    }];
}
#pragma mark -- 保存数据具体方法

- (void)saveHRVDataWithTimeSeconds:(int)timeSeconds HRVDataArray:(NSArray *)HRVDataArray
{
    NSData *pilaoData = [NSKeyedArchiver archivedDataWithRootObject:HRVDataArray];
    NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:timeSeconds];
    if (dic)
    {
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [mutDic setValue:pilaoData forKey:kPilaoData];
        [mutDic setValue:@"0" forKey:ISUP];
        //        if( [AllTool isNeedAmendMacAddress:mutDic[DEVICEID]])
        //        {
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        [mutDic setValue:deviceId forKey:DEVICEID];
        //        }
        //        if (!mutDic[DEVICEID]) {
        //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //            if (!deviceId) {
        //                deviceId =  DEFAULTDEVICEID;
        //            }
        //            [mutDic setValue:deviceId forKey:DEVICEID];
        //        }
        [[CoreDataManage shareInstance] updataDayDetailTableWithDic:mutDic];
    }
    else
    {
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                                     [NSNumber numberWithInt:timeSeconds],DataTime_HCH,
                                     pilaoData,kPilaoData,
                                     @"0",ISUP,
                                     deviceType,DEVICETYPE,
                                     deviceId,DEVICEID,
                                     nil];
        [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];
    }
}

- (void)saveHeartRateArrayWithTiemIndex:(int)timeIndex HeartRateArray:(NSArray *)array
{
    
    //    //adaLog(@"chakan -- %d",timeIndex);
    //    for (NSString * heart in array) {
    //        //adaLog(@"chakan -- %d",[heart intValue]);
    //    }
    NSData *heartData = [NSKeyedArchiver archivedDataWithRootObject:array];
    NSDictionary *dic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:timeIndex];
    if (dic)
    {
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [mutDic setObject:heartData forKey:HeartRate_ActualData_HCH];
        [mutDic setValue:@"0" forKey:ISUP];
        //        if( [AllTool isNeedAmendMacAddress:mutDic[DEVICEID]])
        //        {
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        [mutDic setValue:deviceId forKey:DEVICEID];
        //        }
        //        if (!mutDic[DEVICEID]) {
        //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //            if (!deviceId) {
        //                deviceId =  DEFAULTDEVICEID;
        //            }
        //            [mutDic setValue:deviceId forKey:DEVICEID];
        //        }
        [[CoreDataManage shareInstance] updataHeartRateWithDic:mutDic];
    }
    else
    {
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //        if (!deviceId) {
        //            deviceId =  DEFAULTDEVICEID;
        //        }
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:
               [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
               [NSNumber numberWithInt:timeIndex],DataTime_HCH,
               heartData,HeartRate_ActualData_HCH,
               @"0",ISUP,
               deviceType,DEVICETYPE,
               deviceId,DEVICEID,nil];
        [[CoreDataManage shareInstance] CreatHeartRateWithDic:dic];
    }
}
//144 ，每个值表示十分钟
- (void)saveSleepDataWithSleepModel:(SleepModel *)model
{
    NSData *sleepData = [NSKeyedArchiver archivedDataWithRootObject:model.sleepArary];
    NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:model.timeSeconds];
    if (dic)
    {
        NSMutableDictionary * multDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [multDic setValue:sleepData forKey:DataValue_SleepData_HCH];
        [multDic setValue:[NSNumber numberWithInt:model.lightSleepTime] forKey:kLightSleep];
        [multDic setValue:[NSNumber numberWithInt:model.deepSleepTime] forKey:kDeepSleep];
        [multDic setValue:[NSNumber numberWithInt:model.awakeSleepTime] forKey:kAwakeSleep];
        [multDic setValue:@"0" forKey:ISUP];
        //        if( [AllTool isNeedAmendMacAddress:multDic[DEVICEID]])
        //        {
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        [multDic setValue:deviceId forKey:DEVICEID];
        //        }
        //        if (!multDic[DEVICEID]) {
        //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //            if (!deviceId) {
        //                deviceId =  DEFAULTDEVICEID;
        //            }
        //            [multDic setValue:deviceId forKey:DEVICEID];
        //        }
        [[CoreDataManage shareInstance] updataDayDetailTableWithDic:multDic];
    }
    else
    {
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //        if (!deviceId) {
        //            deviceId =  DEFAULTDEVICEID;
        //        }
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:
               sleepData,DataValue_SleepData_HCH,
               [NSNumber numberWithInt:model.timeSeconds],DataTime_HCH,
               [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
               [NSNumber numberWithInt:model.lightSleepTime],kLightSleep,
               [NSNumber numberWithInt:model.deepSleepTime],kDeepSleep,
               [NSNumber numberWithInt:model.awakeSleepTime],kAwakeSleep,
               @"0",ISUP,
               deviceId,DEVICEID,
               deviceType,DEVICETYPE,nil];
        [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dic];
    }
}
- (void)saveOffLineDataWithModel:(SportModelMap *)sport
{
    //如果有这个开始
    if (sport.fromTime)
    {
        NSArray * array = [[SQLdataManger getInstance] queryHeartRateDataWithFromtime:sport.fromTime];
        if (array.count>0)
        {
            adaLog(@"在线运动  有重复的值");
            return;
        }
    }
    else
    {
        return;
    }
    NSMutableDictionary *dictionary  =[NSMutableDictionary dictionary];
    [dictionary setValue:sport.sportID forKey:@"sportID"];
    [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
    //    [dictionary setValue:[AllTool compatibleDeviceType:sport.sportType] forKey:@"sportType"];
    [dictionary setValue:sport.sportType forKey:@"sportType"];
    [dictionary setValue:sport.sportDate forKey:@"sportDate"];
    [dictionary setValue:sport.fromTime forKey:@"fromTime"];
    [dictionary setValue:sport.toTime forKey:@"toTime"];
    [dictionary setValue:sport.stepNumber forKey:@"stepNumber"];
    [dictionary setValue:sport.kcalNumber forKey:@"kcalNumber"];
    [dictionary setValue:[self setupTitle:sport.sportType] forKey:@"sportName"];
    NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    NSString *deviceId = [AllTool amendMacAddressGetAddress];
    
    [dictionary setValue:deviceId forKey:DEVICEID];
    [dictionary setValue:deviceType forKey:DEVICETYPE];
    [dictionary setValue:@"0" forKey:ISUP];
    [dictionary setValue:@"0" forKey:HAVETRAIL];
    
    int beginTime = (sport.startTimeSeconds - sport.timeSeconds)/60.0;    //开始分钟
    int endTime = (sport.stopTimeSeconds - sport.timeSeconds)/60.0;       //结束分钟
    
    if(beginTime>1439)
    { return;}
    if(endTime>1439)
    {
        endTime = 1439;
    }
    NSMutableArray *heartArray2 = [NSMutableArray array];
    if (beginTime < endTime)
    {
        //        int beginBao = beginTime/180 + 1;
        int stopBao = endTime/180.0 + 1;
        int number = [[TimeCallManager getInstance] getIntervalOneMinWith:sport.startTimeSeconds andEndTime:sport.stopTimeSeconds];
        //1～8 8个包，一个包3小时
        if (stopBao>8) {
            stopBao = 8;
        }
        for (int i = 1; i<= stopBao; i++)
        {
            //adaLog(@"第几个包  i= %d",i);
            
            NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:sport.timeSeconds +i];
            NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
            if (array&&array.count !=0)
            {
                [heartArray2 addObjectsFromArray:array];
            }
            else
            {
                for (int aa = 0 ; aa < 180; aa ++)
                {
                    [heartArray2 addObject:@0];
                }
            }
        }
        if (beginTime+number<=heartArray2.count){
            NSLog(@"离线心率溢出");
            return;
            NSAssert(beginTime+number<=heartArray2.count, @"离线心率溢出");
        }
        if (beginTime>=heartArray2.count) {
            return;
        }
        if(beginTime+number > heartArray2.count)
        {
            number = (int)heartArray2.count - beginTime;
        }
        NSArray *cunArray = [heartArray2 subarrayWithRange:NSMakeRange(beginTime, number)];
        ////adaLog(@"截取前  - - - %@",heartArray2);
        //adaLog(@"离线 存储 心率的cunArray  - - - %@",cunArray);
        NSData *heartData = [NSKeyedArchiver archivedDataWithRootObject:cunArray];
        [dictionary setValue:heartData forKey:@"heartRate"];
    }
    
    //adaLog(@"dictionary - - %@",dictionary);
    [[SQLdataManger getInstance] insertDataWithColumns:dictionary toTableName:@"ONLINESPORT"];
    
}
-(NSString *)setupTitle:(NSString *)type
{
    NSString * titleString = [NSString string];
    int intType = [type intValue];
    if(intType>100)
    {
        intType = intType - 100;
    }
    switch (intType) {
        case 0:
            titleString = NSLocalizedString(@"徒步", nil);;
            break;
        case 1:
            titleString = NSLocalizedString(@"跑步", nil);;
            break;
        case 2:
            titleString = NSLocalizedString(@"登山", nil);;
            break;
        case 3:
            titleString = NSLocalizedString(@"球类", nil);;
            break;
        case 4:
            titleString = NSLocalizedString(@"力量训练", nil);;
            break;
        case 5:
            titleString = NSLocalizedString(@"有氧训练", nil);;
            break;
        case 6:
            titleString = NSLocalizedString(@"自定义", nil);;
            break;
        default:
            titleString = NSLocalizedString(@"徒步", nil);;
            break;
    }
    
    return  titleString;
}
//- (void)hehesaveOffLineDataWithModel:(OffLineDataModel *)model
//{
//    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:model.timeSeconds];
//    if (dic) {
//        testEventCount = [[dic objectForKey:TotalDayEventCount_DayData_HCH] intValue] + 1;
//        [dic setValue:[NSNumber numberWithInt:testEventCount] forKey:TotalDayEventCount_DayData_HCH];
//        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
//    }else {
//        testEventCount = 1;
//        dic = [NSDictionary dictionaryWithObjectsAndKeys:
//               [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
//               [NSNumber numberWithInt:model.timeSeconds],  DataTime_HCH,
//               [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
//               [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
//               [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
//               [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
//               [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan ], Steps_PlanTo_HCH,
//               [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
//               [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
//               [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
//               [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
//               [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
//               [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
//               [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:model.timeSeconds]], TotalDataWeekIndex_DayData_HCH,
//               nil];
//        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
//    }
//
//    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
//                             [NSNumber numberWithInt:model.timeSeconds],  DataTime_HCH,
//                             [NSNumber numberWithInt:model.startSeconds], StartTime_ActualData_HCH,
//                             [NSNumber numberWithInt:model.stopSeconds], StopTime_ActualData_HCH,
//                             [NSNumber numberWithInt:testEventCount],SportEventIndex_HCH,
//                             [NSNumber numberWithInt:-1], SportType_ActualData_HCH,
//                             [NSNumber numberWithInt:model.steps],StepCount_ActualData_HCH,
//                             [NSNumber numberWithInt:model.costs],CostCount_ActualData_HCH,
//                             nil];
//    [[SQLdataManger getInstance] insertSignalDataToTable:ACtualTimeData_Table withData:dataDic];
//    if (self.offLineDataBlock)
//    {
//        self.offLineDataBlock(dic);
//    }
//}

//保存包头为 0 ，全天的数据
- (NSDictionary *)saveAllDayDataWithModel:(DayOverViewDataModel *)model
{
    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:model.timeSeconds];
    NSString *deviceId = [AllTool amendMacAddressGetAddress];
    NSString *macAddress =deviceId;
    //    NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
    //    if (!macAddress)
    //    {
    //        macAddress = DEFAULTDEVICEID;
    //    }
    if (dic)
    {
        [dic setValue:intToString(model.steps) forKey:TotalSteps_DayData_HCH];
        [dic setValue:intToString(model.meters) forKey:TotalMeters_DayData_HCH];
        [dic setValue:intToString(model.costs) forKey:TotalCosts_DayData_HCH];
        [dic setValue:intToString([HCHCommonManager getInstance].sleepPlan)  forKey:Sleep_PlanTo_HCH];
        [dic setValue:intToString([HCHCommonManager getInstance].stepsPlan) forKey:Steps_PlanTo_HCH];
        [dic setValue:intToString(model.activityTime) forKey:TotalDataActivityTime_DayData_HCH];
        [dic setValue:intToString(model.calmTime) forKey:TotalDataCalmTime_DayData_HCH];
        [dic setValue:intToString(model.activityCosts) forKey:kTotalDayActivityCost];
        [dic setValue:intToString(model.calmCosts) forKey:kTotalDayCalmCost];
        
        [dic setValue:[NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]] forKey:DEVICETYPE];
        [dic setValue:macAddress forKey:DEVICEID];
        [dic setValue:@"0" forKey:ISUP];
    }
    else
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
               intToString(model.timeSeconds),  DataTime_HCH,
               intToString(model.steps), TotalSteps_DayData_HCH,
               intToString(model.meters), TotalMeters_DayData_HCH,
               intToString(model.costs), TotalCosts_DayData_HCH,
               intToString([HCHCommonManager getInstance].sleepPlan) , Sleep_PlanTo_HCH,
               intToString([HCHCommonManager getInstance].stepsPlan), Steps_PlanTo_HCH,
               intToString(model.activityTime),TotalDataActivityTime_DayData_HCH,
               intToString(model.calmTime),TotalDataCalmTime_DayData_HCH,
               intToString(model.activityCosts),kTotalDayActivityCost,
               intToString(model.calmCosts),kTotalDayCalmCost,
               [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
               macAddress,DEVICEID,
               @"0",ISUP,
               nil];
    }
    [[SQLdataManger getInstance] insertSignalDataToTable:DayTotalData_Table withData:dic];
    return dic;
}

- (void)saveHourDataWithTimeSeconds:(int)timeSeconds Steps:(NSArray *)steps Costs:(NSArray *)costs
{
    NSData *stepData = [NSKeyedArchiver archivedDataWithRootObject:steps];
    NSData *costsData = [NSKeyedArchiver archivedDataWithRootObject:costs];
    
    NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:timeSeconds];
    if (dic)
    {
        NSMutableDictionary *dictionnaray = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [dictionnaray setValue:stepData forKey:kDayStepsData];
        [dictionnaray setValue:costsData forKey:kDayCostsData];
        [dictionnaray setValue:@"0" forKey:ISUP];
        
        //        if( [AllTool isNeedAmendMacAddress:dictionnaray[DEVICEID]])
        //        {
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        [dictionnaray setValue:deviceId forKey:DEVICEID];
        //        }
        //        if (!dictionnaray[DEVICEID]) {
        //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //            if (!deviceId) {
        //                deviceId =  DEFAULTDEVICEID;
        //            }
        //            [dictionnaray setValue:deviceId forKey:DEVICEID];
        //        }
        [[CoreDataManage shareInstance] updataDayDetailTableWithDic:dictionnaray];
        
    }
    else
    {
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //        if (!deviceId) {
        //            deviceId =  DEFAULTDEVICEID;
        //        }
        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
                                     [NSNumber numberWithInt:timeSeconds],DataTime_HCH,
                                     stepData,kDayStepsData,
                                     costsData,kDayCostsData,
                                     @"0",ISUP,
                                     deviceId,DEVICEID,
                                     deviceType,DEVICETYPE,nil];
        [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];
    }
}
-(void)saveBloodPressureWithModel:(BloodPressureModel *)bloodPre
{
    if(bloodPre)
    {
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *deviceId = [AllTool amendMacAddressGetAddress];
        //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //        if (!deviceId) {
        //            deviceId =  DEFAULTDEVICEID;
        //        }
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              bloodPre.BloodPressureID,BloodPressureID_def,
                              [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                              bloodPre.BloodPressureDate,BloodPressureDate_def,
                              bloodPre.StartTime,StartTime_def,
                              bloodPre.systolicPressure,systolicPressure_def,
                              bloodPre.diastolicPressure,diastolicPressure_def,
                              bloodPre.heartRate,heartRateNumber_def,
                              bloodPre.SPO2,SPO2_def,
                              bloodPre.HRV,HRV_def,
                              @"0",ISUP,
                              deviceId,DEVICEID,
                              deviceType,DEVICETYPE,
                              nil];
        ////adaLog(@"dic -- %@",dic);
        [[SQLdataManger  getInstance] insertSignalDataToTable:BloodPressure_Table withData:dic];
        
        //NSDate *date = [[NSDate alloc]init];
        //NSString * currentDateStr = [date GetCurrentDateStr];
        
        //  NSArray * bloodArray  = [[SQLdataManger getInstance] queryBloodPressureWithDay:currentDateStr];
    }
}
@end
