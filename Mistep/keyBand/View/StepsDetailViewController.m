//
//  StepsDetailViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 2016/9/29.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "StepsDetailViewController.h"
//#import "GCDDelay.h"

@interface StepsDetailViewController ()<StepsUivewDelegate>
@property (strong, nonatomic) UILabel *day220;//day220  多出来的部分
@property (strong, nonatomic) PZPilaoChart *chart;//疲劳视图上成图标
//@property (strong, nonatomic) GCDTask task;//用于延时的对象
@end

@implementation StepsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backNavView];
    [self creatChildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self reloadData];
    [self setBlocks];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
    [self childrenTimeSecondChanged];
    [self reloadBlueToothData];
    [self.datePickBtn setTitle:kLOCAL(@"运动锻炼") forState:UIControlStateNormal];
    [self.datePickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *shareBtn = [self.view viewWithTag:1002];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang-black"] forState:UIControlStateNormal];
}


#pragma mark -- 内部方法

- (void)childrenTimeSecondChanged
{
    [self reloadData];//更新数据
}

- (void)creatChildView
{
    _backScrollView = [[UIScrollView alloc] init];
    _backScrollView.frame = CGRectMake(0, SafeAreaTopHeight, CurrentDeviceWidth, CurrentDeviceHeight - SafeAreaTopHeight );
    [self.view addSubview:_backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height + 0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    WeakSelf;
    [self.backScrollView addHeaderWithCallback:^{
        if ([CositeaBlueTooth sharedInstance].isConnected == YES)
        {
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf reloadBlueToothData];
//            UIButton *HRVButton = (UIButton *)[weakSelf.backScrollView viewWithTag:202];
////            if (HRVButton.selected == YES)
////            {
////                HRVButton.selected = NO;
////                [weakSelf HRandHRVButtonClick:HRVButton];
////            }
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
    
    //装步数热量的view
    UIView *topButtonView = [[UIView alloc] init];
    [_backScrollView addSubview:topButtonView];
//    topButtonView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    topButtonView.layer.borderWidth = 0.5;
    topButtonView.clipsToBounds = YES;
    topButtonView.layer.cornerRadius = 16 * kSY;
    topButtonView.frame = CGRectMake((CurrentDeviceWidth - 80 * kX)/2., 11 * kSY , 80 * kX , 32 * kSY);
    [topButtonView addSubview:self.stepsButton];
    self.stepsButton.frame = CGRectMake(0, 0, topButtonView.width, topButtonView.height);
    //步数 卡路里 的柱状图
    self.stepsView = [[StepsUivew alloc] initWithFrame:CGRectMake(5, topButtonView.bottom + 8, CurrentDeviceWidth - 10, 193 * kSY)];
    [_backScrollView addSubview:self.stepsView];
    self.stepsView.steps = YES;
    
    NSArray *array= @[@"walk",@"SitStill"];
    NSArray *titleArr = @[kLOCAL(@"步数"),kLOCAL(@"久坐")];
    UIView *centerView;
    for (int i = 0; i < 2; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(24 * kX + (152 + 23) * kX * i,_stepsView.bottom + 15 , 152 * kX, 75*kSY);
        [_backScrollView addSubview:view];
        view.layer.cornerRadius = 8;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 0.5;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:array[i]];
        imageView.frame = CGRectMake(15 * kX, 0, 20*kX, view.height-10);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(imageView.right + 11, 20 * kSY, 1, (view.height - 20*kSY * 2));
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:lineLabel];
        
        UILabel *titlela = [[UILabel alloc] init];
        titlela.text = titleArr[i];
        titlela.textColor = kMainColor;
        titlela.font = [UIFont boldSystemFontOfSize:13];
        titlela.textAlignment = NSTextAlignmentCenter;
        titlela.frame = CGRectMake(2, view.height-30, lineLabel.left, 20);
        [view addSubview:titlela];
        
        UIImageView *timeImageView = [[UIImageView alloc] init];
        timeImageView.image = [UIImage imageNamed:@"ClockSmall"];
        timeImageView.contentMode = UIViewContentModeScaleAspectFit;
        timeImageView.frame = CGRectMake(lineLabel.right + 8, view.height/2. - 25 * kX, 20*kX, 20*kX);
        [view addSubview:timeImageView];
        
        UIImageView *costImageView = [[UIImageView alloc] init];
        costImageView.image = [UIImage imageNamed:@"CaloriesSmall"];
        costImageView.contentMode = UIViewContentModeScaleAspectFit;
        costImageView.frame = CGRectMake(lineLabel.right + 8,view.height/2. + 5 * kX, 20*kX, 20*kX);
        [view addSubview:costImageView];
        
        if (i == 0)
        {
            centerView = view;
            [view addSubview:self.activeTimeLabel];
            self.activeTimeLabel.frame = CGRectMake(timeImageView.right + 5, timeImageView.top, view.width - timeImageView.right - 5, timeImageView.height);
            self.activeTimeLabel.attributedText = [self getHandMinAttributeStringWithNumber:0];
            
            [view addSubview:self.activeCostLabel];
            self.activeCostLabel.frame = CGRectMake(timeImageView.right + 5, costImageView.top, view.width - timeImageView.right - 5, costImageView.height);
            self.activeCostLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
            
        }
        else
        {
            [view addSubview:self.camlTimeLabel];
            self.camlTimeLabel.frame = CGRectMake(timeImageView.right + 5, timeImageView.top, view.width - timeImageView.right - 5, timeImageView.height);
            self.camlTimeLabel.attributedText = [self getHandMinAttributeStringWithNumber:0];
            
            [view addSubview:self.camlCostLabel];
            self.camlCostLabel.frame = CGRectMake(timeImageView.right + 5, costImageView.top, view.width - timeImageView.right - 5, costImageView.height);
            self.camlCostLabel.attributedText = [self makeAttributedStringWithnumBer:@"0" Unit:@"kcal" WithFont:18];
        }
    }
    
    //装步数热量的view
    UIView *bottompButtonView = [[UIView alloc] init];
    [_backScrollView addSubview:bottompButtonView];
//    bottompButtonView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    bottompButtonView.layer.borderWidth = 0.5;
    bottompButtonView.clipsToBounds = YES;
    bottompButtonView.layer.cornerRadius = 16 * kSY;
    bottompButtonView.frame = CGRectMake((CurrentDeviceWidth - 80 * kX)/2., 11 * kSY + centerView.bottom , 80 * kX , 32 * kSY);
    [bottompButtonView addSubview:self.costsButton];
    self.costsButton.frame = CGRectMake(0, 0, bottompButtonView.width, topButtonView.height);
    //步数 卡路里 的柱状图
    self.colsView = [[StepsUivew alloc] initWithFrame:CGRectMake(5, bottompButtonView.bottom + 8, CurrentDeviceWidth - 10, 193 * kSY)];
    [_backScrollView addSubview:self.colsView];
    self.colsView.steps = NO;
    
//    UIView * bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = kColor(233, 243, 250);
//    bottomView.frame = CGRectMake(0, self.stepsView.bottom + 105 * kSY, CurrentDeviceWidth, _backScrollView.height - self.stepsView.bottom - 105 *kSY);
//    [_backScrollView addSubview:bottomView];
//
//    UIView *heartBackView = [[UIView alloc] init];
//    heartBackView.backgroundColor = [UIColor whiteColor];
//    heartBackView.frame = CGRectMake(10 * kX, 10 * kSY, CurrentDeviceWidth - 20 * kX, bottomView.height - 10 * kSY);
//    [bottomView addSubview:heartBackView];
//
//
//    UIView *HRButtonView = [[UIView alloc] init];
//    [heartBackView addSubview:HRButtonView];
//    HRButtonView.frame = CGRectMake(13 * kX, 13 * kSY, 87 * kX , 22*kSY);
//    HRButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    HRButtonView.layer.borderWidth = 0.5;
//    HRButtonView.layer.cornerRadius = 5;
//    HRButtonView.clipsToBounds = YES;
//
//    [HRButtonView addSubview:self.heartRateButton];
//    self.heartRateButton.frame = CGRectMake(0, 0, HRButtonView.width/2., 22*kSY);
//
//    [HRButtonView addSubview:self.HRVButton];
//    self.HRVButton.frame = CGRectMake(HRButtonView.width/2., 0 , HRButtonView.width/2.0, 22*kSY);
//
//    [heartBackView addSubview:self.maxHeartLabel];
//    self.maxHeartLabel.text = [NSString stringWithFormat:@"%@ %d",kLOCAL(@"最高心率"),0];
//    [self.maxHeartLabel sizeToFit];
//
//    [heartBackView addSubview:self.avgHeartLabel];
//    self.avgHeartLabel.text = [NSString stringWithFormat:@"%@ %d",kLOCAL(@"平均心率"),0];
//    [self.avgHeartLabel sizeToFit];
//
//    int heartLabelWidth = MAX(self.maxHeartLabel.width + 20, self.avgHeartLabel.width + 20);
//    self.maxHeartLabel.frame = CGRectMake(heartBackView.width - heartLabelWidth, 8 * kSY, heartLabelWidth, 14*kSY);
//    self.avgHeartLabel.frame = CGRectMake(heartBackView.width - heartLabelWidth, 26 * kSY, heartLabelWidth, 14*kSY);
//
//
//    UIView *heartView = [[UIView alloc] init];
//    [heartBackView addSubview:heartView];
//    heartView.frame = CGRectMake(0, HRButtonView.bottom + 11, heartBackView.width, heartBackView.height - HRButtonView.bottom - 11);
    //    heartView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
//    [self addHeartLabelTo:heartView];
//
//    self.heartScrollView = [[UIScrollView alloc] init];
//    self.heartScrollView.frame = CGRectMake(0, 0, heartView.width, heartView.height);
//    self.heartScrollView.showsHorizontalScrollIndicator = NO;
//    [heartView addSubview:self.heartScrollView];
    
//    self.heartChart = [[PZChart alloc] initWithFrame:CGRectMake(0, 0, 0, self.heartScrollView.frame.size.height)];
//    [self.heartScrollView addSubview:self.heartChart];
}

- (void)addHeartLabelTo:(UIView *)view
{
    NSArray *HRAlarmArray = [[NSUserDefaults standardUserDefaults] objectForKey:kHeartRateAlarm];
    int maxHR = 160;
    int minHR = 40;
    if (HRAlarmArray)
    {
        maxHR = [HRAlarmArray[1] intValue];
        minHR = [HRAlarmArray[0] intValue];
    }
    
    UILabel *dayWarningLabel1 = [[UILabel alloc] init];
    dayWarningLabel1.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel1.font = [UIFont systemFontOfSize:12];
    dayWarningLabel1.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    [view addSubview:dayWarningLabel1];
    dayWarningLabel1.frame = CGRectMake(0, 0, view.width, view.height/220 * (220 - maxHR));
    
    
    UILabel *day220 = [[UILabel alloc] init];
    _day220 = day220;
    day220.textColor = [UIColor grayColor];
    day220.text = @"220";
    [day220 sizeToFit];
    day220.font = [UIFont systemFontOfSize:12];
    [view addSubview:day220];
    
    day220.frame = CGRectMake(8, 0 - day220.height/2., day220.width, day220.height);
    
    
    
    UIImageView *lineImageView1 = [[UIImageView alloc] init];
    [view addSubview:lineImageView1];
    lineImageView1.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView1.contentMode = UIViewContentModeScaleToFill;
    lineImageView1.frame = CGRectMake(32, 0, view.width - 32, 1);
    
    UILabel *dayNormalLabel = [[UILabel alloc] init];
    dayNormalLabel.text = NSLocalizedString(@"         正常", nil);
    dayNormalLabel.textColor = [UIColor grayColor];
    dayNormalLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayNormalLabel];
    dayNormalLabel.frame = CGRectMake(0, dayWarningLabel1.bottom, view.width, view.height/220. * (maxHR - minHR));
    
    UILabel *dayMax = [[UILabel alloc] init];
    dayMax.textColor = [UIColor grayColor];
    
    dayMax.text = [NSString stringWithFormat:@"%.d",maxHR];
    [dayMax sizeToFit];
    dayMax.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayMax];
    dayMax.frame = CGRectMake(8, dayWarningLabel1.bottom - 5, dayMax.width, 10);
    
    
    UIImageView *lineImageView2 = [[UIImageView alloc] init];
    [view addSubview:lineImageView2];
    lineImageView2.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView2.contentMode = UIViewContentModeScaleToFill;
    lineImageView2.frame = CGRectMake(32, dayWarningLabel1.bottom, view.width - 32, 1);
    
    
    UILabel *dayWarningLabel2 = [[UILabel alloc] init];
    dayWarningLabel2.text = NSLocalizedString(@"         预警", nil);
    dayWarningLabel2.textColor = [UIColor colorWithRed:254/255.0 green:40/255.0 blue:42/255.0 alpha:0.6];
    dayWarningLabel2.font = [UIFont systemFontOfSize:12];
    [view addSubview:dayWarningLabel2];
    dayWarningLabel2.frame = CGRectMake(0, dayNormalLabel.bottom, view.width, view.height - dayNormalLabel.bottom);
    
    
    UILabel *day50 = [[UILabel alloc] init];
    day50.textColor = [UIColor grayColor];
    day50.text = [NSString stringWithFormat:@"%d",minHR];
    [day50 sizeToFit];
    day50.font = [UIFont systemFontOfSize:12];
    [view addSubview:day50];
    day50.frame = CGRectMake(8, dayNormalLabel.bottom - 5, day50.width, 10);
    
    
    UIImageView *lineImageView3 = [[UIImageView alloc] init];
    [view addSubview:lineImageView3];
    lineImageView3.image = [UIImage imageNamed:@"XQ_pointLine"];
    lineImageView3.contentMode = UIViewContentModeScaleToFill;
    lineImageView3.frame = CGRectMake(32, dayNormalLabel.bottom, view.width - 32, 1);
}

