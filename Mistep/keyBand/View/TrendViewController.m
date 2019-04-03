//
//  TrendViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/9.
//  Copyright © 2015年 huichenghe. All rights reserved.
//
#define labelTag  10000
#define sleepLabelTag  1000
#define mStepLabelTag  1111
#define mSleepLabelTag  11111
#define yueStepScroll     126
#define yueSleepScroll     166
#define KONEDAYSECONDS 86400

#define zhouSleepDeepColor kColor(69,110,230)
#define zhouSleepLightColor kColor(24,232,244)
#define zhouSleepAwakeColor kColor(255,145,7)


#import "TrendViewController.h"
#import "NSAttributedString+appendAttributedString.h"
#import "SleepTool.h"
//#import "GCDDelay.h"


@interface TrendViewController ()<UIScrollViewDelegate>
{
    int MaxHeight;    // 周
    float zhouMaxStep; // 周
    float zhouMaxSleep; // 周
    CGFloat zhouMaxheightSleep; // 周
    CGFloat monthStepHeight;//月
    CGFloat yueMaxmStep;  //月
    CGFloat monthMaxheightSleep;//月
    int maxSleep; //月
    
}
//@property(nonatomic,strong)GCDTask task;//用于延时的对象
@property(nonatomic,strong)NSDictionary *stepDictionary; // 31天的步数字典
@property(nonatomic,strong)NSDictionary *sleepDictionary;// 31天的睡眠字典
@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    [self setUpView];
} 
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}

- (void)setUpView {
    [self setUpView2];
    
//    [self zongHuitu];
    
    //   用户 上传下行，，查看数据
//    if(![AllTool isDirectUse])
//    {
//        WeakSelf;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //等待  6   秒。还没有下载完成就取表中数据
//            self.task = [GCDDelay gcdDelay:6 task:^{
//                [weakSelf queryNetworkTimeOut];
//            }];
//            [TimingUploadData downYueStepTrend:^(NSDictionary *dict) {
//                _stepDictionary = dict;
//                [TimingUploadData  downYueSleepTrend:^(NSDictionary *dict) {
//                    _sleepDictionary = dict;
//                    [weakSelf zongHuitu];
//                } date:kHCH.todayTimeSeconds];
//            } date:kHCH.todayTimeSeconds];
//        });
//    }
}
-(void)queryNetworkTimeOut
{
    [[TodayStepsViewController sharedInstance] remindRedownData];
}
 
-(void)setUpView2
{
    self.view.frame = CurrentDeviceBounds;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, CurrentDeviceWidth, CurrentDeviceHeight-64)];
    _scrollView.contentSize = CGSizeMake(CurrentDeviceWidth * 2, CurrentDeviceHeight - 64);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    
    _zhouView.frame = CGRectMake(0, 0, _scrollView.width, CurrentDeviceHeight - 64);
    _yueView.frame = CGRectMake(0, 0, _scrollView.width, CurrentDeviceHeight - 64);
    _yueView.frame = CGRectMake(CurrentDeviceWidth, 0, CurrentDeviceWidth, _scrollView.frame.size.height);
    [_scrollView addSubview:_zhouView];
    [_scrollView addSubview:_yueView];
    
    _mSleepArray = [[NSMutableArray alloc]init];
    //    _mSleepTagArray = [[NSMutableArray alloc] init];
    
    //整体的约束的计算
    [self  zhouCalculateConstraint];
    [self  yueCalculateConstraint];
    [self zongHuitu];
}
-(void)zongHuitu
{
//    [GCDDelay gcdCancel:self.task];
    [self loadWStepView];
    [self drawMStepView];
    [self loadMSleepView];
    [self loadWSleepView];
}
- (void)setXibLabel
{
    [_zhouBtn setTitle:NSLocalizedString(@"周", nil) forState:UIControlStateNormal];
    [_zhouBtn setTitle:NSLocalizedString(@"周", nil) forState:UIControlStateSelected];
    [_yueBtn setTitle:NSLocalizedString(@"月", nil) forState:UIControlStateNormal];
    [_yueBtn setTitle:NSLocalizedString(@"月", nil) forState:UIControlStateSelected];
    _zhouCompletionLabel.text = NSLocalizedString(@"完成:", nil);
    _zhouRecordLabel.text = NSLocalizedString(@"最高纪录:", nil);
    _zhouAvgStepLabel.text = NSLocalizedString(@"平均步数", nil);
    _zhouAvgCaloriesLabel.text = NSLocalizedString(@"平均消耗热量", nil);
    _zhouAvgDurationLabel.text = NSLocalizedString(@"平均时长", nil);
    _zhouAvgDeepLabel.text = NSLocalizedString(@"平均深睡", nil);
    _yueCompletionLabel.text = NSLocalizedString(@"完成:", nil);
    _yueRecordLabel.text = NSLocalizedString(@"最高纪录:", nil);
    _yueAvgStepLabel.text = NSLocalizedString(@"平均步数", nil);
    _yueAvgCaloriesLabel.text = NSLocalizedString(@"平均消耗热量", nil);
    _yueAvgDurationLabel.text = NSLocalizedString(@"平均时长", nil);
    _yueAvgDeepLabel.text = NSLocalizedString(@"平均深睡", nil);
    _stepsLabel.text = NSLocalizedString(@"步", nil);
    _yueSteps.text = NSLocalizedString(@"步", nil);
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    [self calculateConstraint];
//}

- (void)loadMSleepView
{
    for (UIView *del in _yueView.subviews) {
        if (del.tag == yueSleepScroll) {
            del.alpha = 0;
            [del removeFromSuperview];
        }
    }
    _mSleepScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, _mSleepView.height)];
    _mSleepScrollView.showsHorizontalScrollIndicator = NO;
    _mSleepScrollView.tag = yueSleepScroll;
    [_yueView addSubview:_mSleepScrollView];
    _mSleepScrollView.sd_layout.leftEqualToView(_mSleepView)
    .rightEqualToView(_mSleepView)
    .topEqualToView(_mSleepView)
    .bottomEqualToView(_mSleepView);
    
    
    int seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString *nowString = [formatter stringFromDate:date];
    int now = [nowString intValue];
    
    _mSleepScrollView.contentSize = CGSizeMake((20+40+40*now)*WidthProportion, _mStepScrollView.height);
    _mSleepScrollView.contentOffset = CGPointMake(_mStepScrollView.contentSize.width - CurrentDeviceWidth, 0);
    if(!_sleepDictionary)
    {
        [_mSleepArray removeAllObjects];
        for (int i = 0 ; i < now; i ++)
        {
            NSMutableArray *sleepArray = [[NSMutableArray alloc]init];
            
            NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconds - (now - i) * KONEDAYSECONDS];
            NSMutableArray * lastDaySleepArray= [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
            [sleepArray addObjectsFromArray:lastDaySleepArray];
            
            NSDictionary *todayDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconds - (now - 1 - i) * KONEDAYSECONDS];
            NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:todayDic];
            [sleepArray addObjectsFromArray:todaySleepArray];
             sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
            NSDictionary *sleepDic = [SleepTool sleepDataArrayTodictionary:sleepArray];//睡觉数组。经过判断转字典
            [_mSleepArray addObject:sleepDic];
        }
    }
    else
    {
        [_mSleepArray removeAllObjects];
        for (int i = 0 ; i < now; i ++)
        {
            NSMutableArray *sleepArray = [[NSMutableArray alloc]init];
            
            NSString *lastTime=[[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.todayTimeSeconds - (now - i) * KONEDAYSECONDS andFormat:@"yyyy-MM-dd"];
            NSString *todayTime=[[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.todayTimeSeconds - (now - i - 1) * KONEDAYSECONDS andFormat:@"yyyy-MM-dd"];
            
            NSString *lastStr=_sleepDictionary[lastTime];
            NSString *todayStr=_sleepDictionary[todayTime];
            
            NSMutableArray * lastDaySleepArray=  [SleepTool lastDaySleepDataWithArray:[lastStr componentsSeparatedByString:@","]];
            NSMutableArray * todaySleepArray = [SleepTool  todayDaySleepDataWithArray:[todayStr componentsSeparatedByString:@","]];
            
            [sleepArray addObjectsFromArray:lastDaySleepArray];
            [sleepArray addObjectsFromArray:todaySleepArray];
             sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
            NSDictionary *sleepDic = [SleepTool sleepDataArrayTodictionary:sleepArray];//睡觉数组。经过判断转字典
            [_mSleepArray addObject:sleepDic];
        }
    }
  
    NSMutableArray *weekDateArray = [NSMutableArray new];
    CGFloat mLabelX = 0;
    CGFloat mLabelY = CGRectGetMaxY(_mDownImageView.frame);
    CGFloat mLabelH = 15 * HeightProportion;
    CGFloat mLabelW = 40 * WidthProportion;
    
    for (int i = 0; i < now ; i ++)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds - KONEDAYSECONDS*(now-1-i)];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd"];
        NSString *string = [formatter stringFromDate:date];
        [weekDateArray addObject:string];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = string;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        label.tag = mSleepLabelTag + i;
        [_mSleepScrollView addSubview:label];
        
        mLabelX = 20 * WidthProportion + mLabelW * i;
        label.frame =CGRectMake(mLabelX, mLabelY, mLabelW, mLabelH);
    }
    monthMaxheightSleep = 0;
    maxSleep = 0;
    int maxYueSleepI = 0;
    int mTotalSleep = 0;
    int mTotalDeepSleep = 0;
    int mTotalSleepCount = 0;
    for (int i = 0 ; i < _mSleepArray.count; i ++ )
    {
        NSDictionary *sleepDic = _mSleepArray[i];
        int deepSleep = [sleepDic[@"deepSleep"] intValue];
        int lightSleep = [sleepDic[@"lightSleep"] intValue];
        int awake = [sleepDic[@"awake"] intValue];
        
        int totalSleep = deepSleep + lightSleep + awake;
        if (totalSleep != 0)
        {
            mTotalSleepCount += 1;
            mTotalSleep += totalSleep;
        }
        if (maxSleep < totalSleep)
        {
            maxSleep = totalSleep;
            maxYueSleepI = i;
        }
        if (deepSleep != 0)
        {
            mTotalDeepSleep += deepSleep;
        }
    }
    
    if (maxSleep != 0)
    {
        int aveSleep = mTotalSleep * 10 /mTotalSleepCount;
        int aveDeepSleep = mTotalDeepSleep * 10 / mTotalSleepCount;
        _mSleepHourLabel.text = [NSString stringWithFormat:@"%d",aveSleep/60];
        _mSleepMinLabel.text = [NSString stringWithFormat:@"%d",aveSleep%60];
        _mDeepHourLabel.text = [NSString stringWithFormat:@"%d",aveDeepSleep/60];
        _mDeepMinLabel.text = [NSString stringWithFormat:@"%d",aveDeepSleep%60];
        
        CGFloat monthWidthSleep = CurrentDeviceWidth / 49;
        CGFloat monthTotalSleepHeight = 0;
        CGFloat monthHeightSleep = 0;
        
        monthMaxheightSleep = CGRectGetMaxY(self.mDownImageView.frame) - CGRectGetMaxY(self.yueXialabel.frame);
        
        UIButton *btn = nil;// 传递按钮
        for (int i = 0 ; i < now ; i ++)
        {
            NSDictionary *sleepDic = _mSleepArray[i];
            
            int deepSleep = [sleepDic[@"deepSleep"] intValue];
            
            int lightSleep = [sleepDic[@"lightSleep"] intValue];
            int awake = [sleepDic[@"awake"] intValue];
            //adaLog(@"i = %d  ,deepSleep = %d, lightSleep = %d, deepSleep = %d",i,deepSleep,lightSleep,awake);
            float totalSleep =(float) deepSleep + (float)lightSleep + (float)awake;
            if (totalSleep != 0)
            {
                //adaLog(@"i = %d  , totalSleep = %.0f",i,totalSleep);
                
                UIView * labelView = [_mSleepScrollView viewWithTag:(mSleepLabelTag + i)];
                monthTotalSleepHeight = totalSleep / maxSleep * monthMaxheightSleep;
                
                UIView *awakeView = [[UIView alloc] init];
                [_mSleepScrollView addSubview:awakeView];
                awakeView.backgroundColor = zhouSleepAwakeColor;
                if (awake > 3) {
                    awakeView.layer.cornerRadius = monthWidthSleep/2.;
                    awakeView.clipsToBounds = YES;}
                
                CGFloat awakeViewY = CGRectGetMaxY(self.mDownImageView.frame) - monthTotalSleepHeight;
                monthHeightSleep = awake / totalSleep * monthTotalSleepHeight;
                awakeView.frame = CGRectMake(0, awakeViewY, monthWidthSleep, monthHeightSleep);
                awakeView.centerX = labelView.centerX;
                
                UIView *lightView = [[UIView alloc] init];
                [_mSleepScrollView addSubview:lightView];
                lightView.backgroundColor = zhouSleepLightColor;
                if (lightSleep > 3) {
                    lightView.layer.cornerRadius = monthWidthSleep/2.;
                    lightView.clipsToBounds = YES;}
                
                CGFloat lightViewY = awakeViewY + monthHeightSleep;
                monthHeightSleep = lightSleep / totalSleep * monthTotalSleepHeight;
                lightView.frame = CGRectMake(0, lightViewY, monthWidthSleep, monthHeightSleep);
                lightView.centerX = labelView.centerX;
                
                UIView *view = [[UIView alloc]init];
                view.backgroundColor = zhouSleepDeepColor;
                [_mSleepScrollView addSubview:view];
                if (deepSleep > 3) {
                    view.layer.cornerRadius = monthWidthSleep/2.;
                    view.clipsToBounds = YES;
                }
                CGFloat viewY = lightViewY + monthHeightSleep;
                monthHeightSleep = deepSleep / totalSleep * monthTotalSleepHeight;
                view.frame = CGRectMake(0, viewY, monthWidthSleep, monthHeightSleep);
                view.centerX = labelView.centerX;
                
                
                
                UIButton *button = [[UIButton alloc]init];
                button.backgroundColor = [UIColor clearColor];// button.alpha = 0.5;
                [_mSleepScrollView addSubview:button];
                awakeViewY = CGRectGetMaxY(self.mDownImageView.frame) - monthMaxheightSleep;
                button.frame = CGRectMake(0, awakeViewY, monthWidthSleep * 3, monthMaxheightSleep);
                button.centerX = labelView.centerX;
                button.layer.cornerRadius = monthWidthSleep * 3 /2.;
                button.clipsToBounds = YES;
                button.tag = i;
                [button addTarget:self action:@selector(monthSleepAddLabel:) forControlEvents:UIControlEventTouchUpInside];
                if (maxYueSleepI == i)
                {
                    btn = button;
                    //                    [self monthSleepAddLabel:button];
                }
            }
        }
        if (btn) {
            [self monthSleepAddLabel:btn];
        }
    }
    else
    {
        if (self.monthShowLabelViewSleep)
        {
            [self.monthShowLabelViewSleep removeFromSuperview];
            self.monthShowLabelViewSleep = nil;
        }
        //    [_mSleepScrollView addSubview:self.monthShowLabelViewSleep];
    }
}


