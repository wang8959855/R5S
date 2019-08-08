
//
//  HCHCommonManager.m
//  HuiChengHe
//
//  Created by zhangtan on 14-12-7.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import "HCHCommonManager.h"
#import "BleTool.h"

static HCHCommonManager * instance=nil;

@interface HCHCommonManager()
@property (nonatomic,strong) NSTimer *timeTimer;//用于监测系统的变化。基本是区别夸天
@end

@implementation HCHCommonManager

+ (HCHCommonManager *)getInstance{
    //        static dispatch_once_t onceToken;
    @synchronized(self) {
        if( instance == nil ){
            instance =  [[HCHCommonManager alloc] init];
            [instance initData];
        }
    }
    return instance;
}

+ (void)clearInstance{
    instance = nil ;
}

- (int)todayTimeSeconds{
    return [[TimeCallManager getInstance] getSecondsOfCurDay];
}

- (int)selectTimeSeconds{
    return [[TimeCallManager getInstance] getSecondsOfCurDay];
}

- (void)initData{
    _isFirstLogin = [[NSUserDefaults standardUserDefaults] boolForKey:CheckFirstLoad_HCH];
    _sleepPlan = [[[NSUserDefaults standardUserDefaults] objectForKey:Sleep_PlanTo_HCH] intValue];
    _stepsPlan = [[[NSUserDefaults standardUserDefaults] objectForKey:Steps_PlanTo_HCH] intValue];
    _antilossIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:AntiLoss_Status_HCH];
    _state = [[[NSUserDefaults standardUserDefaults] objectForKey:kUnitStateKye]intValue];
//    _todayTimeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
//    _selectTimeSeconds = _todayTimeSeconds;
    self.pilaoValue = YES;
    self.weatherLocation = 1;
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(systemTimeChange) userInfo:nil repeats:YES];//定时刷新时间
    
    //监测网络的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //开始监测网络
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void)setAntilossIsOn:(BOOL)antilossIsOn {
    _antilossIsOn = antilossIsOn;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:antilossIsOn] forKey:AntiLoss_Status_HCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getFileStoreFolder{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *paths = [[path objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@""]];
    if( ![fileManager isExecutableFileAtPath:paths] ){
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return paths;
}

- (int)getPersonAge {
    int age = 25;
    //    NSDictionary *dic = [[SQLdataManger getInstance] getCurPersonInf];
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *assignDate = [formates dateFromString:[dic objectForKey:BornDate_PersonInfo_HCH]];
    NSDate *assignDate = [formates dateFromString:[_userInfoDictionAry objectForKey:@"birthdate"]];
    int time = [assignDate timeIntervalSinceNow];
    age = abs(time/(60*60*24))/365;
    return age;
}

//设置自动登录
- (void)setIsFirstLogin:(BOOL)isFirstLogin{
    _isFirstLogin = isFirstLogin ;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isFirstLogin] forKey:CheckFirstLoad_HCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSleepPlan:(int)sleepPlan {
    _sleepPlan = sleepPlan;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:sleepPlan] forKey:Sleep_PlanTo_HCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setStepsPlan:(int)stepsPlan {
    _stepsPlan = stepsPlan;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:stepsPlan] forKey:Steps_PlanTo_HCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)storeHeadImageWithImage:(UIImage *)locImage{
    NSString *file = [self getFileStoreFolder];
    file = [NSString stringWithFormat:@"%@/%@",file,@"file.png"];
    
    NSData *imageData = UIImagePNGRepresentation(locImage);
    [imageData writeToFile:file atomically:YES];
    
    return file ;
}

- (NSString *)saveImageFromCache
{
    NSString *file = [self getFileStoreFolder];
    NSString *file1 = [NSString stringWithFormat:@"%@/%@",file,@"headImageCache.png"];
    NSString *file2 = [NSString stringWithFormat:@"%@/%@",file,@"headImage.png"];
    [[NSFileManager defaultManager] removeItemAtPath:file2 error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:file1 toPath:file2 error:nil];
    return file2;
}

- (UIImage *)getHeadImageWithFile:(NSString *)fileName{
    UIImage *locImage = [UIImage imageWithContentsOfFile:fileName];
    
    return locImage ;
}

