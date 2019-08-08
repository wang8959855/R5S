//
//  BlueToothManager.m
//  TestBlueToothVector
//
//  Created by zhangtan on 14-9-24.
//  Copyright (c) 2014年 zhangtan. All rights reserved.
//


#define ArraySize(ARR) ( (sizeof(ARR)) / ( sizeof(ARR[0])) )
#define Service_UUID @"FFF0"
#define OAD_Service_UUID @"FEF5"
#define HeartRate_Service_UUID ([mSystemVersion floatValue] >= 8.0 ? @"Heart Rate" : @"180D")

//#define HeartRate_Service_UUID  @"Heart Rate"
//#define HeartRate_Service_UUID  @"180D"
//#define WriteService_UDID @"FFF0"
//#define WriteCharactic_UUID  @"FFF3"

#define Charatic_UDID1 @"FFF2"   //wite
#define Notiify_Charatic @"FFF1" //notify
#define HeartRate_Notify_Charatic   @"2A37" //心率notify
#define BodySensor_Charatic   @"2A38"    //消息提醒的特征。。不使能，就是使能



#import "BlueToothManager.h"
#import "GMHeader.h"
#import "PZCityTool.h"
#import "WeatherDays.h"
#import "PerModel.h"
#import "SleepTool.h"
#import "BleTool.h"


@interface BlueToothManager()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    CBCentralManager *cbCenterManger;
    CBService *cbServices;
    CBCharacteristic *cbCharacteristcs;
//    CBPeripheral *cbPeripheral;
    
    CBCharacteristic *rdCharactic1;
    CBCharacteristic *notifyCharactic;
    CBCharacteristic *heartRateNotifyCharactic;
    CBCharacteristic *PairCharactic;
    
    
    CBCharacteristic *OAD_notifyCharactic;
    CBCharacteristic *OAD_rdCharactic_Uuid1;
    CBCharacteristic *OAD_rdCharactic_Uuid4;
    CBCharacteristic *OAD_rdCharactic_Uuid5;
    
    NSString *transString;
    
    
    NSMutableArray *uuidArray ;
    NSData *sendData;
    
    uint revTotalCount;
    uint revTotalBytes;
    BOOL isMulRev;
    NSMutableData *reviceData;
    NSData *toSendData_OAD;
    
    BOOL isPersonOper;
    //    BOOL isConnecting;
    NSTimer *myTimer;//定时连接外设
    NSTimer *weatherTimer;//天气定时器
    int connectTime;//连接了几次蓝牙
    NSTimer *hearRateTime;//定时请求当天全天心率
    
    
}

@property (nonatomic,strong) CBPeripheral *cbPeripheral;

@property (nonatomic,assign) BOOL isConnecting;
@property (nonatomic,assign) NSInteger checkPageManagerNum;//  保证一秒内 只发送一次
@property (nonatomic,assign) NSInteger queryCustomAlarmNum;//  保证一秒内 只发送一次
@property (nonatomic,assign) NSInteger queryJiuzuoAlarmNum;//  保证一秒内 只发送一次
//@property (nonatomic,assign) NSInteger queryHeartAndtiredNum;//  保证一秒内 只发送一次
@property (nonatomic,assign) NSInteger sendWeatherNum;//发送天气 保证一秒内 只发送一次

@property (nonatomic,assign) NSInteger coreBlueRefreshNum;//两秒内刷新一次

@end

@implementation BlueToothManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [cbCenterManger stopScan];
    self.cbPeripheral.delegate = nil ;
    cbCenterManger.delegate = nil ;
    cbCenterManger = nil;
    if( self.cbPeripheral ){
        [cbCenterManger cancelPeripheralConnection:self.cbPeripheral];
    }
    cbServices = nil ;
    cbCharacteristcs = nil ;
    rdCharactic1 = nil ;
    sendData = nil;
    _isSeek = 1;
    [ADASaveDefaluts setObject:@"1" forKey:SEARCHDEVICEISSEEK];//没有找到
}
static BlueToothManager *instance;
+ (BlueToothManager *)getInstance{
    
    if( !instance ){
        instance = [[BlueToothManager alloc] init];
        //        [instance initData];
    }
    return instance ;
}

+ (void)clearInstance{
    instance = nil ;
}
- (instancetype)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

- (void)initData{
    revTotalCount = 0;
    revTotalBytes = 0;
    connectTime = 0;
    _isSeek = 1;
    [ADASaveDefaluts setObject:@"1" forKey:SEARCHDEVICEISSEEK];//没有找到
    isMulRev = NO;
    reviceData = [[NSMutableData alloc]init];
    self.canPaired = YES;
    [self startScan];
    
    //初始化属性
    self.checkPageManagerNum = 0;
    self.queryCustomAlarmNum = 0;
    self.queryJiuzuoAlarmNum = 0;
    //    self.queryHeartAndtiredNum = 0;
    self.sendWeatherNum = 0;
    self.coreBlueRefreshNum = 0;
    
}

- (void)startScan{
    if(cbCenterManger)
    {
        [cbCenterManger stopScan];
    }
    cbCenterManger = nil;
    if (!cbCenterManger) {
        cbCenterManger = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
}
/**通过设备的 UUID 得到蓝牙对象的方法*/
-(CBPeripheral *)getDeviceByUUID:(NSString *)uuid{
    CBPeripheral *cb;
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:uuid];
    if(nsUUID) {
        NSArray *peripheralArray = [cbCenterManger retrievePeripheralsWithIdentifiers:@[nsUUID]];
        CBPeripheral *dev_perpheral;
        if([peripheralArray count] > 0) {
            for(CBPeripheral *peripheral in peripheralArray) {
                dev_perpheral=peripheral;
            }
            cb=dev_perpheral;
        }
    }
    return cb;
}
-(void)stopScanDevice
{
    if (cbCenterManger) {
        [cbCenterManger stopScan];
        //cbCenterManger = nil;
        [uuidArray removeAllObjects];
    }
}

//- (void)stopScan {
//    if (cbCenterManger) {
//        [cbCenterManger stopScan];
//        cbCenterManger = nil;
//    }
//}

- (void)ConnectPeripheral:(CBPeripheral *)peripheral {
    if (peripheral) {
        [cbCenterManger connectPeripheral:peripheral options:nil];
    }
}

//- (void)disConnectPeripheralWithUuid:(NSString *)uuid {
//    if ([uuid isEqualToString:self.connectUUID]) {
//        if (cbPeripheral && cbCenterManger) {
//            isPersonOper = YES;
//            [cbCenterManger cancelPeripheralConnection:cbPeripheral];
//            self.connectUUID = @"";
//            [cbCenterManger stopScan];
////            cbCenterManger = nil;
//        }
//    }
//}

