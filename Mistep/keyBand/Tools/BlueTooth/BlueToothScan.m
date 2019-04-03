//
//  BlueToothScan.m
//  健康手环
//
//  Created by szx000 on 14-11-8.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//

#define ArraySize(ARR) ( (sizeof(ARR)) / ( sizeof(ARR[0])) )

#import "BlueToothScan.h"
#import "PerModel.h"


@interface BlueToothScan()<CBCentralManagerDelegate,CBPeripheralDelegate> {
    CBCentralManager *cbCenterManger;
    CBPeripheral *cbPeripheral;
    
    NSMutableArray *uuidArray ;
}

@end

@implementation BlueToothScan

- (void)dealloc{
    [cbCenterManger stopScan];
    cbPeripheral.delegate = nil ;
    cbCenterManger.delegate = nil ;
    cbCenterManger = nil;
    uuidArray = nil;
    if( cbPeripheral ){
        [cbCenterManger cancelPeripheralConnection:cbPeripheral];
    }
}

-(void)updateLog:(NSString *)s
{
}

- (void)startScan{
    cbCenterManger = nil;
    cbCenterManger = [[CBCentralManager alloc]initWithDelegate:self queue:nil ];
    if (uuidArray) {
        [uuidArray removeAllObjects];
    }else {
        uuidArray = [[NSMutableArray alloc]init];
    }
    //        NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"]]];
    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]];
    
    for (NSInteger index = 0; index < array.count; index++) {
        BOOL addFlag = [self addDevList:array[index] RSSI:@1 dictionary:nil];
        if (addFlag) {
            if ([_delegate respondsToSelector:@selector(blueToothScanDiscoverPeripheral:)]) {
                [_delegate blueToothScanDiscoverPeripheral:uuidArray];
            }
        }
    }
}

- (void)stopScan {
    if (cbCenterManger) {
        [cbCenterManger stopScan];
        //        [self performSelector:@selector(delaystopScan) withObject:nil afterDelay:1.f];
        [uuidArray removeAllObjects];
    }
}
//-(void)delaystopScan
//{
//    cbCenterManger = nil;
//}

#pragma mark
#pragma mark centerBlueManagere Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            [self updateLog:@"CoreBluetooth BLE hardware is Powered off"];
            break;
        case CBCentralManagerStatePoweredOn:
            [self updateLog:@"CoreBluetooth BLE hardware is Powered on and ready"];
            [cbCenterManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        case CBCentralManagerStateResetting:
            
            [self updateLog:@"CoreBluetooth BLE hardware is resetting"];
            break;
        case CBCentralManagerStateUnauthorized:
            
            [self updateLog:@"CoreBluetooth BLE state is unauthorized"];
            break;
        case CBCentralManagerStateUnknown:
            
            [self updateLog:@"CoreBluetooth BLE state is unknown"];
            break;
        case CBCentralManagerStateUnsupported:
            
            [self updateLog:@"CoreBluetooth BLE hardware is unsupported on this platform"];
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    cbPeripheral = peripheral;
    
    BOOL addFlag = FALSE;
    NSDictionary * dic = advertisementData;
    //adaLog(@"dic - %@",dic);
    addFlag = [self addDevList:peripheral RSSI:RSSI dictionary:dic];
    if (addFlag) {
        if ([_delegate respondsToSelector:@selector(blueToothScanDiscoverPeripheral:)]) {
            [_delegate blueToothScanDiscoverPeripheral:uuidArray];
        }
    }
}



- (BOOL)addDevList:(CBPeripheral *)peripheral RSSI:(NSNumber*)RSSI dictionary:(NSDictionary *)advertisementData
{
    //    NSString *name =  advertisementData[CBAdvertisementDataLocalNameKey];
    //    //    NSString *subName = [name substringToIndex:2];
    //    if ([name isEqualToString:@"R1_95a64a2630"])
    //    {
    //
    //    }
    //    NSRange rang = [name rangeOfString:@"R1_95a64a2630" options:NSCaseInsensitiveSearch];
    
    //    if (rang.location != NSNotFound)
    //    {
    //
    //    }
    //    //adaLog(@"name - %@",advertisementData[CBAdvertisementDataLocalNameKey]);
    //    //adaLog(@"mac - %@",advertisementData[CBAdvertisementDataManufacturerDataKey]);
    //    }
    if ([RSSI intValue] == 127)
    {
        return NO;
    }
    int count = (int)[uuidArray count];
    BOOL isUpdate = true;
    for (int index = 0; index < count; index++) {
        PerModel *model = [uuidArray objectAtIndex:index];
        CBPeripheral *peripheralInArray = model.per;
        NSString *llString1;
        NSString *llString2;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        llString1 = [NSString stringWithFormat:@"%@",peripheral.UUID];
        llString2 = [NSString stringWithFormat:@"%@",peripheralInArray.UUID];
#else
        llString1 = peripheral.identifier.UUIDString;
        llString2 = peripheralInArray.identifier.UUIDString;
#endif
        if ([llString1 isEqualToString:llString2]) {
            isUpdate = false;
            break;
        }
    }
    if (isUpdate) {

        NSData * data = advertisementData[CBAdvertisementDataManufacturerDataKey];
        
        int type = 0;
        if (data && data.length!=0)
        {
            Byte *macDat = (Byte *)[data bytes];
            type = macDat[1];
        }else
        {
            NSString *typeString = [ADASaveDefaluts objectForKey:peripheral.name];
            if (typeString)
            {
                type = typeString.intValue;
            }else
            {
                type = 1000;
            }
        }
        PerModel *model = [[PerModel alloc] init];
        model.per = peripheral;
        model.RSSI = [RSSI intValue];
        model.type = type;
        model.macAddress = [AllTool macDataToString:data];
 
        
        if ([model.macAddress isEqualToString:@"B60421"])
        {
            //adaLog(@"advertisementData - %@",advertisementData);
            NSAssert(![model.macAddress isEqualToString:@"B60421"],@"-----错误的macaddress");
        }
        //校验macAddress
        BOOL correct = [AllTool checkMacAddressLength:model.macAddress];
        if (!correct)
        {
            return correct;
        }
        model.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
        NSString *uuidStr = [NSString string];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        uuidStr = [NSString stringWithFormat:@"%@",peripheral.UUID];
#else
        uuidStr = peripheral.identifier.UUIDString;
#endif
        model.UUIDString = uuidStr;
        for (int i = 0 ; i < uuidArray.count; i ++)
        {
            PerModel *arryModel = uuidArray[i];
            if ([RSSI intValue] > arryModel.RSSI)
            {
                [uuidArray insertObject:model atIndex:i];
                return isUpdate;
            }
        }
        [uuidArray addObject:model];
        
    }
    return isUpdate;
}

- (void)clearDeviceList {
    if (uuidArray) {
        [uuidArray removeAllObjects];
        if ([_delegate respondsToSelector:@selector(blueToothScanDiscoverPeripheral:)]) {
            [_delegate blueToothScanDiscoverPeripheral:uuidArray];
        }
    }
}

@end
