//
//  DeleteAlertViewController.m
//  Mistep
//
//  Created by 迈诺科技 on 16/3/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "DeleteAlertViewController.h"

@interface DeleteAlertViewController ()

@end

@implementation DeleteAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLabel.text = NSLocalizedString(@"请解除手环与系统之间的配对", nil);
//    _deviceNameLabel.text = [BlueToothManager getInstance].deviceName;
    _stateLabel.text = NSLocalizedString(@"已连接", nil);
    _detailLabel.text = NSLocalizedString(@"系统设置 > 蓝牙 > 点击设备名右侧的 i > 忽略此设备", nil);
    [_dismissBtn setTitle:NSLocalizedString(@"知道了", nil) forState:UIControlStateNormal];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (IBAction)dismissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
