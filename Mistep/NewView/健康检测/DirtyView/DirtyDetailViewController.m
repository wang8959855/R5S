//
//  DirtyDetailViewController.m
//  Wukong
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "DirtyDetailViewController.h"

@interface DirtyDetailViewController ()

@end

@implementation DirtyDetailViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.datePickBtn setTitle:@"脏腑" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backNavView];
    [self reloadBlueToothData];
    [self setBodyT];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBlocks];
}

- (void)setBlocks {
    WeakSelf;
    [[PZBlueToothManager sharedInstance] connectedStateChangedWithBlock:^(int number) {
        if (number)
        {
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [HCHCommonManager getInstance].isEquipmentConnect = YES;
        }
        else
        {
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
            [HCHCommonManager getInstance].isEquipmentConnect = NO;
        }
    }];
}

- (void)setBodyT{
    _backScrollView = [[UIScrollView alloc] init];
    _backScrollView.frame = CGRectMake(0, 64, CurrentDeviceWidth, CurrentDeviceHeight - 64 );
    [self.view addSubview:_backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height + 0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    WeakSelf;
    [self.backScrollView addHeaderWithCallback:^{
        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
        {
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf reloadBlueToothData];
        }
        else
        {
            if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
            {
                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            }
            else
            {
                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"未绑定", nil) deleyTime:1.5f];
            }
            [weakSelf.backScrollView headerEndRefreshing];
        }
    }];
    
    self.view.backgroundColor = kColor(233, 243, 250);
    UIView *bodyTBackView = [[UIView alloc] init];
    bodyTBackView.backgroundColor = [UIColor whiteColor];
    bodyTBackView.frame = CGRectMake(10,10, CurrentDeviceWidth - 20 * kX, (_backScrollView.height-30)/2);
    [_backScrollView addSubview:bodyTBackView];
    
    UILabel *bodyTButtonView = [[UILabel alloc] init];
    [bodyTBackView addSubview:bodyTButtonView];
    bodyTButtonView.frame = CGRectMake(13 * kX, 10 * kSY, 75 * kX , 25*kSY);
    bodyTButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bodyTButtonView.layer.cornerRadius = bodyTButtonView.height/2.0;
    bodyTButtonView.clipsToBounds = YES;
    bodyTButtonView.backgroundColor = kMainColor;
    bodyTButtonView.text = @"体温";
    bodyTButtonView.textAlignment = NSTextAlignmentCenter;
    bodyTButtonView.textColor = [UIColor whiteColor];
    
    self.bodyTScrollView = [[UIScrollView alloc] init];
    self.bodyTScrollView.frame = CGRectMake(0, bodyTButtonView.bottom + 11, bodyTBackView.width, bodyTBackView.height -  bodyTButtonView.bottom - 11);
    self.bodyTScrollView.showsHorizontalScrollIndicator = NO;
    [bodyTBackView addSubview:self.bodyTScrollView];
    
    UIView *bodyTView = [[UIView alloc] init];
    [self.bodyTScrollView addSubview:bodyTView];
    bodyTView.frame = CGRectMake(0, 5, 35*24+30, bodyTBackView.height -  bodyTButtonView.bottom - 11);
    [self addBodyLabelTo:bodyTView];
    self.bodyTScrollView.contentSize = CGSizeMake(bodyTView.width, bodyTView.height);
    
    self.bodyTChart = [[BodyTChart alloc] initWithFrame:CGRectMake(0, 0, bodyTView.width, self.bodyTScrollView.frame.size.height)];
    [self.bodyTScrollView addSubview:self.bodyTChart];
    self.bodyTScrollView.bounces = NO;
    
    self.oxygenBackView = [[UIView alloc] init];
    self.oxygenBackView.backgroundColor = [UIColor whiteColor];
    self.oxygenBackView.frame = CGRectMake(10,bodyTBackView.bottom+10, bodyTBackView.width, bodyTBackView.height);
    [_backScrollView addSubview:self.oxygenBackView];
    
    self.OxygenScrollView = [[UIScrollView alloc] init];
    self.OxygenScrollView.frame = CGRectMake(0, 0, self.oxygenBackView.width, self.oxygenBackView.height);
    self.OxygenScrollView.showsHorizontalScrollIndicator = NO;
    [self.oxygenBackView addSubview:self.OxygenScrollView];
    
    [self oxygenView];
    [self reloadHeartData];
}

