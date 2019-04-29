//
//  SleepView.m
//  Wukong
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "SleepView.h"
#import "TargetViewController.h"
#import "SleepTool.h"
#import "ConnectStateView.h"
#import "DoneCustomView.h"
#import "SheBeiViewController.h"

@interface SleepView ()<BlutToothManagerDelegate,PZBlueToothManagerDelegate,NightCircleViewDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;
//@property (nonatomic,strong)UIView *connectView;//提示连接的view

//@property (nonatomic,strong) ConnectStateView *SLEconStateView;//提示连接的view
//@property (nonatomic,strong) UIButton *SLEconnectButton;//显示连接中。。。的button 点击跳转设备管理
//@property (nonatomic,strong) NSString *SLEconnectString;//连接字符串。
//@property (nonatomic,strong) DoneCustomView *SLEdoneView;
//@property (nonatomic,strong) NSString *SLEdoneString;
//@property (nonatomic,strong) UILabel *SLEchangLabel;//传递颜色的label

@end

@implementation SleepView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [[PSDrawerManager instance] beginDragResponse];
        [BlueToothManager getInstance].delegate = self;
        [self childrenTimeSecondChanged];
        
        [self reloadBlueToothDataSleep];
        [self setBlocks];
        [self SLErefreshAlertView];
    }
    return self;
}

-(void)setupView
{
    [self initPro];
    [self setSleepbackGround];
    [self SLEremindView];
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
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.backgroundColor  = [UIColor clearColor];
    
    WeakSelf
    [self.backScrollView addHeaderWithCallback:^{
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
        [weakSelf SLEdropDownReload];
    }];
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    bgView.backgroundColor = kColor(37 ,124 ,255);
    [self.backScrollView addSubview:bgView];
    
    [self setBackgroundView];
    
}

#pragma mark -- 内部方法
-(void)initPro
{
    [PZBlueToothManager sharedInstance].delegate = self;
}

- (void)setBlocks
{
    WeakSelf;
    
    [[PZBlueToothManager sharedInstance] checkTodaySleepStateWithBlock:^(int timeSeconds, NSArray *sleepArray) {
        [weakSelf reloadData];
    }];
    
    [BlueToothManager getInstance].delegate = self;
    //解除绑定要回调事件
    SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
    [shebei changRemoveBinding:^(int number) {
        //adaLog(@"number2 - sleep == %d",number);
        if (number) {
            //[weakSelf submitIsConnect];
            [weakSelf SLErefreshAlertView];
        }
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
    if (kHCH.selectTimeSeconds != kHCH.todayTimeSeconds)
    {
        _targetBtn.userInteractionEnabled = NO;
    }
    else
    {
        _targetBtn.userInteractionEnabled = YES;
    }
    
    [self reloadData];
}
-(void)reloadBlueToothDataSleep{
    
}
-(void)successCallbackSleepData
{
    [self SLErefreshSucc];
    [self reloadData];
}
- (void)reloadData;
{
    [self.backScrollView headerEndRefreshing];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    [self sleepDrawWithDictionary];// 睡眠数据
    [self reloadPlan]; // 天总数据
}
-(void)reloadPlan
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadPlan) object:nil];
    // 天总数据中 - - -- - 目标的下载
    NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    if (dic)
    {
        int sleepPlan = [dic[@"sleepPlan"] intValue];
        [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d h",sleepPlan / 60] Unit:@"(目标睡眠)" WithFont:18] forState:UIControlStateNormal];
        self.circle.maxValue = sleepPlan;
    }
}
/**
 *
 查询了今天的睡眠和昨天的睡眠组成一个睡眠数据
 */
-(void)sleepDrawWithDictionary
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sleepDrawWithDictionary) object:nil];
    NSDictionary *todayDic =  [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    NSDictionary *lastDayDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS];
    
    NSMutableArray *sleepArray = [[NSMutableArray alloc] init];
    
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:todayDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    
    sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
    
    int lightSleep = 0;
    int awakeSleep = 0;
    int deepSleep = 0;
    BOOL isBegin = NO;
    int nightBeginTime = 0;
    int nightEndTime = 0;
    
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
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            for (int i = nightBeginTime ; i <= nightEndTime; i ++)
            {
                int state = [sleepArray[i] intValue];
                if (state == 2 )    {  deepSleep ++; }
                else if (state == 1){   lightSleep ++; }
                else if (state == 0 || state == 3) {  awakeSleep ++;}
            }
        }
    }
    
    
    int totalCount = awakeSleep + lightSleep + deepSleep;
    _awakeLabel.attributedText = [self getHandMinAttributeStringWithNumber:awakeSleep * 10];
    _lightLabel.attributedText = [self getHandMinAttributeStringWithNumber:lightSleep * 10];
    _deepLabel.attributedText = [self getHandMinAttributeStringWithNumber:deepSleep * 10];
    [_deepLabel adjustsFontSizeToFitWidth];
    self.circle.value = totalCount * 10;
    
    if (totalCount < 36)
    {
        _sleepStateLabel.text = NSLocalizedString(@"偏少", nil);
    }else if (totalCount < 54)
    {
        _sleepStateLabel.text = NSLocalizedString(@"正常", nil);
    }else
    {
        _sleepStateLabel.text = NSLocalizedString(@"充裕", nil);
    }
    [self reloadPlan];
}

