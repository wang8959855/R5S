/*
 NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address Char)";
 */


#import "SQLdataManger.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "GMHeader.h"
//#import "SportModel.h"
#import "BloodPressureModel.h"
#import "SportModelMap.h"

static SQLdataManger * instance=nil;

#define SQLfileName @"person.sqlite"
#define SQLfileStep @"step.sqlite"
#define InitTableAction  1
#define WriteTableAction 2
#define WriteTable_Dictionary 3  //使用字典的形式写入
#define ReadTableAction  5

@interface SQLdataManger(){
    NSString *sqlDataPath;
    NSString *sqlStepPath;
    NSArray *contentArray;
    NSString *resourceDataPath;
}
@end

@implementation SQLdataManger

#define Int_Type_SQL  @"1"
#define Long_Type_SQL @"2"
#define DateTime_Type_SQL @"3"
#define Double_Type_SQL  @"4"
//#define Int_Type_AUTO  @"5"
#define Char_Type_SQL(x,y) [self getCharTypeSQLWithLength:x default:y]
#define Nvarchar_Type_SQL(x,y) [self getNvarcharTypeSQLWithLength:x default:y]
#define Varchar_Type_SQL(x,y) [self getVarcharTypeSQLWithLength:x default:y]
//#define adaNvarchar_Type_SQL(x,y) [self adagetNvarcharTypeSQLWithLength:x default:y]

- (void)dealloc
{
    contentArray = nil;
    sqlDataPath = nil ;
    resourceDataPath = nil ;
}

+ (SQLdataManger *)getInstance {
    if(instance == nil ) {
        @synchronized(self)
        {
            instance =  [[SQLdataManger alloc] init];
            [instance createMinuteStepTable];
            if ([[ADASaveDefaluts objectForKey:MISTEPDATABASEVERSION] integerValue] == 5)
            {
                [instance createTable];
                [instance createTableTwo];
                //                ////adaLog(@"-------------------------startInit");
                //                //dataLog(@"-------------------------startInit");
            }
            else
            {
                [instance checkUpdateDataBase:[[ADASaveDefaluts objectForKey:MISTEPDATABASEVERSION] integerValue]];
                
            }
        }
    }
    return instance;
}

+ (void)clearInstance{
    if (instance) {
        instance = nil;
        
    }
}
/**
 1 把要更改结构的那张表 A1 改名为 tempA1
 2 创建一张当前版本需要结构的表A1
 3 将tempA1 里面的有效数据 迁移到 A1中
 4 删除 tempA1
 
 */