-(void)monthSleepAddLabel:(UIButton *)button
{
    NSDictionary *sleepDic = _mSleepArray[button.tag];
    float deepSleep = [sleepDic[@"deepSleep"] floatValue];
    int lightSleep = [sleepDic[@"lightSleep"] intValue];
    int awake = [sleepDic[@"awake"] intValue];
    float totalSleep =(float) deepSleep + lightSleep + awake;
    float viewHeitht = totalSleep/maxSleep * monthMaxheightSleep;
    //背景图
    CGFloat imageViewX = 0;
    CGFloat imageViewW = 80 * WidthProportion;
    CGFloat imageViewH = 43 * HeightProportion;
    //    CGFloat buttonY = button.frame.origin.y;
    //    CGFloat whiteViewMaxY = CGRectGetMaxY(_yueXialabel.frame);
    CGFloat imageViewY = 0;
    if (monthMaxheightSleep - viewHeitht > imageViewH) {
        imageViewY = CGRectGetMaxY(self.mDownImageView.frame) - (viewHeitht + imageViewH);
    } else {
        imageViewY = CGRectGetMaxY(self.mDownImageView.frame) - (viewHeitht - imageViewH / 4);
    }
    self.monthShowLabelViewSleep.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.monthShowLabelViewSleep.centerX = button.centerX;
    
    //开始添加背景图上的各种控件
    CGFloat blueViewX = 5 * WidthProportion;
    CGFloat blueViewW = 8 * WidthProportion;
    CGFloat blueViewH = blueViewW;
    CGFloat blueViewY = (20 * HeightProportion - blueViewW) / 2;
    self.monthBlueView.frame = CGRectMake(blueViewX, blueViewY, blueViewW, blueViewH);
    
    CGFloat showDeepSleeplabelX = 2 * WidthProportion + CGRectGetMaxX(self.monthBlueView.frame);
    CGFloat showDeepSleeplabelY = 0;
    CGFloat showDeepSleeplabelW = imageViewW / 2 - showDeepSleeplabelX;
    CGFloat showDeepSleeplabelH = 20 * HeightProportion;
    self.monthShowDeepSleeplabel.frame = CGRectMake(showDeepSleeplabelX, showDeepSleeplabelY, showDeepSleeplabelW, showDeepSleeplabelH);
    //    self.showDeepSleeplabel.backgroundColor = [UIColor redColor];
    
    CGFloat greenViewX = CGRectGetMaxX(self.monthShowDeepSleeplabel.frame) + 5 * WidthProportion;
    CGFloat greenViewY = blueViewY;
    CGFloat greenViewW = blueViewW;
    CGFloat greenViewH = greenViewW;
    self.monthGreenView.frame = CGRectMake(greenViewX, greenViewY, greenViewW, greenViewH);
    
    CGFloat showLightSleeplabelX = 2 * WidthProportion + CGRectGetMaxX(self.monthGreenView.frame);
    CGFloat showLightSleeplabelY = 0;
    CGFloat showLightSleeplabelW = imageViewW - showLightSleeplabelX;
    CGFloat showLightSleeplabelH = showDeepSleeplabelH;
    self.monthShowLightSleeplabel.frame = CGRectMake(showLightSleeplabelX, showLightSleeplabelY, showLightSleeplabelW, showLightSleeplabelH);
    //    self.showLightSleeplabel.backgroundColor = [UIColor blackColor];
    
    
    CGFloat orangeViewX = blueViewX;
    CGFloat orangeViewY = blueViewY + CGRectGetMaxY(self.monthShowDeepSleeplabel.frame);
    CGFloat orangeViewW = blueViewW;
    CGFloat orangeViewH = orangeViewW;
    self.monthOrangeView.frame = CGRectMake(orangeViewX, orangeViewY, orangeViewW, orangeViewH);
    
    CGFloat showAwakeSleeplabelX = 2 * WidthProportion + CGRectGetMaxX(self.monthOrangeView.frame);
    CGFloat showAwakeSleeplabelY = CGRectGetMaxY(self.monthShowDeepSleeplabel.frame);
    CGFloat showAwakeSleeplabelW = showDeepSleeplabelW;
    CGFloat showAwakeSleeplabelH = showDeepSleeplabelH;
    self.monthShowAwakeSleeplabel.frame = CGRectMake(showAwakeSleeplabelX, showAwakeSleeplabelY, showAwakeSleeplabelW, showAwakeSleeplabelH);
    
    self.monthShowDeepSleeplabel.adjustsFontSizeToFitWidth = YES;
    
    
    CGFloat fontSize = 10;
    NSString *stringDeep = [NSString stringWithFormat:@"%2.1f",deepSleep * 10 / 60.0];
    NSString *stringLight = [NSString stringWithFormat:@"%2.1f",lightSleep * 10 / 60.0];
    NSString *stringAwake = [NSString stringWithFormat:@"%2.1f",awake * 10/ 60.0];
    if ([stringDeep isEqualToString:@"0.0"])
        stringDeep = @"0";
    if ([stringLight isEqualToString:@"0.0"])
        stringLight = @"0";
    if ([stringAwake isEqualToString:@"0.0"])
        stringAwake = @"0";
    
    self.monthShowDeepSleeplabel.attributedText = [NSAttributedString makeAttributedStringWithnumBer:stringDeep Unit:@"h" WithFont:fontSize];
    self.monthShowLightSleeplabel.attributedText = [NSAttributedString makeAttributedStringWithnumBer:stringLight Unit:@"h" WithFont:fontSize];
    self.monthShowAwakeSleeplabel.attributedText = [NSAttributedString makeAttributedStringWithnumBer:stringAwake Unit:@"h" WithFont:fontSize];
    
    [self.monthShowDeepSleeplabel adjustsFontSizeToFitWidth];
    [self.monthShowLightSleeplabel adjustsFontSizeToFitWidth];
    [self.monthShowAwakeSleeplabel adjustsFontSizeToFitWidth];
    
    [_mSleepScrollView addSubview:self.monthShowLabelViewSleep];
    [self.monthShowLabelViewSleep addSubview:self.monthBlueView];
    [self.monthShowLabelViewSleep addSubview:self.monthGreenView];
    [self.monthShowLabelViewSleep addSubview:self.monthOrangeView];
    [self.monthShowLabelViewSleep addSubview:self.monthShowDeepSleeplabel];
    [self.monthShowLabelViewSleep addSubview:self.monthShowLightSleeplabel];
    [self.monthShowLabelViewSleep addSubview:self.monthShowAwakeSleeplabel];
}

- (void)drawMStepView
{
    for (UIView *del in _yueView.subviews) {
        if (del.tag == yueStepScroll) {
            del.alpha = 0;
            [del removeFromSuperview];
        }
    }
    
    _mStepScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, _mStepView.height)];
    _mStepScrollView.showsHorizontalScrollIndicator = NO;
    _mStepScrollView.tag = yueStepScroll;
    [_yueView addSubview:_mStepScrollView];
    
    _mStepScrollView.sd_layout.leftEqualToView(_mStepView)
    .rightEqualToView(_mStepView)
    .topEqualToView(_mStepView)
    .bottomEqualToView(_mStepView);
    
    _mStepArray = [[NSMutableArray alloc]init];
    _mCostArray = [[NSMutableArray alloc] init];
    _mStepTagArray = [[NSMutableArray alloc] init];
    int seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString *nowString = [formatter stringFromDate:date];
    int now = [nowString intValue];
    if(!_stepDictionary)
    {
        for (int i = 0 ; i < now; i ++)
        {
            NSDictionary *dic = [[SQLdataManger getInstance] getTotalDataWith:seconds - (now-1-i)*KONEDAYSECONDS];
            NSNumber *mStep = dic[@"TotalSteps_DayData"];
            NSNumber *mCost = dic[@"TotalCosts_DayData"];
            NSNumber *mStepTag = dic[@"stepsPlan"];
            NSNumber *msleepTag = dic[@"sleepPlan"];
            if (msleepTag)
            {
                [_mSleepTagArray addObject:msleepTag];
            }
            if(mStep)
            {
                [_mStepArray addObject:mStep];
                [_mCostArray addObject:mCost];
                [_mStepTagArray addObject:mStepTag];
            }
            else
            {
                [_mStepArray addObject:@0];
                [_mCostArray addObject:@0];
                [_mStepTagArray addObject:@0];
            }
        }
    }
    else
    {
        for (int i = 0 ; i < now; i ++)
        {
            NSString *time=[[TimeCallManager getInstance] getTimeStringWithSeconds:seconds - (now-1-i)*KONEDAYSECONDS andFormat:@"yyyy-MM-dd"];
            
            NSNumber *mStep = _stepDictionary[time][@"step"];
            NSNumber *mCost = _stepDictionary[time][@"calorie"];
            NSNumber *mStepTag = _stepDictionary[time][@"stepTarget"];
            
            if(mStep)
            {
                [_mStepArray addObject:mStep];
                [_mCostArray addObject:mCost];
                [_mStepTagArray addObject:mStepTag];
            }
            else
            {
                [_mStepArray addObject:@0];
                [_mCostArray addObject:@0];
                [_mStepTagArray addObject:@0];
            }
        }
    }
  
    NSMutableArray *weekDateArray = [NSMutableArray new];
    
    NSString *mounth = nil;
    
    CGFloat yueriLabelX = 0;
    CGFloat yueriLabelY = CGRectGetMaxY(_mUpImageView.frame);
    CGFloat yueriLabelH = 15 * HeightProportion;
    CGFloat yueriLabelW = 40 * WidthProportion;
    for (int i = 0; i < now ; i ++)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds - KONEDAYSECONDS*(now-1-i)];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd"];
        NSString *string = [formatter stringFromDate:date];
        [weekDateArray addObject:string];
        
        NSDateFormatter *mouthFormatter = [[NSDateFormatter alloc]init];
        [mouthFormatter setDateFormat:@"MM"];
        mounth = [mouthFormatter stringFromDate:date];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = string;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        [_mStepScrollView addSubview:label];
        label.tag = mStepLabelTag + [string integerValue];
        
        yueriLabelX = 20 * WidthProportion + yueriLabelW * i;
        label.frame =CGRectMake(yueriLabelX, yueriLabelY, yueriLabelW, yueriLabelH);
        //        label.sd_layout.leftSpaceToView(_mStepScrollView,10+40*i)
        //        .heightIs(15)
        //        .widthIs(20)
        //        .bottomSpaceToView(_mStepScrollView,40);
    }
    _mouthLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@月", nil),mounth];
    
    
    int mTotalStep = 0;
    int mTotalCost = 0;
    int mComCount = 0;
    int valueCout = 0;
    monthStepHeight = 0;
    yueMaxmStep = 0;
    int yueMaxmStepI = 0;
    for (int i = 0 ; i < now ; i ++)
    {
        int step = [_mStepArray[i] intValue];
        int cost = [_mCostArray[i] intValue];
        int mStepTag = [_mStepTagArray[i] intValue];
        mTotalStep += step;
        mTotalCost += cost;
        if (step!=0)
        {
            valueCout ++;
        }
        if (step >= mStepTag && mStepTag != 0)
        {
            mComCount ++;
        }
        if (yueMaxmStep < step)
        {
            yueMaxmStep = step;
            yueMaxmStepI = i ;
        }
    }
    
    if (valueCout != 0)
    {
        _mAveStepLabel.text = [NSString stringWithFormat:@"%d",mTotalStep/valueCout];
        _mAveCostLabel.text = [NSString stringWithFormat:@"%d",mTotalCost/valueCout];
    }
    else
    {
        _mAveStepLabel.text = @"0";
        _mAveCostLabel.text = @"0";
    }
    _mStepComLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d次", nil),mComCount];
    _mMaxStepLabel.text = [NSString stringWithFormat:@"%.0f%@",yueMaxmStep,NSLocalizedString(@"步", nil)];
    //        _mMaxStepLabel.backgroundColor = allColorRed;
    
    _mStepScrollView.contentSize = CGSizeMake((20+40+40*now)*WidthProportion, _mStepScrollView.height);
    _mStepScrollView.contentOffset = CGPointMake(_mStepScrollView.contentSize.width - CurrentDeviceWidth, 0);
    if (yueMaxmStep != 0)
    {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewH = 0;
        CGFloat viewW =  CurrentDeviceWidth / 49;;
        monthStepHeight = CGRectGetMaxY(_mUpImageView.frame) - CGRectGetMaxY(_yueWhiteLineView.frame);
        for (int i = 0 ; i < now; i ++)
        {
            int step = [_mStepArray[i] intValue];
            if (step != 0)
            {
                UIView *view = [[UIView alloc]init];
                view.backgroundColor = allColorWhite;
                [_mStepScrollView addSubview:view];
                
                viewH = ((CGFloat)step / yueMaxmStep) * monthStepHeight;
                viewX = 0;
                viewY = CGRectGetMaxY(_mUpImageView.frame) - viewH;
                view.frame = CGRectMake(viewX, viewY, viewW, viewH);
                
                UIView *tagView = [_mStepScrollView viewWithTag:(mStepLabelTag + i + 1)];
                view.centerX = tagView.centerX;
                view.layer.cornerRadius = viewW / 2;
                
                UIButton *button = [[UIButton alloc]init];
                button.backgroundColor = [UIColor clearColor];// button.alpha = 0.5;
                [_mStepScrollView addSubview:button];
                viewY = CGRectGetMaxY(_mUpImageView.frame) - monthStepHeight;
                button.frame = CGRectMake(viewX, viewY, viewW * 3, monthStepHeight);
                button.centerX = view.centerX;
                button.layer.cornerRadius = viewX/2.;
                button.clipsToBounds = YES;
                
                button.tag = i+100;
                [button addTarget:self action:@selector(monthStepAddLabel:) forControlEvents:UIControlEventTouchUpInside];
                if (yueMaxmStepI == i)
                {
                    [self monthStepAddLabel:button];
                }
            }
        }
    }
    
}