- (NSMutableAttributedString *)getHandMinAttributeStringWithNumber:(int)number
{
    NSMutableAttributedString *attributeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number / 60] Unit:@"h" WithFont:17];
    [attributeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number%60] Unit:@"min" WithFont:17]];
    return attributeString;
}

- (void)setBackgroundView {
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - 286*kDY + 30 + 20, ScreenWidth-20 , 200)];
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
    jieduLabel.text = @"睡眠解读";
    jieduLabel.font = Font_Bold_String(15);
    [downView addSubview:jieduLabel];
    
    UILabel *tixing = [[UILabel alloc] initWithFrame:CGRectMake(20, downView.height-45, downView.width-40, 40)];
    [downView addSubview:tixing];
    tixing.font = [UIFont systemFontOfSize:11];
    tixing.numberOfLines = 0;
    tixing.text = @"*正常人睡眠时长是7-8小时,\n 其中深睡时长应达到总睡眠时长的25%。";
    tixing.textColor = kMainColor;
    
    NSArray *array = @[@"深睡",@"浅睡",@"清醒"];
    for (int i = 0; i < 3; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50+i*40, 25,25)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:array[i]];
        [downView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i];
        label.font = Font_Bold_String(13);
        label.textColor = kMainColor;
        label.frame = CGRectMake(imageView.right + 3, imageView.top , 50, 25);
        label.textAlignment = NSTextAlignmentLeft;
        [downView addSubview:label];
        
        NSMutableAttributedString *string;
        switch (i) {
            case 2:
            {//清醒
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:17];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:17]];
                _awakeLabel = [[UILabel alloc] init];
                _awakeLabel.frame = CGRectMake(imageView.right + 5, imageView.top, downView.width - imageView.right-20, 25);
                _awakeLabel.textAlignment = NSTextAlignmentRight;
                _awakeLabel.attributedText = string;
                _awakeLabel.textColor = kMainColor;
                [downView addSubview:_awakeLabel];
                //  _awakeLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 0:
            {//深睡
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:17];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:17]];
                _deepLabel = [[UILabel alloc] init];
                _deepLabel.frame = CGRectMake(imageView.right + 5, imageView.top, downView.width - imageView.right-20, 25);
                _deepLabel.attributedText = string;
                _deepLabel.textAlignment = NSTextAlignmentRight;
                _deepLabel.textColor = kMainColor;
                [downView addSubview:_deepLabel];
                //_deepLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            case 1:
            {//浅睡
                string =  [self makeAttributedStringWithnumBer:@"0" Unit:@"h" WithFont:17];
                [string appendAttributedString:[self makeAttributedStringWithnumBer:@"0" Unit:@"min" WithFont:17]];
                _lightLabel = [[UILabel alloc] init];
                _lightLabel.frame = CGRectMake(imageView.right + 5, imageView.top, downView.width - imageView.right-20, 25);
                _lightLabel.attributedText = string;
                _lightLabel.textAlignment = NSTextAlignmentRight;
                _lightLabel.textColor = kMainColor;
                [downView addSubview:_lightLabel];
                //                _lightLabel.backgroundColor = [UIColor greenColor];
            }
                break;
            default:
                break;
        }
    }
    
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(150*kX, 30*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.height - 286*kDY);
    [self.backScrollView addSubview:self.targetBtn];