-(void)checkUpdateDataBase:(NSInteger)DBVersion
{
    //interfaceLog(@"DBVersion = %ld",DBVersion);
    [instance createTable];
    [instance createTableTwo];
    if (DBVersion <= 2)
    {
        //adaLog(@"开始数据库的操作");
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString *fileFolder = [[HCHCommonManager getInstance] getFileStoreFolder];
        NSString *paths = [NSString stringWithFormat:@"%@/%@",fileFolder,SQLfileName];
        ////adaLog(@"数据库的路径 paths == %@",paths);
        
        resourceDataPath = [NSString stringWithFormat:@"%@", paths];
        sqlDataPath = paths;
        if ([fileManager fileExistsAtPath:paths])
        {
            FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
            //1.0  //将原始表名T1 修改为 tempT1
            //将原始表名PersonInfo_Table 修改为 tempPersonInfo_Table
            NSString *renameString1 = @"alter table PersonInfo_Table rename to tempPersonInfo_Table";
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret = [db executeUpdate:renameString1];
                if (ret == YES)
                {
                    //修改表名成功
                    //                    //dataLog(@"修改表名成功 - renameString1");
                }
                else
                {
                    //修改表名失败
                    //dataLog(@"修改表名失败 - renameString1");
                }
            }];
            
            //将原始表名DayTotalData_Table 修改为 tempDayTotalData_Table
            NSString *renameString2 = @"alter table DayTotalData_Table rename to tempDayTotalData_Table";
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret = [db executeUpdate:renameString2];
                if (ret == YES)
                {
                    //修改表名成功
                    //dataLog(@"修改表名成功 - renameString2");
                }
                else
                {
                    //修改表名失败
                    //dataLog(@"修改表名失败 - renameString2");
                }
            }];
            //将原始表名BloodPressure_Table 修改为 tempBloodPressure_Table
            NSString *renameString3 = @"alter table BloodPressure_Table rename to tempBloodPressure_Table";
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret = [db executeUpdate:renameString3];
                if (ret == YES)
                {
                    //修改表名成功
                    //dataLog(@"修改表名成功 - renameString3");
                }
                else
                {
                    //修改表名失败
                    //dataLog(@"修改表名失败 - renameString3");
                }
            }];
            //将原始表名ONLINESPORT 修改为 tempONLINESPORT
            NSString *renameString4 = @"alter table ONLINESPORT rename to tempONLINESPORT";
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret = [db executeUpdate:renameString4];
                if (ret == YES)
                {
                    //修改表名成功
                    //dataLog(@"修改表名成功 - renameString4");
                }
                else
                {
                    //修改表名失败
                    //dataLog(@"修改表名失败 - renameString4");
                }
            }];
            
            // 2.0 //创建新表T1（V2版本的新表创建）
            contentArray = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:PersonInfo_Table],
                            [NSNumber numberWithInt:DayTotalData_Table],
                            [NSNumber numberWithInt:BloodPressure_Table],
                            nil];
            for( int i=0;i<contentArray.count ;i++ )
            {
                //判断是否有表名
                NSInteger tableName = [[contentArray objectAtIndex:i] integerValue];
                
                [queue inDatabase:^(FMDatabase *db) {
                    if( ![db tableExists:[self getTableNameStringWithName:tableName]] )
                    {                        //建立第一张表:用户信息表
                        NSString *sql = [self packageSQLorder:InitTableAction withTableName:tableName];
                        BOOL res = [db executeUpdate:sql];
                        if (res)
                        {
                            //dataLog(@"DBVersion <= 2  建表成功");
                        } else {
                            //dataLog(@"DBVersion <= 2  建表失败");
                        }
                    }
                }];
            }
            
            
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sportSql = [self haveStringTableName:ONLINESPORT primaryKey:SPORTID type:@"varchar(1000)" otherColumn:@{CurrentUserName_HCH:@"varchar(10000)",ISUP:@"Char",DEVICETYPE:@"varchar(10000)",DEVICEID:@"varchar(10000)",SPORTTYPE:@"varchar(10000)",SPORTDATE:@"varchar(1000)",FROMTIME:@"varchar(1000)",TOTIME:@"varchar(1000)",STEPNUMBER:@"varchar(1000)",KCALNUMBER:@"varchar(1000)",HEARTRATE:@"blob",SPORTNAME:@"varchar(1000)"}];
                BOOL res = [db executeUpdate:sportSql];
                if (res)
                {
                    //dataLog(@"DBVersion <= 2  建表成功");
                } else {
                    //dataLog(@"DBVersion <= 2  建表失败");
                }
            }];
            
            // 3.0  //迁移数据
            NSString *toString1 = @"insert into PersonInfo_Table(Key,HeadImageURL,BornDateHCL,Male,High,Weight,PersonInfo_IsNeedTosend)  select Key,HeadImageURL,BornDateHCL,Male,High,Weight,PersonInfo_IsNeedTosend from tempPersonInfo_Table";
            NSString *toString2 = @"insert into DayTotalData_Table(CurrentUserName,DataDate,TotalSteps_DayData,TotalMeters_DayData,TotalCosts_DayData,stepsPlan,sleepPlan,TotalDeepSleep_DayData,TotalLittleSleep_DayData,TotalWarkeSleep_DayData,TotalSleepCount_DayData,TotalDayEventCount_DayData,TotalDataWeekIndex,TotalDataActivityTime_DayData,TotalDataCalm_DayData,activityCosts,calmCosts)  select CurrentUserName,DataDate,TotalSteps_DayData,TotalMeters_DayData,TotalCosts_DayData,stepsPlan,sleepPlan,TotalDeepSleep_DayData,TotalLittleSleep_DayData,TotalWarkeSleep_DayData,TotalSleepCount_DayData,TotalDayEventCount_DayData,TotalDataWeekIndex,TotalDataActivityTime_DayData,TotalDataCalm_DayData,activityCosts,calmCosts from tempDayTotalData_Table";
            NSString *toString3 = @"insert into BloodPressure_Table(BloodPressureID,CurrentUserName,BloodPressureDate,StartTime,systolicPressure,diastolicPressure,heartRateNumber,SPO2,HRV)  select BloodPressureID,CurrentUserName,BloodPressureDate,StartTime,systolicPressure,diastolicPressure,heartRateNumber,SPO2,HRV from tempBloodPressure_Table";
            NSString *toString4 = @"insert into ONLINESPORT(sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName) select sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName from tempONLINESPORT";
            
            [queue inDatabase:^(FMDatabase *db) {
                BOOL res =  [db executeUpdate:toString1];
                if (res)
                {
                    //dataLog(@"DBVersion <= 2  数据迁移成功 toString1");
                } else {
                    //dataLog(@"DBVersion <= 2  数据迁移失败 toString1");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret =  [db executeUpdate:toString2];
                if (ret)
                {
                    //dataLog(@"DBVersion <= 2  数据迁移成功 toString2");
                } else {
                    //dataLog(@"DBVersion <= 2  数据迁移失败 toString2");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret =  [db executeUpdate:toString3];
                if (ret)
                {
                    //dataLog(@"DBVersion <= 2  数据迁移成功 toString3");
                } else {
                    //dataLog(@"DBVersion <= 2  数据迁移失败 toString3");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                BOOL ret = [db executeUpdate:toString4];
                if (ret)
                {
                    //dataLog(@"DBVersion <= 2  数据迁移成功 toString4");
                } else {
                    //dataLog(@"DBVersion <= 2  数据迁移失败 toString4");
                }
            }];
            // 4.0   //删除tempT1临时表
            [queue inDatabase:^(FMDatabase *db) {
                
                NSString *dropTableStr1 = @"drop table tempPersonInfo_Table";
                BOOL booOne =  [db executeUpdate:dropTableStr1];
                if (booOne)
                {
                    //adaLog(@"删除临时数据库 ---  -  cuccess");
                }
                else
                {
                    ////adaLog(@"删除临时数据库-- - error");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                NSString *dropTableStr2 = @"drop table tempDayTotalData_Table";
                BOOL booTwo =   [db executeUpdate:dropTableStr2];
                if (booTwo)
                {
                    //adaLog(@"删除临时数据库 ---  -  cuccess");
                }
                else
                {
                    ////adaLog(@"删除临时数据库-- - error");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                NSString *dropTableStr3 = @"drop table tempBloodPressure_Table";
                BOOL booThree =   [db executeUpdate:dropTableStr3];
                if (booThree)
                {
                    //adaLog(@"删除临时数据库 ---  -  cuccess");
                }
                else
                {
                    ////adaLog(@"删除临时数据库-- - error");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                NSString *dropTableStr4 = @"drop table tempONLINESPORT";
                BOOL booFour =   [db executeUpdate:dropTableStr4];
                if (booFour)
                {
                    //adaLog(@"删除临时数据库 ---  -  cuccess");
                }
                else
                {
                    ////adaLog(@"删除临时数据库-- - error");
                }
            }];
            [ADASaveDefaluts setObject:@"3" forKey:MISTEPDATABASEVERSION];
            DBVersion = 3;
        }
        
    }
    if (DBVersion == 3)
    {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString *fileFolder = [[HCHCommonManager getInstance] getFileStoreFolder];
        NSString *paths = [NSString stringWithFormat:@"%@/%@",fileFolder,SQLfileName];
        resourceDataPath = [NSString stringWithFormat:@"%@", paths];
        sqlDataPath = paths;
        if ([fileManager fileExistsAtPath:paths])
        {
            FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
            
            //将原始表名ONLINESPORT 修改为 tempONLINESPORT
            [queue inDatabase:^(FMDatabase *db) {
                NSString *renameString4 = @"alter table ONLINESPORT rename to tempONLINESPORT";
                BOOL ret = [db executeUpdate:renameString4];
                if (ret)
                {
                    //dataLog(@"DBVersion == 3    renameString4");
                } else {
                    //dataLog(@"DBVersion == 3    renameString4");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sportSql = [self haveStringTableName:ONLINESPORT primaryKey:SPORTID type:@"varchar(1000)" otherColumn:@{CurrentUserName_HCH:@"varchar(10000)",ISUP:@"Char",DEVICETYPE:@"varchar(10000)",DEVICEID:@"varchar(10000)",SPORTTYPE:@"varchar(10000)",SPORTDATE:@"varchar(1000)",FROMTIME:@"varchar(1000)",TOTIME:@"varchar(1000)",STEPNUMBER:@"varchar(1000)",KCALNUMBER:@"varchar(1000)",HEARTRATE:@"blob",SPORTNAME:@"varchar(1000)",HAVETRAIL:@"Char",TRAILARRAY:@"blob",MOVETARGET:@"varchar(1000)",MILEAGEM:@"varchar(1000)",MILEAGEM_MAP:@"varchar(1000)",SPORTPACE:@"varchar(1000)",WHENLONG:@"varchar(1000)"}];
                BOOL res = [db executeUpdate:sportSql];
                if (res)
                {
                    //adaLog(@"DBVersion == 3    运动表  建表 success");
                } else {
                    //dataLog(@"DBVersion == 3    运动表  建表 fail");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                // 3.0  //迁移数据
                NSString *toString4 = @"insert into ONLINESPORT(sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName,isUp,deviceType,deviceID) select sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName,isUp,deviceType,deviceID from tempONLINESPORT";
                BOOL del1 = [db executeUpdate:toString4];
                if (del1)
                {
                    //dataLog(@"DBVersion == 3    运动表  迁移 success");
                } else {
                    //dataLog(@"DBVersion == 3    运动表  迁移 fail");
                }
            }];
            [queue inDatabase:^(FMDatabase *db) {
                // 4.0   //删除tempT1临时表
                NSString *dropTableStr4 = @"drop table tempONLINESPORT";
                BOOL dropRet = [db executeUpdate:dropTableStr4];
                if (dropRet)
                {
                    //adaLog(@"DBVersion == 3    运动表  删除 success");
                } else {
                    //dataLog(@"DBVersion == 3    运动表  删除 fail");
                }
            }];
            [ADASaveDefaluts setObject:@"4" forKey:MISTEPDATABASEVERSION];
            DBVersion = 4;
        }
        
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *fileFolder = [[HCHCommonManager getInstance] getFileStoreFolder];
    NSString *paths = [NSString stringWithFormat:@"%@/%@",fileFolder,SQLfileName];
    resourceDataPath = [NSString stringWithFormat:@"%@", paths];
    sqlDataPath = paths;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    if (DBVersion == 4)
    {
        //update  旧数据。设备类型1或2 新数据。设备类型001或002
        //血压
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateBlood = @"update BloodPressure_Table set deviceType = '002' where deviceType  = '2'";
            BOOL ret = [db executeUpdate:updateBlood];
            if (ret)
            {
                //adaLog(@"updateBlood  == 更新设备类型才 success");
            } else {
                
            }
        }];
        //天总数据
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateOne = @"update DayTotalData_Table set deviceType = '001' where deviceType  = '1'";
            BOOL ret = [db executeUpdate:updateOne];
            if (ret)
            {
                //adaLog(@"updateOne  == 更新设备类型才 success");
            } else {
                
            }
        }];
        //天总数据
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateOne = @"update DayTotalData_Table set deviceType = '002' where deviceType  = '2'";
            BOOL ret = [db executeUpdate:updateOne];
            if (ret)
            {
                //adaLog(@"updateOne  == 更新设备类型才 success");
            } else {
                
            }
        }];
        //运动
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateSport = @"update ONLINESPORT set deviceType = '001' where deviceType  = '1'";
            BOOL ret = [db executeUpdate:updateSport];
            if (ret)
            {
                //adaLog(@"updateSport  == 更新设备类型才 success");
            } else {
                
            }
        }];
        //运动
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateSport = @"update ONLINESPORT set deviceType = '002' where deviceType  = '2'";
            BOOL ret = [db executeUpdate:updateSport];
            if (ret)
            {
                //adaLog(@"updateSport  == 更新设备类型才 success");
            } else {
                
            }
        }];
        //PersonInfo_Table
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updatePerson = @"update PersonInfo_Table set deviceType = '001' where deviceType  = '1'";
            BOOL ret = [db executeUpdate:updatePerson];
            if (ret)
            {
                //adaLog(@"updatePerson  == 更新设备类型才 success");
            } else {
                
            }
        }];
        //PersonInfo_Table
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updatePerson = @"update PersonInfo_Table set deviceType = '002' where deviceType  = '2'";
            BOOL ret = [db executeUpdate:updatePerson];
            if (ret)
            {
                //adaLog(@"updatePerson  == 更新设备类型才 success");
            } else {
                
            }
        }];
        
        //更新数据库的null值   设备类型为null 就是001  isup=null 就是@"0"
        //        DayTotalData_Table,//天数据总览
        //        BloodPressure_Table,//血压数据表
        //        ONLINESPORT
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateDay = @"update DayTotalData_Table set deviceType = '001' where deviceType is null";
            BOOL ret = [db executeUpdate:updateDay];
            if (ret)
            {
                //adaLog(@"updateDay1  ==  success");
            } else {
                
            }
        }];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateDay = @"update BloodPressure_Table set deviceType = '002' where deviceType is null";
            BOOL ret = [db executeUpdate:updateDay];
            if (ret)
            {
                //adaLog(@"updateDay2  ==  success");
            } else {
                
            }
        }];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *updateDay = @"update ONLINESPORT set deviceType = '001' where deviceType is null";
            BOOL ret = [db executeUpdate:updateDay];
            if (ret)
            {
                //adaLog(@"updateDay3  ==  success");
            } else {
                
            }
        }];
        // isUp
        
        [queue inDatabase:^(FMDatabase *db) {
            NSString *isupDay = @"update DayTotalData_Table set isUp = '0' where isUp is null";
            BOOL ret = [db executeUpdate:isupDay];
            if (ret)
            {
                //adaLog(@"isupDay  ==  success");
            } else {
                
            }
        }];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *isupBlood = @"update BloodPressure_Table set isUp = '0' where isUp is null";
            BOOL ret = [db executeUpdate:isupBlood];
            if (ret)
            {
                //adaLog(@"isupBlood  ==  success");
            } else {
                
            }
        }];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *isupSport = @"update ONLINESPORT set isUp = '0' where isUp is null";
            BOOL ret = [db executeUpdate:isupSport];
            if (ret)
            {
                //adaLog(@"isupSport  ==  success");
            } else {
                
            }
        }];
        __block NSString *createWea = [self createTableWeather]; //创建天气的表
