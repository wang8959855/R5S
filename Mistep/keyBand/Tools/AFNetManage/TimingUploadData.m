 // ONLINESPORT //在线运动的表
//BloodPressure_Table = 10,//血压数据表
//DayTotalData_Table,//天数据总览
//DayDetail //天数据 详细
//HeartData


//PersonInfo_Table,//个人信息

/*
 上传下载的功能码
 9003  成功的标记
 9004  没有数据
 9001  为登录
 */

#import "TimingUploadData.h"
#import "SQLdataManger.h"
#import "CoreDataManage.h"
#import "BloodPressureModel.h"
#import "SleepTool.h"


@interface TimingUploadData()<CLLocationManagerDelegate>

@property (nonatomic,assign)int curSeconed;
@property (nonatomic,strong)NSTimer *timingUploadDataTime;//定时器  给服务器上传数据
@property (nonatomic,strong)NSMutableArray *sportArray;
@property (nonatomic,assign)int dayTotalData;//天总数据
@property (nonatomic,assign)int daySportDetail;//一天的每小时步数
@property (nonatomic,assign)int dayHeartDetail;//
//@property (nonatomic,assign)int dayHeartDetailPack;//
@property (nonatomic,assign)int dayOnlineSport;//
@property (nonatomic,assign)int bloodPressure;//一天的血压
@property (nonatomic,assign)int sleepDetail;//一天的睡眠
//@property (nonatomic,assign)int dayHeartDetailPackCurrentDay;//当天心率

//上传出错，就重复三次
@property (nonatomic,assign)int UpdataDayTotalDataTimes;//天总
@property (nonatomic,assign)int UpdataDaySportDetailTimes1;//详细
@property (nonatomic,assign)int UpdataDaySportDetailTimes2;//详细
@property (nonatomic,assign)int UpdataDaySportDetailTimes3;//详细
@property (nonatomic,assign)int UpdataDaySportDetailTimes4;//详细
@property (nonatomic,assign)int UpdataDayHeartDetailTimes;//心率数据
@property (nonatomic,assign)int UpdataDayOnlinesportTimes;//在线运动
@property (nonatomic,assign)int UpdataBloodPressureTimes;//血压数据
@property (nonatomic,assign)int UpdataSleepTimes;//睡眠数据

//当天的数据上传
@property (nonatomic,assign)int UpdataDayTotalDataCurrentDayTimes;
@property (nonatomic,assign)int UpdataDaySportDetailCurrentDayTimes1;
@property (nonatomic,assign)int UpdataDaySportDetailCurrentDayTimes2;
@property (nonatomic,assign)int UpdataDaySportDetailCurrentDayTimes3;
@property (nonatomic,assign)int UpdataDaySportDetailCurrentDayTimes4;
@property (nonatomic,assign)int UpdataDayHeartDetailCurrentDayTimes;
@property (nonatomic,assign)int UpdataDayOnlinesportCurrentDayTimes;
@property (nonatomic,assign)int UpdataBloodPressureCurrentDayTimes;
@property (nonatomic,assign)int yueSleepTrendTimes;
@property (nonatomic,assign)int yueStepTrendTimes;
@property (nonatomic, strong) CLLocationManager  *locationManager;

//删除运动的属性
@property (nonatomic,assign)int deleteSportProperty;

//当天的数据
@property (nonatomic, strong) NSMutableArray *sleepArray;
@property (nonatomic, assign) int sleepTime;

@end

@implementation TimingUploadData

+ (TimingUploadData *)sharedInstance
{
    static TimingUploadData * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance startTask];//开始执行更新的任务
    });
    return instance;
}

//开始执行更新的任务
-(void)startTask
{
    
    //ecg
    [[CositeaBlueTooth sharedInstance] readyReceive:YES];
    
    [[CositeaBlueTooth sharedInstance] getECGData:^(NSString *ecg, NSString *SPO2, NSString *AF,NSString *rate) {
        NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",UPLOADECG,TOKEN];
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:uploadUrl ParametersDictionary:@{@"userid":USERID,@"ecg":ecg,@"rate":rate,@"fangchan":AF,@"xueyang":SPO2,@"apptime":[[TimeCallManager getInstance] getCurrentAreaTime]} Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
         {
             
             //                 adaLog(@"  - - - - -开始登录返回");
             
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
             
             if (error)
             {
                 [[UIApplication sharedApplication].keyWindow makeCenterToast:@"网络连接错误"];
             }
             else
             {
                 int code = [[responseObject objectForKey:@"code"] intValue];
                 NSString *message = [responseObject objectForKey:@"message"];
                 if (code == 0) {
                     //成功
                     [[UIApplication sharedApplication].keyWindow makeCenterToast:@"上传成功"];
                     
                 }else{
                     [[UIApplication sharedApplication].keyWindow makeCenterToast:message];
                 }
             }
         }];
    }];
    
    
    WeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [weakSelf initProperty];
        [weakSelf timingUploadData];
        // 在主线程回调
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            complection(ret);
        //        });
    });
}

- (void)initProperty
{
    _dayTotalData = 0;
    _daySportDetail = 0;
    _dayHeartDetail = 0;
    _dayOnlineSport = 0;
    _bloodPressure = 0;
    _UpdataDayTotalDataTimes=0;
    _UpdataDaySportDetailTimes1 = 0;
    _UpdataDaySportDetailTimes2 = 0;
    _UpdataDaySportDetailTimes3 = 0;
    _UpdataDaySportDetailTimes4 = 0;
    _UpdataDayOnlinesportTimes = 0;
    _UpdataBloodPressureTimes = 0;
    
    _UpdataDayTotalDataCurrentDayTimes = 0;
    _UpdataDaySportDetailCurrentDayTimes1 = 0;
    _UpdataDaySportDetailCurrentDayTimes2 = 0;
    _UpdataDaySportDetailCurrentDayTimes3 = 0;
    _UpdataDaySportDetailCurrentDayTimes4 = 0;
    _UpdataDayHeartDetailCurrentDayTimes = 0;
    _UpdataDayOnlinesportCurrentDayTimes = 0;
    _UpdataBloodPressureCurrentDayTimes = 0;
    _deleteSportProperty = 0;
    _yueSleepTrendTimes = 0;
    _yueStepTrendTimes = 0;
    _sleepDetail = 0;
}
#pragma mark -- 定时上传数据
/**
 1.两种状态，1）connected（以手环数据为准）2）disconnect（以服务器数据为准）
 2.上传的过程 1）10分钟后上传一次 2）以后定时30分钟上传一次。上传数据的标记符 isUp
 3.手环断开，都是请求服务器数据刷新界面
 */
-(void)timingUploadData
{
    //    if (kHCH.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN||kHCH.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi)
    //    {
    if(kHCH.iphoneNetworkStatus>0){
        //以后五分钟后就开始 上传数据。  300     180
        WeakSelf;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(360.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf timingUploadDataStart];
//        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf timingUploadDataStart];
        });
    }
}

-(void)timingUploadDataStart
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000;
    [self.locationManager startUpdatingLocation];
    
    //    //adaLog(@"123");
    //请求一次。
    [self timingUploadDataTimeAction];
    
    self.timingUploadDataTime = [NSTimer  scheduledTimerWithTimeInterval:60 target:self selector:@selector(detailDayDateCurrent) userInfo:nil repeats:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    NSString *locationString = [NSString stringWithFormat:@"%.6f,%.6f",currentLocation.coordinate.longitude,currentLocation.coordinate.latitude];
    [ADASaveDefaluts setObject:locationString forKey:[NSString stringWithFormat:@"%@location",kHCH.UserAcount]];
    
    [manager stopUpdatingLocation];
    self.locationManager = nil;
}


-(void)timingUploadDataTimeAction
{
    BOOL isDown  = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    
    //    if (kHCH.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN||kHCH.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi)
    //    {
    if(kHCH.iphoneNetworkStatus>0){
        //定时请求   请求一次。
        
        [self detailDayData];
        [self uploadMinuteStep];
    }
}

-(void)checkDataUpdata
{
    [self UpdataDayTotalData];//天总数据
}

//每分钟上传的数据
- (void)detailDayDateCurrent{
    BOOL isDown  = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    if(kHCH.iphoneNetworkStatus>0){
//        [self UpdataDayHeartDetailCurrentDay];// 当天心率
//        [self UpdataDaySportDetailCurrentDay];// 当天运动情况
//        [self UpdateSleepDataCurrent];//睡眠数据
        [self uploadCurrentDayData];
        [self uploadMinuteStep];
    }
    
}

-(void)detailDayData //天总数据搞定后就上传其他数据；
{
    [self UpdataDaySportDetail]; //二、全天运动情况上传
//    [self UpdataDayHeartDetail]; // 全天心率
//    [self UpdateSleepData];
    //[self UpdataDayOnlinesport]; // 在线运动
    //[self UpdataBloodPressure];  //血压数据
    
}

//睡眠数据
- (void)UpdateSleepData{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    if (self.sleepDetail>=7)
    {
        _UpdataSleepTimes = 0;
        return;
    }
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:(self.curSeconed-KONEDAYSECONDS*self.sleepDetail) isUp:@"1"];
    NSString *startTime = [self calcSleepStartAndEndTimeWithCurrentTime:self.curSeconed-KONEDAYSECONDS*self.sleepDetail][0];
    NSString *endTime = [self calcSleepStartAndEndTimeWithCurrentTime:self.curSeconed-KONEDAYSECONDS*self.sleepDetail][1];
    if (dayDetailDictionary)
    {
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        NSArray *sleepArray = [NSArray array];
        if (!((NSNull *)dayDetailDictionary[DataValue_SleepData_HCH] == [NSNull null]))
        {
            sleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[DataValue_SleepData_HCH]];
        }
        else
        {
            sleepArray = [AllTool makeSleepArray];
        }
        NSString *sleepString =[AllTool arrayToString2:[self deleteSleepArrayZero:self.sleepArray]];
        __block  NSDictionary *paramSleep = @{@"userId":USERID,@"Date":timeStr,@"Sq_List":sleepString,@"StartTime":startTime,@"EndTime":endTime};
        NSString *url = [NSString stringWithFormat:@"%@/%@",SLEEPUPDATE,TOKEN];
        __block  NSString *deviceId = dayDetailDictionary[@"deviceID"];
        if (deviceId) {
            
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        __block  NSString *deviceType = dayDetailDictionary[@"deviceType"];
        WeakSelf
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramSleep Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            //adaLog(@"code = %d, msd = %@",code,responseObject[@"msg"]);
            if (code == 0)
            {
                ++weakSelf.sleepDetail;
//                [weakSelf  performSelector:@selector(UpdateSleepData) withObject:nil afterDelay:1];
                [weakSelf UpdateSleepData];
                
                if (!dayDetailDictionary[DEVICETYPE]) {
                    [dayDetailDictionary setValue:deviceType forKey:DEVICETYPE];
                }
                if (!dayDetailDictionary[DEVICEID]) {
                    [dayDetailDictionary setValue:deviceId forKey:DEVICEID];
                }
                [dayDetailDictionary setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataDayDetailTableWithDic:dayDetailDictionary];
                [[CoreDataManage shareInstance] updataDayDetailDAYALLWithDic:dayDetailDictionary];
            }else{
                ++_UpdataSleepTimes;
                if (_UpdataSleepTimes>3)
                {
                    _UpdataSleepTimes=0;
                    return ;
                }
                else
                {
                    --weakSelf.sleepDetail;
                }
                [weakSelf  performSelector:@selector(UpdateSleepData) withObject:nil afterDelay:0.1];
            }
        }];
        
    }
}

//一、天总数据 - DayTotal
-(void)UpdataDayTotalData
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    //adaLog(@"self.dayTotalData - %d",self.dayTotalData);
    if (self.dayTotalData>=7)
    {
//        self.dayTotalData = 0;
        _UpdataDayTotalDataTimes = 0;
        [self detailDayData];  //天总数据搞定后就上传其他数据；
        return;
    }
    NSDictionary * dict = [[SQLdataManger getInstance] getTotalDataWithToUp:(self.curSeconed-KONEDAYSECONDS*self.dayTotalData) isUp:@"1"];
    if (dict)
    {
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dict[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        __block  NSString *deviceType = dict[@"deviceType"];
        if (!deviceType) {
            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        }
        __block  NSString *deviceId = dict[@"deviceID"];
        if (deviceId) {
            
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        int sleepPlan = [dict[Sleep_PlanTo_HCH] intValue]/60;
        
        NSString *locationString = [ADASaveDefaluts objectForKey:[NSString stringWithFormat:@"%@location",kHCH.UserAcount]];
        __block  NSDictionary *param;
        if (locationString && locationString.length > 0)
        {
                 param = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"allData.step":dict[TotalSteps_DayData_HCH],@"allData.calorie":dict[TotalCosts_DayData_HCH],@"allData.mileage":dict[TotalMeters_DayData_HCH],@"allData.activityTimes":dict[TotalDataActivityTime_DayData_HCH],@"allData.activityCalor":dict[kTotalDayActivityCost],@"allData.sitTimes":dict[TotalDataCalmTime_DayData_HCH],@"allData.sitCalor":dict[kTotalDayCalmCost],@"allData.stepTarget":dict[Steps_PlanTo_HCH],@"allData.sleepTarget":intToString(sleepPlan),@"allData.GPS":locationString};
        }else
        {
                   param = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"allData.step":dict[TotalSteps_DayData_HCH],@"allData.calorie":dict[TotalCosts_DayData_HCH],@"allData.mileage":dict[TotalMeters_DayData_HCH],@"allData.activityTimes":dict[TotalDataActivityTime_DayData_HCH],@"allData.activityCalor":dict[kTotalDayActivityCost],@"allData.sitTimes":dict[TotalDataCalmTime_DayData_HCH],@"allData.sitCalor":dict[kTotalDayCalmCost],@"allData.stepTarget":dict[Steps_PlanTo_HCH],@"allData.sleepTarget":intToString(sleepPlan),@"allData.GPS":@""};
        }

        
        //adaLog(@"param - %@",param);
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_AllData" ParametersDictionary:param Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            //adaLog(@"code-%d, DayTotalData -- %@",code,responseObject[@"msg"]);
            if (code == 9003)
            {
                //adaLog(@"一、天总数据 - DayTotal - -上传数据成功");
                if (!deviceType) {
                    deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
                }
                __block  NSString *deviceId = dict[@"deviceID"];
                if (deviceId) {
                    deviceId = [AllTool macToMacString:deviceId];
                }
                else
                { deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
                }
                [dict setValue:@"1" forKey:ISUP];
                [[SQLdataManger getInstance] replaceDataWithColumns:dict toTableName:@"DayTotalData_Table"];
                
                //adaLog(@"msg -- %@",responseObject[@"msg"]);
                [weakSelf  performSelector:@selector(UpdataDayTotalData) withObject:nil afterDelay:0.1];
            }
            else if(code == 9001)
            {
                ++_UpdataDayTotalDataTimes;
                if (_UpdataDayTotalDataTimes > 3)
                {
                    _UpdataDayTotalDataTimes = 0;
                    return ;
                }
                else
                {
                    --weakSelf.dayTotalData;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataDayTotalData) withObject:nil afterDelay:0.1];
            }
            else
            {
                ++_UpdataDayTotalDataTimes;
                if (_UpdataDayTotalDataTimes > 3)
                {
                    _UpdataDayTotalDataTimes = 0;
                    return ;
                }
                else
                {
                    --weakSelf.dayTotalData;
                }
                [weakSelf  performSelector:@selector(UpdataDayTotalData) withObject:nil afterDelay:0.1];
                //adaLog(@"else");
            }
        } ];
    }
    else
    {
        [self  performSelector:@selector(UpdataDayTotalData) withObject:nil afterDelay:0.1];
        //adaLog(@"dict - - else");
    }
    ++self.dayTotalData;
}
#pragma mark     - - - 删除运动事件