//    self.targetBtn.layer.borderColor = kMainColor.CGColor;
//    self.targetBtn.layer.borderWidth = 1;
//    self.targetBtn.layer.cornerRadius = 8*kDY;
    self.targetBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    
    [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d h",[HCHCommonManager getInstance].sleepPlan / 60] Unit:@"(目标睡眠)" WithFont:18] forState:UIControlStateNormal];
//    [self.targetBtn setTitle:[NSString stringWithFormat:@"%d h",[HCHCommonManager getInstance].sleepPlan / 60] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textColor = allColorWhite;
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.circle = [[NightCircleView alloc] init];
    [self.backScrollView addSubview:self.circle];
    self.circle.frame = CGRectMake(0, 0, MIN(203 * kX, 203 * kDY), MIN(203 * kX, 203 * kDY));
    self.circle.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circle.height/2.);
    self.circle.backgroundColor = [UIColor clearColor];
    
    self.circle.minValue = 0;
    self.circle.maxValue = kHCH.sleepPlan;
    self.circle.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circle.endAngle = 3./2 * M_PI;
    self.circle.ringBackgroundColor = [UIColor whiteColor];
    self.circle.valueTextColor = [UIColor whiteColor];
    self.circle.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circle.delegate = self;
    self.circle.value = 0;
    [self.circle setNeedsDisplay];
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.circle addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat detailButtonX = 0;
    CGFloat detailButtonY = 0;
    CGFloat detailButtonW = MIN(203 * kX, 203 * kDY) * WidthProportion;
    CGFloat detailButtonH = MIN(203 * kX, 203 * kDY) * HeightProportion;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
}

#pragma mark -- button方法
- (void)targetBtnAction:(UIButton *)button
{
    TargetViewController *tagetVC = [TargetViewController new];
    tagetVC.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:tagetVC animated:YES];
}
- (void)detailButtonAction:(UIButton *)button
{
    TodaySleepDetailViewController *detail = [[TodaySleepDetailViewController alloc]init];
    detail.hidesBottomBarWhenPushed = YES;
//    self.controller.haveTabBar = NO;
    [self.controller.navigationController pushViewController:detail animated:YES];
    
}
- (UIColor *)gaugeView:(NightCircleView *)gaugeView ringStokeColorForValue:(CGFloat)value
{
    return [UIColor blackColor];
}
- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self SLErefreshFail];
    //    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}




//- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

#pragma mark   -------- -- 连接状态的提示
-(void)SLEremindView
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(SLEconnectionFailedAction:) name:@"ConnectTimeout" object:nil];
    [center addObserver:self selector:@selector(SLErefreshAlertView) name:@"didDisconnectDevice" object:nil];
}

//初始化提醒的view  的 刷新
-(void)SLErefreshAlertView{
    
}

-(void)SLEconnectionFailedAction:(int)isSeek
{
    if([ADASaveDefaluts objectForKey:kLastDeviceUUID])
    {
        if([[ADASaveDefaluts objectForKey:CALLBACKFORTY] integerValue] == 2)//可用
        {
            if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 1)    //没有找到
            {
                //                    self.connectStringHight = 2;
                self.SLEconnectString = NSLocalizedString(@"pleaseWakeupDeviceNotfound", nil);
                
            }
            else if ([[ADASaveDefaluts objectForKey:SEARCHDEVICEISSEEK] integerValue] == 2)   //找到了
            {
                //                    self.connectStringHight = 2;
                self.SLEconnectString = NSLocalizedString(@"bluetoothConnectionFailed", nil);
            }
        }
        
    }
    else
    {
        //self.connectLabel.text = NSLocalizedString(@"未绑定", nil);
//        self.SLEconnectString = NSLocalizedString(@"未绑定", nil);
//        self.SLEconnectButton.userInteractionEnabled = YES;
//        self.SLEconStateView.labeltextColor = [UIColor blueColor];
    }
    
}

