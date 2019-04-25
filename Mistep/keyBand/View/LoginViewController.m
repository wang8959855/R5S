//
//  LoginViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/27.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "LoginViewController.h"
#import "RgistViewController.h"
#import "FindPSWViewController.h"
#import "UMSocial.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EditPersonInformationViewController.h"
#import "EditPersonalInformationOneViewController.h"
//#import <UMSocialCore/UMSocialCore.h>

@interface LoginViewController ()
{
    BOOL keyBoard;
    NSInteger _sec;
}

//倒计时
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LoginViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    self.navigationController.navigationBar.hidden = YES;
    
    self.versionLabel.text = showAppVersion;
    
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
//    [_loginBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.clipsToBounds = YES;
    
//    [self.nameTF addTarget:self.completionTableView action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.completionTableView.sd_layout.leftEqualToView(self.nameTF)
    .rightEqualToView(self.nameTF)
    .topSpaceToView(self.nameTF,0)
    .leftEqualToView(self.nameTF)
    .heightIs(150);
    self.completionTableView.leftSpace = 10 ;
    
    
}

- (AutocompletionTableView *)completionTableView
{
    if (!_completionTableView)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _completionTableView = [[AutocompletionTableView alloc] initWithTextField:self.nameTF inViewController:self withOptions:options];
        _completionTableView.suggestionsDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameCache"] ;
    }
    return _completionTableView;
}

- (void)setXibLabel
{
    _nameTF.placeholder = NSLocalizedString(@"请输入手机号", nil);
    _passWordTF.placeholder = NSLocalizedString(@"请输入验证码", nil);
    [_registBtn setTitle:NSLocalizedString(@"点击注册", nil) forState:UIControlStateNormal];
    [_findPasswordBtn setTitle:NSLocalizedString(@"忘记密码》", nil) forState:UIControlStateNormal];
    _titleLabel.text = NSLocalizedString(@"登录", nil);
    _thirdPartLabel.text = NSLocalizedString(@"使用第三方登录", nil);
}

- (void)dealloc
{
    
}
- (void)loginTimeOut
{
    [self removeActityIndicatorFromView:self.view];
    [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil)  deleyTime:1.5f];
}
#pragma mark - TF事件

