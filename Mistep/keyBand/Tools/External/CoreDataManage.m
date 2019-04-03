#import "CoreDataManage.h"

@implementation CoreDataManage

static CoreDataManage *instance = nil;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
+ (id)shareInstance
{
    @synchronized(instance)
    {
        if (instance == nil)
        {
            instance = [CoreDataManage new];
            [instance toUpdateData];//更新以前的数据。符合上传下行的要求
        }
        return instance;
    }
}
//更新以前的数据。符合上传下行的要求
-(void)toUpdateData
{
    //adaLog(@" - -- - - - - coredata 数据更新");
    
    //运动详情表
    //设备 类型 处理
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayDetail" inManagedObjectContext:context];
    
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"deviceType = %@",@"1"];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    //adaLog(@"deviceType =  1 arr = 有%ld个需要修改  -- ",arr.count);
    for (HeartRate* entity in arr) {
        entity.deviceType = @"001";
    }
    //    [self saveContext];
    
    NSFetchRequest *requestTwo = [NSFetchRequest new];
    requestTwo.entity = entity;
    NSPredicate *preTwo = [NSPredicate predicateWithFormat:@"deviceType = %@",@"2"];
    [requestTwo setPredicate:preTwo];
    NSArray *arrTwo = [context executeFetchRequest:requestTwo error:nil];
    //adaLog(@"deviceType = 2 arrTwo = 有%ld个需要修改  -- ",arrTwo.count);
    for (HeartRate* entity in arrTwo) {
        entity.deviceType = @"002";
    }
    
    //null 空处理
    NSFetchRequest *requestThree = [NSFetchRequest new];
    requestThree.entity = entity;
    NSPredicate *preThree = [NSPredicate predicateWithFormat:@"deviceType = nil"];
    [requestThree setPredicate:preThree];
    NSArray *arrThree = [context executeFetchRequest:requestThree error:nil];
    //adaLog(@"null = 有%ld个需要修改  -- ",arrThree.count);
    for (HeartRate* entity in arrThree) {
        entity.deviceType = @"001";
    }
    
    
    NSFetchRequest *requestFour = [NSFetchRequest new];
    requestFour.entity = entity;
    NSPredicate *preFour = [NSPredicate predicateWithFormat:@"isUp = nil"];
    [requestFour setPredicate:preFour];
    NSArray *arrFour = [context executeFetchRequest:requestFour error:nil];
    //adaLog(@"null = 有%ld个需要修改  -- ",arrFour.count);
    for (HeartRate* entity in arrFour) {
        entity.isUp = @"0";
    }
    
    //心率表
    
    NSEntityDescription *entityheart = [NSEntityDescription entityForName:@"HeartRate" inManagedObjectContext:context];
    
    NSFetchRequest *req = [NSFetchRequest new];
    req.entity = entityheart;
    NSPredicate *preheart = [NSPredicate predicateWithFormat:@"deviceType = %@",@"1"];
    [req setPredicate:preheart];
    NSArray *arrheart = [context executeFetchRequest:req error:nil];
    //adaLog(@"heart-deviceType =  1 有%ld个需要修改  -- ",arrheart.count);
    for (HeartRate* entity in arrheart) {
        entity.deviceType = @"001";
    }
    //    [self saveContext];
    
    NSFetchRequest *reqTwo = [NSFetchRequest new];
    reqTwo.entity = entityheart;
    NSPredicate *preheartTwo = [NSPredicate predicateWithFormat:@"deviceType = %@",@"2"];
    [reqTwo setPredicate:preheartTwo];
    NSArray *arrheartTwo = [context executeFetchRequest:reqTwo error:nil];
    //adaLog(@"heart-deviceType = 2 有%ld个需要修改  -- ",arrheartTwo.count);
    for (HeartRate* entity in arrheartTwo) {
        entity.deviceType = @"002";
    }
    
    //null 空处理
    NSFetchRequest *reqThree = [NSFetchRequest new];
    reqThree.entity = entityheart;
    NSPredicate *preheartThree = [NSPredicate predicateWithFormat:@"deviceType = nil"];
    [reqThree setPredicate:preheartThree];
    NSArray *arrheartThree = [context executeFetchRequest:reqThree error:nil];
    //adaLog(@"heart-null = 有%ld个需要修改  -- ",arrheartThree.count);
    for (HeartRate* entity in arrheartThree) {
        entity.deviceType = @"001";
    }
    
    
    NSFetchRequest *reqFour = [NSFetchRequest new];
    reqFour.entity = entityheart;
    NSPredicate *preheartFour = [NSPredicate predicateWithFormat:@"isUp = nil"];
    [reqFour setPredicate:preheartFour];
    NSArray *arrheartFour = [context executeFetchRequest:reqFour error:nil];
    //adaLog(@"heart-null = 有%ld个需要修改  -- ",arrheartFour.count);
    for (HeartRate* entity in arrheartFour) {
        entity.isUp = @"0";
    }
    [self saveContext];
    
    //adaLog(@"修改数据 -- 完成");
}