//-(void)deleteSportDataWithDictionary:(NSMutableDictionary *)dict
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:dict Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        int code = [responseObject[@"code"] intValue];
//        //adaLog(@"code-%d,offlineData - msg -- %@",code,responseObject[@"msg"]);
//        if (code == 9003)
//        {
//            //adaLog(@" deleteSport -  %@",responseObject);
//            _deleteSportProperty  = 0;
//        }
//        else if(code == 9001)
//        {
//            if (_deleteSportProperty>3) {
//                _deleteSportProperty = 0;
//                return ;
//            }
//            ++_deleteSportProperty;
//            [CacheLogin logining];
//            [weakSelf  performSelector:@selector(deleteSportDataWithDictionary:) withObject:dict afterDelay:0.1];
//        }
//        else if(code == 9004)
//        {
//            if (_deleteSportProperty>3) {
//                _deleteSportProperty = 0;
//                return ;
//            }
//            ++_deleteSportProperty;
//            [weakSelf  performSelector:@selector(deleteSportDataWithDictionary:) withObject:dict afterDelay:0.1];
//        }
//        else
//        {
//            if (_deleteSportProperty>3) {
//                _deleteSportProperty = 0;
//                return ;
//            }
//            ++_deleteSportProperty;
//            [weakSelf  performSelector:@selector(deleteSportDataWithDictionary:) withObject:dict afterDelay:0.1];
//        }
//
//    } ];
//}
//二、全天运动情况上传 - dayDetail
-(void)UpdataDaySportDetail
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    if (self.daySportDetail>=7)
    {
//        self.daySportDetail = 0;
        _UpdataDaySportDetailTimes1 = 0;
        _UpdataDaySportDetailTimes2 = 0;
        _UpdataDaySportDetailTimes3 = 0;
        _UpdataDaySportDetailTimes4 = 0;
        [self UpdataDayHeartDetail]; // 全天心率
        return;
    }
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:(self.curSeconed-KONEDAYSECONDS*self.daySportDetail) isUp:@"1"];
    NSDictionary * dict = [[SQLdataManger getInstance] getTotalDataWithToUp:(self.curSeconed-KONEDAYSECONDS*self.daySportDetail) isUp:@"1"];
    
    if (dayDetailDictionary)
    {
        if (dict) {
            //日期
            NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
            NSArray *stepsArray = [NSArray array];//@[@"0"];
            if (!((NSNull *)dayDetailDictionary[kDayStepsData] == [NSNull null]))
            {stepsArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[kDayStepsData]];
            }
            //        else{stepsArray = @[@"0"];}
            
            NSString *stepString = [AllTool arrayToStringSport:stepsArray];
            
            NSArray *costsArray =  [NSArray array];//@[@"0"];
            if (!((NSNull *)dayDetailDictionary[kDayCostsData] == [NSNull null])) {
                costsArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[kDayCostsData]];
            }
            //        else{costsArray = @[@"0"];}
            NSString *costsString =[AllTool arrayToStringSport:costsArray];
            NSString *cal = dict[@"TotalCosts_DayData"];
            NSString *step = dict[@"TotalSteps_DayData"];
            NSString *distance = [NSString stringWithFormat:@"%f",[dict[@"TotalMeters_DayData"] doubleValue]/1000.0];
            
            __block  NSDictionary *paramSport = @{@"date":timeStr,@"userId":USERID,@"Step":step,@"Cal":cal,@"Distance":distance,@"Step_List":stepString,@"Cal_List":costsString,@"apptime":[[TimeCallManager getInstance] getCurrentAreaTime]};
            //adaLog(@"paramStep - %@",paramStep);
            //adaLog(@"paramCosts - %@",paramCosts);
            //adaLog(@"paramPilao - %@",paramPilao);
            //adaLog(@"paramSleep - %@",paramSleep);
            NSString *url = [NSString stringWithFormat:@"%@/%@",SPORTUPDATE,TOKEN];
            WeakSelf;
            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramSport Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
                int code = [responseObject[@"code"] intValue];
                //adaLog(@"code = %d, msd = %@",code,responseObject[@"msg"]);
                if (code == 0) {
                    NSLog(@"运动数据上传成功");
                    [weakSelf  performSelector:@selector(UpdataDaySportDetail) withObject:nil afterDelay:0.1];
                }else
                {
                    if (_UpdataDaySportDetailTimes1>3)
                    {
                        _UpdataDaySportDetailTimes1=0;
                        return ;
                    }else{
                        --weakSelf.daySportDetail;
                    }
                    [weakSelf  performSelector:@selector(UpdataDaySportDetail) withObject:nil afterDelay:1];
                }
            } ];
        }
    }
    else
    {
        [self  performSelector:@selector(UpdataDaySportDetail) withObject:nil afterDelay:1];
    }
    ++self.daySportDetail;
}

- (void)updataHeartRateWarning
{
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:kHCH.todayTimeSeconds isUp:@"1"];
    
    NSString *deviceType = dayDetailDictionary[@"deviceType"];
    NSString *deviceId = dayDetailDictionary[@"deviceID"];
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
    
    NSString *locationString = [ADASaveDefaluts objectForKey:[NSString stringWithFormat:@"%@location",kHCH.UserAcount]];
    
    __block  NSDictionary *HeartWarningParam;
    if (locationString && locationString.length > 0) {
        HeartWarningParam = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"warning_time",@"uploadData":locationString};
    }else
    {
        return;
    }
    adaLog(@"%@",HeartWarningParam);
    
    WeakSelf;
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:HeartWarningParam Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
        int code = [responseObject[@"code"] intValue];
        //adaLog(@"code = %d, msd = %@",code,responseObject[@"msg"]);
        if (code == 9003)
        {
            NSDate *date = [NSDate date];
            [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%.0f",date.timeIntervalSince1970] forKey:@"heartWarningTime"];
            
        }
        else if(code == 9001)
        {
            [CacheLogin logining];
            [weakSelf  performSelector:@selector(updataHeartRateWarning) withObject:nil afterDelay:0.3];
        }
        else
        {
//            [weakSelf  performSelector:@selector(updataHeartRateWarning) withObject:nil afterDelay:0.3];
        }
    } ];

}

