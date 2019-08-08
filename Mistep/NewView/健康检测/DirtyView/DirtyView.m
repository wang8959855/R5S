//
//  DirtyView.m
//  Wukong
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "DirtyView.h"
#import "DirtyDetailViewController.h"
#import "SleepTool.h"

@interface DirtyView ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,AVAudioPlayerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;

@property (nonatomic, assign) NSInteger nowSec;

//图片的数组
@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) NSString *SJDString;

//当前心率
@property (nonatomic, assign) NSInteger nowHeartRate;
@property (nonatomic, strong) NSTimer *heartTimer;

//播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
//选择的音乐
@property (nonatomic, assign) NSInteger selectMusic;
@property (nonatomic, strong) NSArray *musicArr;

//上一次点击的位置
@property (nonatomic, assign) NSInteger lastTouch;

//存取开关数据
@property (nonatomic, strong) NSMutableArray *openArr;

@end

@implementation DirtyView

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    [self calcGlu];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [self setupView];
        self.lastTouch = -1;
        [[PSDrawerManager instance] beginDragResponse];
        [BlueToothManager getInstance].delegate = self;
        [self childrenTimeSecondChanged];
        [self getDate];
        [self setBlocks];
    }
    return self;
}

-(void)setupView
{
    [self initPro];
    [self setSleepbackGround];
    self.imageArr = @[@"chou",@"yin",@"mao",@"chen",@"si",@"wu",@"wei",@"shen",@"you",@"xv",@"hai",@"zi"];
    
    //获取开关的数据
    [self.openArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"openArr"]];
    if ([self.openArr count] == 0) {//如果没有数据放入12个NO
        for (int i = 0; i < 12; i++) {
            BOOL isOpen = NO;
            [self.openArr addObject:@(isOpen)];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.openArr forKey:@"openArr"];
        self.openRobotBtn.selected = NO;
    }else{
        NSInteger count = 0;
        for (NSNumber *num in self.openArr) {
            if (num.boolValue == YES) {
                count++;
            }
        }
        if (count != 0) {
            self.openRobotBtn.selected = YES;
        }else{
            self.openRobotBtn.selected = NO;
        }
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setDate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self setMusicData];
}

- (void)setMusicData{
    NSURL *url1 = [[NSBundle mainBundle]  URLForResource:@"choushi.mp3" withExtension:nil];
    NSURL *url2 = [[NSBundle mainBundle]  URLForResource:@"yinshi.mp3" withExtension:nil];
    NSURL *url3 = [[NSBundle mainBundle]  URLForResource:@"moushi.mp3" withExtension:nil];
    NSURL *url4 = [[NSBundle mainBundle]  URLForResource:@"chenshi.mp3" withExtension:nil];
    NSURL *url5 = [[NSBundle mainBundle]  URLForResource:@"sishi.mp3" withExtension:nil];
    NSURL *url6 = [[NSBundle mainBundle]  URLForResource:@"wushi.mp3" withExtension:nil];
    NSURL *url7 = [[NSBundle mainBundle]  URLForResource:@"weishi.mp3" withExtension:nil];
    NSURL *url8 = [[NSBundle mainBundle]  URLForResource:@"shenshi.mp3" withExtension:nil];
    NSURL *url9 = [[NSBundle mainBundle]  URLForResource:@"youshi.mp3" withExtension:nil];
    NSURL *url10 = [[NSBundle mainBundle]  URLForResource:@"xushi.mp3" withExtension:nil];
    NSURL *url11 = [[NSBundle mainBundle]  URLForResource:@"haishi.mp3" withExtension:nil];
    NSURL *url12 = [[NSBundle mainBundle]  URLForResource:@"zishi.mp3" withExtension:nil];
    self.musicArr = @[url1,url2,url3,url4,url5,url6,url7,url8,url9,url10,url11,url12];
}