- (void)CreatDayDetailTabelWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext *context = self.managedObjectContext;
    DayDetail *detail = [NSEntityDescription insertNewObjectForEntityForName:@"DayDetail" inManagedObjectContext:context];
    detail.userCount = dic[CurrentUserName_HCH];
    detail.dataDate = dic[DataTime_HCH];
    detail.stepData = dic[kDayStepsData];
    detail.costsData = dic[kDayCostsData];
    detail.sleepData = dic[DataValue_SleepData_HCH];
    detail.deepSleep = dic[kDeepSleep];
    detail.lightSleep = dic[kLightSleep];
    detail.pilaoData = dic[kPilaoData];
    detail.deviceID = dic[DEVICEID];
    detail.deviceType = dic[DEVICETYPE];
    detail.isUp = dic[ISUP];
    [self saveContext];
}

- (NSDictionary *)querDayDetailWithTimeSeconds:(int)seconds
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayDetail" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSString *type =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userCount = %@ AND dataDate = %d AND deviceType = %@",[HCHCommonManager getInstance].UserAcount,seconds,type];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithCapacity:11];
    if ( arr && arr.count != 0 )
    {
        DayDetail *detail = arr.firstObject;
        if (detail.dataDate) [mutDic setObject:detail.dataDate forKey:DataTime_HCH];
        if (detail.stepData) [mutDic setObject:detail.stepData forKey:kDayStepsData];
        if (detail.costsData)[mutDic setObject:detail.costsData forKey:kDayCostsData];
        if (detail.sleepData)[mutDic setObject:detail.sleepData forKey:DataValue_SleepData_HCH];
        if (detail.userCount)[mutDic setObject:detail.userCount forKey:CurrentUserName_HCH];
        if (detail.deepSleep)[mutDic setObject:detail.deepSleep forKey:kDeepSleep];
        if (detail.lightSleep)[mutDic setObject:detail.lightSleep forKey:kLightSleep];
        if (detail.pilaoData) [mutDic setObject:detail.pilaoData forKey:kPilaoData];
        if (detail.awakeSleep)[mutDic setObject:detail.awakeSleep forKey:kAwakeSleep];
        if (detail.deviceID)[mutDic setObject:detail.deviceID forKey:DEVICEID];
        if (detail.deviceType)[mutDic setObject:detail.deviceType forKey:DEVICETYPE];
        if (detail.isUp)[mutDic setObject:detail.isUp forKey:ISUP];
    }
    if (mutDic.allKeys.count != 0)
    {
        return mutDic;
    }
    return nil;
}
- (NSDictionary *)querDayDetailWithTimeSecondsToUp:(int)seconds isUp:(NSString *)isUp
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayDetail" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSString *type =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userCount = %@ AND dataDate = %d AND deviceType = %@ and isUp != %@",[HCHCommonManager getInstance].UserAcount,seconds,type,isUp];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    if ( arr && arr.count != 0 )
    {
        DayDetail *detail = arr.firstObject;
        if (detail.dataDate) [mutDic setObject:detail.dataDate forKey:DataTime_HCH];
        if (detail.stepData) [mutDic setObject:detail.stepData forKey:kDayStepsData];
        if (detail.costsData)[mutDic setObject:detail.costsData forKey:kDayCostsData];
        if (detail.sleepData)[mutDic setObject:detail.sleepData forKey:DataValue_SleepData_HCH];
        if (detail.userCount)[mutDic setObject:detail.userCount forKey:CurrentUserName_HCH];
        if (detail.deepSleep)[mutDic setObject:detail.deepSleep forKey:kDeepSleep];
        if (detail.lightSleep)[mutDic setObject:detail.lightSleep forKey:kLightSleep];
        if (detail.pilaoData) [mutDic setObject:detail.pilaoData forKey:kPilaoData];
        if (detail.awakeSleep)[mutDic setObject:detail.awakeSleep forKey:kAwakeSleep];
        if (detail.isUp)[mutDic setObject:detail.isUp forKey:ISUP];
        if (detail.deviceID)[mutDic setObject:detail.deviceID forKey:DEVICEID];
        if (detail.deviceType)[mutDic setObject:detail.deviceType forKey:DEVICETYPE];
    }
    if (mutDic.allKeys.count != 0)
    {
        return mutDic;
    }
    return nil;
    
}
- (void)deleteData
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayDetail" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"dataDate like %@",@"*1*"];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    if (arr && arr.count != 0)
    {
        for (NSManagedObject *obj in arr)
        {
            [context deleteObject:obj];
        }
    }
    [self saveContext];
    [self deleteHeartRate];
}