-(void)monthStepAddLabel:(UIButton *)button
{
    //     CGRectGetMaxY(_mUpImageView.frame) - CGRectGetMaxY(_yueWhiteLineView.frame);
    int step = [_mStepArray[button.tag - 100] intValue];
    float viewHeitht = step/yueMaxmStep * monthStepHeight;
    CGFloat imageViewX = 0;
    CGFloat imageViewW = 45*WidthProportion;
    if(step>10000)
    {
        imageViewW = 50*WidthProportion;
    }
    CGFloat imageViewH = imageViewW;
    //    CGFloat whiteViewMaxY = CGRectGetMaxY(_yueWhiteLineView.frame);
    
    CGFloat imageViewY = 0;
    if (monthStepHeight - viewHeitht > imageViewW) {
        imageViewY =  CGRectGetMaxY(_mUpImageView.frame) - (viewHeitht + imageViewW);
    } else {
        imageViewY = CGRectGetMaxY(_mUpImageView.frame) - (viewHeitht - imageViewW / 4);
    }
    self.monthShowLabelView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.monthShowLabelView.centerX = button.centerX;
    
    CGFloat labelNumberX = -5*WidthProportion;
    CGFloat labelNumberY = 5*HeightProportion;
    CGFloat labelNumberW = imageViewW+10*WidthProportion;
    CGFloat labelNumberH = (imageViewH - 2 * labelNumberY) / 2;
    self.monthLabelNumber.frame = CGRectMake(labelNumberX, labelNumberY, labelNumberW, labelNumberH);
    
    
    CGFloat labelUnitX = 0;
    CGFloat labelUnitY = CGRectGetMaxY(self.monthLabelNumber.frame);
    CGFloat labelUnitW = imageViewW;
    CGFloat labelUnitH = labelNumberH*(3.0/5.0);
    self.monthLabelUnit.frame = CGRectMake(labelUnitX, labelUnitY, labelUnitW, labelUnitH);
    
    //设置显示的值
    self.monthLabelNumber.text = [NSString stringWithFormat:@"%d",step];
    self.monthLabelNumber.adjustsFontSizeToFitWidth = YES;
    self.monthLabelUnit.text = @"steps";
    self.monthLabelNumber.textColor =  fontcolorMain;
    self.monthLabelUnit.textColor =  fontcolorless;
    [_mStepScrollView addSubview:self.monthShowLabelView];
    [self.monthShowLabelView addSubview:self.monthLabelUnit];
    [self.monthShowLabelView addSubview:self.monthLabelNumber];
}

- (void)loadWStepView
{
    //    _wStepView.sd_layout.heightIs(_zhouView.height/2);
    _stepArray = [[NSMutableArray alloc]init];
    _wCostArray = [[NSMutableArray alloc]init];
    _wStepTagArray = [[NSMutableArray alloc]init];
    if(!_stepDictionary)
    {
        int seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
        for (int i = 0; i <7; i ++)
        {
            NSDictionary *dic = [[SQLdataManger getInstance] getTotalDataWith:seconds - (6 - i) * KONEDAYSECONDS];
            NSNumber *Steps = dic[@"TotalSteps_DayData"];
            NSNumber *cost = dic[@"TotalCosts_DayData"];
            NSNumber *wStepTag = dic[@"stepsPlan"];
            if (Steps)
            {
                [_wCostArray addObject:cost];
                [_stepArray addObject:Steps];
                [_wStepTagArray addObject:wStepTag];
            }
            else
            {
                [_wCostArray addObject:@0];
                [_stepArray addObject:@0];
                [_wStepTagArray addObject:@0];
            }
            //                    [_stepArray addObject:[NSNumber numberWithInt:i + 1]];
        }
    }
    else
    {
        for (int i = 0; i <7; i ++)
        {
            NSString *time=[[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.todayTimeSeconds - (6 - i) * KONEDAYSECONDS andFormat:@"yyyy-MM-dd"];
            NSNumber *Steps = _stepDictionary[time][@"step"];
            NSNumber *cost = _stepDictionary[time][@"calorie"];
            NSNumber *wStepTag = _stepDictionary[time][@"stepTarget"];
            if (Steps)
            {
                [_wCostArray addObject:cost];
                [_stepArray addObject:Steps];
                [_wStepTagArray addObject:wStepTag];
            }
            else
            {
                [_wCostArray addObject:@0];
                [_stepArray addObject:@0];
                [_wStepTagArray addObject:@0];
            }
        }
    }
    
    int wMaxStep = 0;
    int totalStep = 0;
    int totalCost = 0;
    int completeCount = 0;
    int valueCount = 0;
    for (int i = 0; i < 7; i ++)
    {
        int step = [_stepArray[i] intValue];
        int cost = [_wCostArray[i] intValue];
        int wstepTag = [_wStepTagArray[i] intValue];
        if (step >= wstepTag && wstepTag != 0)
        {
            completeCount ++;
        }
        if (step != 0)
        {
            valueCount ++;
        }
        totalStep += step;
        totalCost += cost;
        if (wMaxStep < step)
        {
            wMaxStep = step;
        }
    }
    _wMaxStepLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d步", nil),wMaxStep];
    
    _wStepComLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d次", nil),completeCount];
    
    _wAveStepLabel.text = [NSString stringWithFormat:@"%d",valueCount == 0?0:totalStep/valueCount];
    _wAveCostLabel.text = [NSString stringWithFormat:@"%d",valueCount == 0?0:totalCost/valueCount];
    [self drawWStepView];
}

- (void)drawWStepView
{
    //删除之前添加的lable。
    for (UIView *del in _wStepView.subviews) {
        //label
        if (del.tag>=labelTag&&del.tag<(labelTag+7)) {
            del.alpha = 0;
            [del removeFromSuperview];
        }
        //view
        if (del.tag>=20&&del.tag<27) {
            del.alpha = 0;
            [del removeFromSuperview];
        }
        //button
        if (del.tag>=10&&del.tag<17) {
            del.alpha = 0;
            [del removeFromSuperview];
        }
    }
    
    int seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    
    NSMutableArray *weekDateArray = [NSMutableArray new];
    for (int i = 0; i < 7 ; i ++)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds - KONEDAYSECONDS*(6-i)];
        NSDateFormatter *formatter = [NSDateFormatter new];
        
        [formatter setDateFormat:@"MM/dd"];
        
        NSString *string = [formatter stringFromDate:date];
        [weekDateArray addObject:string];
    }
    zhouMaxStep = 0;
    int maxIndex = 0;
    CGFloat dateLabelX = 0;
    CGFloat dateLabelY = CGRectGetMaxY(_UpImageView.frame);
    CGFloat dateLabelH = 15 * HeightProportion;
    CGFloat dateLabelW = 40 * WidthProportion;
    for (int index = 0; index < 7; index ++)
    {
        int step = [_stepArray[index] intValue];
        if (zhouMaxStep < step)
        {
            zhouMaxStep = step;
            maxIndex = index;
        }
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = weekDateArray[index];
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.textColor = fontcolorless;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.tag = labelTag + index;
        [_wStepView addSubview:dateLabel];
        
        dateLabelX = 20 * WidthProportion + dateLabelW *index;
        dateLabel.frame =CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH);
        
    }
    MaxHeight = CGRectGetMaxY(_UpImageView.frame) - CGRectGetMaxY(_whiteView.frame);
    
    if (zhouMaxStep != 0 )
    {
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        CGFloat viewW = CurrentDeviceWidth / 49;
        CGFloat viewH = 0;
        
        for (int index = 0; index < 7 ; index ++)
        {
            int step = [_stepArray[index] intValue];
            if (step != 0)
            {
                UIView *view = [[UIView alloc]init];
                view.backgroundColor = [UIColor whiteColor];
                [self.wStepView addSubview:view];
                viewH = step / zhouMaxStep * MaxHeight;
                viewX = 0;
                viewY = CGRectGetMaxY(_UpImageView.frame) - viewH;
                view.frame = CGRectMake(viewX, viewY, viewW, viewH);
                UIView *tagView = [self.wStepView viewWithTag:(labelTag + index)];
                view.centerX = tagView.centerX;
                view.layer.cornerRadius = viewW / 2;
                view.tag = index + 20;
                
                UIButton *button = [[UIButton alloc]init];
                button.backgroundColor = [UIColor clearColor];
                //  button.alpha = 0.6;
                [self.wStepView addSubview:button];
                viewY =CGRectGetMaxY(_UpImageView.frame) - MaxHeight;
                button.frame = CGRectMake(viewX, viewY, viewW * 3, MaxHeight);
                button.centerX = view.centerX;
                button.layer.cornerRadius = viewX/2.;
                button.clipsToBounds = YES;
                
                button.tag = index + 10;
                [button addTarget:self action:@selector(addLabel:) forControlEvents:UIControlEventTouchUpInside];
                if (index == maxIndex)
                {
                    [self addLabel:button];
                }
            }
        }
    }
    else
    {
        if(self.showLabelView)
        {
            [self.showLabelView removeFromSuperview];
            self.showLabelView = nil;
        }
        //    [self.wStepView addSubview:self.showLabelView];
    }
}

-(void)addLabel:(UIButton *)button
{
    int step = [_stepArray[button.tag - 10] intValue];//
    float viewHeitht = step/zhouMaxStep * MaxHeight;
    CGFloat imageViewX = 0;
    CGFloat imageViewW = 43*WidthProportion;
    if (step>10000) {
        imageViewW = 50*WidthProportion;
    }
    CGFloat buttonY = button.frame.origin.y;
    CGFloat whiteViewMaxY = CGRectGetMaxY(_whiteView.frame);
    
    CGFloat imageViewY = buttonY - whiteViewMaxY;
    if (MaxHeight - viewHeitht > imageViewW) {
        imageViewY = CGRectGetMaxY(_UpImageView.frame) - (viewHeitht + imageViewW);
    } else {
        imageViewY = CGRectGetMaxY(_UpImageView.frame) - (viewHeitht - imageViewW / 4);
    }
    CGFloat imageViewH = imageViewW;
    self.showLabelView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.showLabelView.centerX = button.centerX;
    //    self.showLabelView.backgroundColor = [UIColor redColor];
    
    CGFloat labelNumberX = -5*WidthProportion;
    CGFloat labelNumberY = 5*HeightProportion;
    CGFloat labelNumberW = imageViewW+10*WidthProportion;
    CGFloat labelNumberH = (imageViewH - 2 * labelNumberY) / 2;
    self.labelNumber.frame = CGRectMake(labelNumberX, labelNumberY, labelNumberW, labelNumberH);
    
    //    self.labelNumber.backgroundColor = [UIColor redColor];
    
    CGFloat labelUnitX = 0;
    CGFloat labelUnitY = CGRectGetMaxY(self.labelNumber.frame);
    CGFloat labelUnitW = imageViewW;
    CGFloat labelUnitH = labelNumberH*(3.0/5.0);//高度
    self.labelUnit.frame = CGRectMake(labelUnitX, labelUnitY, labelUnitW, labelUnitH);
//    self.labelUnit.backgroundColor = allColorRed
    //设置显示的值
    self.labelNumber.text = [NSString stringWithFormat:@"%d",step];
    self.labelNumber.adjustsFontSizeToFitWidth = YES;
    self.labelUnit.text = @"steps";
    _labelNumber.textColor =  fontcolorMain;
    _labelUnit.textColor =  fontcolorless;
    [self.wStepView addSubview:self.showLabelView];
    [self.showLabelView addSubview:_labelNumber];
    [self.showLabelView addSubview:_labelUnit];
}

- (void)loadWSleepView
{
    _wSleepArray = [[NSMutableArray alloc]init];
    if(!_sleepDictionary)
    {
        int seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
        
        for (int i = 0; i <7; i ++)
        {
            NSMutableArray *sleepArray = [[NSMutableArray alloc]init];
            
            NSDictionary *lastDayDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconds - (7 - i) * KONEDAYSECONDS];
            NSMutableArray * lastDaySleepArray= [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
            
            NSDictionary *todayDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:seconds - (7 - i -1) * KONEDAYSECONDS];
            NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:todayDic];
            
            [sleepArray addObjectsFromArray:lastDaySleepArray];
            [sleepArray addObjectsFromArray:todaySleepArray];
            sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
            NSDictionary *sleepDic = [SleepTool sleepDataArrayTodictionary:sleepArray];//睡觉数组。经过判断转字典
            [_wSleepArray addObject:sleepDic];
            
        }
    }
    else
    {
        for (int i = 0; i <7; i ++)
        {
            NSMutableArray *sleepArray = [[NSMutableArray alloc]init];
            
            NSString *lastTime=[[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.todayTimeSeconds - (7 - i) * KONEDAYSECONDS andFormat:@"yyyy-MM-dd"];
            NSString *todayTime=[[TimeCallManager getInstance] getTimeStringWithSeconds:kHCH.todayTimeSeconds - (7 - i - 1) * KONEDAYSECONDS andFormat:@"yyyy-MM-dd"];
            NSString *lastStr=_sleepDictionary[lastTime];
            NSString *todayStr=_sleepDictionary[todayTime];
            
            NSMutableArray * lastDaySleepArray=  [SleepTool lastDaySleepDataWithArray:[lastStr componentsSeparatedByString:@","]];
            [sleepArray addObjectsFromArray:lastDaySleepArray];
            
            NSArray *todaySleepArray = [SleepTool  todayDaySleepDataWithArray:[todayStr componentsSeparatedByString:@","]];
            [sleepArray addObjectsFromArray:todaySleepArray];
           sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
            NSDictionary *sleepDic = [SleepTool sleepDataArrayTodictionary:sleepArray];//睡觉数组。经过判断转字典
            [_wSleepArray addObject:sleepDic];
        }
    }
    [self drawWSleepView];
}