//- (int)age {
//    int age = 25;
//    NSDictionary *dic = [[SQLdataManger getInstance] getCurPersonInf];
//    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
//    [formates setDateFormat:@"yyyy-MM-dd"];
//    NSDate *assignDate = [formates dateFromString:[dic objectForKey:BornDate_PersonInfo_HCH]];
//    int time = fabs([assignDate timeIntervalSinceNow]);
//    age = trunc(time/(60*60*24))/365;
//    if (age >60) {
//        age = 60;
//    }
//    return age;
//}

//- (void)sendUserInfoToBlueTooth {
//
//    [[PZBlueToothManager sharedInstance] sendUserInfoToBind];
//}

//- (void)sendCurrentUserInfoToBlueTooth {
//    [[PZBlueToothManager sharedInstance] sendUserInfoToBind];
//}


- (NSString *)createRandomString {
    int NUMBER_OF_CHARS = 10;
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

- (void)setUserEmailWith:(NSString *)email {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && email) {
        [_userInfoDictionAry setObject:email forKey:@"email"];
    }
}

- (id)UserEmail {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"email"];
    } else {
        return  nil;
    }
}

- (void)setUserBirthdateWith:(NSString *)birthdate {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && birthdate) {
        [_userInfoDictionAry setObject:birthdate forKey:@"Birthday"];
    }
}

- (id)userBirthdate {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Birthday"];
    } else {
        return  @"";
    }
}
- (void)setUserHeaderWith:(NSString *)header {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && header) {
        [_userInfoDictionAry setObject:header forKey:@"headImg"];
    }
}

- (id)UserHeader {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"headImg"];
    } else {
        return  @"";
    }
}

- (void)setUserHeightWith:(NSString *)height {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && height) {
        [_userInfoDictionAry setObject:height forKey:@"Height"];
    }
}

- (id)UserHeight {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Height"];
    } else {
        return  @"";
    }
}

- (void)setUserWeightWith:(NSString *)weight {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && weight) {
        [_userInfoDictionAry setObject:weight forKey:@"Weight"];
    }
}

- (id)UserWeight {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Weight"];
    } else {
        return  @"";
    }
}

- (void)setUserNickWith:(NSString *)nick {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && nick) {
        [_userInfoDictionAry setObject:nick forKey:@"NickName"];
    }
}

- (id)UserNick {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"NickName"];
    } else {
        return @"";
    }
}

- (void)setUserGenderWith:(NSString *)gender {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && gender) {
        [_userInfoDictionAry setObject:gender forKey:@"Sex"];
    }
}

- (id)UserGender {
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Sex"];
    } else {
        return  @"";
    }
}

- (void)setUserAcountName:(NSString *)userName {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && userName) {
        [_userInfoDictionAry setObject:userName forKey:@"Name"];
    }
}

- (id)UserAcount {
    if (_userInfoDictionAry) {
        if ([_userInfoDictionAry objectForKey:@"Name"] == nil)
        {
            return NSLocalizedString(@"", nil);
        }
        return [_userInfoDictionAry objectForKey:@"Name"];
        
    } else {
        return  NSLocalizedString(@"", nil);
    }
}

- (void)setUserAddressWith:(NSString *)address{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && address) {
        [_userInfoDictionAry setObject:address forKey:@"Address"];
    }
}

- (id)UserAddress{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Address"];
    } else {
        return @"";
    }
}

- (void)setUserIsCHDWith:(NSString *)isCHD{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && isCHD) {
        [_userInfoDictionAry setObject:isCHD forKey:@"Is_CHD"];
    }
}

- (id)UserIsCHD{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Is_CHD"];
    } else {
        return  @"";
    }
}

- (void)setUserIsHypertensionWith:(NSString *)isHypertension{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && isHypertension) {
        [_userInfoDictionAry setObject:isHypertension forKey:@"Is_hypertension"];
    }
}

- (id)UserIsHypertension{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Is_hypertension"];
    } else {
        return  @"";
    }
}

- (void)setUserRafTel1With:(NSString *)rafTel1{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && rafTel1) {
        [_userInfoDictionAry setObject:rafTel1 forKey:@"EmergencyContact1"];
    }
}

- (id)UserRafTel1{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"EmergencyContact1"];
    } else {
        return @"";
    }
}

- (void)setUserRafTel2With:(NSString *)rafTel2{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && rafTel2) {
        [_userInfoDictionAry setObject:rafTel2 forKey:@"EmergencyContact2"];
    }
}

