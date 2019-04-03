////
////  AFNetworkReachabilityManager.m
////  Mistep
////
////  Created by 迈诺科技 on 2017/1/5.
////  Copyright © 2017年 huichenghe. All rights reserved.
////
//
//#import "AFNetworkReachabilityMana.h"
//
//
//
//@implementation AFNetworkReachabilityMana
//
//+ (AFNetworkReachabilityMana *)sharedInstancee
//{
//    static AFNetworkReachabilityMana * instance;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//        [instance startMonitor];//开始执行更新的任务
//    });
//    return instance;
//}
//
//-(void)startMonitor
//{
//    // 1.获得网络监控的管理者
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    
//    // 2.设置网络状态改变后的处理
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 当网络状态改变了, 就会调用这个block
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                // 未知网络
//                //adaLog(@"未知网络");
//                kHCH.networkStatus = AFNetworkReachabilityStatusUnknown;
//                break;
//            case AFNetworkReachabilityStatusNotReachable:// 没有网络(断网)
//                //adaLog(@"没有网络(断网)");
//                kHCH.networkStatus = AFNetworkReachabilityStatusNotReachable;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:// 手机自带网络
//                //adaLog(@"手机自带网络");
//                kHCH.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                // WIFI
//                //adaLog(@"WIFI");
//                kHCH.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
//                break;
//        }
//    }];
//    // 3.开始监控
//    [manager startMonitoring];
//    
//}
//@end