- (void)drawWSleepView
{
    for (UIView *del in _wSleepView.subviews)
    {
        if (del.tag>=sleepLabelTag&&del.tag<sleepLabelTag+7)
        {
            del.alpha = 0;
            [del removeFromSuperview];
        }
        if (del.tag>=50&&del.tag<50+7)
        {
            del.alpha = 0;
            [del removeFromSuperview];
        }
        if (del.tag>=60&&del.tag<60+7)
        {
            del.alpha = 0;
            [del removeFromSuperview];
        }
        if (del.tag>=70&&del.tag<70+7)
        {
            del.alpha = 0;
            [del removeFromSuperview];
        }
        if (del.tag>=80&&del.tag<80+7)
        {
            del.alpha = 0;
            [del removeFromSuperview];
        }
    }
    int seconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    NSMutableArray *weekDateArray = [NSMutableArray new];
    for (int i = 0; i < 7 ; i ++)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds - KONEDAYSECONDS*(6-i)];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"MM/dd"];
        NSString *string = [formatter stringFromDate:date];
        [weekDateArray addObject:string];
    }
    int wTotalSleep = 0;
    int wTotalDeepSleep = 0;
    int wTotalSleepCount = 0;
    zhouMaxSleep = 0 ;
    int zhouMaxSleepIndex = 0;
    zhouMaxheightSleep = 0;
 
    CGFloat dateLabelX = 0;
    CGFloat dateLabelY = CGRectGetMaxY(_DownImageView.frame);
    CGFloat dateLabelH = 15 * HeightProportion;
    CGFloat dateLabelW = 40 * WidthProportion;
    for (int index = 0; index < 7; index ++)
    {
        NSDictionary *sleepDic = _wSleepArray[index];
        int deepSleep = [sleepDic[@"deepSleep"] intValue];
        int lightSleep = [sleepDic[@"lightSleep"] intValue];
        int awake = [sleepDic[@"awake"] intValue];
        int totalSleep = deepSleep + lightSleep + awake;
        if (totalSleep != 0)
        {
            wTotalSleepCount ++;
            wTotalSleep += totalSleep;
        }
        if (zhouMaxSleep < totalSleep)
        {
            zhouMaxSleep = totalSleep;
            zhouMaxSleepIndex = index;
        }
        if (deepSleep != 0)
        {
            wTotalDeepSleep += deepSleep;
        }
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = weekDateArray[index];
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.tag = sleepLabelTag + index;
        [_wSleepView addSubview:dateLabel];
        
        dateLabelX = 20 * WidthProportion + dateLabelW *index;
        dateLabel.frame =CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH);
        //            dateLabel.sd_layout.leftSpaceToView(_wSleepView,CurrentDeviceWidth/7.0 * (index))
        //            .bottomSpaceToView(_wSleepView,40)
        //            .widthIs(CurrentDeviceWidth/7.0)
        //            .heightIs(15);
    }
    
    if (zhouMaxSleep != 0)
    {
        int aveSleep = wTotalSleep * 10 /wTotalSleepCount;
        int aveDeepSleep = wTotalDeepSleep * 10 /wTotalSleepCount;
        
        _wSleepHour.text = [NSString stringWithFormat:@"%d",aveSleep/60];
        _wSleepMin.text =  [NSString stringWithFormat:@"%d",aveSleep%60];
        _wDeepSleepHour.text =  [NSString stringWithFormat:@"%d",aveDeepSleep/60];
        _wDeepSleepMin.text =  [NSString stringWithFormat:@"%d",aveDeepSleep%60];
        CGFloat widthSleep = CurrentDeviceWidth / 49;
        CGFloat totalSleepHeight = 0;
        CGFloat HeightSleep = 0;
        
        zhouMaxheightSleep = CGRectGetMaxY(self.DownImageView.frame) - CGRectGetMaxY(self.erlineLabel.frame);
        
        UIButton *zhouMaxSleepIndexBtn = nil;//用于传递按钮
        
        for (int index = 0 ; index < 7; index ++)
        {
            NSDictionary *sleepDic = _wSleepArray[index];
            float deepSleep = [sleepDic[@"deepSleep"] floatValue];
            int lightSleep = [sleepDic[@"lightSleep"] intValue];
            int awake = [sleepDic[@"awake"] intValue];
            
            float totalSleep = deepSleep + lightSleep + awake;
            if (totalSleep != 0)
            {
                UIView * labelView = [self.wSleepView viewWithTag:(sleepLabelTag + index)];
                totalSleepHeight = totalSleep / zhouMaxSleep * zhouMaxheightSleep;
                
                UIView *awakeView = [[UIView alloc] init];
                [_wSleepView addSubview:awakeView];
                awakeView.backgroundColor = zhouSleepAwakeColor;
                awakeView.tag = 50+index;
                if (awake > 3) {
                    awakeView.layer.cornerRadius = widthSleep/2.;
                    awakeView.clipsToBounds = YES;}
                
                CGFloat awakeViewY = CGRectGetMaxY(self.DownImageView.frame) - totalSleepHeight;
                HeightSleep = awake / totalSleep * totalSleepHeight;
                awakeView.frame = CGRectMake(0, awakeViewY, widthSleep, HeightSleep);
                awakeView.centerX = labelView.centerX;
                
                UIView *lightView = [[UIView alloc] init];
                [_wSleepView addSubview:lightView];
                lightView.backgroundColor = zhouSleepLightColor;
                awakeView.tag = 60+index;
                if (lightSleep > 3) {
                    lightView.layer.cornerRadius = widthSleep/2.;
                    lightView.clipsToBounds = YES;}
                
                CGFloat lightViewY = awakeViewY + HeightSleep;
                HeightSleep = lightSleep / totalSleep * totalSleepHeight;
                lightView.frame = CGRectMake(0, lightViewY, widthSleep, HeightSleep);
                lightView.centerX = labelView.centerX;
                
                UIView *view = [[UIView alloc]init];
                view.backgroundColor = zhouSleepDeepColor;
                [_wSleepView addSubview:view];
                awakeView.tag = 70+index;
                if (deepSleep > 3) {
                    view.layer.cornerRadius = widthSleep/2.;
                    view.clipsToBounds = YES;
                }
                CGFloat viewY = lightViewY + HeightSleep;
                HeightSleep = deepSleep / totalSleep * totalSleepHeight;
                view.frame = CGRectMake(0, viewY, widthSleep, HeightSleep);
                view.centerX = labelView.centerX;
                
                
                
                UIButton *button = [[UIButton alloc]init];
                button.backgroundColor = [UIColor clearColor];//button.alpha = 0.5;
                [self.wSleepView addSubview:button];
                awakeViewY = CGRectGetMaxY(self.DownImageView.frame) - zhouMaxheightSleep;
                button.frame = CGRectMake(0, awakeViewY, widthSleep * 3, zhouMaxheightSleep);
                button.centerX = labelView.centerX;
                button.layer.cornerRadius = widthSleep * 3 /2.;
                button.clipsToBounds = YES;
                button.tag = index+80;
                [button addTarget:self action:@selector(sleepAddLabel:) forControlEvents:UIControlEventTouchUpInside];
                if (zhouMaxSleepIndex == index)
                {
                    zhouMaxSleepIndexBtn = button;
                    //                    [self sleepAddLabel:button];
                }
            }
        }
        if (zhouMaxSleepIndexBtn)
        {
            [self sleepAddLabel:zhouMaxSleepIndexBtn];
        }
    }
    else
    {
        if (self.showLabelViewSleep) {
            [self.showLabelViewSleep removeFromSuperview];
            self.showLabelViewSleep = nil;
        }
        //    [self.wSleepView addSubview:self.showLabelViewSleep];
    }
}


-(void)sleepAddLabel:(UIButton *)button
{
    NSDictionary *sleepDic = _wSleepArray[button.tag-80];
    float deepSleep = [sleepDic[@"deepSleep"] floatValue];
    int lightSleep = [sleepDic[@"lightSleep"] intValue];
    int awake = [sleepDic[@"awake"] intValue];
    float totalSleep = deepSleep + lightSleep + awake;
    CGFloat totalSleepHeight = totalSleep / zhouMaxSleep * zhouMaxheightSleep;
    //背景图
    CGFloat imageViewX = 0;
    CGFloat imageViewW = 80 * WidthProportion;
    CGFloat imageViewH = 43 * HeightProportion;
    
    //    CGFloat buttonY = button.frame.origin.y;
    //    CGFloat whiteViewMaxY = CGRectGetMaxY(_erlineLabel.frame);
    CGFloat imageViewY = 0;
    if (zhouMaxheightSleep - totalSleepHeight > imageViewH)
    {
        imageViewY = CGRectGetMaxY(self.DownImageView.frame) - totalSleepHeight - imageViewH;
    }
    else
    {
        imageViewY = CGRectGetMaxY(self.DownImageView.frame) - (totalSleepHeight - imageViewH / 4);
    }
    self.showLabelViewSleep.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.showLabelViewSleep.centerX = button.centerX;
    
    //开始添加背景图上的各种控件
    CGFloat blueViewX = 5 * WidthProportion;
    CGFloat blueViewW = 8 * WidthProportion;
    CGFloat blueViewH = blueViewW;
    CGFloat blueViewY = (20 * HeightProportion - blueViewW) / 2;
    self.blueView.frame = CGRectMake(blueViewX, blueViewY, blueViewW, blueViewH);
    
    CGFloat showDeepSleeplabelX = 2 * WidthProportion + CGRectGetMaxX(self.blueView.frame);
    CGFloat showDeepSleeplabelY = 0;
    CGFloat showDeepSleeplabelW = imageViewW / 2 - showDeepSleeplabelX;
    CGFloat showDeepSleeplabelH = 20 * HeightProportion;
    self.showDeepSleeplabel.frame = CGRectMake(showDeepSleeplabelX, showDeepSleeplabelY, showDeepSleeplabelW, showDeepSleeplabelH);
    //    self.showDeepSleeplabel.backgroundColor = [UIColor redColor];
    
    CGFloat greenViewX = CGRectGetMaxX(self.showDeepSleeplabel.frame) + 5 * WidthProportion;
    CGFloat greenViewY = blueViewY;
    CGFloat greenViewW = blueViewW;
    CGFloat greenViewH = greenViewW;
    self.greenView.frame = CGRectMake(greenViewX, greenViewY, greenViewW, greenViewH);
    
    CGFloat showLightSleeplabelX = 2 * WidthProportion + CGRectGetMaxX(self.greenView.frame);
    CGFloat showLightSleeplabelY = 0;
    CGFloat showLightSleeplabelW = imageViewW - showLightSleeplabelX;
    CGFloat showLightSleeplabelH = showDeepSleeplabelH;
    self.showLightSleeplabel.frame = CGRectMake(showLightSleeplabelX, showLightSleeplabelY, showLightSleeplabelW, showLightSleeplabelH);
    
    
    CGFloat orangeViewX = blueViewX;
    CGFloat orangeViewY = blueViewY + CGRectGetMaxY(self.showDeepSleeplabel.frame);
    CGFloat orangeViewW = blueViewW;
    CGFloat orangeViewH = orangeViewW;
    self.orangeView.frame = CGRectMake(orangeViewX, orangeViewY, orangeViewW, orangeViewH);
    
    CGFloat showAwakeSleeplabelX = 2 * WidthProportion + CGRectGetMaxX(self.orangeView.frame);
    CGFloat showAwakeSleeplabelY = CGRectGetMaxY(self.showDeepSleeplabel.frame);
    CGFloat showAwakeSleeplabelW = showDeepSleeplabelW;
    CGFloat showAwakeSleeplabelH = showDeepSleeplabelH;
    self.showAwakeSleeplabel.frame = CGRectMake(showAwakeSleeplabelX, showAwakeSleeplabelY, showAwakeSleeplabelW, showAwakeSleeplabelH);
    
    self.showDeepSleeplabel.adjustsFontSizeToFitWidth = YES;
    
    
    CGFloat fontSize = 10;
    NSString *stringDeep = [NSString stringWithFormat:@"%2.1f",deepSleep * 10/ 60.0];
    NSString *stringLight = [NSString stringWithFormat:@"%2.1f",lightSleep * 10/ 60.0];
    NSString *stringAwake = [NSString stringWithFormat:@"%2.1f",awake * 10/ 60.0];
    if ([stringDeep isEqualToString:@"0.0"])
        stringDeep = @"0";
    if ([stringLight isEqualToString:@"0.0"])
        stringLight = @"0";
    if ([stringAwake isEqualToString:@"0.0"])
        stringAwake = @"0";
    
    self.showDeepSleeplabel.attributedText = [NSAttributedString makeAttributedStringWithnumBer:stringDeep Unit:@"h" WithFont:fontSize];
    self.showLightSleeplabel.attributedText = [NSAttributedString makeAttributedStringWithnumBer:stringLight Unit:@"h" WithFont:fontSize];
    self.showAwakeSleeplabel.attributedText = [NSAttributedString makeAttributedStringWithnumBer:stringAwake Unit:@"h" WithFont:fontSize];
    //    self.showDeepSleeplabel.font = [UIFont systemFontOfSize:fontSize];
    //    self.showLightSleeplabel.font = [UIFont systemFontOfSize:fontSize];
    //    self.showAwakeSleeplabel.font = [UIFont systemFontOfSize:fontSize];
    [self.showDeepSleeplabel adjustsFontSizeToFitWidth];
    [self.showLightSleeplabel adjustsFontSizeToFitWidth];
    [self.showAwakeSleeplabel adjustsFontSizeToFitWidth];
    
    [self.wSleepView addSubview:self.showLabelViewSleep];
    [self.showLabelViewSleep addSubview:self.blueView];
    [self.showLabelViewSleep addSubview:self.greenView];
    [self.showLabelViewSleep addSubview:self.orangeView];
    [self.showLabelViewSleep addSubview:self.showDeepSleeplabel];
    [self.showLabelViewSleep addSubview:self.showLightSleeplabel];
    [self.showLabelViewSleep addSubview:self.showAwakeSleeplabel];
}
- (void)viewWillLayoutSubviews
{
    
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
}

#pragma mark - 按钮事件

- (IBAction)segmentBtnAction:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        _yueBtn.selected = NO;
        _zhouBtn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    else
    {
        _zhouBtn.selected = NO;
        _yueBtn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(CurrentDeviceWidth, 0);
        }];
    }
}

- (IBAction)shareAction:(id)sender
{
    [self shareVC];
}

