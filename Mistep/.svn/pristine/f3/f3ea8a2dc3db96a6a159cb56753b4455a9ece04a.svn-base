////
////  DayOffLineViewController.m
////  Mistep
////
////  Created by 迈诺科技 on 15/12/21.
////  Copyright © 2015年 huichenghe. All rights reserved.
////
//
//#import "DayOffLineViewController.h"
//
//@interface DayOffLineViewController ()
//
//@end
//
//@implementation DayOffLineViewController
//
//
//- (void)setXibLabel
//{
//    _durationLabel.text = NSLocalizedString(@"总运动时长", nil);
//    _yujingLabel.text = NSLocalizedString(@"预警", nil);
//    [_yujingLabel sizeToFit];
//    _wuyangLabel.text = NSLocalizedString(@"无氧", nil);
//    _youyangLabel.text = NSLocalizedString(@"有氧", nil);
//    _ranzhiLabel.text = NSLocalizedString(@"燃脂", nil);
//    _reshenLabel.text = NSLocalizedString(@"热身", nil);
//    _avgHRLabel.text = NSLocalizedString(@"平均心率", nil);
//    _caloriesLabel.text = NSLocalizedString(@"热量消耗", nil);
//    _intensityLabel.text = NSLocalizedString(@"运动强度", nil);
//    _stateLabel.text = NSLocalizedString(@"非常低", nil);
//    _bpmLabel.text = @"bpm";
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    [self setXibLabel];
//    NSArray *typeArray = [[NSArray alloc]initWithObjects:
//                          @"jingxi",NSLocalizedString(@"静息", nil),
//                          @"tubu",NSLocalizedString(@"徒步", nil),
//                          @"paopu",NSLocalizedString(@"跑步",nil),
//                          @"pashan",NSLocalizedString(@"爬山",nil),
//                          @"qiulei",NSLocalizedString(@"球类运动", nil),
//                          @"juzhong",NSLocalizedString(@"力量训练",nil),
//                          @"youyang",NSLocalizedString(@"有氧训练",nil),
//                          @"JR_zidingyi",_contentDic[SportString_ActualData_HCH],
//                          nil];
//    _titleLabel.text = typeArray[[_contentDic[SportType_ActualData_HCH] intValue]*2 + 1];
//    [self loadData];
//    
//}
//
//- (void)loadData
//{
//    int begeinSecond = [_contentDic[StartTime_ActualData_HCH] intValue];
//    int endSecond = [_contentDic[StopTime_ActualData_HCH] intValue];
//    int cost = [_contentDic[CostCount_ActualData_HCH] intValue];
//    int beginIndex = [self getTimeIndexWithSecond:begeinSecond];
//    int endIndex = [self getTimeIndexWithSecond:endSecond];
//    int totalHeartRate = 0;
//
//    NSMutableArray *actualHeartArray = [[NSMutableArray alloc]init];
//    int activeMin = (endIndex - beginIndex)+1;
//    if (activeMin <= 0)
//    {
//        activeMin = (endSecond - begeinSecond)/60 + 1;
//    }
//    
//    int heartCount = 0;
//    if(beginIndex%180 + activeMin > _heartRateArray.count)
//    {
//        activeMin = _heartRateArray.count - beginIndex%180;
//    }
//    for (int i = beginIndex%180; i < beginIndex%180 + activeMin; i ++)
//    {
//        int heartRate = [_heartRateArray[i] intValue];
//        totalHeartRate += heartRate;
//        if (heartRate != 0)
//        {
//            heartCount ++;
//        }
//        [actualHeartArray addObject:[NSNumber numberWithInt:heartRate]];
//    }
//    int aveHeart = 0;
//    if (heartCount > 0)
//    {
//         aveHeart = totalHeartRate/heartCount;
//    }
//    
//    int age = [[HCHCommonManager getInstance] getPersonAge];
////    if (age > 60)
////    {
////        age = 60;
////    }
//    int maxHeartRate = 220 - age;
//  
//    NSMutableArray *stateArray  = [[NSMutableArray alloc]initWithObjects:@0,@0,@0,@0,@0, nil];
//    for (int i = 0 ; i < actualHeartArray.count; i ++)
//    {
//        int heartRate = [actualHeartArray[i] intValue];
//        float rate = (float)heartRate / maxHeartRate;
//        if (rate > 0.9)
//        {
//            int yujing = [stateArray[0] intValue];
//            yujing ++;
//            [stateArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:yujing]];
//        }else if (rate > 0.8)
//        {
//            int wuyang = [stateArray[1] intValue];
//            wuyang ++;
//            [stateArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:wuyang]];
//        }else if (rate > 0.7)
//        {
//            int youyang = [stateArray[2] intValue];
//            youyang ++;
//            [stateArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:youyang]];
//        }else if (rate > 0.6)
//        {
//            int ranzhi = [stateArray[3] intValue];
//            ranzhi ++;
//            [stateArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:ranzhi]];
//        }else
//        {
//            int reshen = [stateArray[4] intValue];
//            reshen ++;
//            [stateArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:reshen]];
//        }
//    }
//    int maxState = 0;
//    for (int i = 0 ; i < stateArray.count; i ++)
//    {
//        int stateCount = [stateArray[i] intValue];
//        if (maxState < stateCount)
//        {
//            maxState = stateCount;
//        }
//    }
//
//    if ([stateArray[3] intValue] >= 80)
//    {
//        _stateLabel.text = NSLocalizedString(@"低", nil);
//    }
//    if ([stateArray[2] intValue] >= 40)
//    {
//        _stateLabel.text = NSLocalizedString(@"中", nil);
//    }
//    if ([stateArray[1] intValue] >= 10)
//    {
//        _stateLabel.text = NSLocalizedString(@"高", nil);
//    }
//    if ([stateArray[0] intValue] >= 5)
//    {
//        _stateLabel.text = NSLocalizedString(@"非常高", nil);
//    }
//    NSArray *colorArray = [[NSArray alloc]initWithObjects:kColor(237, 62, 109),kColor(201, 110, 179),kColor(255, 156, 110),kColor(255, 117, 109),kColor(123, 191, 254), nil];
//    for (int i = 0 ; i < stateArray.count; i ++)
//    {
//        float stateCount = [stateArray[i] floatValue];
//        if (stateCount != 0)
//        {
//            
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_reshenLabel.right + 5, (106 + 16) + i * (16 + 21), (CurrentDeviceWidth - 300 - _ranzhiLabel.right) * stateCount/maxState, 21)];
//            view.backgroundColor = colorArray[i];
//            [self.view addSubview:view];
//           
//            [_ranzhiLabel sizeToFit];
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_reshenLabel.right + 5 + view.width +5, (106 + 16) + i * (16 + 21), 60, 21)];
//            label.text = [NSString stringWithFormat:NSLocalizedString(@"%.0f分钟", nil),stateCount];
//            [label sizeToFit];
//            label.font = [UIFont systemFontOfSize:15];
//            label.textColor = kColor(96, 96, 96);
//            [self.view addSubview:label];
//            view.sd_layout.leftSpaceToView(_yujingLabel,5)
//            .widthIs((CurrentDeviceWidth - label.width - _ranzhiLabel.size.width - _ranzhiLabel.origin.x - 30) * stateCount/maxState);
//            label.sd_layout.leftSpaceToView(view,5)
//            .widthIs(label.width);
//        }
//    }
//    _hourLabel.text = [NSString stringWithFormat:@"%d",activeMin/60];
//    _minLabel.text = [NSString stringWithFormat:@"%d",activeMin%60];
//    _costLabel.text = [NSString stringWithFormat:@"%d",cost];
//    _aveHeartLabel.text = [NSString stringWithFormat:@"%d",aveHeart];
//    
//}
//
//- (int)getTimeIndexWithSecond:(int)seconds
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH"];
//    int hour = [[dateFormatter stringFromDate:date] intValue];
//    [dateFormatter setDateFormat:@"mm"];
//    int min = [[dateFormatter stringFromDate:date]intValue];
//    int timeIndex = hour * 60 + min;
//    return timeIndex;
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)goBackAction:(id)sender
//{
//    if (_isFirst)
//    {
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
//        
//    }
//    else{
//    [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