- (void)reloadData//更新数据
{
    [self updateLabelMiddle];
    [self updateStepsData];
    [self updateHeartData];
    
    //    [self updateLabels];
    //    [self reloadStepsData];
    //    [self reloadHeartData];
}
-(void)updateLabelMiddle
{
    [self updateLabels];
    //   一、更新label
    //   用户 上传下行，，查看数据
    //    if([AllTool isDirectUse])
    //    {
    //        //        NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    //        //        if(dic)
    //        //        {
    //        [self updateLabels];
    //        //        }
    //    }
    //    else
    //    {
    //        //蓝牙没有连接就查询服务器
    //        if ([CositeaBlueTooth sharedInstance].isConnected)
    //        {
    //            [self performSelector:@selector(updateLabels) withObject:nil afterDelay:1.0f];
    //            NSDictionary *dic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    //            if(dic)
    //            {
    //                [self updateLabels];
    //            }
    //            else
    //            {
    //                WeakSelf;
    //                [TimingUploadData  downDayTotalData:^(NSDictionary *dict) {
    //                    [weakSelf updateLabels];
    //                } date:kHCH.selectTimeSeconds];
    //            }
    //        }
    //        else
    //        {
    //            [self performSelector:@selector(updateLabels) withObject:nil afterDelay:1.0f];
    //            WeakSelf;
    //            [TimingUploadData  downDayTotalData:^(NSDictionary *dict) {
    //                [weakSelf updateLabels];
    //            } date:kHCH.selectTimeSeconds];
    //        }
    //    }
}
-(void)updateStepsData
{
    [self reloadStepsData];
    //   二 、更新   Steps
    
    //   用户 上传下行，，查看数据
    //    if([AllTool isDirectUse])
    //    {
    //        //        NSDictionary *dic =  [[CoreDataManage shareInstance]querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    //        //        if(dic)
    //        //        {
    //        [self reloadStepsData];
    //        //        }
    //    }
    //    else
    //    {
    //        //蓝牙没有连接就查询服务器
    //        if ([CositeaBlueTooth sharedInstance].isConnected)
    //        {
    //            WeakSelf;
    //            //等待  1   秒。还没有下载完成就取表中数据
    //            //            self.task = [GCDDelay gcdDelay:1 task:^{
    //            //                [weakSelf reloadStepsData];
    //            //            }];
    //            NSDictionary *dic =  [[CoreDataManage shareInstance]querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    //            if(dic)
    //            {
    //                [self reloadStepsData];
    //            }
    //            else
    //            {
    //
    //                self.task = [GCDDelay gcdDelay:1 task:^{
    //                    [weakSelf reloadStepsData];
    //                }];
    //                [TimingUploadData downDayDetailSteps:^(NSArray *array) {
    //                    [TimingUploadData downDayDetailCosts:^(NSArray *array) {
    //                        [TimingUploadData downDayDetailHRV:^(NSArray *array) {
    //                            [weakSelf reloadStepsData];
    //                        } date:kHCH.selectTimeSeconds];
    //                    } date:kHCH.selectTimeSeconds];
    //                } date:kHCH.selectTimeSeconds];
    //            }
    //        }
    //        else
    //        {
    //            WeakSelf;
    //            //等待  1   秒。还没有下载完成就取表中数据
    //            self.task = [GCDDelay gcdDelay:1 task:^{
    //                [weakSelf reloadStepsData];
    //            }];
    //
    //            [TimingUploadData downDayDetailSteps:^(NSArray *array) {
    //                [TimingUploadData downDayDetailCosts:^(NSArray *array) {
    //                    [TimingUploadData downDayDetailHRV:^(NSArray *array) {
    //                        [weakSelf reloadStepsData];
    //                    } date:kHCH.selectTimeSeconds];
    //                } date:kHCH.selectTimeSeconds];
    //            } date:kHCH.selectTimeSeconds];
    //        }
    //    }
}
-(void)updateHeartData
{
    [self reloadHeartData];
    //   三、更新   heart
    
    //   用户 上传下行，，查看数据
    //    if([AllTool isDirectUse])
    //    {
    //        //        NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+1];
    //
    //        [self reloadHeartData];
    //
    //    }
    //    else
    //    {
    //
    //        //蓝牙没有连接就查询服务器
    //        if ([CositeaBlueTooth sharedInstance].isConnected)
    //        {
    //            NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+1];
    //            if(heartDic)
    //            {
    //                [self reloadHeartData];
    //            }
    //            else
    //            {
    //                WeakSelf;
    //                [TimingUploadData downDayHeartRate:^(NSArray *array) {
    //                    [weakSelf reloadHeartData];
    //                } date:kHCH.selectTimeSeconds];
    //            }
    //        }
    //        else
    //        {
    //            WeakSelf;
    //            [TimingUploadData downDayHeartRate:^(NSArray *array) {
    //                [weakSelf reloadHeartData];
    //            } date:kHCH.selectTimeSeconds];
    //        }
    //    }
}
- (void)updateLabels
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLabels) object:nil];
    self.totalDic =  [[SQLdataManger getInstance] getTotalDataWith:kHCH.selectTimeSeconds];
    int activeTime =  [_totalDic[TotalDataActivityTime_DayData_HCH] intValue];
    int calmdownTime = [_totalDic[TotalDataCalmTime_DayData_HCH] intValue];
    int activeCosts = [_totalDic[kTotalDayActivityCost] intValue];
    int calmCosts = [_totalDic[kTotalDayCalmCost] intValue];
    self.activeTimeLabel.attributedText = [self getHandMinAttributeStringWithNumber:activeTime];
    self.camlTimeLabel.attributedText = [self getHandMinAttributeStringWithNumber:calmdownTime];
    self.activeCostLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",activeCosts] Unit:@"kcal" WithFont:18];
    self.camlCostLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",calmCosts] Unit:@"kcal" WithFont:18];
}