- (IBAction)goBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//整体的约束的计算
#pragma mark   - - - 计算各个控件的距离
-(void)zhouCalculateConstraint
{
    //上层  上半部分
    CGFloat wStepViewX = 0;
    CGFloat wStepViewY = 0;
    CGFloat wStepViewW = CurrentDeviceWidth;
    CGFloat wStepViewH = (CurrentDeviceHeight - 64) / 2;
    _wStepView.frame =CGRectMake(wStepViewX, wStepViewY, wStepViewW, wStepViewH);
    //下层  下半部分
    CGFloat wSleepViewX = 0;
    CGFloat wSleepViewY = CGRectGetMaxY(_wStepView.frame);
    CGFloat wSleepViewW = CurrentDeviceWidth;
    CGFloat wSleepViewH = (CurrentDeviceHeight - 64) / 2;
    _wSleepView.frame =CGRectMake(wSleepViewX, wSleepViewY, wSleepViewW, wSleepViewH);
    _wSleepView.backgroundColor = [UIColor whiteColor];
    
    //导航条按钮的设置
    [_zhouBtn setBackgroundImage:[UIImage imageNamed:@"Layer_o"] forState:UIControlStateSelected];
    [_zhouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_zhouBtn setBackgroundImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [_zhouBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_zhouBtn setSelected:YES];
    [_yueBtn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_yueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_yueBtn setBackgroundImage:[UIImage imageNamed:@"Unselected02"] forState:UIControlStateNormal];
    [_yueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor blackColor];
    //    _wSleepView.backgroundColor = [UIColor redColor];
    //    _wStepView.backgroundColor = [UIColor greenColor];
    
    _pjbushu.translatesAutoresizingMaskIntoConstraints = YES;
    _wAveStepLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _stepsLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _zhouAvgStepLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _kaluli.translatesAutoresizingMaskIntoConstraints = YES;
    _wAveCostLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.colories2.translatesAutoresizingMaskIntoConstraints = YES;
    _zhouAvgCaloriesLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _lineLabe.translatesAutoresizingMaskIntoConstraints = YES;
    
    //上层图的背景图
    CGFloat UpImageViewX = 5;
    CGFloat UpImageViewY = 80 * HeightProportion;
    CGFloat UpImageViewW = CurrentDeviceWidth - 10;
    CGFloat UpImageViewH = 178 * HeightProportion;
    UIImageView  *UpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UpImageViewX, UpImageViewY, UpImageViewW, UpImageViewH)];
    UpImageView.image = [UIImage imageNamed:@"StepChartBackground"];
    [_wStepView addSubview:UpImageView];
    _UpImageView = UpImageView;
    
    //下层图的背景图
    CGFloat DownImageViewX = 5;
    CGFloat DownImageViewY = 85 * HeightProportion;
    CGFloat DownImageViewW = CurrentDeviceWidth - 10;
    CGFloat DownImageViewH = 178 * HeightProportion;
    UIImageView  *DownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DownImageViewX, DownImageViewY, DownImageViewW, DownImageViewH)];
    DownImageView.image = [UIImage imageNamed:@"StepChartBackgroundO"];
    [_wSleepView addSubview:DownImageView];
    _DownImageView = DownImageView;
    
    
    //第一层
    CGFloat pjbushuX = 20 * WidthProportion;
    CGFloat pjbushuY = 20 * HeightProportion;
    CGFloat pjbushuW = 40;
    CGFloat pjbushuH = pjbushuW;
    _pjbushu.frame =CGRectMake(pjbushuX, pjbushuY, pjbushuW, pjbushuH);
    
    CGFloat wAveStepLabelX = CGRectGetMaxX(_pjbushu.frame) + 10 * WidthProportion;
    CGFloat wAveStepLabelY = pjbushuY;
    CGFloat wAveStepLabelW = 40;
    CGFloat wAveStepLabelH = 30;
    _wAveStepLabel.frame =CGRectMake(wAveStepLabelX, wAveStepLabelY, wAveStepLabelW, wAveStepLabelH);
    _wAveStepLabel.font = [UIFont systemFontOfSize:24];
    _wAveStepLabel.textColor =  fontcolorMain;
    //    [_wAveStepLabel sizeToFit];
    
    CGFloat stepsLabelX = CGRectGetMaxX(_wAveStepLabel.frame) + 5 * WidthProportion;
    CGFloat stepsLabelY = pjbushuY + 10 * HeightProportion;
    CGFloat stepsLabelW = 40;
    CGFloat stepsLabelH = 20;
    _stepsLabel.frame =CGRectMake(stepsLabelX, stepsLabelY, stepsLabelW, stepsLabelH);
    _stepsLabel.font = [UIFont systemFontOfSize:12];
    _stepsLabel.textColor =  fontcolorless;
    //    [_stepsLabel sizeToFit];
    //    _stepsLabel.sd_layout.leftSpaceToView(_wAveStepLabel,0);
    [_wAveStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pjbushu.mas_right).offset(10 * WidthProportion);
        make.top.equalTo(_pjbushu);
    }];
    [_stepsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wAveStepLabel).offset(10 * HeightProportion);
        make.left.equalTo(_wAveStepLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    
    CGFloat zhouAvgStepLabelX = CGRectGetMaxX(_pjbushu.frame) + 10 * WidthProportion;
    CGFloat zhouAvgStepLabelY = CGRectGetMaxY(_wAveStepLabel.frame);
    CGFloat zhouAvgStepLabelW = 40;
    CGFloat zhouAvgStepLabelH = 20;
    _zhouAvgStepLabel.frame =CGRectMake(zhouAvgStepLabelX, zhouAvgStepLabelY, zhouAvgStepLabelW, zhouAvgStepLabelH);
    [_zhouAvgStepLabel sizeToFit];
    _zhouAvgStepLabel.textColor =  fontcolorless;
    _zhouAvgStepLabel.font = [UIFont systemFontOfSize:12];
    
    
    //平均消耗卡路里
    CGFloat kaluliX = CurrentDeviceWidth / 2 + 20 * WidthProportion;
    CGFloat kaluliY = pjbushuY;
    CGFloat kaluliW = pjbushuW;
    CGFloat kaluliH = kaluliW;
    _kaluli.frame =CGRectMake(kaluliX, kaluliY, kaluliW, kaluliH);
    
    CGFloat wAveCostLabelX = CGRectGetMaxX(_kaluli.frame) + 10 * WidthProportion;
    CGFloat wAveCostLabelY = kaluliY;
    CGFloat wAveCostLabelW = wAveStepLabelW;
    CGFloat wAveCostLabelH = wAveStepLabelH;
    _wAveCostLabel.frame =CGRectMake(wAveCostLabelX, wAveCostLabelY, wAveCostLabelW, wAveCostLabelH);
    _wAveCostLabel.font = [UIFont systemFontOfSize:24];
    _wAveCostLabel.textColor =  fontcolorMain;
    //    [_wAveCostLabel sizeToFit];
    
    
    CGFloat Colories2X = CGRectGetMaxX(_wAveCostLabel.frame) + 5 * WidthProportion;
    CGFloat Colories2Y = wAveCostLabelY + 10;
    CGFloat Colories2W = stepsLabelW;
    CGFloat Colories2H = stepsLabelH;
    self.colories2.frame =CGRectMake(Colories2X, Colories2Y, Colories2W, Colories2H);
    //    self.colories2.textColor =  fontcolorless;
    [self.colories2 sizeToFit];
    self.colories2.font = [UIFont systemFontOfSize:12];
    
    
    [_wAveCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kaluli.mas_right).offset(10 * WidthProportion);
        make.top.equalTo(_kaluli);
    }];
    [self.colories2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wAveCostLabel).offset(10 * HeightProportion);
        make.left.equalTo(_wAveCostLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    
    CGFloat zhouAvgCaloriesLabelX = wAveCostLabelX;
    CGFloat zhouAvgCaloriesLabelY = CGRectGetMaxY(_wAveCostLabel.frame);
    CGFloat zhouAvgCaloriesLabelW = zhouAvgStepLabelW;
    CGFloat zhouAvgCaloriesLabelH = zhouAvgStepLabelH;
    _zhouAvgCaloriesLabel.frame =CGRectMake(zhouAvgCaloriesLabelX, zhouAvgCaloriesLabelY, zhouAvgCaloriesLabelW, zhouAvgCaloriesLabelH);
    _zhouAvgCaloriesLabel.textColor =  fontcolorless;
    [_zhouAvgCaloriesLabel sizeToFit];
    _zhouAvgCaloriesLabel.font = [UIFont systemFontOfSize:12];
    
    //第二层控件
    CGFloat zhouCompletionLabelX = 20 * WidthProportion;
    CGFloat zhouCompletionLabelY = CGRectGetMinY(_UpImageView.frame) + 13;
    CGFloat zhouCompletionLabelW = zhouAvgStepLabelW;
    CGFloat zhouCompletionLabelH = zhouAvgStepLabelH;
    _zhouCompletionLabel.frame =CGRectMake(zhouCompletionLabelX, zhouCompletionLabelY, zhouCompletionLabelW, zhouCompletionLabelH);
    _zhouCompletionLabel.textColor =  fontcolorMain;
    [_zhouCompletionLabel sizeToFit];
    
    CGFloat wStepComLabelX = CGRectGetMaxX(_zhouCompletionLabel.frame);
    CGFloat wStepComLabelY = zhouCompletionLabelY;
    CGFloat wStepComLabelW = zhouCompletionLabelW;
    CGFloat wStepComLabelH = zhouCompletionLabelH;
    _wStepComLabel.frame =CGRectMake(wStepComLabelX, wStepComLabelY, wStepComLabelW, wStepComLabelH);
    _wStepComLabel.textColor =  fontcolorMain;
    //    [_wStepComLabel sizeToFit];
    [_wStepComLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_zhouCompletionLabel.mas_right);
        make.top.equalTo(_zhouCompletionLabel);
    }];
    
    
    CGFloat zhouRecordLabelX = CurrentDeviceWidth / 2;
    CGFloat zhouRecordLabelY = wStepComLabelY;
    CGFloat zhouRecordLabelW = wStepComLabelW;
    CGFloat zhouRecordLabelH = wStepComLabelH;
    _zhouRecordLabel.frame =CGRectMake(zhouRecordLabelX, zhouRecordLabelY, zhouRecordLabelW, zhouRecordLabelH);
    _zhouRecordLabel.textColor =  fontcolorMain;
    [_zhouRecordLabel sizeToFit];
    
    
    CGFloat wMaxStepLabelX = CGRectGetMaxX(_zhouRecordLabel.frame);
    CGFloat wMaxStepLabelY = zhouRecordLabelY;
    CGFloat wMaxStepLabelW = wStepComLabelW;
    CGFloat wMaxStepLabelH = wStepComLabelH;
    _wMaxStepLabel.frame =CGRectMake(wMaxStepLabelX, wMaxStepLabelY, wMaxStepLabelW, wMaxStepLabelH);
    _wMaxStepLabel.textColor =  fontcolorMain;
    //    [_wMaxStepLabel sizeToFit];
    [_wMaxStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_zhouRecordLabel.mas_right);
        make.top.equalTo(_zhouRecordLabel);
    }];
    
    
    // 白线
    CGFloat whiteViewX = 20 * WidthProportion;
    CGFloat whiteViewY = CGRectGetMaxY(_wMaxStepLabel.frame) + 10;
    CGFloat whiteViewW = CurrentDeviceWidth - whiteViewX * 2 ;
    CGFloat whiteViewH = 1;
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(whiteViewX, whiteViewY, whiteViewW, whiteViewH)];
    [_wStepView addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView = whiteView;
    
    
    //最下面的线条
    CGFloat lineLabeX = 10 * WidthProportion;
    CGFloat lineLabeY = CGRectGetMaxY(_wStepView.frame) - 1;
    CGFloat lineLabeW = CurrentDeviceWidth - lineLabeX * 2;
    CGFloat lineLabeH = 1;
    _lineLabe.frame =CGRectMake(lineLabeX, lineLabeY, lineLabeW, lineLabeH);
    _lineLabe.backgroundColor = [UIColor grayColor];
    [_wStepView addSubview:_lineLabe];
    
    [_wStepView sendSubviewToBack:_UpImageView];
    [_wSleepView sendSubviewToBack:_DownImageView];
    
    
    /**
     *
     *下半部分的   zhou Sleep   view
     *
     */
    _pjshichang.translatesAutoresizingMaskIntoConstraints = YES;
    _wSleepHour.translatesAutoresizingMaskIntoConstraints = YES;
    self.hour3.translatesAutoresizingMaskIntoConstraints = YES;
    _wSleepMin.translatesAutoresizingMaskIntoConstraints = YES;
    //    self.minites3.translatesAutoresizingMaskIntoConstraints = YES;
    self.minites3.translatesAutoresizingMaskIntoConstraints = NO;
    _zhouAvgDurationLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _pjshenshui.translatesAutoresizingMaskIntoConstraints = YES;
    _wDeepSleepHour.translatesAutoresizingMaskIntoConstraints = YES;
    self.hour4.translatesAutoresizingMaskIntoConstraints = YES;
    _wDeepSleepMin.translatesAutoresizingMaskIntoConstraints = YES;
    self.minites4.translatesAutoresizingMaskIntoConstraints = YES;
    _zhouAvgDeepLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    //第一部分
    CGFloat pjshichangX = 20 * WidthProportion;
    CGFloat pjshichangY = 20 * HeightProportion;
    CGFloat pjshichangW = 40;
    CGFloat pjshichangH = pjshichangW;
    _pjshichang.frame =CGRectMake(pjshichangX, pjshichangY, pjshichangW, pjshichangH);
    
    CGFloat wSleepHourX = CGRectGetMaxX(_pjshichang.frame);
    CGFloat wSleepHourY = pjshichangY;
    CGFloat wSleepHourW = 30;
    CGFloat wSleepHourH = 30;
    _wSleepHour.frame =CGRectMake(wSleepHourX, wSleepHourY, wSleepHourW, wSleepHourH);
    _wSleepHour.font = fontSizeBig;
    _wSleepHour.textColor = fontcolorMain;
    
    CGFloat hour33X = CGRectGetMaxX(_wSleepHour.frame);
    CGFloat hour33Y = pjshichangY + 10 * HeightProportion;
    CGFloat hour33W = 40;
    CGFloat hour33H = 20;
    self.hour3.frame =CGRectMake(hour33X, hour33Y, hour33W, hour33H);
    self.hour3.font = fontSizeSmall;
    self.hour3.textColor = fontcolorless;
    //    self.hour3.backgroundColor = allColorRed;
    
    [_wSleepHour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pjshichang.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(_pjshichang);
    }];
    [self.hour3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wSleepHour).offset(10 * HeightProportion);
        make.left.equalTo(_wSleepHour.mas_right);//.offset(10 * WidthProportion);
    }];
    
    
    CGFloat wSleepMinX = CGRectGetMaxX(self.hour3.frame);
    CGFloat wSleepMinY = pjshichangY;
    CGFloat wSleepMinW = wSleepHourW;
    CGFloat wSleepMinH = wSleepHourH;
    _wSleepMin.frame =CGRectMake(wSleepMinX, wSleepMinY, wSleepMinW, wSleepMinH);
    _wSleepMin.font = fontSizeBig;
    _wSleepMin.textColor = fontcolorMain;
    //    _wSleepMin.backgroundColor = [UIColor greenColor];
    
    CGFloat Minites33X = CGRectGetMaxX(_wSleepMin.frame);
    CGFloat Minites33Y = pjshichangY + 10 * HeightProportion;
    CGFloat Minites33W = 40;
    CGFloat Minites33H = 20;
    self.minites3.frame =CGRectMake(Minites33X, Minites33Y, Minites33W, Minites33H);
    self.minites3.font = fontSizeSmall;
    self.minites3.textColor = fontcolorless;
    //    self.minites3.backgroundColor = allColorRed;
    
    //     self.minites3.sd_layout.leftSpaceToView(_wSleepMin,0);
    [_wSleepMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hour3.mas_right);
        make.top.equalTo(_wSleepHour);
    }];
    [self.minites3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wSleepMin.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(self.hour3);
    }];
    
    
    CGFloat zhouAvgDurationLabelX = CGRectGetMaxX(_pjshichang.frame);
    CGFloat zhouAvgDurationLabelY = CGRectGetMaxY(_wSleepHour.frame);
    CGFloat zhouAvgDurationLabelW = 40;
    CGFloat zhouAvgDurationLabelH = 20;
    _zhouAvgDurationLabel.frame =CGRectMake(zhouAvgDurationLabelX, zhouAvgDurationLabelY, zhouAvgDurationLabelW, zhouAvgDurationLabelH);
    _zhouAvgDurationLabel.font = fontSizeSmall;
    _zhouAvgDurationLabel.textColor = fontcolorless;
    [_zhouAvgDurationLabel sizeToFit];
    
    //第二部分
    
    CGFloat pjshenshuiX = CurrentDeviceWidth / 2 + 20 * WidthProportion;
    CGFloat pjshenshuiY = 20 * HeightProportion;
    CGFloat pjshenshuiW = 40;
    CGFloat pjshenshuiH = pjshenshuiW;
    _pjshenshui.frame =CGRectMake(pjshenshuiX, pjshenshuiY, pjshenshuiW, pjshenshuiH);
    
    CGFloat wDeepSleepHourX = CGRectGetMaxX(_pjshenshui.frame);
    CGFloat wDeepSleepHourY = pjshenshuiY;
    CGFloat wDeepSleepHourW = 40;
    CGFloat wDeepSleepHourH = 30;
    _wDeepSleepHour.frame =CGRectMake(wDeepSleepHourX, wDeepSleepHourY, wDeepSleepHourW, wDeepSleepHourH);
    _wDeepSleepHour.font = fontSizeBig;
    _wDeepSleepHour.textColor = fontcolorMain;
    //    [_wDeepSleepHour sizeToFit];
    //    _wDeepSleepHour.sd_layout.leftSpaceToView(_pjshenshui,0);
    
    CGFloat hour4X = CGRectGetMaxX(_wDeepSleepHour.frame);
    CGFloat hour4Y = wDeepSleepHourY + 10 * HeightProportion;
    CGFloat hour4W = 40;
    CGFloat hour4H = 20;
    self.hour4.frame =CGRectMake(hour4X, hour4Y, hour4W, hour4H);
    self.hour4.font = fontSizeSmall;
    self.hour4.textColor = fontcolorless;
    //    [self.hour4 sizeToFit];
    //    self.hour4.sd_layout.leftSpaceToView(_wDeepSleepHour,0);
    
    [_wDeepSleepHour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pjshenshui.mas_right);
        make.top.equalTo(_pjshenshui);
    }];
    [self.hour4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wDeepSleepHour.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(_wDeepSleepHour).offset(10 * WidthProportion);
    }];
    
    CGFloat wDeepSleepMinX = CGRectGetMaxX(self.hour4.frame);
    CGFloat wDeepSleepMinY = pjshenshuiY;
    CGFloat wDeepSleepMinW = wSleepHourW;
    CGFloat wDeepSleepMinH = wSleepHourH;
    _wDeepSleepMin.frame =CGRectMake(wDeepSleepMinX, wDeepSleepMinY, wDeepSleepMinW, wDeepSleepMinH);
    _wDeepSleepMin.font = fontSizeBig;
    _wDeepSleepMin.textColor = fontcolorMain;
    
    CGFloat minites4X = CGRectGetMaxX(_wDeepSleepMin.frame);
    CGFloat minites4Y = pjshenshuiY + 10 * HeightProportion;
    CGFloat minites4W = 40;
    CGFloat minites4H = 20;
    self.minites4.frame =CGRectMake(minites4X, minites4Y, minites4W, minites4H);
    self.minites4.font = fontSizeSmall;
    self.minites4.textColor = fontcolorless;
    
    [_wDeepSleepMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hour4.mas_right);
        make.top.equalTo(_wDeepSleepHour);
    }];
    [self.minites4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wDeepSleepMin.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(self.hour4);
    }];
    
    CGFloat zhouAvgDeepLabelX = CGRectGetMaxX(_pjshenshui.frame);
    CGFloat zhouAvgDeepLabelY = CGRectGetMaxY(_wSleepHour.frame);
    CGFloat zhouAvgDeepLabelW = 40;
    CGFloat zhouAvgDeepLabelH = 20;
    _zhouAvgDeepLabel.frame =CGRectMake(zhouAvgDeepLabelX, zhouAvgDeepLabelY, zhouAvgDeepLabelW, zhouAvgDeepLabelH);
    _zhouAvgDeepLabel.font = fontSizeSmall;
    _zhouAvgDeepLabel.textColor = fontcolorless;
    [_zhouAvgDeepLabel sizeToFit];
    
    //用于图和label的 分隔   线条
    CGFloat erlineLabelX = 10 * WidthProportion;
    CGFloat erlineLabelY = CGRectGetMinY(_DownImageView.frame) + 40 * HeightProportion;
    CGFloat erlineLabelW = CurrentDeviceWidth - erlineLabelX * 2;
    CGFloat erlineLabelH = 1;
    _erlineLabel.frame =CGRectMake(erlineLabelX, erlineLabelY, erlineLabelW, erlineLabelH);
    _erlineLabel.backgroundColor = [UIColor grayColor];
    [_wSleepView addSubview:_erlineLabel];
    
    
    //颜色 的色块对应的意思
    
    UIFont *font = [UIFont systemFontOfSize:17];
    //    UIColor *fontCol = [UIColor colorWithHexString:@"#181818"];
    CGFloat margin = 10 *WidthProportion;
    
    UILabel * awakeLab = [[UILabel alloc]init];
    [self.DownImageView addSubview:awakeLab];
    awakeLab.text = NSLocalizedString(@"清醒", nil);
    CGFloat zitiWidth = [awakeLab.text sizeWithAttributes:@{NSFontAttributeName :font}].width;
    CGFloat awakeLabX = _DownImageView.width - zitiWidth - 30 * WidthProportion;
    CGFloat awakeLabW = zitiWidth;
    CGFloat awakeLabH = 40 * HeightProportion;
    CGFloat awakeLabY = (CGRectGetMaxY(self.erlineLabel.frame) - CGRectGetMinY(_DownImageView.frame) - awakeLabH) / 2;
    awakeLab.frame = CGRectMake(awakeLabX, awakeLabY, awakeLabW, awakeLabH);
    //    awakeLab.backgroundColor = [UIColor redColor];
    
    UIView *colorOrangeView = [[UIView alloc]init];
    [self.DownImageView addSubview:colorOrangeView];
    colorOrangeView.backgroundColor = zhouSleepAwakeColor;
    CGFloat colorOrangeViewW = 15 * WidthProportion;
    CGFloat colorOrangeViewH = colorOrangeViewW;
    CGFloat colorOrangeViewX = CGRectGetMinX(awakeLab.frame) - margin - colorOrangeViewW;
    CGFloat colorOrangeViewY = 0;
    colorOrangeView.frame = CGRectMake(colorOrangeViewX, colorOrangeViewY, colorOrangeViewW, colorOrangeViewH);
    colorOrangeView.centerY = awakeLab.centerY;
    
    
    UILabel * lightLab = [[UILabel alloc]init];
    [self.DownImageView addSubview:lightLab];
    lightLab.text = NSLocalizedString(@"浅睡", nil);
    CGFloat lightLabZitiWidth = [lightLab.text sizeWithAttributes:@{NSFontAttributeName :font}].width;
    CGFloat lightLabX = CGRectGetMinX(colorOrangeView.frame) - 20 * WidthProportion - lightLabZitiWidth;
    CGFloat lightLabW = lightLabZitiWidth;
    CGFloat lightLabH = awakeLabH;
    CGFloat lightLabY = 0;
    lightLab.frame = CGRectMake(lightLabX, lightLabY, lightLabW, lightLabH);
    lightLab.centerY = awakeLab.centerY;
    
    UIView *colorCyanView = [[UIView alloc]init];
    [self.DownImageView addSubview:colorCyanView];
    colorCyanView.backgroundColor = zhouSleepLightColor;
    
    CGFloat colorCyanViewW = colorOrangeViewW;
    CGFloat colorCyanViewH = colorCyanViewW;
    CGFloat colorCyanViewX = CGRectGetMinX(lightLab.frame) - margin - colorCyanViewW;
    CGFloat colorCyanViewY = 0;
    colorCyanView.frame = CGRectMake(colorCyanViewX, colorCyanViewY, colorCyanViewW, colorCyanViewH);
    colorCyanView.centerY = awakeLab.centerY;
    
    UILabel * deepLab = [[UILabel alloc]init];
    [self.DownImageView addSubview:deepLab];
    deepLab.text = NSLocalizedString(@"深睡", nil);
    
    CGFloat deepLabZitiWidth = [deepLab.text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat deepLabX = CGRectGetMinX(colorCyanView.frame) - 20 * WidthProportion - deepLabZitiWidth;
    CGFloat deepLabW = deepLabZitiWidth;
    CGFloat deepLabH = awakeLabH;
    CGFloat deepLabY = 0;
    deepLab.frame = CGRectMake(deepLabX, deepLabY, deepLabW, deepLabH);
    deepLab.centerY = awakeLab.centerY;
    
    UIView *colorBlueView = [[UIView alloc]init];
    [self.DownImageView addSubview:colorBlueView];
    colorBlueView.backgroundColor = zhouSleepDeepColor;
    
    CGFloat colorBlueViewW = colorOrangeViewW;
    CGFloat colorBlueViewH = colorBlueViewW;
    CGFloat colorBlueViewX = CGRectGetMinX(deepLab.frame) - margin - colorBlueViewW;
    CGFloat colorBlueViewY = 0;
    colorBlueView.frame = CGRectMake(colorBlueViewX, colorBlueViewY, colorBlueViewW, colorBlueViewH);
    colorBlueView.centerY = awakeLab.centerY;
    
}
-(void)yueCalculateConstraint
{
    //月上层  上半部分
    CGFloat mStepViewX = 0;
    CGFloat mStepViewY = 0;
    CGFloat mStepViewW = CurrentDeviceWidth;
    CGFloat mStepViewH = (CurrentDeviceHeight - 64) / 2;
    _mStepView.frame =CGRectMake(mStepViewX, mStepViewY, mStepViewW, mStepViewH);
    //    _mStepView.backgroundColor = [UIColor cyanColor];
    
    //下层  下半部分
    CGFloat mSleepViewX = 0;
    CGFloat mSleepViewY = CGRectGetMaxY(_mStepView.frame);
    CGFloat mSleepViewW = CurrentDeviceWidth;
    CGFloat mSleepViewH = mStepViewH;
    _mSleepView.frame =CGRectMake(mSleepViewX, mSleepViewY, mSleepViewW, mSleepViewH);
    _mSleepView.backgroundColor = [UIColor whiteColor];
    
    
    _mpjSteps.translatesAutoresizingMaskIntoConstraints = YES;
    _mAveStepLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _yueSteps.translatesAutoresizingMaskIntoConstraints = YES;
    _yueAvgStepLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _mpjKcal.translatesAutoresizingMaskIntoConstraints = YES;
    _mAveCostLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.colories1.translatesAutoresizingMaskIntoConstraints = YES;
    _yueAvgCaloriesLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _yueDownLine.translatesAutoresizingMaskIntoConstraints = YES;
    
    //上层图的背景图
    CGFloat mUpImageViewX = 5;
    CGFloat mUpImageViewY = 80 * WidthProportion;
    CGFloat mUpImageViewW = CurrentDeviceWidth - 10;
    CGFloat mUpImageViewH = 178 * HeightProportion;
    UIImageView  *mUpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(mUpImageViewX, mUpImageViewY, mUpImageViewW, mUpImageViewH)];
    mUpImageView.image = [UIImage imageNamed:@"StepChartBackground"];
    [_mStepView addSubview:mUpImageView];
    _mUpImageView = mUpImageView;
    
    //下层图的背景图
    CGFloat mDownImageViewX = 5;
    CGFloat mDownImageViewY = 85 * HeightProportion;
    CGFloat mDownImageViewW = CurrentDeviceWidth - 10;
    CGFloat mDownImageViewH = 178 * HeightProportion;
    UIImageView  *mDownImageView = [[UIImageView alloc]initWithFrame:CGRectMake(mDownImageViewX, mDownImageViewY, mDownImageViewW, mDownImageViewH)];
    mDownImageView.image = [UIImage imageNamed:@"StepChartBackgroundO"];
    [_mSleepView addSubview:mDownImageView];
    _mDownImageView = mDownImageView;
    
    
    //第一层
    CGFloat mpjStepsX = 20 * WidthProportion;
    CGFloat mpjStepsY = 20 * HeightProportion;
    CGFloat mpjStepsW = 40;
    CGFloat mpjStepsH = mpjStepsW;
    _mpjSteps.frame =CGRectMake(mpjStepsX, mpjStepsY, mpjStepsW, mpjStepsH);
    
    CGFloat mAveStepLabelX = CGRectGetMaxX(_pjbushu.frame) + 10 * WidthProportion;
    CGFloat mAveStepLabelY = mpjStepsY;
    CGFloat mAveStepLabelW = 40;
    CGFloat mAveStepLabelH = 30;
    _mAveStepLabel.frame =CGRectMake(mAveStepLabelX, mAveStepLabelY, mAveStepLabelW, mAveStepLabelH);
    _mAveStepLabel.font = [UIFont systemFontOfSize:24];
    _mAveStepLabel.textColor =  fontcolorMain;
    //    [_mAveStepLabel sizeToFit];
    
    
    CGFloat yueStepsX = CGRectGetMaxX(_mAveStepLabel.frame) + 5 * WidthProportion;
    CGFloat yueStepsY = mpjStepsY + 10;
    CGFloat yueStepsW = 40;
    CGFloat yueStepsH = 20;
    _yueSteps.frame =CGRectMake(yueStepsX, yueStepsY, yueStepsW, yueStepsH);
    _yueSteps.font = [UIFont systemFontOfSize:12];
    _yueSteps.textColor =  fontcolorless;
    //    [_yueSteps sizeToFit];
    [_mAveStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mpjSteps.mas_right).offset(10 * WidthProportion);
        make.top.equalTo(_mpjSteps);
    }];
    [_yueSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mAveStepLabel).offset(10 * HeightProportion);
        make.left.equalTo(_mAveStepLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    
    CGFloat yueAvgStepLabelX = CGRectGetMaxX(_pjbushu.frame) + 10 * WidthProportion;
    CGFloat yueAvgStepLabelY = CGRectGetMaxY(_wAveStepLabel.frame);
    CGFloat yueAvgStepLabelW = 40;
    CGFloat yueAvgStepLabelH = 20;
    _yueAvgStepLabel.frame =CGRectMake(yueAvgStepLabelX, yueAvgStepLabelY, yueAvgStepLabelW, yueAvgStepLabelH);
    _yueAvgStepLabel.textColor =  fontcolorless;
    _yueAvgStepLabel.font = [UIFont systemFontOfSize:12];
    [_yueAvgStepLabel sizeToFit];
    
    
    //平均消耗卡路里
    CGFloat mpjKcalX = CurrentDeviceWidth / 2 + 20 * WidthProportion;
    CGFloat mpjKcalY = mpjStepsY;
    CGFloat mpjKcalW = mpjStepsW;
    CGFloat mpjKcalH = mpjKcalW;
    _mpjKcal.frame =CGRectMake(mpjKcalX, mpjKcalY, mpjKcalW, mpjKcalH);
    
    
    CGFloat mAveCostLabelX = CGRectGetMaxX(_kaluli.frame) + 10 * WidthProportion;
    CGFloat mAveCostLabelY = mpjKcalY;
    CGFloat mAveCostLabelW = mAveStepLabelW;
    CGFloat mAveCostLabelH = mAveStepLabelH;
    _mAveCostLabel.frame =CGRectMake(mAveCostLabelX, mAveCostLabelY, mAveCostLabelW, mAveCostLabelH);
    _mAveCostLabel.font = [UIFont systemFontOfSize:24];
    _mAveCostLabel.textColor =  fontcolorMain;
    //    [_mAveCostLabel sizeToFit];
    
    
    CGFloat colories1X = CGRectGetMaxX(_mAveCostLabel.frame) + 5 * WidthProportion;
    CGFloat colories1Y = mAveCostLabelY + 10;
    CGFloat colories1W = yueStepsW;
    CGFloat colories1H = yueStepsH;
    self.colories1.frame =CGRectMake(colories1X, colories1Y, colories1W, colories1H);
    self.colories1.textColor =  fontcolorless;
    //    [self.colories1 sizeToFit];
    self.colories1.font = [UIFont systemFontOfSize:12];
    
    [_mAveCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mpjKcal.mas_right).offset(10 * WidthProportion);
        make.top.equalTo(_mpjKcal);
    }];
    [self.colories1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mAveCostLabel).offset(10 * HeightProportion);
        make.left.equalTo(_mAveCostLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    CGFloat yueAvgCaloriesLabelX = mAveCostLabelX;
    CGFloat yueAvgCaloriesLabelY = CGRectGetMaxY(_mAveCostLabel.frame);
    CGFloat yueAvgCaloriesLabelW = yueAvgStepLabelW;
    CGFloat yueAvgCaloriesLabelH = yueAvgStepLabelH;
    _yueAvgCaloriesLabel.frame =CGRectMake(yueAvgCaloriesLabelX, yueAvgCaloriesLabelY, yueAvgCaloriesLabelW, yueAvgCaloriesLabelH);
    _yueAvgCaloriesLabel.textColor =  fontcolorless;
    [_yueAvgCaloriesLabel sizeToFit];
    _yueAvgCaloriesLabel.font = [UIFont systemFontOfSize:12];
    
    
    
    //第二层控件
    CGFloat yueCompletionLabelX = 20 * WidthProportion;
    CGFloat yueCompletionLabelY = CGRectGetMinY(_mUpImageView.frame) + 13;
    CGFloat yueCompletionLabelW = yueAvgStepLabelW;
    CGFloat yueCompletionLabelH = yueAvgStepLabelH;
    _yueCompletionLabel.frame =CGRectMake(yueCompletionLabelX, yueCompletionLabelY, yueCompletionLabelW, yueCompletionLabelH);
    _yueCompletionLabel.textColor =  fontcolorMain;
    [_yueCompletionLabel sizeToFit];
    
    
    CGFloat mStepComLabelX = CGRectGetMaxX(_zhouCompletionLabel.frame);
    CGFloat mStepComLabelY = yueCompletionLabelY;
    CGFloat mStepComLabelW = yueCompletionLabelW;
    CGFloat mStepComLabelH = yueCompletionLabelH;
    _mStepComLabel.frame =CGRectMake(mStepComLabelX, mStepComLabelY, mStepComLabelW, mStepComLabelH);
    _mStepComLabel.textColor =  fontcolorMain;
    //    [_mStepComLabel sizeToFit];
    
    [_mStepComLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yueCompletionLabel.mas_right).offset(10 * WidthProportion);
        make.top.equalTo(_yueCompletionLabel);
    }];
    
    
    
    CGFloat yueRecordLabelX = CurrentDeviceWidth / 2;
    CGFloat yueRecordLabelY = mStepComLabelY;
    CGFloat yueRecordLabelW = mStepComLabelW;
    CGFloat yueRecordLabelH = mStepComLabelH;
    _yueRecordLabel.frame =CGRectMake(yueRecordLabelX, yueRecordLabelY, yueRecordLabelW, yueRecordLabelH);
    _yueRecordLabel.textColor =  fontcolorMain;
    [_yueRecordLabel sizeToFit];
    
    CGFloat mMaxStepLabelX = CGRectGetMaxX(_zhouRecordLabel.frame);
    CGFloat mMaxStepLabelY = yueRecordLabelY;
    CGFloat mMaxStepLabelW = mStepComLabelW;
    CGFloat mMaxStepLabelH = mStepComLabelH;
    _mMaxStepLabel.frame =CGRectMake(mMaxStepLabelX, mMaxStepLabelY, mMaxStepLabelW, mMaxStepLabelH);
    _mMaxStepLabel.textColor =  fontcolorMain;
    //    [_mMaxStepLabel sizeToFit];
    [_mMaxStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yueRecordLabel.mas_right).offset(10 * WidthProportion);
        make.top.equalTo(_yueRecordLabel);
    }];
    
    // 白线。。在完成下面
    CGFloat yueWhiteLineViewX = 20 * WidthProportion;
    CGFloat yueWhiteLineViewY = CGRectGetMinY(_mUpImageView.frame) + 40 * HeightProportion;
    CGFloat yueWhiteLineViewW = CurrentDeviceWidth - 40 * WidthProportion;
    CGFloat yueWhiteLineViewH = 1;
    UIView *yueWhiteLineView = [[UIView alloc]initWithFrame:CGRectMake(yueWhiteLineViewX, yueWhiteLineViewY, yueWhiteLineViewW, yueWhiteLineViewH)];
    [_mStepView addSubview:yueWhiteLineView];
    yueWhiteLineView.backgroundColor = [UIColor whiteColor];
    _yueWhiteLineView = yueWhiteLineView;
    
    
    //最下面的线条
    CGFloat yueDownLineX = 10 * WidthProportion;
    CGFloat yueDownLineY = CGRectGetMaxY(_mStepView.frame) - 1;
    CGFloat yueDownLineW = CurrentDeviceWidth - yueDownLineX * 2;
    CGFloat yueDownLineH = 1;
    _yueDownLine.frame =CGRectMake(yueDownLineX, yueDownLineY, yueDownLineW, yueDownLineH);
    _yueDownLine.backgroundColor = [UIColor grayColor];
    //    [_mStepView addSubview:_yueDownLine];
    
    [_mStepView sendSubviewToBack:_mUpImageView];
    [_mSleepView sendSubviewToBack:_mDownImageView];
    
    
    /**
     *
     *下半部分的view
     *
     */
    _mpjshichang.translatesAutoresizingMaskIntoConstraints = YES;
    _mSleepHourLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.hour1.translatesAutoresizingMaskIntoConstraints = YES;
    _mSleepMinLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.minites1.translatesAutoresizingMaskIntoConstraints = YES;
    _yueAvgDurationLabel.translatesAutoresizingMaskIntoConstraints = YES;
    _mpjshenshui.translatesAutoresizingMaskIntoConstraints = YES;
    _mDeepHourLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.hour2.translatesAutoresizingMaskIntoConstraints = YES;
    _mDeepMinLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.minites1.translatesAutoresizingMaskIntoConstraints = YES;
    _yueAvgDeepLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    //第一部分
    
    
    CGFloat mpjshichangX = 20 * WidthProportion;
    CGFloat mpjshichangY = 20 * HeightProportion;
    CGFloat mpjshichangW = 40;
    CGFloat mpjshichangH = mpjshichangW;
    _mpjshichang.frame =CGRectMake(mpjshichangX, mpjshichangY, mpjshichangW, mpjshichangH);
    
    CGFloat mSleepHourLabelX = CGRectGetMaxX(_pjshichang.frame);
    CGFloat mSleepHourLabelY = mpjshichangY;
    CGFloat mSleepHourLabelW = 30;
    CGFloat mSleepHourLabelH = 30;
    _mSleepHourLabel.frame =CGRectMake(mSleepHourLabelX, mSleepHourLabelY, mSleepHourLabelW, mSleepHourLabelH);
    _mSleepHourLabel.font = fontSizeBig;
    _mSleepHourLabel.textColor = fontcolorMain;
    //     [_mSleepHourLabel sizeToFit];
    
    
    CGFloat hour1X = CGRectGetMaxX(_mSleepHourLabel.frame);
    CGFloat hour1Y = mpjshichangY + 10 * HeightProportion;
    CGFloat hour1W = 40;
    CGFloat hour1H = 20;
    self.hour1.frame =CGRectMake(hour1X, hour1Y, hour1W, hour1H);
    self.hour1.font = fontSizeSmall;
    self.hour1.textColor = fontcolorless;
    //    [self.hour1 sizeToFit];
    //    CGFloat widthhour1 = [self.hour1.text sizeWithFont:fontSizeSmall].width;
    //    self.hour1.sd_layout.leftSpaceToView(_mSleepHourLabel,0)
    //    .widthIs(widthhour1);
    [_mSleepHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mpjshichang.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(_mpjshichang);
    }];
    [self.hour1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mSleepHourLabel).offset(10 * HeightProportion);
        make.left.equalTo(_mSleepHourLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    CGFloat mSleepMinLabelX = CGRectGetMaxX(self.hour1.frame);
    CGFloat mSleepMinLabelY = mpjshichangY;
    CGFloat mSleepMinLabelW = mSleepHourLabelW;
    CGFloat mSleepMinLabelH = mSleepHourLabelH;
    _mSleepMinLabel.frame =CGRectMake(mSleepMinLabelX, mSleepMinLabelY, mSleepMinLabelW, mSleepMinLabelH);
    _mSleepMinLabel.font = fontSizeBig;
    _mSleepMinLabel.textColor = fontcolorMain;
    
    CGFloat minites1X = CGRectGetMaxX(_mSleepMinLabel.frame);
    CGFloat minites1Y = mpjshichangY + 10 * HeightProportion;
    CGFloat minites1W = 40;
    CGFloat minites1H = 20;
    self.minites1.frame =CGRectMake(minites1X, minites1Y, minites1W, minites1H);
    self.minites1.font = fontSizeSmall;
    self.minites1.textColor = fontcolorless;
    
    [_mSleepMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hour1.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(_mSleepHourLabel);
    }];
    [self.minites1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mSleepMinLabel).offset(10 * HeightProportion);
        make.left.equalTo(_mSleepMinLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    CGFloat yueAvgDurationLabelX = CGRectGetMaxX(_mpjshichang.frame);
    CGFloat yueAvgDurationLabelY = CGRectGetMaxY(_mSleepHourLabel.frame);
    CGFloat yueAvgDurationLabelW = 40;
    CGFloat yueAvgDurationLabelH = 20;
    _yueAvgDurationLabel.frame =CGRectMake(yueAvgDurationLabelX, yueAvgDurationLabelY, yueAvgDurationLabelW, yueAvgDurationLabelH);
    _yueAvgDurationLabel.font = fontSizeSmall;
    _yueAvgDurationLabel.textColor = fontcolorless;
    [_yueAvgDurationLabel sizeToFit];
    
    //第二部分
    
    CGFloat mpjshenshuiX = CurrentDeviceWidth / 2 + 20 * WidthProportion;
    CGFloat mpjshenshuiY = 20 * HeightProportion;
    CGFloat mpjshenshuiW = 40;
    CGFloat mpjshenshuiH = mpjshenshuiW;
    _mpjshenshui.frame =CGRectMake(mpjshenshuiX, mpjshenshuiY, mpjshenshuiW, mpjshenshuiH);
    
    CGFloat mDeepHourLabelX = CGRectGetMaxX(_mpjshenshui.frame);
    CGFloat mDeepHourLabelY = mpjshenshuiY;
    CGFloat mDeepHourLabelW = 40;
    CGFloat mDeepHourLabelH = 30;
    _mDeepHourLabel.frame =CGRectMake(mDeepHourLabelX, mDeepHourLabelY, mDeepHourLabelW, mDeepHourLabelH);
    _mDeepHourLabel.font = fontSizeBig;
    _mDeepHourLabel.textColor = fontcolorMain;
    //    [_mDeepHourLabel sizeToFit];
    //    _mDeepHourLabel.sd_layout.leftSpaceToView(_mpjshenshui,0);
    
    CGFloat hour2X = CGRectGetMaxX(_mDeepHourLabel.frame);
    CGFloat hour2Y = mDeepHourLabelY + 10 * HeightProportion;
    CGFloat hour2W = 40;
    CGFloat hour2H = 20;
    self.hour2.frame =CGRectMake(hour2X, hour2Y, hour2W, hour2H);
    self.hour2.font = fontSizeSmall;
    self.hour2.textColor = fontcolorless;
    //    [self.hour2 sizeToFit];
    //    self.hour2.sd_layout.leftSpaceToView(_mDeepHourLabel,0);
    [_mDeepHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mpjshenshui.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(_mpjshenshui);
    }];
    [self.hour2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mDeepHourLabel).offset(10 * HeightProportion);
        make.left.equalTo(_mDeepHourLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    
    CGFloat mDeepMinLabelX = CGRectGetMaxX(self.hour2.frame);
    CGFloat mDeepMinLabelY = mpjshenshuiY;
    CGFloat mDeepMinLabelW = mSleepHourLabelW;
    CGFloat mDeepMinLabelH = mSleepHourLabelH;
    _mDeepMinLabel.frame =CGRectMake(mDeepMinLabelX, mDeepMinLabelY, mDeepMinLabelW, mDeepMinLabelH);
    _mDeepMinLabel.font = fontSizeBig;
    _mDeepMinLabel.textColor = fontcolorMain;
    //    [_mDeepMinLabel sizeToFit];
    //    _mDeepMinLabel.sd_layout.leftSpaceToView(self.hour2,0);
    
    CGFloat minites11X = CGRectGetMaxX(_mDeepMinLabel.frame);
    CGFloat minites11Y = mpjshenshuiY + 10 * HeightProportion;
    CGFloat minites11W = 40;
    CGFloat minites11H = 20;
    self.minites2.frame =CGRectMake(minites11X, minites11Y, minites11W, minites11H);
    self.minites2.font = fontSizeSmall;
    self.minites2.textColor = fontcolorless;
    //    [self.minites1 sizeToFit];
    //    self.minites1.sd_layout.leftSpaceToView(_mDeepMinLabel,0);
    [_mDeepMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hour2.mas_right);//.offset(10 * WidthProportion);
        make.top.equalTo(_mDeepHourLabel);
    }];
    [self.minites2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mDeepMinLabel).offset(10 * HeightProportion);
        make.left.equalTo(_mDeepMinLabel.mas_right);//.offset(10 * WidthProportion);
    }];
    
    
    CGFloat yueAvgDeepLabelX = CGRectGetMaxX(_pjshenshui.frame);
    CGFloat yueAvgDeepLabelY = CGRectGetMaxY(_mSleepHourLabel.frame);
    CGFloat yueAvgDeepLabelW = 40;
    CGFloat yueAvgDeepLabelH = 20;
    _yueAvgDeepLabel.frame =CGRectMake(yueAvgDeepLabelX, yueAvgDeepLabelY, yueAvgDeepLabelW, yueAvgDeepLabelH);
    _yueAvgDeepLabel.font = fontSizeSmall;
    _yueAvgDeepLabel.textColor = fontcolorless;
    [_yueAvgDeepLabel sizeToFit];
    
    //用于图和label的 分隔   线条
    CGFloat yueXialabelX = 10 * WidthProportion;
    CGFloat yueXialabelY = CGRectGetMinY(_mDownImageView.frame) + 40 * HeightProportion;
    CGFloat yueXialabelW = CurrentDeviceWidth - yueXialabelX * 2;
    CGFloat yueXialabelH = 1;
    _yueXialabel.frame =CGRectMake(yueXialabelX, yueXialabelY, yueXialabelW, yueXialabelH);
    _yueXialabel.backgroundColor = [UIColor grayColor];
    //    [_wSleepView addSubview:_yueXialabel];
    
    
    //颜色 的色块对应的意思
    
    UIFont *font = [UIFont systemFontOfSize:17];