-(void)SLEconnectButtonToshebei
{
    SheBeiViewController *shebeiVC = [SheBeiViewController sharedInstance];
    shebeiVC.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:shebeiVC animated:YES];
}
-(void)SLErefreshConnect
{
    WeakSelf;
    if ([CositeaBlueTooth sharedInstance].isConnected)
    {   [self SLEConnected];
        [weakSelf performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
#pragma mark --  代理。监测连接状态
- (void)BlueToothIsConnected:(BOOL)isconnected
{
    if (isconnected)
    {
        [self SLEConnected];
        [self performSelector:@selector(SLEsubmitIsConnect) withObject:nil afterDelay:2.0f];
    }
}
-(void)SLEConnected
{
//    self.SLEconnectString = NSLocalizedString(@"connectSuccessfully", nil);
}
-(void)SLEsubmitIsConnect
{
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(SLEsubmitIsConnect) object:nil];
    
//    self.SLEconStateView.alpha = 0;
//    if(!([self.SLEdoneView.titleString isEqualToString:NSLocalizedString(@"DataSyn", nil)]&&self.SLEdoneView.alpha == 1))
//    {
//        self.backScrollView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
//    }
}
-(void)setSLEconnectString:(NSString *)SLEconnectString
{
//    _SLEconnectString = SLEconnectString;
//    //adaLog(@"--- SLErt -- connectString - %@",SLEconnectString);
//    self.SLEconStateView.stateString = SLEconnectString;
//    self.SLEconStateView.labeltextColor = _SLEchangLabel.textColor;
//    NSDictionary *dicDown3 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
//    CGSize sizeDown3 = [SLEconnectString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicDown3 context:nil].size;
//    NSInteger height = sizeDown3.height;
//
//    if(height>self.SLEconStateView.height)
//    {
//        self.SLEconStateView.height =  height;
//    }
//    if(![SLEconnectString isEqualToString:NSLocalizedString(@"connectSuccessfully", nil)])
//    {
//        self.backScrollView.frame = CGRectMake(0,self.SLEconStateView.height,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
//    }
}

-(void)refreshing
{
    self.SLEdoneString = NSLocalizedString(@"DataSyn", nil);
    if (self.sleepReloadViewBlock) {
        self.sleepReloadViewBlock(NSLocalizedString(@"DataSyn", nil));
    }
}
-(void)SLErefreshSucc
{
    self.SLEdoneString = NSLocalizedString(@"syncFinish", nil);
    if (self.sleepReloadViewBlock) {
        self.sleepReloadViewBlock(NSLocalizedString(@"syncFinish", nil));
    }
}
-(void)SLErefreshFail
{
    self.SLEdoneString = NSLocalizedString(@"synchronizationFailure", nil);
    if (self.sleepReloadViewBlock) {
        self.sleepReloadViewBlock(NSLocalizedString(@"synchronizationFailure", nil));
    }
}
-(void)SLEhiddenDoneView
{
//    self.SLEdoneView.alpha = 0;
//    [UIView animateWithDuration:1.f animations:^{
//        self.backScrollView.frame = CGRectMake(0,0,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
//    }];
}
//-(DoneCustomView *)SLEdoneView{
//    if (!_SLEdoneView)
//    {
//        _SLEdoneView = [[DoneCustomView alloc]init];
//        _SLEdoneView.frame = CGRectMake(0,64, CurrentDeviceWidth, 60*HeightProportion);
//        _SLEdoneView.alpha = 0;
//    }
//    return _SLEdoneView;
//}
-(void)setSLEdoneString:(NSString *)SLEdoneString
{
//    _SLEdoneString = SLEdoneString;
//    self.SLEdoneView.titleString = SLEdoneString;
//
//    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
//    CGSize size2 = [SLEdoneString boundingRectWithSize:CGSizeMake(CurrentDeviceWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
//
//    NSInteger height = size2.height;
//    if(height>self.SLEdoneView.height)
//    {
//        self.SLEdoneView.height =  height;
//    }
//    self.backScrollView.frame = CGRectMake(0,self.SLEdoneView.height,self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
//    if (![SLEdoneString isEqualToString:NSLocalizedString(@"DataSyn", nil)])
//    {
//        [self performSelector:@selector(SLEhiddenDoneView) withObject:nil afterDelay:2.f];
//    }
//    self.SLEdoneView.alpha = 1;
}
#pragma mark   - -- 蓝牙状态的回调   --- delegate
-(void)callbackCBCentralManagerState:(CBCentralManagerState)state
{
    [self performSelector:@selector(SLErefreshAlertView) withObject:nil afterDelay:1.f];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"人未进入睡眠过程的清醒状态。",@"本参数显示清醒总时长。"];
            break;
            
        case 31:
            arr = @[@"本参数显示夜间睡眠的质量状态，请结合个人感受评判实际睡眠质量。",@"衡量深度睡眠的标准:",@"1.入睡快，10-30分钟左右入睡；",@"2.睡眠深，呼吸深长不易惊醒；",@"3.无起夜或很少起夜，无惊梦现象，醒后很快忘记梦境；",@"4.早晨睡醒后，起床快，精神好；",@"5.白天神清脑爽,工作效率高,不困倦。"];
            break;
            
        case 32:
            arr = @[@"科学来讲，目前的可穿戴设备难以对人的深度睡眠进行准确监测。本项功能提供了实时连续监测睡眠状态的手段，智能监测人体睡眠时的连续心率以及体位活动等，通过体位幅度、起夜活动、心率波动等数据分析人体的安静睡眠状态，有利于指导用户合理安排作息时间，养成良好的睡眠习惯。",@"本参数显示安静睡眠总时长。"];
            break;
            
        case 33:
            arr = @[@"浅度睡眠指睡眠不踏实，包括多梦、体位活动较频繁、心率波动明显或偏高等。",@"本参数显示浅度睡眠总时长。"];
            break;
    }
    [AlertMainView alertMainViewWithArray:arr];
}

@end