//平均心率
- (void)getAvgHeartRate:(NSNotification *)noti{
//    NSDictionary *dic = noti.object;
//    self.averageHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:dic[@"avg"] Unit:@"bpm" WithFont:18];
}
//实时心率
- (void)getNowHeartRate:(NSNotification *)noti{
    NSString *heart = noti.object;
//    self.nowHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:heart Unit:@"bpm" WithFont:18];
    self.nowHeartRate = heart.integerValue;
    NSString *tep = @"";
    if ([heart isEqualToString:@"--"]) {
        tep = @"--";
    }else if (heart.integerValue > 80){
        tep = [NSString stringWithFormat:@"%.2f",36.7+(heart.integerValue-80)/40.0];
    }else{
        tep = [NSString stringWithFormat:@"%.2f",36.5+(heart.integerValue-70)/50.0];
    }
}
//血氧
- (void)getSPOPressure:(NSNotification *)noti{
//    BloodPressureModel *bloodPre = noti.object;
}

//血糖
- (void)calcGlu{
    //睡醒前半小时、14:30、22:00
    /* NSInteger v = [self getSleepEndTime:[[TimeCallManager getInstance] getSecondsOfCurDay] is30:YES];
    NSInteger v2 = [self get230And22HeartWith:YES];
    NSInteger v10 = [self get230And22HeartWith:NO];
    
    NSInteger currentMinute = [[[TimeCallManager getInstance] getMinutueWithSecond:[[TimeCallManager getInstance] getSecondsOfCurDay]] integerValue];
    NSInteger currentHour = [[[TimeCallManager getInstance] getHourWithSecond:[[TimeCallManager getInstance] getSecondsOfCurDay]] integerValue];
    
    float s = 0;
    if (currentHour >= 22) {
        if (v10 > 0) {
            s = [[[HCHCommonManager getInstance] UserGlu] integerValue] + (v10 - 80) * 0.0975;
        }else{
            self.nowHeartRateLabel.text = @"--";
            return;
        }
    }else if (currentHour >= 14 && currentMinute >= 30){
        if (v2 > 0) {
            s = [[[HCHCommonManager getInstance] UserGlu] integerValue] + (v2 - 80) * 0.0975;
        }else{
            self.nowHeartRateLabel.text = @"--";
            return;
        }
    }else if (v != 0) {
       s = [[[HCHCommonManager getInstance] UserGlu] integerValue] + (v - 80) * 0.0975;
    }else{
        self.nowHeartRateLabel.text = @"--";
        return;
    }*/
    [self calcDaixie];
    NSInteger glu = 6;
    if ([[[HCHCommonManager getInstance] UserGlu] integerValue] != 0) {
        glu = [[[HCHCommonManager getInstance] UserGlu] integerValue];
    }
    if (self.nowHeartRate == 0) {
//        self.nowHeartRateLabel.text = @"--";
        [self performSelector:@selector(calcGlu) withObject:nil afterDelay:5.f];
    }else{
        float s = glu + (self.nowHeartRate - 80) * 0.0975;
        if (s < 0) {
//            self.nowHeartRateLabel.text = @"--";
        }else{
//            self.nowHeartRateLabel.text = [NSString stringWithFormat:@"%.2f",s];
        }
    }
    
}