//    UIColor *fontCol = [UIColor colorWithHexString:@"#181818"];
    CGFloat margin = 10 *WidthProportion;
    
    UILabel * awakeLab = [[UILabel alloc]init];
    [self.mDownImageView addSubview:awakeLab];
    awakeLab.text = NSLocalizedString(@"清醒", nil);
    CGFloat zitiWidth = [awakeLab.text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat awakeLabX = _mDownImageView.width - zitiWidth - 30 * WidthProportion;
    CGFloat awakeLabW = zitiWidth;
    CGFloat awakeLabH = 40 * HeightProportion;
    CGFloat awakeLabY = (CGRectGetMaxY(self.yueXialabel.frame) - CGRectGetMinY(_mDownImageView.frame) - awakeLabH) / 2;
    awakeLab.frame = CGRectMake(awakeLabX, awakeLabY, awakeLabW, awakeLabH);
    //    awakeLab.backgroundColor = [UIColor redColor];
    
    UIView *colorOrangeView = [[UIView alloc]init];
    [self.mDownImageView addSubview:colorOrangeView];
    colorOrangeView.backgroundColor = zhouSleepAwakeColor;
    CGFloat colorOrangeViewW = 15 * WidthProportion;
    CGFloat colorOrangeViewH = colorOrangeViewW;
    CGFloat colorOrangeViewX = CGRectGetMinX(awakeLab.frame) - margin - colorOrangeViewW;
    CGFloat colorOrangeViewY = 0;
    colorOrangeView.frame = CGRectMake(colorOrangeViewX, colorOrangeViewY, colorOrangeViewW, colorOrangeViewH);
    colorOrangeView.centerY = awakeLab.centerY;
    
    
    UILabel * lightLab = [[UILabel alloc]init];
    [self.mDownImageView addSubview:lightLab];
    lightLab.text = NSLocalizedString(@"浅睡", nil) ;
    CGFloat lightLabZitiWidth = [lightLab.text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat lightLabX = CGRectGetMinX(colorOrangeView.frame) - 20 * WidthProportion - lightLabZitiWidth;
    CGFloat lightLabW = lightLabZitiWidth;
    CGFloat lightLabH = awakeLabH;
    CGFloat lightLabY = 0;
    lightLab.frame = CGRectMake(lightLabX, lightLabY, lightLabW, lightLabH);
    lightLab.centerY = awakeLab.centerY;
    
    UIView *colorCyanView = [[UIView alloc]init];
    [self.mDownImageView addSubview:colorCyanView];
    colorCyanView.backgroundColor = zhouSleepLightColor;
    
    CGFloat colorCyanViewW = colorOrangeViewW;
    CGFloat colorCyanViewH = colorCyanViewW;
    CGFloat colorCyanViewX = CGRectGetMinX(lightLab.frame) - margin - colorCyanViewW;
    CGFloat colorCyanViewY = 0;
    colorCyanView.frame = CGRectMake(colorCyanViewX, colorCyanViewY, colorCyanViewW, colorCyanViewH);
    colorCyanView.centerY = awakeLab.centerY;
    
    UILabel * deepLab = [[UILabel alloc]init];
    [self.mDownImageView addSubview:deepLab];
    deepLab.text = NSLocalizedString(@"深睡", nil);
    CGFloat deepLabZitiWidth = [deepLab.text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat deepLabX = CGRectGetMinX(colorCyanView.frame) - 20 * WidthProportion - deepLabZitiWidth;
    CGFloat deepLabW = deepLabZitiWidth;
    CGFloat deepLabH = awakeLabH;
    CGFloat deepLabY = 0;
    deepLab.frame = CGRectMake(deepLabX, deepLabY, deepLabW, deepLabH);
    deepLab.centerY = awakeLab.centerY;
    
    UIView *colorBlueView = [[UIView alloc]init];
    [self.mDownImageView addSubview:colorBlueView];
    colorBlueView.backgroundColor = zhouSleepDeepColor;
    
    CGFloat colorBlueViewW = colorOrangeViewW;
    CGFloat colorBlueViewH = colorBlueViewW;
    CGFloat colorBlueViewX = CGRectGetMinX(deepLab.frame) - margin - colorBlueViewW;
    CGFloat colorBlueViewY = 0;
    colorBlueView.frame = CGRectMake(colorBlueViewX, colorBlueViewY, colorBlueViewW, colorBlueViewH);
    colorBlueView.centerY = awakeLab.centerY;
    
    
    [self.mStepView sendSubviewToBack:_mUpImageView];
    [self.mSleepView sendSubviewToBack:_mDownImageView];
}
#pragma mark   - - - 懒加载
-(UIImageView *)showLabelView
{
    if (!_showLabelView) {
        _showLabelView = [[UIImageView alloc]init];
        _showLabelView.image = [UIImage imageNamed:@"qipao_"];
    }
    return _showLabelView;
}

-(UILabel *)labelNumber
{
    if (!_labelNumber) {
        _labelNumber = [[UILabel alloc]init];
        _labelNumber.textAlignment = NSTextAlignmentCenter;
        _labelNumber.font = [UIFont systemFontOfSize:13*WidthProportion];
    }
    return _labelNumber;
}
-(UILabel *)labelUnit
{
    if (!_labelUnit) {
        _labelUnit = [[UILabel alloc]init];
        _labelUnit.textAlignment  = NSTextAlignmentCenter;
        _labelUnit.font = [UIFont systemFontOfSize:8*WidthProportion];
    }
    return _labelUnit;
}
-(UILabel *)soberLabel
{
    if (!_soberLabel) {
        _soberLabel = [[UILabel alloc]init];
    }
    return _soberLabel;
}
-(UILabel *)somnolenceLabel
{
    if (!_somnolenceLabel) {
        _somnolenceLabel = [[UILabel alloc]init];
    }
    return _somnolenceLabel;
}
-(UILabel *)deepSleepLabel
{
    if (!_deepSleepLabel) {
        _deepSleepLabel = [[UILabel alloc]init];
    }
    return _deepSleepLabel;
}

-(UIImageView *)showLabelViewSleep
{
    if (!_showLabelViewSleep) {
        _showLabelViewSleep = [[UIImageView alloc]init];
        _showLabelViewSleep.image = [UIImage imageNamed:@"RectangularBubble_"];
    }
    return _showLabelViewSleep;
}
-(UILabel *)showDeepSleeplabel
{
    if (!_showDeepSleeplabel) {
        _showDeepSleeplabel = [[UILabel alloc]init];
        _showDeepSleeplabel.textAlignment = NSTextAlignmentCenter;
        _showDeepSleeplabel.font = [UIFont systemFontOfSize:14];
    }
    return _showDeepSleeplabel;
}
-(UILabel *)showLightSleeplabel
{
    if (!_showLightSleeplabel) {
        _showLightSleeplabel = [[UILabel alloc]init];
        _showLightSleeplabel.textAlignment  = NSTextAlignmentCenter;
        _showLightSleeplabel.font = [UIFont systemFontOfSize:14];
    }
    return _showLightSleeplabel;
}
-(UILabel *)showAwakeSleeplabel
{
    if (!_showAwakeSleeplabel) {
        _showAwakeSleeplabel = [[UILabel alloc]init];
        _showAwakeSleeplabel.textAlignment  = NSTextAlignmentCenter;
        _showAwakeSleeplabel.font = [UIFont systemFontOfSize:14];
    }
    return _showAwakeSleeplabel;
}
-(UIView *)blueView
{
    if (!_blueView) {
        _blueView = [[UIView alloc]init];
        _blueView.backgroundColor = zhouSleepDeepColor;
        CGFloat blueViewW = 10;
        CGFloat blueViewH = blueViewW;
        _blueView.size = CGSizeMake(blueViewW, blueViewH);
    }
    return _blueView;
}
-(UIView *)greenView
{
    if (!_greenView) {
        _greenView = [[UIView alloc]init];
        _greenView.backgroundColor = zhouSleepLightColor;
        CGFloat greenViewW = 10;
        CGFloat greenViewH = greenViewW;
        _greenView.size = CGSizeMake(greenViewW, greenViewH);
    }
    return _greenView;
}
-(UIView *)orangeView
{
    if (!_orangeView) {
        _orangeView = [[UIView alloc]init];
        _orangeView.backgroundColor = zhouSleepAwakeColor;
        CGFloat orangeViewW = 10;
        CGFloat orangeViewH = orangeViewW;
        _orangeView.size = CGSizeMake(orangeViewW, orangeViewH);
    }
    return _orangeView;
}

-(UIImageView *)monthShowLabelView
{
    if (!_monthShowLabelView) {
        _monthShowLabelView = [[UIImageView alloc]init];
        _monthShowLabelView.image = [UIImage imageNamed:@"qipao_"];
    }
    return _monthShowLabelView;
}

-(UILabel *)monthLabelNumber
{
    if (!_monthLabelNumber) {
        _monthLabelNumber = [[UILabel alloc]init];
        _monthLabelNumber.textAlignment = NSTextAlignmentCenter;
        _monthLabelNumber.font = [UIFont systemFontOfSize:13*WidthProportion];
        _monthLabelNumber.backgroundColor = [UIColor clearColor];
    }
    return _monthLabelNumber;
}
-(UILabel *)monthLabelUnit
{
    if (!_monthLabelUnit) {
        _monthLabelUnit = [[UILabel alloc]init];
        _monthLabelUnit.textAlignment  = NSTextAlignmentCenter;
        _monthLabelUnit.font = [UIFont systemFontOfSize:8*WidthProportion];
        _monthLabelUnit.backgroundColor = [UIColor clearColor];
    }
    return _monthLabelUnit;
}
-(UIImageView *)monthShowLabelViewSleep
{
    if (!_monthShowLabelViewSleep) {
        _monthShowLabelViewSleep = [[UIImageView alloc]init];
        _monthShowLabelViewSleep.image = [UIImage imageNamed:@"RectangularBubble_"];
    }
    return _monthShowLabelViewSleep;
}
-(UILabel *)monthShowDeepSleeplabel
{
    if (!_monthShowDeepSleeplabel) {
        _monthShowDeepSleeplabel = [[UILabel alloc]init];
        _monthShowDeepSleeplabel.textAlignment = NSTextAlignmentCenter;
        _monthShowDeepSleeplabel.font = [UIFont systemFontOfSize:14];
    }
    return _monthShowDeepSleeplabel;
}
-(UILabel *)monthShowLightSleeplabel
{
    if (!_monthShowLightSleeplabel) {
        _monthShowLightSleeplabel = [[UILabel alloc]init];
        _monthShowLightSleeplabel.textAlignment  = NSTextAlignmentCenter;
        _monthShowLightSleeplabel.font = [UIFont systemFontOfSize:14];
    }
    return _monthShowLightSleeplabel;
}
-(UILabel *)monthShowAwakeSleeplabel
{
    if (!_monthShowAwakeSleeplabel) {
        _monthShowAwakeSleeplabel = [[UILabel alloc]init];
        _monthShowAwakeSleeplabel.textAlignment  = NSTextAlignmentCenter;
        _monthShowAwakeSleeplabel.font = [UIFont systemFontOfSize:14];
    }
    return _monthShowAwakeSleeplabel;
}
-(UIView *)monthBlueView
{
    if (!_monthBlueView) {
        _monthBlueView = [[UIView alloc]init];
        _monthBlueView.backgroundColor = zhouSleepDeepColor;
        CGFloat monthBlueViewW = 10;
        CGFloat monthBlueViewH = monthBlueViewW;
        _monthBlueView.size = CGSizeMake(monthBlueViewW, monthBlueViewH);
    }
    return _monthBlueView;
}
-(UIView *)monthGreenView
{
    if (!_monthGreenView) {
        _monthGreenView = [[UIView alloc]init];
        _monthGreenView.backgroundColor = zhouSleepLightColor;
        CGFloat monthGreenViewW = 10;
        CGFloat monthGreenViewH = monthGreenViewW;
        _monthGreenView.size = CGSizeMake(monthGreenViewW, monthGreenViewH);
    }
    return _monthGreenView;
}
-(UIView *)monthOrangeView
{
    if (!_monthOrangeView) {
        _monthOrangeView = [[UIView alloc]init];
        _monthOrangeView.backgroundColor = zhouSleepAwakeColor;
        CGFloat monthOrangeViewW = 10;
        CGFloat monthOrangeViewH = monthOrangeViewW;
        _monthOrangeView.size = CGSizeMake(monthOrangeViewW, monthOrangeViewH);
    }
    return _monthOrangeView;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
