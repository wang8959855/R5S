//
//  RgistViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/28.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "RgistViewController.h"
#import "LoginViewController.h"
#import "EditPersonInformationViewController.h"
#import "EditPersonalInformationOneViewController.h"

@interface RgistViewController ()
{
    BOOL keyBoard;
    NSInteger _sec;
}

//倒计时
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;

@end

@implementation RgistViewController

- (void)dealloc
{
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    self.versionLabel.text = showAppVersion;
    // Do any additional setup after loading the view from its nib.
//    [self setButtonWithButton:_nextBtn andTitle:NSLocalizedString(@"下一步", nil)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    CGFloat top = 0;
    if (ScreenHeight <= 667) {
        top -= 150;
    }else if (ScreenHeight <= 812){
        top -= 100;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.viewTop.constant = top;
    } completion:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    self.viewTop.constant = 0;
}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"注册", nil);
    _userNameTF.placeholder = NSLocalizedString(@"请输入手机号", nil);
    _passWordTF.placeholder = NSLocalizedString(@"请输入验证码", nil);
    _passWordSureTF.placeholder = NSLocalizedString(@"请输入密码", nil);
    _emailTF.placeholder = NSLocalizedString(@"请输入邮箱", nil);
    _kUserNameLabel.text = NSLocalizedString(@"帐号", nil);
    _kPasswordLabel.text = NSLocalizedString(@"密码", nil);
    _kPassworkSureLabel.text = NSLocalizedString(@"确认密码", nil);
    _kEmailLabel.text = NSLocalizedString(@"邮箱", nil);
}

#pragma mark - 按钮点击事件
- (IBAction)gobackClick:(id)sender
{
    [HCHCommonManager getInstance].userInfoDictionAry = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextButton
{
    _nextBtn.userInteractionEnabled = YES;
}
- (IBAction)nextPage:(id)sender
{
    _nextBtn.userInteractionEnabled = NO;
    [self performSelector:@selector(nextButton) withObject:nil afterDelay:2.0f];
    [self.view endEditing:YES];
    if ([self checkUserName:_userNameTF.text])
    {
        if ([self checkPassWord:_passWordTF.text])
        {
        
            NSString *url = [NSString stringWithFormat:@"%@/tel/%@/code/%@",REGISTER,_userNameTF.text,_passWordTF.text];
            
            WeakSelf;
            [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:nil Block:^(id responseObject, NSError *error) {
                
                //adaLog(@"responseObject[msg] - %@",responseObject[@"msg"]);
                //adaLog(@"responseObject - %@",responseObject);
                //adaLog(@"error - %@",error);
                if (error)
                {
                    [weakSelf removeActityIndicatorFromView:weakSelf.view];
                    [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", ni) deleyTime:1.5f];
                }else
                {
                    
                    int code = [[responseObject objectForKey:@"code"] intValue];
                    NSString *message = [responseObject objectForKey:@"message"];
                    if (code == 0)
                    {
                        [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"注册成功", nil) deleyTime:1.5f];
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"id"] forKey:@"userId"];
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
                       [[HCHCommonManager getInstance] setUserAcountName:_userNameTF.text];
                        NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:_userNameTF.text,@"tel",_passWordTF.text,@"code", nil];
                        [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:LastLoginUser_Info];
                       //编辑个人信息
                        EditPersonalInformationOneViewController *editVC = [[UIStoryboard storyboardWithName:@"EditPersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPersonalOne"];
                        editVC.uploadInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:responseObject[@"data"][@"id"] ,@"userId", nil];
                        [self.navigationController pushViewController:editVC animated:YES];
                    }
                    else
                    {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
                        
                        [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_userNameTF afterDelay:1];
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
        [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_userNameTF afterDelay:1];
    }
}

//获取验证码
- (IBAction)getVerificationCodeClick:(UIButton *)sender {
    if ([self checkUserName:_userNameTF.text]){
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在获取验证码", nil) detailLabel:NSLocalizedString(@"正在获取验证码", nil)];
        [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
        
        NSString *url = [NSString stringWithFormat:@"%@/tel/%@",REGISTERSEND,_userNameTF.text];
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
        [self performSelector:@selector(TFBecomeFirstResponder:) withObject:_userNameTF afterDelay:1];
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

- (void)loginTimeOut
{
    [self removeActityIndicatorFromView:self.view];
    [self addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", nil)  deleyTime:1.5f];
}

- (BOOL) checkPassWordTwo
{
    BOOL flag = YES;
    if ([_passWordTF.text isEqualToString:_passWordSureTF.text])
    {
        flag = YES;
    }
    else
    {
        flag = NO;
        [self showAlertView:NSLocalizedString(@"您两次输入的密码不一致", nil) ];
    }
    
    return flag;
}
#pragma mark - TF获得第一响应
- (void)TFBecomeFirstResponder:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (IBAction)didEndEdit:(UITextField *)sender
{
    [self.view endEditing:YES];
}


- (IBAction)TFDidChanged:(UITextField *)sender {
    bool isOK = NO;
    switch (sender.tag)
    {
        case 50:
            isOK = [self isUserName:_userNameTF.text]?YES:NO;
            break;
        case 51:
            isOK = [self isPassWord:_passWordTF.text]?YES:NO;
            break;
        case 52:
            isOK = [self isEmail:_emailTF.text]?YES:NO;
            break;
        default:
            break;
    }
    if (isOK)
    {
        UIImageView *imageView = [self.view viewWithTag:sender.tag+100];
        if ([imageView isKindOfClass:[UIImageView class]])
            imageView.image = [UIImage imageNamed:@"ZC_OK"];
    }else
    {
        UIImageView *imageView = [self.view viewWithTag:sender.tag+100];
        if ([imageView isKindOfClass:[UIImageView class]])
            imageView.image = [UIImage imageNamed:@"ZC_NotOK"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    if (keyBoard)
    {
        return;
    }
    else
    {
        CGPoint center = self.view.center;
        center.y -= 216;
        [UIView animateWithDuration:0.27 animations:^{
            self.view.center = center;
        }];
        keyBoard = YES;
    }
}

- (void)keyBoardWillHiden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CurrentDeviceCenter;
    }];
    keyBoard = NO;
}
-(void)dimissAlertController:(UIAlertController *)alert {
    if(alert)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