//        adaLog(@"createWea =%@",createWea);
        [queue inDatabase:^(FMDatabase *db) {
            
            BOOL ret = [db executeUpdate:createWea];
            if (ret)
            {
                adaLog(@"天气的表  ==  success");
            } else {
                
            }
        }];
        
        [ADASaveDefaluts setObject:@"5" forKey:MISTEPDATABASEVERSION];
        DBVersion = 5;
    }
}

- (void)updateSqlite;
{
    [self createTable];
    [self createTableTwo];
}


- (void)deleteTabel
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *fileFolder = [[HCHCommonManager getInstance] getFileStoreFolder];
    NSString *paths = [NSString stringWithFormat:@"%@/%@",fileFolder,SQLfileName];
    if ([fileManager fileExistsAtPath:paths])
    {
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
        
        //将原始表名ONLINESPORT 修改为 tempONLINESPORT
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"drop table DayTotalData_Table";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                ////adaLog(@"error when delete db table");
            } else {
                ////adaLog(@"succ to delete db table");
            }
        }];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"drop table BloodPressure_Table";
            BOOL res2 = [db executeUpdate:sql];
            if (!res2) {
                ////adaLog(@"error when delete db table time");
            } else {
                ////adaLog(@"succ to delete db table time");
            }
        }];
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"drop table ONLINESPORT";
            BOOL res3 = [db executeUpdate:sql];
            if (!res3) {
                ////adaLog(@"error when delete db table time");
            } else {
                ////adaLog(@"succ to delete db table time");
            }
            
        }];
    }
}

