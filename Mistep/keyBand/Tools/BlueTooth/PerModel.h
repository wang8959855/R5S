//
//  PerModel.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/5.
//  Copyright © 2016年 huichenghe. All rights reserved.
//


#import <Foundation/Foundation.h>

//扫描返回数组内Model

@interface PerModel : NSObject
/**
 *  CBPeripheral对象，per.name可获得设备名称，per.identifier.UUIDString可获得设备UUID，可用于连接设备，断开设备
 */
@property (strong, nonatomic) CBPeripheral *per;
/**
 *  搜索时设备的信号值，RSSI值为负，RSSI值越大，信号强度越好
 */

@property (assign, nonatomic) int RSSI;


@property (assign, nonatomic) int type;

@property (nonatomic,copy) NSString *macAddress;// Mac address broadcasted by Bluetooth peripherals


@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,copy) NSString *UUIDString;//UUID of Bluetooth peripherals
//@property (nonatomic,copy) NSString *localName;//Manufacturer identifier of the Bluetooth peripherals
@property (nonatomic,copy) NSString *deviceName;  //修改后的名字
//@property (nonatomic,copy) NSString *passWord;//外设密码

-(NSString *)description;

@end
