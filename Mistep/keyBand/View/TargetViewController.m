//
//  TargetViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/11.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "TargetViewController.h"
#import "SEFilterControl.h"
#import "NightFilterControl.h"

@interface TargetViewController ()

{
    SEFilterControl *dayFilter;
    NightFilterControl *nightFilter;
}

@end

@implementation TargetViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"目标设置", nil);
    _stepLabel.text = NSLocalizedString(@"运动目标", nil);
    _sleepLabel.text = NSLocalizedString(@"睡眠目标", nil);
    _introducLabel.text = NSLocalizedString(@"根据个人数据，设置相应目标！", nil);
    [_completionBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabel];
    
    CGFloat flite = [UIScreen mainScreen].bounds.size.height/480;
    
    
    self.dayView.layer.cornerRadius = 8;
    [self.dayView clipsToBounds];
    dayFilter = [[SEFilterControl alloc]initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth-20, 25*flite) Titles:@[@"2000",@"4000",@"6000",@"8000",@"10000",@"12000",@"14000",@"16000",@"18000",@"20000"]];
    
    int stepsPlan = [HCHCommonManager getInstance].stepsPlan;
    dayFilter.SelectedIndex = (stepsPlan - 2000)/2000;
    [dayFilter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    //    filter.tag = 400 + index;
    [dayFilter setTitlesColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1]];
    [self.dayView addSubview:dayFilter];
    
    [self filterValueChanged:dayFilter];
    
    self.nightView.layer.cornerRadius = 8;
    [self.nightView clipsToBounds];
    nightFilter = [[NightFilterControl alloc]initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth - 20, 25*flite) Titles:@[@"4h",@"5h",@"6h",@"7h",@"8h",@"9h",@"10h",@"11h",@"12h"]];
    int sleepPlan = [HCHCommonManager getInstance].sleepPlan;
    nightFilter.SelectedIndex = (sleepPlan/60 - 4);
    [nightFilter addTarget:self action:@selector(nightFilterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [nightFilter setTitlesColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1]];
    [self.nightView addSubview:nightFilter];
    [self nightFilterValueChanged:nightFilter];
}

- (void)viewDidLayoutSubviews
{
    dayFilter.center = CGPointMake(CurrentDeviceWidth/2, _dayView.height/2. + 20);
    nightFilter.center = CGPointMake(CurrentDeviceWidth/2., _nightView.height/2. + 20);
}

-(void)filterValueChanged:(SEFilterControl *)filter
{
    switch (filter.SelectedIndex)
    {
        case 0:  case 1:
        {
            _dayTypeLabel.text = NSLocalizedString(@"偏低", nil);
        }
            break;
        case 2: case 3:
        {
            _dayTypeLabel.text = NSLocalizedString(@"正常", nil);
        }
            break;
        case 4: case 5:
        {
            _dayTypeLabel.text = NSLocalizedString(@"活跃", nil);
        }
            break;
        case 6:  case 7:  case 8:  case 9:
        {
            _dayTypeLabel.text = NSLocalizedString(@"达人", nil);
        }
        default:
            break;
    }
}

- (void)nightFilterValueChanged:(NightFilterControl *)nightFil
{
    switch (nightFil.SelectedIndex)
    {
        case 0: case 1: case 2:
        {
            _nightTypeLabel.text = NSLocalizedString(@"偏少", nil);
        }
            break;
        case 3: case 4: case 5:
        {
            _nightTypeLabel.text = NSLocalizedString(@"正常", nil);
        }
            break;
        case 6: case 7: case 8:
        {
            _nightTypeLabel.text = NSLocalizedString(@"充裕", nil);
        }
            break;
        default:
            break;
    }
}

- (IBAction)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)completAction:(id)sender
{
    int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
    int dayValue = dayFilter.SelectedIndex*2000 + 2000;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:dayValue]  forKey:Steps_PlanTo_HCH];
    [HCHCommonManager getInstance].stepsPlan = dayValue;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int nightValue = (nightFilter.SelectedIndex*1 + 4)*60;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:nightValue] forKey:Sleep_PlanTo_HCH];
    [HCHCommonManager getInstance].sleepPlan = nightValue;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
    NSString *macAddress = [AllTool amendMacAddressGetAddress];
    //    NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
    //    if (!macAddress)
    //    {
    //        macAddress = DEFAULTDEVICEID;
    //    }
    if (dic) {
        [dic setValue:[NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan] forKey:Sleep_PlanTo_HCH];
        [dic setValue:[NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan ] forKey:Steps_PlanTo_HCH];
    }else {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
               [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
               [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
               [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
               [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
               [NSNumber numberWithInt: [HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
               [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan ], Steps_PlanTo_HCH,
               [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
               [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
               [NSNumber numberWithInt:0],TotalDayEventCount_DayData_HCH,
               [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
               [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
               [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
               macAddress,DEVICEID,
               @"0",ISUP,
               nil];
    }
    [[SQLdataManger getInstance] insertSignalDataToTable:DayTotalData_Table withData:dic];
    //保存睡眠目标和运动目标。发送给蓝牙
    
    [[CositeaBlueTooth sharedInstance] activeCompletionDegree];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end