- (void)createTable
{
    NSString *fileFolder = [[HCHCommonManager getInstance] getFileStoreFolder];
    NSString *paths = [NSString stringWithFormat:@"%@/%@",fileFolder,SQLfileName];
    ////adaLog(@"数据库的路径 paths == %@",paths);
    
    resourceDataPath = [NSString stringWithFormat:@"%@" , paths];
    
    sqlDataPath = paths;
    
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    //将原始表名ONLINESPORT 修改为 tempONLINESPORT
    [queue inDatabase:^(FMDatabase *db) {
        
        //历史心率表
        NSString *heartRateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (array1 data, array2 data, array3 data, array4 data, array5 data, array6 data, array7 data, array8 data,date string);",HistoryHeartRateTable_SQL];
        BOOL result = [db executeUpdate:heartRateTable];
        if (result) {
            NSLog(@"历史心率表创建成功");
        } else {
            NSLog(@"历史心率表创建失败");
        }
        
        contentArray = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:PersonInfo_Table],
                        [NSNumber numberWithInt:DayTotalData_Table],
                        [NSNumber numberWithInt:BloodPressure_Table],
                        [NSNumber numberWithInt:Peripheral_Table],
                        
                        nil];
        for( int i=0;i<contentArray.count ;i++ ){
            //判断是否有表名
            NSInteger tableName = [[contentArray objectAtIndex:i] integerValue];
            
            if( ![db tableExists:[self getTableNameStringWithName:tableName]] )
            {
                //建立第一张表:用户信息表
                NSString *sql = [self packageSQLorder:InitTableAction withTableName:tableName];
                
//                adaLog(@"sql = %@",sql);
                
                BOOL res = [db executeUpdate:sql];
                if (res) {
                    adaLog(@"直接建表 ---- success =%ld",tableName);
                } else {
                    adaLog(@"直接建表 ---- fail");
                }
            }
        }
    }];
}

//创建每分钟步数表
- (void)createMinuteStepTable{
    NSString *fileFolder = [[HCHCommonManager getInstance] getFileStoreFolder];
    NSString *paths = [NSString stringWithFormat:@"%@/%@",fileFolder,SQLfileStep];
    ////adaLog(@"数据库的路径 paths == %@",paths);
    
    sqlStepPath = paths;
    
    FMDatabase *db = [FMDatabase databaseWithPath:sqlStepPath];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return;
    }
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists stepTable (Step TEXT NOT NULL, Time TEXT NOT NULL)";
    BOOL result = [db executeUpdate:sql];
    if (result) {
        NSLog(@"create table success");
        
    }
    [db close];
}

#pragma mark Package SQL order
- (NSString *)packageSQLorder:(int)orderIndex withTableName:(NSInteger)tableName{
    NSString *string = @"";
    
    NSArray *array = [self getSQLTableKeyArrayWithIndex:tableName];
    NSInteger nums = [array count]/2;
    NSString *tableString = @"";//表名
    NSString *keyString = @"";//主键
    if( nums >= 2 ){
        tableString = [array objectAtIndex:0];
        keyString = [array objectAtIndex:2];
    }else{
        return string ;
    }
    
    switch (orderIndex) {
        case InitTableAction:
        {
            string = [NSString stringWithFormat:@"CREATE TABLE '%@' " , tableString];
            //主键
            int kNums = [[array objectAtIndex:3] intValue];
            NSString *pirmkey = @"" ;
            NSString *yueshu = [self getUnionKeyWithTableName:tableName];
            if( yueshu ){
                
            }else{
                pirmkey = @"primary key";
            }
            
            switch (kNums) {
                case 0://字符
                    string = [NSString stringWithFormat:@"%@ (%@ %@ %@ " , string,keyString , [array objectAtIndex:3],pirmkey];
                    break;
                case 1://int 型
                    string = [NSString stringWithFormat:@"%@ (%@ int NOT NULL %@ " , string,keyString,pirmkey];
                    break;
                case 2://long 型
                    string = [NSString stringWithFormat:@"%@ (%@ long NOT NULL %@ " , string,keyString,pirmkey];
                    break;
                case 3://dateTime
                    string = [NSString stringWithFormat:@"%@ (%@ DATETIME NOT NULL %@ " , string,keyString,pirmkey];
                    break;
                case 4://double
                    string = [NSString stringWithFormat:@"%@ (%@ double NOT NULL %@ " , string,keyString,pirmkey];
                    break;
                case 5://   int 型  auto
                    string = [NSString stringWithFormat:@"%@ (%@  PRIMARY KEY autoincrement" , string,keyString];
                    break;
                default:
                    break;
            }
            
            for(int i =2;i<nums;i++ ){
                int fNums = [[array objectAtIndex:2*i+1]intValue];
                NSString *section = [array objectAtIndex:2*i];
                NSString *value = [array objectAtIndex:2*i + 1];
                switch (fNums) {
                    case 0:
                        string = [NSString stringWithFormat:@"%@ , '%@' %@" , string , section , value];
                        break;
                    case 1: //int 型
                        string = [NSString stringWithFormat:@"%@ , '%@' int NOT NULL DEFAULT (0)",string,section];
                        break;
                    case 2: //long 型
                        string = [NSString stringWithFormat:@"%@ , '%@' long NOT NULL DEFAULT (0)",string,section];
                        break;
                    case 3://dateTime
                        string = [NSString stringWithFormat:@"%@ , '%@' DATETIME NOT NULL",string,section];
                        break;
                    case 4://double
                        string = [NSString stringWithFormat:@"%@ , '%@' double NOT NULL DEFAULT (0)",string,section];
                        break;
                    default:
                        break;
                }
            }
            
            if( yueshu ) string = [NSString stringWithFormat:@"%@ , %@",string , yueshu];
            
            string = [NSString stringWithFormat:@"%@)",string];
        }
            break;
            
        case WriteTableAction:
        {
            string = [NSString stringWithFormat:@"insert or replace into %@ (%@" , tableString,keyString];
            for(int i =2;i<nums;i++ ){
                string = [NSString stringWithFormat:@"%@,%@",string,[array objectAtIndex:2*i]];
            }
            string = [NSString stringWithFormat:@"%@) values(?",string];
            
            for(int i=2;i<nums;i++ ){
                string = [NSString stringWithFormat:@"%@,? ",string];
            }
            string = [NSString stringWithFormat:@"%@)",string];
        }
            break;
            
        case WriteTable_Dictionary:
        {
            //insert into namedparamcounttest values (:a, :b, :c, :d)
            string = [NSString stringWithFormat:@"insert or replace into %@ values (:%@" , tableString,keyString];
            for(int i =2;i<nums;i++ ){
                string = [NSString stringWithFormat:@"%@,:%@",string,[array objectAtIndex:2*i]];
            }
            string = [NSString stringWithFormat:@"%@)",string];
        }
            break;
        default:
            break;
    }
    
    return string ;
}

- (NSString *)getUnionKeyWithTableName:(NSInteger)tableName{
    NSString *string ;
    
    switch (tableName) {
        case DayTotalData_Table:
            string = [NSString stringWithFormat:@"primary key ('%@','%@','%@')",CurrentUserName_HCH,DataTime_HCH,DEVICETYPE];
            break;
        default:
            break;
    }
    
    return string ;
}

- (NSString *)checkNULLstring:(NSString *)oriString{
    NSString *string = @"";
    if( !oriString ) return string;
    if( [oriString isKindOfClass:[NSNull class] ] ) return string ;
    string =[NSString stringWithFormat:@"%@" , oriString ];
    
    return string ;
}