- (id)UserRafTel2{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"EmergencyContact2"];
    } else {
        return  @"";
    }
}

- (void)setUserRafTel3With:(NSString *)rafTel3{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && rafTel3) {
        [_userInfoDictionAry setObject:rafTel3 forKey:@"EmergencyContact3"];
    }
}

- (id)UserRafTel3{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"EmergencyContact3"];
    } else {
        return  @"";
    }
}

- (void)setUserDiastolicPWith:(NSString *)diastolicP{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && diastolicP) {
        [_userInfoDictionAry setObject:diastolicP forKey:@"DiastolicPressure"];
        [ADASaveDefaluts setObject:diastolicP forKey:BLOODPRESSURELOW];
    }
}

- (id)UserDiastolicP{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"DiastolicPressure"];
    } else {
        return @"";
    }
}

- (void)setUserSystolicPWith:(NSString *)systolicP{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && systolicP) {
        [_userInfoDictionAry setObject:systolicP forKey:@"SystolicPressure"];
        [ADASaveDefaluts setObject:systolicP forKey:BLOODPRESSUREHIGH];
    }
}

- (id)UserSystolicP{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"SystolicPressure"];
    } else {
        return @"";
    }
}

- (void)setUserGluWith:(NSString *)Glu {
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && Glu) {
        [_userInfoDictionAry setObject:Glu forKey:@"Glu"];
    }
}

- (id)UserGlu{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Glu"];
    } else {
        return @"";
    }
}

- (void)setUserIsGlu:(NSString *)isGlu{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && isGlu) {
        [_userInfoDictionAry setObject:isGlu forKey:@"is_Glu"];
    }
}

- (id)UserIsGlu{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"is_Glu"];
    } else {
        return @"";
    }
}

- (void)setUserVipTimeWith:(NSString *)VipTime{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && VipTime) {
        [_userInfoDictionAry setObject:VipTime forKey:@"VipTime"];
    }
}

- (id)UserVipTime{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"VipTime"];
    } else {
        return @"";
    }
}

- (void)setUserIDCardNoWith:(NSString *)IDCardNo{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && IDCardNo) {
        [_userInfoDictionAry setObject:IDCardNo forKey:@"IDCardNo"];
    }
}

- (id)UserIDCardNo{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"IDCardNo"];
    } else {
        return @"";
    }
}

- (void)setUserPointWith:(NSString *)Point{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && Point) {
        [_userInfoDictionAry setObject:Point forKey:@"Point"];
    }
}

- (id)UserPoint{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Point"];
    } else {
        return @"";
    }
}

- (void)setUserTelWith:(NSString *)Tel{
    if (!_userInfoDictionAry) {
        _userInfoDictionAry = [[NSMutableDictionary alloc]init];
    }
    if (_userInfoDictionAry && Tel) {
        [_userInfoDictionAry setObject:Tel forKey:@"Tel"];
    }
}

- (id)UserTel{
    if (_userInfoDictionAry) {
        return [_userInfoDictionAry objectForKey:@"Tel"];
    } else {
        return @"";
    }
}

- (int)pilaoWarning
{
    int age = [[HCHCommonManager getInstance] getPersonAge];
    int warningValue = 15;
    if (age < 25)
    {
        warningValue = 40;
        
    }else if (age < 35)
    {
        warningValue = 35;
    }
    else if (age < 45)
    {
        warningValue = 25;
    }
    else if (age < 55)
    {
        warningValue = 20;
    }
    else if (age < 65)
    {
        warningValue = 15;
    }
    
    return warningValue;
}

