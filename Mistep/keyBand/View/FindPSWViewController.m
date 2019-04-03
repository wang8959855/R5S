//
//  FindPSWViewController.m
//  keyband
//
//  Created by 迈诺科技 on 15/10/28.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import "FindPSWViewController.h"

@interface FindPSWViewController ()

@end

@implementation FindPSWViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];

    // Do any additional setup after loading the view from its nib.
    
    [self setButtonWithButton:_confirmBtn andTitle:NSLocalizedString(@"找回密码", nil)];

}

- (void)setXibLabel
{
    _titleLabel.text = NSLocalizedString(@"找回密码", nil);
    _tipLabel.text = NSLocalizedString(@"请输入帐号:", nil);
}

#pragma mark - 键盘事件
- (void)keyBoardWillShow:(NSNotification *)notification
{
    CGPoint center = self.view.center;
    center.y -= 100;
    [UIView animateWithDuration:0.27 animations:^{
        self.view.center = center;
    }];
}

- (void)keyBoardWillHiden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CurrentDeviceCenter;
    }];
}

- (IBAction)findPswAction:(id)sender
{
    if ([self isUserName:_countTF.text])
    {
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"找回密码", nil) detailLabel:NSLocalizedString(@"找回密码", nil)];
        NSDictionary *findDictionary = @{@"account":_countTF.text};
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"user_findPwd" ParametersDictionary:findDictionary Block:^(id responseObject, NSError *error,NSURLSessionDataTask *task) {
            if (error) {
                [self removeActityIndicatorFromView:self.view];
                [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
            }else {
                int code = [[responseObject objectForKey:@"code"] intValue];
                if (code != 9001) {
                    [self removeActityIndicatorFromView:self.view];
                }
                if(code == 9003) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"找回密码成功", nil) message:NSLocalizedString(@"密码已经发送到帐号关联的邮箱，请查看后重新登录！", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
                    [alertView show];
                }else if(code == 200){
                    [self addActityTextInView:self.view text:NSLocalizedString(@"用户不存在", nil) deleyTime:1.5f];
                }else if(code == 201){
                    [self addActityTextInView:self.view text:NSLocalizedString(@"邮箱无效", nil) deleyTime:1.5f];
                }else {
                    [self addActityTextInView:self.view text:NSLocalizedString(@"找回失败", nil) deleyTime:1.5f];
                }
            }
        }];
    }
}


- (IBAction)gobackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tfClickReturn:(id)sender
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