#pragma mark getTableDic
//根据表名获取表所对应的表结构字段
- (NSArray *)getSQLTableKeyArrayWithIndex:(NSInteger)indexs{
    NSArray *array = nil ;
    switch (indexs) {
        case PersonInfo_Table:
            array = [NSArray arrayWithObjects:
                     @"PersonInfo_Table",Char_Type_SQL(0, nil),
                     Key_PersonInfo_HCH,Int_Type_SQL,//主键
                     HeadImageURL_PersonInfo_HCH,Char_Type_SQL(0, nil),
                     BornDate_PersonInfo_HCH,Char_Type_SQL(0, nil),
                     Male_PersonInfo_HCH,Char_Type_SQL(0, nil),
                     High_PersonInfo_HCH,Char_Type_SQL(0, nil),
                     Weight_PersonInfo_HCH,Char_Type_SQL(0, nil),
                     PersonInfo_IsNeedTosend_HCH,Int_Type_SQL,
                     ISUP,Char_Type_SQL(0, nil),
                     DEVICETYPE,Char_Type_SQL(0, nil),
                     DEVICEID,Char_Type_SQL(0, nil),
                     nil];
            break;
        case DayTotalData_Table:
            array = [NSArray arrayWithObjects:
                     @"DayTotalData_Table",Char_Type_SQL(0, nil),
                     CurrentUserName_HCH,Nvarchar_Type_SQL(20, @""),
                     DataTime_HCH,Int_Type_SQL,//主键
                     TotalSteps_DayData_HCH,Int_Type_SQL,
                     TotalMeters_DayData_HCH,Int_Type_SQL,
                     TotalCosts_DayData_HCH,Int_Type_SQL,
                     Steps_PlanTo_HCH, Int_Type_SQL,
                     Sleep_PlanTo_HCH, Int_Type_SQL,
                     TotalDeepSleep_DayData_HCH, Int_Type_SQL,
                     TotalLittleSleep_DayData_HCH, Int_Type_SQL,
                     TotalWarkeSleep_DayData_HCH, Int_Type_SQL,
                     TotalSleepCount_DayData_HCH, Int_Type_SQL,
                     TotalDayEventCount_DayData_HCH, Int_Type_SQL,
                     TotalDataWeekIndex_DayData_HCH, Int_Type_SQL,
                     TotalDataActivityTime_DayData_HCH, Int_Type_SQL,
                     TotalDataCalmTime_DayData_HCH,Int_Type_SQL,
                     kTotalDayActivityCost,Int_Type_SQL,
                     kTotalDayCalmCost,Int_Type_SQL,
                     ISUP,Char_Type_SQL(0, nil),
                     DEVICETYPE,Char_Type_SQL(0, nil),
                     DEVICEID,Char_Type_SQL(0, nil),
                     nil];
            break;
        case BloodPressure_Table:   //血压建表。字段
            array = [NSArray arrayWithObjects:
                     @"BloodPressure_Table",Char_Type_SQL(0, nil),
                     BloodPressureID_def,Nvarchar_Type_SQL(1000, @""),//主键
                     CurrentUserName_HCH,Nvarchar_Type_SQL(1000, @""),
                     BloodPressureDate_def,Nvarchar_Type_SQL(1000, @""),
                     StartTime_def,Nvarchar_Type_SQL(1000, @""),
                     systolicPressure_def,Nvarchar_Type_SQL(1000, @""),
                     diastolicPressure_def,Nvarchar_Type_SQL(1000, @""),
                     heartRateNumber_def,Nvarchar_Type_SQL(1000, @""),
                     SPO2_def,Nvarchar_Type_SQL(1000, @""),
                     HRV_def,Nvarchar_Type_SQL(1000, @""),
                     ISUP,Char_Type_SQL(0, nil),
                     DEVICETYPE,Char_Type_SQL(0, nil),
                     DEVICEID,Char_Type_SQL(0, nil),
                     nil];
            break;
        case  Peripheral_Table:  //外设表
            array = [NSArray arrayWithObjects:
                     @"Peripheral_Table",Char_Type_SQL(0, nil),//主键
                     deviceId_per,Int_Type_SQL,
                     macAddress_per,Nvarchar_Type_SQL(1000, @""),
                     UUIDString_per,Nvarchar_Type_SQL(1000, @""),
                     RSSI_per,Nvarchar_Type_SQL(1000, @""),
                     deviceName_per,Nvarchar_Type_SQL(1000, @""),
                     nil];
            break;
        default:
            break;
    }
    
    return array ;
}

- (NSString *)getTableNameStringWithName:(NSInteger)indexs{
    NSString *string = @"";
    NSArray *array = [self getSQLTableKeyArrayWithIndex:indexs];
    if( [array count] >= 4 ){
        string = [NSString stringWithFormat:@"%@" , [array objectAtIndex:0]];
    }
    
    return string ;
}


#pragma mark insertMoreDateToTable
- (BOOL)insertMoreDataToTable:(SQLTalbeNameEnum)tableName withData:(NSArray *)transArray{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    __block BOOL res = NO ;
    [queue inDatabase:^(FMDatabase *db){
        NSInteger nums = [transArray count];
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            NSString * sql = [self packageSQLorder:WriteTable_Dictionary withTableName:tableName];
            NSArray *keyArray = [self getSQLTableKeyArrayWithIndex:tableName];
            NSInteger kNums = [keyArray count]/2;
            
            for( int i =0 ;i<nums ;i++ ){
                NSDictionary *dic = [transArray objectAtIndex:i];
                NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
                for( int j = 1 ; j<kNums ;j++ ){
                    NSString *keyString = [keyArray objectAtIndex:2*j];
                    int type = [[keyArray objectAtIndex:2*j+1] intValue];
                    id value ;
                    switch (type) {
                        case 0:
                            value = [dic objectForKey:keyString];
                            if( !value ) value = @"" ;
                            else value = [NSString stringWithFormat:@"%@" , value];
                            break;
                        case 1: //int 型
                            value = [NSNumber numberWithInt:[[dic objectForKey:keyString] intValue]];
                            break;
                        case 2: //long 型
                            value = [NSNumber numberWithLongLong:[[dic objectForKey:keyString] longLongValue]];
                            break;
                        case 3: //DateTime
                        {
                            NSString *dString = [self checkNULLstring:[dic objectForKey:keyString]];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            value = [formatter dateFromString:dString];
                        }
                            break;
                        case 4://double
                            value = [NSNumber numberWithDouble:[[dic objectForKey:keyString] doubleValue]];
                            break;
                        case 5://bigint
                            value = [NSNumber numberWithLongLong:[[dic objectForKey:keyString] longLongValue]];
                            break;
                        default:
                            break;
                    }
                    
                    [mutDic setValue:value forKey:keyString];
                }
                
                res = [db executeUpdate:sql withParameterDictionary:mutDic];
            }
        }
        @catch (NSException *exception) {
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                res = YES ;
                [db commit];
            }
        }
    }];
    
    return res;
}