//   点击return按钮
- (IBAction)didEndEdit:(UITextField *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - 按钮事件
//登录
- (IBAction)loginClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([self checkUserName:_nameTF.text])
    {
        if ([self checkPassWord:_passWordTF.text])
        {
            [HCHCommonManager getInstance].userInfoDictionAry = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginCache"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:_nameTF.text,@"tel",_passWordTF.text,@"code", nil];
            [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在登录", nil) detailLabel:NSLocalizedString(@"正在登录", nil)];
            [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
//            adaLog(@"  - - - - -开始登录");
            NSString *url = [NSString stringWithFormat:@"%@/tel/%@/code/%@",LOGIN,_nameTF.text,_passWordTF.text];
            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:nil Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
             {
                 
//                 adaLog(@"  - - - - -开始登录返回");
                 
                 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
                 
                 [self removeActityIndicatorFromView:self.view];
                 if (error)
                 {
                     [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                 }
                 else
                 {
                     int code = [[responseObject objectForKey:@"code"] intValue];
                     NSString *message = [responseObject objectForKey:@"message"];
                     if (code == 0)
                     {
                         [self addActityTextInView:self.view text:NSLocalizedString(@"登录成功", nil) deleyTime:1.5f];
                         [AllTool startUpData];
                         NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                         NSString *name = [tempDic objectForKey:@"userName"] ;
                         NSString *birthday = [tempDic objectForKey:@"birthday"] ;
                         if ((NSNull *)name == [NSNull null]) {
                             [tempDic setValue:nil forKey:@"userName"];
                         }
                         if ((NSNull *)birthday == [NSNull null]) {
                             [tempDic setValue:@"" forKey:@"birthday"];
                         }
                         
//                         [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
                         [[NSUserDefaults standardUserDefaults] setObject:tempDic[@"userId"] forKey:@"userId"];
                         [[NSUserDefaults standardUserDefaults] setObject:tempDic[@"token"] forKey:@"token"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNameCache"];
                         NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:array];
                         bool flag = NO;
                         for (NSString *string in mutArray)
                         {
                             if ([string isEqualToString:_nameTF.text])
                             {
                                 flag = YES;
                             }
                         }
                         if (flag == NO)
                         {
                             [mutArray addObject:_nameTF.text];
                             [[NSUserDefaults standardUserDefaults] setObject:mutArray forKey:@"userNameCache"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                         int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
                         NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
                         if (!dic) {
                             NSString *macAddress = [AllTool amendMacAddressGetAddress];
                             //                             NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
                             //                             if (!macAddress)
                             //                             {
                             //                                 macAddress = DEFAULTDEVICEID;
                             //                             }
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
                         [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kThirdPartLoginKey];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
//                         [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                         [[HCHCommonManager getInstance] setUserAcountName:_nameTF.text];
                         [self loginHome];
                         [HCHCommonManager getInstance].isLogin = YES;
                         [HCHCommonManager getInstance].isThirdPartLogin = NO;
                     }else if (code == 3009){
                         [self addActityTextInView:self.view text:@"请完成个人信息"  deleyTime:1.5f];
                         [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"userid"] forKey:@"userId"];
                         NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:_nameTF.text,@"tel",_passWordTF.text,@"code", nil];
                         [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
                         [[HCHCommonManager getInstance] setUserAcountName:_nameTF.text];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:LastLoginUser_Info];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         EditPersonalInformationOneViewController *editVC = [[UIStoryboard storyboardWithName:@"EditPersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPersonalOne"];
                         editVC.uploadInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:responseObject[@"data"][@"userid"] ,@"userId", nil];
                         [self.navigationController pushViewController:editVC animated:YES];
                     }else {
                         [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
                     }
                 }
             }];
        }
        else
        {
            [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_passWordTF afterDelay:1];
        }
    }
    else
    {
        [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_nameTF afterDelay:1];
    }
}

//获取验证码
- (IBAction)getVerificationCodeClick:(UIButton *)sender {
    if ([self checkUserName:_nameTF.text]){
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在获取验证码", nil) detailLabel:NSLocalizedString(@"正在获取验证码", nil)];
        [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
        
        NSString *url = [NSString stringWithFormat:@"%@/tel/%@",LOGINSEND,_nameTF.text];
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:nil Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
         {
             
             //                 adaLog(@"  - - - - -开始登录返回");
             
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
             
             [self removeActityIndicatorFromView:self.view];
             if (error)
             {
                 [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
             }
             else
             {
                 int code = [[responseObject objectForKey:@"code"] intValue];
                 NSString *message = [responseObject objectForKey:@"message"];
                 if (code == 0) {
                     //成功
                     _sec = 60;
                     sender.userInteractionEnabled = NO;
                     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                     [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                     [self.timer fire];
                 }else{
                     [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
                 }
             }
         }];
    }else{
        [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_nameTF afterDelay:1];
    }
}

//倒计时
- (void)countDown{
    _sec--;
    [self.verificationButton setTitle:[NSString stringWithFormat:@"%ld秒",_sec] forState:UIControlStateNormal];
    if (_sec == 0) {
        [self.timer invalidate];
        [self.verificationButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        self.verificationButton.userInteractionEnabled = YES;
    }
}

#pragma mark - TF获得第一响应
- (void)TFBecomeFirstResponder:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (IBAction)risitClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    RgistViewController *rigistVC = [RgistViewController new];
    [self.navigationController pushViewController:rigistVC animated:YES];
}

- (IBAction)forgetPassWord:(id)sender
{
    FindPSWViewController *fPSWVC = [FindPSWViewController new];
    [self.navigationController pushViewController:fPSWVC animated:YES];
}

- (IBAction)securetyClick:(id)sender
{
    UIButton *butoon = (UIButton *)sender;
    butoon.selected = !butoon.selected;
    if (butoon.selected)
    {
        _eyeImageView.image = [UIImage imageNamed:@"眼睛选中状态"];
    }else
    {
        _eyeImageView.image = [UIImage imageNamed:@"眼睛"];
    }
    _passWordTF.secureTextEntry = !_passWordTF.secureTextEntry;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
