//
//  EditPswViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/12/15.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "EditPswViewController.h"


@interface EditPswViewController ()

@end

@implementation EditPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    
    // Do any additional setup after loading the view from its nib.
    
    [self setButtonWithButton:_confirmBtn andTitle:NSLocalizedString(@"确定", nil)];
}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"修改密码", nil);
    _oldPSWLabel.text = NSLocalizedString(@"旧密码", nil);
    _twicePSWLabel.text = NSLocalizedString(@"新密码", nil);
    _confirmLabel.text = NSLocalizedString(@"确认密码", nil);
    _userNameLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"帐号", nil),[[HCHCommonManager getInstance] UserAcount]];
}

- (IBAction)endEdit:(id)sender
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)completeAction:(id)sender
{
    if ([self checkPassWord:_oldPSW.text])
    {
        if ([self checkPassWord:_twicePSW.text])
        {
            if (![_reSurePSW.text isEqualToString: _twicePSW.text])
            {
                [self showAlertView:NSLocalizedString(@"您两次输入的密码不一致", nil)];
            }
            else{
                if ([_oldPSW.text isEqualToString:_twicePSW.text])
                {
                    [self showAlertView:NSLocalizedString(@"新密码不能和旧密码相同", nil)];
                }
                else
                {
                    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"修改密码...", nil) detailLabel:NSLocalizedString(@"修改密码...", nil)];
                    NSDictionary *loginDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
                    NSDictionary *modifyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[_oldPSW.text md5_32],@"oldPwd",
                                                      [_twicePSW.text md5_32],@"newPwd",
                                                      [_reSurePSW.text md5_32],@"newPwd2", nil] ;
                    
                    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_updatePwd" ParametersDictionary:modifyDictionary Block:^(id responseObject, NSError *error,NSURLSessionTask*task) {
                        if (error) {
                            [self removeActityIndicatorFromView:self.view];
                            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                        }else {
                            //adaLog(@"%@",responseObject[@"msg"]);
                            int code = [[responseObject objectForKey:@"code"] intValue];
                            if (code == 9003) {
                                [self removeActityIndicatorFromView:self.view];
                                [self addActityTextInView:self.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                                
                                NSMutableDictionary *restoreLoginInfo = [NSMutableDictionary dictionaryWithDictionary:loginDictionary];
                                [restoreLoginInfo setValue:[_twicePSW.text md5_32] forKey:@"password"];
                                [[NSUserDefaults standardUserDefaults] setValue:restoreLoginInfo forKey:LastLoginUser_Info];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [self performSelector:@selector(goBackAction:) withObject:nil afterDelay:1.6f];
                            } else if (code == 9001){
                                NSDictionary *loginDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginUser_Info];
                                if (loginDictionary) {
                                    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_login" ParametersDictionary:loginDictionary Block:^(id responseObject, NSError *error,NSURLSessionTask *task) {
                                        if (error) {
                                            [self removeActityIndicatorFromView:self.view];
                                            [self addActityTextInView:self.view text:NSLocalizedString(@"修改失败", nil) deleyTime:1.5f];
                                        }else {
                                            int code = [[responseObject objectForKey:@"code"] intValue];
                                            if(code == 9003) {
                                                
                                                int timeSeconds = [[TimeCallManager getInstance] getSecondsOfCurDay];
                                                NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:timeSeconds];
                                                if (!dic) {
                                                    NSString *macAddress = [AllTool amendMacAddressGetAddress];
                                                    //                                                        NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
                                                    //                                                        if (!macAddress)
                                                    //                                                        {
                                                    //                                                            macAddress = DEFAULTDEVICEID;
                                                    //                                                        }
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
                                                [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_updatePwd" ParametersDictionary:modifyDictionary Block:^(id responseObject, NSError *error,NSURLSessionTask *task) {
                                                    [self removeActityIndicatorFromView:self.view];
                                                    if (error) {
                                                        
                                                        [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
                                                    }else {
                                                        int code = [[responseObject objectForKey:@"code"] intValue];
                                                        if (code == 9003) {
                                                            [self addActityTextInView:self.view text:NSLocalizedString(@"修改成功", nil) deleyTime:1.5f];
                                                            NSMutableDictionary *restoreLoginInfo = [NSMutableDictionary dictionaryWithDictionary:loginDictionary];
                                                            [restoreLoginInfo setValue:[_twicePSW.text md5_32] forKey:@"password"];
                                                            [[NSUserDefaults standardUserDefaults] setValue:restoreLoginInfo forKey:LastLoginUser_Info];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            [self performSelector:@selector(goBackAction:) withObject:nil afterDelay:1.6f];
                                                        }else {
                                                            [self addActityTextInView:self.view text:NSLocalizedString(@"修改密码失败", nil) deleyTime:1.5f];
                                                        }
                                                    }
                                                }];
                                                
                                            }else {
                                                [self removeActityIndicatorFromView:self.view];
                                                [self addActityTextInView:self.view text:(NSLocalizedString(@"修改失败", nil)) deleyTime:1.5f];
                                            }
                                        }
                                    }];
                                }
                            }else {
                                [self removeActityIndicatorFromView:self.view];
                                [self addActityTextInView:self.view text:NSLocalizedString(@"修改密码失败", nil) deleyTime:1.5];
                            }
                        }
                    }];
                    
                }
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
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