#pragma mark insetSignalDataToTable
- (BOOL)insertSignalDataToTable:(SQLTalbeNameEnum)tableName withData:(NSDictionary *)transDic{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    __block BOOL res = NO ;
    
    [queue inDatabase:^(FMDatabase *db){
        NSString * sql = [self packageSQLorder:WriteTable_Dictionary withTableName:tableName];
        NSArray *array = [self getSQLTableKeyArrayWithIndex:tableName];
        NSInteger nums = [array count]/2;
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
        for( int i=1;i<nums;i++ ){
            NSString *keyString = [array objectAtIndex:2*i];
            int type = [[array objectAtIndex:2*i+1] intValue];
            
            id value ;
            switch (type) {
                case 0:
                    value = [transDic objectForKey:keyString];
                    if( !value ) value = @"" ;
                    else value = [NSString stringWithFormat:@"%@" , value];
                    break;
                case 1: //int 型
                    value = [NSNumber numberWithInt:[[transDic objectForKey:keyString] intValue]];
                    break;
                case 2: //long 型
                case 5: //longint
                    value = [NSNumber numberWithLongLong:[[transDic objectForKey:keyString] longLongValue]];
                    break;
                case 3: //DateTime
                {
                    NSString *dString = [self checkNULLstring:[transDic objectForKey:keyString]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    value = [formatter dateFromString:dString];
                }
                    break;
                case 4://double
                    value = [NSNumber numberWithDouble:[[transDic objectForKey:keyString] doubleValue]];
                    break;
                    
                default:
                    break;
            }
            [mutDic setValue:value forKey:keyString];
        }
        
        res = [db executeUpdate:sql withParameterDictionary:mutDic];
    }];
    
    return res ;
}


#pragma mark
#pragma mark deleteTableInfoWithTableName
- (void)deleteTableInfoWithTableName:(SQLTalbeNameEnum)talbeName{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:talbeName];
        NSString *sql = [NSString stringWithFormat:@"delete from %@ " , tableName];
        if( [db executeUpdate:sql] ){
            ////adaLog(@"Delete %@ success" , tableName ) ;
        }else{
            ////adaLog(@"delete %@ failed" , tableName);
        }
    }];
}

#pragma mark dropTableWithName
- (BOOL)dropTableWithName:(int)tableIndex{
    
    __block  BOOL res = NO ;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    //将原始表名ONLINESPORT 修改为 tempONLINESPORT
    [queue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self getTableNameStringWithName:tableIndex];
        NSString *sql = [NSString stringWithFormat:@"drop table %@" , tableName];
        res = [db executeUpdate:sql] ;
        if( res ){
            ////adaLog(@"drop table success" ) ;
        }else{
            ////adaLog(@"drop table failed");
        }
        
    }];
    return res ;
}

//数据库封装
- (NSString *)getCharTypeSQLWithLength:(int)length default:(NSString *)defalut{
    NSString *string = @"Char";
    
    if( length > 0 ){
        string = [NSString stringWithFormat:@"%@(%d)" , string , length];
    }
    
    if( ![defalut isEqualToString:@"Not Null"] && defalut ){
        string = [NSString stringWithFormat:@"%@ NOT NULL DEFAULT '%@'" , string , defalut] ;
    }else if(defalut){
        string = [NSString stringWithFormat:@"%@ NOT NULL " , string ] ;
    }
    
    return string ;
}

- (NSString *)getNvarcharTypeSQLWithLength:(int)length default:(NSString *)defalut{
    NSString *string = @"Nvarchar";
    
    if( length > 0 ){
        string = [NSString stringWithFormat:@"%@(%d)" , string , length];
    }
    
    if( ![defalut isEqualToString:@"Not Null"] && defalut ){
        string = [NSString stringWithFormat:@"%@ NOT NULL DEFAULT '%@'" , string , defalut] ;
    }else if(defalut){
        string = [NSString stringWithFormat:@"%@ NOT NULL " , string ] ;
    }
    
    return string ;
}
- (NSString *)getVarcharTypeSQLWithLength:(int)length default:(NSString *)defalut{
    NSString *string = @"Varchar";
    
    if( length > 0 ){
        string = [NSString stringWithFormat:@"%@(%d)" , string , length];
    }
    
    if( ![defalut isEqualToString:@"Not Null"] && defalut ){
        string = [NSString stringWithFormat:@"%@ NOT NULL DEFAULT '%@'" , string , defalut] ;
    }else if(defalut){
        string = [NSString stringWithFormat:@"%@ NOT NULL " , string ] ;
    }
    
    return string ;
}


- (NSDictionary *)getCurPersonInf{
    __block NSDictionary *infoDic ;
    
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:PersonInfo_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            infoDic = [rs resultDictionary] ;
        }
    }];
    
    return infoDic ;
}

- (NSDictionary *)getTotalDataWith:(int)date{
    __block NSDictionary *infoDic ;
    
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:DayTotalData_Table];
        NSString *deviceType = [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%d' and %@ = '%@' " , tableName,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount], DataTime_HCH, date,DEVICETYPE,deviceType];
        //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            infoDic = [rs resultDictionary] ;
        }
    }];
    
    return infoDic ;
}
/*
 *根据系统的uuid的唯一标记符。取得macAddress
 *
 *
 */
- (NSDictionary *)getPeripheralWith:(NSString *)uuid
{
    __block NSDictionary *infoDic ;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:Peripheral_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'" , tableName,UUIDString_per, uuid];
        //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            infoDic = [rs resultDictionary] ;
        }
    }];
    return infoDic ;
}
/**
 
 上传数据查询 , ,获取天总数据
 日期 ，上传标记
 */
- (NSDictionary *)getTotalDataWithToUp:(int)date  isUp:(NSString *)isUp
{
    __block NSDictionary *infoDic ;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:DayTotalData_Table];
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%d'  and %@ != '%@' and %@ = '%@'" , tableName,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount], DataTime_HCH, date,ISUP,isUp,DEVICETYPE,deviceType];
        //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            infoDic = [rs resultDictionary] ;
        }
    }];
    
    return infoDic ;
}
/**
 
 上传 成功   更新数据
 日期 ，上传标记
 */
//- (void)updataTotalDataTableWithDic:(NSDictionary *)dic
//{
//
//    __block NSDictionary *infoDic ;
//    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
//    [queue inDatabase:^(FMDatabase *db){
//        NSString *tableName = [self getTableNameStringWithName:DayTotalData_Table];
//        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%d'  and %@ != '%@' " , tableName,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount], DataTime_HCH, date,ISUP,isUp];
//        //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
//
//        FMResultSet * rs = [db executeQuery:sql];
//
//        while ([rs next]) {
//            infoDic = [rs resultDictionary] ;
//        }
//    }];
//}
- (NSArray *)getAllTotalData{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    int startTime = [[TimeCallManager getInstance]getSecondsWithTimeString:@"2015/01/20" andFormat:@"yyyy/MM/dd"];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:DayTotalData_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ > '%d' order by %@ " , tableName , CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount],DataTime_HCH, startTime, DataTime_HCH];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    
    return mutArray ;
}