//基础代谢率
- (void)calcDaixie{
    //今天的心率
    NSInteger v = [self getSleepEndTime:[[TimeCallManager getInstance] getSecondsOfCurDay] is30:NO];
    if (v == 0) {
//        self.averageHeartRateLabel.text = @"--";
        return;
    }
    
    NSInteger sec = [[TimeCallManager getInstance] getNowSecond];
    NSInteger hour = [[[TimeCallManager getInstance] getHourWithSecond:sec] integerValue];
    
    NSInteger s = 0;
    NSInteger d = 0;
    //不同时段男女基础数据不同
    NSInteger jichu = 0;
    if ((hour >= 6 && hour < 10) || (hour >= 16 && hour < 18)) {
        if ([[[HCHCommonManager getInstance] UserGender] isEqualToString:@"1"]){
            //男
            jichu = 60;
        }else{
            //女
            jichu = 65;
        }
    }else{
        if ([[[HCHCommonManager getInstance] UserGender] isEqualToString:@"1"]){
            //男
            jichu = 70;
        }else{
            //女
            jichu = 75;
        }
    }
    s = jichu/self.nowHeartRate*(self.nowHeartRate-70)+ [[[HCHCommonManager getInstance] UserSystolicP] integerValue];
    d = jichu/self.nowHeartRate*0.6*(self.nowHeartRate-70) + [[[HCHCommonManager getInstance] UserDiastolicP] integerValue];
    
    NSInteger daixie = v+(s-d)-111;
    
//    self.averageHeartRateLabel.text = [NSString stringWithFormat:@"%ld%%",daixie];
    
    NSString *str = @"--";
    if (daixie < -10) {
        str = @"异常";
    }else if (daixie >= -10 && daixie <= 19){
        str = @"正常";
    }else if (daixie >= 20 && daixie <= 29){
        str = @"轻度甲亢";
    }else if (daixie >= 30 && daixie <= 59){
        str = @"中度甲亢";
    }else if (daixie >= 60){
        str = @"重度甲亢";
    }
//    self.averageHeartRateLabel.text = str;
    
}

- (void)getDate{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    
    NSInteger hour=[components hour];
    NSInteger minute=[components minute];
    NSInteger second=[components second];
    self.nowSec = hour*3600+minute*60+second;
}

- (void)setDate{
    self.nowSec++;
    if (self.nowSec >= 86400) {
        self.nowSec = 0;
    }
    NSInteger hour = 0;
    NSInteger min = 0;
    NSInteger sec;
    NSInteger now = self.nowSec;
    if (self.nowSec >= 3600) {
        hour = self.nowSec/3600;
        now -= hour*3600;
    }
    if (now >= 60) {
        min = now/60;
        now -= min*60;
    }
    sec = now;
    self.nowDateLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,min,sec];
    
    NSInteger index = 0;
    self.SJDString = @"";
    if (self.nowSec == 3600) {
        //丑时
        index = 0;
        self.SJDString = @"丑时(01:00-03:00)";
    }else if (self.nowSec == 10800){
        //寅时
        index = 1;
        self.SJDString = @"寅时(03:00-05:00)";
    }else if (self.nowSec == 18000){
        //卯时
        index = 2;
        self.SJDString = @"卯时(05:00-07:00)";
    }else if (self.nowSec == 25200){
        //辰时
        index = 3;
        self.SJDString = @"辰时(07:00-09:00)";
    }else if (self.nowSec == 32400){
        //巳时
        index = 4;
        self.SJDString = @"巳时(09:00-11:00)";
    }else if (self.nowSec == 39600){
        //午时
        index = 5;
        self.SJDString = @"午时(11:00-13:00)";
    }else if (self.nowSec == 4680){
        //未时
        index = 6;
        self.SJDString = @"未时(13:00-15:00)";
    }else if (self.nowSec == 54000){
        //申时
        index = 7;
        self.SJDString = @"申时(15:00-17:00)";
    }else if (self.nowSec == 61200){
        //酉时
        index = 8;
        self.SJDString = @"酉时(17:00-19:00)";
    }else if (self.nowSec == 68400){
        //戌时
        index = 9;
        self.SJDString = @"戌时(19:00-21:00)";
    }else if (self.nowSec == 75600){
        //亥时
        index = 10;
        self.SJDString = @"亥时(21:00-23:00)";
    }else if (self.nowSec == 82800){
        //子时
        index = 11;
        self.SJDString = @"子时(23:00-01:00)";
    }else{
        return;
    }
    
    if ([self.openArr[index] boolValue] == NO) {//语音播报关闭
        return;
    }
    self.selectMusic = index;
    //语音播报
    [self audioPlayer];
}