-(void)updateLog:(CBCentralManagerState)s
{
    //adaLog(@"s--蓝牙状态--%ld",s);
    if (_delegate&&[_delegate respondsToSelector:@selector(callbackCBCentralManagerState:)])
    {
        [_delegate callbackCBCentralManagerState:s];
    }
}
- (void)ConnectWithUUID:(NSString *)connectUUID
{
    _isSeek = 1;//没有找到
    [ADASaveDefaluts setObject:@"1" forKey:SEARCHDEVICEISSEEK];//没有找到
    self.connectUUID = connectUUID;
    if(!cbCenterManger){return;}
    if (cbCenterManger.state!=CBManagerStatePoweredOn)
    {
        return;
    }
    CBPeripheral *cb;
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:connectUUID];
    if(nsUUID)
    {
        NSArray *peripheralArray = [cbCenterManger retrievePeripheralsWithIdentifiers:@[nsUUID]];
        CBPeripheral *dev_perpheral;
        if([peripheralArray count] > 0) {
            for(CBPeripheral *peripheral in peripheralArray) {
                dev_perpheral=peripheral;
            }
            cb=dev_perpheral;
            
        }
        
    }
    self.cbPeripheral = cb;
    //    self.connectUUID = connectUUID;
    //    _connectUUID = connectUUID;
    self.isConnecting = NO;
    if(self.cbPeripheral)
    {
        [cbCenterManger connectPeripheral:self.cbPeripheral options:nil];
        [self performSelector:@selector(connectOutTime) withObject:nil afterDelay:5.f];
        if( self.cbPeripheral.state == CBPeripheralStateConnected || self.cbPeripheral.state == CBPeripheralStateConnecting )
        {
            //adaLog(@"------------------!!!!!-----------   外设已经被连接！");
        }
        else
        {
            [cbCenterManger stopScan];
            [cbCenterManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        }
    }
    else
    {
        [cbCenterManger stopScan];
        [cbCenterManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]
                                               options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
    
    
    //    if (self.isConnected) {
    //        return;
    //    }
}
//- (void)connectDeviceTimer {
//
//    if (cbCenterManger.state == CBCentralManagerStatePoweredOff)  return;
//    //    if (_connectUUID && ![_connectUUID isEqualToString:@""] && currentWorkMode == 0 && !isConnecting) {
//    //        [self ConnectWithUUID:_connectUUID];
//    //    }
//
//
//    //    CBPeripheral *cb = [self getDeviceByUUID:self.connectUUID];
//    //    cbPeripheral = cb;
//    if (cbPeripheral != nil && ![self readDeviceIsConnect:cbPeripheral])
//    {
//
//        ++connectTime;
//        if(connectTime > 8)
//        {
//            if (_delegate&&[_delegate respondsToSelector:@selector(callbackConnectTimeAlert:)])
//            {
//                [_delegate callbackConnectTimeAlert:_connectTimeAlert];
//            }
//        }
//        //adaLog(@"定时连接");
//        //[self ConnectPeripheral:cb];
//        [cbCenterManger connectPeripheral:cbPeripheral options:nil];
//        [self performSelector:@selector(connectOutTime) withObject:nil afterDelay:5.f];
//    }
//}
//- (void)ConnectWithUUID:(NSString *)connectUUID{
//    //    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"]]];
//    NSArray *array = [cbCenterManger retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]];
//    for (NSInteger index = 0; index < array.count; index++) {
//        cbPeripheral = array[index];
//        NSString *llString;
//
//        llString = cbPeripheral.identifier.UUIDString;
//        if ([llString isEqualToString:connectUUID]) {
//            self.connectUUID = connectUUID;
//            [cbCenterManger connectPeripheral:cbPeripheral options:nil];
//            return;
//        }
//    }
//
//    if (_isConnected) {
//        return;
//    }
//    _connectUUID = connectUUID ;
//
//    isConnecting = NO;
//    if( cbPeripheral.state == CBPeripheralStateConnected || cbPeripheral.state == CBPeripheralStateConnecting ){
//    }else{
//        [cbCenterManger stopScan];
//        [cbCenterManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]
//                                               options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
//    }
//}

- (void)connectOutTime
{
    self.isConnecting = NO;
}

- (void)disConnectPeripheralWithUuid:(NSString *)uuid {
    //    if ([uuid isEqualToString:self.connectUUID]) {
    
    if (self.cbPeripheral && heartRateNotifyCharactic && notifyCharactic) {
        [self.cbPeripheral setNotifyValue:NO forCharacteristic:heartRateNotifyCharactic];
        [self.cbPeripheral setNotifyValue:NO forCharacteristic:notifyCharactic];
    }
    if (self.cbPeripheral && cbCenterManger) {
        [cbCenterManger cancelPeripheralConnection:self.cbPeripheral];
        [cbCenterManger stopScan];
    }
    isPersonOper = YES;
    self.connectUUID = @"";
    if (myTimer.isValid)
    { [myTimer invalidate]; myTimer = nil;
    }
    if (weatherTimer.isValid)
    { [weatherTimer invalidate]; weatherTimer = nil;
    }
    if (hearRateTime.isValid)
    { [hearRateTime invalidate]; hearRateTime = nil;
    }
    
    self.connectUUID = nil;
    //    }
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
    //adaLog(@"isConnected == %d",isConnected);
    self.isConnecting = NO;
    if (isConnected == NO)
    {
        [HCHCommonManager getInstance].pilaoValue = YES;
        //        [HCHCommonManager getInstance].jiuzuoValue = YES;
    }
}

#pragma mark
#pragma mark centerBlueManagere Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [HCHCommonManager getInstance].BlueToothState = central.state;
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            [self updateLog:CBCentralManagerStatePoweredOff];
            //[self updateLog:@"CoreBluetooth BLE hardware is Powered off"];
            self.isConnected = NO;
            self.sendingData = nil;
            [self.dataArray removeAllObjects];
            _isSeek = 0;
            connectTime = 0;
            [ADASaveDefaluts setObject:@"0" forKey:SEARCHDEVICEISSEEK];
            self.deviceName = nil;
            if( [_delegate respondsToSelector:@selector(blueToothManagerIsConnected: connectPeripheral:)] ){
                [_delegate blueToothManagerIsConnected:NO connectPeripheral:nil];
            }
            break;
        case CBCentralManagerStatePoweredOn:
            [self updateLog:CBCentralManagerStatePoweredOn];
            //[self updateLog:@"CoreBluetooth BLE hardware is Powered on and ready"];
            //if([ADASaveDefaluts objectForKey:kLastDeviceUUID]){
            if (!myTimer && currentWorkMode == 0) {
                myTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
            }
            connectTime = 0;
            //}
            //            [cbCenterManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]
            //                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            //                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            //            [cbCenterManger scanForPeripheralsWithServices:nil
            //                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        case CBCentralManagerStateResetting:
            [self updateLog:CBCentralManagerStateResetting];
            // [self updateLog:@"CoreBluetooth BLE hardware is resetting"];
            break;
        case CBCentralManagerStateUnauthorized:
            [self updateLog:CBCentralManagerStateUnauthorized];
            // [self updateLog:@"CoreBluetooth BLE state is unauthorized"];
            break;
        case CBCentralManagerStateUnknown:
            [self updateLog:CBCentralManagerStateUnknown];
            //  [self updateLog:@"CoreBluetooth BLE state is unknown"];
            break;
        case CBCentralManagerStateUnsupported:
            [self updateLog:CBCentralManagerStateUnsupported];
            //[self updateLog:@"CoreBluetooth BLE hardware is unsupported on this platform"];
            break;
        default:
            break;
    }
}



//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
//{
//
//}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    //    //adaLog(@"advertisementData = %@",advertisementData);
    //    NSString *name = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    //    NSString *macAddress = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
    //    //    if (![name hasPrefix:ShouHuan_DeviceName]) return;
    //    NSLog(@"device macAddress is %@", macAddress);
    
    NSString *llString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    llString = [NSString stringWithFormat:@"%@",peripheral.UUID];
#else
    llString = peripheral.identifier.UUIDString;
#endif
    
    if( !_connectUUID ){
        return;
    }else if([_connectUUID isEqualToString:llString] && !self.isConnecting){
        self.cbPeripheral = peripheral;
        [cbCenterManger connectPeripheral:self.cbPeripheral options:nil];
        self.isConnecting = YES;
        _isSeek = 2;
        [ADASaveDefaluts setObject:@"2" forKey:SEARCHDEVICEISSEEK];//找到了
        [self performSelector:@selector(connectOutTime) withObject:nil afterDelay:5.f];
    }
    //连接设备
    //[cbCenterManger connectPeripheral:cbPeripheral options:nil];//451964
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectOutTime) object:nil];
    self.cbPeripheral = peripheral;
    //停止扫描
    [cbCenterManger stopScan];
    self.deviceName = peripheral.name;
    
    NSString *llString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    llString = [NSString stringWithFormat:@"%@",peripheral.UUID];
#else
    llString = peripheral.identifier.UUIDString;