- (NSArray *)queryDayTotalDataWith:(NSInteger)year weekIndex:(NSInteger)week {
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:DayTotalData_Table];
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%ld' and %@ = '%@'" , tableName , CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount],TotalDataWeekIndex_DayData_HCH , (long)week,DEVICETYPE,deviceType];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            NSInteger time = [[dic objectForKey:DataTime_HCH] integerValue];
            NSInteger year_temp = [[[TimeCallManager getInstance]getYearWithSecond:time] integerValue];
            if (year == year_temp) {
                [mutArray addObject:dic];
            }
        }
    }];
    
    return mutArray ;
}
//通过日期查询血压数据
- (NSArray *)queryBloodPressureWithDay:(NSString *) time {
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:BloodPressure_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@  where %@ = '%@' and %@ = '%@'" , tableName ,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount], BloodPressureDate_def,time];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    return mutArray ;
}
/**
 *
 *上传数据查询
 *日期 ，上传标记
 *通过日期查询血压数据
 */
- (NSArray *)queryBloodPressureWithDayToUp:(NSString *)time isUp:(NSString *)isUp
{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:BloodPressure_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@  where %@ = '%@' and %@ = '%@' and %@ != '%@'" , tableName ,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount], BloodPressureDate_def, time,ISUP,isUp];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    return mutArray ;
    
}


// 查询血压数据 总数／／
- (NSInteger)queryBloodPressureALL{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:BloodPressure_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@" , tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    return [mutArray count];
}
// 查询外设数据 总数／／
- (NSInteger)queryPeripheralALL{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:Peripheral_Table];
        NSString *sql = [NSString stringWithFormat:@"select * from %@" , tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    return [mutArray count];
}
/**
 
 查询表内所有数据
 */
- (NSArray*)queryALLDataWithTable:(SQLTalbeNameEnum)talbeName
{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *tableName = [self getTableNameStringWithName:talbeName];
        NSString *sql = [NSString stringWithFormat:@"select * from %@" , tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    return mutArray;
}

#pragma mark   ---  建表    ---  建表   ---   建表


/**创建表单*/
- (void)createTableTwo
{
    [self createTableName:ONLINESPORT primaryKey:SPORTID type:@"varchar(1000)" otherColumn:@{CurrentUserName_HCH:@"varchar(10000)",ISUP:@"Char",DEVICETYPE:@"varchar(10000)",DEVICEID:@"varchar(10000)",SPORTTYPE:@"varchar(10000)",SPORTDATE:@"varchar(1000)",FROMTIME:@"varchar(1000)",TOTIME:@"varchar(1000)",STEPNUMBER:@"varchar(1000)",KCALNUMBER:@"varchar(1000)",HEARTRATE:@"blob",SPORTNAME:@"varchar(1000)",HAVETRAIL:@"Char",TRAILARRAY:@"blob",MOVETARGET:@"varchar(1000)",MILEAGEM:@"varchar(1000)",MILEAGEM_MAP:@"varchar(1000)",SPORTPACE:@"varchar(1000)",WHENLONG:@"varchar(1000)"}];
}
- (NSString *)createTableWeather
{
    return [self autoStringTableName:WEATHERTABLE primaryKey:WEATHERID type:@"integer" otherColumn:@{WEATHERTIME:@"varchar(10000)",WEATHERLOCATION:@"varchar(10000)",WEATHERCONTENT:@"blob",EXTONE:@"varchar(10000)",EXTTWO:@"varchar(10000)",EXTTHREE:@"varchar(1000)"}];
}

- (NSString*)haveStringTableName:(NSString *)name primaryKey:(NSString *)key type:(NSString *)type otherColumn:(NSDictionary *)dict
{
    //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
    NSString* sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ %@ PRIMARY KEY",name,key,type];
    for (NSString* columnName in dict) {
        sql=[sql stringByAppendingFormat:@",%@ %@",columnName,dict[columnName]];
    }
    sql=[sql stringByAppendingString:@");"];
    return sql;
}
- (NSString*)autoStringTableName:(NSString *)name primaryKey:(NSString *)key type:(NSString *)type otherColumn:(NSDictionary *)dict
{
    //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
    NSString* sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ %@ PRIMARY KEY autoincrement",name,key,type];
    for (NSString* columnName in dict) {
        sql=[sql stringByAppendingFormat:@",%@ %@",columnName,dict[columnName]];
    }
    sql=[sql stringByAppendingString:@");"];
    return sql;
}
/**建表*/
//在线运动
- (void)createTableName:(NSString *)name primaryKey:(NSString *)key type:(NSString *)type otherColumn:(NSDictionary *)dict {
    //在线运动
    //建立数据库
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
        NSString* sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ %@ PRIMARY KEY",name,key,type];
        for (NSString* columnName in dict) {
            sql=[sql stringByAppendingFormat:@",%@ %@",columnName,dict[columnName]];
        }
        sql=[sql stringByAppendingString:@");"];
        BOOL res = [db executeUpdate:sql];
        if (res) {
            //dataLog(@"运动 表  success");
            //            ////adaLog(@"Two   error when creating db table");
        } else {
            //dataLog(@"运动 表  fail");
            //            ////adaLog(@"Two   succ to creating db table");
        }
    }];
    
}
//在线运动
/**插入记录*/
- (void)insertDataWithColumns:(NSDictionary *)dic toTableName:(NSString *)tableName {
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString* columnNames=[dic.allKeys componentsJoinedByString:@","];
        NSMutableArray* xArray=[NSMutableArray array];
        for (int i=0 ; i<[dic.allKeys count] ; i++) {
            [xArray addObject:@"?"];
        }
        NSString* valueStr=[xArray componentsJoinedByString:@","];
        NSString* sql=[NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@);",tableName,columnNames,valueStr];
        ////adaLog(@"sql==%@",sql);
        BOOL res = [db executeUpdate:sql  withArgumentsInArray:dic.allValues];
        if (!res) {
            ////adaLog(@"insert   error ");
        } else {
            ////adaLog(@"insert   succ ");
        }
    }];
}
/**插入于覆盖记录*/
- (void)replaceDataWithColumns:(NSDictionary *)dic toTableName:(NSString *)tableName
{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString* columnNames=[dic.allKeys componentsJoinedByString:@","];
        NSMutableArray* xArray=[NSMutableArray array];
        for (int i=0 ; i<[dic.allKeys count] ; i++) {
            [xArray addObject:@"?"];
        }
        NSString* valueStr=[xArray componentsJoinedByString:@","];
        NSString* sql=[NSString stringWithFormat:@"REPLACE INTO %@(%@) VALUES(%@);",tableName,columnNames,valueStr];
        
        ////adaLog(@"sql==%@",sql);
        BOOL res = [db executeUpdate:sql  withArgumentsInArray:dic.allValues];
        if (res) {
             adaLog(@"REPLACE   succ ");
        } else {
             adaLog(@"REPLACE   error ");
        }
    }];
}