-(void)setSleepbackGround
{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@""];
    backImageView.backgroundColor = allColorWhite;
    [self addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 48);
    
    //CGFloat backScrollViewX = 0;
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    [self addSubview:self.backScrollView];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+20);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.backgroundColor  = [UIColor clearColor];
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
        [weakSelf SLEdropDownReload];
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    bgView.backgroundColor = kColor(37 ,124 ,255);
    [self.backScrollView addSubview:bgView];
    
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundView];
}

-(void)initPro
{
    [PZBlueToothManager sharedInstance].delegate = self;
}

- (void)setBlocks
{
    WeakSelf;
    
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
        [weakSelf reloadData];
        [self calcGlu];
    }];
    
}
//下拉刷新
-(void)SLEdropDownReload
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
        //        [weakSelf reloadData];
        [weakSelf successCallbackSleepData];
    }];
    [self childrenTimeSecondChanged];
}

- (void)childrenTimeSecondChanged
{
    if (![CositeaBlueTooth sharedInstance].isConnected)
    {
        [self.backScrollView headerEndRefreshing];
    }
    
    [self reloadData];
}

-(void)successCallbackSleepData
{
    [self SLErefreshSucc];
    [self reloadData];
}
- (void)reloadData;
{
    [self.backScrollView headerEndRefreshing];
    [HCHCommonManager getAvgHeartRate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    [self sleepDrawWithDictionary];// 睡眠数据
    [self reloadPlan]; // 天总数据
}
-(void)reloadPlan
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadPlan) object:nil];
    // 天总数据中 - - -- - 目标的下载
//    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
}
-(void)sleepDrawWithDictionary{
    
}

- (NSMutableAttributedString *)getHandMinAttributeStringWithNumber:(int)number
{
    NSMutableAttributedString *attributeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number / 60] Unit:@"h" WithFont:25];
    [attributeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number%60] Unit:@"min" WithFont:25]];
    return attributeString;
}

- (void)setBackgroundView {

    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-150, 10, 300, 25)];
    [self.backScrollView addSubview:titL];
    titL.textColor = [UIColor whiteColor];
    titL.text = kLOCAL(@"时辰与脏腑对照表");
    titL.font = Font_Bold_String(17);
    titL.textAlignment = NSTextAlignmentCenter;
    
    self.circleImage = [[UIImageView alloc] init];
    [self.backScrollView addSubview:self.circleImage];
    self.circleImage.frame = CGRectMake(0, 0, 224, 224);
    self.circleImage.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circleImage.height/2.);
    self.circleImage.image = [UIImage imageNamed:@"kongbai"];
    self.circleImage.backgroundColor = [UIColor clearColor];
    self.circleImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCircle:)];
    [self.circleImage addGestureRecognizer:tap];
    tap.delegate = self;
    
    
    self.nowDateLabel = [[UILabel alloc] init];
    [self.backScrollView addSubview:self.nowDateLabel];
    self.nowDateLabel.frame = CGRectMake(0, 0, MIN(223 * kX, 223 * kDY), 30);
    self.nowDateLabel.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circleImage.height/2.);
    self.nowDateLabel.text = @"0";
    self.nowDateLabel.textColor = allColorWhite;
    self.nowDateLabel.backgroundColor = [UIColor clearColor];
    self.nowDateLabel.textAlignment = NSTextAlignmentCenter;
    
