//
//  BlueToothScan.h
//  健康手环
//
//  Created by szx000 on 14-11-8.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>



@protocol BlueToothScanDelegate <NSObject>


@optional

//发现设备
- (void)blueToothScanDiscoverPeripheral:(NSMutableArray *)deviceArray;

@end


@interface BlueToothScan : NSObject

@property (nonatomic , assign) id<BlueToothScanDelegate>delegate;

//开始扫描
- (void)startScan;
- (void)stopScan;
- (void)clearDeviceList;

@end
