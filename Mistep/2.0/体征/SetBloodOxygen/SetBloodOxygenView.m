//
//  SetBloodOxygenView.m
//  Wukong
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "SetBloodOxygenView.h"

@interface SetBloodOxygenView()

@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *lowTF;

@property (weak, nonatomic) IBOutlet UITextField *SPO2TF;

@end

@implementation SetBloodOxygenView

+ (instancetype)bloodOxygenView{
    SetBloodOxygenView *set = [[NSBundle mainBundle] loadNibNamed:@"SetBloodOxygenView" owner:self options:nil].lastObject;
    set.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    set.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:set];
    
//    set.SPO2TF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"setspo2"];
//    set.heightTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"setheight"];
//    set.lowTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"setlow"];
    
    [set getData];
    
    return set;
}

//确定
- (IBAction)okeyAction:(UIButton *)sender {
    
    NSInteger hei = self.heightTF.text.integerValue;
    NSInteger low = self.lowTF.text.integerValue;
    CGFloat xuetang = self.SPO2TF.text.floatValue;
    
    if (self.heightTF.text.length == 0) {
        [self makeBottomToast:kLOCAL(@"请填写基准高压值")];
        return;
    }
    if (self.lowTF.text.length == 0) {
        [self makeBottomToast:kLOCAL(@"请填写基准低压值")];
        return;
    }
    if (self.SPO2TF.text.length == 0) {
        [self makeBottomToast:kLOCAL(@"请填写餐后血糖值")];
        return;
    }
    
    if (hei > 200 || hei < 30) {
        [self makeBottomToast:kLOCAL(@"请输入30-200之间的数值")];
        return;
    }
    
    if (low > 200 || low < 30) {
        [self makeBottomToast:kLOCAL(@"请输入30-200之间的数值")];
        return;
    }
    
    if (xuetang > 35) {
        [self makeBottomToast:kLOCAL(@"餐后血糖值不能大于35")];
        return;
    }
    
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",UPLOADUSERINFO,TOKEN];
    
    NSMutableDictionary *_uploadInfoDic = [NSMutableDictionary dictionary];
    HCHCommonManager *hchc = [HCHCommonManager getInstance];
    [_uploadInfoDic setObject:[hchc userBirthdate] forKey:@"birthday"];
    [_uploadInfoDic setObject:[hchc UserGender] forKey:@"sex"];
    [_uploadInfoDic setObject:[hchc UserAcount] forKey:@"userName"];
    [_uploadInfoDic setObject:[hchc UserAddress] forKey:@"address"];
    [_uploadInfoDic setObject:[hchc UserWeight] forKey:@"weight"];
    [_uploadInfoDic setObject:[hchc UserHeight] forKey:@"height"];
    [_uploadInfoDic setObject:[hchc UserIsHypertension] forKey:@"is_hypertension"];
    [_uploadInfoDic setObject:self.heightTF.text forKey:@"SystolicPressure"];
    [_uploadInfoDic setObject:[hchc UserIsCHD] forKey:@"is_CHD"];
    [_uploadInfoDic setObject:self.lowTF.text forKey:@"DiastolicPressure"];
    [_uploadInfoDic setObject:[hchc UserRafTel1] forKey:@"rafTel1"];
    [_uploadInfoDic setObject:[hchc UserRafTel2] forKey:@"rafTel2"];
    [_uploadInfoDic setObject:[hchc UserRafTel3] forKey:@"rafTel3"];
    [_uploadInfoDic setObject:self.SPO2TF.text forKey:@"Glu"];
    [_uploadInfoDic setObject:[hchc UserIsGlu] forKey:@"is_Glu"];
    [_uploadInfoDic setObject:USERID forKey:@"userId"];
    
    [self makeToastActivity:CSToastPositionCenter];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:_uploadInfoDic Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self hideToastActivity];
        if (error)
        {
            [self makeCenterToast:kLOCAL(@"网络连接错误")];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                if ([message isEqualToString:@"error"]) {
                    [self makeCenterToast:kLOCAL(@"修改失败")];
                    return;
                }else{
                    //设置血压配置参数
                    [ADASaveDefaluts setObject:_uploadInfoDic[@"SystolicPressure"] forKey:BLOODPRESSURELOW];
                    [ADASaveDefaluts setObject:_uploadInfoDic[@"DiastolicPressure"] forKey:BLOODPRESSUREHIGH];
                    [self makeCenterToast:kLOCAL(@"修改成功")];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.heightTF.text forKey:@"setheight"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.lowTF.text forKey:@"setlow"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.SPO2TF.text forKey:@"setspo2"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
                    
                    [self removeFromSuperview];
                    
                }
                
            } else {
                [self makeCenterToast:message];
            }
        }
    }];
    
}

- (void)getData{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",GETHOMEGLU,TOKEN];
    [self makeToastActivity:CSToastPositionCenter];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userId":USERID} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self hideToastActivity];
        if (error)
        {
            [self makeCenterToast:kLOCAL(@"网络连接错误")];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                self.heightTF.text = responseObject[@"data"][@"SystolicPressure"];
                self.lowTF.text = responseObject[@"data"][@"DiastolicPressure"];
                self.SPO2TF.text = responseObject[@"data"][@"Glu"];
                
            } else {
                [self makeCenterToast:message];
            }
        }
    }];
}

//取消
- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}


@end