#endif
    self.connectUUID = llString;
    
    //发现services
    //设置peripheral的delegate未self非常重要，否则，didDiscoverServices无法回调
    self.cbPeripheral.delegate = self;
    //    NSArray *array = [NSArray arrayWithObjects:
    //                      [CBUUID UUIDWithString:@"FFE0"],
    //                      nil];
    [self.cbPeripheral discoverServices:nil];
    [ADASaveDefaluts setObject:@"1" forKey:CALLBACKFORTY];//不可用
    if (myTimer.isValid) {
        [myTimer invalidate];
        myTimer = nil;
    }
    self.isConnected = YES;
    kHCH.conState = YES;
    //[self updateLog:@"finding services"];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    rdCharactic1 = nil ;
    heartRateNotifyCharactic = nil;
    notifyCharactic = nil;
    self.cbPeripheral = nil;
    
    if (self.isConnected) {
        if(
           [_delegate respondsToSelector:@selector(blueToothManagerIsConnected: connectPeripheral:)]){
            [_delegate blueToothManagerIsConnected:NO connectPeripheral:nil];
        }
    }
    self.isConnected = NO;
    kHCH.conState = NO;
    _isSeek = 1;
    [ADASaveDefaluts setObject:@"1" forKey:SEARCHDEVICEISSEEK];//没有找到
    [self.dataArray removeAllObjects];
    self.sendingData = nil;
    
    isPersonOper = NO;
    revTotalCount = 0;
    revTotalBytes = 0;
    isMulRev = NO;
    //    [reviceData subdataWithRange:NSMakeRange(0, 0)];
    [reviceData replaceBytesInRange:NSMakeRange(0, reviceData.length) withBytes:NULL length:0];
    
    //    [cbCenterManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180d"],[CBUUID UUIDWithString:@"1814"]]
    //                                           options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    if (!myTimer && !isPersonOper) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timeFired:) userInfo:nil repeats:YES];
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"didDisconnectDevice" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    //adaLog(@"发出断开通知---------------------------");
    connectTime = 0;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSArray *array = [peripheral services];
    for( CBService *service in array ){
        NSString *string = [NSString stringWithFormat:@"%@",service.UUID];
        string = [self getIOS6UUID:string];
        
        //        NSLog(@"%d",service.length);
        if( [string isEqualToString:Service_UUID]){
            [peripheral discoverCharacteristics:nil forService:service];
        }
        //远程升级uuid
        if ([string isEqualToString:OAD_Service_UUID]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
        
        if ([string isEqualToString:HeartRate_Service_UUID]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    //adaLog(@"device connect");
    self.isConnected = YES;
    self.sendingData = nil;
//     adaLog(@"出现服务");
}

- (void)getcurdata {
    [self getActualData];
    [self performSelector:@selector(getcurdata) withObject:nil afterDelay:5.f];
}

- (void)phoneAlarmNotify
{//不知道为什么  申请配对
    //adaLog(@"申请配对");
    if (self.canPaired)
    {
        if (PairCharactic&&self.cbPeripheral) {
            [self.cbPeripheral setNotifyValue:NO forCharacteristic:PairCharactic];

        }
        self.canPaired = NO;
        [self performSelector:@selector(changeCanPaire) withObject:nil afterDelay:1];
        //adaLog(@"发送配对");
    }
}
- (void)changeCanPaire
{
    self.canPaired = YES;
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for( CBCharacteristic *c in service.characteristics ){
        NSString *string = [NSString stringWithFormat:@"%@",c.UUID];
        string = [self getIOS6UUID:string];
        if( [string isEqualToString:Notiify_Charatic]){
            [self.cbPeripheral setNotifyValue:YES forCharacteristic:c];
            //adaLog(@"使能数据");
            notifyCharactic = c;
        }else if( [string isEqualToString:Charatic_UDID1] ){
            rdCharactic1 = c ;
        }else if ([string isEqualToString:HeartRate_Notify_Charatic]) {
            heartRateNotifyCharactic = c;
        }else if ([string isEqualToString:BodySensor_Charatic]){
            PairCharactic = c;  //  @"2A38"    消息提醒的特征。。不使能，就是使能
        }
    }
    NSString *string = [NSString stringWithFormat:@"%@",service.UUID];
    string = [self getIOS6UUID:string];
    if( [string isEqualToString:Service_UUID]){
        [self.cbPeripheral setNotifyValue:YES forCharacteristic:notifyCharactic];
        if( [_delegate respondsToSelector:@selector(blueToothManagerIsConnected:connectPeripheral:)] ){
            [_delegate blueToothManagerIsConnected:YES connectPeripheral:peripheral];
        }
    }
    [self coreBlueRefresh];
    
//    adaLog(@"出现特征");
}
#pragma mark   - - - - -      连接蓝牙刷新 的方法
-(void)coreBlueRefresh
{
    if (self.coreBlueRefreshNum > 0)
    {
        return;
    }
    ++self.coreBlueRefreshNum;
    
    [ADASaveDefaluts setObject:@"4294967295" forKey:SUPPORTPAGEMANAGER];//支持  页面管理的默认值 页面配置
    [ADASaveDefaluts setObject:@"4294967295" forKey:SHOWPAGEMANAGER];//显示  页面管理的默认值 页面配置
    [ADASaveDefaluts setObject:@"1" forKey:SUPPORTINFORMATION];//支持信息提醒的默认值
    [ADASaveDefaluts setObject:@"0" forKey:COMPLETIONDEGREESUPPORT];
    [ADASaveDefaluts setObject:@"0" forKey:WEATHERSUPPORT];  //是否支持天气 0不支持 1支持
    [ADASaveDefaluts setObject:@"22" forKey:CUSTOMREMINDLENGTH];
    
    //[ (MAX(L(send),L(receive))/20) * P + 100 + random(0,100)] ms   (arc4random()%100)   40 改成 50 改成60
    CGFloat delayTime = 0;
    [self performSelector:@selector(notigyCharactic) withObject:nil afterDelay:0.06f];
    [self performSelector:@selector(phoneAlarmNotify) withObject:nil afterDelay:0.8f];//配对
    [self performSelector:@selector(synsCurTime) withObject:nil afterDelay:0.2f];//同步时间Max(10,6/20)*40+100+random(0,100)
    delayTime = (800/1000.);//(600/1000.)
    [self performSelector:@selector(setLanguage) withObject:nil afterDelay:delayTime];  //语言刷新Max(8,8/20)*40+100+random(0,100)
    delayTime += (700/1000.);//(520/1000.)
    [self performSelector:@selector(checkPower) withObject:nil afterDelay:delayTime];//检查电量Max(6,7/20)*40+100+random(0,100)
    delayTime += ((460+arc4random()%100)/1000.);//((340+arc4random()%100)/1000.)
    [self performSelector:@selector(supportPageManager) withObject:nil afterDelay:delayTime];  //APP查询设备能支持的参数  Max(7,11/20)*40+100+random(0,100)
    delayTime += ((520+arc4random()%100)/1000.);//((380+arc4random()%100)/1000.)
    [self performSelector:@selector(checkPageManager) withObject:nil afterDelay:delayTime];//先发送一次页面管理，没有回复就是不支持Max(7,8/20)*40+100+random(0,100)
    delayTime += ((520+arc4random()%100)/1000.);//((380+arc4random()%100)/1000.)
    [self performSelector:@selector(checkInformation) withObject:nil afterDelay:delayTime];//先发送一次信息提醒查询，没有回复就是不支持 Max(6,8/20)*40+100+random(0,100)
    delayTime += ((460+arc4random()%100)/1000.);//((340+arc4random()%100)/1000.)
    
    [self performSelector:@selector(sendBraMMDDformat) withObject:nil afterDelay:delayTime];//发送手环的显示日期的格式 日月
    delayTime += ((640+arc4random()%100)/1000.);
    [self performSelector:@selector(getCurDayTotalData) withObject:nil afterDelay:delayTime];//当天总数据Max(10,38/20)*40+100+random(0,100)
    delayTime += ((700+arc4random()%100)/1000.);//((500+arc4random()%100)/1000.)
    [self performSelector:@selector(setBindDateMa) withObject:nil afterDelay:delayTime];  //绑定数据 —— 设置计步参数 (四个内容)Max(8,10/20)*40+100+random(0,100)
    delayTime += (700/1000.);//(520/1000.)
    [self performSelector:@selector(setBindDateStateWithS) withObject:nil afterDelay:delayTime];//绑定数据
    delayTime += (700/1000.);//(520/1000.)
    [self performSelector:@selector(sendUserInfoToBind) withObject:nil afterDelay:delayTime];//设置计步参数，功能码：0x04 Max(10,6/20)*40+100+random(0,100)
    delayTime += (800/1000.);//(600/1000.)
    
    [self performSelector:@selector(checkAction) withObject:nil afterDelay:delayTime];  //查询设备是否支持某功能Max(10,11/20)*40+100+random(0,100)
    delayTime += ((700+arc4random()%100)/1000.);//((500+arc4random()%100)/1000.)
    [self performSelector:@selector(queryHeartAlarm) withObject:nil afterDelay:delayTime];//查询心率预警区间Max(7,10/20)*40+100+random(0,100)
    delayTime += ((520+arc4random()%100)/1000.);//((380+arc4random()%100)/1000.)
    [self performSelector:@selector(checkParameter) withObject:nil afterDelay:delayTime];  //APP查询设备能支持的参数 Max(9,11/20)*40+100+random(0,100)
    delayTime +=  ((640+arc4random()%100)/1000.);//((460+arc4random()%100)/1000.)
    
    //以下是全天数据
    [self performSelector:@selector(getCurDayTotalDataWithType:) withObject:@1 afterDelay:delayTime];//查询每小时数据 Max(10,202/20)*40+100+random(0,100)
    delayTime += (706/1000.);//(504/1000.)
    [self performSelector:@selector(getPilaoData) withObject:nil afterDelay:delayTime];//疲劳 Max(10,202/20)*40+100+random(0,100)
    delayTime += (800/1000);//(600/1000)
    [self performSelector:@selector(queryPhoneNotice) withObject:nil afterDelay:delayTime];//读取防丢提醒 Max(8,8/20)*40+100+random(0,100)
    delayTime += (700/1000);//(520/1000)
    [self performSelector:@selector(querySMSNotice) withObject:nil afterDelay:delayTime];//
    delayTime += (700/1000);
    
    NSString *str = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
    [self performSelector:@selector(getCurDayTotalDataWithType:) withObject:@2 afterDelay:delayTime];//查询睡眠数据 Max(10,46/20)*40+100+random(0,100)
    //adaLog(@"str = %@",str);//@"B7"
    delayTime += (800/1000);
    if (NSOrderedSame == [str compare:@"B7" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 2)])
    {
        [self performSelector:@selector(weatherRefresh) withObject:nil afterDelay:delayTime];//天气刷新 Max(50,8/20)*40+100+random(0,100)
        delayTime += 1;
        [self performSelector:@selector(setupCorrectNumber) withObject:nil afterDelay:delayTime];//设置校正值
        delayTime += (800/1000);
    }
    [self performSelector:@selector(getCurDayTotalHeartData) withObject:nil afterDelay:delayTime];//当天心率总数。8个包Max(12,1452/20)*40+100+random(0,100)   == 8个包 24.832
    
    [self performSelector:@selector(timingHeartRate) withObject:nil afterDelay:5];
   
    [self performSelector:@selector(coreBlueRefreshDelay) withObject:nil afterDelay:2]; //保证两秒内不能进入这里
}
-(void)coreBlueRefreshDelay//保证两秒后后正常使用
{
    --self.coreBlueRefreshNum;
}

- (void)setBindDateMa
{
    int unitState = kState;
    [[CositeaBlueTooth sharedInstance] setUnitStateWithState:unitState == 2];
    //    [self sendUserInfoToBind];
}
-(void)setBindDateStateWithS
{
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    [[CositeaBlueTooth sharedInstance] setBindDateStateWithState:!hasAMPM];//app设置手环的时间是12小时制或24小时制
    
}

//- (void)setBindDate
//{
//    int unitState = kState;
//    [[CositeaBlueTooth sharedInstance] setUnitStateWithState:unitState == 2];
//
//    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
//    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
//    BOOL hasAMPM = containsA.location != NSNotFound;
//    [[CositeaBlueTooth sharedInstance] setBindDateStateWithState:!hasAMPM];
//
//    [self sendUserInfoToBind];
//}

- (void)sendUserInfoToBind{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
//    adaLog(@"身高体重 = %@",dic);
    if (dic) {
        int height = [[dic objectForKey:@"height"]intValue];
        int weight = [[dic objectForKey:@"weight"]intValue];
        int male = [[dic objectForKey:@"gender"] intValue];
        int age = 25;
        NSDateFormatter *formates = [[NSDateFormatter alloc] init];
        [formates setDateFormat:@"yyyy-MM-dd"];
        NSDate *assignDate = [formates dateFromString:[dic objectForKey:@"birthdate"]];
        int time = fabs([assignDate timeIntervalSinceNow]);
        age = trunc(time/(60*60*24))/365;
        
        [[CositeaBlueTooth sharedInstance] sendUserInfoToBindWithHeight:height weight:weight male:male - 1 age:age];
    }
}
-(void)setLanguage
{
    int langage = [BleTool setLanguageTool];
    
    [self setLanguageByte:langage];
}
-(void)checkAction
{
    [ADASaveDefaluts setObject:@"44" forKey:NEWALARM];
    [ADASaveDefaluts setObject:@"0" forKey:HEARTCONTINUITY];
    //    Byte transData[] = {0x68,0x32,0x04,0x00,0x01,0x01,0x02,0x03};注意： 原来的0x01,0x02暂时保留不用。
    Byte transData[] = {0x68,checkAction_Enum,0x04,0x00,0x01,0x03,0x04,0x05};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    //    interfaceLog(@" APP查询功能支持码 ask%@",data);
    [self appendingCheckNumData:data isNeedResponse:NO];
}
-(void)checkParameter
{
    Byte transData[] = {0x68,checkAction_Enum,0x03,0x00,0x02,0x01,0x02};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    
    //     interfaceLog(@"  APP查询设备能支持的参数 ask%@",data);
    [self appendingCheckNumData:data isNeedResponse:NO];
}

//开启定时器，定时请求天气
-(void)weatherRefresh
{
    //    [HCHCommonManager getInstance].queryWeatherID = 0;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    [[PZCityTool sharedInstance] refresh];
    if (!weatherTimer)
    {
//        weatherTimer = [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(weatherRe:) userInfo:nil repeats:YES];
    }
    //    });
}
//开启定时器，定时请求天气
- (void)weatherRe:(NSTimer *)timer
{
    [[PZCityTool sharedInstance] refresh];
}
- (void)notigyCharactic
{
    if (notifyCharactic&&self.cbPeripheral) {
         [self.cbPeripheral setNotifyValue:YES forCharacteristic:notifyCharactic];
    }
   
}

- (void)queryPhoneNotice
{
    [self querySystemAlarmWithIndex:3];
}

- (void)querySMSNotice
{
    [self querySystemAlarmWithIndex:2];
}

- (void)checkRcieveDataNextHead
{
    if (reviceData.length == 0 || !reviceData) return;
    Byte headTransDat[] = {0x68};
    NSData *headData = [NSData dataWithBytes:headTransDat length:ArraySize(headTransDat)];
    
    NSRange range = [reviceData rangeOfData:headData options:NSDataSearchBackwards range:NSMakeRange(0, reviceData.length)];
    if(range.location != NSNotFound)
    {
        [reviceData replaceBytesInRange:NSMakeRange(0, range.location) withBytes:NULL length:0];
        [self recieveDataUpdate];
        
    }else
    {
        reviceData = nil;
        reviceData = [[NSMutableData alloc]init];
    }
}

- (void)recieveDataUpdate
{
    //adaLog(@"reviceData   ==  %@",reviceData);
    while(reviceData.length >= 6) {
        Byte *tempData = (Byte *)[reviceData bytes];
        if(tempData[0] != 0x68) {
            //adaLog(@"??????????  重新读取第二个头");
            [self checkRcieveDataNextHead];
            return;
        }
        int len = tempData[2] | (tempData[3] << 8); //第二个数字
        if (reviceData.length >= len+6) {
            
            int end = tempData[len + 5];
            uint checkNum = 0;
            for (int i = 0; i < len + 4; i ++)
            {
                checkNum += tempData[i];
            }
            checkNum = checkNum % 256;
            if (end == 0x16 && checkNum == tempData[len + 4])
            {
                NSData *toSendData = [reviceData subdataWithRange:NSMakeRange(0, len+6)];
                [reviceData replaceBytesInRange:NSMakeRange(0, len+6) withBytes:NULL length:0];
                //adaLog(@"recieveData == %@",toSendData);
                if (_delegate && [_delegate respondsToSelector:@selector(blueToothManagerReceiveNotifyData:)])
                {
                    [_delegate blueToothManagerReceiveNotifyData:toSendData];
                    Byte *recieveByte = (Byte *)[toSendData bytes];
                    int recieveCode = recieveByte[1] & 0x7f;
                    
                    if (_sendingData && _sendingData.length != 0)
                    {
                        Byte *sendingByte = (Byte*)[_sendingData bytes];
                        int sendCode = sendingByte[1] ;
                        if (sendCode == recieveCode || recieveCode == 73)
                        {
                            self.sendingData = nil;
                        }
                    }
                    [self blueToothWhriteTransData:nil isNeedResponse:YES];
                }
            }
            else
            {
                [reviceData replaceBytesInRange:NSMakeRange(0, 1) withBytes:NULL length:0];
                [self checkRcieveDataNextHead];
            }
        }
        else
        {
            break;
        }
    }
}

#pragma  - - - mark - - - - 接受数据的方法- -- - -- - - didUpdateValueForCharacteristic
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //adaLog(@"[characteristic value] == %@",[characteristic value]);
    
    NSString *string = [NSString stringWithFormat:@"%@",[characteristic UUID]];
    string = [self getIOS6UUID:string];
    if( [string isEqualToString:Notiify_Charatic]){
        NSData *notifyData = [characteristic value];
        [reviceData appendData:notifyData];
        [self recieveDataUpdate];
    }  else if ([string isEqualToString:HeartRate_Notify_Charatic]) {
        NSData *notifyData = [characteristic value];
        if ([_delegate respondsToSelector:@selector(blueToothManagerReceiveHeartRateNotify:)]) {
            [_delegate blueToothManagerReceiveHeartRateNotify:notifyData];
        }
    }
    
}
//配置  CBCharacteristicWriteWithResponse  才进入这个方法
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *string = [NSString stringWithFormat:@"%@",[characteristic UUID]];
    string = [self getIOS6UUID:string];
    adaLog(@"已经更新的数据   peripheral=%@characteristic=%@error=%@",peripheral,characteristic,error);
    if (sendData != nil && [string isEqualToString:Charatic_UDID1]) {
        if ([sendData length] > 20) {
            [self.cbPeripheral writeValue:[sendData subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
            NSInteger len = [sendData length];
            sendData = [sendData subdataWithRange:NSMakeRange(20, len - 20)];
        }else if([sendData length] > 0){
            NSData *data = [sendData subdataWithRange:NSMakeRange(0, sendData.length)];
            [self.cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
            sendData = [sendData subdataWithRange:NSMakeRange(0, 0)];
        }else {
            sendData = nil;
        }
    }
    
}

- (NSString *)getHexStringWithValue:(int)values{
    NSString *newHexStr = [NSString stringWithFormat:@"%x",values&0xff];
    if([newHexStr length]==1)
        newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
    else
        newHexStr = [NSString stringWithFormat:@"%@",newHexStr];
    
    newHexStr = [NSString stringWithFormat:@"0x%@",newHexStr];
    
    return newHexStr ;
}

- (NSString *)getIOS6UUID:(NSString *)string{
    NSRange rangess = [string rangeOfString:@"<" options:1];
    NSRange tRangess = [string rangeOfString:@">" options:1];
    if( rangess.location != NSNotFound ){
        string = [string substringWithRange:NSMakeRange(rangess.location+1, tRangess.location-rangess.location-1)];
        string = [string uppercaseString];
    }
    
    return string ;
}

- (void)revDataAckWith:(int) dataFunctionNum {
    int checkNum = 0x68 + dataFunctionNum;
    checkNum = checkNum % 256;
    Byte transData[] = {0x68, dataFunctionNum, 0x00, 0x00, checkNum, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}



- (void)checkPower {
    Byte transData[] = {0x68, CheckPower_Enum, 0x00, 0x00, 0x6B, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}

- (void)resetDevice
{
    Byte transData[] = {0x68,ResetDevice_Enum,0x01,0x00,0x01,0x7B,0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
    [self performSelector:@selector(synsCurTime) withObject:nil afterDelay:0.6];
}

- (void)queryHeartAlarm
{
    Byte transData[] = {0x68,HeartRateAlarm_Enum,0x01,0x00,0x02,0x7B,0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}

- (void)setHeartAlarmWithMin:(int)minHeart andMax:(int)maxHeart andState:(int)state
{
    state = !state;
    int checkNum = 0x68 + HeartRateAlarm_Enum + 0x04 + 0x01 + state + maxHeart + minHeart;
    Byte transData[] = {0x68,HeartRateAlarm_Enum,0x04,0x00,0x01,state,maxHeart,minHeart,checkNum,0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}


- (void)setStepPramWithHeight:(int)height andWeight:(int)weight andSexIndex:(int)sexIndex andAge:(int)age{
    int checkNum = 0x68 + SetStepPram_Enum + 0x04 + height + weight + age + sexIndex;
    checkNum = checkNum % 256;
    Byte transData[] = {0x68, SetStepPram_Enum, 0x04, 0x00,height,weight,sexIndex,age,checkNum, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
//    adaLog(@"设置计步参数 app set %@",lData);
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
    
}

- (void)getActualData {
    Byte transData[] = {0x68, GetActualData_Enum, 0x01, 0x00, 0x00,0x6F, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}

- (void)checkVersion {
    Byte transData[] = {0x68, CheckVersion_Enum, 0x00, 0x00, 0x6F, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}
//读取页面管理
- (void)checkPageManager {
    
    if (self.checkPageManagerNum <=0)
    {
        Byte transData[] = {0x68, PageManager_None, 0x01, 0x00, 0x02};
        NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:lData isNeedResponse:NO];
        //    [self blueToothWhriteTransData:lData isNeedResponse:NO];
        //        //adaLog(@"sendPageManager - -%@",lData);
        //        interfaceLog(@"page  读取设备页面的配置 ask %@",lData);
        self.checkPageManagerNum ++;
        [self performSelector:@selector(checkPageManagerNumber) withObject:nil afterDelay:1.0f];
    }
}
- (void)checkPageManagerNumber
{
    self.checkPageManagerNum -- ;
}
//页面管理 -- 支持那些页面
- (void)supportPageManager
{
    Byte transData[] = {0x68, PageManager_None, 0x01, 0x00, 0x03};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
    //    //adaLog(@"supportPageManager - -%@",lData);
    //   interfaceLog(@"page  APP读取设备支持的页面配置 ask %@",lData);
}
//读取信息提醒的支持
- (void)checkInformation
{
    Byte transData[] = {0x68, OpenAntiLoss_Enum, 0x02, 0x00,0x02,0x10};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    //adaLog(@"checkInformation - -%@",lData);
    
    [self appendingCheckNumData:lData isNeedResponse:NO];
}

- (void)openAntiLoss {
    Byte transData[] = {0x68, OpenAntiLoss_Enum, 0x01, 0x00, 0x01,0x6F, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}
- (void)closeAntiLoss {
    Byte transData[] = {0x68, OpenAntiLoss_Enum, 0x01, 0x00, 0x00,0x6E, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}

- (void)queryPhoneDelay
{
    Byte transData[] = {0x68,PhoneDelay_Enum,0x01,0x00,0x02,0x7D,0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}

- (void)setPhoneDelay:(int)seconds
{
    Byte transData[] = {0x68,PhoneDelay_Enum,0x02,0x00,0x01,seconds};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}

- (void)querySystemAlarmWithIndex:(int)index {
    Byte transData[] = {0x68, OpenAntiLoss_Enum, 0x02, 0x00, 0x01, index};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}

- (void)setSystemAlarmWithIndex:(int)index status:(int)status {
    Byte transData[] = {0x68, OpenAntiLoss_Enum, 0x03, 0x00, 0x00,index,status};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}


- (void)setCustomAlarmWithStatus:(int)status alarmIndex:(int)alarmIndex alarmType:(int)alarmType alarmCount:(int)alarmCount alarmtimeArray:(NSArray *)alarmtimeArray repeat:(int)repeat noticeString:(NSString *)noticeString {
    
    noticeString = [noticeString stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSData *strData = [self utf8ToUnicode:noticeString];
    //adaLog(@"test - data  - pang- %@",strData);
    NSInteger len = 0;
    if (alarmType == 6) {
        len = 5 + alarmtimeArray.count*2 +  [strData length];
    }else {
        len = 5 + alarmtimeArray.count*2;
    }
    
    NSInteger checkNum = 0x68 + CustomAlarm_Enum + len + status + alarmIndex + alarmCount + alarmType;
    Byte transData[] = {0x68, CustomAlarm_Enum, len, 0x00,status, alarmIndex, alarmType, alarmCount};
    
    NSMutableData *lData = [NSMutableData dataWithBytes:transData length:ArraySize(transData)];
    for (int index = 0; index < alarmtimeArray.count; index ++) {
        int hour = [[alarmtimeArray objectAtIndex:index] intValue];
        int min = [[[alarmtimeArray objectAtIndex:index] substringFromIndex:3] intValue];
        Byte timeData[] = {hour, min};
        checkNum = checkNum + hour + min;
        [lData appendBytes:timeData length:ArraySize(timeData)];
    }
    checkNum = checkNum + repeat;
    if (alarmType == 6) {
        Byte *dat = (Byte *)[strData bytes];
        for (int index = 0; index < strData.length; index++) {
            checkNum += dat[index];
        }
    }
    checkNum = checkNum%256;
    [lData appendBytes:&repeat length:1];
    if (alarmType == 6) {
        [lData appendData:strData];
    }
    [lData appendBytes:&checkNum length:1];
    Byte endData[] = {0x16};
    [lData appendBytes:endData length:1];
    if (rdCharactic1) {
        if (lData.length > 20)
        {
            int cishu  = (int)lData.length / 20;
            NSData *cache = lData;
            for (int inde = 0; inde <= cishu; inde++)
            {
                if (cache.length>20)
                {
                    adaLog(@"cache = %@",cache);
                    [self.cbPeripheral writeValue:[cache subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
                    cache = [cache subdataWithRange:NSMakeRange(20, cache.length - 20)];
                } else {
                    adaLog(@"cache = %@",cache);
                    [self.cbPeripheral writeValue:cache forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
                }
            }
        }
        else
        {
            [self.cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        }
    }
    //    [self  sendupdateData:lData];
    //    if (rdCharactic1) {
    //        if (lData.length > 20)
    //        {
    //            [cbPeripheral writeValue:[lData subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    //            NSData *cache = [lData subdataWithRange:NSMakeRange(20, lData.length - 20)];
    //            if ([cache length] > 20)
    //            {
    //                [cbPeripheral writeValue:[cache subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    //                cache = [cache subdataWithRange:NSMakeRange(20, cache.length - 20)];
    //                if (cache.length > 20)
    //                {
    //                    [cbPeripheral writeValue:cache forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    //                }
    //                else
    //                {
    //                }
    //            }
    //            else
    //            {
    //                [cbPeripheral writeValue:cache forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    //            }
    //
    //        }else {
    //            [cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    //        }
    //    }
}

-(NSData *)utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
    {
        NSString *cString = [NSString stringWithFormat:@"%.4x",[string characterAtIndex:i]];
        NSMutableString *mutString = [[NSMutableString alloc] initWithCapacity:4];
        [mutString appendString:[cString substringWithRange:NSMakeRange(2, 2)]];
        [mutString appendString:[cString substringWithRange:NSMakeRange(0, 2)]];
        [s appendString:mutString];
    }
    NSData *unicodeData = [self stringToHexDataWithString:s];
    return unicodeData;
}
//    把内容为16进制的字符串转换为数组
- (NSData *)stringToHexDataWithString:(NSString *)string
{
     NSAssert([string isKindOfClass:[NSString class]],@"是这个类型 = string");
    NSInteger len = [string length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}
/**
 *
 使用unicode编码，最大44个字节长度，相当于可有22个ascii或中文；如果提醒类型是1~5，则不用传递提醒语
 
 *   把内容为16进制的字符串转换为数组
 **/
+(NSData *)utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
    {
        NSString *cString = [NSString stringWithFormat:@"%.4x",[string characterAtIndex:i]];
        NSMutableString *mutString = [[NSMutableString alloc] initWithCapacity:4];
        [mutString appendString:[cString substringWithRange:NSMakeRange(2, 2)]];
        [mutString appendString:[cString substringWithRange:NSMakeRange(0, 2)]];
        [s appendString:mutString];
    }
    NSData *unicodeData = [self stringToHexDataWithString:s];
    return unicodeData;
}
//    把内容为16进制的字符串转换为数组
+ (NSData *)stringToHexDataWithString:(NSString *)string
{
     NSAssert([string isKindOfClass:[NSString class]],@"是这个类型 = string123");
    NSInteger len = [string length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}

- (void)synsCurTime {
    UInt32 seconds = (UInt32)[[NSDate date] timeIntervalSince1970] + (UInt32)[[NSTimeZone systemTimeZone] secondsFromGMT];
    //    UInt32 seconds = [[TimeCallManager getInstance]getYYYYMMDDHHmmSecondsWith:@"2014-12-24 23:58"] + 8*60*60;
    uint checkNum = 0x68 + TimeSync_Enum + (seconds & 255) + ((seconds >> 8) & 255) + ((seconds >> 16)& 255) + ((seconds >> 24)& 255) + 0x04;
    checkNum = checkNum % 256;
    Byte transData[] = {0x68, TimeSync_Enum, 0x04, 0x00, seconds,seconds >> 8,seconds >> 16,seconds >> 24,checkNum, 0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
    
}

- (void)queryCustomAlarm{
    if(self.queryCustomAlarmNum <=0)
    {
        self.queryCustomAlarmNum++;
        for (int i = 0 ; i < 8; i ++)
        {
            Byte transData[] = {0x68,CustomAlarm_Enum, 0x02,0x00,0x00,i};
            NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
            [self appendingCheckNumData:lData isNeedResponse:YES];
        }
        [self performSelector:@selector(queryCustomAlarmNumber) withObject:nil afterDelay:1.0f];
    }
}
- (void)queryCustomAlarmNumber
{
    self.queryCustomAlarmNum --;
}
- (void)closeCustomAlarmWith:(int)index {
    Byte transData[] = {0x68,CustomAlarm_Enum, 0x02,0x00,0x02,index};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:YES];
}

- (BOOL)checkRevDataValidityWith:(NSData *)recData {
     NSAssert([recData isKindOfClass:[NSData class]],@"是这个类型 = NSData");
    BOOL result = YES;
    long checkNum = 0;
    int datCount = (int)[recData length];
    Byte *dat = (Byte *)[recData bytes];
    for (int index = 0 ; index < datCount - 2; index++) {
        checkNum += dat[index];
    }
    if (checkNum % 256 != dat[datCount - 2]) {
        result = NO;
    }
    
    return result;
}
#pragma mark   - - -  多写注释
/**判断蓝牙外设连接状态的方法*/
-(BOOL)readDeviceIsConnect:(CBPeripheral *)device{
    if(device.state == CBPeripheralStateConnected) {
        return YES;//连接状态
    } else {
        return NO;//未连接状态(断开状态)
    }
}
//打开心率的命令
-(void)openHeartRate
{
    Byte transData[] = {0x68,GetActualData_Enum,0x01,0x00,0x01};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}
//定时获取数据  用于在线运动
-(void)timerGetHeartRateData
{
    Byte transData[] = {0x68,GetActualData_Enum,0x01,0x00,0x00,0x6f,0x16};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    //    [self appendingCheckNumData:lData isNeedResponse:NO];
    [self.cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
}
//关闭心率的命令
-(void)closeHeartRate
{
    Byte transData[] = {0x68,GetActualData_Enum,0x01,0x00,0x02};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}
//  收到血压数据。回复的数据
-(void)answerBloodPressure
{
    Byte transData[] = {0x68,BloodPressure_Enum,0x01,0x00,0x00}; //{0x68,0x06,0x01,0x00,0x02};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}
//  告诉设备，是否准备接收数据
-(void)readyReceive:(int)number
{
    Byte transData[] = {0x68,0x2a,0x02,0x00,0x01,number};
//    Byte transData[] = {0x68,BloodPressure_Enum,0x02,0x00,0x01,0x00};//不想接收原始数据
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}

//  回答设备，是否准备接收数据
-(void)answerReadyReceive:(int)number
{
        Byte transData[] = {0x68,0x2a,0x02,0x00,0x02,number};//不想接收原始数据
//    Byte transData[] = {0x68,BloodPressure_Enum,0x02,0x00,0x02,0x00};//不想接收原始数据
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
    //     interfaceLog(@"准备好接收血压原始数据  app answer %@",lData);
}
//  回答设备， 校正值
-(void)answerCorrectNumber
{
    int diya = [[ADASaveDefaluts objectForKey:BLOODPRESSURELOW] intValue];
    int gaoya = [[ADASaveDefaluts objectForKey:BLOODPRESSUREHIGH] intValue];
    //    40-100，收缩压90-180
    if (diya>=40 && gaoya>=90)
    {
        Byte transData[] = {0x68,BloodPressure_Enum,0x03,0x00,0x04,gaoya,diya};
        NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:lData isNeedResponse:NO];
    }
    else
    {
        
    }
}

//  回答设备手环设置APP参数
-(void)answerBraceletSetParam:(int)code
{
    Byte transData[] = {0x68,checkNewLength_Enum,0x02,0x00,code,0x00};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    //     interfaceLog(@"手环设置APP参数 app answer %@",lData);
    [self appendingCheckNumData:lData isNeedResponse:NO];
}

//  设置设备， 校正值   APP设置血压测量配置参数
-(void)setupCorrectNumber
{
    int diya = [[ADASaveDefaluts objectForKey:BLOODPRESSURELOW] intValue];
    int gaoya = [[ADASaveDefaluts objectForKey:BLOODPRESSUREHIGH] intValue];
    if (diya>0&&gaoya>0)
    {
        Byte transData[] = {0x68,BloodPressure_Enum,0x03,0x00,0x05,gaoya,diya};
        NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:lData isNeedResponse:NO];
    }
    else
    {
        
    }
}

//  set  页面管理
- (void)setupPageManager:(uint)pageString
{
    Byte b1=pageString & 0xff;
    Byte b2=(pageString>>8) & 0xff;
    Byte b3=(pageString>>16) & 0xff;
    Byte b4=(pageString>>24) & 0xff;
    Byte transData[] = {0x68, PageManager_None, 0x05, 0x00,0x01,b1,b2,b3,b4};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
    //    interfaceLog(@"page 333 APP ask %@",lData);
}
-(BOOL)sendWeatherFilter
{
    BOOL isCan = NO;
    
    NSString *str = [ADASaveDefaluts objectForKey:kLastDeviceNAME];
    //adaLog(@"strB7 = %@",str);//@"B7"
    if (NSOrderedSame == [str compare:@"B7" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 2)])
    {
        isCan = YES;
    }
    if([[ADASaveDefaluts objectForKey:WEATHERSUPPORT] intValue]==1)
    {
        isCan = YES;
    }
    return isCan;
}
-(void)sendWeather:(PZWeatherModel *)weather//发送天气
{
    //adaLog(@"       ========       发送天气");
    BOOL isYes = [self sendWeatherFilter];
    if (!isYes) {
        return;
    }
    if(self.sendWeatherNum<=0)
    {
        if (weather)
        {
            //时间
            NSMutableArray *timeArray = [AllTool weatherDateToArray:weather.weatherDate];
            //地点
            NSData *cityData = [weather.weather_city dataUsingEncoding:NSUTF8StringEncoding];
            cityData = [BleTool checkLocaleLength:cityData];
            
            NSAssert([cityData isKindOfClass:[NSData class]],@"是这个类型 = cityData weather");
            NSInteger cityDataLength = [cityData length];
            
            int hour = 0;
            if(weather.realtimeShi.length>2)
            {
                hour = [[weather.realtimeShi substringWithRange:NSMakeRange(0, 2)] intValue];
            }
            else
            {
                hour = [weather.realtimeShi intValue];
            }
            
            Byte contentByte1[] = {0x00, 0x04,hour,[timeArray[0] integerValue],[timeArray[1] integerValue],[timeArray[2] intValue]%100,0x01,[cityData length]};
            NSInteger contentByte1Length = ArraySize(contentByte1);
            NSMutableData *contentData1 = [NSMutableData dataWithBytes:contentByte1 length:ArraySize(contentByte1)];//contentData1   为主要内容的容器
            
            [contentData1 appendData:cityData];
            
            //天气内容
            NSData *weatherContentData = [weather.weatherContent dataUsingEncoding:NSUTF8StringEncoding];
            weatherContentData = [BleTool checkWeatherContentLength:weatherContentData];
            NSInteger weatherContentDataLength = weatherContentData.length;
            //天气
            Byte contentByte2[] = {0x02, 0x01,[weather.weatherType integerValue],0x03,weatherContentData.length};
            NSInteger contentByte2Length = ArraySize(contentByte2);
            NSMutableData *contentData2 = [NSMutableData dataWithBytes:contentByte2 length:ArraySize(contentByte2)];
            [contentData2  appendData:weatherContentData];
            
            [contentData1 appendData:contentData2];
            
            //温度
            Byte contentByte3[] = {0x04, 0x03,[weather.tempArray[0] integerValue],[weather.tempArray[1] integerValue],[weather.tempArray[2] integerValue],0x05,0x01,[weather.weather_uv integerValue],0x06,0x01,[weather.weather_fl integerValue],0x07,0x01,[weather.weather_fx integerValue]};
            
            NSInteger contentByte3Length = ArraySize(contentByte3);
            NSMutableData *contentData3 = [NSMutableData dataWithBytes:contentByte3 length:ArraySize(contentByte3)];
            [contentData1 appendData:contentData3];
            
            //aqi 有时有，有时没有
            NSInteger contentByte4Length = 0;
            NSMutableData *contentData4 = [NSMutableData data];
            NSInteger aqiNumber = [weather.weather_aqi integerValue];
            NSInteger aqilength = 1;
            if (aqiNumber == 1000) {
                aqilength = 0;
                Byte contentByte4[] = {0x08,aqilength};
                contentByte4Length = ArraySize(contentByte4);
                contentData4 = [NSMutableData dataWithBytes:contentByte4 length:ArraySize(contentByte4)];
            }
            else
            {
                aqilength = 1;
                Byte contentByte5[] = {0x08,aqilength,aqiNumber};
                contentByte4Length = ArraySize(contentByte5);
                contentData4 = [NSMutableData dataWithBytes:contentByte5 length:ArraySize(contentByte5)];
                
            }
            [contentData1 appendData:contentData4];
            
            
            NSInteger length = contentByte1Length + cityDataLength + contentByte2Length + weatherContentDataLength + contentByte3Length + contentByte4Length;
            Byte headByte[] = {0x68, sendWeatherSuc_Enum,length, 0x00};
            NSMutableData *headData = [NSMutableData dataWithBytes:headByte length:ArraySize(headByte)];
            [headData appendData:contentData1];
            
            
            Byte *headUseData = (Byte*)[headData bytes];
            uint checkNum = 0;
            for (int i = 0; i < headData.length; i ++)
            {
                checkNum += headUseData[i];
            }
            checkNum = checkNum%256;
            Byte footData[] = {checkNum,0x16};
            [headData appendBytes:footData length:ArraySize(footData)];
            NSData *weatherData = [[NSData alloc] initWithData:headData];
            //            adaLog(@"weatherData = %@",weatherData);
            ++self.sendWeatherNum;
            [self  sendupdateData:weatherData];
            [self performSelector:@selector(delaySendWeather) withObject:nil afterDelay:2.f];
        }
    }
    else
    {
                adaLog(@"发送天气被拦截");
    }
}
-(void)delaySendWeather
{
    --self.sendWeatherNum;
}
-(void)sendWeatherArray:(NSMutableArray *)weatherArr  day:(int)day number:(int)number//发送未来几天天气
{
    if(number>3)
    {
        number=3;
    }
    NSInteger length = number * 6 + 1;
    //温度
    Byte headByte[] = {0x68, queryWeather_Enum,length,0x00,0x02};
    NSMutableData *headData = [NSMutableData dataWithBytes:headByte length:ArraySize(headByte)];//headByte   为主要内容的容器
    
    for (int i=0; i<number; i++) {
        WeatherDays *days = weatherArr[i];
        NSInteger ri = [days.weatherDateArray[0] integerValue];
        NSInteger yue = [days.weatherDateArray[1] integerValue];
        NSInteger year = [days.weatherDateArray[2] intValue]%100;//[[days.weatherDateArray[2]  substringWithRange:NSMakeRange(2, 2)] integerValue];
        NSInteger type = [days.weatherType integerValue];
        NSInteger max =[days.weatherMax integerValue];
        NSInteger min =[days.weatherMin integerValue];
        Byte contentByte[] = {ri,yue,year%100,type,min,max};//协议改了。小的天气在前面
        //            NSMutableData *headData = [NSMutableData dataWithBytes:headByte length:ArraySize(headByte)];
        [headData appendBytes:contentByte length:ArraySize(contentByte)];
    }
    Byte *headUseData = (Byte*)[headData bytes];
    uint checkNum = 0;
    for (int i = 0; i < headData.length; i ++)
    {
        checkNum += headUseData[i];
    }
    checkNum = checkNum%256;
    Byte footData[] = {checkNum,0x16};
    [headData appendBytes:footData length:ArraySize(footData)];
    NSData *daysData = [[NSData alloc] initWithData:headData];
    adaLog(@"未来几天的数据 - daysData - %@",daysData);
    [self  sendupdateData:daysData];
    
    
}
-(void)sendOneDayWeather:(PZWeatherModel *)weather//发送某天天气   今天
{
    if (weather)
    {
        //以下是内容的拼接
        //时间
        NSMutableArray *timeArray = [AllTool  weatherDateToArray:weather.weatherDate];
        //地点
        NSData *cityData = [weather.weather_city dataUsingEncoding:NSUTF8StringEncoding];
        cityData = [BleTool checkLocaleLength:cityData];    //地点  最大24个字节  地点的长度不能太长
        NSInteger cityDataLength = [cityData length];
        
        int hour = 0;
        if(weather.realtimeShi.length>2)
        {
            hour = [[weather.realtimeShi substringWithRange:NSMakeRange(0, 2)] intValue];
        }
        else
        {
            hour = [weather.realtimeShi intValue];
        }
        
        Byte contentByte1[] = {0x01,0x00, 0x04,hour,[timeArray[0] integerValue],[timeArray[1] integerValue],[timeArray[2] intValue]%100,0x01,[cityData length]};
        NSInteger contentByte1Length = ArraySize(contentByte1);
        NSMutableData *contentData1 = [NSMutableData dataWithBytes:contentByte1 length:ArraySize(contentByte1)];//contentData1   为主要内容的容器
        
        
        [contentData1 appendData:cityData];
        
        //天气内容
        NSData *weatherContentData = [weather.weatherContent dataUsingEncoding:NSUTF8StringEncoding];
        weatherContentData = [BleTool checkWeatherContentLength:weatherContentData];  //天气内容  最大48个字节
        NSInteger weatherContentDataLength = weatherContentData.length;
        //天气
        Byte contentByte2[] = {0x02, 0x01,[weather.weatherType integerValue],0x03,weatherContentData.length};
        NSInteger contentByte2Length = ArraySize(contentByte2);
        NSMutableData *contentData2 = [NSMutableData dataWithBytes:contentByte2 length:ArraySize(contentByte2)];
        [contentData2  appendData:weatherContentData];
        
        [contentData1 appendData:contentData2];
        
        //温度
        Byte contentByte3[] = {0x04, 0x03,[weather.tempArray[0] integerValue],[weather.tempArray[1] integerValue],[weather.tempArray[2] integerValue],0x05,0x01,[weather.weather_uv integerValue],0x06,0x01,[weather.weather_fl integerValue],0x07,0x01,[weather.weather_fx integerValue]};
        NSInteger contentByte3Length = ArraySize(contentByte3);
        NSMutableData *contentData3 = [NSMutableData dataWithBytes:contentByte3 length:ArraySize(contentByte3)];
        
        [contentData1 appendData:contentData3];
        
        //aqi 有时有，有时没有  ,0x08,0x01,[weather.weather_aqi integerValue]
        NSInteger contentByte4Length = 0;
        NSMutableData *contentData4 = [NSMutableData data];
        NSInteger aqiNumber = [weather.weather_aqi integerValue];
        NSInteger aqilength = 1;
        if (aqiNumber == 1000) {
            aqilength = 0;
            Byte contentByte4[] = {0x08,aqilength};
            contentByte4Length = ArraySize(contentByte4);
            contentData4 = [NSMutableData dataWithBytes:contentByte4 length:ArraySize(contentByte4)];
        }
        else
        {
            aqilength = 1;
            Byte contentByte5[] = {0x08,aqilength,aqiNumber};
            contentByte4Length = ArraySize(contentByte5);
            contentData4 = [NSMutableData dataWithBytes:contentByte5 length:ArraySize(contentByte5)];
            
        }
        [contentData1 appendData:contentData4];
        
        
        
        
        //总长度
        NSInteger length = contentByte1Length + cityDataLength + contentByte2Length + weatherContentDataLength + contentByte3Length + contentByte4Length;
        Byte headByte[] = {0x68, queryWeather_Enum,length, 0x00};
        NSMutableData *headData = [NSMutableData dataWithBytes:headByte length:ArraySize(headByte)];
        [headData appendData:contentData1];
        
        
        Byte *headUseData = (Byte*)[headData bytes];
        uint checkNum = 0;
        for (int i = 0; i < headData.length; i ++)
        {
            checkNum += headUseData[i];
        }
        checkNum = checkNum%256;
        Byte footData[] = {checkNum,0x16};
        [headData appendBytes:footData length:ArraySize(footData)];
        NSData *mouData = [[NSData alloc] initWithData:headData];
        adaLog(@"mouData = %@",mouData);
        [self  sendupdateData:mouData];
    }
}
-(void)sendOneDayWeatherTwo:(WeatherDay *)weather//发送某天天气   某天   < 6
{
    
    if (weather)
    {               //以下是内容的拼接
        //时间
        NSData *wea = [weather.weatherContent dataUsingEncoding:NSUTF8StringEncoding];
        
        Byte startByte[] = {0x01, 0x00,0x00,0x01,0x00,0x02,0x01,[weather.weatherType intValue],0x03,wea.length};
        NSMutableData *startData =[[NSMutableData alloc]initWithBytes:startByte length:ArraySize(startByte)];
        
        [startData appendData:wea];
        
        Byte twoByte[] = {0x04,0x02,[weather.temp_num_Min intValue],[weather.temp_num_Max intValue],0x05,0x00,0x06,0x01,[weather.fl_num intValue],0x07,0x01,[weather.fx_num intValue],0x08,0x00};
        [startData appendBytes:twoByte length:ArraySize(twoByte)];
        //总长度
        NSInteger length = startData.length;
        Byte headByte[] = {0x68, queryWeather_Enum,length, 0x00};
        NSMutableData *headData = [[NSMutableData alloc]initWithBytes:headByte length:ArraySize(headByte)];
        [headData appendData:startData];
        
        
        Byte *headUseData = (Byte*)[headData bytes];
        uint checkNum = 0;
        for (int i = 0; i < headData.length; i ++)
        {
            checkNum += headUseData[i];
        }
        checkNum = checkNum%256;
        Byte footData[] = {checkNum,0x16};
        [headData appendBytes:footData length:ArraySize(footData)];
        [self  sendupdateData:[[NSData alloc] initWithData:headData]];
    }
}

#pragma mark
#pragma mark OAD operate

- (void)revDataAckWith:(int) dataFunctionNum andDat:(NSData *)data {
    int checkNum = 0x68 + dataFunctionNum;
    Byte *dataByte = (Byte *)[data bytes];
    for (int index = 0; index < data.length; index++) {
        checkNum += dataByte[index];
    }
    checkNum += data.length;
    checkNum = checkNum % 256;
    Byte transData[] = {0x68, dataFunctionNum, data.length, 0x00};
    NSMutableData *lData = [NSMutableData dataWithBytes:transData length:ArraySize(transData)];
    [lData appendData:data];
    Byte endData[] = {checkNum, 0x16};
    [lData appendBytes:endData length:ArraySize(endData)];
    [self blueToothWhriteTransData:lData isNeedResponse:NO];
}
//- (void)returnDataWithFlag:(int)flag andDat:(NSData *)data {
//    int checkNum = 0x68 + 0x08 + 0x04 + flag;
//    Byte *dataByte = (Byte *)[data bytes];
//    for (int index = 0; index < data.length; index++) {
//        checkNum += dataByte[index];
//    }
//    //checkNum += data.length;
//    checkNum = checkNum % 256;
//    Byte transData[] = {0x68, 0x08, 0x04, 0x00,flag,0x00};
//    NSMutableData *lData = [NSMutableData dataWithBytes:transData length:ArraySize(transData)];
//    [lData appendData:data];
//    Byte endData[] = {checkNum, 0x16};
//    [lData appendBytes:endData length:ArraySize(endData)];
//    [self blueToothWhriteTransData:lData isNeedResponse:NO];
//}

- (void)responseExceptionData
{
    Byte transData[] = {0x68,ExceptioncodeData_Enum,0x02,0x00,0x01,0x00};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
}
//发送手环的显示日期的格式 日月
- (void)sendBraMMDDformat
{
    Byte transData[] = {0x68,UnitSet_Enum,0x03,0x00,0x01,0x05,([BleTool getMMDDformat]-1)};
    NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:lData isNeedResponse:NO];
    
}
- (void)getCurDayTotalData {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    now=[NSDate date];
    NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
    Byte transData[] = {0x68,UpdateTotalData_Enum, 0x04,0x00, [comps day],[comps month], [comps year]%100,0x00};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:YES];
}

- (void)getCurDayTotalDataWithType:(NSNumber *)type {
    int intType = [type intValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    now=[NSDate date];
    NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
    Byte transData[] = {0x68,UpdateTotalData_Enum, 0x04,0x00, [comps day],[comps month], [comps year]%100,intType};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:YES];
}

- (void)getPilaoData
{
    if (![HCHCommonManager getInstance].pilaoValue)
    {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now;
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        now=[NSDate date];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
        
        Byte transData[] = {0x68,UpdateTiredData_Enum, 0x03,0x00, [comps day],[comps month], [comps year]%100};
        NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self appendingCheckNumData:data isNeedResponse:NO];
        });
    });
}

- (void)getCurDayTotalHeartData {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now;
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        now=[NSDate date];
        NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH"];
        NSString *string = [formatter stringFromDate:now];
        
        int packNumber = [string intValue]/3+1;
        for (int i = 0; i < packNumber; i ++)
        {
            [HCHCommonManager getInstance].requestIndex = i+1;
            Byte transData[] = {0x68,UpdateTotalData_Enum, 0x06,0x00, [comps day],[comps month], [comps year]%100,0x03,0x08,[HCHCommonManager getInstance].requestIndex};
            NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self appendingCheckNumData:data isNeedResponse:YES];
            });
        }
    });
}
//请求最新的两个心率包
-(void)getNewestCurDayTotalHeartData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now;
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        now=[NSDate date];
        NSDateComponents * comps = [calendar components:unitFlags fromDate:now];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH"];
        NSString *string = [formatter stringFromDate:now];
        
        int packNumber = [string intValue]/3+1;
        int packNumberSpecific = [string intValue]/3+1;
        BOOL isChao = NO;
        if (packNumber>2)
        {
            packNumber = 2;
            isChao = YES;
        }
        for (int i = 0; i < packNumber; i ++)
        {
            if (isChao)
            {
                [HCHCommonManager getInstance].requestIndex = packNumberSpecific - 2 + i + 1;
                
            }
            else
            {
                [HCHCommonManager getInstance].requestIndex = i+1;
            }
            Byte transData[] = {0x68,UpdateTotalData_Enum, 0x06,0x00, [comps day],[comps month], [comps year]%100,0x03,0x08,[HCHCommonManager getInstance].requestIndex};
            NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self appendingCheckNumData:data isNeedResponse:YES];
            });
        }
    });
}

