//
//  ViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/27.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RgistViewController.h"
#import "HomeViewController.h"
#import "TodayViewController.h"
#import "EditPersonInformationViewController.h"
#import "StartUpViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SQLdataManger getInstance] updateSqlite];
    int unitState = [[[NSUserDefaults standardUserDefaults] objectForKey:kUnitStateKye] intValue];
    if (unitState != 2 && unitState!=3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:3] forKey:kUnitStateKye];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    _backGroundImageView.contentMode = UIViewContentModeScaleToFill;
//    [_notLoginBtn setTitle:NSLocalizedString(@"直接使用", nil) forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
//    _loginBtn.layer.cornerRadius = 5;
//    _loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _loginBtn.layer.borderWidth = 1.;
//
//    [_registBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
//    _registBtn.layer.cornerRadius = 5;
//    _registBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _registBtn.layer.borderWidth = 1.;
//
//
//    NSArray *allLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    NSString *prefeffedLang = allLanguages[0];
//    if ([prefeffedLang hasPrefix:@"zh-Hans"])
//    {
//        [HCHCommonManager getInstance].LanuguageIndex_SRK = ChinesLanguage_Enum;
//    }else if ([prefeffedLang hasPrefix:@"ko"])
//    {
//        [HCHCommonManager getInstance].LanuguageIndex_SRK = KoreaLanguage_Enum;
//    }else if ([prefeffedLang hasPrefix:@"es"])
//    {
//        [HCHCommonManager getInstance].LanuguageIndex_SRK = SpanishLanguage_Enum;
//    }
//    else
//    {
//        [HCHCommonManager getInstance].LanuguageIndex_SRK = EnglishLanguage_Enum;
//    }
    [self newCacheLogin];//新的登录方式
    
    //    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
    //    if (dic.allKeys.count>0)
    //    {
    //        [ADASaveDefaluts setObject:@"1" forKey:LOGINTYPE];
    //        [self useCacheLogin:dic];
    //    }
    //    else
    //    {
    //        NSDictionary *thirdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kThirdPartLoginKey];
    //        if (thirdDic.allKeys.count>0)
    //        {
    //            [ADASaveDefaluts setObject:@"2" forKey:LOGINTYPE];
    //            [self useThirdCacheLogin:thirdDic];
    //        }
    //    }
}
     
-(void)dimissAlertController:(UIAlertController *)alert {
     if(alert)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }
 }
     
-(void)newCacheLogin
{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
//    NSDictionary *thirdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kThirdPartLoginKey];
    
    
    if (dic.allKeys.count>0)
    {
        [self loginHome];
        [AllTool startUpData];
        [HCHCommonManager getInstance].isLogin = YES;
        [ADASaveDefaluts setObject:@"1" forKey:LOGINTYPE];
        
        [HCHCommonManager getInstance].isThirdPartLogin = NO;
//        [super backstageUseCacheLogin:dic];
    }
    else
    {
        //跳转到登录页面
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[StartUpViewController alloc] init]];
        [self setRootViewController:loginNav animationType:@""];
    }
}

- (void)loginTimeOut
{
    [self removeActityIndicatorFromView:self.view];
    [self addActityTextInView:self.view text:NSLocalizedString(@"登录失败", nil)  deleyTime:1.5f];
}
- (void)useThirdCacheLogin:(NSDictionary *)param
{
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在登录", nil)detailLabel:NSLocalizedString(@"正在登录", nil)];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_thirdPartyLogin" ParametersDictionary:param Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task){
        if (error)
        {
            [self loginTimeOut];
        }
        else
        {
            [self thirdPartLoginDic:responseObject];
        }
    } ];
}