- (void)reloadStepsData
{
//    [GCDDelay gcdCancel:self.task];
    NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:[[TimeCallManager getInstance] getSecondsOfCurDay]];
    NSArray *stepsArray;
    if (!((NSNull *)detailDic[kDayStepsData] == [NSNull null]))
        stepsArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kDayStepsData]];
    if (stepsArray)
    {
//#warning mark  测试修改
//        stepsArray = @[@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400"];
        self.stepsArray = stepsArray;
    }
    else
    {
//           stepsArray = @[@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400",@"400"];
        self.stepsArray = nil;
    }
    NSArray *costsArray;
    if (!((NSNull *)detailDic[kDayCostsData] == [NSNull null]))
        costsArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kDayCostsData]];
    if (costsArray)
    {
        self.costsArray = costsArray;//stepsArray;
    }
    else
    {
        self.costsArray = nil;
    }
    NSArray *HRVArray;
    if (!((NSNull *)detailDic[kPilaoData] == [NSNull null]))
        HRVArray = [NSKeyedUnarchiver unarchiveObjectWithData:detailDic[kPilaoData]];
    if (HRVArray)
    {
        self.HRVArray = HRVArray;
    }
    else
    {
        self.HRVArray = nil;
    }
}

- (void)reloadHeartData
{
    int beginTime = 0;//1～8 8个包，一个包3小时
    BOOL stepIsBegin = NO;
    for (int i = 0; i < self.stepsArray.count; i ++)
    {
        int step =[self.stepsArray[i] intValue];
        if (step != 0 && stepIsBegin == NO)
        {
            beginTime = i;
            stepIsBegin = YES;
        }
    }
    int heartBegin = beginTime/3+1;
    int heartEnd = 0;
    if (kHCH.selectTimeSeconds == [[TimeCallManager getInstance] getSecondsOfCurDay])
    {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH"];
        NSString *hourString = [formatter stringFromDate:date];
        heartEnd = [hourString intValue]/3+1;
    }
    else
    {
        heartEnd = 8;
    }
    if (!self.heartsArray)
    {
        self.heartsArray  = [[NSMutableArray alloc] init];
    }
    [self.heartsArray removeAllObjects];
    for (int i = heartBegin; i < heartEnd + 1; i ++)
    {
        NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
        NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
        //        //adaLog(@"array - %@",array);
        if (array)
        {
            [self.heartsArray addObjectsFromArray:array];
        }
    }
    if (self.heartsArray.count != 0)//删除前面无效的心率
    {
        int beginIndex = beginTime%3;
        [self.heartsArray removeObjectsInRange:NSMakeRange(0, beginIndex * 60)];
    }
    
    int maxheart = 0;
    int heartCount = 0;
    int totalHeart = 0;
    
    for (int i = 0 ;  i < self.heartsArray.count; i ++)
    {
        int heart = [self.heartsArray[i] intValue];
        if (maxheart < heart)
        {
            maxheart = heart;
        }
        if (heart != 0 )
        {
            totalHeart += heart;
            heartCount += 1;
        }
    }
    if (heartCount != 0)
    {
        int aveHeart = totalHeart/heartCount;
        _maxHeartLabel.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"最高心率:", nil) ,maxheart];
        _avgHeartLabel.text = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"平均心率:", nil) ,aveHeart];
    }
    else
    {
        _maxHeartLabel.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"最高心率:", nil) ,0];
        _avgHeartLabel.text = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"平均心率:", nil) ,0];
    }
    
    int showBegin = 0;
    int showEnd = 0;
    BOOL isBegin = NO;
    NSMutableArray *showHearArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < self.heartsArray.count; i ++)
    {
        int heart = [self.heartsArray[i] intValue];
        if (heart != 0)
        {
            showEnd = i;
            if (isBegin == NO)
            {
                isBegin = YES;
                showBegin = i;
            }
        }
        if (isBegin)
        {
            [showHearArray addObject:[NSNumber numberWithInt:heart]];
        }
    }
    
    self.heartScrollView.contentSize= CGSizeMake(showEnd - showBegin + 20, self.heartScrollView.frame.size.height);
    for (UILabel *label in self.heartScrollView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            label.hidden = YES;
            [label removeFromSuperview];
        }
    }
    
    for (int i = showBegin ; i < showEnd; i ++)
    {
        if (i % 60 ==0)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (i - showBegin) , self.heartScrollView.frame.size.height - 15 , 43 , 15)];
            label.text = [NSString stringWithFormat:@"%d:00",beginTime + i/60];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            if (_pilaoView) {
                [self.heartScrollView insertSubview:label belowSubview:_pilaoView];
            }
            else
            {
                [self.heartScrollView addSubview:label];
            }
        }
    }
    self.heartChart.heartArray = showHearArray;