- (void)addBodyLabelTo:(UIView *)view
{
    int maxHR = 40;
    float minHR = 37.5;
    
    UILabel *dayWarningLabel1 = [[UILabel alloc] init];
    dayWarningLabel1.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel1.font = [UIFont systemFontOfSize:12];
    dayWarningLabel1.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    [view addSubview:dayWarningLabel1];
    dayWarningLabel1.frame = CGRectMake(0, 0, view.width, view.height/77.5 * (77.5 - maxHR));
    
    
    UILabel *day220 = [[UILabel alloc] init];
//    _day220 = day220;
    day220.textColor = [UIColor grayColor];
    day220.text = [NSString stringWithFormat:@"%d",maxHR];
    [day220 sizeToFit];
    day220.font = [UIFont systemFontOfSize:12];
    [view addSubview:day220];
    
    day220.frame = CGRectMake(8, 0 - day220.height/2., day220.width, day220.height);
    
    
    
    UIImageView *lineImageView1 = [[UIImageView alloc] init];
    [view addSubview:lineImageView1];
    lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView1.contentMode = UIViewContentModeScaleToFill;
    lineImageView1.frame = CGRectMake(32, 0, view.width - 32, 1);
    
    UILabel *dayWarningLabel2 = [[UILabel alloc] init];
    dayWarningLabel2.text = NSLocalizedString(@"         正常", nil);
    dayWarningLabel2.textColor = [UIColor grayColor];
    dayWarningLabel2.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayWarningLabel2];
    dayWarningLabel2.frame = CGRectMake(0, dayWarningLabel1.bottom, view.width, view.height - dayWarningLabel1.bottom-15);
    
    
    UILabel *day50 = [[UILabel alloc] init];
    day50.textColor = [UIColor grayColor];
    day50.text = [NSString stringWithFormat:@"%.1f",minHR];
    [day50 sizeToFit];
    day50.font = [UIFont systemFontOfSize:12];
    [view addSubview:day50];
    day50.frame = CGRectMake(8, dayWarningLabel1.bottom - 5, day50.width, 10);
    
    
    UIImageView *lineImageView3 = [[UIImageView alloc] init];
    [view addSubview:lineImageView3];
    lineImageView3.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView3.contentMode = UIViewContentModeScaleToFill;
    lineImageView3.frame = CGRectMake(32, dayWarningLabel1.bottom, view.width - 32, 1);
    
    for (int i = 0; i < 24; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        NSString *text = [NSString stringWithFormat:@"%d",i];
        if (text.length == 1)
        {
            text = [NSString stringWithFormat:@"0%@:00",text];
        }else{
            text = [NSString stringWithFormat:@"%@:00",text];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor grayColor];
        label.frame = CGRectMake(i * 35+30, dayWarningLabel2.bottom, 30 , 10);
        [view addSubview:label];
    }
    
}

- (void)reloadBlueToothData
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
        [weakSelf reloadHeartData];
        [weakSelf.backScrollView headerEndRefreshing];
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(reloadOutTime) object:nil];
    }];
}

- (void)reloadHeartData{
    for (int i = 0; i < 8; i ++)
    {
        NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
        NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
        //        //adaLog(@"array - %@",array);
        if (array) {
            [self.heartsArray addObjectsFromArray:array];
        }else{
            NSMutableArray *a = [NSMutableArray array];
            for (int i = 0 ; i < 180; i++) {
                [a addObject:@(0)];
            }
            [self.heartsArray addObjectsFromArray:a];
        }
    }
    
    //拿出每小时的心率数组
    NSMutableArray *avgArray = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        NSMutableArray *hourArr = [NSMutableArray array];
        for (int j = 0; j < 60; j++) {
            [hourArr addObject:self.heartsArray[i*60+j]];
        }
        [avgArray addObject:hourArr];
    }
    
    //获取没小时的平均值
    NSMutableArray *hourAvgArray = [NSMutableArray array];
    for (NSArray *arr in avgArray) {
        [hourAvgArray addObject:@([self calcEveryHour:arr])];
    }
    
   //计算体温、血氧
    NSMutableArray *tiwenArr = [NSMutableArray array];
    NSMutableArray *xueyangArr = [NSMutableArray array];
    for (NSNumber *num in hourAvgArray) {
        [tiwenArr addObject:@([self calcTiWenWithHeartRate:num.integerValue])];
        [xueyangArr addObject:@([self calcXueYangWithHeartRate:num.integerValue])];
    }
    _bodyTChart.bodyTArray = tiwenArr;
    _oxygenChart.oxygenArray = xueyangArr;
    
}

- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self SLErefreshFail];
}

-(void)SLErefreshFail {
    [self.backScrollView headerEndRefreshing];
    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOxygenArray:(NSArray *)oxygenArray{
    if (_oxygenArray != oxygenArray){
        _oxygenArray = oxygenArray;
        _oxygenChart.oxygenArray = oxygenArray;
    }
}

- (UIView *)oxygenView
{
    if (!_oxygenView)
    {
        
        UILabel *oxygenButtonView = [[UILabel alloc] init];
        [self.oxygenBackView addSubview:oxygenButtonView];
        oxygenButtonView.frame = CGRectMake(13 * kX, 10 * kSY, 75 * kX , 25*kSY);
        oxygenButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        oxygenButtonView.layer.cornerRadius = oxygenButtonView.height/2.0;
        oxygenButtonView.clipsToBounds = YES;
        oxygenButtonView.backgroundColor = kMainColor;
        oxygenButtonView.text = @"血氧";
        oxygenButtonView.textAlignment = NSTextAlignmentCenter;
        oxygenButtonView.textColor = [UIColor whiteColor];
        
        _oxygenView = [[PZOxygenView alloc] initWithFrame:CGRectMake(0, oxygenButtonView.bottom+11, 24*35+30, self.OxygenScrollView.height-oxygenButtonView.height-23)];
        [self.OxygenScrollView addSubview:_oxygenView];
        self.OxygenScrollView.contentSize = CGSizeMake(_oxygenView.width, _oxygenView.height);
        self.OxygenScrollView.bounces = NO;
        OxygenChart *chart = [[OxygenChart alloc] initWithFrame:CGRectMake(_oxygenView.frame.origin.x, 0, _oxygenView.frame.size.width, _oxygenView.frame.size.height - 23)];
        _oxygenChart = chart;
        chart.oxygenArray = self.oxygenArray;
        [_oxygenView addSubview:chart];
        self.OxygenScrollView.layer.masksToBounds = YES;
    }
    return _oxygenView;
}

- (NSMutableArray *)heartsArray{
    if (!_heartsArray) {
        _heartsArray = [NSMutableArray array];
    }
    return _heartsArray;
}

//计算每小时平均心率
- (NSInteger)calcEveryHour:(NSArray *)array{
    NSInteger avg = 0;
    NSInteger i = 0;
    for (NSNumber *num in array) {
        avg += num.integerValue;
        if (num.integerValue != 0) {
            i++;
        }
    }
    return avg/i;
}

//计算体温
- (float)calcTiWenWithHeartRate:(NSInteger)heartRate{
    float tiwen = 0;
    if (heartRate > 30) {
        if (heartRate > 80){
            tiwen = 36.7+(heartRate-80)/40.0;
        }else{
            tiwen = 36.5+(heartRate-70)/50.0;
        }
    }else{
        tiwen = 0;
    }
    
    return tiwen;
}

//计算血氧
- (NSInteger)calcXueYangWithHeartRate:(NSInteger)heartRate{
    NSInteger xueyang = 0;
    if (heartRate > 30) {
        if (heartRate > 100 && heartRate <= 110) {
            xueyang = 94;
        }else if (heartRate > 110 && heartRate <= 120){
            xueyang = 93;
        }else if (heartRate > 120 && heartRate <= 130){
            xueyang = 92;
        }else if (heartRate > 130 && heartRate <= 140){
            xueyang = 91;
        }else if (heartRate > 140 && heartRate <= 150){
            xueyang = 90;
        }else if (heartRate == 100){
            xueyang = 95;
        }else if (heartRate >= 90 && heartRate < 100){
            xueyang = 96;
        }else if (heartRate >= 80 && heartRate < 90){
            xueyang = 97;
        }else if (heartRate >= 70 && heartRate < 80){
            xueyang = 98;
        }else if (heartRate >= 60 && heartRate < 70){
            xueyang = 99;
        }else if (heartRate < 60){
            xueyang = 99;
        }
        
    }
    return xueyang;
}

@end
