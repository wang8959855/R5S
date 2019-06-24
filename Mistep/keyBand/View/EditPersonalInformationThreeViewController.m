//
//  EditPersonalInformationThreeViewController.m
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "EditPersonalInformationThreeViewController.h"
#import "UserProtocolVC.h"
#import "BMIViewController.h"

@interface EditPersonalInformationThreeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *selectXieYi;


@end

@implementation EditPersonalInformationThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.versionLabel.text = showAppVersion;
    [self setSubViews];
}

- (void)delayMask{
    self.completeButton.layer.mask = [AllTool getCornerRoundWithSelfView:self.completeButton byRoundingCorners:UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];
}

- (void)setSubViews{
    [self performSelector:@selector(delayMask) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)uploadInfoDic {
    if (!_uploadInfoDic) {
        _uploadInfoDic = [NSMutableDictionary dictionary];
    }
    return _uploadInfoDic;
    
}

#pragma mark - 点击事件
//完成
- (IBAction)completeClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self checkUserName:self.rafTel1TF.text]) {
        return;
    }
    if (!self.selectXieYi.selected) {
        [self addActityTextInView:self.view text:@"请先同意协议" deleyTime:1.5f];
        return;
    }
    [self.uploadInfoDic setObject:self.rafTel1TF.text forKey:@"rafTel1"];
    if (self.rafTel2TF.text.length == 11) {
        [self.uploadInfoDic setObject:self.rafTel2TF.text forKey:@"rafTel2"];
    }
    if (self.rafTel3TF.text.length == 11) {
        [self.uploadInfoDic setObject:self.rafTel3TF.text forKey:@"rafTel3"];
    }
    
    //基准高压和基准低压
    NSString *SystolicPressure = [AllTool calcSWithBirthday:self.uploadInfoDic[@"birthday"] sex:self.uploadInfoDic[@"sex"]][0];
    NSString *DiastolicPressure = [AllTool calcSWithBirthday:self.uploadInfoDic[@"birthday"] sex:self.uploadInfoDic[@"sex"]][1];
    [self.uploadInfoDic setObject:SystolicPressure forKey:@"SystolicPressure"];
    [self.uploadInfoDic setObject:DiastolicPressure forKey:@"DiastolicPressure"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOADUSERINFO,TOKEN];
    
    WeakSelf;
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:self.uploadInfoDic Block:^(id responseObject, NSError *error) {
        if (error){
            [weakSelf removeActityIndicatorFromView:weakSelf.view];
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", ni) deleyTime:1.5f];
        }else{
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [[HCHCommonManager getInstance] setUserBirthdateWith:self.uploadInfoDic[@"birthday"]];
                [self getHeartRateWithAge];
                [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"上传成功", nil) deleyTime:1.5f];
                [HCHCommonManager getInstance].isLogin = YES;
                [HCHCommonManager getInstance].isThirdPartLogin = NO;
                [AllTool startUpData];
                
                //设置血压配置参数
                [ADASaveDefaluts setObject:SystolicPressure forKey:BLOODPRESSURELOW];
                [ADASaveDefaluts setObject:DiastolicPressure forKey:BLOODPRESSUREHIGH];
                [[CositeaBlueTooth sharedInstance] setupCorrectNumber];
                
                BMIViewController *bmiVC = [[BMIViewController alloc] init];
                bmiVC.height = [self.uploadInfoDic[@"height"] floatValue];
                bmiVC.weight = [self.uploadInfoDic[@"weight"] floatValue];
                bmiVC.okBlock = ^{
                    [self loginHome];
                };
                [self presentViewController:bmiVC animated:YES completion:nil];
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
            }
        }
    }];
}


//返回
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//协议
- (IBAction)xieyiAction:(UIButton *)sender {
    UserProtocolVC *pro = [[UserProtocolVC alloc] init];
    [self.navigationController pushViewController:pro animated:YES];
}

//选择协议
- (IBAction)selectXieyi:(UIButton *)sender {
    sender.selected = !sender.selected;
}


-(void)dimissAlertController:(UIAlertController *)alert {
    if(alert)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//根据年龄获取心率
- (void)getHeartRateWithAge{
    int maxHeart,maxHeartTwo;
    maxHeart = 220 - [[HCHCommonManager getInstance]getAge];
    maxHeartTwo = maxHeart * 80 /100;
    [[CositeaBlueTooth sharedInstance] setHeartRateAlarmWithState:YES MaxHeartRate:maxHeartTwo MinHeartRate:40];
}

@end