//    UIButton *detailButton = [[UIButton alloc]init];
//    [self.circleImage addSubview:detailButton];
//    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
//    [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat detailButtonX = 0;
//    CGFloat detailButtonY = 0;
//    CGFloat detailButtonW = MIN(203 * kX, 203 * kDY) * WidthProportion;
//    CGFloat detailButtonH = MIN(203 * kX, 203 * kDY) * HeightProportion;
//    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
    CGFloat btnWidth = (ScreenWidth-40-30)/2;
    
    self.openRobotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openRobotBtn.frame = CGRectMake(20, self.circleImage.bottom+20, btnWidth, 58);
    [self.backScrollView addSubview:self.openRobotBtn];
    [self.openRobotBtn setImage:[UIImage imageNamed:@"kq-anniu"] forState:UIControlStateNormal];
    [self.openRobotBtn setImage:[UIImage imageNamed:@"gb-anniu"] forState:UIControlStateSelected];
    [self.openRobotBtn addTarget:self action:@selector(robotSetAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.audioSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.audioSetBtn.frame = CGRectMake(20+btnWidth+30, self.circleImage.bottom+20, btnWidth, 58);
    [self.backScrollView addSubview:self.audioSetBtn];
    [self.audioSetBtn setImage:[UIImage imageNamed:@"shezhi-audio"] forState:UIControlStateNormal];
    [self.audioSetBtn addTarget:self action:@selector(voiceOpenAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(10, self.audioSetBtn.bottom + 20, ScreenWidth-20 , 200*kDY)];
    downView.layer.cornerRadius = 10;
    downView.layer.masksToBounds = YES;
    downView.layer.borderColor = kMainColor.CGColor;
    downView.layer.borderWidth = 0.5f;
    downView.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:downView];
    
    UIImageView *jiedu = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    jiedu.image = [UIImage imageNamed:@"jiedu"];
    [downView addSubview:jiedu];
    
    UILabel *jieduLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 20)];
    jieduLabel.text = kLOCAL(@"健康解读");
    jieduLabel.font = Font_Bold_String(13);
    [downView addSubview:jieduLabel];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, jiedu.bottom+10, downView.width-40, 80)];
    content.textColor = kMainColor;
    content.font = [UIFont boldSystemFontOfSize:14];
    content.text = kLOCAL(@"人为什么会生病？许多原因是因为人违背了自然的时间法则和时间节律。中医哲学主张天人合一，认为人是大自然的组成部分，人正常生理活动应该符合自然规律。");
    content.numberOfLines = 0;
    [downView addSubview:content];
    [content sizeToFit];
    
    UILabel *content1 = [[UILabel alloc] initWithFrame:CGRectMake(20, content.bottom+5, downView.width-40, 80)];
    content1.textColor = kMainColor;
    content1.font = [UIFont boldSystemFontOfSize:14];
    content1.text = kLOCAL(@"养生机器人把人的脏腑与12个时辰的兴衰变化联系起来，环环相扣，有机有序，科学掌握和应用脏腑节律，能够促进人体健康养生，预防和排查人体疾病。养生机器人是你随身相伴的健康管理专家！");
    content1.numberOfLines = 0;
    [downView addSubview:content1];
    [content1 sizeToFit];
    
}

//机器人
- (void)robotSetAction{
    WeakSelf;
    RobotSwitchView *robot = [RobotSwitchView robotSwitchView];
    robot.backRobotSwitchBlock = ^(NSInteger count, NSArray *arr) {
        [weakSelf.openArr removeAllObjects];
        [weakSelf.openArr addObjectsFromArray:arr];
        if (count != 0) {
            weakSelf.openRobotBtn.selected = YES;
        }else{
            weakSelf.openRobotBtn.selected = NO;
        }
    };
}

//语音播报
- (void)voiceOpenAction{
    WeakSelf
    VoiceBroadcastView *voice = [VoiceBroadcastView voiceBroadcastView];
    voice.backVoiceSwitchBlock = ^(NSInteger count, NSArray *arr) {
        [weakSelf.openArr removeAllObjects];
        [weakSelf.openArr addObjectsFromArray:arr];
        if (count != 0) {
            weakSelf.openRobotBtn.selected = YES;
        }else{
            weakSelf.openRobotBtn.selected = NO;
        }
    };
}