//在线运动
- (NSArray *)queryHeartRateDataWithDate:(NSString *)Date {
    
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *sql = [NSString stringWithFormat:@"select * from ONLINESPORT where sportDate = '%@' and %@ = '%@' and %@ = '%@'" ,Date ,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount],DEVICETYPE,deviceType];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            SportModelMap *sport = [SportModelMap  setValueWithDictionary:dic];
            [mutArray addObject:sport];
        }
    }];
    return mutArray ;
    
}
//在线运动
- (NSInteger)queryHeartRateDataWithAll{
    
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"select * from ONLINESPORT"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            [mutArray addObject:dic];
        }
    }];
    return [mutArray count] ;
}
// 查询开始时间。是否有这个运动了
- (NSArray *)queryHeartRateDataWithFromtime:(NSString *)fromTime
{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *sql = [NSString stringWithFormat:@"select * from ONLINESPORT where fromTime = '%@'  and %@ = '%@'" ,fromTime ,DEVICETYPE,deviceType];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            SportModelMap *sport = [SportModelMap  setValueWithDictionary:dic];
            [mutArray addObject:sport];
        }
    }];
    return mutArray ;
}

//在线运动  求最大的id
- (NSMutableArray *)queryMaxSportID
{
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"select sportID from ONLINESPORT"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            NSString *sport = [dic objectForKey:@"sportID"];
            [mutArray addObject:sport];
        }
    }];
    return mutArray ;
    
}

- (void)deleteDataWithTableName:(NSString *)tableName{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        
        NSString *sql = [NSString stringWithFormat:@"Delete from %@ where 1 = 1",tableName];
        if( [db executeUpdate:sql] ){
            ////adaLog(@"Delete %@ s uccess" , tableName ) ;
        }else{
            ////adaLog(@"delete %@ failed" , tableName);
        }
    }];
}
/**删除数据*/
- (void)deleteDataWithColumns:(NSDictionary *)dic fromTableName:(NSString *)tableName
{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString* sql=[NSString stringWithFormat:@"DELETE FROM %@",tableName];
        BOOL isFirst=YES;
        for (NSString* key in dic)
        {
            if (isFirst)
            {
                sql=[sql stringByAppendingString:@" WHERE "];
                isFirst=NO;
            }
            else
            {
                sql=[sql stringByAppendingString:@" AND "];
            }
            sql=[sql stringByAppendingFormat:@"%@=?",key];
        }
        sql=[sql stringByAppendingString:@";"];
        if( [db executeUpdate:sql withArgumentsInArray:dic.allValues] ){
            ////adaLog(@"Delete %@  success" , tableName ) ;
        }else{
            ////adaLog(@"delete %@ failed" , tableName);
        }
    }];
}

/**
 
 上传数据查询
 日期 ，上传标记
 */
- (NSArray *)queryHeartRateDataWithDateToUp:(NSString *)Date isUp:(NSString *)isUp
{
    
    __block NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db){
        NSString *deviceType =  [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]];
        NSString *sql = [NSString stringWithFormat:@"select * from ONLINESPORT where sportDate = '%@' and %@ = '%@' and %@ != '%@' and %@ = '%@'" ,Date ,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount],ISUP,isUp,DEVICETYPE,deviceType];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            SportModelMap *sport = [SportModelMap  setValueWithDictionary:dic];
            [mutArray addObject:sport];
        }
    }];
    return mutArray ;
    
}
/**
 插入一个数组
 */
-(void)insertMostSport:(NSArray *)array
{
    for (int i=0;i<array.count;i++)
    {
        NSDictionary *dic = [(SportModelMap *)array[i]  modelToStorageDictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
        if(!dict[@"sportID"])
        {
            NSString *str = [NSString stringWithFormat:@"%ld",[[SQLdataManger getInstance] queryHeartRateDataWithAll]];
            [dict setValue:str forKey:@"sportID"];
            [self replaceDataWithColumns:dict toTableName:ONLINESPORT];
        }
        else
        {
            [self replaceDataWithColumns:dict toTableName:ONLINESPORT];
        }
    }
    
}
/**
 插入一个血压数组
 */
-(void)insertMostBlood:(NSArray *)array
{
    for (NSDictionary *dict in array)
    {
        NSDictionary *dic = [BloodPressureModel  modelToStorageDict:dict];
        [self replaceDataWithColumns:dic toTableName:@"BloodPressure_Table"];
    }
}
    //今天天气
- (NSDictionary *)queryWeather
{
    __block NSDictionary *dict = [NSDictionary dictionary];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db)
    {
        NSString *sql = [NSString stringWithFormat:@"select * from Weather_Table where weatherId = 1"];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary] ;
            dict = dic;
        }
    }];
    return dict ;
}

//插入一条心率数据
- (void)addHistoryHeartRate:(NSArray *)array date:(NSString *)date{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db) {
        
        if ([self getHistoryHeartRateWithDate:date]) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set array1 = ?, array2 = ?,array3 = ?,array4 = ?,array5 = ?,array6 = ?,array7 = ?,array8 = ? where date = ?",HistoryHeartRateTable_SQL];
            BOOL isupdate = [db executeUpdate:sql withArgumentsInArray:array];
            if (isupdate) {
                NSLog(@"历史心率修改成功");
            }
        } else{
            NSLog(@"没有数据创建一条，创建一条数据");
            NSString *addSql = [NSString stringWithFormat:@"insert into %@ (array1,array2,array3,array4,array5,array6,array7,array8,date) values(?,?,?,?,?,?,?,?,?)",HistoryHeartRateTable_SQL];
            BOOL isInsert = [db executeUpdate:addSql,array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]];
            if (isInsert) {
                NSLog(@"历史心率插入成功");
            }
        }
    }];
    
}

//查询历史心率
- (NSArray *)getHistoryHeartRateWithDate:(NSString *)date{
    __block NSArray *arr;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where date = '%@'",HistoryHeartRateTable_SQL,date];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            NSArray *array1 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array1"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data2 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array2"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data3 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array3"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data4 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array4"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data5 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array5"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data6 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array6"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data7 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array7"] options:NSJSONReadingMutableLeaves error:nil];
            NSArray *data8 = [NSJSONSerialization JSONObjectWithData:[set dataForColumn:@"array8"] options:NSJSONReadingMutableLeaves error:nil];
            NSString *date = [set stringForColumn:@"date"];
            arr = @[array1,data2,data3,data4,data5,data6,data7,data8,date];
        }
    }];
    return arr;
}

//插入一条每分钟步数数据
- (void)addMinuteStepWith:(NSString *)step time:(NSString *)time{
    FMDatabase *db = [FMDatabase databaseWithPath:sqlStepPath];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return;
    }
    NSString *insertSql = @"insert into stepTable(Step, Time) values(?, ?)";
    BOOL result = [db executeUpdate:insertSql,step,time];
    if (result) {
        NSLog(@"insert into 'step' success");
    } else {
        NSLog(@"insert into 'step' fail");
    }
    
    [db close];
}
//查询每分钟步数数据
- (NSArray *)getMinuteStepWithTime:(NSString *)time{
    FMDatabase *db = [FMDatabase databaseWithPath:sqlStepPath];
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return @[];
    }
    FMResultSet *result = [db executeQuery:@"select * from stepTable where Time = ?" withArgumentsInArray:@[time]];
    NSMutableArray *arr = [NSMutableArray array];
    if ([result next]) {
        NSString *step = [result stringForColumn:@"Step"];
        NSString *time = [result stringForColumn:@"Time"];
        NSDictionary *dic = @{@"Step":step,@"Time":time};
        [arr addObject:dic];
    }
    [db close];
    return arr;
}

@end