- (void)heartRateNotifyEnable:(BOOL)isEnable {
    if (self.cbPeripheral && heartRateNotifyCharactic) {
        [self.cbPeripheral setNotifyValue:isEnable forCharacteristic:heartRateNotifyCharactic];
        //adaLog(@"使能心率");
    }
}



- (void)timeFired:(NSTimer *)timer {
    if (cbCenterManger.state != CBCentralManagerStatePoweredOn)  return;
    if (_connectUUID && ![_connectUUID isEqualToString:@""] && currentWorkMode == 0 && !self.isConnecting) {
        [self ConnectWithUUID:_connectUUID];
    }
    if(![ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        return;
    }
    //[[TimeCallManager getInstance] getNowSecond];
    //adaLog(@" ----conState = %d    --- connectTime = %d",kHCH.conState,connectTime);
    if(kHCH.conState)
    {
        connectTime = 0;
    }
    else
    {
        ++connectTime;
    }
    if(connectTime>200)
    {connectTime = 21;
    }
    [ADASaveDefaluts setObject:@"1" forKey:CALLBACKFORTY];//不可用
    if(connectTime > 20)  //20*2 等于40秒
    {
        [ADASaveDefaluts setObject:@"2" forKey:CALLBACKFORTY];//可用
        [self delayCallback];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"ConnectTimeout" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        //[self performSelector:@selector(delayCallback) withObject:nil afterDelay:1.f];
    }
    ////adaLog(@"定时连接");
}
-(void)delayNotCan
{
    
}
-(void)delayCallback
{
    if (_delegate&&[_delegate respondsToSelector:@selector(callbackConnectTimeAlert:)])
    {
        [_delegate callbackConnectTimeAlert:_isSeek];
    }
}
#pragma mark -固件升级

- (void)startUpdateHardWithURL:(NSString *)romURL
{
    self.romURL = romURL;
    if (self.romURL)
    {
        NSData *data = [NSData dataWithContentsOfFile:self.romURL];
        int dataLength = (int)data.length;
        Byte transData[] = {0x68,UpdateHardWare_Enum,0x05,0x00,0x00,dataLength&0xff,dataLength>>8&0xff,dataLength>>16&0xff,dataLength>>24&0xff};
        NSData *lData = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:lData isNeedResponse:NO];
    }
}