- (void)tapCircle:(UIGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:tap.view];
    NSLog(@"%f",point.x);
    NSLog(@"%f",point.y);
    NSInteger select = -1;
    if ([self touchLocation:81.666656 y1:207.486787 x2:91 y2:179.820131 x3:69 y3:165.820131 x4:45.666656 y4:188.820131 touchPoint:point]) {
        //丑时
        select = 0;
    }else if ([self touchLocation:37.666656 y1:178.153459 x2:59.333328 y2:158.153459 x3:49.333328 y3:136.820131 x4:17.333328 y4:145.153459 touchPoint:point]){
        //寅时
        select = 1;
    }else if ([self touchLocation:13 y1:135.153459 x2:46.333328 y2:128.486787 x3:47.666656 y3:100.153459 x4:14 y4:91.820131 touchPoint:point]){
        //卯时
        select = 2;
    }else if ([self touchLocation:47.666656 y1:94.153459 x2:15.666656 y2:83.486787 x3:40.666656 y3:41.153459 x4:63 y4:69.486787 touchPoint:point]){
        //辰时
        select = 3;
    }else if ([self touchLocation:45 y1:38.820131 x2:68.333328 y2:62.153459 x3:90.333328 y3:50.486787 x4:83.666656 y4:16.820131 touchPoint:point]){
        //巳时
        select = 4;
    }else if ([self touchLocation:87.333328 y1:15.153459 x2:97 y2:46.820131 x3:128 y3:47.820131 x4:136.666656 y4:15.820131 touchPoint:point]){
        //午时
        select = 5;
    }else if ([self touchLocation:143.666656 y1:17.153459 x2:132.333328 y2:49.153459 x3:160 y3:61.820131 x4:185 y4:39.153459 touchPoint:point]){
        //未时
        select = 6;
    }else if ([self touchLocation:187.333328 y1:44.486787 x2:164.666656 y2:69.820131 x3:180 y3:92.486787 x4:209 y4:81.820131 touchPoint:point]){
        //申时
        select = 7;
    }else if ([self touchLocation:212.333328 y1:91.486787 x2:181.333328 y2:100.820131 x3:179 y3:129.153459 x4:210.666656 y4:135.153459 touchPoint:point]){
        //酉时
        select = 8;
    }else if ([self touchLocation:208 y1:143.486787 x2:178.333328 y2:135.820131 x3:163 y3:161.486787 x4:185.666656 y4:179.153459 touchPoint:point]){
        //戊时
        select = 9;
    }else if ([self touchLocation:182 y1:188.153459 x2:160.666656 y2:165.153459 x3:132.666656 y3:179.820131 x4:142.333328 y4:208.820131 touchPoint:point]){
        //亥时
        select = 10;
    }else if ([self touchLocation:135.666656 y1:211.820131 x2:128 y2:182.486787 x3:99.333328 y3:179.820131 x4:86.333328 y4:210.486787 touchPoint:point]){
        //子时
        select = 11;
    }
    
    if (select == -1) {
        return;
    }
    if (self.lastTouch == -1) {//没有选择
        self.circleImage.image = [UIImage imageNamed:self.imageArr[select]];
        self.selectMusic = select;
        self.lastTouch = select;
        [self audioPlayer];
    }else if (self.lastTouch == select){//反选
        self.audioPlayer = nil;
        self.circleImage.image = [UIImage imageNamed:@"kongbai"];
        self.lastTouch = -1;
    }else{//切换
        self.audioPlayer = nil;
        self.circleImage.image = [UIImage imageNamed:self.imageArr[select]];
        self.selectMusic = select;
        self.lastTouch = select;
        [self audioPlayer];
    }
}