- (void)deleteHeartRate
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeartRate" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"dataDate like %@",@"*1*"];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    if (arr && arr.count != 0)
    {
        for (NSManagedObject *obj in arr)
        {
            [context deleteObject:obj];
        }
    }
    [self saveContext];
    
}

- (void)updataDayDetailTableWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayDetail" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userCount = %@ AND deviceType = %@  AND dataDate = %d",[HCHCommonManager getInstance].UserAcount,dic[DEVICETYPE],[dic[DataTime_HCH] intValue]];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    if (arr && arr.count != 0)
    {
        DayDetail *detail = arr.firstObject;
        detail.stepData = dic[kDayStepsData];
        detail.costsData = dic[kDayCostsData];
        detail.sleepData = dic[DataValue_SleepData_HCH];
        detail.deepSleep = dic[kDeepSleep];
        detail.lightSleep = dic[kLightSleep];
        detail.pilaoData = dic[kPilaoData];
        detail.awakeSleep = dic[kAwakeSleep];
        detail.isUp = dic[ISUP];
        detail.deviceType = dic[DEVICETYPE];
        detail.deviceID = dic[DEVICEID];
        [self saveContext];
    }
}
//上传服务器后。更新当天的详情数据
- (void)updataDayDetailDAYALLWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayDetail" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userCount = %@ AND deviceType = %@  AND dataDate = %d",[HCHCommonManager getInstance].UserAcount,dic[DEVICETYPE],[dic[DataTime_HCH] intValue]];
    [request setPredicate:pre];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    if (arr && arr.count != 0)
    {
        for (int i=0; i<arr.count; i++)
        {
            DayDetail *detail = arr[i];
            detail.stepData = dic[kDayStepsData];
            detail.costsData = dic[kDayCostsData];
            detail.sleepData = dic[DataValue_SleepData_HCH];
            detail.deepSleep = dic[kDeepSleep];
            detail.lightSleep = dic[kLightSleep];
            detail.pilaoData = dic[kPilaoData];
            detail.awakeSleep = dic[kAwakeSleep];
            detail.isUp = dic[ISUP];
            detail.deviceType = dic[DEVICETYPE];
            detail.deviceID = dic[DEVICEID];
            adaLog(@"i = %d",i);
        }
        [self saveContext];
    }
}