- (int)getAge
{
    NSDateFormatter *formates = [[NSDateFormatter alloc] init];
    [formates setDateFormat:@"yyyy-MM-dd"];
    NSDate *assignDate = [formates dateFromString:[self userBirthdate]];
    int time = fabs([assignDate timeIntervalSinceNow]);
    int age = trunc(time/(60*60*24))/365;
    return age;
}
-(NSMutableArray *)queryWeatherArray
{
    if (!_queryWeatherArray) {
        _queryWeatherArray = [NSMutableArray array];
    }
    return _queryWeatherArray;
}
//-(AFNetworkReachabilityStatus)networkStatus
//{
//    if (_networkStatus<=0)
//    {
//        //adaLog(@"当前无网络连接");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[TodayStepsViewController sharedInstance] remindNotReachable];
//        });
//        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        //        [self addActityTextInView:window text:NSLocalizedString(@"当前无网络连接", nil) deleyTime:1.0f];
//    }
//    return _networkStatus;
//}
-(int)LanguageNum
{
    _LanguageNum = [BleTool setLanguageTool];
    return _LanguageNum;
}
//监测系统时间的方法
-(void)systemTimeChange
{
    self.todayTimeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    
//    //adaLog(@"todayTimeSeconds = %d",_todayTimeSeconds);
//    //adaLog(@"todayTimeSeconds = %@",[[TimeCallManager getInstance] timeAdditionWithTimeString:@"yyyy-MM-dd HH:mm:ss" andSeconed:_todayTimeSeconds]);
}
#pragma  mark   - -- apple demo   监测网络
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    self.iphoneNetworkStatus = netStatus;
    switch (netStatus)
    {
        case NotReachable:{
            //adaLog(@"--NotReachable");
            break;
        }
        case ReachableViaWWAN:{
            //adaLog(@"--ReachableViaWWAN");
            break;
        }
        case ReachableViaWiFi:{
            //adaLog(@"--ReachableViaWiFi");
            break;
        }
    }
}

- (void)setIsEquipmentConnect:(BOOL)isEquipmentConnect{
    _isEquipmentConnect = isEquipmentConnect;
    if (isEquipmentConnect) {
        //实时心率
        [[PZBlueToothManager sharedInstance] changeHeartStateWithState:YES Block:^(int number) {
            if (number == 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:GetNowHeartRateNotification object:@"--"];
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GetNowHeartRateNotification object:[NSString stringWithFormat:@"%d",number]];
        }];
        //设置血压
        [[CositeaBlueTooth sharedInstance] setupCorrectNumber];
        //获取血压
        [[PZBlueToothManager sharedInstance] checkBloodPressure:^(BloodPressureModel *bloodPre) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GetPressureSPO2HRV object:bloodPre];
        }];
    }
}

+ (void)getAvgHeartRate{
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
    NSString *timeStr = [[TimeCallManager getInstance] getTimeStringWithSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay] andFormat:@"yyyy-MM-dd"];
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
        
        if ([heart1 count] && [heart2 count] && [heart3 count] && [heart4 count] && [heart5 count] && [heart6 count] && [heart7 count] && [heart8 count]) {
            NSData *data1 = [NSJSONSerialization dataWithJSONObject:heart1 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data2 = [NSJSONSerialization dataWithJSONObject:heart2 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data3 = [NSJSONSerialization dataWithJSONObject:heart3 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data4 = [NSJSONSerialization dataWithJSONObject:heart4 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data5 = [NSJSONSerialization dataWithJSONObject:heart5 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data6 = [NSJSONSerialization dataWithJSONObject:heart6 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data7 = [NSJSONSerialization dataWithJSONObject:heart7 options:NSJSONWritingPrettyPrinted error:nil];
            NSData *data8 = [NSJSONSerialization dataWithJSONObject:heart8 options:NSJSONWritingPrettyPrinted error:nil];
            [[SQLdataManger getInstance] addHistoryHeartRate:@[data1,data2,data3,data4,data5,data6,data7,data8,timeStr] date:timeStr];
        }
        
//        NSInteger heart = 0;
//        NSInteger max = 0;
//        NSInteger min = 100;
//        NSInteger total = 0;
//        for (NSNumber *number in heart1) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart2) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart3) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart4) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart5) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart6) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart7) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        for (NSNumber *number in heart8) {
//            heart += number.integerValue;
//            if (number.integerValue != 0){
//                total += 1;
//            }
//            if (number.integerValue > max){
//                max = number.integerValue;
//            }
//            if (number.integerValue < min && number.integerValue != 0){
//                min = number.integerValue;
//            }
//        }
//        NSString *avg = [NSString stringWithFormat:@"%ld",heart/total];
//        NSString *minStr = [NSString stringWithFormat:@"%ld",min];
//        if (total == 0){
//            minStr = @"0";
//        }
//        NSString *maxStr = [NSString stringWithFormat:@"%ld",max];
//        [[NSNotificationCenter defaultCenter] postNotificationName:GetAvgHeartRateNotification object:@{@"avg":avg,@"min":minStr,@"max":maxStr}];
    }];
}

-(void)dealloc
{
    //暂停定时器
    if (_timeTimer.isValid) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
