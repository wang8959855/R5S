//
//  CoreDataManage.h
//  keyBand
//
//  Created by 迈诺科技 on 15/11/19.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "DayDetail.h"
//#import "HeartRate.h"
#import "DayDetail+CoreDataClass.h"
#import "HeartRate+CoreDataClass.h"

@interface CoreDataManage : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//DayDetail
- (void)CreatDayDetailTabelWithDic:(NSDictionary *)dic;
- (NSDictionary *)querDayDetailWithTimeSeconds:(int)seconds;
- (NSDictionary *)querDayDetailWithTimeSecondsToUp:(int)seconds isUp:(NSString *)isUp;
- (void)updataDayDetailTableWithDic:(NSDictionary *)dic;
- (void)updataDayDetailDAYALLWithDic:(NSDictionary *)dic;//上传服务器后。更新当天的详情数据

//HeartData
- (NSDictionary *)querHeartDataWithTimeSeconds:(int)seconds;
- (NSDictionary *)querHeartDataWithTimeSecondsToUp:(int)seconds isUp:(NSString *)isUp;
- (void)CreatHeartRateWithDic:(NSDictionary *)dic;
- (void)updataHeartRateWithDic:(NSDictionary *)dic;
- (void)updataHeartRateALLDAYWithDic:(NSDictionary *)dic;//上传服务器后，更新当天的心率

+ (id)shareInstance;

- (void)deleteData;
// test

@end