#warning  警告  ---   以后这里要改的
}

- (void)reloadBlueToothData
{
    WeakSelf;
    [[PZBlueToothManager sharedInstance] checkHourStepsAndCostsWithBlock:^(NSArray *steps, NSArray *costs) {
        [self reloadStepsData];
        [weakSelf.backScrollView headerEndRefreshing];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    }];
    [[PZBlueToothManager sharedInstance] chekCurDayAllDataWithBlock:^(NSDictionary *dic) {
        [self updateLabels];
    }];
    
    [[PZBlueToothManager sharedInstance] checkTodayHeartRateWithBlock:^(int timeSeconds, int index, NSArray *heartArray) {
        [self reloadHeartData];
    }];
    [[PZBlueToothManager sharedInstance] checkHRVDataWithHRVBlock:^(int number, NSArray *array)
     {
         if(array)
         {
             [self reloadStepsData];
         }
     }];
}

- (void)setBlocks
{
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

- (void)reloadOutTime
{
    [self.backScrollView headerEndRefreshing];
    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}

- (NSMutableAttributedString *)getHandMinAttributeStringWithNumber:(int)number
{
    NSMutableAttributedString *attributeString = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number / 60] Unit:@"h" WithFont:18];
    [attributeString appendAttributedString:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",number%60] Unit:@"min" WithFont:18]];
    return attributeString;
}

- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 7] range:NSMakeRange(0, unitString.length)];
    [unitString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}


#pragma mark -- button方法

- (void)changeStepsOrCosts:(UIButton *)button
{
    if (button.selected) return;
    if (button == _stepsButton)
    {
        _stepsButton.selected = YES;
        _costsButton.selected = NO;
        self.stepsView.backImageView.image = [UIImage imageNamed:@"StepChartBackgroundO"];
        if (self.stepsArray)
        {
            self.stepsView.steps = YES;
            self.stepsView.dataArray = self.stepsArray;
            
            
        }
    }
    else if (button == _costsButton)
    {
        _stepsButton.selected = NO;
        _costsButton.selected = YES;
        self.stepsView.backImageView.image = [UIImage imageNamed:@"StepChartBackground"];
        if (self.costsArray)
        {
            self.stepsView.steps = NO;
            self.stepsView.dataArray = self.costsArray;
            
        }
    }
}

- (void)HRandHRVButtonClick:(UIButton *)button
{
    if (button == _heartRateButton)
    {
        if (_heartRateButton.selected) return;
        _heartRateButton.selected = YES;
        _HRVButton.selected = NO;
        
        //        _pilaoView.hidden = YES;
        [_pilaoView removeFromSuperview];
        _maxHeartLabel.hidden = NO;
        _avgHeartLabel.hidden = NO;
        self.day220.hidden = NO;
        _pilaoView = nil;
        _heartScrollView.scrollEnabled = YES;
        
    }
    else if (button == _HRVButton)
    {
        if (_HRVButton.selected) return;
        
        _heartRateButton.selected = NO;
        _HRVButton.selected = YES;
        
        if (![HCHCommonManager getInstance].pilaoValue) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"当前手环版本不支持此功能", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        self.day220.hidden = YES;
        _maxHeartLabel.hidden = YES;
        _avgHeartLabel.hidden = YES;
        
        
        [_heartScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _heartScrollView.scrollEnabled = NO;
        [self.heartScrollView addSubview:self.pilaoView];
    }
    
}

#pragma mark --set方法

- (void)setStepsArray:(NSArray *)stepsArray
{
    if (_stepsArray != stepsArray)
    {
        _stepsArray = stepsArray;
        //        if (_stepsView && _stepsButton.selected)
        //        {
        _stepsView.dataArray = stepsArray;
        //        }
        
    }
}

- (void)setCostsArray:(NSArray *)costsArray
{
    if (_costsArray != costsArray)
    {
        _costsArray = costsArray;
        _colsView.dataArray = costsArray;
    }
}

- (void)setHeartsArray:(NSMutableArray *)heartsArray
{
    if (_heartsArray != heartsArray)
    {
        _heartsArray = heartsArray;
        //        if (_stepsView && _costsButton.selected)
        //        {
        //            _stepsView.dataArray = costsArray;
        //        }
    }
}

- (void)setHRVArray:(NSArray *)HRVArray
{
    if (_HRVArray != HRVArray)
    {
        _HRVArray = HRVArray;
        if (_pilaoView && _HRVButton.selected)
        {
            _chart.pilaoArray = HRVArray;
        }
    }
}
#pragma mark -- get方法

- (UIButton *)stepsButton
{
    if (!_stepsButton)
    {
        _stepsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_stepsButton setBackgroundImage:[self imageWithColor:kMainColor] forState:UIControlStateNormal];
        [_stepsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _stepsButton.titleLabel.font = Font_Normal_String(13);
        [_stepsButton setTitle:kLOCAL(@"步数") forState:UIControlStateNormal];
        _stepsButton.selected = YES;
        _stepsButton.tag = 101;
//        [_stepsButton addTarget:self action:@selector(changeStepsOrCosts:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stepsButton;
}

- (UIButton *)costsButton
{
    if (!_costsButton)
    {
        _costsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_costsButton setTitle:kLOCAL(@"热量") forState:UIControlStateNormal];
        
        [_costsButton setBackgroundImage:[self imageWithColor:kMainColor] forState:UIControlStateNormal];
        [_costsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _costsButton.titleLabel.font = Font_Normal_String(13);
//        [_costsButton addTarget:self action:@selector(changeStepsOrCosts:) forControlEvents:UIControlEventTouchUpInside];
        _costsButton.tag = 102;
    }
    return _costsButton;
}

- (UILabel *)activeTimeLabel
{
    if (!_activeTimeLabel)
    {
        _activeTimeLabel = [[UILabel alloc] init];
    }
    return _activeTimeLabel;
}

-(UILabel *)activeCostLabel
{
    if (!_activeCostLabel)
    {
        _activeCostLabel = [[UILabel alloc] init];
    }
    return _activeCostLabel;
}

- (UILabel *)camlTimeLabel
{
    if (!_camlTimeLabel)
    {
        _camlTimeLabel = [[UILabel alloc] init];
    }
    return _camlTimeLabel;
}

- (UILabel *)camlCostLabel
{
    if (!_camlCostLabel)
    {
        _camlCostLabel = [[UILabel alloc] init];
    }
    return _camlCostLabel;
}

- (UIButton *)heartRateButton
{
    if (!_heartRateButton)
    {
        _heartRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_heartRateButton setBackgroundImage:[self imageWithColor:kColor(68, 110, 230)] forState:UIControlStateSelected];
        [_heartRateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_heartRateButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_heartRateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _heartRateButton.titleLabel.font = Font_Normal_String(13);
        [_heartRateButton setTitle:kLOCAL(@"心率") forState:UIControlStateNormal];
        _heartRateButton.selected = YES;
        _heartRateButton.tag = 201;
        [_heartRateButton addTarget:self action:@selector(HRandHRVButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _heartRateButton;
}

- (UIButton *)HRVButton
{
    if (!_HRVButton)
    {
        _HRVButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_HRVButton setBackgroundImage:[self imageWithColor:kColor(68, 110, 230)] forState:UIControlStateSelected];
        [_HRVButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_HRVButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_HRVButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _HRVButton.titleLabel.font = Font_Normal_String(13);
        [_HRVButton setTitle:kLOCAL(@"HRV") forState:UIControlStateNormal];
        _HRVButton.selected = NO;
        _HRVButton.tag = 202;
        
        [_HRVButton addTarget:self action:@selector(HRandHRVButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _HRVButton;
}

- (UILabel *)maxHeartLabel
{
    if (!_maxHeartLabel)
    {
        _maxHeartLabel = [[UILabel alloc] init];
        _maxHeartLabel.textColor = [UIColor grayColor];
        _maxHeartLabel.font = Font_Normal_String(11);
    }
    return _maxHeartLabel;
}

- (UILabel *)avgHeartLabel
{
    if (!_avgHeartLabel)
    {
        _avgHeartLabel = [[UILabel alloc] init];
        _avgHeartLabel.textColor = [UIColor grayColor];
        _avgHeartLabel.font = Font_Normal_String(11);
    }
    return _avgHeartLabel;
}

- (UIView *)pilaoView
{
    if (!_pilaoView)
    {
        _pilaoView = [[PZPilaoView alloc] initWithFrame:CGRectMake(0, 0, self.heartScrollView.width, self.heartScrollView.height)];
        [self.heartScrollView addSubview:_pilaoView];
        PZPilaoChart *chart = [[PZPilaoChart alloc] initWithFrame:CGRectMake(_pilaoView.frame.origin.x, 5, _pilaoView.frame.size.width, _pilaoView.frame.size.height - 23)];
        _chart = chart;
        //        chart.backgroundColor = [UIColor greenColor];
        chart.pilaoArray = self.HRVArray;
        [_pilaoView addSubview:chart];
        
    }
    return _pilaoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