#pragma mark -- 固件升级重发

- (void)updateHardWaerWithPackIndex:(int)index
{
    if (!self.isConnected || !self.romURL) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:self.romURL];
    int totalPack = (int)data.length/200 +1;
    int length = 200;
    if (index == totalPack)
    {
        length = data.length%200;
    }
    
    NSData *romData = [data subdataWithRange:NSMakeRange((index - 1)*200, length)];
    
    Byte transDate[] = {0x68,UpdateHardWare_Enum,(length+5)&0xff,(length+5)>>8&0xff,0x01,totalPack&0xff,totalPack>>8&0xff,index&0xff,index>>8&0xff};
    
    NSMutableData *lData = [[NSMutableData alloc]initWithBytes:transDate length:ArraySize(transDate)];
    [lData appendData:romData];
    
    Byte *beginTansDate = (Byte *)[lData bytes];
    
    uint checkNum = 0;
    for (int i = 0; i <lData.length; i ++)
    {
        checkNum += beginTansDate[i];
    }
    checkNum = checkNum%256;
    Byte tempData[] = {checkNum, 0x16};
    [lData appendBytes:tempData length:ArraySize(tempData)];
    
    if (lData.length > 20)
    {
        NSData *subData = [lData subdataWithRange:NSMakeRange(0, 20)];
        NSData *lostData = [lData subdataWithRange:NSMakeRange(20, lData.length- 20)];
        //adaLog(@"update = %@",subData);
        [self.cbPeripheral writeValue:subData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        [self performSelector:@selector(sendupdateData:) withObject:lostData afterDelay:0];
    }
    else
    {
        [self.cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)sendupdateData:(NSData *)lData
{
    if(!cbCenterManger){return;}
    if(!self.cbPeripheral){return;}
    if (cbCenterManger.state!=CBManagerStatePoweredOn)  {  return;  }
    if (!self.isConnected) {   return;   }
    if (!rdCharactic1) {    return;  }
    if (lData.length > 20)
    {
        NSData *subData = [lData subdataWithRange:NSMakeRange(0, 20)];
        NSData *lostData = [lData subdataWithRange:NSMakeRange(20, lData.length -20)];
        adaLog(@"lData= %@",lData);
        adaLog(@"update = %@",subData);
        
        [self.cbPeripheral writeValue:subData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        [self performSelector:@selector(sendupdateData:) withObject:lostData afterDelay:0];
    }
    else
    {
        //adaLog(@"update = %@",lData);
        [self.cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)updatehardwaerComplete
{
    Byte transData[] = {0x68,UpdateHardWare_Enum,0x01,0x00,0x02};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)findBindState:(BOOL)state
{
    state = !state;
    Byte transData[] = {0x68,0x13,0x01,0x00,state};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)setBindDateStateWithState:(BOOL)state
{
    Byte transData[] = {0x68,0x02,0x03,0x00,0x01,0x00,state};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)setUnitStateWithState:(BOOL)state
{
    Byte transData[] = {0x68,0x02,0x03,0x00,0x01,0x01,state};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)queryHeartAndtired
{
    //    if(self.queryHeartAndtiredNum<=0)
    //    {
    Byte transData[] = {0x68,0x02,0x03,0x00,0x00,0x02,0x04};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
    //        self.queryHeartAndtiredNum++;
    //        [self performSelector:@selector(queryHeartAndtiredNumber) withObject:nil afterDelay:1.0f];
    //    }
}
//- (void)queryHeartAndtiredNumber
//{
//    self.queryHeartAndtiredNum--;
//}
- (void)queryJiuzuoAlarm
{
    if(self.queryJiuzuoAlarmNum<=0)
    {
        Byte transData[] = {0x68,0x14,0x02,0x00,0x00,0xff};
        NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:data isNeedResponse:NO];
        self.queryJiuzuoAlarmNum++;
        [self performSelector:@selector(queryJiuzuoAlarmNumber) withObject:nil afterDelay:1.0f];
    }
}

-(void)queryJiuzuoAlarmNumber
{
    self.queryJiuzuoAlarmNum--;
}

- (void)setJiuzuoAlarmWithTag:(int)tag isOpen:(BOOL)isOpen BeginHour:(int)beginHour Minite:(int)beginMinite EndHour:(int)endHour Minite:(int)endMinite Duration:(int)duration
{
    Byte transData[] = {0x68,0x14,0x08,0x00,0x01,tag,isOpen,beginMinite,beginHour,endMinite,endHour,duration};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)deleteJiuzuoAlarmWithTag:(int)tag
{
    Byte transData[] = {0x68,0x14,0x02,0x00,0x02,tag};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void) setHeartHZState:(int)state;
{
    Byte transData[] = {0x68,0x02,0x03,0x00,0x01,0x04,state};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)setHeartDuration:(int)state
{
    if (state == [continuityMonitorNumber intValue])  //==62  设置连续监测
    {
        Byte transData[] = {0x68,0x02,0x03,0x00,0x01,0x02,0X01};
        NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:data isNeedResponse:NO];
        //        interfaceLog(@"连续心率监测 APP set %@",data);
    }
    else
    {
        Byte transData[] = {0x68,0x02,0x03,0x00,0x01,0x02,state};
        NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
        [self appendingCheckNumData:data isNeedResponse:NO];
    }
    
    
}
- (void)setLanguageByte:(int)state
{
    Byte transData[] = {0x68,0x02,0x03,0x00,0x01,0x06,state};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    //    interfaceLog(@"Language 1111 == %@",data);
    [self appendingCheckNumData:data isNeedResponse:NO];
}


- (void)returnCompletionDegree//运动目标 。睡眠目标  睡眠时间
{
    
    int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
    int sleepPlan = 0,stepPlan=0;
    sleepPlan = [dic[Sleep_PlanTo_HCH] intValue]; stepPlan = [dic[Steps_PlanTo_HCH] intValue];
    NSArray *sleepArr = [AllTool numberToArray:sleepPlan];
    NSArray *stepArr = [AllTool numberToArray:stepPlan];
    int length = [SleepTool sleepLengthSeek];
    //    int time = [dict[@"time"] intValue];
    //    int min = [dict[@"min"] intValue];
    //    length =  600;
    int shi =  length/60;
    int min = length%60;
    
    Byte transData[] = {0x68,0x2d,0x0b,0x00,0x01,[stepArr[0] intValue],[stepArr[1] intValue],[stepArr[2] intValue],[stepArr[3] intValue],[sleepArr[0] intValue],[sleepArr[1] intValue],[sleepArr[2] intValue],[sleepArr[3] intValue],min,shi};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:YES];
    //     interfaceLog(@"CompletionDegree  222   == APP - answer %@",data);
    //    adaLog(@"target ==  APP - answer %@",data);
}

- (void)activeCompletionDegree//运动目标 。睡眠目标  睡眠时间 - 主动发送
{
    if ([[ADASaveDefaluts objectForKey:COMPLETIONDEGREESUPPORT] intValue]!=1){
        return;
    }
    int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
    int sleepPlan = 0,stepPlan=0;
    sleepPlan = [dic[Sleep_PlanTo_HCH] intValue];
    stepPlan = [dic[Steps_PlanTo_HCH] intValue];
    NSArray *sleepArr = [AllTool numberToArray:sleepPlan];
    NSArray *stepArr = [AllTool numberToArray:stepPlan];
    int length = [SleepTool sleepLengthSeek];
    //    int time = [dict[@"time"] intValue];
    //    int min = [dict[@"min"] intValue];
    //    length =  600;
    int shi =  length/60.0;
    int min = length%60;
    
    Byte transData[] = {0x68,0x2d,0x0b,0x00,0x02,[stepArr[0] intValue],[stepArr[1] intValue],[stepArr[2] intValue],[stepArr[3] intValue],[sleepArr[0] intValue],[sleepArr[1] intValue],[sleepArr[2] intValue],[sleepArr[3] intValue],min,shi};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:YES];
    //    interfaceLog(@"CompletionDegree  222   == APP - set %@",data);
    adaLog(@"target ==  APP - set %@",data);
    
}

- (void)setPhotoWithState:(BOOL)state
{
    Byte transData[] = {0x68,0x0d,0x01,0x00,!state};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)answerTakePhoto
{
    Byte transData[] = {0x68,0x0e,0x00,0x00};
    NSData *data = [NSData dataWithBytes:transData length:ArraySize(transData)];
    [self appendingCheckNumData:data isNeedResponse:NO];
}

- (void)appendingCheckNumData:(NSData *)data isNeedResponse:(BOOL)response
{
    Byte *transData = (Byte*)[data bytes];
    uint checkNum = 0;
    for (int i = 0; i < data.length; i ++)
    {
        checkNum += transData[i];
    }
    checkNum = checkNum%256;
    Byte tempData[] = {checkNum,0x16};
    NSMutableData *lData = [[NSMutableData alloc] initWithData:data];
    [lData appendBytes:tempData length:ArraySize(tempData)];
    [self blueToothWhriteTransData:lData isNeedResponse:response];
}

#pragma mark    - -- - - - - -  蓝牙的重发机制
- (void)blueToothWhriteTransData:(NSData *)lData isNeedResponse:(BOOL)response
{
    if(!cbCenterManger){return;}
    if(!self.cbPeripheral){return;}
    if (cbCenterManger.state!=CBManagerStatePoweredOn)  {  return;  }
    if (rdCharactic1) {
        
        if (lData && lData.length != 0)
        {
            //            adaLog(@"self.dataArray = %@",self.dataArray); 
            if (response)
            {
                [self.dataArray addObject:lData];
            }
            else if (self.dataArray.count != 0)
            {
                [self.dataArray insertObject:lData atIndex:0];
            }
            else
            {
//                adaLog(@"shotSendData  - -- %@",lData); 
                [self.cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
                return;
            }
        }
        if (self.dataArray && self.dataArray.count!=0 && !_sendingData)
        {
            NSData *data = self.dataArray[0];
            if (data)
            {
//                adaLog(@"longSendData = %@",data);
                [self.cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
                self.sendingData = data;
                float outimeInterver = [BleTool countSendtimeOutWith:data.length AndReceive:10.0];
                //410 + arc4random()%75+24;
                [self performSelector:@selector(resendSendingData:) withObject:data afterDelay:outimeInterver];
                [self.dataArray removeObjectAtIndex:0];
            }
        }
    }
}

- (void)resendSendingData:(NSData*)data
{
    if(!cbCenterManger){return;}
    if (cbCenterManger.state!=CBManagerStatePoweredOn)
    {
        return;
    }
    if (_resendCount >= 2)
    {
        _resendCount = 0;
        self.sendingData = nil;
        [self blueToothWhriteTransData:nil isNeedResponse:YES];
    }
    if ([data isEqual:_sendingData])
    {
        if (notifyCharactic&&self.cbPeripheral)
        {
            [self.cbPeripheral setNotifyValue:YES forCharacteristic:notifyCharactic];
        }
        if (rdCharactic1)
        {
            adaLog(@"resendData ===== %@",data);
            [self.cbPeripheral writeValue:data forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
            _resendCount ++;
            float outimeInterver = [BleTool countSendtimeOutWith:data.length AndReceive:10.0];
            [self performSelector:@selector(resendSendingData:) withObject:data afterDelay:outimeInterver];
        }
    }
}

#pragma mark   ---   定时请求全天的心率
-(void)timingHeartRate
{
    if(hearRateTime)
    {
        [hearRateTime invalidate];  hearRateTime = nil;
    }
    hearRateTime = [NSTimer scheduledTimerWithTimeInterval:3600.f target:self selector:@selector(timingQuerycurdayHeartRate) userInfo:nil repeats:YES];
}
//定时请求全天的心率   、、一小时一次
-(void)timingQuerycurdayHeartRate
{
    if(kHCH.queryHearRateSeconed != 0)
    {
        [self getNewestCurDayTotalHeartData];
    }
    else
    {
        [self getCurDayTotalHeartData];
    }
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