- (NSDictionary *)querHeartDataWithTimeSeconds:(int)seconds
{
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeartRate" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSString *type =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userCount = %@ AND deviceType = %@ AND dataDate = %d",[HCHCommonManager getInstance].UserAcount,type,seconds];
    
    [request setPredicate:pre];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    NSDictionary *dic = nil;
    if (arr && arr.count != 0)
    {
        HeartRate *heartRate = arr.firstObject;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               heartRate.userCount,CurrentUserName_HCH,
               heartRate.dataDate,DataTime_HCH,
               heartRate.heartData,HeartRate_ActualData_HCH,
               heartRate.isUp,ISUP,
               heartRate.deviceID,DEVICEID,
               heartRate.deviceType,DEVICETYPE,nil];
    }
    return dic;
}
- (NSDictionary *)querHeartDataWithTimeSecondsToUp:(int)seconds isUp:(NSString *)isUp
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeartRate" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSString *type =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userCount = %@ AND deviceType = %@ AND dataDate = %d and isUp != %@",[HCHCommonManager getInstance].UserAcount,type,seconds,isUp];
    [request setPredicate:pre];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    NSDictionary *dic = nil;
    if (arr && arr.count != 0)
    {
        HeartRate *heartRate = arr.firstObject;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               heartRate.userCount,CurrentUserName_HCH,
               heartRate.dataDate,DataTime_HCH,
               heartRate.heartData,HeartRate_ActualData_HCH,
               heartRate.isUp,ISUP,
               heartRate.deviceID,DEVICEID,
               heartRate.deviceType,DEVICETYPE,nil];
    }
    return dic;
    
}
- (void)CreatHeartRateWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext *context = self.managedObjectContext;
    HeartRate *heartrate = [NSEntityDescription insertNewObjectForEntityForName:@"HeartRate" inManagedObjectContext:context];
    heartrate.userCount = dic[CurrentUserName_HCH];
    heartrate.dataDate = dic[DataTime_HCH];
    heartrate.heartData = dic[HeartRate_ActualData_HCH];
    heartrate.isUp = dic[ISUP];
    heartrate.deviceID = dic[DEVICEID];
    heartrate.deviceType = dic[DEVICETYPE];
    [self saveContext];
}

- (void)updataHeartRateWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeartRate" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"deviceType = %@ AND userCount = %@ AND dataDate = %d ",dic[DEVICETYPE],[HCHCommonManager getInstance].UserAcount,[dic[DataTime_HCH] intValue]];
    [request setPredicate:pre];
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (arr && arr.count != 0)
    {
        HeartRate *heartRate = arr.firstObject;
        heartRate.heartData = dic[HeartRate_ActualData_HCH];
        heartRate.deviceID = dic[DEVICEID];
        heartRate.deviceType = dic[DEVICETYPE];
        heartRate.isUp = dic[ISUP];
        [self saveContext];
    }
}
//上传服务器后，更新当天的心率
- (void)updataHeartRateALLDAYWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HeartRate" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"deviceType = %@ AND userCount = %@ AND dataDate = %d ",dic[DEVICETYPE],[HCHCommonManager getInstance].UserAcount,[dic[DataTime_HCH] intValue]];
    [request setPredicate:pre];
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (arr && arr.count != 0)
    {
        for (int index=0; index<arr.count; index++)
        {
            HeartRate *heartRate = arr[index];
            heartRate.heartData = dic[HeartRate_ActualData_HCH];
            heartRate.deviceID = dic[DEVICEID];
            heartRate.deviceType = dic[DEVICETYPE];
            heartRate.isUp = dic[ISUP];
        }
        [self saveContext];
    }
}
#pragma mark - CoreData

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mainuo.keyband.coreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"keyBand" withExtension:@"momd"];
    //////adaLog(@"modelURL -- %@",modelURL);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
    
    ////adaLog(@"coreData路径 -- %@",storeURL);
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    //版本升级  改 options
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        ////adaLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //adaLog(@" 自杀 Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