//判断点击的位置是否在区域内
- (BOOL)touchLocation:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 x3:(CGFloat)x3 y3:(CGFloat)y3 x4:(CGFloat)x4 y4:(CGFloat)y4 touchPoint:(CGPoint)point{
    
    //第一种是直接创建某一个区域，然后在判断是否在区域内，这种方法适合于任何图形
    CGMutablePathRef pathRef =CGPathCreateMutable();
    CGPathMoveToPoint(pathRef,NULL, x1, y1);
    CGPathAddLineToPoint(pathRef,NULL, x2, y2);
    CGPathAddLineToPoint(pathRef,NULL, x3,y3);
    CGPathAddLineToPoint(pathRef,NULL, x4,y4);
    CGPathAddLineToPoint(pathRef,NULL, x1, y1);
    CGPathCloseSubpath(pathRef);
    
    if(CGPathContainsPoint(pathRef,NULL, point, NO)){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
//        [self performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}

- (void)detailButtonAction:(UIButton *)button
{
    DirtyDetailViewController *dirtyDetail = [DirtyDetailViewController new];
    dirtyDetail.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:dirtyDetail animated:YES];
}

- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self SLErefreshFail];
}

-(void)refreshing
{
    if (self.dirtyReloadViewBlock) {
        self.dirtyReloadViewBlock(NSLocalizedString(@"DataSyn", nil));
    }
}
-(void)SLErefreshSucc
{
    if (self.dirtyReloadViewBlock) {
        self.dirtyReloadViewBlock(NSLocalizedString(@"syncFinish", nil));
    }
}
-(void)SLErefreshFail
{
    if (self.dirtyReloadViewBlock) {
        self.dirtyReloadViewBlock(NSLocalizedString(@"synchronizationFailure", nil));
    }
}


//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

//获取最后一个心率值
- (NSInteger)getSleepEndTime:(NSInteger)time is30:(BOOL)is30{
    NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:time - KONEDAYSECONDS];
    NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay]];
    NSMutableArray *sleepArray = [NSMutableArray array];
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:detailDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    
    sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
    int nightBeginTime = 0;
    int nightEndTime = 0;
    BOOL isBegin = NO;
    for (int i = 0; i < sleepArray.count; i ++)
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
    
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            nightEndTime += 1;
        }
    }
    
    return [self drawNightHeartViewWithBeginTime:nightBeginTime EndTime:nightEndTime is30:is30];
}

