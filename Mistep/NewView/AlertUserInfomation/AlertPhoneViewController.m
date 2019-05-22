//
//  AlertPhoneViewController.m
//  Wukong
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AlertPhoneViewController.h"

@interface AlertPhoneViewController ()
{
    NSInteger _sec;
}
@property (weak, nonatomic) IBOutlet UITextField *oldTelTF;
@property (weak, nonatomic) IBOutlet UITextField *newsTelTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
//倒计时
@property (nonatomic, strong) NSTimer *timer;

//客服
@property (weak, nonatomic) IBOutlet UILabel *kefuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;


@end

@implementation AlertPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
    self.statusHeight.constant = StatusBarHeight;
}

- (void)setSubViews{
    _kefuLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kefuAction)];
    [_kefuLabel addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - 点击事件
//返回
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//联系客服
- (void)kefuAction{
    NSLog(@"客服");
}

//绑定
- (IBAction)bindNewTel:(UIButton *)sender {
    if ([self isTel]) {
        if ([self.verificationTF.text length] != 0) {
            [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在获取验证码", nil) detailLabel:NSLocalizedString(@"正在获取验证码", nil)];
            NSString *url = [NSString stringWithFormat:@"%@/%@",ALERTTEL,TOKEN];
            NSDictionary *parameter = @{@"userId":USERID,@"oldTel":_oldTelTF.text,@"newTel":self.newsTelTF.text,@"code":_verificationTF.text};
            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:parameter Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
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
                         [self addActityTextInView:self.view text:@"换绑手机号成功" deleyTime:1.5f];
                         [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"userId"] forKey:@"userId"];
                         [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
                         [[HCHCommonManager getInstance] setUserTelWith:_newsTelTF.text];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }else{
                         [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
                     }
                 }
             }];
        }
        
    }
}

//获取验证码
- (IBAction)getVerificationCodeAction:(UIButton *)sender {
    if ([self isTel]) {
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在获取验证码", nil) detailLabel:NSLocalizedString(@"正在获取验证码", nil)];
        [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",ALERTTELSEND,TOKEN];
        NSDictionary *parameter = @{@"userId":USERID,@"oldTel":_oldTelTF.text,@"newTel":self.newsTelTF.text};
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:parameter Block:^(id responseObject, NSError *error,NSURLSessionDataTask* task)
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
                     [self.timer fire];
                 }else{
                     [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
                 }
             }
         }];
    }
}

- (BOOL)isTel{
    if ([self.oldTelTF.text length] == 0) {
        [self addActityTextInView:self.view text:@"原手机号不能为空" deleyTime:1.5f];
        return NO;
    }
    if ([self.oldTelTF.text length] != 11) {
        [self addActityTextInView:self.view text:@"原手机号格式不正确" deleyTime:1.5f];
        return NO;
    }
    if (![self.oldTelTF.text isEqualToString:[[HCHCommonManager getInstance] UserTel]]) {
        [self addActityTextInView:self.view text:@"请输入注册时的手机号" deleyTime:1.5f];
        return NO;
    }
    if ([self.newsTelTF.text length] == 0) {
        [self addActityTextInView:self.view text:@"新手机号不能为空" deleyTime:1.5f];
        return NO;
    }
    if ([self.newsTelTF.text length] != 11) {
        [self addActityTextInView:self.view text:@"新手机号格式不正确" deleyTime:1.5f];
        return NO;
    }
    return YES;
}

//倒计时
- (void)countDown{
    _sec--;
    [self.verificationButton setTitle:[NSString stringWithFormat:@"%ld秒",_sec] forState:UIControlStateNormal];
    if (_sec == 0) {
        [self.timer invalidate];
        [self.verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verificationButton.userInteractionEnabled = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