- (void)updataPilaoWarning
{
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:kHCH.todayTimeSeconds isUp:@"1"];
    
    NSString *deviceType = dayDetailDictionary[@"deviceType"];
    NSString *deviceId = dayDetailDictionary[@"deviceID"];
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];

    NSString *locationString = [ADASaveDefaluts objectForKey:[NSString stringWithFormat:@"%@location",kHCH.UserAcount]];
    
    __block  NSDictionary *pilaoWarningParam;
    if (locationString && locationString.length > 0) {
        pilaoWarningParam = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"fatigue_time",@"uploadData":locationString};
    }else
    {
        return;
    }
        adaLog(@"%@",pilaoWarningParam);
        
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:pilaoWarningParam Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            //adaLog(@"code = %d, msd = %@",code,responseObject[@"msg"]);
            if (code == 9003)
            {
                [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%d",kHCH.todayTimeSeconds] forKey:@"pilaoWarningTime"];
                
            }
            else if(code == 9001)
            {

//                [CacheLogin logining];
//                [weakSelf  performSelector:@selector(updataPilaoWarning) withObject:nil afterDelay:0.3];
            }
            else
            {
//                [weakSelf  performSelector:@selector(updataPilaoWarning) withObject:nil afterDelay:0.3];
            }
        } ];
}
// 三、全天心率 - heartRate
-(void)UpdataDayHeartDetail
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    if (self.dayHeartDetail>=7)
    {
        self.dayHeartDetail = 0;
        _UpdataDayHeartDetailTimes = 0;
        [self UpdateSleepData];  //运动数据
        return;
    }
    int seconedTemp = (self.curSeconed-KONEDAYSECONDS*self.dayHeartDetail);
    //adaLog(@"seconedTemp - %d",seconedTemp);
    NSDictionary *dayHeartDetailDict1 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+1 isUp:@"1"];
    NSDictionary *dayHeartDetailDict2 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+2 isUp:@"1"];
    NSDictionary *dayHeartDetailDict3 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+3 isUp:@"1"];
    NSDictionary *dayHeartDetailDict4 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+4 isUp:@"1"];
    NSDictionary *dayHeartDetailDict5 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+5 isUp:@"1"];
    NSDictionary *dayHeartDetailDict6 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+6 isUp:@"1"];
    NSDictionary *dayHeartDetailDict7 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+7 isUp:@"1"];
    NSDictionary *dayHeartDetailDict8 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:seconedTemp+8 isUp:@"1"];
    if (dayHeartDetailDict1||dayHeartDetailDict2||dayHeartDetailDict3||dayHeartDetailDict4||dayHeartDetailDict5||dayHeartDetailDict6||dayHeartDetailDict7||dayHeartDetailDict8)
    {
        NSDictionary *dayHeartDetailDict1 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+1];
        NSDictionary *dayHeartDetailDict2 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+2];
        NSDictionary *dayHeartDetailDict3 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+3];
        NSDictionary *dayHeartDetailDict4 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+4];
        NSDictionary *dayHeartDetailDict5 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+5];
        NSDictionary *dayHeartDetailDict6 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+6];
        NSDictionary *dayHeartDetailDict7 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+7];
        NSDictionary *dayHeartDetailDict8 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconedTemp+8];
        
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayHeartDetailDict1[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        NSArray *heartArray1 = [NSArray array];
        if(dayHeartDetailDict1)
        {
            if (!((NSNull *)dayHeartDetailDict1[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray1 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict1[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray1 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray1 = [AllTool makeArrayEight];
        }
        
        NSArray *heartArray2 = [NSArray array];
        if(dayHeartDetailDict2)
        {
            if (!((NSNull *)dayHeartDetailDict2[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict2[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray2 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray2 = [AllTool makeArrayEight];
        }
        NSArray *heartArray3 = [NSArray array];
        if(dayHeartDetailDict3)
        {
            if (!((NSNull *)dayHeartDetailDict3[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray3 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict3[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray3 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray3 = [AllTool makeArrayEight];
        }
        NSArray *heartArray4 = [NSArray array];
        if(dayHeartDetailDict4)
        {
            if (!((NSNull *)dayHeartDetailDict4[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray4 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict4[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray4 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray4 = [AllTool makeArrayEight];
        }
        NSArray *heartArray5 = [NSArray array];
        if(dayHeartDetailDict5)
        {
            if (!((NSNull *)dayHeartDetailDict5[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray5 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict5[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray5 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray5 = [AllTool makeArrayEight];
        }
        NSArray *heartArray6 = [NSArray array];
        if(dayHeartDetailDict6)
        {
            if (!((NSNull *)dayHeartDetailDict6[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray6 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict6[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray6 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray6 = [AllTool makeArrayEight];
        }
        NSArray *heartArray7 = [NSArray array];
        if(dayHeartDetailDict7)
        {
            if (!((NSNull *)dayHeartDetailDict7[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray7 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict7[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray7 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray7 = [AllTool makeArrayEight];
        }
        NSArray *heartArray8 = [NSArray array];
        if(dayHeartDetailDict8)
        {
            if (!((NSNull *)dayHeartDetailDict8[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray8 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict8[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray8 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray8 = [AllTool makeArrayEight];
        }
        NSString *heartString1 =[AllTool arrayToStringHeart:heartArray1];
        NSString *heartString2 =[AllTool arrayToStringHeart:heartArray2];
        NSString *heartString3 =[AllTool arrayToStringHeart:heartArray3];
        NSString *heartString4 =[AllTool arrayToStringHeart:heartArray4];
        NSString *heartString5 =[AllTool arrayToStringHeart:heartArray5];
        NSString *heartString6 =[AllTool arrayToStringHeart:heartArray6];
        NSString *heartString7 =[AllTool arrayToStringHeart:heartArray7];
        NSString *heartString8 =[AllTool arrayToStringHeart:heartArray8];
        NSMutableString * upDataHeart =[NSMutableString string];
        [upDataHeart appendString:heartString1];
        [upDataHeart appendString:heartString2];
        [upDataHeart appendString:heartString3];
        [upDataHeart appendString:heartString4];
        [upDataHeart appendString:heartString5];
        [upDataHeart appendString:heartString6];
        [upDataHeart appendString:heartString7];
        [upDataHeart appendString:heartString8];
        __block  NSString *deviceType = dayHeartDetailDict1[@"deviceType"];
        if (!deviceType) {
            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        }
        __block  NSString *deviceId = dayHeartDetailDict1[DEVICEID];
        if (deviceId) {
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        NSString *time = [NSString stringWithFormat:@"%f",[[TimeCallManager getInstance] getNowSecond]];
        __block  NSDictionary *paramHeart = @{@"userId":USERID,@"time":time,@"date":timeStr,@"hrData":upDataHeart};
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",HEARTRATEUPDATE,TOKEN];
        
        //adaLog(@"HeartDetail - %@",paramHeart);
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramHeart Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            adaLog(@"上传心率的  code = %d",code);
            if (code == 0)
            {
                //adaLog(@"三、全天心率 - heartRate - 上传数据成功");
                //adaLog(@"heartRate - msg -- %@",responseObject[@"msg"]);
                
                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict1];
                if (!dict1[@"deviceType"]) {
                    [dict1 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict1[DEVICEID]) {
                    [dict1 setValue:deviceId forKey:DEVICEID];
                }
                [dict1 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict1];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict1];
                
                NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict2];
                if (!dict2[@"deviceType"]) {
                    [dict2 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict2[DEVICEID]) {
                    [dict2 setValue:deviceId forKey:DEVICEID];
                }
                [dict2 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict2];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict2];
                
                NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict3];
                if (!dict3[@"deviceType"]) {
                    [dict3 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict3[DEVICEID]) {
                    [dict3 setValue:deviceId forKey:DEVICEID];
                }
                [dict3 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict3];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict3];
                NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict4];
                if (!dict4[@"deviceType"]) {
                    [dict4 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict4[DEVICEID]) {
                    [dict4 setValue:deviceId forKey:DEVICEID];
                }
                [dict4 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict4];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict4];
                NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict5];
                if (!dict5[@"deviceType"]) {
                    [dict5 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict5[DEVICEID]) {
                    [dict5 setValue:deviceId forKey:DEVICEID];
                }
                [dict5 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict5];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict5];
                
                NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict6];
                if (!dict6[@"deviceType"]) {
                    [dict6 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict6[DEVICEID]) {
                    [dict6 setValue:deviceId forKey:DEVICEID];
                }
                [dict6 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict6];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict6];
                NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict7];
                if (!dict7[@"deviceType"]) {
                    [dict7 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict7[DEVICEID]) {
                    [dict7 setValue:deviceId forKey:DEVICEID];
                }
                [dict7 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict7];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict7];
                NSMutableDictionary *dict8 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict8];
                if (!dict8[@"deviceType"]) {
                    [dict8 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict8[DEVICEID]) {
                    [dict8 setValue:deviceId forKey:DEVICEID];
                }
                [dict8 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict8];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict8];
                
                [weakSelf  performSelector:@selector(UpdataDayHeartDetail) withObject:nil afterDelay:0.1];
            }
            else if(code == 9001)
            {
                ++_UpdataDayHeartDetailTimes;
                if (_UpdataDayHeartDetailTimes>3)
                {
                    _UpdataDayHeartDetailTimes=0;
                    return ;
                }
                else
                {
                    --self.dayHeartDetail;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataDayHeartDetail) withObject:nil afterDelay:0.1];
            }
            else
            {
                ++_UpdataDayHeartDetailTimes;
                if (_UpdataDayHeartDetailTimes>3)
                {
                    _UpdataDayHeartDetailTimes=0;
                    return ;
                }
                else
                {
                    --self.dayHeartDetail;
                }
                [weakSelf  performSelector:@selector(UpdataDayHeartDetail) withObject:nil afterDelay:0.1];
            }
            
        } ];
    }
    else
    {
        [self  performSelector:@selector(UpdataDayHeartDetail) withObject:nil afterDelay:0.1];
        //adaLog(@"dictionary -- else");
    }
    ++self.dayHeartDetail;
}
// 四、在线运动 - onlinesport
-(void)UpdataDayOnlinesport
{
    //    BOOL isDown = [self checkIsCanDown];
    //    if (!isDown) {
    //        return;
    //    }
    //    //在线运动。。
    //    if (self.dayOnlineSport>=7)
    //    {
    //        self.dayOnlineSport = 0;
    //        _UpdataDayOnlinesportTimes = 0;
    //        return;
    //    }
    //    //日期
    //    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:(self.curSeconed-KONEDAYSECONDS*self.dayOnlineSport) andFormat:@"yyyy-MM-dd"];
    //    __block   NSArray * OnlineSportArray = [[SQLdataManger getInstance] queryHeartRateDataWithDateToUp:timeStr isUp:@"1"];
    //
    //
    //    if (OnlineSportArray.count>0)
    //    {
    //        __block   NSArray * OnlineSportArray = [[SQLdataManger getInstance] queryHeartRateDataWithDate:timeStr];
    //
    //        NSMutableDictionary *sportArraydictionary = [NSMutableDictionary dictionary];
    //
    //        for (SportModel *sportModel in OnlineSportArray)
    //        {
    //            NSDictionary *dictionary = [sportModel modelToUpdataDictionary];
    //            //adaLog(@"dictionary - %@",dictionary);
    //            [sportArraydictionary addEntriesFromDictionary:dictionary];
    //        }
    //
    //
    //        SportModel *model = OnlineSportArray[0];
    //        __block  NSString *deviceType = model.deviceType;
    //        if (!deviceType) {
    //            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    //        }
    //        __block  NSString *deviceId = model.deviceId;
    //        if (deviceId) {
    //
    //            deviceId = [AllTool macToMacString:deviceId];
    //        }
    //        else
    //        {
    //            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
    //        }
    //        NSString* str = [AllTool dictionaryToJson:sportArraydictionary];
    //        __block  NSDictionary *paramHeart = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"offlineData",@"uploadData":str};
    //
    //        //adaLog(@"paramHeart-%@",paramHeart);
    //        WeakSelf;
    //        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramHeart Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
    //            int code = [responseObject[@"code"] intValue];
    //            //adaLog(@"code-%d,offlineData - msg -- %@",code,responseObject[@"msg"]);
    //            if (code == 9003)
    //            {
    //                //adaLog(@"四、在线运动 - onlinesport - 上传数据成功");
    //                [[SQLdataManger getInstance] insertMostSport:OnlineSportArray];
    //                //adaLog(@"offlineData - msg -- %@",responseObject[@"msg"]);
    //
    //            }
    //            else if(code == 9001)
    //            {
    //                --weakSelf.dayOnlineSport;
    //                [CacheLogin logining];
    //                [weakSelf  performSelector:@selector(UpdataDayOnlinesport) withObject:nil afterDelay:0.1];
    //            }
    //            else
    //            {
    //                ++_UpdataDayOnlinesportTimes;
    //                if (_UpdataDayOnlinesportTimes>3) {
    //                    _UpdataDayOnlinesportTimes = 0;
    //                } else {
    //                    --weakSelf.dayOnlineSport;
    //                }
    //                [weakSelf  performSelector:@selector(UpdataDayOnlinesport) withObject:nil afterDelay:0.1];
    //            }
    //
    //        } ];
    //    }
    //    else
    //    {
    //        [self  performSelector:@selector(UpdataDayOnlinesport) withObject:nil afterDelay:0.1];
    //        //adaLog(@"dictionary -- else");
    //    }
    //    ++self.dayOnlineSport;
}
// 五、血压数据 - bloodPressure
-(void)UpdataBloodPressure
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    if (self.bloodPressure>=7)
    {
        self.bloodPressure = 0;
        _UpdataBloodPressureTimes = 0;
        return;
    }
    //日期
//    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:(self.curSeconed-KONEDAYSECONDS*self.bloodPressure) andFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:(self.curSeconed) andFormat:@"yyyy-MM-dd"];
    __block   NSArray * BloodPressureArray = [[SQLdataManger getInstance] queryBloodPressureWithDayToUp:timeStr isUp:@"1"];
    
    if (BloodPressureArray.count>0)
    {
        __block   NSArray * BloodPressureArray = [[SQLdataManger getInstance] queryBloodPressureWithDay:timeStr];
        NSMutableDictionary *dic = [BloodPressureModel arrayToDictionary:BloodPressureArray];
        NSDictionary *dict = [BloodPressureArray lastObject];
        __block  NSString *deviceType = dict[@"deviceType"];
        if (!deviceType) {
            deviceType = DEVICETYPE;
        }
        __block  NSString *deviceId = dict[@"deviceID"];
        if (deviceId) {
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        NSString *BloodStr = [AllTool dictionaryToJson:dic];
        __block  NSDictionary *paramBlood = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"bloodPressure",@"uploadData":BloodStr};
        //adaLog(@"paramBlood - %@",paramBlood);
        
        
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramBlood Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            if (code == 9003)
            {
                adaLog(@"五、血压数据 - bloodPressure  - 上传数据成功");
                
                [[SQLdataManger getInstance] insertMostBlood:BloodPressureArray];
                [weakSelf  performSelector:@selector(UpdataDayTotalData) withObject:nil afterDelay:0.1];
            }
            else if(code == 9001)
            {
                ++_UpdataBloodPressureTimes;
                if (_UpdataBloodPressureTimes>3) {
                    _UpdataBloodPressureTimes = 0;
                    return ;
                } else {
                    --weakSelf.bloodPressure;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataBloodPressure) withObject:nil afterDelay:0.1];
            }
            else
            {
                ++_UpdataBloodPressureTimes;
                if (_UpdataBloodPressureTimes>3) {
                    _UpdataBloodPressureTimes = 0;
                    return ;
                } else {
                    --weakSelf.bloodPressure;
                }
                
                [weakSelf  performSelector:@selector(UpdataBloodPressure) withObject:nil afterDelay:0.1];
            }
        } ];
    }
    else
    {
        [self  performSelector:@selector(UpdataBloodPressure) withObject:nil afterDelay:0.1];
        //adaLog(@"dictionary -- else");
    }
    ++self.bloodPressure;
}



#pragma     -  - - mark  -- 以下是上传当天数据
/**
 *
 *上传当前天的数据
 *
 **/
-(void)CurrentDayUpData
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000;
    [self.locationManager startUpdatingLocation];
    
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    //关闭定时器
    //    if(self.timingUploadDataTime){
    //        [self.timingUploadDataTime setFireDate:[NSDate distantFuture]];
    //    }
    [self performSelector:@selector(UpdataDayTotalDataCurrentDay) withObject:nil afterDelay:6.0];
    //    [self performSelector:@selector(updataCurrentDayTimeOut) withObject:nil afterDelay:5.0f];
    
}
-(void)updataCurrentDayTimeOut
{
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(CurrentDaydetailDayData) object:nil];
    //    [self CurrentDaydetailDayData];
}
-(void)CurrentDaydetailDayData //天总数据搞定后就上传其他数据；
{
    //    BOOL isDown = [self checkIsCanDown];
    //    if (!isDown) {
    //        return;
    //    }
    //    [self UpdataDaySportDetailCurrentDay]; //二、全天运动情况上传
    //    [self UpdataDayHeartDetailCurrentDay]; // 全天心率
    //    [self UpdataDayOnlinesportCurrentDay]; // 在线运动
    //    [self UpdataBloodPressureCurrentDay];  //血压数据
    //    //开启定时器
    //    if(self.timingUploadDataTime){
    //        [self.timingUploadDataTime setFireDate:[NSDate distantPast]];
    //    }
}
//一、天总数据 - DayTotal - CurrentDay
-(void)UpdataDayTotalDataCurrentDay
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    NSDictionary * dict = [[SQLdataManger getInstance] getTotalDataWithToUp:self.curSeconed isUp:@"1"];
    if (dict)
    {
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dict[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        __block  NSString *deviceType = dict[@"deviceType"];
        if (!deviceType) {
            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        }
        __block  NSString *deviceId = dict[@"deviceID"];
        if (deviceId) {
            
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        int sleepPlan = [dict[Sleep_PlanTo_HCH] intValue]/60;
        NSString *locationString = [ADASaveDefaluts objectForKey:[NSString stringWithFormat:@"%@location",kHCH.UserAcount]];
        __block  NSDictionary *param;
        if (locationString && locationString.length > 0)
        {
                   param = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"allData.step":dict[TotalSteps_DayData_HCH],@"allData.calorie":dict[TotalCosts_DayData_HCH],@"allData.mileage":dict[TotalMeters_DayData_HCH],@"allData.activityTimes":dict[TotalDataActivityTime_DayData_HCH],@"allData.activityCalor":dict[kTotalDayActivityCost],@"allData.sitTimes":dict[TotalDataCalmTime_DayData_HCH],@"allData.sitCalor":dict[kTotalDayCalmCost],@"allData.stepTarget":dict[Steps_PlanTo_HCH],@"allData.sleepTarget":intToString(sleepPlan),@"allData.GPS":locationString};
        }else
        {
               param = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"allData.step":dict[TotalSteps_DayData_HCH],@"allData.calorie":dict[TotalCosts_DayData_HCH],@"allData.mileage":dict[TotalMeters_DayData_HCH],@"allData.activityTimes":dict[TotalDataActivityTime_DayData_HCH],@"allData.activityCalor":dict[kTotalDayActivityCost],@"allData.sitTimes":dict[TotalDataCalmTime_DayData_HCH],@"allData.sitCalor":dict[kTotalDayCalmCost],@"allData.stepTarget":dict[Steps_PlanTo_HCH],@"allData.sleepTarget":intToString(sleepPlan),@"allData.GPS":@""};
        }

        
        //adaLog(@"param - %@",param);
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_AllData" ParametersDictionary:param Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updataCurrentDayTimeOut) object:nil];
            int code = [responseObject[@"code"] intValue];
            //adaLog(@"code-%d, DayTotalData -- %@",code,responseObject[@"msg"]);
            if (code == 9003)
            {
                adaLog(@"%@",responseObject[@"msg"]);
                //adaLog(@"一、天总数据 - 当天 - DayTotal - -上传数据成功");
                if (!deviceType) {
                    deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
                }
                __block  NSString *deviceId = dict[@"deviceID"];
                if (deviceId) {
                    deviceId = [AllTool macToMacString:deviceId];
                }
                else
                { deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
                }
                [dict setValue:@"1" forKey:ISUP];
                [[SQLdataManger getInstance] replaceDataWithColumns:dict toTableName:@"DayTotalData_Table"];
                //adaLog(@"msg -- %@",responseObject[@"msg"]);
                //[weakSelf CurrentDaydetailDayData];
                _UpdataDayTotalDataCurrentDayTimes = 0;
            }
            else if(code == 9001)
            {
                ++_UpdataDayTotalDataCurrentDayTimes;
                if (_UpdataDayTotalDataCurrentDayTimes>3) {
                    _UpdataDayTotalDataCurrentDayTimes = 0;
                    return ;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataDayTotalDataCurrentDay) withObject:nil afterDelay:0.1];
            }
            else
            {
                ++_UpdataDayTotalDataCurrentDayTimes;
                if (_UpdataDayTotalDataCurrentDayTimes>3) {
                    _UpdataDayTotalDataCurrentDayTimes = 0;
                    return ;
                }else {
                    [weakSelf  performSelector:@selector(UpdataDayTotalDataCurrentDay) withObject:nil afterDelay:0.1];
                    //adaLog(@"else");
                }
            }
        } ];
    }
    else
    {
        //adaLog(@"dict - - else");
    }
}

//二、全天运动情况上传 - dayDetail - CurrentDay
-(void)UpdataDaySportDetailCurrentDay
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:self.curSeconed isUp:@"1"];
    
    if (dayDetailDictionary)
    {
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        NSArray *stepsArray = [NSArray array];//@[@"0"];
        if (!((NSNull *)dayDetailDictionary[kDayStepsData] == [NSNull null]))
        {
            stepsArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[kDayStepsData]];
        }
        NSString *stepString =[AllTool arrayToString:stepsArray];
        
        NSArray *costsArray = [NSArray array];//@[@"0"];
        if (!((NSNull *)dayDetailDictionary[kDayCostsData] == [NSNull null]))
        {
            costsArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[kDayCostsData]];
        }
        NSString *costsString =[AllTool arrayToString:costsArray];
        
        NSArray *pilaoArray = [NSArray array];//@[@"0"];
        if (!((NSNull *)dayDetailDictionary[kPilaoData] == [NSNull null]))
        {
            pilaoArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[kPilaoData]];
        }
        NSString *pilaoString =[AllTool arrayToString:pilaoArray];
        
        NSArray *sleepArray = [NSArray array];
        if (!((NSNull *)dayDetailDictionary[DataValue_SleepData_HCH] == [NSNull null]))
        {
            sleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[DataValue_SleepData_HCH]];
        }
        else
        {
            sleepArray = [AllTool makeSleepArray];
        }
        NSString *sleepString =[AllTool arrayToString:sleepArray];

        __block  NSString *deviceType = dayDetailDictionary[@"deviceType"];
        if (!deviceType) {
            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        }
        __block  NSString *deviceId = dayDetailDictionary[@"deviceID"];
        if (deviceId) {
            
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        __block  NSDictionary *paramStep = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"stepDay",@"uploadData":stepString};
        __block  NSDictionary *paramCosts = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"calorieDay",@"uploadData":costsString};
        __block  NSDictionary *paramPilao = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"hrv",@"uploadData":pilaoString};
        __block  NSDictionary *paramSleep = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"sleepData",@"uploadData":sleepString};
        //adaLog(@"paramStep - %@",paramStep);
        //adaLog(@"paramCosts - %@",paramCosts);
        //adaLog(@"paramPilao - %@",paramPilao);
        //adaLog(@"paramSleep - %@",paramSleep);
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramStep Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            //adaLog(@"stepDay - code = %d, msd = %@",code,responseObject[@"msg"]);
            if (code == 9003)
            {
                //adaLog(@"stepDay - msg -- %@",responseObject[@"msg"]);
                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramCosts Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
                    int code = [responseObject[@"code"] intValue];
                    //adaLog(@"calorieDay code = %d, msd = %@",code,responseObject[@"msg"]);
                    if (code == 9003)
                    {
                        //adaLog(@"calorieDay - msg -- %@",responseObject[@"msg"]);
                        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramPilao Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
                            int code = [responseObject[@"code"] intValue];
                            //adaLog(@"hrv code = %d, msd = %@",code,responseObject[@"msg"]);
                            if (code == 9003)
                            {
                                //adaLog(@"hrv - msg -- %@",responseObject[@"msg"]);
                                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramSleep Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
                                    int code = [responseObject[@"code"] intValue];
                                    //adaLog(@"sleepData code = %d, msd = %@",code,responseObject[@"msg"]);
                                    if (code == 9003)
                                    {
                                        //adaLog(@"sleepData - msg -- %@",responseObject[@"msg"]);
                                        //adaLog(@"二、全天运动情况上传  - 当天 - - dayDetail -上传数据成功");
                                        
                                        if (!dayDetailDictionary[DEVICETYPE]) {
                                            [dayDetailDictionary setValue:deviceType forKey:DEVICETYPE];
                                        }
                                        if (!dayDetailDictionary[DEVICEID]) {
                                            [dayDetailDictionary setValue:deviceId forKey:DEVICEID];
                                        }
                                        [dayDetailDictionary setValue:@"1" forKey:ISUP];
                                        //[[CoreDataManage shareInstance] updataDayDetailTableWithDic:dayDetailDictionary];
                                        [[CoreDataManage shareInstance] updataDayDetailDAYALLWithDic:dayDetailDictionary];
                                        
                                        _UpdataDaySportDetailCurrentDayTimes1 = 0;
                                        _UpdataDaySportDetailCurrentDayTimes2 = 0;
                                        _UpdataDaySportDetailCurrentDayTimes3 = 0;
                                        _UpdataDaySportDetailCurrentDayTimes4 = 0;
                                    }
                                    else if(code == 9001)
                                    {
                                        ++_UpdataDaySportDetailCurrentDayTimes4;
                                        if (_UpdataDaySportDetailCurrentDayTimes4>3) {
                                            _UpdataDaySportDetailCurrentDayTimes4=0;
                                            return ;
                                        }
                                        [CacheLogin logining];
                                        [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                                    }
                                    else
                                    {
                                        ++_UpdataDaySportDetailCurrentDayTimes4;
                                        if (_UpdataDaySportDetailCurrentDayTimes4>3) {
                                            _UpdataDaySportDetailCurrentDayTimes4=0;
                                            return ;
                                        } else {
                                            
                                            [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                                        }
                                    }
                                } ];
                            }
                            else if(code == 9001)
                            {
                                ++_UpdataDaySportDetailCurrentDayTimes3;
                                if (_UpdataDaySportDetailCurrentDayTimes3>3) {
                                    _UpdataDaySportDetailCurrentDayTimes3=0;
                                    return ;
                                }
                                [CacheLogin logining];
                                [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                            }
                            else
                            {
                                ++_UpdataDaySportDetailCurrentDayTimes3;
                                if (_UpdataDaySportDetailCurrentDayTimes3>3) {
                                    _UpdataDaySportDetailCurrentDayTimes3=0;
                                    return ;
                                } else {
                                    [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                                }
                            }
                        } ];
                    }
                    else if(code == 9001)
                    {
                        ++_UpdataDaySportDetailCurrentDayTimes2;
                        if (_UpdataDaySportDetailCurrentDayTimes2>3) {
                            _UpdataDaySportDetailCurrentDayTimes2=0;
                            return ;
                        }
                        [CacheLogin logining];
                        [self  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                    }
                    else
                    {
                        ++_UpdataDaySportDetailCurrentDayTimes2;
                        if (_UpdataDaySportDetailCurrentDayTimes2>3) {
                            _UpdataDaySportDetailCurrentDayTimes2=0;
                            return ;
                        } else {
                            [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                        }
                    }
                } ];
            }
            else if(code == 9001)
            {
                ++_UpdataDaySportDetailCurrentDayTimes1;
                if (_UpdataDaySportDetailCurrentDayTimes1>3) {
                    _UpdataDaySportDetailCurrentDayTimes1 =0;
                    return ;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                
            }
            else
            {
                ++_UpdataDaySportDetailCurrentDayTimes1;
                if (_UpdataDaySportDetailCurrentDayTimes1>3) {
                    _UpdataDaySportDetailCurrentDayTimes1 =0;
                    return ;
                } else {
                    [weakSelf  performSelector:@selector(UpdataDaySportDetailCurrentDay) withObject:nil afterDelay:0.1];
                }
            }
        } ];
    }
    else
    {
        //adaLog(@"dictionary -- else");
    }
}

// 三、全天心率 - heartRate - CurrentDay
-(void)UpdataDayHeartDetailCurrentDay
{
    
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:self.curSeconed isUp:@"1"];
    if (dayDetailDictionary)
    {
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        NSArray *sleepArray = [NSArray array];
        if (!((NSNull *)dayDetailDictionary[DataValue_SleepData_HCH] == [NSNull null]))
        {
            sleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[DataValue_SleepData_HCH]];
        }
        else
        {
            sleepArray = [AllTool makeSleepArray];
        }
        NSString *sleepString =[AllTool arrayToString2:sleepArray];
    }
    
    NSDictionary *dayHeartDetailDict1 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+1 isUp:@"1"];
    NSDictionary *dayHeartDetailDict2 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+2 isUp:@"1"];
    NSDictionary *dayHeartDetailDict3 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+3 isUp:@"1"];
    NSDictionary *dayHeartDetailDict4 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+4 isUp:@"1"];
    NSDictionary *dayHeartDetailDict5 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+5 isUp:@"1"];
    NSDictionary *dayHeartDetailDict6 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+6 isUp:@"1"];
    NSDictionary *dayHeartDetailDict7 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+7 isUp:@"1"];
    NSDictionary *dayHeartDetailDict8 = [[CoreDataManage shareInstance] querHeartDataWithTimeSecondsToUp:self.curSeconed+8 isUp:@"1"];
    if (dayHeartDetailDict1||dayHeartDetailDict2||dayHeartDetailDict3||dayHeartDetailDict4||dayHeartDetailDict5||dayHeartDetailDict6||dayHeartDetailDict7||dayHeartDetailDict8)
    {
        
        NSDictionary *dayHeartDetailDict1 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+1)];
        NSDictionary *dayHeartDetailDict2 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+2)];
        NSDictionary *dayHeartDetailDict3 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+3)];
        NSDictionary *dayHeartDetailDict4 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+4)];
        NSDictionary *dayHeartDetailDict5 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+5)];
        NSDictionary *dayHeartDetailDict6 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+6)];
        NSDictionary *dayHeartDetailDict7 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+7)];
        NSDictionary *dayHeartDetailDict8 = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:(self.curSeconed+8)];
        
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayHeartDetailDict1[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        NSArray *heartArray1 = [NSArray array];
        
        if(dayHeartDetailDict1)
        {
            if (!((NSNull *)dayHeartDetailDict1[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray1 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict1[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray1 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray1 = [AllTool makeArrayEight];
        }
        
        NSArray *heartArray2 = [NSArray array];
        
        if(dayHeartDetailDict2)
        {
            if (!((NSNull *)dayHeartDetailDict2[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict2[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray2 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray2 = [AllTool makeArrayEight];
        }
        NSArray *heartArray3 = [NSArray array];
        
        if(dayHeartDetailDict3)
        {
            if (!((NSNull *)dayHeartDetailDict3[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray3 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict3[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray3 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray3 = [AllTool makeArrayEight];
        }
        NSArray *heartArray4 = [NSArray array];
        
        if(dayHeartDetailDict4)
        {
            if (!((NSNull *)dayHeartDetailDict4[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray4 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict4[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray4 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray4 = [AllTool makeArrayEight];
        }
        NSArray *heartArray5 = [NSArray array];
        
        if(dayHeartDetailDict5)
        {
            if (!((NSNull *)dayHeartDetailDict5[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray5 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict5[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray5 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray5 = [AllTool makeArrayEight];
        }
        NSArray *heartArray6 = [NSArray array];
        
        if(dayHeartDetailDict6)
        {
            if (!((NSNull *)dayHeartDetailDict6[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray6 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict6[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray6 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray6 = [AllTool makeArrayEight];
        }
        NSArray *heartArray7 = [NSArray array];
        
        if(dayHeartDetailDict7)
        {
            if (!((NSNull *)dayHeartDetailDict7[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray7 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict7[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray7 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray7 = [AllTool makeArrayEight];
        }
        NSArray *heartArray8 = [NSArray array];
        if(dayHeartDetailDict8)
        {
            if (!((NSNull *)dayHeartDetailDict8[HeartRate_ActualData_HCH] == [NSNull null]))
            {
                heartArray8 = [NSKeyedUnarchiver unarchiveObjectWithData:dayHeartDetailDict8[HeartRate_ActualData_HCH]];
            }
            else
            {
                heartArray8 = [AllTool makeArrayEight];
            }
        }
        else
        {
            heartArray8 = [AllTool makeArrayEight];
        }
        NSString *heartString1 =[AllTool arrayToString2:heartArray1];
        NSString *heartString2 =[AllTool arrayToString2:heartArray2];
        NSString *heartString3 =[AllTool arrayToString2:heartArray3];
        NSString *heartString4 =[AllTool arrayToString2:heartArray4];
        NSString *heartString5 =[AllTool arrayToString2:heartArray5];
        NSString *heartString6 =[AllTool arrayToString2:heartArray6];
        NSString *heartString7 =[AllTool arrayToString2:heartArray7];
        NSString *heartString8 =[AllTool arrayToString2:heartArray8];
        NSMutableString *updataHeart = [NSMutableString string];
        [updataHeart appendString:heartString1];
        [updataHeart appendString:heartString2];
        [updataHeart appendString:heartString3];
        [updataHeart appendString:heartString4];
        [updataHeart appendString:heartString5];
        [updataHeart appendString:heartString6];
        [updataHeart appendString:heartString7];
        [updataHeart appendString:heartString8];
        
        __block  NSString *deviceType = dayHeartDetailDict1[@"deviceType"];
        if (!deviceType) {
            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        }
        __block  NSString *deviceId = dayHeartDetailDict1[DEVICEID];
        if (deviceId) {
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        NSString *time = [NSString stringWithFormat:@"%f",[[TimeCallManager getInstance] getNowSecond]];
        __block  NSDictionary *paramHeart = @{@"userId":USERID,@"time":time,@"date":timeStr,@"hrData":updataHeart};
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",HEARTRATEUPDATE,TOKEN];
        
        //adaLog(@"updataHeart-%@",updataHeart);
        //adaLog(@"UpdataDayHeartDetailCurrentDay - %@",paramHeart);
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramHeart Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            adaLog(@"上传心率的  code = %d",code);
            if (code == 0)
            {
                //adaLog(@"三、全天心率 - - 当天 -  heartRate - 上传数据成功");
                //adaLog(@"heartRate - msg -- %@",responseObject[@"msg"]);
                
                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict1];
                if (!dict1[@"deviceType"]) {
                    [dict1 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict1[DEVICEID]) {
                    [dict1 setValue:deviceId forKey:DEVICEID];
                }
                [dict1 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict1];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict1];
                
                NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict2];
                if (!dict2[@"deviceType"]) {
                    [dict2 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict2[DEVICEID]) {
                    [dict2 setValue:deviceId forKey:DEVICEID];
                }
                [dict2 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict2];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict2];
                
                NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict3];
                if (!dict3[@"deviceType"]) {
                    [dict3 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict3[DEVICEID]) {
                    [dict3 setValue:deviceId forKey:DEVICEID];
                }
                [dict3 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict3];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict3];
                
                NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict4];
                if (!dict4[@"deviceType"]) {
                    [dict4 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict4[DEVICEID]) {
                    [dict4 setValue:deviceId forKey:DEVICEID];
                }
                [dict4 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict4];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict4];
                
                NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict5];
                if (!dict5[@"deviceType"]) {
                    [dict5 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict5[DEVICEID]) {
                    [dict5 setValue:deviceId forKey:DEVICEID];
                }
                [dict5 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict5];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict5];
                
                NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict6];
                if (!dict6[@"deviceType"]) {
                    [dict6 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict6[DEVICEID]) {
                    [dict6 setValue:deviceId forKey:DEVICEID];
                }
                [dict6 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict6];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict6];
                
                NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict7];
                if (!dict7[@"deviceType"]) {
                    [dict7 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict7[DEVICEID]) {
                    [dict7 setValue:deviceId forKey:DEVICEID];
                }
                [dict7 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict7];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict7];
                
                NSMutableDictionary *dict8 = [[NSMutableDictionary alloc]initWithDictionary:dayHeartDetailDict8];
                if (!dict8[@"deviceType"]) {
                    [dict8 setValue:deviceType forKey:@"deviceType"];
                }
                if (!dict8[DEVICEID]) {
                    [dict8 setValue:deviceId forKey:DEVICEID];
                }
                [dict8 setValue:@"1" forKey:ISUP];
                //[[CoreDataManage shareInstance] updataHeartRateWithDic:dict8];
                [[CoreDataManage shareInstance] updataHeartRateALLDAYWithDic:dict8];
            }
            else if(code == 9001)
            {
                ++_UpdataDayHeartDetailCurrentDayTimes;
                if (_UpdataDayHeartDetailCurrentDayTimes>3)
                {
                    _UpdataDayHeartDetailCurrentDayTimes = 0;
                    return ;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataDayHeartDetailCurrentDay) withObject:nil afterDelay:0.1];
            }
            else
            {
                ++_UpdataDayHeartDetailCurrentDayTimes;
                if (_UpdataDayHeartDetailCurrentDayTimes>3)
                {
                    _UpdataDayHeartDetailCurrentDayTimes = 0;
                    return ;
                }
                else
                {
                    [weakSelf  performSelector:@selector(UpdataDayHeartDetailCurrentDay) withObject:nil afterDelay:0.1];
                }
            }
            
        } ];
    }
    else
    {
        //adaLog(@"dictionary -- else");
    }
}
// 四、在线运动 - onlinesport - CurrentDay
-(void)UpdataDayOnlinesportCurrentDay
{
    //    BOOL isDown = [self checkIsCanDown];
    //    if (!isDown) {
    //        return;
    //    }
    //    //日期
    //    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:self.curSeconed andFormat:@"yyyy-MM-dd"];
    //    __block   NSArray * OnlineSportArray = [[SQLdataManger getInstance] queryHeartRateDataWithDateToUp:timeStr isUp:@"1"];
    //
    //
    //    if (OnlineSportArray.count>0)
    //    {
    //        __block   NSArray * OnlineSportArray = [[SQLdataManger getInstance] queryHeartRateDataWithDate:timeStr];
    //        NSMutableDictionary *sportArraydictionary = [NSMutableDictionary dictionary];
    //        for (SportModel *sportModel in OnlineSportArray)
    //        {
    //            NSDictionary *dictionary = [sportModel modelToUpdataDictionary];
    //            //adaLog(@"dictionary - %@",dictionary);
    //            [sportArraydictionary addEntriesFromDictionary:dictionary];
    //        }
    //        SportModel *model = OnlineSportArray[0];
    //        __block  NSString *deviceType = model.deviceType;
    //        if (!deviceType) {
    //            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    //        }
    //        __block  NSString *deviceId = model.deviceId;
    //        if (deviceId) {
    //
    //            deviceId = [AllTool macToMacString:deviceId];
    //        }
    //        else
    //        {
    //            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
    //        }
    //        NSString *str = [AllTool dictionaryToJson:sportArraydictionary];
    //        __block  NSDictionary *paramHeart = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"offlineData",@"uploadData":str};
    //
    //        //adaLog(@"paramHeart-%@",paramHeart);
    //        WeakSelf;
    //        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramHeart Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
    //            int code = [responseObject[@"code"] intValue];
    //            //adaLog(@"code-%d,offlineData - msg -- %@",code,responseObject[@"msg"]);
    //            if (code == 9003)
    //            {
    //                //adaLog(@"四、在线运动 - 当天 -  - onlinesport - 上传数据成功");
    //                [[SQLdataManger getInstance] insertMostSport:OnlineSportArray];
    //                //adaLog(@"offlineData - msg -- %@",responseObject[@"msg"]);
    //            }
    //            else if(code == 9001)
    //            {
    //                [CacheLogin logining];
    //                [weakSelf  performSelector:@selector(UpdataDayOnlinesportCurrentDay) withObject:nil afterDelay:0.1];
    //            }
    //            else
    //            {
    //                ++_UpdataDayOnlinesportCurrentDayTimes;
    //                if (_UpdataDayOnlinesportCurrentDayTimes>3) {
    //                    _UpdataDayOnlinesportCurrentDayTimes = 0;
    //                } else {
    //                    [weakSelf  performSelector:@selector(UpdataDayOnlinesportCurrentDay) withObject:nil afterDelay:0.1];
    //                }
    //            }
    //
    //        } ];
    //    }
    //    else
    //    {
    //        //adaLog(@"dictionary -- else");
    //    }
}
// 五、血压数据 - bloodPressure - CurrentDay
-(void)UpdataBloodPressureCurrentDay
{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    //日期
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:self.curSeconed andFormat:@"yyyy-MM-dd"];
    __block   NSArray * BloodPressureArray = [[SQLdataManger getInstance] queryBloodPressureWithDayToUp:timeStr isUp:@"1"];
    
    
    if (BloodPressureArray.count>0)
    {
        __block   NSArray * BloodPressureArray = [[SQLdataManger getInstance] queryBloodPressureWithDay:timeStr];
        NSMutableDictionary *dic = [BloodPressureModel arrayToDictionary:BloodPressureArray];
        NSDictionary *dict = BloodPressureArray[0];
        __block  NSString *deviceType = dict[@"deviceType"];
        if (!deviceType) {
            deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        }
        __block  NSString *deviceId = dict[@"deviceID"];
        if (deviceId) {
            
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        
        NSString *BloodStr = [AllTool dictionaryToJson:dic];
        __block  NSDictionary *paramBlood = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"bloodPressure",@"uploadData":BloodStr};
        //adaLog(@"paramBloodcur - %@",paramBlood);
        
        WeakSelf;
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"uploadData_MovementData" ParametersDictionary:paramBlood Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            if (code == 9003)
            {
                //adaLog(@"五、血压数据  - 当天 - - bloodPressure  - 上传数据成功");
                [[SQLdataManger getInstance] insertMostBlood:BloodPressureArray];
            }
            else if(code == 9001)
            {
                ++_UpdataBloodPressureCurrentDayTimes;
                if (_UpdataBloodPressureCurrentDayTimes>3) {
                    _UpdataBloodPressureCurrentDayTimes = 0;
                    return ;
                }
                [CacheLogin logining];
                [weakSelf  performSelector:@selector(UpdataBloodPressureCurrentDay) withObject:nil afterDelay:0.1];
            }
            else
            {
                ++_UpdataBloodPressureCurrentDayTimes;
                if (_UpdataBloodPressureCurrentDayTimes>3) {
                    _UpdataBloodPressureCurrentDayTimes = 0;
                    return ;
                } else {
                    [weakSelf  performSelector:@selector(UpdataBloodPressureCurrentDay) withObject:nil afterDelay:0.1];
                }
            }
        } ];
    }
    else
    {
        //adaLog(@"dictionary -- else");
    }
}

//睡眠数据
- (void)UpdateSleepDataCurrent{
    BOOL isDown = [self checkIsCanDown];
    if (!isDown) {
        return;
    }
    NSDictionary *dayDetailDictionary = [[CoreDataManage shareInstance] querDayDetailWithTimeSecondsToUp:self.curSeconed isUp:@"1"];
    if (dayDetailDictionary)
    {
        //日期
        NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[dayDetailDictionary[@"DataDate"] intValue] andFormat:@"yyyy-MM-dd"];
        NSArray *sleepArray = [NSArray array];
        if (!((NSNull *)dayDetailDictionary[DataValue_SleepData_HCH] == [NSNull null]))
        {
            sleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:dayDetailDictionary[DataValue_SleepData_HCH]];
        }
        else
        {
            sleepArray = [AllTool makeSleepArray];
        }
        NSString *sleepString =[AllTool arrayToString2:sleepArray];
        __block  NSDictionary *paramSleep = @{@"userId":USERID,@"Date":timeStr,@"Sq_List":sleepString};
        NSString *url = [NSString stringWithFormat:@"%@/%@",SLEEPUPDATE,TOKEN];
        __block  NSString *deviceId = dayDetailDictionary[@"deviceID"];
        if (deviceId) {
            
            deviceId = [AllTool macToMacString:deviceId];
        }
        else
        {
            deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
        }
        __block  NSString *deviceType = dayDetailDictionary[@"deviceType"];
        WeakSelf
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramSleep Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
            int code = [responseObject[@"code"] intValue];
            //adaLog(@"code = %d, msd = %@",code,responseObject[@"msg"]);
            if (code == 0)
            {
                if (!dayDetailDictionary[DEVICETYPE]) {
                    [dayDetailDictionary setValue:deviceType forKey:DEVICETYPE];
                }
                if (!dayDetailDictionary[DEVICEID]) {
                    [dayDetailDictionary setValue:deviceId forKey:DEVICEID];
                }
                [dayDetailDictionary setValue:@"1" forKey:ISUP];
                [[CoreDataManage shareInstance] updataDayDetailDAYALLWithDic:dayDetailDictionary];
            }else{
                ++_UpdataSleepTimes;
                if (_UpdataSleepTimes>3)
                {
                    _UpdataSleepTimes=0;
                    return ;
                }
                [weakSelf  performSelector:@selector(UpdateSleepDataCurrent) withObject:nil afterDelay:0.1];
            }
        }];
        
    }
}

- (void)uploadCurrentDayData{
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0; i < 180; i++) {
        [a addObject:@(0)];
    }
    //全天心率
    NSMutableArray *heart1 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart2 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart3 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart4 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart5 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart6 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart7 = [NSMutableArray arrayWithArray:a];
    NSMutableArray *heart8 = [NSMutableArray arrayWithArray:a];
    
    WeakSelf;
    //获取睡眠数据
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
//        weakSelf.sleepArray = sleepArray;
//        weakSelf.sleepArray = [NSMutableArray array];
        weakSelf.sleepTime = timeSeconds;
        //获取心率数据
        [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
            switch (index) {
                case 1:{
                    [heart1 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 2:{
                    [heart2 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 3:{
                    [heart3 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 4:{
                    [heart4 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 5:{
                    [heart5 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 6:{
                    [heart6 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 7:{
                    [heart7 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
                case 8:{
                    [heart8 replaceObjectsInRange:NSMakeRange(0, 180) withObjectsFromArray:heartArray];
                }break;
            }
            NSString *heartString1 =[AllTool arrayToStringHeart:heart1];
            NSString *heartString2 =[AllTool arrayToStringHeart:heart2];
            NSString *heartString3 =[AllTool arrayToStringHeart:heart3];
            NSString *heartString4 =[AllTool arrayToStringHeart:heart4];
            NSString *heartString5 =[AllTool arrayToStringHeart:heart5];
            NSString *heartString6 =[AllTool arrayToStringHeart:heart6];
            NSString *heartString7 =[AllTool arrayToStringHeart:heart7];
            NSString *heartString8 =[AllTool arrayToStringHeart:heart8];
            NSMutableString * upDataHeart =[NSMutableString string];
            [upDataHeart appendString:heartString1];
            [upDataHeart appendString:heartString2];
            [upDataHeart appendString:heartString3];
            [upDataHeart appendString:heartString4];
            [upDataHeart appendString:heartString5];
            [upDataHeart appendString:heartString6];
            [upDataHeart appendString:heartString7];
            [upDataHeart appendString:heartString8];
            //获取运动数据
            [[PZBlueToothManager sharedInstance] checkHourStepsAndCostsWithBlock:^(NSArray *steps, NSArray *costs) {
                [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
                   [self uploadCurrentHearStr:upDataHeart sleepArr:self.sleepArray sleepTime:weakSelf.sleepTime steps:steps costs:costs dayDic:dic];
                }];
            }];
        }];
    }];
}

- (void)uploadCurrentHearStr:(NSString *)hear sleepArr:(NSArray *)sleepArr sleepTime:(int)sleeptime steps:(NSArray *)stepArr costs:(NSArray *)costs dayDic:(NSDictionary *)dayDic{
    NSString *cal = dayDic[@"TotalCosts_DayData"];
    NSString *step = dayDic[@"TotalSteps_DayData"];
    NSString *distance = [NSString stringWithFormat:@"%f",[dayDic[@"TotalMeters_DayData"] doubleValue]/1000.0];
    
    NSString *startTime = [self calcSleepStartAndEndTimeWithCurrentTime:self.curSeconed][0];
    NSString *endTime = [self calcSleepStartAndEndTimeWithCurrentTime:self.curSeconed][1];
    NSString *stepAll = [AllTool arrayToStringSport:stepArr];
    NSString *costsAll = [AllTool arrayToStringSport:costs];
    NSString *sleepAll = @"";
    if ([self.sleepArray count] == 0) {
        sleepAll = @"";
    }else{
        sleepAll = [AllTool arrayToString2:[self deleteSleepArrayZero:self.sleepArray]];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%f",[[TimeCallManager getInstance] getNowSecond]];
    NSString *dateStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:self.curSeconed andFormat:@"yyyy-MM-dd"];
    
    NSDictionary *paramater = @{@"Step_List":stepAll,@"Step":step,@"Cal":cal,@"Distance":distance,@"Cal_List":costsAll,@"Sq_List":sleepAll,@"StartTime":startTime,@"EndTime":endTime,@"hrData":hear,@"userId":USERID,@"date":dateStr,@"time":timeStr};
    NSString *url = [NSString stringWithFormat:@"%@/%@",HEARTRATEUPDATE,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramater Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
        int code = [responseObject[@"code"] intValue];
        //adaLog(@"code = %d, msd = %@",code,responseObject[@"msg"]);
        if (code == 0)
        {
            NSLog(@"每分钟上传数据成功");
            
        }else{
            
        }
    }];
    
}

- (NSArray *)calcSleepStartAndEndTimeWithCurrentTime:(int)time{
    [self.sleepArray removeAllObjects];
    NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:time - KONEDAYSECONDS];
    NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:time];
    NSMutableArray *sleepArray = [NSMutableArray array];
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:detailDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    
    sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
    int nightBeginTime = 0;
    int nightEndTime = 0;
    BOOL isBegin = NO;
    for (int i = 0; i < sleepArray.count; i ++)
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
    
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            for (int i = nightBeginTime ; i <= nightEndTime; i ++) {
                int state = [sleepArray[i] intValue];
                [self.sleepArray addObject:@(state)];
            }
        }
    }
    
    if (nightEndTime == nightBeginTime) {
        return @[@"",@""];
    }
    
    nightEndTime += 1;
    
    if (nightBeginTime < 12) {
        nightBeginTime += 132;
    }else{
        nightBeginTime -= 12;
    }
    if (nightEndTime < 12) {
        nightEndTime += 132;
    }else{
        nightEndTime -= 12;
    }
    
    NSInteger starHour = (nightBeginTime*10)/60;
    NSInteger starMin = (nightBeginTime*10)%60;
    NSInteger endHour = (nightEndTime*10)/60;
    NSInteger endMin = (nightEndTime*10)%60;
    
    NSString *start = [NSString stringWithFormat:@"%02ld:%02ld",starHour,starMin];
    NSString *end = [NSString stringWithFormat:@"%02ld:%02ld",endHour,endMin];
    
    return @[start,end];
}

//上传每分钟实时步数
- (void)uploadMinuteStep{
    if ([CositeaBlueTooth sharedInstance].isConnected) {
        [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
            //记录上一分钟的步数
            int lastStep = 0;
            //步数
            int steps = [dic[@"TotalSteps_DayData"] intValue];
            //日期
            int time = [[TimeCallManager getInstance] getNowMinute];
            //打开数据库
            SQLdataManger *sq = [SQLdataManger getInstance];
            //获取上一分钟的步数
            NSArray *lastArr = [sq getMinuteStepWithTime:[NSString stringWithFormat:@"%d",time-60]];
            //如果上一分钟为0
            if ([lastArr count] != 0) {
                //拿到上一分钟的步数
                NSDictionary *dic = lastArr[0];
                lastStep = [dic[@"Step"] intValue];
            }
            //把当前分钟的数据存入数据库
            [sq addMinuteStepWith:[NSString stringWithFormat:@"%d",steps] time:[NSString stringWithFormat:@"%d",time]];
            //开始上传到服务器
            NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOADMINUTESTEP,TOKEN];
            NSArray *dataArr = @[@{@"Step":[NSString stringWithFormat:@"%d",steps-lastStep],@"Time":@(time)}];
            NSData *data = [NSJSONSerialization dataWithJSONObject:dataArr options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *paramater = @{@"userid":USERID,@"data":string};
            //请求
            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:paramater Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
                int code = [responseObject[@"code"] intValue];
                if (code == 0)
                {
                    NSLog(@"每分钟上传步数数据成功");
                    
                }else{
                    
                }
            }];
        }];
    }else{
        [self performSelector:@selector(uploadMinuteStep) withObject:nil afterDelay:5];
    }
}

//删除睡眠数据的0
- (NSArray *)deleteSleepArrayZero:(NSArray *)sleepArr{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:sleepArr];
    NSInteger location = 0;
    for (int i = 0; i < arr.count; i++) {
        NSInteger num = [arr[i] integerValue];
        if (num != 0) {
            location = 0;
        }else{
            location = i;
        }
    }
    
    BOOL isZero = YES;
    for (int i = 0; i < arr.count; i++) {
        NSInteger num = [arr[i] integerValue];
        if (num == 0 && isZero == YES) {
            [arr removeObjectAtIndex:i];
            i--;
        }else{
            isZero = NO;
        }
    }
    
    if (location != 0) {
        for (int i = 0; i < arr.count; i++) {
            if (i >= location) {
                [arr removeObjectAtIndex:i];
                i--;
            }
        }        
    }
    
    return arr;
}

#pragma mark  - -- - -  以下  下载   数据
#pragma mark  - -- - -     下载   超时
//-(void)downDataTimeOut
//{
//
//}
///**
// *
// *      下载   数据 +DayTotalData
// *
// **/
//+(void)downDayTotalData:(dictionaryBlock)dictionaryBlock  date:(int)seconed
//{
//
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramTotalData = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"allData" };
//    //adaLog(@"down - paramTotalData - %@",paramTotalData);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramTotalData Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载全天数据成功");
//                NSDictionary *data = responseObject[@"data"];
//                //adaLog(@"全天数据 -- %@",data);
//                int time = [[TimeCallManager getInstance] getSecondsWithTimeString:data[@"time"] andFormat:@"yyyy-MM-dd"];
//                NSDictionary *dic;
//                if (!dic) {
//                    dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                           [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
//                           [NSString stringWithFormat:@"%d",time], DataTime_HCH,
//                           data[@"step"], TotalSteps_DayData_HCH,
//                           data[@"mileage"], TotalMeters_DayData_HCH,
//                           data[@"calorie"], TotalCosts_DayData_HCH,
//                           intToString([data[@"sleepTarget"] intValue]*60) , Sleep_PlanTo_HCH,
//                           data[@"stepTarget"] , Steps_PlanTo_HCH,
//                           data[@"activityTime"],TotalDataActivityTime_DayData_HCH,
//                           data[@"activityCalor"],kTotalDayActivityCost,
//                           data[@"sitTime"],TotalDataCalmTime_DayData_HCH,
//                           data[@"sitCalor"],kTotalDayCalmCost,
//                           deviceType,DEVICETYPE,
//                           deviceId,DEVICEID,
//                           @"1",ISUP,
//                           [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
//                           [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
//                           [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
//                           [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
//                           [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
//                           [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:time]], TotalDataWeekIndex_DayData_HCH,
//                           nil];
//                    [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
//                    if (dictionaryBlock) {
//                        dictionaryBlock(dic);
//                    }
//                }
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else if(code == 9004)
//            {
//                //adaLog(@"今天没有数据");
//                if (dictionaryBlock) {
//                    dictionaryBlock(nil);
//                }
//            }
//            else
//            {
//            }
//        }
//    } ];
//}
///**
// *
// *      下载   数据 + DayOnlinesport
// *
// **/
//+(void)downDayOnlinesport:(arrayBlock)arrayBlock  date:(int)seconed
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramOnlinesport = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"offlineData" };
//    //adaLog(@"down - paramOnlinesport - %@",paramOnlinesport);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramOnlinesport Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 在线运动   数据成功");
//                NSDictionary *sportDic =  [AllTool dictionaryWithJsonString:responseObject[@"data"][@"offlineData"]];
//                if (sportDic)
//                {
//                    NSMutableArray *mutableArr = [NSMutableArray array];
//                    NSArray *Arr = [sportDic allKeys];
//                    //    枚举其中的字典
//                    for (int i=0; i<Arr.count; i++)
//                    {
//                        SportModel *sport= [SportModel modelWithDictionary:sportDic[Arr[i]] key:Arr[i]];
//                        [mutableArr addObject:sport];
//                    }
//                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
//                    [deleteDict setObject:[[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"] forKey:SPORTDATE];
//                    [[SQLdataManger getInstance] deleteDataWithColumns:deleteDict fromTableName:@"ONLINESPORT"];
//                    NSInteger sportIDTemp = [[SQLdataManger getInstance] queryHeartRateDataWithAll];
//                    NSDictionary *totalDatadict = [[SQLdataManger getInstance] getTotalDataWith:seconed];
//                    for (NSInteger index=0; index<mutableArr.count; index++)
//                    {
//                        NSInteger idNum = sportIDTemp + index;
//                        SportModel * sport=mutableArr[index];
//                        sport.sportID = [NSString stringWithFormat:@"%ld",idNum];
//                        sport.userName = totalDatadict[CurrentUserName_HCH];
//                        sport.deviceId = totalDatadict[DEVICEID];
//                        int type = [totalDatadict[DEVICETYPE] intValue];
//                        //                        if(type>99)
//                        //                        {
//                        //                            sport.sportType = intToString(type);
//                        //                        }
//                        //                        else
//                        //                        {
//                        //                            sport.sportType = intToString(type+100);
//                        //                        }
//                        sport.deviceType = [NSString stringWithFormat:@"%03d",type];
//                        sport.isUp = @"1";
//                    }
//                    [[SQLdataManger getInstance] insertMostSport:mutableArr];
//
//                    if (arrayBlock) {
//                        arrayBlock(mutableArr);
//                    }
//                }
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else if(code == 9004)
//            {
//                //adaLog(@"今天没有数据");
//            }
//            else
//            {
//            }
//        }
//    } ];

//}
///**
// *
// *       下载   数据 +  sleepDictionaryBlock
// *
// **/
//+(void)downSleepData:(sleepDictionaryBlock)sleepDictionaryBlock  date:(int)seconed
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//    __block  NSString *timeStr2 =  [[TimeCallManager getInstance] getTimeStringWithSeconds:(seconed-KONEDAYSECONDS) andFormat:@"yyyy-MM-dd"];
//    __block  NSDictionary *paramSleepData = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"sleepData" };
//    __block  NSDictionary *paramSleepData2 = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr2,@"dataType":@"sleepData" };
//    //adaLog(@"down - paramSleepData - %@",paramSleepData);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramSleepData Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error)
//        {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 睡眠   数据成功");
//
//                NSString *sleepDay = responseObject[@"data"][@"time"];
//                int seconed = [[TimeCallManager getInstance] getSecondsWithTimeString:sleepDay andFormat:@"yyyy-MM-dd"];
//                NSString *sleepStr = responseObject[@"data"][@"sleepData"];
//                NSArray *array = [sleepStr componentsSeparatedByString:@","];
//                NSData *sleepData = [NSKeyedArchiver archivedDataWithRootObject:array];
//                __block  NSDictionary *dic1 = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                NSDictionary *totalDatadict = [[SQLdataManger getInstance] getTotalDataWith:seconed];
//                if (dic1)
//                {
//                    NSMutableDictionary * multDic = [[NSMutableDictionary alloc]initWithDictionary:dic1];
//                    [multDic setValue:sleepData forKey:DataValue_SleepData_HCH];
//                    [multDic setValue:@"1" forKey:ISUP];
//                    [multDic setValue:totalDatadict[CurrentUserName_HCH] forKey:CurrentUserName_HCH];
//                    [multDic setValue:totalDatadict[DEVICEID] forKey:DEVICEID];
//                    [multDic setValue:totalDatadict[DEVICETYPE] forKey:DEVICETYPE];
//                    [[CoreDataManage shareInstance] updataDayDetailTableWithDic:multDic];
//                }
//                else
//                {
//                    dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            sleepData,DataValue_SleepData_HCH,
//                            [NSNumber numberWithInt:seconed],DataTime_HCH,
//                            [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                            [NSNumber numberWithInt:0],kLightSleep,
//                            [NSNumber numberWithInt:0],kDeepSleep,
//                            [NSNumber numberWithInt:0],kAwakeSleep,
//                            @"1",ISUP,
//                            totalDatadict[DEVICEID],DEVICEID,
//                            totalDatadict[DEVICETYPE],DEVICETYPE,nil];
//                    [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dic1];
//                }
//                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramSleepData2 Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//
//                    if (error)
//                    {
//                        //adaLog(@"服务器异常");
//                        [[TodayStepsViewController sharedInstance] remindRedownData];
//
//                    }
//                    else
//                    {
//                        int code = [responseObject[@"code"] intValue];
//                        if (code == 9003)
//                        {
//                            //adaLog(@"下载 睡眠  2 数据成功");
//
//                            NSString *sleepDay = responseObject[@"data"][@"time"];
//                            int seconed = [[TimeCallManager getInstance] getSecondsWithTimeString:sleepDay andFormat:@"yyyy-MM-dd"];
//                            NSString *sleepStr = responseObject[@"data"][@"sleepData"];
//                            NSArray *array = [sleepStr componentsSeparatedByString:@","];
//                            NSData *sleepData = [NSKeyedArchiver archivedDataWithRootObject:array];
//                            NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                            NSDictionary *totalDatadict = [[SQLdataManger getInstance] getTotalDataWith:seconed];
//                            if (dic)
//                            {
//                                NSMutableDictionary * multDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//                                [multDic setValue:sleepData forKey:DataValue_SleepData_HCH];
//                                [multDic setValue:@"1" forKey:ISUP];
//                                [multDic setValue:totalDatadict[CurrentUserName_HCH] forKey:CurrentUserName_HCH];
//                                [multDic setValue:totalDatadict[DEVICEID] forKey:DEVICEID];
//                                [multDic setValue:totalDatadict[DEVICETYPE] forKey:DEVICETYPE];
//                                [[CoreDataManage shareInstance] updataDayDetailTableWithDic:multDic];
//                            }
//                            else
//                            {
//                                dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                       sleepData,DataValue_SleepData_HCH,
//                                       [NSNumber numberWithInt:seconed],DataTime_HCH,
//                                       [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                                       [NSNumber numberWithInt:0],kLightSleep,
//                                       [NSNumber numberWithInt:0],kDeepSleep,
//                                       [NSNumber numberWithInt:0],kAwakeSleep,
//                                       @"1",ISUP,
//                                       totalDatadict[DEVICEID],DEVICEID,
//                                       totalDatadict[DEVICETYPE],DEVICETYPE,nil];
//                                [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dic];
//                            }
//
//                            if (sleepDictionaryBlock)
//                            {
//                                sleepDictionaryBlock(dic1,dic);
//                            }
//                        }
//                        else if(code == 9001)
//                        {
//                            [CacheLogin logining];
//                        }
//                        else
//                        {
//
//                        }
//                    }
//                } ];
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else if(code == 9004)
//            {
//                //adaLog(@"没有今天的数据");
//                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramSleepData2 Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//
//                    if (error)
//                    {
//                        //adaLog(@"服务器异常");
//                        [[TodayStepsViewController sharedInstance] remindRedownData];
//
//                    }
//                    else
//                    {
//                        int code = [responseObject[@"code"] intValue];
//                        if (code == 9003)
//                        {
//                            //adaLog(@"下载 睡眠  2 数据成功");
//
//                            NSString *sleepDay = responseObject[@"data"][@"time"];
//                            int seconed = [[TimeCallManager getInstance] getSecondsWithTimeString:sleepDay andFormat:@"yyyy-MM-dd"];
//                            NSString *sleepStr = responseObject[@"data"][@"sleepData"];
//                            NSArray *array = [sleepStr componentsSeparatedByString:@","];
//                            NSData *sleepData = [NSKeyedArchiver archivedDataWithRootObject:array];
//                            NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                            NSDictionary *totalDatadict = [[SQLdataManger getInstance] getTotalDataWith:seconed];
//                            if (dic)
//                            {
//                                NSMutableDictionary * multDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//                                [multDic setValue:sleepData forKey:DataValue_SleepData_HCH];
//                                [multDic setValue:@"1" forKey:ISUP];
//                                [multDic setValue:totalDatadict[CurrentUserName_HCH] forKey:CurrentUserName_HCH];
//                                [multDic setValue:totalDatadict[DEVICEID] forKey:DEVICEID];
//                                [multDic setValue:totalDatadict[DEVICETYPE] forKey:DEVICETYPE];
//                                [[CoreDataManage shareInstance] updataDayDetailTableWithDic:multDic];
//                            }
//                            else
//                            {
//                                dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                       sleepData,DataValue_SleepData_HCH,
//                                       [NSNumber numberWithInt:seconed],DataTime_HCH,
//                                       [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                                       [NSNumber numberWithInt:0],kLightSleep,
//                                       [NSNumber numberWithInt:0],kDeepSleep,
//                                       [NSNumber numberWithInt:0],kAwakeSleep,
//                                       @"1",ISUP,
//                                       totalDatadict[DEVICEID],DEVICEID,
//                                       totalDatadict[DEVICETYPE],DEVICETYPE,nil];
//                                [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dic];
//                            }
//
//                            if (sleepDictionaryBlock) {
//                                sleepDictionaryBlock(nil,dic);
//                            }
//                        }
//                        else if(code == 9001)
//                        {
//                            [CacheLogin logining];
//                        }
//                        else if(code == 9004)
//                        {
//                            //adaLog(@"没有昨天的数据");
//                        }
//                        else
//                        {
//
//                        }
//                    }
//                } ];
//            }
//            else
//            {
//            }
//        }
//    } ];
//}
//
//+(void)downSleepDataADay:(sleepDictionaryBlock)sleepDictionaryBlock  date:(int)seconed
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//    __block  NSDictionary *paramSleepData = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"sleepData" };
//    //adaLog(@"down - paramSleepData - %@",paramSleepData);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramSleepData Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error)
//        {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 睡眠   数据成功");
//
//                NSString *sleepDay = responseObject[@"data"][@"time"];
//                int seconed = [[TimeCallManager getInstance] getSecondsWithTimeString:sleepDay andFormat:@"yyyy-MM-dd"];
//                NSString *sleepStr = responseObject[@"data"][@"sleepData"];
//                NSArray *array = [sleepStr componentsSeparatedByString:@","];
//                NSData *sleepData = [NSKeyedArchiver archivedDataWithRootObject:array];
//                __block  NSDictionary *dic1 = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                NSDictionary *totalDatadict = [[SQLdataManger getInstance] getTotalDataWith:seconed];
//                if (dic1)
//                {
//                    NSMutableDictionary * multDic = [[NSMutableDictionary alloc]initWithDictionary:dic1];
//                    [multDic setValue:sleepData forKey:DataValue_SleepData_HCH];
//                    [multDic setValue:@"1" forKey:ISUP];
//                    [multDic setValue:totalDatadict[CurrentUserName_HCH] forKey:CurrentUserName_HCH];
//                    [multDic setValue:totalDatadict[DEVICEID] forKey:DEVICEID];
//                    [multDic setValue:totalDatadict[DEVICETYPE] forKey:DEVICETYPE];
//                    [[CoreDataManage shareInstance] updataDayDetailTableWithDic:multDic];
//                }
//                else
//                {
//                    dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            sleepData,DataValue_SleepData_HCH,
//                            [NSNumber numberWithInt:seconed],DataTime_HCH,
//                            [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                            [NSNumber numberWithInt:0],kLightSleep,
//                            [NSNumber numberWithInt:0],kDeepSleep,
//                            [NSNumber numberWithInt:0],kAwakeSleep,
//                            @"1",ISUP,
//                            totalDatadict[DEVICEID],DEVICEID,
//                            totalDatadict[DEVICETYPE],DEVICETYPE,nil];
//                    [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dic1];
//                }
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else if(code == 9004)
//            {
//
//            }
//            else
//            {
//
//            }
//        }
//    } ];
//
//}
///**
// *
// *      下载   数据 + BloodPressure
// *
// **/
//+(void)downBloodPressure:(arrayBlock)bloodPressureArrayBlock  date:(int)seconed
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramBloodPressure = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"bloodPressure" };
//    //adaLog(@"down - paramBloodPressure - %@",paramBloodPressure);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramBloodPressure Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 血压数据   数据成功");
//                NSDictionary *bloodPressureDic =  [AllTool dictionaryWithJsonString:responseObject[@"data"][@"bloodPressure"]];
//                if (bloodPressureDic)
//                {
//                    NSMutableArray *mutableArr = [NSMutableArray array];
//                    NSArray *Arr = [bloodPressureDic allKeys];
//                    //    枚举其中的字典
//                    for (int i=0; i<Arr.count; i++)
//                    {
//                        //                        BloodPressureModel *bloodP= [BloodPressureModel modelWithDictionary:bloodPressureDic[Arr[i]] key:Arr[i]];
//                        //                        [mutableArr addObject:bloodP];
//                        NSDictionary *dict = [BloodPressureModel modelWithDictionary:bloodPressureDic[Arr[i]] key:Arr[i]];
//                        [mutableArr addObject:dict];
//                    }
//                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
//                    [deleteDict setObject:[[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"] forKey:BloodPressureDate_def];
//                    [[SQLdataManger getInstance] deleteDataWithColumns:deleteDict fromTableName:@"BloodPressure_Table"];
//
//                    NSInteger bloodPTemp = [[SQLdataManger getInstance] queryBloodPressureALL];
//                    NSDictionary *totalDatadict = [[SQLdataManger getInstance] getTotalDataWith:seconed];
//                    for (NSInteger index=0; index<mutableArr.count; index++)
//                    {
//                        NSInteger idNum = bloodPTemp + index;
//                        NSMutableDictionary * bloodP=[NSMutableDictionary dictionaryWithDictionary:mutableArr[index]];
//                        [bloodP setObject:[NSString stringWithFormat:@"%ld",idNum] forKey:BloodPressureID_def];
//                        [bloodP setObject:totalDatadict[CurrentUserName_HCH] forKey:CurrentUserName_HCH];
//                        [bloodP setObject:totalDatadict[DEVICEID] forKey:DEVICEID];
//                        [bloodP setObject:totalDatadict[DEVICETYPE] forKey:DEVICETYPE];
//                        [bloodP setObject:@"1" forKey:ISUP];
//                        //                        bloodP.BloodPressureID = [NSString stringWithFormat:@"%ld",idNum];
//                        //                        bloodP.userName = totalDatadict[CurrentUserName_HCH];
//                        //                        bloodP.deviceId = totalDatadict[DEVICEID];
//                        //                        bloodP.deviceType = totalDatadict[DEVICETYPE];
//                        //                        bloodP.isUp = @"1";
//
//                        [mutableArr replaceObjectAtIndex:index withObject:bloodP];
//                    }
//                    [[SQLdataManger getInstance] insertMostBlood:mutableArr];
//
//                    if (bloodPressureArrayBlock) {
//                        bloodPressureArrayBlock(mutableArr);
//                    }
//                }
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else
//            {
//            }
//        }
//    } ];
//}
//
///**
// *
// *      下载   数据 +  每小时计步: type = stepDay
// *
// **/
//+(void)downDayDetailSteps:(arrayBlock)DayDetailStepsBlock  date:(int)seconed
//{
//
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramDayDetailSteps = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"stepDay" };
//    //adaLog(@"down - paramDayDetailSteps - %@",paramDayDetailSteps);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramDayDetailSteps Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 每小时计步: type = stepDay   数据成功");
//                NSString *stepString =  responseObject[@"data"][@"stepDay"];
//                NSArray *stepArray = [stepString componentsSeparatedByString:@","];
//                NSData *stepData = [NSKeyedArchiver archivedDataWithRootObject:stepArray];
//                if (stepArray.count>0)
//                {
//                    NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                    if (dic)
//                    {
//                        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//
//                        [mutDic setValue:stepData forKey:kDayStepsData];
//                        [mutDic setValue:@"1" forKey:ISUP];
//                        if (!mutDic[DEVICEID]) {
//                            NSString *deviceId = [AllTool amendMacAddressGetAddress];
//                            //                            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//                            //                            if (!deviceId) {
//                            //                                deviceId =  DEFAULTDEVICEID;
//                            //                            }
//                            [mutDic setValue:deviceId forKey:DEVICEID];
//                        }
//                        [[CoreDataManage shareInstance] updataDayDetailTableWithDic:mutDic];
//                    }
//                    else
//                    {
//                        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//                        NSString *deviceId = [AllTool amendMacAddressGetAddress];
//                        //                        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//                        //                        if (!deviceId) {
//                        //                            deviceId =  DEFAULTDEVICEID;
//                        //                        }
//                        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                                                     [NSNumber numberWithInt:seconed],DataTime_HCH,
//                                                     stepData,kDayStepsData,
//                                                     @"1",ISUP,
//                                                     deviceType,DEVICETYPE,
//                                                     deviceId,DEVICEID,
//                                                     nil];
//                        [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];
//
//                    }
//                    if(DayDetailStepsBlock)
//                    {
//                        DayDetailStepsBlock(stepArray);
//                    }
//                }
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else
//            {
//            }
//
//        }
//    } ];
//}
//
///**
// *
// *      下载   数据 +  每小时卡路里消耗: type = calorieDay
// *
// **/
//+(void)downDayDetailCosts:(arrayBlock)DayDetailCostsBlock  date:(int)seconed
//{
//
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramDayDetailCosts = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"calorieDay" };
//    //adaLog(@"down - paramDayDetailCosts - %@",paramDayDetailCosts);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramDayDetailCosts Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载  每小时卡路里消耗: type = calorieDay   数据成功");
//                NSString *calorieString =  responseObject[@"data"][@"calorieDay"];
//                NSArray *calorieArray = [calorieString componentsSeparatedByString:@","];
//                NSData *calorieData = [NSKeyedArchiver archivedDataWithRootObject:calorieArray];
//                if (calorieArray.count>0)
//                {
//                    NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                    if (dic)
//                    {
//                        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//
//                        [mutDic setValue:calorieData forKey:kDayCostsData];
//                        [mutDic setValue:@"1" forKey:ISUP];
//                        if (!mutDic[DEVICEID]) {
//                            NSString *deviceId = [AllTool amendMacAddressGetAddress];
//                            //                            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//                            //                            if (!deviceId) {
//                            //                                deviceId =  DEFAULTDEVICEID;
//                            //                            }
//                            [mutDic setValue:deviceId forKey:DEVICEID];
//                        }
//                        [[CoreDataManage shareInstance] updataDayDetailTableWithDic:mutDic];
//                    }
//                    else
//                    {
//                        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//                        NSString *deviceId = [AllTool amendMacAddressGetAddress];
//                        //                        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//                        //                        if (!deviceId) {
//                        //                            deviceId =  DEFAULTDEVICEID;
//                        //                        }
//                        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                                                     [NSNumber numberWithInt:seconed],DataTime_HCH,
//                                                     calorieData,kDayCostsData,
//                                                     @"1",ISUP,
//                                                     deviceType,DEVICETYPE,
//                                                     deviceId,DEVICEID,
//                                                     nil];
//                        [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];
//
//                    }
//                    if(DayDetailCostsBlock)
//                    {
//                        DayDetailCostsBlock(calorieArray);
//                    }
//
//                }
//                else if(code == 9001)
//                {
//                    [CacheLogin logining];
//                }
//                else
//                {
//                }
//            }
//        }
//    } ];
//}
///**
// *
// *      下载   数据 +  Hrv: type = hrv
// *
// **/
//+(void)downDayDetailHRV:(arrayBlock)DayDetailHRVBlock  date:(int)seconed
//{
//
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramDayDetailHRV = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"hrv" };
//    //adaLog(@"down - paramDayDetailHRV - %@",paramDayDetailHRV);
//    //    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramDayDetailHRV Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载  Hrv: type = hrv   数据成功");
//                NSString *hrvString =  responseObject[@"data"][@"hrv"];
//                NSArray *hrvArray = [hrvString componentsSeparatedByString:@","];
//                NSData *hrvData = [NSKeyedArchiver archivedDataWithRootObject:hrvArray];
//                if (hrvArray.count>0)
//                {
//                    NSDictionary *dic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconed];
//                    if (dic)
//                    {
//                        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//
//                        [mutDic setValue:hrvData forKey:kPilaoData];
//                        [mutDic setValue:@"1" forKey:ISUP];
//                        if (!mutDic[DEVICEID]) {
//                            NSString *deviceId = [AllTool amendMacAddressGetAddress];
//                            //                            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//                            //                            if (!deviceId) {
//                            //                                deviceId =  DEFAULTDEVICEID;
//                            //                            }
//                            [mutDic setValue:deviceId forKey:DEVICEID];
//                        }
//                        [[CoreDataManage shareInstance] updataDayDetailTableWithDic:mutDic];
//                    }
//                    else
//                    {
//                        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//                        NSString *deviceId = [AllTool amendMacAddressGetAddress];
//                        //                        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//                        //                        if (!deviceId) {
//                        //                            deviceId =  DEFAULTDEVICEID;
//                        //                        }
//                        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:[HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//                                                     [NSNumber numberWithInt:seconed],DataTime_HCH,
//                                                     hrvData,kPilaoData,
//                                                     @"1",ISUP,
//                                                     deviceType,DEVICETYPE,
//                                                     deviceId,DEVICEID,
//                                                     nil];
//                        [[CoreDataManage shareInstance] CreatDayDetailTabelWithDic:dictionnary];
//
//                    }
//                    if(DayDetailHRVBlock)
//                    {
//                        DayDetailHRVBlock(hrvArray);
//                    }
//                }
//                else if(code == 9001)
//                {
//                    [CacheLogin logining];
//                }
//                else
//                {
//                }
//            }
//        }
//    } ];
//}
///**
// *
// *      下载   数据 +  每分钟心率: type = heartRate
// *
// **/
//+(void)downDayHeartRate:(arrayBlock)DayHeartRateBlock  date:(int)seconed
//{
//
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *paramDayHeartRate = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"heartRate" };
//    //adaLog(@"down - paramDayHeartRate - %@",paramDayHeartRate);
//    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:paramDayHeartRate Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载  每分钟心率: type = heartRate   数据成功");
//                NSString *heartRateString =  responseObject[@"data"][@"heartRate"];
//                NSArray *heartRateArray = [heartRateString componentsSeparatedByString:@","];//心率的总数组
//                float ArrayNumber1 = (float)(heartRateArray.count)/180.0;
//                float ArrayNumber2 =  ceilf(ArrayNumber1);
//                //adaLog(@"---%.0f",ArrayNumber2);
//
//                if (ArrayNumber2>=1)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:1];
//                }
//                if (ArrayNumber2>=2)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:2];
//
//                }
//                if (ArrayNumber2>=3)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:3];
//
//                }
//                if (ArrayNumber2>=4)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:4];
//                }
//                if (ArrayNumber2>=5)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:5];
//                }
//                if (ArrayNumber2>=6)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:6];
//
//                }
//                if (ArrayNumber2>=7)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:7];
//                }
//                if (ArrayNumber2>=8)
//                {
//                    [weakSelf saveHeartRateWithArray:heartRateArray date:seconed index:8];
//                }
//                if(DayHeartRateBlock)
//                {
//                    DayHeartRateBlock(heartRateArray);
//                }
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//            }
//            else
//            {
//            }
//        }
//    } ];
//}
////保存心率数据
//+(void)saveHeartRateWithArray:(NSArray *)array date:(int)seconed index:(int)index
//{
//    NSRange range = NSMakeRange((index-1)*180, 180);
//    NSInteger count = array.count;
//    if (count<range.location+range.length)
//    {
//        range.length = count-range.location;
//    }
//    //关闭了下载
//    NSArray *arr = [array subarrayWithRange:range];
//    NSData *heartRateData = [NSKeyedArchiver archivedDataWithRootObject:arr];
//    NSDictionary *dic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:seconed+index];
//    if (dic)
//    {
//        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//        [mutDic setObject:heartRateData forKey:HeartRate_ActualData_HCH];
//        [mutDic setValue:@"1" forKey:ISUP];
//        if (!mutDic[DEVICEID]) {
//            NSString *deviceId = [AllTool amendMacAddressGetAddress];
//            //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//            //            if (!deviceId) {
//            //                deviceId =  DEFAULTDEVICEID;
//            //            }
//            [mutDic setValue:deviceId forKey:DEVICEID];
//        }
//        [[CoreDataManage shareInstance] updataHeartRateWithDic:mutDic];
//    }
//    else
//    {
//        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//        NSString *deviceId = [AllTool amendMacAddressGetAddress];
//        //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
//        //        if (!deviceId) {
//        //            deviceId =  DEFAULTDEVICEID;
//        //        }
//        dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//               [HCHCommonManager getInstance].UserAcount,CurrentUserName_HCH,
//               [NSNumber numberWithInt:seconed+index],DataTime_HCH,
//               heartRateData,HeartRate_ActualData_HCH,
//               @"1",ISUP,
//               deviceType,DEVICETYPE,
//               deviceId,DEVICEID,nil];
//        [[CoreDataManage shareInstance] CreatHeartRateWithDic:dic];
//    }
//}
//
///**
// *
// *      下载   数据 + 步数月趋势 	type=stepTrend
// *
// **/
//+(void)downYueStepTrend:(dictionaryBlock)dictionaryBlock  date:(int)seconed
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *YueStepTrend = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"stepTrend" };
//    //adaLog(@"down - YueStepTrend - %@",YueStepTrend);
//    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:YueStepTrend Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error) {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 数据 + 步数月趋势 	type=stepTrend   数据成功");
//                NSDictionary *YueStepTrendDict =  responseObject[@"data"][@"stepTrend"];
//                if (dictionaryBlock) {
//                    dictionaryBlock(YueStepTrendDict);
//                }
//                [TimingUploadData sharedInstance].yueStepTrendTimes = 0;
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//                ++[TimingUploadData sharedInstance].yueStepTrendTimes;
//                if ([TimingUploadData sharedInstance].yueStepTrendTimes>3) {
//                    [TimingUploadData sharedInstance].yueStepTrendTimes = 0;
//                } else {
//                    [weakSelf  downYueStepTrend:dictionaryBlock date:seconed];
//                }
//            }
//            else
//            {
//                [CacheLogin logining];
//                ++[TimingUploadData sharedInstance].yueStepTrendTimes;
//                if ([TimingUploadData sharedInstance].yueStepTrendTimes>3) {
//                    [TimingUploadData sharedInstance].yueStepTrendTimes = 0;
//                } else {
//                    [weakSelf  downYueStepTrend:dictionaryBlock date:seconed];
//                }
//            }
//        }
//    } ];
//
//}

/**
 *
 *      下载   数据 + 睡眠月趋势 	type=sleepTrend
 *
 **/
//+(void)downYueSleepTrend:(dictionaryBlock)dictionaryBlock  date:(int)seconed
//{
//    BOOL isDown = [self checkIsCanDown];
//    if (!isDown) {
//        return;
//    }
//    __block  NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
//    __block  NSString *deviceId = [AllTool macToMacString:[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS]];
//    __block  NSString *timeStr =  [[TimeCallManager getInstance] getTimeStringWithSeconds:seconed andFormat:@"yyyy-MM-dd"];
//
//    __block  NSDictionary *YueSleepTrend = @{@"deviceType":deviceType,@"deviceId":deviceId,@"time":timeStr,@"dataType":@"sleepTrend" };
//    //adaLog(@"down - YueSleepTrend - %@",YueSleepTrend);
//    WeakSelf;
//    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"download_allData" ParametersDictionary:YueSleepTrend Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
//        if (error)
//        {
//            //adaLog(@"服务器异常");
//            [[TodayStepsViewController sharedInstance] remindRedownData];
//        }
//        else
//        {
//            int code = [responseObject[@"code"] intValue];
//            if (code == 9003)
//            {
//                //adaLog(@"下载 数据 + 睡眠月趋势 	type=sleepTrend   数据成功");
//                NSDictionary *YueSleepTrendDict =  responseObject[@"data"][@"sleepTrend"];
//                if (dictionaryBlock) {
//                    dictionaryBlock(YueSleepTrendDict);
//                }
//                [TimingUploadData sharedInstance].yueSleepTrendTimes = 0;
//            }
//            else if(code == 9001)
//            {
//                [CacheLogin logining];
//                ++[TimingUploadData sharedInstance].yueSleepTrendTimes;
//                if ([TimingUploadData sharedInstance].yueSleepTrendTimes>3) {
//                    [TimingUploadData sharedInstance].yueSleepTrendTimes = 0;
//                } else {
//                    [weakSelf  downYueStepTrend:dictionaryBlock date:seconed];
//                }
//            }
//            else
//            {
//                [CacheLogin logining];
//                ++[TimingUploadData sharedInstance].yueSleepTrendTimes;
//                if ([TimingUploadData sharedInstance].yueSleepTrendTimes>3) {
//                    [TimingUploadData sharedInstance].yueSleepTrendTimes = 0;
//                } else {
//                    [weakSelf  downYueStepTrend:dictionaryBlock date:seconed];
//                }
//            }
//        }
//    } ];
//
//}

#pragma mark   - - -私有方法
/**
 检查网络，检查是否有用户
 */
+(BOOL)checkIsCanDown
{
    BOOL isDown = YES;
    //    if (kHCH.networkStatus<=0)
    //    {
    if(kHCH.iphoneNetworkStatus<=0){
        isDown = NO;
    }
    if([[ADASaveDefaluts objectForKey:LOGINTYPE] intValue] ==3)
    {
        isDown = NO;
    }
    return isDown;
}
/**
 检查网络，检查是否有用户
 */
-(BOOL)checkIsCanDown
{
    BOOL isDown = YES;
    //    if (kHCH.networkStatus<=0)
    //    {
    if(kHCH.iphoneNetworkStatus<=0){
        isDown = NO;
    }
    if([[ADASaveDefaluts objectForKey:LOGINTYPE] intValue] ==3)
    {
        isDown = NO;
    }
    return isDown;
}
#pragma  mark  -  - - 懒加载
-(int)curSeconed
{
    if (_curSeconed<=0)
    {
        _curSeconed = [[TimeCallManager getInstance] getSecondsOfCurDay];
    }
    return _curSeconed;
}
-(NSMutableArray *)sportArray
{
    if (!_sportArray)
    {
        _sportArray = [NSMutableArray array];
    }
    return _sportArray;
}

- (NSMutableArray *)sleepArray{
    if (!_sleepArray)
    {
        _sleepArray = [NSMutableArray array];
    }
    return _sleepArray;
}

@end