- (NSInteger)drawNightHeartViewWithBeginTime:(int)beginTime EndTime:(int)endTime is30:(BOOL)is30
{
    NSMutableArray *_nightHeartArray = [NSMutableArray array];
    [_nightHeartArray removeAllObjects];
    if (beginTime == endTime)
    {
        return 0;
    }
    beginTime = beginTime*10;
    endTime = endTime *10;
    NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS + 8 ];
    
    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
    //只是去后面两个小时
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSRange range = NSMakeRange(0, mutableArray.count/3);
    [mutableArray removeObjectsInRange:range];
    
    NSMutableArray *tempArray = [NSMutableArray new];
    if (array && array.count != 0)
    {
        [tempArray addObjectsFromArray:mutableArray];
    }
    else
    {
        for (int i = 0 ; i < 120; i ++) //晚上九点到十二点
        {
            [tempArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    for (int i = 1 ; i < 5; i ++)
    {
        if( i == 4 )
        {   //只是取前十个小时
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            NSMutableArray *mutableArray1 = [NSMutableArray arrayWithArray:array1];
            NSRange range1 = NSMakeRange(mutableArray1.count/ 3, mutableArray1.count/3 *2);
            [mutableArray1 removeObjectsInRange:range1];
            if (array && array.count != 0)
            {
                [tempArray addObjectsFromArray:mutableArray1];
            }
            else
            {
                for (int i = 0 ; i < 60; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
            
        }
        else
        {
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            if (array && array.count != 0&&(!((array.count==1)&&([array[0]isEqualToString:@""]))))
            {
                [tempArray addObjectsFromArray:array];
            }
            else
            {
                for (int i = 0 ; i < 180; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
        }
    }
    
    
    for (int i = beginTime; i < endTime; i ++)
    {
        if(tempArray[i])
        {
            [_nightHeartArray addObject:tempArray[i]];
        }
        else
        {
        }
    }
    if (is30) {
       return [_nightHeartArray[_nightHeartArray.count-30] integerValue];
    }
    return [_nightHeartArray.lastObject integerValue];
}

- (NSInteger)get230And22HeartWith:(BOOL)is230{
    NSInteger hea = 0;
    int i = 0;
    if (is230) {
        i = 5;
    }else{
        i = 8;
    }
    NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
    if (is230) {
        hea = [array[150] integerValue];
    }else{
        hea = [array[60] integerValue];
    }
    
    return hea;
}

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"许多疾病会造成氧供应缺乏，如心血管疾病、肺部疾病、睡眠呼吸暂停综合症等，可直接影响细胞的正常新陈代谢，严重者甚至危及生命。实时动态监测血氧趋势能够随时监测生命体征，提高心血管、睡眠呼吸暂停、癌症等疾病的检出率，以及对疾病康复具有重要的现实意义。",@"本项监测为实时动态监测，每3分钟一次。周期性血氧趋势状态请在“健康报告”中查看。"];
            break;
            
        case 31:
            arr = @[@"目前的体温监测为单点测量方式，仅仅停留在“是否发烧”的简单层面。本项功能提供了无仪器监测现场的实时动态体温监测手段，能够有效反映全天候体温变化规律。通过连续动态体温监测，采集到大量的体温数据，运用大数据云计算分析，获得针对不同年龄、不同疾病、不同生理状态的体温密码，可以为人们提供疾病早期筛查、个性化治疗用药指导、 慢病康复监护、居家养老护理等更有价值的健康管理服务。",@"本项监测为实时动态监测，每3分钟一次。周期性体温趋势状态请在“健康报告”中查看。"];
            break;
            
        case 32:
            arr = @[@"由于一天当中人体大部分时候均处于餐后状态，因此长期跟踪监测餐后血糖有助于提高检出率，早期干预，降低糖尿病发病风险。",@"系统初始餐后血糖值默认为6，由于个体差异及医疗控制等原因出现数值不准确者，请点击侧边栏图标-点击头像图标，进入个人资料编辑页面，在“餐后血糖值”中，将数值修改为经医生或血压计测量校准的数值。",@"本项功能对餐后血糖进行实时动态监测，每3分钟一次。周期性血糖趋势状态请在“健康报告”中查看。"];
            break;
            
        case 33:
            arr = @[@"基础代谢率是人体在基础状态下的能量代谢，是临床诊断甲状腺疾病的主要辅助方法，甲状腺机能亢进时，基础代谢率可明显升高，甲状腺机能低下时基础代谢率则明显降低。",@"本项监测为连续动态监测，每天一次，采集用户晨起时的静息心率和血压参数，如系统未采集到数据，参数值则显示为“- -”。周期性基础代谢率状态请在“健康报告”中查看。"];
            break;
    }
    [AlertMainView alertMainViewWithArray:arr];
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark - AVAudioPlayerDelegate
// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    player = nil;
}

#pragma mark -懒加载
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        
        // 0. 设置后台音频会话
        // 01. 设置会话模式
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; ;
        // 02. 激活会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        // 1. 获取资源URL
        NSURL *url = self.musicArr[self.selectMusic];
        
        // 2. 根据资源URL, 创建 AVAudioPlayer 对象
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        //无限播放
        self.audioPlayer.numberOfLoops = 1;
        
        // 2.1 设置允许倍速播放
        self.audioPlayer.enableRate = NO;
        
        // 3. 准备播放
        [_audioPlayer prepareToPlay];
        
        //播放
        [self.audioPlayer play];
        
        // 4. 设置代理, 监听播放事件
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

- (NSMutableArray *)openArr{
    if (!_openArr) {
        _openArr = [NSMutableArray array];
    }
    return _openArr;
}

@end
