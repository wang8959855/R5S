//  Mistep SDK
//  AppDelegate.m
//  keyBand
//
//  Created by 迈诺科技 on 15/10/30.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

/*
 *
 *	        __          _______            __
 *        /  \        |  ____  \         /  \
 *       / /\ \       | |     \ \       / /\ \
 *      / /__\ \      | |      | |     / /__\ \
 *     / /----\ \     | |      | |    / /----\ \
 *    / /      \ \    | |_____/ /    / /      \ \
 *   / /        \ \   |________/    / /        \ \
 *   Copyright (c) ada
 */

#import "AppDelegate.h"
#import "PZCityTool.h"
#import "SleepTool.h"
#import "AFAppDotNetAPIClient.h"
#import "LoginViewController.h"
#import "GuideViewController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialFacebookHandler.h"
#import "WXApi.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "HomeView.h"
#import "TodaySportMapViewController.h"
#import "XueyaViewController.h"
#import "DeviceTypeViewController.h"
#import "TodaySleepViewController.h"
#import "MoreView.h"


@interface AppDelegate ()<AVAudioSessionDelegate,AVAudioPlayerDelegate>
@end

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"\n%@\n%@\n%@",arr,reason,name);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate sendCrashLogWithCallStackSymbols:[arr componentsJoinedByString:@","] reason:reason name:name];
}

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialQQHandler setQQWithAppId:@"1106924549" appKey:@"ePtk6IhmBCxTCcf6" url:@"www.baidu.com"];
    [UMSocialWechatHandler setWXAppId:@"wxb3af538e0d180733" appSecret:@"2735eed22f85f44c8dc755884c74fe" url:@"www.baidu.com"];
    
//    [PZCityTool sharedInstance];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[PZBlueToothManager sharedInstance] setBlocks];
    //    [AFAppDotNetAPIClient startMonitor];//旧的监测网络
    [HCHCommonManager getInstance];//apple demo 监测网络
    
    [MoreView moreView];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
    if ([dic allKeys].count > 0) {
        [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    
    NSString *isFirstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpen"];
    
    if (isFirstOpen == nil) {
        GuideViewController *guide = [[GuideViewController alloc] init];
        self.window.rootViewController = guide;
        [self.window makeKeyWindow];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeGuid) name:@"ChangeGuid" object:nil];
    }
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    [self queryCrashInfo];
    
    return YES;
}

- (void)queryCrashInfo{
    //查询有没有崩溃信息
    NSDictionary *paramatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"crash"];
    if (paramatar == nil) {
        return;
    }
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:CRASH ParametersDictionary:paramatar Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"crash"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

// 通过post 或者 get 方式来将异常信息发送到服务器
- (void)sendCrashLogWithCallStackSymbols:(NSString *)callStackSymbols reason:(NSString *)reason name:(NSString *)name{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //获取版本
    NSString *version = [NSString stringWithFormat:@"%@.%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];
    
    NSDictionary *paramatar = @{@"reason":reason,@"name":name,@"callStackSymbols":callStackSymbols,@"version":version};
    
    [[NSUserDefaults standardUserDefaults] setObject:paramatar forKey:@"crash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)playbackgroud {
    
        /*
         
              这里是随便添加得一首音乐。
         
              真正的工程应该是添加一个尽可能小的音乐。。。
         
              0～1秒的
         
              没有声音的。
         
              循环播放就行。
         
              这个只是保证后台一直运行该软件。
         
              使得该软件一直处于活跃状态.
         
              你想操作的东西该在哪里操作就在哪里操作。
         
              */
    
        AVAudioSession *session = [AVAudioSession sharedInstance];
    
    /*打开应用会关闭别的播放器音乐*/
    
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    /*打开应用不影响别的播放器音乐*/
    
         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
        [session setActive:YES error:nil];
    
        //设置代理 可以处理电话打进时中断音乐播放
        [session setDelegate:self];
    
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"无声" ofType:@"m4a"];
    
        NSURL *URLPath = [[NSURL alloc] initFileURLWithPath:musicPath];
    
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:URLPath error:nil];
    
        [player prepareToPlay];
    
        [player setDelegate:self];
    
        player.numberOfLoops = -1;
    
        [player play];
    
}

- (void)ChangeGuid{
    ViewController *guide = [[ViewController alloc] init];
    self.window.rootViewController = guide;
    [self.window makeKeyWindow];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
     return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //adaLog(@"facebook == ======url=%@====sourceApplication = %@- annotation= %@",url,sourceApplication,annotation);
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [HCHCommonManager getInstance].active = NO;
    //    if ([BlueToothManager getInstance].isConnected)
    //    {
    //        [[BlueToothManager getInstance] heartRateNotifyEnable:NO];
    //    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self uploadData];
    
}

- (void)uploadData
{
    if ([HCHCommonManager getInstance].isLogin)
    {
        int timeSeconds = [[TimeCallManager getInstance]getSecondsOfCurDay];
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
        
        NSMutableArray * lastDaySleepArray= [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
        [sleepArray addObjectsFromArray:lastDaySleepArray];
        
        NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:todayDic];
        [sleepArray addObjectsFromArray:todaySleepArray];
        //        NSArray *lastDaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:lastDayDic[DataValue_SleepData_HCH]];
        //        if (lastDaySleepArray && lastDaySleepArray.count != 0)
        //        {
        //            for (int i = 126; i < 144; i ++)
        //            {
        //                [sleepArray addObject:lastDaySleepArray[i]];
        //            }
        //        }
        //        else {
        //            for (int i = 0 ; i < 18; i ++)
        //            {
        //                [sleepArray addObject:@3];
        //            }
        //        }
        
        //        NSArray *todaySleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[DataValue_SleepData_HCH]];
        //        if (todaySleepArray && todaySleepArray.count != 0)
        //        {
        //            for (int i = 0; i < 72; i ++)
        //            {
        //                [sleepArray addObject:todaySleepArray[i]];
        //            }
        //        }
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
        NSDictionary *dataDic = @{@"activity.day":formateDate,@"activity.step":[NSNumber numberWithInt:(int)step],@"activity.sleepDept":[NSNumber numberWithInt:(int)deep * 10],@"activity.sleepLight":[NSNumber numberWithInt:(int)light * 10],@"activity.sleepAweek":[NSNumber numberWithInt:(int)awake * 10],@"activity.sleepStatus":SleepState,@"activity.finishStatus":[NSNumber  numberWithInt:completion]};
        
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
                                                 //adaLog(@"%@",responseObject[@"msg"]);
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
                                                     //adaLog(@"%@",responseObject[@"msg"]);
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
                            //adaLog(@"%@",responseObject[@"msg"]);
                        }
                    }];
                    
                }
            }
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //从后台进入刷新天气
    if ([CositeaBlueTooth sharedInstance].isConnected) {
        [[PZCityTool sharedInstance] refresh];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    if ([BlueToothManager getInstance].isConnected)
    //    {
    //        [[BlueToothManager getInstance] heartRateNotifyEnable:YES];
    //        [[BlueToothManager getInstance] connectReload];
    //    }
    [HCHCommonManager getInstance].active = YES;
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [HCHCommonManager getInstance].active = NO;
    //    if ([BlueToothManager getInstance].isConnected)
    //    {
    //        [[BlueToothManager getInstance] heartRateNotifyEnable:NO];
    //    }
}
@end