- (void)thirdPartLoginDic:(NSDictionary *)param;
{
    int code = [param[@"code"] intValue];
    if (code == 9005) {
        NSDictionary *dic = param[@"data"];
        NSString *account = dic[@"account"];
        [[HCHCommonManager getInstance] setUserAcountName:account];
        
        EditPersonInformationViewController *personVC = [[EditPersonInformationViewController alloc]init];
        personVC.isEdit = YES;
        personVC.EditState = EditPersonStateEdit;
        [self.navigationController pushViewController:personVC animated:YES];
        [HCHCommonManager getInstance].isLogin = YES;
        [HCHCommonManager getInstance].isThirdPartLogin = YES;
        [HCHCommonManager getInstance].isFirstLogin = YES;
    }
    else if (code == 9003)
    {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"data"]];
        NSString *birthDay = tempDic[@"birthdate"];
        if ((NSNull *)birthDay == [NSNull null])
        {
            NSDictionary *dic = param[@"data"];
            NSString *account = dic[@"account"];
            [[HCHCommonManager getInstance] setUserAcountName:account];
            
            EditPersonInformationViewController *personVC = [[EditPersonInformationViewController alloc]init];
            personVC.isEdit = YES;
            personVC.EditState = EditPersonStateEdit;
            [self.navigationController pushViewController:personVC animated:YES];
            [HCHCommonManager getInstance].isLogin = YES;
            [HCHCommonManager getInstance].isThirdPartLogin = YES;
            [HCHCommonManager getInstance].isFirstLogin = YES;
            return;
        }
        [self addActityTextInView:self.view text:NSLocalizedString(@"登录成功", nil) deleyTime:1.5f];
        [AllTool startUpData];
        NSString *name = [tempDic objectForKey:@"header"] ;
        if ((NSNull *)name == [NSNull null]) {
            [tempDic setValue:nil forKey:@"header"];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
        NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
        if (!dic) {
            NSString *macAddress = [AllTool amendMacAddressGetAddress];
            //            NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //            if (!macAddress)
            //            {
            //                macAddress = DEFAULTDEVICEID;
            //            }
            dic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                   [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                   [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
                   [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
                   [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
                   [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
                   [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
                   [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
                   [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
                   [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
                   [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
                   [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
                   macAddress,DEVICEID,
                   @"0",ISUP,
                   nil];
            [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
        }
        
        [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"data"]];
        //        [[HCHCommonManager getInstance] setUserAcountName:loginDic[@"account"]];
        [HCHCommonManager getInstance].isLogin = YES;
        [HCHCommonManager getInstance].isThirdPartLogin = YES;
        [self loginHome];
    }
}

- (void)useCacheLogin:(NSDictionary *)loginDic
{
    //adaLog(@"iphoneNetwork   ==   %ld",kHCH.iphoneNetworkStatus);
    if (kHCH.iphoneNetworkStatus==NotReachable)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"当前无网络连接", nil) deleyTime:4.0f];
        return;
    }
    
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在登录", nil)detailLabel:NSLocalizedString(@"正在登录", nil)];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:10.];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_login" ParametersDictionary:loginDic Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task)
     {
         [NSObject cancelPreviousPerformRequestsWithTarget:self];
         [self removeActityIndicatorFromView:self.view];
         if (error)
         {
             [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
         }
         else
         {
             
             //adaLog(@"msg = %@",[responseObject objectForKey:@"msg"]);
             int code = [[responseObject objectForKey:@"code"] intValue];
             
             if (code == 9003)
             {
                 [self addActityTextInView:self.view text:NSLocalizedString(@"登录成功", nil) deleyTime:1.5f];
                 [AllTool startUpData];
                 NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                 NSString *name = [tempDic objectForKey:@"header"] ;
                 if ((NSNull *)name == [NSNull null]) {
                     [tempDic setValue:nil forKey:@"header"];
                 }
                 
                 [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
                 NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
                 if (!dic) {
                     NSString *macAddress = [AllTool amendMacAddressGetAddress];
                     //                     NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
                     //                     if (!macAddress)
                     //                     {
                     //                         macAddress = DEFAULTDEVICEID;
                     //                     }
                     dic = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
                            [NSNumber numberWithInt:timeSeconds],  DataTime_HCH,
                            [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
                            [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
                            [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
                            [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
                            [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan], Steps_PlanTo_HCH,
                            [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
                            [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
                            [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
                            [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
                            [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
                            [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
                            [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:timeSeconds]], TotalDataWeekIndex_DayData_HCH,
                            [NSString stringWithFormat:@"%03d",[[ADASaveDefaluts objectForKey:AllDEVICETYPE] intValue]],DEVICETYPE,
                            macAddress,DEVICEID,
                            @"0",ISUP,
                            nil];
                     [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:LastLoginUser_Info];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                 [[HCHCommonManager getInstance] setUserAcountName:loginDic[@"account"]];
                 [self loginHome];
                 [HCHCommonManager getInstance].isLogin = YES;
                 [HCHCommonManager getInstance].isThirdPartLogin = NO;
             }
             else if(code == 9004){
                 [self addActityTextInView:self.view text:NSLocalizedString(@"用户名或密码错误", nil) deleyTime:1.5f];
             }else {
                 [self addActityTextInView:self.view text:NSLocalizedString(@"登录失败", nil)  deleyTime:1.5f];
             }
         }
     }];
}

- (IBAction)loginClick:(UIButton *)sender
{
    [ADASaveDefaluts setObject:@"1" forKey:LOGINTYPE];
    StartUpViewController *loginVC = [StartUpViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
    [self clearDeviceType];
    
}

- (IBAction)registClick:(UIButton *)sender
{
    RgistViewController *rigistVC = [RgistViewController new];
    //    [self setRootViewController:rigistVC animationType:kCATransitionPush];
    [self.navigationController pushViewController:rigistVC animated:YES];
    [self clearDeviceType];
}


- (IBAction)doNotLogin:(id)sender
{
    [ADASaveDefaluts setObject:@"3" forKey:LOGINTYPE];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginCache"];
    if (dic && [dic allKeys].count != 0)
    {
        [super loginHome];
    }
    else
    {
        EditPersonInformationViewController *personVC = [[EditPersonInformationViewController alloc]init];
        personVC.isEdit = YES;
        personVC.EditState = EditPersonStateFirst;
        [self.navigationController pushViewController:personVC animated:YES];
        [self clearDeviceType];
    }
    
    //    [self loginHome];
}
-(void)clearDeviceType
{
    [ADASaveDefaluts remobeObjectForKey:AllDEVICETYPE];
    [ADASaveDefaluts remobeObjectForKey:kLastDeviceUUID];
    if([CositeaBlueTooth sharedInstance].connectUUID)
    {
        [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
